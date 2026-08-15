#!/usr/bin/env bash
# stop-gate.sh - Stop/SubagentStop hook: typecheck before the turn ends.
# Exit 2 blocks the stop with stderr feedback; exit 0 allows.
# Managed by hand (not by pi setup) - lives only here.
input=$(cat)

# Parse the event JSON structurally (byte-grep missed `"stop_hook_active": true`
# with a space - Codex review 2026-08-15). Also take the event's cwd so a
# subagent in a worktree is checked where it actually worked.
parsed=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
print("1" if d.get("stop_hook_active") is True else "0")
print(d.get("cwd") or "")
' 2>/dev/null) || parsed="0"
active=${parsed%%$'\n'*}
evcwd=${parsed#*$'\n'}
[ "$active" = "1" ] && exit 0 # never loop: already blocked once this stop

cd "${evcwd:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# fail closed on git errors instead of mistaking them for a clean tree
if ! porcelain=$(git status --porcelain 2>&1); then
  echo "stop-gate: git status failed: $porcelain" >&2
  exit 2
fi
ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0)
# clean tree AND nothing unpushed: nothing this turn could have broken
[ -z "$porcelain" ] && [ "${ahead:-0}" -eq 0 ] && exit 0

# typecheck if the project defines one (root or worker/-style subdir);
# structural check so a dep named "typecheck" can't trigger a ghost script
for dir in . worker; do
  [ -f "$dir/package.json" ] || continue
  has=$(python3 -c 'import json,sys;s=json.load(open(sys.argv[1])).get("scripts",{}).get("typecheck");print(1 if isinstance(s,str) and s else 0)' "$dir/package.json" 2>/dev/null)
  [ "$has" = "1" ] || continue
  if ! out=$(cd "$dir" && npm run -s typecheck 2>&1); then
    {
      echo "Typecheck failing in $dir - fix before finishing:"
      echo "$out" | tail -20
    } >&2
    exit 2
  fi
done

# stray-file visibility: plain stdout on exit 0 goes only to debug logs,
# so emit the documented systemMessage JSON instead
if [ -n "$porcelain" ]; then
  printf '%s\n' "$porcelain" | head -20 | python3 -c 'import json,sys;print(json.dumps({"systemMessage": "stop-gate: working tree has changes:\n" + sys.stdin.read().rstrip()}))'
fi
exit 0
