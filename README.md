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

Roadmap (nucleo a construir + backlog) em [`SKILLS-MAP.md`](SKILLS-MAP.md).
