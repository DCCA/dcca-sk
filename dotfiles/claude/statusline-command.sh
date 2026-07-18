#!/bin/sh
# Claude Code status line. Reads JSON on stdin.
# Shows: model | dir | git branch | $/prompt (delta) | $ session total | +/- lines
# Uses python3 (no jq dependency).
exec python3 /dev/fd/3 3<<'PY'
import sys, json, os, subprocess

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

model = g(data, "model", "display_name", default="?")
cwd = g(data, "workspace", "current_dir") or g(data, "cwd") or os.getcwd()
dir_name = os.path.basename(cwd.rstrip("/")) or cwd
session_id = g(data, "session_id", default="nosession")

def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return 0.0

total_cost = num(g(data, "cost", "total_cost_usd", default=0))
lines_added = g(data, "cost", "total_lines_added", default=0) or 0
lines_removed = g(data, "cost", "total_lines_removed", default=0) or 0

# git branch
branch = ""
try:
    r = subprocess.run(
        ["git", "-C", cwd, "--no-optional-locks", "branch", "--show-current"],
        capture_output=True, text=True, timeout=1,
    )
    if r.returncode == 0:
        branch = r.stdout.strip()
except Exception:
    pass

# Per-prompt cost = delta vs last cumulative cost seen for this session.
state_dir = os.path.join(os.path.expanduser("~"), ".claude", "statusline-state")
prev = 0.0
try:
    os.makedirs(state_dir, exist_ok=True)
    sf = os.path.join(state_dir, session_id)
    if os.path.exists(sf):
        prev = num(open(sf).read().strip())
    with open(sf, "w") as f:
        f.write(str(total_cost))
except Exception:
    pass

prompt_cost = max(0.0, total_cost - prev)

C = {"model": "\033[36m", "dir": "\033[34m", "git": "\033[33m",
     "cost": "\033[32m", "add": "\033[32m", "del": "\033[31m"}
R = "\033[0m"
SEP = " \033[2m|\033[0m "

parts = [f"{C['model']}{model}{R}", f"{C['dir']}{dir_name}{R}"]
if branch:
    parts.append(f"{C['git']}{branch}{R}")
parts.append(f"{C['cost']}${prompt_cost:.4f}/prompt{R}")
parts.append(f"{C['cost']}${total_cost:.4f} session{R}")
if lines_added or lines_removed:
    parts.append(f"{C['add']}+{lines_added}{R}/{C['del']}-{lines_removed}{R}")

sys.stdout.write(SEP.join(parts))
PY
