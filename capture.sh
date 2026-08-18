#!/usr/bin/env bash
set -euo pipefail

# Captura somente os arquivos ainda pertencentes ao dcca-sk (shell e VS Code)
# de volta para dotfiles/<tool>/, dirigido por dotfiles/manifest.
#
# Configuracao de agentes, skills de terceiros e estado de runtime pertencem ao
# dcca-env e sao deliberadamente ignorados. Nao commita nada: revise com
# `git diff` e commite voce.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$REPO_DIR/dotfiles/manifest"

OS="linux"; IS_WSL=0
[ "$(uname -s)" = "Darwin" ] && OS="mac"
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }
win_home() {
  local p=""
  if command -v wslpath >/dev/null 2>&1 && command -v cmd.exe >/dev/null 2>&1; then
    p=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')" 2>/dev/null) || true
  fi
  if [[ -n "$p" && -d "$p" ]]; then printf '%s' "$p"; fi
  return 0
}

[[ -f "$MANIFEST" ]] || { echo "manifest ausente: $MANIFEST" >&2; exit 1; }
echo "dcca-env ownership: agent config, third-party skills and runtime state are not captured by dcca-sk."
echo "Capture scope: shell e VS Code only; agent destinations serao pulados."

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
  target="${target/#\~/$HOME}"
  if [[ "$target" == *'$WINHOME'* ]]; then
    wh="$(win_home)"; [[ -z "$wh" ]] && continue
    target="${target//\$WINHOME/$wh}"
  fi
  src="$REPO_DIR/dotfiles/$m_tool"
  [[ -d "$src" ]] || continue
  excl=",$(trim "$m_excl"),"

  while IFS= read -r -d '' repo_file; do
    rel="${repo_file#"$src"/}"; top="${rel%%/*}"
    case "$excl" in *",$rel,"*|*",${rel##*/},"*|*",$top,"*) continue;; esac
    live="$target/$rel"
    if [[ -L "$live" ]]; then
      echo "ERRO: recusando symlink em '$live'; capture aceita somente arquivo regular." >&2
      exit 1
    fi
    if [[ ! -f "$live" ]]; then
      echo "AVISO: '$m_tool/$rel' nao existe em $target - pulando." >&2
      missing=$((missing + 1)); continue
    fi
    tmp="$(mktemp)"
    cp "$live" "$tmp"
    if cmp -s "$tmp" "$repo_file"; then rm -f "$tmp"; continue; fi
    cp "$tmp" "$repo_file"   # cp sobre o arquivo existente preserva o modo (ex: hook executavel)
    rm -f "$tmp"
    echo "atualizado no repo: $m_tool/$rel"
    changed=$((changed + 1))
  done < <(find "$src" -type f -print0 | sort -z)
done < "$MANIFEST"

echo
tail=""
[[ "$missing" -gt 0 ]] && tail=" ($missing arquivo(s) ausente(s) na maquina.)"
if [[ "$changed" -eq 0 ]]; then
  echo "Nada mudou - dotfiles/ ja esta igual aos targets.$tail"
else
  echo "$changed arquivo(s) atualizado(s) em dotfiles/. Revise com 'git diff' e commite.$tail"
fi
