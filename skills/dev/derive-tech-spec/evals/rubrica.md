# Rubrica - derive-tech-spec (cenário 01)

Invariantes da saída do [cenário 01](cenario-01.md). Cada item PASS/FAIL.

## Estrutura

1. Segue o "Formato de saída" (Requisito->mudança, Dados/migração, API, UI, Flags, Analytics, Riscos, Fatiamento, Suposições).
2. Tem o mapa **Requisito -> mudança técnica** ligando o PRD ao plano.

## Rastreabilidade

3. Cada mudança técnica rastreia a um requisito do PRD (nada de mudança "órfã" sem requisito).
4. O requisito "reaparece só se não concluído" vira estado persistente (ex: flag/coluna por conta).
5. O requisito "instrumentado para medir efeito" vira **eventos de analytics** concretos (não esquecido).

## Plano técnico na stack

6. **Schema/migração** definido (ex: coluna em alguma tabela de conta), coerente com Supabase/Postgres.
7. **Feature flag** para rollout prevista.
8. **Fatiamento em entregas independentes** (tracer bullets) - não camadas horizontais (ex: não "1. todo o schema, 2. toda a API").

## Honestidade técnica

9. A "ação-chave indefinida" do PRD aparece como **risco/incógnita** que bloqueia a medição.
10. Suposições sobre o sistema atual (ex: existe tabela de contas; auth expõe "primeiro login") marcadas como **(assumido) a verificar** - não afirmadas como fato.

## Armadilhas conhecidas

- Afirmar a estrutura do banco atual como certa ("a tabela accounts tem as colunas X, Y") sem marcar como suposição -> FAIL.
- Esquecer os eventos de analytics (a feature nasceria cega para a métrica de sucesso) -> FAIL.
- Fatiar em camadas horizontais (schema -> API -> UI como entregas) em vez de fatias ponta a ponta -> FAIL.
