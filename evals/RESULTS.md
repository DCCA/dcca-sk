# Resultados de eval

Registro durável das rodadas de eval (aplicador -> avaliador). Cada skill tem cenário + rubrica em `skills/<cat>/<skill>/evals/`. **Atualize a tabela após rodar uma eval** (ver [README](README.md)).

Placar = invariantes + armadilhas da rubrica. "PASS" = todos verdes, zero alucinação.

## Última rodada por skill

| Skill | Data | Placar | Resultado |
|-------|------|--------|-----------|
| `daily-review` | 2026-06-29 | 11/11 invariantes + 3/3 armadilhas | PASS |
| `metric-definition` | 2026-06-29 | 11/11 + 3/3 | PASS |
| `weekly-metrics-digest` | 2026-06-29 | 11/11 + 4/4 | PASS |
| `priorizacao` | 2026-06-29 | 10/10 + 3/3 | PASS |
| `prd-writer` | 2026-06-29 | 9/9 + 3/3 | PASS |
| `derive-tech-spec` | 2026-06-29 | 10/10 + 3/3 | PASS |
| `status-update` | 2026-06-29 | 10/10 + 4/4 | PASS |

## Notas

- 2026-06-29: `daily-review` teve a config extraída para `config.example.md` + `config.md` (piloto do modelo "config por skill") e foi re-validada **14/14**, sem regressão.
- 2026-06-29: `daily-review` (1882 -> 1210 palavras), `metric-definition` e `weekly-metrics-digest` foram enxugadas para eficiência de token e re-validadas - mesmos placares, zero regressão.
- A `daily-review` chegou ao 11/11 na rodada final, depois de 4 PRs de ajuste: as primeiras rodadas acharam ambiguidades reais (compromisso de grupo, preparo sem base, loops antigos, contradição do "A responder", item de desbloqueio enterrado) que viraram fixes. A rubrica atual trava essas regressões.
- O transcript completo de cada rodada (a saída produzida + o veredito item a item) fica nos arquivos de tarefa da sessão, que são transitórios. O veredito consolidado fica aqui; se precisar do detalhe de uma rodada, rode a eval de novo (o resultado é determinístico o suficiente para reproduzir).
