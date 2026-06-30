---
name: daily-review
description: 'Use quando o usuário quer fechar o dia anterior e preparar o dia atual - a rotina diária pessoal de um PM. Gatilhos: "daily", "review diário", "fechar o dia", "revisar ontem", "preparar meu dia", "o que tenho hoje", "começar o dia", ou qualquer pedido de rotina de manhã / início de expediente, mesmo que não use a palavra "daily" explicitamente.'
---

# Daily Review

Rotina pessoal de um PM, sempre nesta ordem: (1) fechar o dia anterior - o que aconteceu, o que ficou pendente, quem deve o quê a quem - e (2) preparar o dia atual - agenda, prioridades, preparo, follow-ups. É um brief pessoal de 2 minutos, não um report para terceiros.

## Princípio que não pode ser quebrado

Reporte apenas o que veio de uma fonte real consultada nesta execução. Não encontrou? Diga que não encontrou - nunca preencha lacuna com suposição. Um brief com buracos honestos é melhor que um inventado, porque você vai agir em cima dele.

## Configuração

Preencher uma vez (no destino, ao importar). Campo vazio: a skill segue sem ele, com menos precisão.

- **Fontes ativas:** [calendário, e-mail, Slack, GitHub, Jira, transcrições - só as que sua empresa usa]. A skill consulta apenas estas; adapte à sua stack (Jira ou Linear; Teams no lugar de Slack).
- **Handles no Slack:** [@seu.handle, apelidos] - para detectar menções diretas.
- **Canais prioritários (allowlist):** [#squad, ...] - lidos por completo; fora da lista, só DMs, menções e threads onde você respondeu.
- **VIPs no e-mail:** [chefe, pares, clientes] - prioridade mesmo sem estrela.
- **Glossário:** [pessoas, produtos, siglas] - para normalizar termos que a transcrição distorce.

## Passo 1 - Ancorar o tempo

Chame a ferramenta de hora para fixar "hoje" e o fuso; nunca assuma a data. Janela de "ontem": ter-sex = dia útil anterior; segunda = sexta + fim de semana; após feriado = do último dia útil até agora.

## Passo 2 - Descobrir as fontes

Considere só as **Fontes ativas** e veja quais estão conectadas. Possíveis: **Calendário**, **E-mail**, **Slack** (ou Teams/Discord), **GitHub** (código/PRs), **Rastreador de issues** (Jira/Linear/GitHub Issues), **Transcrições**. Fonte ativa mas não conectada vai para a lista "Fontes não consultadas" - não trave por causa dela.

## Passo 3 - Coletar (com filtro de ruído)

De cada fonte, extraia só o que serve aos dois objetivos; não despeje conteúdo bruto.

- **Calendário:** título, participantes, nota/decisão. Ignore aniversários e lembretes sem participantes. Hoje: marque reuniões de alto peso (1:1, liderança, apresentação, decisão).
- **E-mail:** quem pediu o quê e o que você prometeu. Descarte promoções, newsletters e notificações automáticas. Peso extra a marcados importante/estrela e a **VIPs**.
- **Slack:** sempre olhe DMs, menções aos seus **handles**, e threads onde você respondeu; leia por completo só os **canais prioritários**. Extraia pedidos, perguntas em aberto e decisões.
- **GitHub (código/PRs):** o que avançou ou está esperando você; foque em PRs seus ou aguardando seu review.
- **Rastreador (Jira/Linear):** o que avançou, mudou de status ou travou - tickets seus, blockers, menções a você. Um comentário/pedido não vira compromisso seu até você aceitar (Passo 4). Não despeje o board inteiro.
- **Transcrições:** prefira a seção de resumo/action items, não o transcript cru; normalize termos pelo glossário (sem inventar o que não está lá). A atribuição de quem falou é frágil, então todo compromisso daqui é provisório - marque **(verificar)**. Sem acesso ao doc, registre "transcrição não acessível" em vez de inferir.

## Passo 4 - Reconstruir ontem

Quatro blocos: **1. Aconteceu** (reuniões e eventos relevantes, incl. mudança de status de ticket - entrou em review, ficou blocked); **2. Concluído** (o que de fato fechou - um ticket que só avançou não é concluído); **3. Você assumiu** (o quê / para quem / prazo); **4. Esperando de outros** (o que terceiros te devem e não entregaram).

O rastreio nos dois sentidos (3 e 4) é o núcleo. Cace commitments em e-mail/Slack/transcrição ("eu te mando", "fico de", "pode deixar"; e as recíprocas "você consegue", "me manda"). Regras:

- **Direção do pedido:** solicitação que chegou e que você **não aceitou** não é sua - vai para "A responder" (Passo 5), não para o bloco 3. Só é "Você assumiu" com aceite explícito.
- **Loops em aberto:** os blocos 3 e 4 não se limitam à janela de ontem; um compromisso seu ou uma cobrança ainda pendente continua vivo e aparece mesmo que seja de dias atrás.
- **Grupo:** compromisso de um grupo do qual você faz parte ("o squad fica de X") conta como seu (bloco 3), salvo se delegado a alguém específico.
- **Citação e prazo:** registre a fonte entre colchetes; marque **(verificar)** o que veio de transcrição; não infira prazo não dito - escreva "sem prazo".

## Passo 5 - Preparar hoje

Cinco blocos:

1. **Agenda** - reuniões de hoje em ordem (horário, participantes). Marque as coladas (sem intervalo) e aponte um bloco livre de ≥90min para foco; se não houver, diga explicitamente.
2. **Preparo** - o que levar pronto para cada reunião que exige. Só inclua a reunião se houver base concreta (compromisso, material citado, action item); sem base, não invente - omita.
3. **A responder** - inbound (e-mail/Slack/rastreador) esperando resposta ou **decisão sua** - inclui o caso de maior impacto: outra pessoa parada esperando você (ex: ticket blocked). De quem, sobre o quê, fonte.
4. **Prioridades** - o que carrega de ontem (blocos 3 e 4) + o novo de hoje. Máximo 3-5 (lista de foco, não backlog). Desempate, de cima para baixo:
   1. Compromisso seu com prazo hoje
   2. Decisão/ação sua travando outra pessoa (desbloqueio)
   3. Cobrança vencida
   4. Preparo de reunião de hoje
   5. Compromisso seu sem prazo, herdado de ontem
   6. Prioridade nova de hoje

   No mesmo nível, ordene pelo prazo mais cedo; sem horário, por último.
5. **Follow-ups que vencem** - cobranças e entregas com prazo hoje ou atrasadas.

## Formato de saída

Use esta estrutura. Cada item em 1-2 linhas. Bloco vazio: escreva "-", não omita.

```
# Daily Review - [data de hoje]

## Ontem ([janela coberta])

### Aconteceu
- ...
### Concluído
- ...
### Você assumiu
- [o quê] → [para quem] · [prazo] · [fonte] [(verificar) se de transcrição]
### Esperando de outros
- [o quê] ← [de quem] · [desde quando] · [fonte]

## Hoje

### Agenda
- [HH:MM] [reunião] · [participantes]
Coladas: [...] · Bloco de foco: [janela ≥90min, ou "nenhum"]
### Preparo
- [reunião]: [o que levar]
### A responder
- [de quem] · [sobre o quê] · [fonte]
### Prioridades
1. ...
### Follow-ups que vencem
- ...

---
Fontes não consultadas: [lista, ou "nenhuma"]
```

## Exemplo (abreviado)

```
# Daily Review - ter, 30/jun

## Ontem (seg, 29/jun)

### Aconteceu
- Sync de roadmap (Ana, squad): priorizar Checkout no Q3. [transcrição]
- PROJ-130 ficou blocked. [Jira]
### Concluído
- -
### Você assumiu
- Números de ativação W4 → Ana · até hoje · [e-mail: "Números W4"]
- Preparar dados de ativação → squad (você faz parte) · sem prazo · [transcrição] (verificar)
### Esperando de outros
- Aprovação do orçamento ← Carlos · desde sex 26/jun · [Slack: #squad-core]

## Hoje

### Agenda
- 10:00 1:1 Ana · Ana
Coladas: nenhuma · Bloco de foco: 10:30-14:00 livre
### Preparo
- 1:1 Ana: levar os números W4 (compromisso de ontem)
### A responder
- Bia · decisão do fluxo de erro p/ destravar PROJ-130 · [Jira]
### Prioridades
1. Enviar W4 para Ana antes das 10h
2. Decidir o fluxo de erro (destrava a Bia)
3. Cobrar Carlos o orçamento (vencido)
### Follow-ups que vencem
- W4 para Ana (hoje)

---
Fontes não consultadas: GitHub (sem conector)
```
