# Mapa de Skills

Planejamento das agent skills deste repositório. Foco **lean**: só o que eu realmente uso fica instalado; o resto é ideia parada até virar recorrente.

**Princípio agnóstico a empresa:** nenhuma skill carrega configuração final (nomes, canais, produtos, métricas, ferramentas). O método/estrutura fica fixo; só a calibração, o glossário e os destinos viram config. Assim as skills são portáteis entre empregos.

## Em uso

- `daily-review` (produto) - fecha o dia anterior e prepara o atual a partir das fontes conectadas (calendário, e-mail, Slack, GitHub, rastreador, transcrições). Pessoal e interno.
- `capturar-config-claude` (dev) - traz mudanças do `~/.claude` de volta pro repo (roda `capture.sh`, revisa o diff sem vazar segredo/path, sobe via PR). Infra do próprio repo.

## Removidas (construídas, não usadas)

Um núcleo de "geradores de artefato de PM" foi construído e validado por eval, mas **não pegou tração no uso real**, então saiu do repo (histórico preservado no git): `metric-definition`, `weekly-metrics-digest`, `priorizacao`, `prd-writer`, `derive-tech-spec`, `status-update`.

**Lição:** construir uma skill quando a tarefa vira recorrente, não especulativamente. Passar na eval não é sinal de que vai ser usada. O gatilho para (re)construir qualquer uma - destas ou do backlog abaixo - é o mesmo: virou rotina de verdade.

## Ideias paradas (backlog, não construídas)

Não somem, só não estão em foco. Promover só quando a necessidade for real e recorrente.

- **Discovery:** `discovery-synthesis`, `interview-guide`.
- **Experimentação:** `instrument-analytics`, `experiment-design`, `experiment-readout`, `funnel-cohort-analysis`.
- **Planejamento:** `roadmap-planning`, `okr-drafting`, `growth-loop-mapping`.
- **Lançamento:** `launch-checklist`, `launch-announcement`.
- **Registro / incidente:** `product-decision-log`, `postmortem`.
- **Escrita:** `one-pager`, `stakeholder-message`.
- **Dev / higiene:** `pr-description`, `release-notes`, `tech-feasibility`.
