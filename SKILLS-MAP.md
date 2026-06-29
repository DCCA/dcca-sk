# Mapa de Skills

Planejamento das agent skills deste repositório: o que construir, em que ordem, e onde estão as fronteiras (cada skill = um propósito, sem gatilhos colidindo). Foco **lean**: um núcleo essencial pequeno; o resto fica no backlog até ganhar tração.

**Princípio agnóstico a empresa:** nenhuma skill carrega configuração final (nomes, canais, produtos, métricas, ferramentas). O método/estrutura fica fixo; só a calibração, o glossário, as ferramentas e os destinos viram config. Assim as skills são portáteis entre empregos.

Status: **feito** · **núcleo** (construir agora) · **backlog** (depois) · **fundida** · **cortada**.

## Feito

- `daily-review` (produto) - fecha o dia anterior e prepara o atual a partir das fontes conectadas (calendário, e-mail, Slack, GitHub, Jira/rastreador, transcrições). Pessoal e interno.
- `metric-definition` (produto) - produz a metric spec (fonte única de verdade de uma métrica): expõe decisões escondidas, reconcilia divergências, não inventa número.
- `weekly-metrics-digest` (produto) - resumo semanal das métricas virado para o sinal: variação WoW, anomalias com hipótese, guardrails, lacunas de dado. Só a metade quantitativa.

## Núcleo essencial (construir agora)

A espinha: **métrica -> número -> decisão -> spec -> build -> reporte**.

| # | Skill | Categoria | Por que agora |
|---|-------|-----------|---------------|
| 1 | `priorizacao` | produto | Achismo vira decisão auditável (RICE/ICE). Uso quase contínuo, sem dependências. |
| 2 | `prd-writer` | produto | Artefato central; força a métrica de sucesso antes da solução; alimenta o `derive-tech-spec`. |
| 3 | `derive-tech-spec` | dev | Ponte PRD -> plano técnico na stack real. Maior alavancagem do PM que codifica. |
| 4 | `status-update` | escrita | Progresso semanal para a liderança; reaproveita a saída do `weekly-metrics-digest`. |

**Próximas (em ordem):** `priorizacao` -> `prd-writer` -> `derive-tech-spec` -> `status-update`. (`metric-definition` e `weekly-metrics-digest` já feitos.)

## Backlog (depois - não some, só sai do foco)

Critério para promover do backlog: virou recorrente, ou uma dependência do núcleo passou a precisar.

**Discovery / pesquisa** (episódico, por ciclo)
- `discovery-synthesis` - síntese rigorosa de pesquisa (fato x interpretação, evidência, JTBD).
- `interview-guide` - o "antes" do discovery; construir como par com a `discovery-synthesis`.

**Experimentação** (quando houver A/B; dependem de `metric-definition`)
- `instrument-analytics` - feature nasce mensurável. 1º candidato a promover.
- `experiment-design` - pré-registra hipótese e amostra. Par com o readout.
- `experiment-readout` - leitura do A/B vira decisão defensável.
- `funnel-cohort-analysis` - funil/coorte; investigação pontual (o digest cobre o número semanal).

**Planejamento** (trimestral)
- `roadmap-planning` - now/next/later ligado a objetivos.
- `okr-drafting` - redige metas; avaliar fundir no `roadmap-planning`.
- `growth-loop-mapping` - modelo causal do crescimento; estratégico ocasional.

**Lançamento** (só em launches; pacote único)
- `launch-checklist` - checagem repetível; sucesso e rollback definidos. Absorve o QA-como-usuário.
- `launch-announcement` - anúncio por audiência; consome a `release-notes`.

**Registro / incidente** (baixa frequência)
- `product-decision-log` - ADR de produto; pode começar como doc simples.
- `postmortem` - RCA blameless após incidente.

**Escrita / comunicação**
- `one-pager` - buy-in pré-PRD.
- `stakeholder-message` - comunicação sensível (atraso, "não", escalar).

**Dev / higiene**
- `pr-description` - padroniza PRs; mais snippet que skill.
- `release-notes` - changelog derivado do git; baixa frequência.
- `tech-feasibility` - sizing ocasional; sobrepõe ao `derive-tech-spec`.

## Cortada / fundida

- **Cortada:** `product-acceptance-review` - duplicava o eixo Spec de um review genérico; o QA-como-usuário foi dobrado no `launch-checklist`.
- **Fundida:** `stakeholder-update` -> `status-update` (mesmo artefato; a `status-update` herdou "adaptar tom por audiência"). `executive-summary` -> embutida onde for usada (BLUF dentro de `status-update` e `one-pager`), não standalone.

## Fronteiras (colisões de gatilho resolvidas)

- `daily-review` x `status-update` x `weekly-metrics-digest`: pessoal/agenda x andamento externo x métricas de negócio.
- `prd-writer` x `one-pager`: spec completa x doc leve de buy-in pré-PRD.
- `release-notes` x `launch-announcement`: deriva changelog do git x consome e foca na mensagem por público.
- `funnel-cohort-analysis` x `growth-loop-mapping`: diagnóstico tático x mapa do motor (modelo causal).
