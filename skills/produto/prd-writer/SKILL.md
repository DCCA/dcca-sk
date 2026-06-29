---
name: prd-writer
description: Use quando vai formalizar uma feature num documento de produto - "escrever um PRD", "spec de feature", "documentar os requisitos", "virar isso num doc de produto". Para o doc leve de buy-in pré-PRD ("one-pager", "brief de decisão"), é a one-pager, não esta.
---

# PRD Writer

Escreve um PRD impondo uma estrutura canônica. O ganho central: força definir o **problema e a métrica de sucesso antes da solução**, então o "o quê" sempre serve a um "por quê" explícito.

## Princípio que não pode ser quebrado

Problema e métrica de sucesso vêm antes da solução. Um PRD que abre pela solução esconde a razão de existir e vira lista de funcionalidades. Se o pedido chega como solução ("adiciona um tour"), reconstrua o problema por trás antes de detalhar. Todo requisito não validado vira pergunta em aberto ou **(assumido)** - não invente pesquisa, dado ou número de usuário.

## Configuração

- **Seções/template da empresa:** [se houver um padrão de PRD].
- **Métricas de produto:** [as métricas que um PRD pode mover - ligar em `metric-definition`].
- **Stakeholders / dono:** [quem aprova e quem é impactado].

## Passo 1 - Problema primeiro

Qual dor, de quem, com que evidência? Se o input veio como solução, suba um nível: que problema essa solução tenta resolver? Sem problema claro, pare aqui.

## Passo 2 - Sucesso antes da solução

Defina a métrica de sucesso (a que move - ligue na sua definição) e os **não-objetivos** (o que esta feature explicitamente NÃO tenta fazer). Isto baliza o escopo.

## Passo 3 - Só então o escopo

Usuários/JTBD, escopo da v1 e o que fica fora, comportamento/requisitos. Mantenha a v1 mínima e ligada ao problema.

## Passo 4 - Riscos e o que está aberto

Riscos, dependências e perguntas em aberto. Marque o que é suposição a validar. Um PRD honesto sobre o que não sabe é mais útil que um que finge certeza.

## Formato de saída

```
# PRD - [nome da feature]

**Problema:** [dor + de quem + evidência]
**Objetivo & métrica de sucesso:** [o resultado + a métrica que move]
**Não-objetivos:** [o que NÃO é]
**Usuários / JTBD:** ...
**Escopo v1:** ...
**Fora de escopo (agora):** ...
**Requisitos / comportamento:** ...
**Riscos & dependências:** ...
**Perguntas em aberto:** [com dono, ou "nenhuma"]

Suposições não validadas: [lista, ou "nenhuma"]
```

## Exemplo (abreviado) - Acme

```
# PRD - Onboarding guiado

**Problema:** Contas novas não chegam ao 1º valor: a ativação W4 está abaixo da meta (45%) e o funil mostra queda no primeiro uso. [analytics]
**Objetivo & métrica de sucesso:** Subir a ativação W4. Sucesso = +X pp de ativação W4 na coorte exposta.
**Não-objetivos:** Não é redesenhar o produto; não mexe em billing.
**Usuários / JTBD:** Conta nova que "quer entender rápido se a Acme resolve meu caso".
**Escopo v1:** Tour de 3 passos no primeiro login cobrindo a ação-chave.
**Fora de escopo (agora):** Personalização por segmento; tour no mobile.
**Requisitos:** Dispensável; reaparece só se não concluído; instrumentado.
**Riscos & dependências:** Depende da definição de "ação-chave" (ver metric-definition).
**Perguntas em aberto:** Qual é a ação-chave canônica? (dono: Marina)

Suposições não validadas: que o atrito está no primeiro uso (a confirmar no funil).
```
