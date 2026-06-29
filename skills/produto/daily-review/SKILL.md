---
name: daily-review
description: Use quando o usuário quer fechar o dia anterior e preparar o dia atual - a rotina diária pessoal de um PM. Gatilhos: "daily", "review diário", "fechar o dia", "revisar ontem", "preparar meu dia", "o que tenho hoje", "começar o dia", ou qualquer pedido de rotina de manhã / início de expediente, mesmo que não use a palavra "daily" explicitamente.
---

# Daily Review

Rotina pessoal de um PM. Dois objetivos, sempre nesta ordem: (1) fechar o dia anterior - o que aconteceu, o que ficou pendente, quem deve o quê a quem - e (2) preparar o dia atual - agenda, prioridades, preparo por reunião, follow-ups que vencem.

Não é um report para terceiros. O tom é direto e pessoal, escrito para o próprio usuário ler em dois minutos.

## Princípio que não pode ser quebrado

Reporte apenas o que vier de uma fonte real consultada nesta execução. Se uma informação não foi encontrada, diga que não foi encontrada - nunca preencha lacuna com suposição. É melhor um brief com buracos honestos do que um brief inventado, porque o usuário vai agir em cima dele.

## Configuração

Preencher uma vez. A skill usa estes valores para escopar a coleta e cortar ruído. Se um campo estiver vazio, a skill segue sem ele, mas a precisão cai.

- **Handles do usuário no Slack:** [@seu.handle, apelidos] - usados para detectar menções diretas.
- **Canais Slack prioritários (allowlist):** [#canal-do-squad, #outro] - a skill lê estes canais por completo; fora desta lista, só olha DMs, menções e threads onde você respondeu.
- **Remetentes VIP no e-mail:** [chefe, pares-chave, clientes] - e-mails destes têm prioridade mesmo sem estrela.
- **Glossário (opcional):** [nomes de pessoas, produtos e siglas - ex: Consignado, FGTS, RICE, nomes do time] - usado para normalizar termos que transcrição costuma distorcer.

## Passo 1 - Ancorar o tempo

Chame a ferramenta de hora atual para fixar "hoje" e o fuso. Defina a janela de "ontem":
- Terça a sexta: o dia útil anterior.
- Segunda: sexta + fim de semana (puxe de sexta 00h até agora).
- Após feriado: do último dia útil até agora.

Nunca assuma a data - sempre derive da ferramenta.

## Passo 2 - Descobrir quais fontes existem

Verifique quais ferramentas/conectores estão disponíveis no ambiente. As fontes-alvo são:

- **Calendário** - reuniões de ontem (o que aconteceu) e de hoje (o que preparar).
- **E-mail** - threads recebidas/enviadas na janela de ontem; pedidos em aberto.
- **Slack** - menções, DMs e threads onde o usuário foi citado ou respondeu.
- **GitHub** - PRs, issues, reviews e commits na janela.
- **Transcrições de reunião** - decisões e action items das reuniões de ontem.

Para cada fonte que **não** estiver conectada, registre numa lista "Fontes não consultadas" e siga em frente. Não trave a execução por causa de uma fonte ausente.

## Passo 3 - Coletar

De cada fonte disponível, extraia somente o que serve aos dois objetivos. Não despeje conteúdo bruto. Aplique os filtros abaixo para cortar ruído antes de sintetizar.

- **Calendário (ontem):** título, participantes, e se houve nota/decisão registrada. Ignore aniversários e lembretes sem participantes.
- **Calendário (hoje):** horário, participantes, e o que o usuário precisa levar pronto. Mesmos filtros de ruído. Sinalize reuniões de alto peso (1:1, reunião com liderança, apresentação, decisão).
- **E-mail:** quem pediu o quê, e o que o usuário prometeu responder. Descarte promoções, newsletters e notificações automáticas (categoria de promoções; remetentes de serviço como redes sociais, lojas, cobranças automáticas). Dê peso a e-mails marcados como importante ou com estrela, e a qualquer e-mail de um **remetente VIP** da config.
- **Slack:** escope pela config. Sempre olhe: DMs do usuário, menções diretas aos **handles** da config, e threads onde o usuário respondeu. Leia por completo apenas os **canais prioritários** da allowlist. Não varra outros canais. Extraia pedidos diretos, perguntas não respondidas e decisões em thread.
- **GitHub:** o que avançou, o que está parado esperando o usuário, o que espera outra pessoa. Foque em PRs e issues atribuídos ao usuário ou aguardando review dele.
- **Transcrições (ex: Gemini):** prefira a seção de resumo / action items do documento gerado, não o transcript cru - é mais limpa e já vem atribuída. Normalize nomes e termos contra o glossário da config. Atenção: a atribuição de quem falou é frágil, então todo compromisso extraído daqui é provisório (ver Passo 4). Se você não foi o organizador da reunião, o documento pode estar no Drive de outra pessoa e não estar acessível - nesse caso, registre a reunião como "transcrição não acessível" em vez de inferir o conteúdo.

## Passo 4 - Reconstruir ontem

Sintetize o que foi coletado em quatro blocos:

1. **Aconteceu** - reuniões e eventos relevantes, em uma linha cada.
2. **Concluído** - o que efetivamente fechou.
3. **Compromissos que VOCÊ assumiu** - para cada um: o quê, para quem, prazo (se houver). Isto é o que pode cair se você esquecer.
4. **Esperando de outros** - compromissos que terceiros assumiram com você e ainda não entregaram. Isto é o que você precisa cobrar.

O rastreio nos dois sentidos (3 e 4) é o núcleo da skill. Procure ativamente por commitments em e-mail, Slack e transcrições - frases como "eu te mando", "fico de", "pode deixar comigo", "te respondo até", e as recíprocas ("você consegue", "me manda", "fica de").

**Confiança e citação.** Para todo compromisso, registre a origem entre colchetes ao final: a fonte e a referência (ex: remetente/assunto do e-mail, canal/thread do Slack, nome da reunião). Compromissos vindos de **transcrição** entram marcados com **(verificar)**, porque a atribuição de quem falou é frágil e pode inverter a direção (você ↔ outros). Não infira prazo que não foi dito de forma explícita - se não houve prazo claro, escreva "sem prazo".

## Passo 5 - Preparar hoje

Cinco blocos:

1. **Agenda** - reuniões de hoje em ordem, com horário e participantes. Faça uma análise rápida: marque reuniões coladas (sem intervalo entre uma e outra) e aponte pelo menos um bloco livre de no mínimo 90 minutos para trabalho de foco. Se o dia não tiver nenhum bloco assim, diga isso explicitamente.
2. **Preparo por reunião** - para cada reunião que exige preparo, o que precisa estar pronto antes. Reuniões de alto peso (1:1, liderança, apresentação) têm prioridade de preparo.
3. **A responder** - inbound (e-mail ou Slack) que espera resposta sua e ainda não foi respondido. Para cada item: de quem, sobre o quê, e a fonte. Este bloco existe para que comunicação pendente não dispute vaga na lista de foco abaixo.
4. **Prioridades** - o que carrega de ontem (itens dos blocos 3 e 4 do Passo 4) + o que é novo hoje. No máximo 3–5 itens; isto é uma lista de foco, não um backlog. Ordene por esta regra de desempate, de cima para baixo:
   1. Compromisso que VOCÊ assumiu com prazo hoje
   2. Cobrança vencida (algo que estão te devendo e já passou do prazo)
   3. Preparo de reunião de hoje
   4. Prioridade nova que surgiu hoje

   Dentro do mesmo nível, ordene pelo horário do prazo - mais cedo primeiro. Sem horário definido, vai por último dentro do nível.
5. **Follow-ups que vencem** - cobranças e entregas com prazo hoje ou atrasadas.

## Formato de saída

Use exatamente esta estrutura. Mantenha cada item em uma ou duas linhas. Se um bloco estiver vazio, escreva "-" em vez de omitir o bloco.

```
# Daily Review - [data de hoje, ex: seg, 29/jun]

## Ontem ([janela coberta])

### Aconteceu
- ...

### Concluído
- ...

### Você assumiu
- [o quê] → [para quem] · [prazo] · [fonte] [(verificar) se vier de transcrição]

### Esperando de outros
- [o quê] ← [de quem] · [desde quando] · [fonte]

## Hoje

### Agenda
- [HH:MM] [reunião] · [participantes]
Coladas: [reuniões sem intervalo, ou "nenhuma"]
Bloco de foco: [janela livre ≥90min, ou "nenhum bloco de 90min livre hoje"]

### Preparo
- [reunião]: [o que levar pronto]

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
- Sync de roadmap com liderança; alinhamento de prioridade Q3.

### Concluído
- PRD do Consignado CLT enviado para review.

### Você assumiu
- Mandar números de ativação W4 → para Ana · até hoje · [e-mail: Ana, "números W4"]
- Revisar proposta de ranker → para o squad · sem prazo · [reunião: Sync de roadmap] (verificar)

### Esperando de outros
- Aprovação do orçamento de growth ← do Carlos · desde sex 26/jun · [Slack: #coreapp]

## Hoje

### Agenda
- 10:00 1:1 com Ana · Ana
- 14:00 Review de experimento · squad CoreApp
Coladas: nenhuma
Bloco de foco: 11:00–13:00 livre

### Preparo
- 1:1 Ana: levar os números de ativação W4 (compromisso de ontem)
- Review: ter o resultado de significância do teste em mãos

### A responder
- Cliente (Consignado) · dúvida de integração da API · [e-mail]

### Prioridades
1. Enviar ativação W4 para Ana antes das 10h
2. Cobrar Carlos sobre o orçamento de growth
3. Fechar a leitura do experimento antes das 14h

### Follow-ups que vencem
- Ativação W4 (hoje)

---
Fontes não consultadas: GitHub (sem conector ativo)
```
