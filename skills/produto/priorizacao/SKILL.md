---
name: priorizacao
description: Use quando precisa decidir a ordem de um conjunto de itens (features, bugs, apostas) - "priorizar", "RICE", "ICE", "qual fazer primeiro", "rankear o backlog", "montar a fila do trimestre". Transforma a discussão de escopo em uma decisão auditável.
---

# Priorização

Transforma uma lista de candidatos em uma fila ordenada e **auditável**, usando um framework de pontuação (RICE por padrão). O valor não é o número final - é tornar explícita e discutível a premissa por trás de cada nota.

## Princípio que não pode ser quebrado

Nota sem premissa é achismo travestido de número. Cada fator pontuado vem com a premissa e a fonte (dado real vs **(assumido)**). E a escala é calibrada **antes** de pontuar - senão cada item infla a própria nota. Não invente números de alcance/impacto: se não há dado, é estimativa marcada como tal, e isso derruba a confiança.

## Configuração

- **Framework:** [RICE (padrão), ICE, WSJF] e a fórmula.
- **Escala de cada fator:** [âncoras de alto/médio/baixo para Reach, Impact, Confidence, Effort].
- **Fonte dos números:** [de onde vem o Reach - ex: analytics; quem valida].
- **Objetivo do período:** [a meta/tema contra o qual o Impact é medido].

## Passo 1 - Enquadrar

Priorizar PARA quê? Fixe o objetivo do período - é contra ele que o Impact de cada item é avaliado. Escolha o framework.

## Passo 2 - Calibrar a escala (antes de pontuar)

Defina, com âncoras concretas, o que é alto/médio/baixo em cada fator: Reach (quantos por período), Impact (efeito no objetivo: massivo/alto/médio/baixo/mínimo), Confidence (% conforme a evidência), Effort (pessoa-semanas). Calibrar antes evita que cada item puxe a régua para si.

## Passo 3 - Pontuar

Para cada item, dê a nota de cada fator + a premissa/fonte numa frase. Confidence reflete a qualidade da evidência, não o entusiasmo. Marque **(assumido)** onde não há dado.

## Passo 4 - Calcular e ranquear

Aplique a fórmula (RICE: Reach x Impact x Confidence / Effort). Ordene do maior para o menor score.

## Passo 5 - Sanity check

O topo faz sentido? Sinalize: itens de **baixa confiança** no topo (candidatos a discovery antes de buildar), itens **grandes demais para a nota** (quebrar em menores), e empates. A fila é uma recomendação para discutir, não um decreto.

## Formato de saída

```
# Priorização - [objetivo do período]

Framework: [RICE] · Escala calibrada: [resumo das âncoras]

| Item | R | I | C | E | Score | Premissa-chave |
|------|---|---|---|---|-------|----------------|
| ... | | | | | | ... [(assumido) onde aplicável] |

## Ranking
1. ...

## Notas
- Baixa confiança (discovery antes): ...
- Quebrar (grande demais): ...
- Premissas a validar: ...
```

## Exemplo (abreviado) - Acme (objetivo: subir ativação W4)

```
# Priorização - subir ativação W4

Framework: RICE · Escala: Reach = contas novas/mês; Impact 3/2/1/0,5; Confidence por evidência; Effort em pessoa-semanas

| Item | R | I | C | E | Score | Premissa-chave |
|------|---|---|---|---|-------|----------------|
| Onboarding guiado | 800 | 2 | 70% | 3 | 373 | Reach = contas novas/mês [analytics]; impacto alto pq ataca o 1º uso |
| Lembrete por e-mail D+3 | 800 | 1 | 80% | 1 | 640 | barato; impacto menor (assumido, sem teste) |
| Refazer o ranker | 200 | 2 | 30% | 5 | 24 | confiança baixa: hipótese não validada |

## Ranking
1. Lembrete D+3  2. Onboarding guiado  3. Refazer o ranker

## Notas
- Baixa confiança no ranker: discovery antes de buildar.
- "Onboarding guiado" pode ser grande demais para 1 nota: quebrar em tooltips vs tour.
```
