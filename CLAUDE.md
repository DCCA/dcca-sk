# dcca-sk - Skills profissionais do Daniel

Repositorio publico de autoria das minhas agent skills, templates e evals.
Sou PM e trabalho em portugues.

## Principio: agnostico a empresa

Este repo nao guarda configuracao final. Skills sao genericas; nomes, canais,
metricas, produtos, handles e demais dados reais ficam como placeholders ou em
arquivos locais ignorados. Nunca commitar dados reais de uma empresa.

## Ownership

- `dcca-sk` e a fonte de autoria e avaliacao das skills. O export explicito esta
  em `skills/export-manifest.json`.
- `dcca-env` e o unico dono da configuracao de runtime de Pi, Claude Code e
  Codex, dos links de agente e da instalacao de skills de terceiros.
- `dcca-sk` nao captura, instala ou linka configuracao de agentes. Nao ha
  snapshots de agentes nem catalogo de terceiros neste repo.
- O glue de shell e os arquivos seed do VS Code continuam neste repo. O
  ambiente de terminal continua no `DCCA/ade-stack`.

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
A policy de agentes pertence ao dcca-env; o harness e os casos de eval continuam neste repo e recebem o arquivo canonico por argumento.

## Instalar e capturar

`./install.sh` valida o frontmatter e a estrutura das skills listadas em
`skills/export-manifest.json`, sem criar links de runtime. Tambem instala os
arquivos ainda pertencentes ao repo conforme `dotfiles/manifest`: glue de shell
e arquivos seed do VS Code. Por fim, arma o hook de seguranca do Git. O script
imprime uma mensagem clara de que agentes, terceiros e links de runtime sao
dominio do dcca-env.

`./capture.sh` e report-only e captura somente shell/VS Code. Ele pula
explicitamente destinos de agentes; nao existe mais captura de `~/.claude` ou
`~/.codex`. Revise o diff e commite voce.

## Setup em maquina nova

1. Clone dcca-env e rode o fluxo `bootstrap`, `preview`, `apply` e `check` dele.
2. Clone este repo para editar skills, templates, evals e o glue de shell/VS
   Code ainda pertencente aqui.
3. Clone `DCCA/ade-stack` e rode `bash setup-ade-stack.sh` para o ambiente de
   terminal.

## Git e seguranca

Nunca commitar direto na `main`. Use branch e PR. Mensagens usam `-` simples e
nao adicionam co-author automatico.

Antes de qualquer PR ou push, rode `./scripts/security-scan.sh`. O hook
`githooks/pre-push` executa o mesmo scan. Este repo publico nao pode conter
segredos, credenciais, PII, estado de runtime ou paths absolutos da maquina.
