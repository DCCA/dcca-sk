#!/usr/bin/env bash
set -euo pipefail

# Compatibility wrapper: dcca-sk validates authored skills only. Runtime
# restoration, agent configuration, and third-party skills belong to dcca-env.
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERRO: python3 e obrigatorio para validar o export." >&2
  exit 1
fi

python3 "$REPO_DIR/scripts/check-export.py" "$REPO_DIR"

echo "dcca-sk export: skills autorais validadas; nenhum destino externo foi alterado."
echo "Restauracao do ambiente de agentes: use o fluxo bootstrap, preview, apply e check do DCCA/dcca-env."

# The hook path is the only optional mutation and is local to this clone.
if git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$REPO_DIR" config --local core.hooksPath githooks
  echo "Git hooks: core.hooksPath local -> githooks (security scan no pre-push)."
else
  echo "AVISO: este diretorio nao e um clone Git; hook local nao configurado." >&2
fi
