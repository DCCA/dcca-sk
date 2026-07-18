#!/usr/bin/env bash
set -euo pipefail

# Captura: copia a config viva de cada tool DE VOLTA para dotfiles/<tool>/,
# dirigido por dotfiles/manifest. E o inverso do passo de config do install.sh.
#
# So atualiza os arquivos JA rastreados em dotfiles/<tool>/ - nao adiciona novos
# sozinho (pra isso, copie o arquivo pra dotfiles/<tool>/ na mao e rode install.sh).
# Pula os excludes do manifest (segredo/estado local). Nao commita nada: revise
# com `git diff` e commite voce.
#
# Origem custom do claude: CLAUDE_HOME=/outro/caminho ./capture.sh

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$REPO_DIR/dotfiles/manifest"

OS="linux"; IS_WSL=0
[ "$(uname -s)" = "Darwin" ] && OS="mac"
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

[[ -f "$MANIFEST" ]] || { echo "manifest ausente: $MANIFEST" >&2; exit 1; }

changed=0
missing=0
while IFS='|' read -r m_tool m_lin m_mac m_wsl m_excl m_mode; do
  m_tool="$(trim "$m_tool")"
  [[ -z "$m_tool" || "$m_tool" == \#* ]] && continue
  [[ "$(trim "$m_mode")" == "seed" ]] && continue   # seed: config local, nao captura
  if [[ "$OS" == "mac" ]]; then target="$(trim "$m_mac")"
  elif [[ "$IS_WSL" == 1 ]]; then target="$(trim "$m_wsl")"
  else target="$(trim "$m_lin")"; fi
  [[ "$target" == "-" || -z "$target" ]] && continue
  if [[ "$m_tool" == "claude" && -n "${CLAUDE_HOME:-}" ]]; then target="$CLAUDE_HOME"; fi
  target="${target/#\~/$HOME}"
  src="$REPO_DIR/dotfiles/$m_tool"
  [[ -d "$src" ]] || continue
  excl=",$(trim "$m_excl"),"

  while IFS= read -r -d '' repo_file; do
    rel="${repo_file#"$src"/}"; top="${rel%%/*}"
    case "$excl" in *",$rel,"*|*",${rel##*/},"*|*",$top,"*) continue;; esac
    live="$target/$rel"
    if [[ ! -f "$live" ]]; then
      echo "AVISO: '$m_tool/$rel' nao existe em $target - pulando." >&2
      missing=$((missing + 1)); continue
    fi
    cmp -s "$live" "$repo_file" && continue   # ja identico
    cp "$live" "$repo_file"
    echo "atualizado no repo: $m_tool/$rel"
    changed=$((changed + 1))
  done < <(find "$src" -type f -print0 | sort -z)
done < "$MANIFEST"

# Portabilidade (claude-especifico): reescreve o home absoluto -> $HOME nos
# comandos do settings.json, pra uma captura nunca reintroduzir path da maquina
# (ex: /home/USER). So o settings.json do claude tem esse problema.
settings="$REPO_DIR/dotfiles/claude/settings.json"
if [[ -f "$settings" ]] && command -v python3 >/dev/null 2>&1; then
  python3 - "$settings" "$HOME" <<'PY'
import json, sys
path, home = sys.argv[1], sys.argv[2]
d = json.load(open(path, encoding="utf-8"))
def fix(s): return s.replace(home + "/.claude", "$HOME/.claude")
sl = d.get("statusLine", {})
if isinstance(sl, dict) and "command" in sl:
    sl["command"] = fix(sl["command"])
for grp in d.get("hooks", {}).values():
    for entry in grp:
        for h in entry.get("hooks", []):
            if "command" in h:
                h["command"] = fix(h["command"])
json.dump(d, open(path, "w", encoding="utf-8"), indent=2)
open(path, "a", encoding="utf-8").write("\n")
PY
fi

echo
tail=""
[[ "$missing" -gt 0 ]] && tail=" ($missing arquivo(s) ausente(s) na maquina.)"
if [[ "$changed" -eq 0 ]]; then
  echo "Nada mudou - dotfiles/ ja esta igual aos targets.$tail"
else
  echo "$changed arquivo(s) atualizado(s) em dotfiles/. Revise com 'git diff' e commite.$tail"
fi
