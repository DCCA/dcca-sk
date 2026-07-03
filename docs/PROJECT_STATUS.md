# Project Status - dcca-sk

Logbook do repositório. Entradas em ordem reversa (mais recente no topo). Cada entrada registra onde estávamos, o que mudou e o que ficou pendente.

---

## 2026-07-03 - Skill capturar-config-claude, teste de trigger, e security scan em 2 camadas

**Where we were:** Setup portátil do `~/.claude` já no repo (config por cópia + `capture.sh`), statusline nova. Faltava: transformar o `capture.sh` numa skill, validar que ela é efetiva, e garantir que nada sensível vaze neste repo público.

**What we did:**
- **Skill `capturar-config-claude`** (`skills/dev/`): wrapper do `capture.sh` que reconhece o pedido, roda a captura, revisa o diff com olhar de segurança e sobe via PR. Com cenário + rubrica (comportamental, não puxa da Acme por ser tooling). (#21)
- **Teste da skill vs evals** (sandbox isolado, sem tocar repo/config reais): passou 8/8 na rubrica, inclusive resolução do repo a frio (cwd num projeto não relacionado). Mas o baseline **sem skill** também acertou - porque o próprio repo (README + `capture.sh` safe-by-design) já ensina tudo. Conclusão honesta: a skill é **correta**, mas o valor marginal sobre a doc do repo é pequeno; o que ela adiciona de único é o trigger garantido.
- **Otimização de trigger (skill-creator)**: 1ª rodada deu 0.0 em tudo - era **artefato de medição** (a skill real instalada ofuscava o proxy do harness). Diagnosticado e corrigido (stash da skill real durante o teste). Rodada válida: nenhuma das 5 descrições reescritas bateu a original, e os números absolutos do harness (proxy de comando) não são confiáveis para esta skill. Decisão: **manter a descrição atual** (nada melhor foi achado). Teste manual confirma que a skill dispara ("Vou usar a skill de capturar config").
- **Security scan obrigatório, 2 camadas** (repo público):
  - `scripts/security-scan.sh` (segredos, atribuições, `/home/usuario` fora de docs, email em conteúdo, arquivos sensíveis rastreados; `--history` varre o log). Testado: limpo=OK, segredo plantado=bloqueado, zero falso-positivo.
  - Camada local: `githooks/pre-push` faz `exec` do scan; `install.sh` arma `core.hooksPath -> githooks` por clone. (#22)
  - Camada server-side: workflow `.github/workflows/security-scan.yml` roda o scan em cada PR **sem token** (só o `GITHUB_TOKEN` efêmero); `main` com **branch protection** exigindo o check `security-scan` + `enforce_admins`. Provado: merge com check pendente é bloqueado, só passa com verde. (#23, #24)

**Decisions:**
- **Skill mantida mesmo com valor marginal pequeno**: é barata e o trigger garantido é útil; a doc do repo é que faz o trabalho pesado.
- **Não confiar nos números do otimizador de trigger** aqui: o harness mede um proxy de comando que sub-mede vs skill real instalada.
- **Enforcement por git/CI, não por memória**: automação de "antes de PR/merge" tem que ser hook + branch protection (o harness/GitHub executa), não preferência.
- **Sem token novo**: Actions usa `GITHUB_TOKEN` efêmero; branch protection setada via auth existente do `gh` (escopo `repo` já tinha).

**Pending / next:**
- [ ] Opcional: vendorizar skills de terceiros pro repo (offline-completo). Ainda adiado.
- [ ] Opcional: se a skill `capturar-config-claude` errar o trigger em uso real com frase tipo "subir pro repositório das skills", adicionar essa frase exata como gatilho.
- [ ] Herdado: propagar config separada (`config.example.md` + `config.md` gitignored) para as outras 6 skills.
- [ ] Herdado: promover skills do backlog do `SKILLS-MAP.md` conforme tração.

## 2026-07-02 - Setup portátil do Claude Code (config no repo) + statusline

**Where we were:** O repo guardava só as skills (symlink via `install.sh`). A config do Claude Code (`~/.claude`: instruções, settings, statusline, hooks) vivia só na máquina, não portátil. O pedido inicial era só melhorar a statusline.

**What we did:**
- Statusline reescrita em **python3** (sem depender de `jq`, que não estava instalado): mostra `modelo | dir | branch | $/prompt | $ sessão | +/- linhas`. `$/prompt` = delta do custo cumulativo por sessão, persistido em `~/.claude/statusline-state/`. Corrigi dois bugs do rascunho inicial (dependência de jq; heredoc roubando o stdin do JSON). Verificada ponta a ponta.
- **Setup portátil** do `~/.claude`: novo `home-claude/` espelha os arquivos portáteis (`AGENTS.md`, `settings.json`, `statusline-command.sh`, `hooks/`). `settings.json` usa `$HOME` nos paths (funciona em qualquer usuário). Plugins já eram portáteis via `enabledPlugins`. (#17)
- Config passou de **symlink para cópia**: `install.sh` copia `home-claude/` -> `~/.claude` como arquivos reais; a máquina fica independente do repo (mover/apagar o repo não quebra mais o setup). (#18)
- Novo **`capture.sh`**: caminho de volta (máquina -> repo). Copia os arquivos rastreados do `~/.claude` para `home-claude/`, re-normaliza paths absolutos para `$HOME` no `settings.json`, pula idênticos, não commita. (#19)
- **Auditoria de segurança** (repo é público): varredura de segredos/PII na árvore e em todo o histórico git. Limpo - zero tokens/keys/credenciais; nenhum `.credentials.json`/`settings.local.json` jamais commitado; sem paths `/home/USER`. Único achado: o e-mail nos metadados de autor dos commits (inerente a qualquer repo público), não vaza de nenhum arquivo.

**Decisions:**
- **Cópia, não symlink**, para a config: o usuário preferiu que `~/.claude` tenha arquivos reais e independentes do repo. Trade-off aceito: mudanças não fluem sozinhas - editar em `home-claude/` + `install.sh` (repo -> máquina), ou `capture.sh` (máquina -> repo).
- Sync de config é **script de plumbing** (`capture.sh`), não uma skill em `skills/` - estas são as skills portáteis de PM/dev com evals, agnósticas a empresa.
- Não vendorizar skills de terceiros (hoje symlinkadas de `~/.agents/skills` e `~/projects/jona`) - adiado.

**Pending / next:**
- [ ] Opcional: vendorizar no repo as skills de terceiros que uso, para o set ficar offline-completo em qualquer máquina.
- [ ] Opcional: thin skill que dispara `capture.sh` por conversa ("captura minha config").
- [ ] Herdado: propagar o modelo de **config separada** (`config.example.md` + `config.md` gitignored) para as outras 6 skills - piloto aprovado na `daily-review`.
- [ ] Herdado: promover skills do backlog do `SKILLS-MAP.md` conforme tração (1º candidato: `instrument-analytics`).

## 2026-06-29 - Inicialização do repo, núcleo completo com evals, e hardening (YAML + config separada)

**Where we were:** Repo `dcca-sk` vazio (zero commits). Objetivo: criar, melhorar e organizar minhas agent skills profissionais (sou PM), de forma agnóstica a empresa. Existia só uma skill rascunhada (`daily-review`) num zip no Downloads.

**What we did:**
- Inicializei o repo: estrutura `skills/{produto,dev,escrita}`, `install.sh` (symlink em `~/.claude/skills`), `templates/SKILL.md`, `CLAUDE.md`/`README.md`, e o princípio agnóstico a empresa. Remote privado em github.com/DCCA/dcca-sk. (#1)
- `daily-review` incorporada e endurecida: polish + `description` focada em gatilhos (#1); 4 ambiguidades fechadas via teste de aplicação (#2); fontes configuráveis + Jira como rastreador de issues (#3).
- `SKILLS-MAP.md` lean: um review multi-agente cortou 24 candidatas para um núcleo de 6 + backlog. (#4)
- Harness de eval nível 1: empresa fictícia `evals/empresa-ficticia/acme.md`, método aplicador -> avaliador, convenção "toda skill nasce com cenário + rubrica"; sandbox nível 2 reframado para **mock MCP** (sem criar contas). (#5, #6)
- Núcleo construído e validado por eval: `metric-definition` (#7), `weekly-metrics-digest` (#8), e `priorizacao` + `prd-writer` + `derive-tech-spec` + `status-update` (#9). Todas 11-14/14, zero alucinação.
- `evals/RESULTS.md` para persistir os placares de cada rodada (#10).
- 3 skills enxugadas para eficiência de token (`daily-review` 1882 -> 1210 palavras, -36%), re-validadas 14/14 (#11).
- Fix de YAML no frontmatter: `description` de `daily-review` e `metric-definition` tinha `: ` em valor sem aspas (quebrava o parse / GitHub). Aspas simples + template corrigido (frontmatter no topo) + convenção no CLAUDE.md (#13). O `install.sh` passou a **validar o frontmatter** de cada skill e recusar instalar skill quebrada, com exit != 0 (#14).
- Config separada (piloto na `daily-review`): a config (fontes, handles, canais, VIPs, glossário) saiu do corpo do SKILL.md para `config.example.md` (template versionado) + `config.md` (preenchido no destino, gitignored); o SKILL.md aponta pro `config.md`. Fecha o furo de ter que editar arquivo versionado para preencher config. Re-validada 14/14 (#15).

**Decisions:**
- Distribuição via symlink em `~/.claude/skills` (não plugin), pelo `install.sh`. Repo **agnóstico a empresa**: config sempre como placeholder, preenchida só no destino, para as skills serem portáteis entre empregos.
- Núcleo **lean** (espinha métrica -> número -> decisão -> spec -> build -> reporte) em vez de catálogo; o resto fica no backlog até dar tração.
- Toda skill ship com eval (cenário + rubrica puxando da Acme) e entra no `RESULTS.md`; a eval roda como workflow com aplicador e avaliador **separados** (quem produz não se auto-aprova).
- Teste de maior fidelidade via **mock MCP** (sem contas), não sandboxes reais.

**Pending / next:**
- [ ] Propagar o modelo de **config separada** (`config.example.md` + ponteiro no SKILL.md + `config.md` gitignored) para as outras 6 skills - piloto aprovado na `daily-review`, ainda não propagado.
- [ ] Promover skills do backlog do `SKILLS-MAP.md` conforme tração. 1º candidato sugerido: `instrument-analytics`.
- [ ] Opcional: arquivar o transcript completo de cada rodada de eval (hoje só o veredito consolidado fica no `RESULTS.md`).
- [ ] Opcional: gerar um mock MCP server para testar a `daily-review` contra a interface real dos conectores.
- [ ] Nível 2b (sandboxes reais com conta) só se necessário - exige criar as contas de teste (Jira/Google/Slack).
