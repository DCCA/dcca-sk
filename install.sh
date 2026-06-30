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

if [[ "$invalid" -gt 0 ]]; then
  echo "Corrija o frontmatter das skills invalidas e rode de novo." >&2
  exit 1
fi
