#!/usr/bin/env bash
set -euo pipefail

# Captura: copia os arquivos de config do ~/.claude DE VOLTA para home-claude/,
# para versionar mudancas feitas direto na maquina. E o inverso do passo de
# config do install.sh (que instala home-claude/ -> ~/.claude).
#
# So atualiza os arquivos JA rastreados em home-claude/ - nao adiciona novos
# sozinho (pra isso, copie o arquivo pra home-claude/ na mao e rode install.sh).
# Nao commita nada: revise com `git diff` e commite voce.
#
# Origem custom: CLAUDE_HOME=/outro/caminho ./capture.sh

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$REPO_DIR/home-claude"
CONFIG_TARGET="${CLAUDE_HOME:-$HOME/.claude}"

changed=0
missing=0
while IFS= read -r -d '' repo_file; do
  rel="${repo_file#"$CONFIG_SRC"/}"
  live="$CONFIG_TARGET/$rel"

  if [[ ! -f "$live" ]]; then
    echo "AVISO: '$rel' nao existe em $CONFIG_TARGET - pulando." >&2
    missing=$((missing + 1))
    continue
  fi
  if cmp -s "$live" "$repo_file"; then
    continue   # ja identico
  fi
  cp "$live" "$repo_file"
  echo "atualizado no repo: $rel"
  changed=$((changed + 1))
done < <(find "$CONFIG_SRC" -type f -print0 | sort -z)

# Portabilidade: reescreve o home absoluto -> $HOME nos comandos do settings.json,
# pra uma captura nunca reintroduzir path especifico da maquina (ex: /home/USER).
# ponytail: so o settings.json tem esse problema (comandos de hook/statusline).
settings="$CONFIG_SRC/settings.json"
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
  echo "Nada mudou - home-claude/ ja esta igual a $CONFIG_TARGET.$tail"
else
  echo "$changed arquivo(s) atualizado(s) em home-claude/. Revise com 'git diff' e commite.$tail"
fi
