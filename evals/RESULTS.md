# Resultados de eval

Registro durável das rodadas de eval (aplicador -> avaliador). Cada skill tem cenário + rubrica em `skills/<cat>/<skill>/evals/`. **Atualize a tabela após rodar uma eval** (ver [README](README.md)).

Placar = invariantes + armadilhas da rubrica. "PASS" = todos verdes, zero alucinação.

## Última rodada por skill

| Skill | Data | Placar | Resultado |
|-------|------|--------|-----------|
| `daily-review` | 2026-06-29 | 11/11 invariantes + 3/3 armadilhas | PASS |
| `capturar-config-claude` (retired) | 2026-07-03 | 8/8 invariantes (rubrica comportamental) | PASS |
| regras do `AGENTS.md` externo ([eval](regras-agents-md/README.md)) | 2026-08-09 | 39/40 trials (40/40 reais; 1 falso negativo do juiz) | PASS |

## Notas

- `capturar-config-claude` foi aposentada quando o dcca-env assumiu a configuracao de agentes; o resultado historico permanece. A eval de policy agora recebe o arquivo canonico externo por `--agents-file`.
- 2026-06-29: `daily-review` teve a config extraída para `config.example.md` + `config.md` (piloto do modelo "config por skill") e foi re-validada **14/14**, sem regressão.
- 2026-06-29: `daily-review` foi enxugada (1882 -> 1210 palavras) para eficiência de token e re-validada - mesmo placar, zero regressão.
- As skills de artefato de PM (`metric-definition`, `weekly-metrics-digest`, `priorizacao`, `prd-writer`, `derive-tech-spec`, `status-update`) foram removidas do repo por não terem uso real (histórico no git). Passavam nas evals; o corte é de tração, não de qualidade. Ver [`SKILLS-MAP.md`](../SKILLS-MAP.md).
- A `daily-review` chegou ao 11/11 na rodada final, depois de 4 PRs de ajuste: as primeiras rodadas acharam ambiguidades reais (compromisso de grupo, preparo sem base, loops antigos, contradição do "A responder", item de desbloqueio enterrado) que viraram fixes. A rubrica atual trava essas regressões.
- 2026-08-09: primeira eval de **regra de comportamento** (não de skill) - as regras do `AGENTS.md` acrescentadas no #51. Duas rodadas completas de 8 casos x 5 trials: as regras deram **80/80 reais**, com 2 e depois 1 falso negativo do juiz. Cada regra é testada em par (`*-fire` = dispara quando deve, `*-nofire` = fica quieta quando não deve); o `nofire` do "mostre 2-3 opções" deu 10/10 nas duas rodadas, ou seja a regra não vira imposto numa mudança de uma linha. Custo: ~US$ 45 no total das duas rodadas.
- 2026-08-09: a primeira rodada achou dois defeitos **da própria eval**, não das regras: o juiz só via a mensagem final do agente (reprovava uma rodada que fez o trabalho mas resumiu outra coisa - resolvido passando o diff real pro juiz), e um probe de preflight tinha escrito dentro da `fixture/`, mudando calado o cenário de todos os trials (resolvido com fixture read-only + manifesto sha256 conferido no fim). Eval sem auditoria do próprio harness mede o harness, não a regra.
- O transcript completo de cada rodada (a saída produzida + o veredito item a item) fica nos arquivos de tarefa da sessão, que são transitórios. O veredito consolidado fica aqui; se precisar do detalhe de uma rodada, rode a eval de novo (o resultado é determinístico o suficiente para reproduzir).
