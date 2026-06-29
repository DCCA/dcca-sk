# Empresa fictícia: Acme

Empresa de mentira, coerente e reutilizável, para testar as skills sem dados reais e sem conector. **Tudo aqui é inventado.** Os cenários de eval de cada skill puxam deste universo, então o mundo é o mesmo entre skills (a `daily-review`, o `status-update` e o `weekly-metrics-digest` testam contra a mesma Acme).

Mantenha a Acme estável: mudar uma persona ou métrica aqui afeta todos os cenários que dependem dela.

## A empresa

Acme é uma SaaS B2B de gestão financeira para PMEs. Produto: a plataforma Acme (web + app). O squad do usuário é o **squad-core** (áreas: Checkout, Onboarding, Ativação).

## Você (quem usa as skills)

- Papel: Product Manager do squad-core.
- Handle no Slack: `@voce`.
- Reporta para: Ana (Head of Product).

## Pessoas

| Nome | Papel | Relação com você | Handle |
|------|-------|------------------|--------|
| Ana | Head of Product | sua chefe (VIP) | `@ana` |
| Carlos | Growth Lead | par; dono do orçamento de growth (VIP) | `@carlos` |
| Bia | Engenheira (squad-core) | par | `@bia` |
| João | Designer (squad-core) | par | `@joao` |
| Marina | Data Analyst | apoia o squad em métricas | `@marina` |
| Diego | Engineering Manager | par de liderança | `@diego` |

## Slack

- Canais prioritários (allowlist típica): `#squad-core`.
- Outros: `#produto`, `#growth`, `#geral`, `#incidentes`.

## Jira (projeto PROJ)

- Status do board: Backlog -> To Do -> In Progress -> Code Review -> Blocked -> Done.
- Temas/épicos: Checkout, Onboarding, Ativação.
- Tickets recorrentes (exemplos): `PROJ-123` "Integração de pagamentos" (Checkout), `PROJ-130` "Bug no checkout" (Checkout), `PROJ-145` "Novo fluxo de onboarding" (Onboarding).

## E-mail

- VIPs: Ana, Carlos. Domínio: `@acme.com`.

## Calendário (rituais típicos)

- Seg 10:00 "Sync de roadmap" (Ana + squad).
- 1:1 com Ana (semanal).
- "Review de experimento" (squad-core).
- Daily do squad.

## Glossário

- **ativação W1 / W4**: % de contas novas que ativam na 1ª / 4ª semana (north star do squad é a W4).
- **Checkout, Onboarding, Ativação**: áreas do produto.
- **ranker**: modelo interno de ordenação (feature).
- **squad-core**: o squad do usuário.

## Métricas (para skills de dados)

- Ativação W4 (north star), Retenção M1, Conversão do checkout, MRR.
- Os valores concretos (e variações WoW) ficam no cenário específico de cada eval, não aqui.
