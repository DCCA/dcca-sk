# dcca-sk

Fonte publica de autoria das minhas agent skills, templates e evals. O repo e
agnostico a empresa: configuracoes reais ficam no destino, como placeholders
ou arquivos locais ignorados.

## Ownership

- **dcca-sk**: escreve e avalia skills autorais. O contrato de exportacao esta
  em [`skills/export-manifest.json`](skills/export-manifest.json); hoje exporta
  apenas `daily-review`.
- **dcca-env**: instala skills de terceiros, plugins, CLIs, configuracao de
  agentes e links de runtime. dcca-sk nao e um segundo escritor desses
  destinos.
- **ade-stack**: continua dono do ambiente de terminal.
- **dcca-sk**: continua dono do glue de shell e dos arquivos seed do VS Code
  descritos em [`dotfiles/manifest`](dotfiles/manifest).

Credenciais, autenticacao, sessoes, historico, caches, estado gerado e backups
nao pertencem a este repositorio.

## Estrutura

```
skills/                  skills autorais e export-manifest.json
templates/SKILL.md       base para uma skill nova
evals/                   cenarios, rubricas e resultados
dotfiles/manifest        somente shell e VS Code ainda pertencentes a este repo
dotfiles/shell/          glue de shell para ferramentas de IA
dotfiles/vscode/         settings e extensoes seed do VS Code
install.sh               valida o export e instala shell/VS Code; arma o hook
capture.sh               captura somente os destinos ainda pertencentes aqui
scripts/security-scan.sh varredura obrigatoria antes de push
```

## Instalar o que este repo possui

```bash
./install.sh
```

O script valida cada `SKILL.md` listado no export manifest, sem criar links em
`~/.claude/skills` ou em qualquer outro destino de agente. Tambem copia os
arquivos de shell e VS Code conforme `dotfiles/manifest`, instala extensoes do
VS Code quando `code` esta disponivel e arma o hook local de seguranca do Git.
Ele imprime explicitamente que configuracao de agentes e terceiros pertence ao
dcca-env.

Para restaurar o ambiente de agentes, use o fluxo `bootstrap`, `preview`,
`apply` e `check` do dcca-env. Esses comandos sao a unica fonte de runtime para
Pi, Claude Code e Codex.

## Capturar mudancas ainda pertencentes a este repo

```bash
./capture.sh
```

A captura traz somente shell e VS Code de volta para `dotfiles/`, nunca captura
configuracao de agentes, skills de terceiros ou estado de runtime. Revise o
diff antes de commitar. O script nao cria commit.

## Skills autorais

| Skill | Categoria | O que faz |
|-------|-----------|-----------|
| `daily-review` | produto | Fecha o dia anterior e prepara o dia atual a partir das fontes conectadas. |

Para criar uma skill, comece em [`templates/SKILL.md`](templates/SKILL.md),
salve-a em `skills/<categoria>/<nome-kebab>/SKILL.md`, adicione-a ao export
manifest e rode `./install.sh` para validar frontmatter e o contrato.

## Setup em maquina nova

1. Clone dcca-env e rode o fluxo de restore documentado nele.
2. Clone este repo somente para editar skills, templates, evals e o glue de
   shell/VS Code que ainda e seu.
3. Para o ambiente de terminal, clone tambem `DCCA/ade-stack` e rode seu
   `setup-ade-stack.sh`.

## Seguranca

Este repositorio e publico. O `install.sh` arma `githooks/pre-push`, que roda
`scripts/security-scan.sh`. Rode o scan manualmente quando necessario:

```bash
./scripts/security-scan.sh
```

Nunca adicione credenciais, tokens, PII, estado de runtime ou paths absolutos
da maquina.
