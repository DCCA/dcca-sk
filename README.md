# dcca-sk

Minhas agent skills (Claude Code) + o setup portatil do meu Claude Code - criar, melhorar e organizar tudo que uso no trabalho, para levar entre maquinas e empregos.

O repo e **agnostico a empresa**: as skills ficam genericas, com a configuracao especifica como placeholder. A config real e preenchida so no destino, na hora de importar. Assim as skills sao portateis entre empregos.

## Estrutura

```
skills/         minhas skills (dev/, produto/, escrita/)
templates/
  SKILL.md      base para uma skill nova
dotfiles/       config portatil por tool (dirigido por dotfiles/manifest)
  manifest              tool | target por-OS (linux/mac/wsl) | excludes
  claude/               config do ~/.claude: AGENTS.md, settings.json, statusline, hooks/
install.sh      symlinka as skills e COPIA a config em ~/.claude (repo -> maquina); arma o hook de git
capture.sh      copia a config do ~/.claude de volta pra dotfiles/claude/ (maquina -> repo)
scripts/        security-scan.sh (segredo/PII); roda no githooks/pre-push antes de todo push
CLAUDE.md       convencoes (lido pelo Claude ao trabalhar neste repo)
```

Cada skill vive em `skills/<categoria>/<nome>/SKILL.md`.

## Instalar

```bash
./install.sh
```

Faz duas coisas:

1. **Skills** (symlink) - cada `SKILL.md` vira `~/.claude/skills/<nome>`. Como e symlink, editar a skill no repo reflete direto no Claude.
2. **Config** (copia) - cada arquivo de `dotfiles/claude/` e **copiado** para `~/.claude/<arquivo>` como arquivo real. `~/.claude` fica independente do repo. Um arquivo real ja existente e diferente e salvo em `~/.claude/backups/config-<timestamp>/` antes de ser sobrescrito; se ja for identico, nada acontece. Idempotente.

O repo e a **copia-mestra** da config: edite em `dotfiles/claude/`, rode `./install.sh` para instalar na maquina, e commite.

### Capturar mudancas feitas na maquina

Ajustou algo direto em `~/.claude` (settings, statusline, hook)? Traga de volta pro repo:

```bash
./capture.sh
```

Copia cada arquivo rastreado do `~/.claude` para `dotfiles/claude/` (so os que ja existem la), reescreve paths absolutos do home para `$HOME` no `settings.json` (nao vaza `/home/USER`), e nao commita nada - revise com `git diff` e commite voce. Origem custom: `CLAUDE_HOME=/x ./capture.sh`.

Numa maquina nova: clone o repo, rode `./install.sh`, e o Claude Code ja sobe com suas instrucoes, settings, statusline e hooks. Os **plugins** (superpowers, ponytail, vercel, ...) sao restaurados sozinhos pelo `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`). Para o ambiente de **terminal** (WezTerm + herdr + yazi + helix + eza + starship, Catppuccin, cross-platform WSL/Linux/macOS), clone tambem o repo `DCCA/ade-stack` (privado) e rode `bash setup-ade-stack.sh`. Runbook completo dos dois passos em [`CLAUDE.md`](CLAUDE.md) ("Setup em maquina nova").

Destinos customizaveis: `CLAUDE_SKILLS_DIR=/x CLAUDE_HOME=/y ./install.sh`.

### O que NAO vai para o repo

Segredos e estado local ficam so na maquina, nunca versionados: `.credentials.json`, `settings.local.json`, `history.jsonl`, `sessions/`, `projects/` (transcricoes + memoria), caches. Se precisar de override por maquina, use `~/.claude/settings.local.json` (o Claude Code mescla por cima do `settings.json`).

## Criar uma skill

1. Peca ao Claude para usar o skill `writing-skills` (ou copie `templates/SKILL.md`).
2. Salve em `skills/<categoria>/<nome-kebab>/SKILL.md`.
3. Rode `./install.sh`.

Convencoes completas em [`CLAUDE.md`](CLAUDE.md).

## Skills

| Skill | Categoria | O que faz |
|-------|-----------|-----------|
| `daily-review` | produto | Fecha o dia anterior e prepara o dia atual a partir das fontes conectadas (calendario, e-mail, Slack, GitHub, Jira, transcricoes). |
| `capturar-config-claude` | dev | Traz mudancas feitas no `~/.claude` de volta pro repo: roda `capture.sh`, revisa o diff (sem vazar segredo/path) e sobe via PR. |

Skills removidas (construidas mas nao usadas) e ideias paradas: [`SKILLS-MAP.md`](SKILLS-MAP.md).

### Skills externas que eu uso (referenciadas)

Skills/ferramentas de terceiros que instalo em toda maquina ficam em [`skills/registry`](skills/registry) - **so ponteiros**, nunca o conteudo. O `install.sh` provisiona cada uma: `plugin` (verifica `enabledPlugins`), `git` (clona em `~/.claude/skills`), `npx` (`npx skills add`), `npm` (`npm install -g`). Para adicionar uma, e uma linha no arquivo. Design em [`docs/specs/2026-07-18-skills-registry.md`](docs/specs/2026-07-18-skills-registry.md).
