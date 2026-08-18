#!/usr/bin/env bash
set -euo pipefail

# Valida as skills autorais explicitamente aprovadas em skills/export-manifest.json.
# A instalacao de runtime, links de skills e configuracao de agentes pertencem ao
# dcca-env; este script nao escreve em ~/.claude nem ~/.codex.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# OS (para escolher o target por-OS no manifest de config, dotfiles/manifest)
OS="linux"; IS_WSL=0
[ "$(uname -s)" = "Darwin" ] && OS="mac"
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1

# Home do Windows (WSL) para os targets '$WINHOME' do manifest (ex: VS Code).
win_home() {
  local p=""
  if command -v wslpath >/dev/null 2>&1 && command -v cmd.exe >/dev/null 2>&1; then
    p=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')" 2>/dev/null) || true
  fi
  if [[ -n "$p" && -d "$p" ]]; then printf '%s' "$p"; fi
  return 0
}

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERRO: python3 e obrigatorio para validar o export antes de qualquer instalacao." >&2
  exit 1
fi
python3 "$REPO_DIR/scripts/check-export.py" "$REPO_DIR"

echo "dcca-env ownership: configuracao de agentes, skills de terceiros e links de runtime nao sao instalados por dcca-sk."
echo "dcca-sk export: somente skills autorais listadas em skills/export-manifest.json sao validadas."
echo "Agentes: ~/.claude e ~/.codex pulados; use dcca-env para bootstrap, preview, apply e check."

# --- Config portatil (dotfiles/ dirigido por manifest) ---------------------
# Para cada tool no dotfiles/manifest: COPIA dotfiles/<tool>/ -> target do tool
# (coluna por OS), pulando os excludes (segredo/estado local). Arquivo real ja
# existente e DIFERENTE vai pra backups/ antes de sobrescrever; identico nao mexe;
# symlink de versao antiga e removido.
cfg_trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }
MANIFEST="$REPO_DIR/dotfiles/manifest"
cfg_copied=0
cfg_kept=0
if [[ -f "$MANIFEST" ]]; then
  while IFS='|' read -r m_tool m_lin m_mac m_wsl m_excl m_mode; do
    m_tool="$(cfg_trim "$m_tool")"
    [[ -z "$m_tool" || "$m_tool" == \#* ]] && continue
    if [[ "$OS" == "mac" ]]; then target="$(cfg_trim "$m_mac")"
    elif [[ "$IS_WSL" == 1 ]]; then target="$(cfg_trim "$m_wsl")"
    else target="$(cfg_trim "$m_lin")"; fi
    [[ "$target" == "-" || -z "$target" ]] && { echo "config: $m_tool pulado neste OS"; continue; }
    target="${target/#\~/$HOME}"
    if [[ "$target" == *'$WINHOME'* ]]; then
      wh="$(win_home)"
      [[ -z "$wh" ]] && { echo "AVISO: $m_tool: home do Windows nao encontrado - pulando" >&2; continue; }
      target="${target//\$WINHOME/$wh}"
    fi
    src="$REPO_DIR/dotfiles/$m_tool"
    [[ -d "$src" ]] || { echo "AVISO: dotfiles/$m_tool ausente - pulando" >&2; continue; }
    excl=",$(cfg_trim "$m_excl"),"
    mode="$(cfg_trim "$m_mode")"
    backup_dir="$target/backups/config-$(date +%Y%m%d-%H%M%S)"
    while IFS= read -r -d '' src_f; do
      rel="${src_f#"$src"/}"; top="${rel%%/*}"
      case "$excl" in *",$rel,"*|*",${rel##*/},"*|*",$top,"*) continue;; esac
      dst="$target/$rel"
      if [[ "$mode" == "seed" && -e "$dst" ]]; then
        echo "config seed:       $m_tool/$rel (ja existe - preservado)"
        cfg_kept=$((cfg_kept + 1)); continue
      fi
      mkdir -p "$(dirname "$dst")"
      if [[ -L "$dst" ]]; then rm -f "$dst"
      elif [[ -f "$dst" ]]; then
        if cmp -s "$src_f" "$dst"; then cfg_kept=$((cfg_kept + 1)); continue; fi
        mkdir -p "$(dirname "$backup_dir/$rel")"
        cp "$dst" "$backup_dir/$rel"
        echo "config backup:     $m_tool/$rel"
      fi
      cp "$src_f" "$dst"
      echo "config copiado:    $m_tool/$rel"
      cfg_copied=$((cfg_copied + 1))
    done < <(find "$src" -type f -print0 | sort -z)
  done < "$MANIFEST"
  echo "Config: $cfg_copied copiado(s), $cfg_kept ja atual(is)."
fi

# --- VS Code extensions (dotfiles/vscode/extensions.txt) --------------------
# Extensoes nao sao arquivo de config: instala cada ID via `code --install-extension`
# (idempotente com --force). Sem o `code` na PATH, avisa e segue.
VSCODE_EXT="$REPO_DIR/dotfiles/vscode/extensions.txt"
if [[ -f "$VSCODE_EXT" ]]; then
  echo
  if command -v code >/dev/null 2>&1; then
    ext_n=0; ext_w=0
    while IFS= read -r ext || [[ -n "$ext" ]]; do
      ext="$(cfg_trim "${ext%%#*}")"; [[ -z "$ext" ]] && continue
      if code --install-extension "$ext" --force >/dev/null 2>&1; then ext_n=$((ext_n + 1))
      else echo "AVISO: falha instalando extensao '$ext'" >&2; ext_w=$((ext_w + 1)); fi
    done < "$VSCODE_EXT"
    echo "VS Code: $ext_n extensao(oes) instalada(s)$([ "$ext_w" -gt 0 ] && echo ", $ext_w falha(s)")."
  else
    echo "AVISO: 'code' ausente - pulando extensoes do VS Code" >&2
  fi
fi

# --- Shell glue de IA: sourceia ai.sh no rc --------------------------------
# O passo de config (manifest) ja copiou dotfiles/shell/ -> ~/.config/dcca-sk/.
# Aqui so garante um bloco guardado no rc que sourceia o ai.sh - separado do
# bloco do ade-stack (terminal). Idempotente (nao duplica).
AI_GLUE="$HOME/.config/dcca-sk/ai.sh"
if [[ -f "$AI_GLUE" ]]; then
  rc="$HOME/.bashrc"; case "${SHELL:-}" in *zsh) rc="$HOME/.zshrc";; esac
  marker="# >>> dcca-sk ai glue >>>"
  if [[ -f "$rc" ]] && grep -qF "$marker" "$rc"; then
    echo "Shell glue: bloco ja presente em $rc (ai.sh atualizado pelo manifest)"
  else
    { printf '\n%s\n' "$marker"
      printf '%s\n' '[ -f "$HOME/.config/dcca-sk/ai.sh" ] && . "$HOME/.config/dcca-sk/ai.sh"'
      printf '%s\n' "# <<< dcca-sk ai glue <<<"
    } >> "$rc"
    echo "Shell glue: bloco adicionado em $rc (sourceia ~/.config/dcca-sk/ai.sh)"
  fi
fi

# --- Git hooks deste repo ---------------------------------------------------
# Arma o security scan no pre-push (repo publico: nada de segredo/PII no push).
# core.hooksPath e config local do clone, entao precisa ser setado por clone.
if git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  chmod +x "$REPO_DIR/githooks/pre-push" "$REPO_DIR/scripts/security-scan.sh" 2>/dev/null || true
  git -C "$REPO_DIR" config core.hooksPath githooks
  echo "Git hooks: core.hooksPath -> githooks (security scan no pre-push)."
fi

echo "Terceiros: registry/provisioning aposentado neste repo; dcca-env instala versoes fixadas."
