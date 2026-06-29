# Cenário 01 - Definir "ativação W4" em disputa

Mundo: [Acme](../../../../evals/empresa-ficticia/acme.md). Use SOMENTE os dados abaixo; não invente nada (em especial, não invente um valor numérico de ativação - a tarefa é definir, não medir).

## Config (teste)

- Ferramenta de analytics: PostHog
- Eventos disponíveis: `signup`, `login`, `transacao_concluida`
- Dono de métricas: Marina (Data)
- Glossário: ativação W4, ação-chave

## Pedido

"Preciso cravar a definição de **ativação W4** - o squad e o Carlos estão mostrando números diferentes para a mesma métrica e ninguém sabe qual é o certo."

## Contexto coletado (o que as pessoas/fontes disseram)

- Carlos (Growth): "ativação é quando a conta loga na 4ª semana." (usa o evento `login`)
- Bia (Eng): "pra mim ativação é completar a primeira transação." (usa `transacao_concluida`)
- Marina (Data): "a coorte é por semana de signup; e a gente sempre tira as contas internas (@acme.com) e as de teste."
- Produto: contas têm vários usuários; algumas são free, outras pagas.
- Não foi dito: a unidade é conta ou usuário? como tratar reativação? e eventos que chegam atrasados?

## Esperado

Uma metric spec que reconcilie a divergência (login x transação), exponha as decisões escondidas (unidade, janela, exclusões, dedup, reativação) e marque o que ficou assumido.
