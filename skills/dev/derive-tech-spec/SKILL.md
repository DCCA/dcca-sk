---
name: derive-tech-spec
description: Use quando já tem um PRD/spec de produto pronto e quer o plano técnico - "transformar em tech spec", "plano técnico", "quais mudanças no schema", "quebrar em tarefas técnicas", antes de abrir issues ou começar a codar. Para escrever o PRD em si, é a prd-writer.
---

# Derive Tech Spec

Deriva um plano técnico de implementação a partir de um PRD. O plano **sai** do PRD e não o substitui: cada decisão técnica rastreia a um requisito de produto, e os riscos técnicos aparecem cedo.

## Princípio que não pode ser quebrado

Toda decisão técnica rastreia a um requisito do PRD - se uma mudança não serve a nenhum requisito, ela não entra (ou vira uma pergunta para o produto). E o que você assume sobre o sistema atual (schema, arquitetura, o que já existe) é marcado como **(assumido)** até verificado no código - não afirme a realidade do codebase de memória.

## Configuração

- **Stack:** [ex: Next.js, Supabase/Postgres, Vercel].
- **Convenções:** [padrões de schema, API, organização].
- **Analytics:** [onde e como eventos são instrumentados - ligar em `instrument-analytics`].

## Passo 1 - Mapear requisitos -> mudanças

Liste cada requisito do PRD e, ao lado, a mudança técnica que ele exige. Esse mapa é a espinha do doc.

## Passo 2 - Dados primeiro

Modelo de dados: novas tabelas/colunas, migrações, índices. Mudança de schema é a decisão mais cara de reverter - resolva antes da API/UI.

## Passo 3 - API e UI

Superfície de API (endpoints/contratos) e componentes de UI, derivados do comportamento do PRD.

## Passo 4 - Flags e analytics

Feature flags para rollout seguro e os eventos de analytics que medem a métrica de sucesso do PRD (sem eles a feature nasce cega).

## Passo 5 - Riscos e fatiamento

Riscos e incógnitas técnicas explícitos. Depois, fatie em **entregas independentes** (tracer bullets): cada fatia entrega valor ou aprendizado de ponta a ponta, não uma camada horizontal.

## Formato de saída

```
# Tech Spec - [feature] (deriva de: [PRD])

## Requisito -> mudança técnica
| Requisito (PRD) | Mudança |
|-----------------|---------|
| ... | ... |

## Modelo de dados / migração
...
## API
...
## UI
...
## Feature flags
...
## Eventos de analytics
...
## Riscos e incógnitas
- [risco] · [mitigação]
## Fatiamento (entregas independentes)
1. [fatia ponta a ponta]

Suposições sobre o sistema atual (a verificar): [lista, ou "nenhuma"]
```

## Exemplo (abreviado) - Acme

```
# Tech Spec - Onboarding guiado (deriva de: PRD Onboarding guiado)

## Requisito -> mudança técnica
| Requisito | Mudança |
|-----------|---------|
| Tour de 3 passos no 1º login | componente de tour + estado de progresso por conta |
| Reaparece só se não concluído | flag `onboarding_tour_done` na conta |

## Modelo de dados / migração
- Coluna `onboarding_tour_done boolean default false` em `accounts` (assumido: existe a tabela `accounts`).

## API
- `PATCH /accounts/me` aceitando `onboarding_tour_done`.

## UI
- Componente `<GuidedTour>` montado no primeiro login.

## Feature flags
- `flag: guided_onboarding` para rollout gradual.

## Eventos de analytics
- `onboarding_tour_started`, `onboarding_tour_completed` (alimentam a ativação W4).

## Riscos e incógnitas
- Definição de "ação-chave" ainda aberta no PRD · bloqueia a medição de sucesso.

## Fatiamento
1. Coluna + flag + evento (instrumentação) - mede baseline.
2. Componente do tour atrás da flag.
3. Rollout gradual + leitura.

Suposições sobre o sistema atual (a verificar): tabela `accounts` existe; auth expõe "primeiro login".
```
