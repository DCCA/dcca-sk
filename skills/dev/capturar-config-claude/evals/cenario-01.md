# Cenário 01 - Capturar mudança do ~/.claude no repo

Skill de tooling do próprio repo (não puxa da Acme - não é entregável de PM). O cenário testa o **comportamento**: dado que o usuário mexeu no `~/.claude`, a skill traz a mudança pro repo com segurança e a shippa.

## Mundo (teste)

- Repo `dcca-sk` já com `dotfiles/claude/` e `capture.sh` na raiz.
- O usuário mudou, direto na máquina, dois arquivos rastreados:
  - `~/.claude/settings.json`: trocou `effortLevel` de `xhigh` para `high` **e** (simulando um tool que reescreveu) deixou o comando da statusline com path absoluto `/home/<usuario>/.claude/statusline-command.sh`.
  - `~/.claude/statusline-command.sh`: um ajuste qualquer no script.
- `~/.claude/.credentials.json` existe na máquina (segredo) mas **não** é rastreado.

## Pedido do usuário

"Mudei umas coisas direto no meu ~/.claude, sobe isso pro repo."

## Esperado

A skill roda o `capture.sh`, revisa o diff com olhar de segurança (paths voltaram a `$HOME`, nenhum segredo entrou), e shippa via branch + PR (nunca commit direto na `main`), com só `dotfiles/claude/` no commit.
