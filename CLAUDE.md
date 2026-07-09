# dcca-sk - Skills profissionais do Daniel

Repositorio das minhas agent skills (Claude Code). Objetivo: **criar, melhorar e organizar** as skills que uso no trabalho. Sou PM; trabalho em portugues.

## Princípio: agnóstico a empresa

Este repo **nao guarda configuracao final**. As skills sao montadas, otimizadas e melhoradas aqui de forma generica; tudo que e especifico de uma empresa (nomes, canais, metricas, produtos, handles) fica como **placeholder de config** dentro da propria skill. A configuracao real e preenchida no destino, quando eu importo a skill para o trabalho. Assim as skills sao portateis: se eu trocar de emprego, levo todas comigo. Nunca commitar dados reais de uma empresa neste repo.

## O que e uma skill aqui

Cada skill e um diretorio `skills/<categoria>/<nome-kebab>/SKILL.md`. O `SKILL.md` tem frontmatter (`name`, `description`) + o corpo com o procedimento. Recursos extras (scripts, referencias) ficam no mesmo diretorio da skill.

Categorias:

- `dev/` - engenharia de software (workflows de codigo, revisao, deploy, debugging na minha stack: Next.js, Supabase, Vercel).
- `produto/` - produto, dados e growth (rotinas de PM, analytics/PostHog, metricas, experimentos).
- `escrita/` - escrita e comunicacao (documentos, propostas, comunicacao com time e clientes).

## Criar ou melhorar uma skill

Use **sempre** o skill `superpowers:writing-skills` (versao com verificacao/evals). Nao escreva ou edite `SKILL.md` no improviso.

Convencoes:

- `name` em kebab-case, igual ao nome do diretorio.
- `description` em terceira pessoa, focada em QUANDO usar, com gatilhos concretos. E o campo que faz o Claude escolher a skill - capriche. Coloque entre **aspas simples** no YAML: ela costuma conter `:` e aspas, que quebram o frontmatter se ficar sem aspas. O frontmatter (`---`) e a primeira coisa do arquivo, sempre.
- Uma skill = um proposito. Se esta fazendo coisas demais, quebre em duas.
- Idioma: portugues (como as minhas skills), salvo se a skill for para compartilhar publicamente.
- **Nunca** preencher config com dados reais de uma empresa - deixe placeholders entre colchetes (ver `daily-review`).
- Comece a partir de `templates/SKILL.md`.

## Evals (testar a skill)

Toda skill nasce com **≥1 cenário + rubrica** em `skills/<categoria>/<skill>/evals/`, puxando da empresa fictícia `evals/empresa-ficticia/acme.md`. Para entender e rodar (aplicador + avaliador via subagentes), ver `evals/README.md`. Teste com conectores reais (nível 2) em `evals/sandbox-nivel-2.md`. Sem eval, a skill não está pronta - casa com a preferência de usar a versão com evals.

## Instalar / atualizar

`./install.sh` faz tres coisas (idempotente): (1) **symlinka** cada `skills/**/SKILL.md` em `~/.claude/skills/<nome>` - editar a skill no repo reflete direto na proxima sessao, sem reinstalar; (2) **copia** `home-claude/*` para `~/.claude/*` (AGENTS.md, settings.json, statusline, hooks), com backup do que sobrescreve; (3) **arma** o git hook (`core.hooksPath -> githooks`). De quebra, **valida o frontmatter YAML** de cada skill: skill quebrada nao instala e o script sai != 0 - e o "lint" do repo.

Fez ajuste direto no `~/.claude` (settings, statusline, hook)? `./capture.sh` traz de volta pro `home-claude/` (maquina -> repo), reescreve paths do home pra `$HOME` e nao commita - revise o diff e suba via PR (a skill `capturar-config-claude` automatiza isso). Detalhes de portabilidade em `README.md`.

## Setup em maquina nova

Este repo e o **guia**: um agente configura um PC do zero rodando dois passos idempotentes. Nao ha um script unico que faca tudo - de proposito, cada repo cuida do seu dominio.

1. **Claude (skills + config)** - `git clone` deste repo e `./install.sh`.
2. **Terminal + ferramentas** - `git clone` do repo **`DCCA/ade-stack`** (privado) e `bash setup-ade-stack.sh`. E o ambiente de terminal (WezTerm + herdr + yazi + helix + eza + starship, Catppuccin), cross-platform WSL/Linux/macOS.

O agente conduz (resolve conflitos, revisa segredos, pergunta o que for identidade); os scripts fazem o trabalho bruto e repetivel.

## Git

Nunca commitar direto na `main`. Branch + PR para cada mudanca. Nas mensagens de commit, usar "-" simples (nunca dash longo) e nao adicionar co-author automatico.

**Security scan obrigatorio antes de qualquer PR e merge.** Este repo e publico: nada de segredo, credencial, PII ou path absoluto do home (`/home/usuario`) pode entrar. Duas camadas:

1. **Local (`githooks/pre-push`)** - o `scripts/security-scan.sh` roda antes de todo push e bloqueia se achar algo. `./install.sh` arma o hook (`core.hooksPath -> githooks`) por clone. Rode `./scripts/security-scan.sh` na mao quando quiser (`--history` varre o log). Bypass so em emergencia: `git push --no-verify`.
2. **Server-side (GitHub Actions + branch protection)** - o workflow `.github/workflows/security-scan.yml` roda o mesmo scan em cada PR; a `main` tem branch protection exigindo o check `security-scan` (com `enforce_admins`), entao **nao da pra mergear com o check vermelho**. Sem token: usa so o `GITHUB_TOKEN` efemero.

Consequencia pratica: um `gh pr merge` so completa depois do check verde. Se algum fluxo (ship, session-status) for mergear, espere o check passar.
