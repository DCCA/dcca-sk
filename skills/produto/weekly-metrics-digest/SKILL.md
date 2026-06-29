---
name: weekly-metrics-digest
description: Use quando quer o resumo semanal das métricas do produto/squad - "digest de métricas", "review semanal de números", "como foram os números essa semana", olhar a variação WoW e tendência, ou caçar anomalias. É só a metade quantitativa (números); para andamento de iniciativa use o status-update, para a rotina pessoal do dia use o daily-review.
---

# Weekly Metrics Digest

Resumo semanal das métricas que importam, virado para o sinal, não para o despejo de números. O alvo: em dois minutos, saber o que mudou, o que é anomalia, o que provavelmente explica e o que fazer.

## Princípio que não pode ser quebrado

Número sem movimento e sem leitura é ruído. Toda métrica reportada vem com três coisas: o **valor**, a **variação** (vs semana passada e/ou vs meta) e um **sinal** (estável / melhora / piora / anomalia). E honestidade dura: **não invente causa**. Uma explicação para um movimento é uma **hipótese** até ser confirmada - marque como hipótese e diga o que checar. Se um dado está faltando ou quebrado, diga; nunca estime um número e o apresente como medido.

## Configuração

- **Métricas a acompanhar:** [north star do squad + as principais] - cada uma deve ter definição (ver `metric-definition`).
- **Guardrails:** [métricas que não podem piorar - ex: taxa de erro, churn] - reportadas sempre, mesmo estáveis.
- **Metas / baselines:** [a meta de cada métrica, se houver].
- **Ferramenta e dono:** [onde os números vivem; quem é a fonte].

## Passo 1 - Ancorar a semana e a comparação

Fixe o período coberto (a semana) e contra o que comparar: semana anterior (WoW) e meta, quando houver. Use as métricas **já definidas** (suas metric specs). Se uma métrica reportada não tem definição clara, sinalize - não compare maçã com laranja.

## Passo 2 - Ler cada métrica

Para cada métrica da config: valor da semana, variação (WoW e vs meta), e classifique o sinal (estável / melhora / piora / anomalia). Guardrails entram mesmo quando estáveis.

## Passo 3 - Anomalias e leitura

Para cada movimento relevante (e todo guardrail fora do limite): levante a causa provável como **hipótese** (marcada como tal) e diga o que checar para confirmar. Conecte movimentos que podem estar ligados, mas sem afirmar causalidade. Pistas de contexto (deploys, campanhas) são insumo de hipótese, não prova.

## Passo 4 - Qualidade do dado

Se houve gap, instrumentação quebrada, janela incompleta ou métrica sem definição, registre numa seção de lacunas. Um número parcial sinalizado vale mais que um número cheio e falso.

## Formato de saída

```
# Digest de métricas - [período, ex: 23-29/jun]

**Manchete:** [a história da semana em uma linha]

| Métrica | Valor | vs semana passada | vs meta | Sinal |
|---------|-------|-------------------|---------|-------|
| ... | ... | ... | ... | ... |

## Anomalias e leitura
- [métrica que mexeu]: [o movimento]. Hipótese: [causa provável] (a confirmar). Checar: [o quê].

## Guardrails
- [guardrail]: [status vs limite]

## Qualidade do dado / lacunas
- [gap ou "nenhuma"]
```

## Exemplo (abreviado) - Acme

```
# Digest de métricas - 23-29/jun

**Manchete:** Semana ruim no checkout - erro disparou e ativação caiu; possível ligação com o deploy de quarta (a confirmar).

| Métrica | Valor | vs sem. passada | vs meta | Sinal |
|---------|-------|-----------------|---------|-------|
| Ativação W4 (north star) | 38% | -6 pp (44%) | -7 pp (meta 45%) | piora |
| Conversão do checkout | 12,0% | -0,1 pp | -1 pp | estável |
| MRR | R$ 312k | +2,3% | - | melhora |

## Anomalias e leitura
- Taxa de erro do checkout: 2,1% (era 0,6%), acima do limite de 1%. Hipótese: o deploy do novo fluxo de checkout (qua 25/jun) (a confirmar). Checar: logs de erro pós-deploy e considerar rollback.
- Ativação W4: queda de 6 pp. Hipótese: pode estar ligada ao erro do checkout travando o primeiro fluxo (a confirmar). Checar: funil de ativação por dia.

## Guardrails
- Taxa de erro do checkout: 2,1% - ACIMA do limite (1%). Vermelho.
- Churn semanal: 0,9% - dentro do limite (1,2%). Estável.

## Qualidade do dado / lacunas
- Retenção M1: instrumentação do evento quebrou na qui 26/jun; semana parcial, sem número confiável.
```
