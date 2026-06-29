# Cenário 01 - Priorizar o backlog para subir ativação W4

Mundo: [Acme](../../../../evals/empresa-ficticia/acme.md). Use SOMENTE estes dados. **Não invente números** de alcance/impacto - onde não houver dado, é estimativa marcada como (assumido), com confiança menor.

## Config (teste)

- Framework: RICE
- Reach: contas novas por mês (do PostHog)
- Objetivo do período: subir a Ativação W4

## Pedido

"Prioriza esse backlog pra gente decidir o que atacar primeiro neste trimestre, mirando ativação W4."

## Itens candidatos (info crua coletada)

1. **Onboarding guiado (tour)** - atinge todas as contas novas (o PostHog mostra ~800 contas novas/mês). Ideia: guiar o primeiro uso. Estimativa de esforço da Bia: ~3 pessoas-semanas. Ataca diretamente o primeiro uso. Sem teste ainda.
2. **Lembrete por e-mail D+3** - dispara para as mesmas ~800 contas novas/mês. Esforço baixo (~1 pessoa-semana). Ninguém testou; o impacto é um palpite.
3. **Refazer o ranker da home** - atinge ~200 contas/mês que chegam na home. Esforço alto (~5 pessoas-semanas). É uma hipótese sem evidência de que mexe em ativação.
4. **Migrar o billing para outro provedor** - não tem relação com ativação; é dívida técnica que o Diego quer fazer.

## Esperado

Uma priorização RICE com a escala calibrada, premissa/fonte por nota, marcando o que é (assumido), confiança refletindo a evidência, e sinalizando itens de baixa confiança / fora do objetivo.
