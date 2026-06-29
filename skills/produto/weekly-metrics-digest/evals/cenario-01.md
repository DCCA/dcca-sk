# Cenário 01 - Semana boa com um guardrail estourado

Mundo: [Acme](../../../../evals/empresa-ficticia/acme.md). Use SOMENTE os dados abaixo. **Não invente números** nem apresente causa como fato (causa é hipótese até confirmar).

## Config (teste)

- Métricas a acompanhar: Ativação W4 (north star), Conversão do checkout, MRR
- Guardrails: Taxa de erro do checkout (limite < 1%), Churn semanal (limite < 1,2%)
- Ferramenta: PostHog; dono: Marina (Data)

## Pedido

"Monta o digest de métricas dessa semana."

## Período

Semana 7-13/jul/2026, comparada com a semana anterior (30/jun-6/jul).

## Números (desta semana | semana anterior | meta)

- **Ativação W4:** 47% | 45% | meta 45%
- **Conversão do checkout:** 11,2% | 12,0% | meta 13%
- **MRR:** R$ 320k | R$ 315k | (sem meta)
- **Taxa de erro do checkout** (guardrail): 0,7% | 0,8% | limite < 1%
- **Churn semanal** (guardrail): 1,4% | 1,0% | limite < 1,2%
- **Retenção M1:** 31% nesta leitura, MAS a coorte de origem teve poucos signups (semana de feriado), então o número está volátil.

## Contexto da semana

- Uma campanha de marketing trouxe um volume grande de tráfego novo nesta semana.
