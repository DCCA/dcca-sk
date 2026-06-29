# Fidelidade além do sintético (sem precisar criar contas)

O Nível 1 (fixtures sintéticas) já pega a maior parte dos furos de lógica - validou a `daily-review` 11/11. Quando quiser **fidelidade de conector** (nomes de tool, schemas, paginação, formato real, limites de API), há dois caminhos. **Comece sempre pelo Nível 1.**

## Nível 2a - Mock MCP (sem contas) [recomendado quando precisar de mais fidelidade]

Suba um servidor MCP de mentira local que serve os dados da [Acme](empresa-ficticia/acme.md) pela **mesma interface de ferramentas** que os conectores reais expõem (mesmos nomes de tool, mesmos schemas). A skill faz as chamadas de ferramenta de verdade; o mock responde com os fixtures.

- Exercita o caminho real de tool-call (nomes, schemas, paginação simulada) sem nenhuma conta nem login.
- Esforço: escrever o mock (Node/Python) espelhando os tools dos conectores que a skill usa.
- É o caminho para "mais real que o sintético" sem burocracia de conta. **Posso gerar esse mock quando uma skill precisar.**

## Nível 2b - Sandboxes reais (com contas) [só quando o mock não bastar]

Criar Jira/Google/Slack de teste e semear com a Acme. Pega o comportamento 100% real do provedor, mas exige criar conta, logar, semear e manter. Reserve para quando um bug só aparece no provedor real.

## Recomendação

Nível 1 como padrão; **Nível 2a (mock MCP)** quando uma skill começar a depender do formato real dos dados; Nível 2b só em último caso. Não criar conta só para começar.
