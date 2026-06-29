# dcca-sk

Minhas agent skills (Claude Code) - criar, melhorar e organizar as skills que uso no trabalho.

O repo e **agnostico a empresa**: as skills ficam genericas, com a configuracao especifica como placeholder. A config real e preenchida so no destino, na hora de importar. Assim as skills sao portateis entre empregos.

## Estrutura

```
skills/
  dev/        engenharia de software
  produto/    produto, dados, growth
  escrita/    escrita e comunicacao
templates/
  SKILL.md    base para uma skill nova
install.sh    cria os symlinks em ~/.claude/skills
CLAUDE.md     convencoes (lido pelo Claude ao trabalhar neste repo)
```

Cada skill vive em `skills/<categoria>/<nome>/SKILL.md`.

## Instalar

```bash
./install.sh
```

Cria um symlink de cada skill em `~/.claude/skills/<nome>`. Por ser symlink, editar a skill no repo reflete direto no Claude. Rode de novo ao adicionar uma skill nova.

Destino customizavel: `CLAUDE_SKILLS_DIR=/outro/caminho ./install.sh`.

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
