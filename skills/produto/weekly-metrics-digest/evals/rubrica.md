# Rubrica - weekly-metrics-digest (cenário 01)

Invariantes que a saída do [cenário 01](cenario-01.md) TEM que satisfazer. Cada item é PASS/FAIL.

## Estrutura

1. Segue o "Formato de saída" (manchete + tabela + Anomalias e leitura + Guardrails + Qualidade do dado).
2. **Manchete** captura a história específica da semana (boa no geral, mas com churn estourando o limite e conversão caindo) - não é genérica do tipo "métricas da semana".

## Leitura das métricas

3. Cada métrica da tabela tem valor + variação WoW + (vs meta, quando há meta).
4. Cada métrica tem um **sinal** (estável / melhora / piora / anomalia).
5. **Ativação W4** reportada como **melhora** (47% subiu de 45% e está na/acima da meta).
6. **Conversão do checkout** (queda de 0,8 pp) sinalizada como piora/atenção - não ignorada nem chamada de estável.

## Guardrails e anomalias

7. **Churn** (1,4%, acima do limite de 1,2%) destacado como **guardrail estourado / anomalia** - não pode passar batido, mesmo sendo um número pequeno.
8. **Taxa de erro do checkout** (estável, dentro do limite) ainda assim aparece nos guardrails.
9. Causa para conversão↓ e/ou churn↑ vem como **hipótese (a confirmar)**, não como fato; a campanha de marketing aparece como insumo de hipótese (ex: tráfego menos qualificado), não como causa provada.

## Honestidade

10. **Retenção M1:** a ressalva de confiabilidade (coorte pequena por feriado, número volátil) é dita - não apresenta os 31% como sólido.
11. Não vira **status-update**: a saída fala só de números/métricas, não de tarefas, entregas ou andamento de projeto.

## Armadilhas conhecidas

- Afirmar "a campanha causou a queda de conversão" como fato, sem marcar como hipótese -> FAIL.
- Deixar o churn estourado (1,4% > 1,2%) passar sem destaque -> FAIL.
- Apresentar a Retenção M1 (31%) sem a ressalva da coorte pequena -> FAIL.
- Inventar qualquer número não fornecido no cenário -> FAIL.
