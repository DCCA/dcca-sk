# Cenário 01 - Derivar tech spec de um PRD

Mundo: [Acme](../../../../evals/empresa-ficticia/acme.md). Use SOMENTE estes dados. **Não afirme detalhes do codebase atual** que não foram dados - marque como (assumido) e liste para verificar.

## Config (teste)

- Stack: Next.js (App Router) + Supabase (Postgres) + Vercel
- Analytics: PostHog
- Convenção: migrações versionadas no Supabase

## PRD de entrada (resumo)

**Feature:** Onboarding guiado (tour de 3 passos).
**Problema:** ativação W4 abaixo da meta; contas novas não chegam ao 1º valor.
**Métrica de sucesso:** subir ativação W4.
**Requisitos:**
- Tour de 3 passos no primeiro login, cobrindo a ação-chave.
- Dispensável a qualquer momento.
- Reaparece só se não foi concluído.
- Instrumentado para medir efeito na ativação.
**Aberto no PRD:** qual é exatamente a "ação-chave" (pendente com Marina).

## Esperado

Uma tech spec que mapeia cada requisito numa mudança técnica, define schema/migração, API, UI, flag e eventos de analytics, lista riscos (incluindo a ação-chave indefinida), fatia em entregas independentes, e marca como (assumido) o que supõe do sistema atual.
