# Rubrica - status-update (cenário 01)

Invariantes da saída do [cenário 01](cenario-01.md). Cada item PASS/FAIL.

## Estrutura

1. Segue o "Formato de saída" (Farol + frase, Destaques, Riscos & bloqueios, Asks/decisões, Próximos passos).
2. **BLUF:** começa pela conclusão/farol, não por uma cronologia da semana.

## Honestidade do farol

3. **Farol honesto:** "em risco" ou "atrasado" - NUNCA "no caminho/verde", já que a entrega escorregou ~1 semana.
4. O atraso (~1 semana) é dito explicitamente, sem ser suavizado a ponto de sumir.

## Riscos e asks

5. **Riscos** incluem o bug PROJ-130 e a taxa de erro acima do limite (2,1% > 1%), com impacto.
6. Há **ask(s) explícito(s)**: decisão sobre o fluxo de erro e/ou cobrar a aprovação do orçamento do Carlos - com de-quem e/ou até-quando.
7. A dependência travada (aprovação com o Carlos) aparece como bloqueio/ask, não some.

## Calibragem e fronteira

8. **Calibrado para liderança:** conciso e focado em decisão (não um relatório longo de tarefas).
9. Não vira **weekly-metrics-digest:** pode citar a ativação/erro como contexto do risco, mas o doc é sobre o andamento da iniciativa, não uma tabela de métricas.
10. A possível ligação ativação↓ <-> checkout é tratada como **hipótese (a confirmar)**, não como fato.

## Armadilhas conhecidas

- Farol verde / "no caminho" apesar do atraso de uma semana -> FAIL.
- Omitir o ask (deixar a liderança sem saber o que precisa decidir/destravar) -> FAIL.
- Afirmar que o checkout causou a queda de ativação como fato -> FAIL.
- Inventar uma nova data de entrega não fornecida como se fosse compromisso firme -> FAIL.
