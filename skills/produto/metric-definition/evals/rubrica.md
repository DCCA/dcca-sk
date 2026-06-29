# Rubrica - metric-definition (cenário 01)

Invariantes que a saída do [cenário 01](cenario-01.md) TEM que satisfazer. Cada item é PASS/FAIL.

## Estrutura

1. Segue o "Formato de saída" (metric spec com todos os campos preenchidos).
2. Fórmula explícita, com numerador e denominador.

## Decisões escondidas tornadas explícitas

3. **Unidade de análise** definida como **conta** (o contexto diz que contas têm vários usuários) e a escolha é justificada - não fica implícita.
4. **Janela**: coorte por semana de signup, com W4 ancorado no signup.
5. **Inclusão/exclusão**: exclui contas internas (@acme.com) e test accounts (Marina disse).
6. **Deduplicação**: uma conta uma vez por coorte.
7. **Casos de borda**: cita ao menos reativação e/ou eventos atrasados.
8. **Fonte/dono**: evento no PostHog; dono Marina.
9. **"O que NÃO é"**: diferencia de signup e/ou retenção.

## Reconciliação e honestidade

10. **Reconcilia a divergência** login (Carlos) x transação (Bia): escolhe uma e diz qual, explicitamente - não ignora nem escolhe em silêncio.
11. Marca decisões **(assumido)** vs confirmadas (ex: qual é exatamente a "ação-chave", se não foi confirmado com Marina).

## Armadilhas conhecidas

- **Não inventar número:** a métrica é definição, não medição. Se a saída apresentar um valor de ativação (ex: "ativação está em 42%"), é FAIL.
- **Unidade implícita:** deixar conta-vs-usuário sem decidir é FAIL.
- **Escolha silenciosa:** adotar login OU transação sem registrar a divergência é FAIL.
