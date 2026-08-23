# dcca-sk

Fonte publica de autoria das minhas agent skills, templates e evals. O repo e
agnostico a empresa: configuracoes reais ficam no destino, como placeholders
ou arquivos locais ignorados.

## Ownership

- **dcca-sk**: escreve, valida e avalia skills autorais. O contrato de
  exportacao esta em [`skills/export-manifest.json`](skills/export-manifest.json);
  hoje exporta apenas `daily-review`.
- **dcca-env**: restaura configuracao de agentes e ambiente de terminal,
  instala skills de terceiros, plugins, CLIs e links de runtime. dcca-sk nao
  e um segundo escritor desses destinos.
- **ade-stack**: permanece somente como handoff de compatibilidade para
  dcca-env.

Credenciais, autenticacao, sessoes, historico, caches, estado gerado e backups
nao pertencem a este repositorio.

## Estrutura

```
skills/                  skills autorais e export-manifest.json
templates/SKILL.md       base para uma skill nova
evals/                   cenarios, rubricas, fixtures e resultados
scripts/check-export.py  validacao do contrato de exportacao
scripts/security-scan.sh varredura obrigatoria antes de push
install.sh               wrapper de validacao e hook local do clone
capture.sh               handoff depreciado, sem captura ou mutacao
```

## Validar o que este repo publica

```bash
./install.sh
```

O script valida cada `SKILL.md` listado no export manifest. Ele nao instala
skills, configuracao de agentes, terceiros ou arquivos em HOME. Opcionalmente,
configura `core.hooksPath` somente no clone atual para armar o scan local de
pre-push.

Para restaurar o ambiente de agentes, use o fluxo `bootstrap`, `preview`,
`apply` e `check` do DCCA/dcca-env. Esses comandos sao a unica fonte de runtime
para Pi, Claude Code e Codex.

`capture.sh` foi mantido apenas como handoff de compatibilidade. Ele nao le
estado vivo, nao copia arquivos e nao altera o clone. Use DCCA/dcca-env para o
fluxo de restauracao e configuracao de runtime.

## Skills autorais

| Skill | Categoria | O que faz |
|-------|-----------|-----------|
| `daily-review` | produto | Fecha o dia anterior e prepara o dia atual a partir das fontes conectadas. |

Para criar uma skill, comece em [`templates/SKILL.md`](templates/SKILL.md),
salve-a em `skills/<categoria>/<nome-kebab>/SKILL.md`, adicione-a ao export
manifest e rode `./install.sh` para validar frontmatter e o contrato.

## Setup em maquina nova

1. Clone DCCA/dcca-env e rode o fluxo de restore documentado nele para agentes
   e ambiente de terminal.
2. Clone este repo para editar somente skills, templates, evals e documentacao.

## Seguranca

Este repositorio e publico. O `install.sh` arma `githooks/pre-push` apenas no
clone atual, e o hook roda `scripts/security-scan.sh`. Rode o scan manualmente
quando necessario:

```bash
./scripts/security-scan.sh
```

Nunca adicione credenciais, tokens, PII, estado de runtime ou paths absolutos
da maquina.
