# Rubrica - priorizacao (cenário 01)

Invariantes da saída do [cenário 01](cenario-01.md). Cada item PASS/FAIL.

## Estrutura e método

1. Segue o "Formato de saída" (tabela com R, I, C, E, Score, premissa + ranking + notas).
2. A **escala é calibrada** (âncoras de Reach/Impact/Confidence/Effort declaradas) antes/junto da pontuação.
3. O **Score** é calculado pela fórmula RICE (R x I x C / E) e o **ranking segue o score** (do maior pro menor).

## Premissas e honestidade

4. Cada item tem uma **premissa/fonte** por trás da nota, não só números soltos.
5. Itens sem dado real (lembrete D+3, ranker) têm o impacto/confiança marcado como **(assumido)** ou confiança baixa - não apresentados como medidos.
6. **Confidence reflete a evidência:** o ranker (hipótese sem evidência) recebe confiança baixa; itens com dado de Reach (analytics) têm confiança maior nesse fator.
7. Reach usa o número dado (~800 contas novas/mês; ~200 na home) - não inventa outro.

## Julgamento

8. O **ranker** (baixa confiança, esforço alto) é sinalizado como candidato a **discovery antes de buildar** e/ou fica no fim do ranking.
9. **Migrar o billing** é sinalizado como **fora do objetivo** (não move ativação) - não compete de igual pra igual pela prioridade do tema.
10. O objetivo do período (ativação W4) ancora a avaliação de Impact de cada item.

## Armadilhas conhecidas

- Inventar um número de Reach/Impact onde o cenário não deu (ex: cravar "+5% de ativação") -> FAIL.
- Dar confiança alta ao ranker (que é hipótese sem evidência) -> FAIL.
- Ranquear o billing no topo por esforço/voz do Diego, ignorando que está fora do objetivo -> FAIL.
