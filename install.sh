#!/usr/bin/env bash
set -euo pipefail

# Instala (via symlink) todas as skills deste repo em ~/.claude/skills.
# Cada diretorio que contem um SKILL.md vira uma skill, achatada pelo nome do diretorio.
# Destino customizavel: CLAUDE_SKILLS_DIR=/outro/caminho ./install.sh

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$TARGET"

declare -A seen
linked=0
skipped=0

while IFS= read -r -d '' skillmd; do
  dir="$(dirname "$skillmd")"
  name="$(basename "$dir")"

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
echo "Concluido: $linked linkada(s), $skipped pulada(s). Destino: $TARGET"
