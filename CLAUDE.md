# dcca-sk - Skills profissionais do Daniel

Repositorio publico de autoria das minhas agent skills, templates e evals.
Sou PM e trabalho em portugues.

## Principio: agnostico a empresa

Este repo nao guarda configuracao final. Skills sao genericas; nomes, canais,
metricas, produtos, handles e demais dados reais ficam como placeholders ou em
arquivos locais ignorados. Nunca commitar dados reais de uma empresa.

## Ownership

- `dcca-sk` e a fonte de autoria e avaliacao das skills autorais.
- `dcca-env` e o unico dono da configuracao de runtime de Pi, Claude Code e
  Codex, dos links de agente e da instalacao de skills de terceiros.
- `dcca-sk` nao captura, instala ou linka configuracao de agentes. Nao ha
  snapshots de agentes nem catalogo de terceiros neste repo.
- O ambiente de terminal continua no `DCCA/ade-stack`.

## O que e uma skill aqui

Cada skill e um diretorio `skills/<categoria>/<nome-kebab>/SKILL.md`, com
frontmatter (`name`, `description`) e procedimento. Recursos extras ficam no
mesmo diretorio. Categorias:

- `dev/` - engenharia de software.
- `produto/` - produto, dados e growth.
- `escrita/` - escrita e comunicacao.

O export manifest lista explicitamente as skills aprovadas para consumo por
outros repositorios. Hoje a lista contem somente `daily-review`.

## Criar ou melhorar uma skill

Use sempre `superpowers:writing-skills` (versao com verificacao/evals).
Comece em `templates/SKILL.md`, use nome kebab-case e description em terceira
pessoa, focada em quando usar e com gatilhos concretos. O frontmatter e sempre
a primeira coisa do arquivo e a description fica entre aspas simples no YAML.

## Evals

Toda skill nasce com pelo menos um cenario e uma rubrica em seu diretorio
evals. Use `evals/empresa-ficticia/acme.md` e consulte `evals/README.md` para o
fluxo aplicador -> avaliador. Resultados duraveis ficam em `evals/RESULTS.md`.
A policy de agentes pertence ao dcca-env; o harness e os casos de eval continuam
neste repo e recebem o arquivo canonico por argumento.

## Validar e instalar

`./install.sh` e um wrapper de compatibilidade que valida apenas o contrato em
`skills/export-manifest.json`. Ele pode configurar `core.hooksPath` somente no
clone atual; nao escreve em HOME nem em destinos externos.

`./capture.sh` esta depreciado e serve somente como handoff. E estritamente
nao-mutante: nao captura estado vivo e nao copia arquivos para o repositorio.
Use DCCA/dcca-env para restaurar e configurar o ambiente de agentes.

## Setup em maquina nova

1. Clone dcca-env e rode o fluxo `bootstrap`, `preview`, `apply` e `check` dele.
2. Clone este repo somente para editar skills, templates, evals e documentacao.
3. Para o ambiente de terminal, clone tambem `DCCA/ade-stack` e rode `bash setup-ade-stack.sh`.

## Git e seguranca

Nunca commitar direto na `main`. Use branch e PR. Mensagens usam `-` simples e
nao adicionam co-author automatico.

Antes de qualquer PR ou push, rode `./scripts/security-scan.sh`. O hook
`githooks/pre-push` executa o mesmo scan. Este repo publico nao pode conter
segredos, credenciais, PII, estado de runtime ou paths absolutos da maquina.
