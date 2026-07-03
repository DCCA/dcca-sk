# dcca-sk

Minhas agent skills (Claude Code) + o setup portatil do meu Claude Code - criar, melhorar e organizar tudo que uso no trabalho, para levar entre maquinas e empregos.

O repo e **agnostico a empresa**: as skills ficam genericas, com a configuracao especifica como placeholder. A config real e preenchida so no destino, na hora de importar. Assim as skills sao portateis entre empregos.

## Estrutura

```
skills/         minhas skills (dev/, produto/, escrita/)
templates/
  SKILL.md      base para uma skill nova
home-claude/    config portatil do ~/.claude (symlinkado no install)
  AGENTS.md               instrucoes globais (CLAUDE.md aponta pra ca)
  settings.json           permissoes, hooks, plugins, statusline (paths com $HOME)
  statusline-command.sh   status line (modelo | dir | branch | $/prompt | $ sessao | +/- linhas)
  hooks/                  hooks custom (ex: herdr-agent-state.sh)
install.sh      symlinka as skills e COPIA a config em ~/.claude
CLAUDE.md       convencoes (lido pelo Claude ao trabalhar neste repo)
```

Cada skill vive em `skills/<categoria>/<nome>/SKILL.md`.

## Instalar

```bash
./install.sh
```

Faz duas coisas:

1. **Skills** (symlink) - cada `SKILL.md` vira `~/.claude/skills/<nome>`. Como e symlink, editar a skill no repo reflete direto no Claude.
2. **Config** (copia) - cada arquivo de `home-claude/` e **copiado** para `~/.claude/<arquivo>` como arquivo real. `~/.claude` fica independente do repo. Um arquivo real ja existente e diferente e salvo em `~/.claude/backups/config-<timestamp>/` antes de ser sobrescrito; se ja for identico, nada acontece. Idempotente.

O repo e a **copia-mestra** da config: edite em `home-claude/`, rode `./install.sh` para instalar na maquina, e commite. Um ajuste feito direto em `~/.claude` **nao** volta sozinho para o repo - copie de volta para `home-claude/` e commite se quiser guardar.

Numa maquina nova: clone o repo, rode `./install.sh`, e o Claude Code ja sobe com suas instrucoes, settings, statusline e hooks. Os **plugins** (superpowers, ponytail, vercel, ...) sao restaurados sozinhos pelo `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`).

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
| `metric-definition` | produto | Produz a metric spec (fonte unica de verdade de uma metrica): expoe decisoes escondidas e reconcilia divergencias. |
| `weekly-metrics-digest` | produto | Resumo semanal das metricas virado para o sinal: variacao WoW, anomalias com hipotese, guardrails, lacunas de dado. |
| `priorizacao` | produto | Fila auditavel (RICE): escala calibrada, premissa por nota, baixa confianca vira discovery. |
| `prd-writer` | produto | PRD com problema e metrica de sucesso antes da solucao; marca o que e aberto/assumido. |
| `derive-tech-spec` | dev | Plano tecnico derivado do PRD; cada decisao rastreia a um requisito; supoe o codebase com (assumido). |
| `status-update` | escrita | Update BLUF com farol honesto, riscos e asks explicitos; nao infla. |

Roadmap (nucleo a construir + backlog) em [`SKILLS-MAP.md`](SKILLS-MAP.md).
