# Project Status - dcca-sk

Logbook do repositório. Entradas em ordem reversa (mais recente no topo). Cada entrada registra onde estávamos, o que mudou e o que ficou pendente.

---

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
