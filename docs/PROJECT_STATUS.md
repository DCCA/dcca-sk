# Project Status - dcca-sk

Logbook do repositório. Entradas em ordem reversa (mais recente no topo). Cada entrada registra onde estávamos, o que mudou e o que ficou pendente.

---

## 2026-07-18 - dcca-sk vira dotfiles versionado de IA: skills registry + config layer

**Where we were:** Depois da poda, o dcca-sk tinha 2 skills + a config portátil só do Claude (`home-claude/`). Objetivo desta rodada: transformar o repo num **setup de IA versionado e instalado por agente** - skills (próprias + referenciadas) e config de todas as ferramentas de IA - construído em PRs pequenos.

**What we did:**
- **Skills registry** (#31, fix #32): `skills/registry` = ponteiros pra skills externas, provisionadas pelo `install.sh`. Tipos: `plugin` (verifica enabledPlugins), `git` (clona), `npx` (`npx skills add`), `npm` (`npm -g`). Seed: superpowers/taste/openspec; + `impeccable` (#34). Fix #32: o `npx` roda do `$HOME` (global, sem poluir o repo) - o skills CLI instala no `.agents/` do cwd.
- **Config layer** (#33): `home-claude/` -> `dotfiles/claude/` + `dotfiles/manifest` (`tool | target-linux | target-mac | target-wsl | excludes | mode`). `install.sh`/`capture.sh` dirigidos por manifest (por-OS, expande `~` e `$WINHOME`, pula excludes). Capturou o drift vivo do `~/.claude` (um `model` preference).
- **Codex** (#35): base portátil curada `dotfiles/codex/config.toml` + novo **mode `seed`** (só escreve se o target nao existe, nunca captura) - porque o config.toml mistura settings portáteis com a trust list `[projects]` privada + paths `/home`.
- **VS Code** (#36): `dotfiles/vscode/{settings.json, extensions.txt}`, `seed`, token `$WINHOME` (WSL -> `Code/User` do Windows via `wslpath`) + passo `code --install-extension`.

**Decisions:**
- **Abordagem A (manifest), não chezmoi**: preserva o modelo de cópia + security scan; os ganhos do chezmoi (templating/segredo cifrado) não valem nesta escala (poucos tools, segredo fica de fora, não cifrado).
- **dcca-sk ampliado** de "config do Claude" pra "config de todas as ferramentas de IA"; o ade-stack (terminal) fica separado.
- **`seed` mode** pra config que acumula estado local (trust do Codex, tweaks por-máquina do VS Code): nunca sobrescreve, nunca captura. Reutilizável.
- **Referência, não vendor** pras skills externas (registry = ponteiros); segredo fica FORA (excludes + scan; token em URL derruba o scan). Codex/VS Code: só a fatia portátil viaja (sem projetos/paths privados).

**Pending / next:**
- [ ] **Piece 5: shell/git AI glue** (`dotfiles/shell/ai.sh` sourceado, coexiste com o bloco do ade-stack). Última peça do config layer.
- [ ] **Sync da `daily-review`** - ainda esperando a versão da máquina do trabalho.
- [ ] Nit: `dotfiles/vscode/settings.json` está 755 (veio do mount `/mnt/c`) - `chmod 644`.
- [ ] Herdado: subdir em git-skill do registry adiado; `capturar-config-claude` sem linha no `evals/RESULTS.md`.

## 2026-07-18 - Terminal selector no ade-stack + poda das skills não usadas

**Where we were:** Depois da entrada de 2026-07-09 (#28), o ade-stack estava publicado (privado) e resiliente cross-distro, e o dcca-sk era o orquestrador. Mas o ade-stack só configurava WezTerm, e o dcca-sk ainda tinha 8 skills - a maioria sem uso real.

**What we did:**
- **ade-stack: seletor de terminal plugável.** Flag `--terminal auto|all|none|<csv>` (+ `$ADE_TERMINAL`) para `wezterm`, `iterm2`, `windows-terminal` - todos Catppuccin Mocha + JetBrainsMono Nerd Font. iTerm2 ganha um Dynamic Profile auto-carregado; Windows Terminal um fragmento não-destrutivo (não mexe no `settings.json`); wezterm inalterado. `auto` = WezTerm no WSL/Linux, iTerm2 num Mac que o tenha. As 5 ferramentas sempre foram terminal-agnósticas; só o passo [5/5] mudou. Dogfood em containers Debian/Ubuntu: matriz do seletor, validade dos dois JSON (cores Catppuccin corretas), run `--terminal all` exit 0. (ade-stack #3)
- **dcca-sk: poda de 6 skills não usadas.** Removidas `metric-definition`, `weekly-metrics-digest`, `priorizacao`, `prd-writer`, `derive-tech-spec`, `status-update` (passavam nas evals, mas sem tração). Mantidas `daily-review` + `capturar-config-claude`. Referências limpas: tabela do README, SKILLS-MAP reescrito (`em uso / removidas / backlog`), RESULTS enxugado + nota, `acme.md`. 2 sobreviventes validam, zero referência quebrada. (dcca-sk #29)
- **Sweep de consistência dos docs:** após a poda, o repo está limpo - sem refs órfãs, contagens erradas ou links quebrados. Único doc atrasado era este logbook (agora atualizado).

**Decisions:**
- **Terminal é camada plugável por máquina, não hardcoded.** O usuário pediu o seletor completo (não só iTerm2); `auto` mantém WezTerm no WSL como default. iTerm2/WT entregam um perfil pronto que o usuário seleciona uma vez (não força default).
- **Podar por tração, não por qualidade.** As 6 skills passavam nas evals; foram cortadas por não serem usadas. Lição registrada no SKILLS-MAP: construir skill quando a tarefa vira recorrente, não especulativamente.

**Pending / next:**
- [ ] **Sync da `daily-review`** (aberto, esperando o usuário): ele customizou a skill na máquina do trabalho; trazer a estrutura melhorada de volta pro repo como `[placeholders]` (repo é público). Precisa da versão do trabalho (colar ou apontar arquivo).
- [ ] `capturar-config-claude` não tem linha no `evals/RESULTS.md` (tem eval comportamental, mas ficou fora do placar).
- [ ] ade-stack (herdado): fallback do helix (PPA -> release) não testado em ARM real; configs de iTerm2/WT verificadas por correção de config, não por render de GUI.

## 2026-07-09 - ade-stack (ambiente de terminal) vira repo separado; dcca-sk vira orquestrador

**Where we were:** dcca-sk guardava skills + config portátil do `~/.claude`, mas o CLAUDE.md descrevia só a metade das skills (dizia que `install.sh` só cria symlinks) e não havia ambiente de terminal versionado. Trazido um zip `ade-stack` (WezTerm + herdr + yazi + helix + eza + starship, Catppuccin) com uma tarefa embutida de publicá-lo.

**What we did:**
- **ade-stack publicado como repo separado privado** (`DCCA/ade-stack`), com o commit-base como estava, sem modificar. (ade-stack `a4b2cdb`)
- **ade-stack cross-platform, 2 rodadas** (breakages achados por dogfood em containers Debian 12 + Ubuntu 24.04, não por chute):
  - arm64: detecção de `uname -m` nos downloads de release (yazi/helix/eza); herdr no macOS via installer próprio (não existe fórmula brew). (ade-stack #1)
  - yazi `-gnu` → `-musl` (o `-gnu` exige GLIBC_2.39 e quebra no Debian 12/glibc 2.36); `git` nos prereqs (o `ya pkg add` do flavor precisa dele); `theme.toml` aponta pro flavor **só se ele instalou** (senão yazi brica no boot); helix PPA→release com fallback + guarda de versão vazia (API rate-limited); herdr/starship avisam e seguem em vez de abortar o run inteiro. (ade-stack #2)
- **dcca-sk vira o guia/orquestrador**: CLAUDE.md corrigido (`install.sh` também copia `home-claude/` pro `~/.claude`, arma o git hook e valida o frontmatter YAML - o "lint"; cita `capture.sh`) + nova seção **"Setup em maquina nova"** (runbook de 2 passos: `./install.sh` p/ Claude, `ade-stack` + `setup-ade-stack.sh` p/ terminal). (#26) README sincronizado com o runbook. (#27)
- **Dogfood do runbook completo** em Ubuntu 24.04 e Debian 12 (fresh): os 2 passos rodam limpos, os 5 binários instalam **e executam**, exit 0. Os "problemas" do 1º round (hook não armado, "WSL2" detectado num container, tools MISSING) eram artefatos do método (docker cp com uid 1000 → dubious ownership; kernel WSL compartilhado; guard não-interativo do `.bashrc`), não bugs de produto.

**Decisions:**
- **Dois repos, não merge**: cada repo um propósito (regra do próprio dcca-sk); ade-stack já é limpo, standalone e cheio de binários. dcca-sk é o guia que orquestra os dois domínios.
- **Manter os `.sh`, o agente é que dirige**: a preocupação de "muito .sh" se resolve com o agente rodando os scripts idempotentes via runbook, não apagando os scripts (re-derivar `cp`/`ln` à mão é mais frágil).
- **musl > gnu por portabilidade** onde houve evidência (yazi quebrou); eza fica em `-gnu` (roda no Debian 12, sem sinal de quebra) - evidência, não especulação.

**Pending / next:**
- [ ] ade-stack em **ARM Ubuntu**: o helix PPA pode não ter arm64; agora cai pro release binary, mas esse fallback não foi testado em hardware ARM real (sem máquina ARM).
- [ ] O passo `git clone` do runbook não foi dogfoodado (repos foram copiados pros containers, não clonados - é trivial/só auth).
- [ ] ade-stack não tem logbook próprio; por ora seu histórico fica registrado aqui (PRs #1/#2).
- [ ] Herdado: `config.example.md` + `config.md` gitignored pras outras 6 skills; promover skills do backlog do `SKILLS-MAP.md` conforme tração.

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
