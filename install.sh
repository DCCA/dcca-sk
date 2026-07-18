#!/usr/bin/env bash
set -euo pipefail

# Instala (via symlink) todas as skills deste repo em ~/.claude/skills.
# Cada diretorio que contem um SKILL.md vira uma skill, achatada pelo nome do diretorio.
# Antes de linkar, VALIDA o frontmatter YAML de cada skill (name + description parseaveis):
# uma skill com frontmatter quebrado nao e instalada, e o script sai com codigo != 0.
# Destino customizavel: CLAUDE_SKILLS_DIR=/outro/caminho ./install.sh

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

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

mkdir -p "$TARGET"

# Valida o frontmatter de um SKILL.md. Escreve o motivo no stdout; retorna 0 (ok) ou 1 (invalido).
# Usa PyYAML quando disponivel (pega erros reais de YAML, ex: ': ' em valor sem aspas);
# sem PyYAML, cai para uma checagem basica (name/description presentes) e avisa.
validate_frontmatter() {
  python3 - "$1" <<'PY'
import sys, re
t = open(sys.argv[1], encoding='utf-8').read()
if not t.startswith('---'):
    print("frontmatter nao comeca na 1a linha (---)"); sys.exit(1)
m = re.match(r'^---\s*\n(.*?)\n---', t, re.S)
if not m:
    print("frontmatter mal delimitado (--- ... ---)"); sys.exit(1)
fm = m.group(1)
try:
    import yaml
except ImportError:
    if not (re.search(r'^name:', fm, re.M) and re.search(r'^description:', fm, re.M)):
        print("falta name ou description"); sys.exit(1)
    print("ok (sem PyYAML: validacao basica)"); sys.exit(0)
try:
    d = yaml.safe_load(fm)
except Exception as e:
    print("YAML invalido: " + str(e).splitlines()[0]); sys.exit(1)
if not isinstance(d, dict) or 'name' not in d or 'description' not in d:
    print("falta name ou description"); sys.exit(1)
sys.exit(0)
PY
}

have_python=1
command -v python3 >/dev/null 2>&1 || have_python=0
[[ "$have_python" -eq 0 ]] && echo "AVISO: python3 ausente - validacao de YAML desativada." >&2

declare -A seen
linked=0
skipped=0
invalid=0

while IFS= read -r -d '' skillmd; do
  dir="$(dirname "$skillmd")"
  name="$(basename "$dir")"

  # Valida o frontmatter antes de linkar.
  if [[ "$have_python" -eq 1 ]]; then
    if ! reason="$(validate_frontmatter "$skillmd")"; then
      echo "INVALIDO: $name - $reason" >&2
      echo "          ($skillmd)" >&2
      invalid=$((invalid + 1))
      continue
    fi
  fi

  if [[ -n "${seen[$name]:-}" ]]; then
    echo "AVISO: nome duplicado '$name' (${seen[$name]} e $dir). Pulando o segundo." >&2
    skipped=$((skipped + 1))
    continue
  fi
  seen[$name]="$dir"

  link="$TARGET/$name"
  if [[ -L "$link" ]]; then
    ln -sfn "$dir" "$link"
    echo "atualizado: $name"
  elif [[ -e "$link" ]]; then
    echo "AVISO: '$link' ja existe e NAO e symlink (skill propria?). Pulando." >&2
    skipped=$((skipped + 1))
    continue
  else
    ln -s "$dir" "$link"
    echo "linkado:    $name -> $dir"
  fi
  linked=$((linked + 1))
done < <(find "$SKILLS_SRC" -name SKILL.md -print0 | sort -z)

echo
echo "Concluido: $linked linkada(s), $skipped pulada(s), $invalid invalida(s). Destino: $TARGET"

# --- Config portatil (dotfiles/ dirigido por manifest) ---------------------
# Para cada tool no dotfiles/manifest: COPIA dotfiles/<tool>/ -> target do tool
# (coluna por OS), pulando os excludes (segredo/estado local). Arquivo real ja
# existente e DIFERENTE vai pra backups/ antes de sobrescrever; identico nao mexe;
# symlink de versao antiga e removido. CLAUDE_HOME sobrescreve o target do 'claude'.
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
    if [[ "$m_tool" == "claude" && -n "${CLAUDE_HOME:-}" ]]; then target="$CLAUDE_HOME"; fi
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

# --- Git hooks deste repo ---------------------------------------------------
# Arma o security scan no pre-push (repo publico: nada de segredo/PII no push).
# core.hooksPath e config local do clone, entao precisa ser setado por clone.
if git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  chmod +x "$REPO_DIR/githooks/pre-push" "$REPO_DIR/scripts/security-scan.sh" 2>/dev/null || true
  git -C "$REPO_DIR" config core.hooksPath githooks
  echo "Git hooks: core.hooksPath -> githooks (security scan no pre-push)."
fi

# --- Skills/ferramentas referenciadas (registry) ---------------------------
# Instala o que esta em skills/registry (ponteiros, nao versionado aqui):
# plugin (verifica enabledPlugins), git (clona em ~/.claude/skills), npx
# (`npx skills add`), npm (`npm install -g`). Falha de item avisa e segue.
REGISTRY="$REPO_DIR/skills/registry"
if [[ -f "$REGISTRY" ]]; then
  echo
  settings="${CLAUDE_HOME:-$HOME/.claude}/settings.json"
  [[ -f "$settings" ]] || settings="$REPO_DIR/dotfiles/claude/settings.json"
  r_git=0; r_npx=0; r_npm=0; r_plugin=0; r_warn=0
  reg_warn() { echo "AVISO: $1" >&2; r_warn=$((r_warn + 1)); }
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"                          # tira comentario
    line="${line#"${line%%[![:space:]]*}"}"     # ltrim
    line="${line%"${line##*[![:space:]]}"}"     # rtrim
    [[ -z "$line" ]] && continue
    read -r rtype ra rb <<< "$line"
    case "$rtype" in
      plugin)
        r_plugin=$((r_plugin + 1))
        if grep -Eq "\"${ra}(@[^\"]*)?\"[[:space:]]*:[[:space:]]*true" "$settings" 2>/dev/null; then
          echo "registry plugin:   $ra (enabled)"
        else
          reg_warn "plugin '$ra' nao esta em enabledPlugins ($settings)"
        fi ;;
      git)
        r_git=$((r_git + 1))
        dest="$TARGET/$ra"
        if [[ -z "$ra" || -z "$rb" ]]; then reg_warn "git sem nome/URL: '$line'"
        elif ! command -v git >/dev/null 2>&1; then reg_warn "git ausente - pulando '$ra'"
        elif [[ -d "$dest/.git" ]]; then
          if git -C "$dest" pull --ff-only >/dev/null 2>&1; then echo "registry git:      $ra (pull)"; else reg_warn "pull falhou em '$ra'"; fi
        elif [[ -e "$dest" ]]; then reg_warn "'$dest' ja existe e nao e clone git - pulando '$ra'"
        elif git clone --depth 1 "$rb" "$dest" >/dev/null 2>&1; then echo "registry git:      $ra (clone)"
        else reg_warn "clone falhou em '$ra' ($rb)"; fi ;;
      npx)
        r_npx=$((r_npx + 1))
        # roda a partir do $HOME: o skills CLI instala no ".agents/skills" do
        # cwd, entao rodar aqui poluiria o repo - do $HOME vai pro global.
        if ! command -v npx >/dev/null 2>&1; then reg_warn "npx ausente - pulando '$ra'"
        elif ( cd "$HOME" && npx -y skills add "$ra" ) >/dev/null 2>&1; then echo "registry npx:      $ra"
        else reg_warn "'npx skills add $ra' falhou"; fi ;;
      npm)
        r_npm=$((r_npm + 1))
        if ! command -v npm >/dev/null 2>&1; then reg_warn "npm ausente - pulando '$ra'"
        elif npm install -g "$ra" >/dev/null 2>&1; then echo "registry npm:      $ra"
        else reg_warn "'npm install -g $ra' falhou"; fi ;;
      *) reg_warn "tipo de registry desconhecido '$rtype' (linha: $line)" ;;
    esac
  done < "$REGISTRY"
  echo "Registry: $r_git git, $r_npx npx, $r_npm npm, $r_plugin plugin (avisos: $r_warn). Skills em: $TARGET"
fi

if [[ "$invalid" -gt 0 ]]; then
  echo "Corrija o frontmatter das skills invalidas e rode de novo." >&2
  exit 1
fi
