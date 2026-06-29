---
name: status-update
description: Use quando vai reportar o andamento de uma iniciativa para stakeholders ou liderança - "status update", "weekly", "reportar progresso", "atualização para a liderança", "business review", "mandar o status do squad". É o andamento (externo); para a rotina pessoal do dia use a daily-review, para a leitura de números use a weekly-metrics-digest.
---

# Status Update

Atualização recorrente de progresso para quem está de fora do dia a dia. Estrutura em pirâmide: a liderança lê o farol primeiro e decide se aprofunda. O alvo é construir confiança - e confiança se constrói com honestidade, não com verde.

## Princípio que não pode ser quebrado

Comece pela conclusão (BLUF), não pela cronologia. E o farol é honesto: um verde que esconde um risco destrói mais confiança do que um amarelo assumido. Risco e ask vêm explícitos, nunca enterrados. Não infle progresso nem invente datas - se algo está atrasado ou incerto, diga, com o impacto e o plano.

## Configuração

- **Audiência:** [liderança / stakeholders / cliente] - calibra tom e nível de detalhe.
- **Cadência:** [semanal / quinzenal / mensal].
- **Iniciativa(s) e dono:** [o que está sendo reportado].
- **Métricas de referência:** [as que contextualizam o progresso - ligar em `weekly-metrics-digest`, sem virar o digest].

## Passo 1 - Farol honesto

Classifique: **no caminho / em risco / atrasado**, com uma frase de status. Esta é a única coisa que parte da audiência vai ler - tem que ser fiel à realidade.

## Passo 2 - Destaques

O que avançou desde o último update, ligado ao objetivo/métrica (não uma lista de tarefas concluídas). Foque no que muda a leitura de quem lê.

## Passo 3 - Riscos e bloqueios

O que ameaça a entrega, com impacto e mitigação. Um risco sem impacto e sem plano é só ansiedade; com eles, é gestão.

## Passo 4 - Asks / decisões

O que você precisa, de quem, até quando. Seja explícito - a liderança existe para destravar, mas não adivinha o ask.

## Passo 5 - Próximos passos e calibragem

Os próximos passos concretos. Depois, calibre tom e detalhe pela audiência: liderança quer decisão e farol; um par quer mais detalhe.

## Formato de saída

```
# [Iniciativa] - status [data]

**Farol:** [no caminho / em risco / atrasado] - [frase de status]

## Destaques
- ...
## Riscos & bloqueios
- [risco] · impacto: ... · mitigação: ...
## Asks / decisões
- [o quê] · de quem · até quando
## Próximos passos
- ...
```

## Exemplo (abreviado) - Acme

```
# Onboarding guiado - status 13/jul

**Farol:** Em risco - escopo de pé, mas a medição está bloqueada por uma definição pendente.

## Destaques
- Tour de 3 passos pronto atrás da flag; instrumentação no ar.

## Riscos & bloqueios
- "Ação-chave" da ativação ainda indefinida · impacto: não dá pra medir sucesso nem decidir GA · mitigação: fechar a definição com Data.

## Asks / decisões
- Definir a "ação-chave" da ativação W4 · de: Marina (Data) · até: sex 18/jul.

## Próximos passos
- Rollout para 10% assim que a métrica estiver definida; leitura em 1 semana.
```
