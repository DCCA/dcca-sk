---
name: capturar-config-claude
description: 'Use quando o usuário mexeu direto no ~/.claude (settings.json, statusline, hooks, AGENTS.md/instruções globais) e quer versionar isso no repo dcca-sk. Gatilhos: "capturar minha config", "trouxe/mudei algo no ~/.claude", "sincronizar meu setup do Claude", "sobe minha config pro repo", "atualizar o home-claude". Roda o capture.sh (máquina -> repo), revisa o diff (repo é público - checa que não vazou segredo nem path /home/USER) e sobe via PR. Use mesmo que o usuário não cite "capture.sh" explicitamente.'
---

# Capturar config do Claude (máquina -> repo)

Traz mudanças feitas direto no `~/.claude` de volta para o repo `dcca-sk`, que é a cópia-mestra do setup portátil do Claude Code. É o caminho inverso do `install.sh` (que instala repo -> máquina). O trabalho pesado (copiar + normalizar paths) já está no `capture.sh`; esta skill é o fluxo em volta dele: rodar, revisar com olhar de segurança e shippar.

## Princípio que não pode ser quebrado

O repo é **público**. Nunca deixe um segredo, credencial ou path específico da máquina (`/home/USUARIO`) entrar num commit. Sempre revise o diff antes de subir - o `capture.sh` já re-normaliza paths para `$HOME` no `settings.json`, mas confira, e cheque que nenhum arquivo de segredo (`.credentials.json`, `settings.local.json`) entrou.

## Passos

1. **Ache o repo.** O `capture.sh` fica na raiz do `dcca-sk`. Resolva a raiz a partir do diretório real desta skill (`.../skills/dev/capturar-config-claude` -> sobe 3 níveis), seguindo o symlink se `~/.claude/skills/` apontar pra cá. Confirme que `capture.sh` existe na raiz antes de seguir.

2. **Rode a captura.** Da raiz do repo: `./capture.sh`. Se o usuário indicou outra origem (raro), use `CLAUDE_HOME=/outro/caminho ./capture.sh`. O script copia os arquivos já rastreados em `home-claude/` a partir do `~/.claude`, pula os idênticos e re-normaliza paths do `settings.json`.

3. **Nada mudou?** Se a saída for "Nada mudou", avise que o repo já está igual à máquina e pare - não há o que shippar.

4. **Revise o diff (olhar de segurança).** `git diff home-claude/`. Confira: (a) as mudanças são as que o usuário esperava; (b) nenhum path `/home/<usuario>` sobrou (devem estar como `$HOME`); (c) nada de segredo/token/PII no diff. Se algo suspeito aparecer, pare e mostre ao usuário antes de continuar.

5. **Shippe (convenção do repo: nunca commit direto na `main`).** Branch (`chore/captura-config-<data>`), stage **só** `home-claude/` (deixe mudanças não relacionadas de fora), commit (`chore(config): captura mudanças do ~/.claude`), push, abra PR, e faça merge quando verde. Apague a branch após o merge. Use "-" simples nas mensagens, sem co-author automático.

## Exemplo

Usuário: "mudei o effortLevel e a statusline no meu ~/.claude, sobe isso pro repo".

- `./capture.sh` -> `atualizado no repo: settings.json` / `atualizado no repo: statusline-command.sh`.
- `git diff home-claude/` -> só a linha do `effortLevel` e o script da statusline; paths seguem `$HOME`; sem segredo.
- Branch + commit `chore(config): captura effortLevel + statusline do ~/.claude` + PR + merge.
