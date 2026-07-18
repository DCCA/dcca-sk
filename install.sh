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

# --- Config portatil (~/.claude) -------------------------------------------
# COPIA cada arquivo de home-claude/ para ~/.claude (arquivos reais, nao symlink).
# O repo e a copia-mestra; o install "instala" essa copia na maquina, que fica
# independente do repo. Um arquivo real ja existente e DIFERENTE e salvo em
# ~/.claude/backups/ antes de ser sobrescrito; se ja for identico, nao faz nada.
# Symlinks de versoes antigas sao removidos. Destino custom: CLAUDE_HOME.
CONFIG_SRC="$REPO_DIR/home-claude"
CONFIG_TARGET="${CLAUDE_HOME:-$HOME/.claude}"
cfg_copied=0
cfg_kept=0

if [[ -d "$CONFIG_SRC" ]]; then
  backup_dir="$CONFIG_TARGET/backups/config-$(date +%Y%m%d-%H%M%S)"
  while IFS= read -r -d '' src; do
    rel="${src#"$CONFIG_SRC"/}"
    dst="$CONFIG_TARGET/$rel"
    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
      rm -f "$dst"                        # remove symlink de versoes antigas
    elif [[ -f "$dst" ]]; then
      if cmp -s "$src" "$dst"; then
        cfg_kept=$((cfg_kept + 1))
        continue                          # ja identico: nao mexe
      fi
      mkdir -p "$(dirname "$backup_dir/$rel")"
      cp "$dst" "$backup_dir/$rel"        # backup do arquivo real antes de sobrescrever
      echo "config backup:     $rel -> ${backup_dir#"$CONFIG_TARGET"/}"
    fi

    cp "$src" "$dst"
    echo "config copiado:    $rel"
    cfg_copied=$((cfg_copied + 1))
  done < <(find "$CONFIG_SRC" -type f -print0 | sort -z)
  echo "Config: $cfg_copied copiado(s), $cfg_kept ja atual(is). Destino: $CONFIG_TARGET"
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
  settings="$CONFIG_TARGET/settings.json"
  [[ -f "$settings" ]] || settings="$REPO_DIR/home-claude/settings.json"
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
