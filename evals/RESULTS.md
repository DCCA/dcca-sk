# Resultados de eval

Registro durável das rodadas de eval (aplicador -> avaliador). Cada skill tem cenário + rubrica em `skills/<cat>/<skill>/evals/`. **Atualize a tabela após rodar uma eval** (ver [README](README.md)).

Placar = invariantes + armadilhas da rubrica. "PASS" = todos verdes, zero alucinação.

## Última rodada por skill

| Skill | Data | Placar | Resultado |
|-------|------|--------|-----------|
| `daily-review` | 2026-06-29 | 11/11 invariantes + 3/3 armadilhas | PASS |
| `capturar-config-claude` | 2026-07-03 | 8/8 invariantes (rubrica comportamental) | PASS |

## Notas

- 2026-06-29: `daily-review` teve a config extraída para `config.example.md` + `config.md` (piloto do modelo "config por skill") e foi re-validada **14/14**, sem regressão.
- 2026-06-29: `daily-review` foi enxugada (1882 -> 1210 palavras) para eficiência de token e re-validada - mesmo placar, zero regressão.
- As skills de artefato de PM (`metric-definition`, `weekly-metrics-digest`, `priorizacao`, `prd-writer`, `derive-tech-spec`, `status-update`) foram removidas do repo por não terem uso real (histórico no git). Passavam nas evals; o corte é de tração, não de qualidade. Ver [`SKILLS-MAP.md`](../SKILLS-MAP.md).
- A `daily-review` chegou ao 11/11 na rodada final, depois de 4 PRs de ajuste: as primeiras rodadas acharam ambiguidades reais (compromisso de grupo, preparo sem base, loops antigos, contradição do "A responder", item de desbloqueio enterrado) que viraram fixes. A rubrica atual trava essas regressões.
- O transcript completo de cada rodada (a saída produzida + o veredito item a item) fica nos arquivos de tarefa da sessão, que são transitórios. O veredito consolidado fica aqui; se precisar do detalhe de uma rodada, rode a eval de novo (o resultado é determinístico o suficiente para reproduzir).
