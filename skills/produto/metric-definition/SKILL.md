---
name: metric-definition
description: Use quando precisa cravar a definição de uma métrica de forma inequívoca - "como a gente define X", "qual a fórmula de ativação/retenção/conversão", quando duas pessoas mostram números diferentes para a mesma métrica, ou antes de instrumentar um evento ou montar um dashboard. Gatilhos: "definir métrica", "o que conta como ativado", "por que os números não batem", "qual a definição oficial de".
---

# Metric Definition

Produz uma **metric spec**: a fonte única de verdade de UMA métrica. O alvo não é o número - é a definição, escrita de forma que duas pessoas, partindo dela, cheguem ao mesmo número.

## Princípio que não pode ser quebrado

Toda decisão escondida vira explícita. Uma métrica carrega escolhas silenciosas (população, janela, dedup, reativação); cada uma implícita é uma divergência futura. Escolha não confirmada com a fonte/dono recebe **(assumido)**, nunca é apresentada como fato. E não invente número: esta skill define a métrica, não a mede.

## Configuração

- **Ferramenta de analytics:** [ex: PostHog, Amplitude, BigQuery/SQL] - onde a métrica é calculada.
- **Fontes de evento/tabela:** [nomes canônicos de eventos ou tabelas].
- **Dono por área:** [quem é a autoridade sobre cada métrica].
- **Glossário:** [termos e siglas do produto].

## Passo 1 - Ancorar na pergunta de negócio

Antes da fórmula: que decisão essa métrica informa? Escreva em uma frase o que ela mede e por quê. Métrica sobre a qual ninguém age talvez não precise deste rigor.

## Passo 2 - Preencher a spec

Defina cada campo. Onde a fonte não responde, marque **(assumido)** e siga.

1. **Nome e pergunta** - o nome e a pergunta que ela responde.
2. **Fórmula** - numerador / denominador (ou contagem do evento), explícita.
3. **Unidade de análise** - usuário, conta, sessão ou evento? (a fonte nº 1 de discordância.)
4. **Janela e granularidade** - período (diário/semanal/mensal), rolling vs calendário, e âncoras tipo W1/W4 (a partir de quê: signup? primeira ação?).
5. **Inclusão / exclusão** - que populações entram e saem: contas internas, test accounts, churned, free vs pago, região.
6. **Deduplicação** - como evitar contar a mesma unidade duas vezes.
7. **Casos de borda** - reativação, conta multiusuário, fuso/eventos atrasados, deleção.
8. **Fonte, cálculo e dono** - de que evento/tabela sai, em que ferramenta, e quem é o dono.
9. **O que NÃO é** - a fronteira com métricas vizinhas (ex: ativação ≠ signup ≠ retenção).

## Passo 3 - Reconciliar divergências

Se a métrica está em disputa (dois números), a definição só fecha quando as leituras são reconciliadas: liste a divergência e diga **qual** escolha a spec adotou. Não escolha em silêncio.

## Formato de saída

```
# Metric Spec - [nome da métrica]

**Pergunta que responde:** ...
**Fórmula:** [numerador] / [denominador]
**Unidade de análise:** ...
**Janela / granularidade:** ...
**Inclui:** ...
**Exclui:** ...
**Deduplicação:** ...
**Casos de borda:** ...
**Fonte / cálculo / dono:** ...
**O que NÃO é:** ...

Decisões assumidas (não confirmadas): [lista, ou "nenhuma"]
Divergências reconciliadas: [lista, ou "nenhuma"]
```

## Exemplo (abreviado) - Ativação W4

```
# Metric Spec - Ativação W4

**Pergunta que responde:** Quantas contas novas chegam ao valor central na 4ª semana? (informa a prioridade de onboarding)
**Fórmula:** contas com >=1 ação-chave na semana 4 / contas que deram signup na coorte
**Unidade de análise:** conta (não usuário - contas têm vários usuários)
**Janela / granularidade:** coorte semanal por signup; W4 = dias 22-28 após signup (rolling)
**Inclui:** contas pagas e free
**Exclui:** contas internas (@acme.com) e test accounts
**Deduplicação:** uma conta conta uma vez na sua coorte de signup
**Casos de borda:** reativação não recria coorte; conta multiusuário = 1; eventos atrasados (>48h) entram no recálculo
**Fonte / cálculo / dono:** evento "acao_chave" no PostHog; dono: Marina (Data)
**O que NÃO é:** não é signup (criar conta) nem retenção M1 (voltar no mês 1)

Decisões assumidas (não confirmadas): "ação-chave" = completar 1 transação (verificar com Marina)
Divergências reconciliadas: Carlos contava qualquer login como ativação; a spec exige a ação-chave, não login.
```
