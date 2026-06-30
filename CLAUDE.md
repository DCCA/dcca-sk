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

Depois de adicionar ou editar uma skill, rode `./install.sh` para (re)criar os symlinks em `~/.claude/skills`. Como sao symlinks, edicoes no repo valem na proxima sessao do Claude sem precisar reinstalar.

## Git

Nunca commitar direto na `main`. Branch + PR para cada mudanca. Nas mensagens de commit, usar "-" simples (nunca dash longo) e nao adicionar co-author automatico.
