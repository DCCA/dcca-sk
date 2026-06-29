# Cenário 01 - Update de uma iniciativa atrasada para a liderança

Mundo: [Acme](../../../../evals/empresa-ficticia/acme.md). Use SOMENTE estes dados. **Não infle o progresso** nem invente datas/números; o farol tem que ser fiel à realidade descrita.

## Config (teste)

- Audiência: liderança (Ana e Diego)
- Cadência: semanal
- Iniciativa: Integração de pagamentos (checkout)

## Pedido

"Manda o status semanal da integração de pagamentos pra liderança."

## Situação real (o que está acontecendo)

- A integração ia entrar nesta semana, mas um **bug no checkout** (PROJ-130) está Blocked, esperando uma decisão sobre o fluxo de erro - a entrega **escorregou ~1 semana**.
- O bug do checkout fez a **taxa de erro subir para 2,1%** (limite é 1%).
- A parte de UI do checkout já está pronta e em review.
- Há uma dependência travada: a **aprovação do orçamento** de um provedor de pagamento está com o Carlos desde a semana passada, ainda sem resposta.
- A ativação W4 caiu na semana (38%), possivelmente ligada ao checkout - ainda não confirmado.

## Esperado

Um status update com farol **honesto** (não pode ser verde - está atrasado/em risco), começando pela conclusão (BLUF), com riscos (bug, erro acima do limite) e seus impactos, um **ask explícito** (decisão do fluxo de erro; cobrar a aprovação do Carlos), próximos passos, e calibrado para liderança (conciso, focado em decisão) - sem inflar e sem virar um despejo de métricas.
