#!/bin/sh
# Claude Code status line (two lines). Reads JSON on stdin.
#   L1: model ·effort | dir | git branch (ahead/behind, dirty) | session $ (+delta) | +/- lines
#   L2: context gauge | 5h limit gauge → reset | weekly limit gauge → reset
# Gauge labels/percentages are fixed-width so the meters share one visual rhythm.
# stdin schema: https://code.claude.com/docs/en/statusline
# python3 only (no jq dependency). Bars auto-hide on narrow terminals.
exec python3 /dev/fd/3 3<<'PY'
import sys, json, os, subprocess, time
from datetime import datetime

try:
    data = json.load(sys.stdin)
except Exception:
    print("statusline: bad JSON input")
    sys.exit(0)

def g(d, *path, default=None):
    for k in path:
        d = d.get(k) if isinstance(d, dict) else None
        if d is None:
            return default
    return d

def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return 0.0

R = "\033[0m"; DIM = "\033[2m"
GREEN = "\033[32m"; YELLOW = "\033[33m"; RED = "\033[31m"
CYAN = "\033[36m"; BLUE = "\033[34m"
SEP = f"  {DIM}│{R}  "

try:
    cols = int(os.environ.get("COLUMNS") or 0)
except ValueError:
    cols = 0
wide = cols == 0 or cols >= 100  # drop the mini bars when the terminal is narrow

def sev(pct, warn, crit):
    return RED if pct >= crit else YELLOW if pct >= warn else GREEN

def bar(pct, width=5):
    filled = max(0, min(width, round(pct / 100 * width)))
    return "▰" * filled + "▱" * (width - filled)

def gauge(icon, label, pct, warn, crit, suffix=""):
    c = sev(pct, warn, crit)
    b = f" {bar(pct)}" if wide else ""
    return f"{icon} {DIM}{label:<3}{R}{c}{pct:4.0f}%{b}{R}{suffix}"

def fmt_reset(ts):
    try:
        ts = int(ts)
        dt = datetime.fromtimestamp(ts)
    except Exception:
        return ""
    txt = dt.strftime("%H:%M") if ts - time.time() < 23 * 3600 else dt.strftime("%a")
    return f" {DIM}→{txt}{R}"

# ---- L1: model · effort | dir | git ----
model = g(data, "model", "display_name", default="?")
effort = g(data, "effort", "level")
seg_model = f"{CYAN}{model}{R}"
if effort and effort != "high":
    seg_model += f" {DIM}·{effort}{R}"
if data.get("fast_mode"):
    seg_model += f" {DIM}·fast{R}"

cwd = g(data, "workspace", "current_dir") or data.get("cwd") or os.getcwd()
line1 = [seg_model, f"{BLUE}{os.path.basename(cwd.rstrip('/')) or cwd}{R}"]

# One git call gives branch, ahead/behind and dirty state.
try:
    r = subprocess.run(
        ["git", "-C", cwd, "--no-optional-locks", "status",
         "--porcelain=v2", "--branch", "-uno"],
        capture_output=True, text=True, timeout=1,
    )
    if r.returncode == 0:
        branch, ahead, behind, dirty = "", 0, 0, False
        for ln in r.stdout.splitlines():
            if ln.startswith("# branch.head"):
                branch = ln.split(" ", 2)[2]
            elif ln.startswith("# branch.ab"):
                _, _, a, b = ln.split(" ")
                ahead, behind = int(a), -int(b)
            elif not ln.startswith("#"):
                dirty = True
        if branch:
            seg = f"{YELLOW}🌿{branch}"
            if dirty:
                seg += "*"
            seg += R
            if ahead:
                seg += f"{DIM}↑{ahead}{R}"
            if behind:
                seg += f"{DIM}↓{behind}{R}"
            line1.append(seg)
except Exception:
    pass

# ---- L1 (cont.): session cost (+ per-prompt delta) | +/- lines ----
total_cost = num(g(data, "cost", "total_cost_usd", default=0))
session_id = g(data, "session_id", default="nosession")

# Per-prompt cost = delta vs last cumulative cost seen for this session.
state_dir = os.path.join(os.path.expanduser("~"), ".claude", "statusline-state")
prev = 0.0
try:
    os.makedirs(state_dir, exist_ok=True)
    now = time.time()
    for f in os.listdir(state_dir):  # prune stale session files
        p = os.path.join(state_dir, f)
        try:
            if now - os.path.getmtime(p) > 7 * 86400:
                os.unlink(p)
        except OSError:
            pass
    sf = os.path.join(state_dir, session_id)
    if os.path.exists(sf):
        prev = num(open(sf).read().strip())
    with open(sf, "w") as f:
        f.write(str(total_cost))
except Exception:
    pass
prompt_cost = max(0.0, total_cost - prev)

line1.append(f"💰 {GREEN}${total_cost:.2f}{R} {DIM}(+${prompt_cost:.2f}){R}")

added = int(num(g(data, "cost", "total_lines_added", default=0)))
removed = int(num(g(data, "cost", "total_lines_removed", default=0)))
if added or removed:
    line1.append(f"{GREEN}+{added}{R}{DIM}/{R}{RED}-{removed}{R}")

# ---- L2: the meters — context | 5h limit | weekly limit ----
line2 = []
ctx = g(data, "context_window", "used_percentage")
if ctx is not None:
    warn = f" {RED}⚠{R}" if num(ctx) >= 85 else ""
    line2.append(gauge("🧠", "ctx", num(ctx), 60, 85, warn))
for icon, label, key in (("⏳", "5h", "five_hour"), ("📅", "wk", "seven_day")):
    pct = g(data, "rate_limits", key, "used_percentage")
    if pct is not None:
        line2.append(gauge(icon, label, num(pct), 50, 80,
                           fmt_reset(g(data, "rate_limits", key, "resets_at"))))

out = [SEP.join(line) for line in (line1, line2) if line]
print("\n".join(out))
PY
