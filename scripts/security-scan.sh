#!/usr/bin/env bash
set -uo pipefail
# Security scan para este repo PUBLICO. Falha (exit 1) se achar, nos arquivos
# rastreados: um segredo provavel, um arquivo sensivel versionado, um path
# absoluto do home (vaza usuario / quebra portabilidade) ou um email em conteudo.
#
# Rodado automaticamente pelo githooks/pre-push antes de todo push (portanto
# antes de qualquer PR e antes de qualquer coisa chegar na main).
# Manual: ./scripts/security-scan.sh   (--history varre tambem todo o log git)
# Emergencia (evite): git push --no-verify

cd "$(git rev-parse --show-toplevel)" || exit 2
SELF=scripts/security-scan.sh
fail=0
report() { printf '  [FALHA] %s\n' "$1"; fail=1; }

# 1) Arquivos sensiveis que nunca podem ser rastreados
FORBIDDEN=$(git ls-files | grep -iE '(^|/)(\.credentials\.json|settings\.local\.json|history\.jsonl|.*\.env|.*\.pem|id_rsa|.*_rsa|\.aws/credentials)$' || true)
[ -n "$FORBIDDEN" ] && report "arquivo sensivel rastreado:"$'\n'"$FORBIDDEN"

# 2) Formatos de segredo de alta confianca (qualquer arquivo, exceto este script)
SECRET_RE='sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{32,}|gh[posru]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}|phc_[A-Za-z0-9]{40,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
HITS=$(git grep -nIE "$SECRET_RE" -- ":!$SELF" || true)
[ -n "$HITS" ] && report "possivel segredo:"$'\n'"$HITS"

# 3) Atribuicao generica de segredo (fora de markdown e deste script)
ASSIGN_RE='(secret|token|passwo?r?d|api[_-]?key|access[_-]?token|client[_-]?secret)["'"'"' ]*[:=]["'"'"' ]*[A-Za-z0-9/+_.-]{16,}'
AHITS=$(git grep -nIE "$ASSIGN_RE" -- ':!*.md' ":!$SELF" || true)
[ -n "$AHITS" ] && report "atribuicao suspeita de segredo:"$'\n'"$AHITS"

# 4) Path absoluto real do home (usuario minusculo) fora de docs -> use $HOME
#    O placeholder /home/USER (maiusculo) e ok e nao casa com [a-z].
HHITS=$(git grep -nIE '/home/[a-z][a-z0-9_-]+' -- ':!*.md' ":!$SELF" ':!githooks/*' || true)
[ -n "$HHITS" ] && report "path absoluto do home (troque por \$HOME):"$'\n'"$HHITS"

# 5) Email em conteudo de arquivo (permite dominios de exemplo/ficticios/noreply)
EHITS=$(git grep -nIE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' -- ':!*.md' ":!$SELF" \
        | grep -viE 'example\.|acme|empresa-ficticia|noreply|@(time|lideranca|stakeholder|empresa)' || true)
[ -n "$EHITS" ] && report "email em conteudo de arquivo:"$'\n'"$EHITS"

# Opcional: historico completo (mais lento; nao roda no pre-push por padrao)
if [ "${1:-}" = "--history" ]; then
  HHIST=$(git log --all -p -- . | grep -nIE "$SECRET_RE" || true)
  [ -n "$HHIST" ] && report "segredo no historico git:"$'\n'"$HHIST"
fi

if [ "$fail" -ne 0 ]; then
  printf '\nSecurity scan: FALHOU. Corrija os itens acima antes de push/PR/merge.\n' >&2
  exit 1
fi
printf 'Security scan: OK (nenhum segredo/PII/arquivo sensivel nos arquivos rastreados).\n'
exit 0
