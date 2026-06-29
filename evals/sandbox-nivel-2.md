# Sandbox nível 2 (conectores reais)

Para testar skills "connector-heavy" (a `daily-review` é a principal) contra os conectores de verdade, sem usar dados reais de empresa. Ideia: ambientes de teste descartáveis, semeados com a [Acme](empresa-ficticia/acme.md). Pega o que o nível 1 não pega: auth, paginação, formato real dos dados, limites de API.

## Passos manuais (exigem suas contas/logins)

> Eu não consigo criar contas nem autorizar conectores por você. Estes passos são seus. Para comandos de login, rode via `!` na sessão; o resto é no navegador.

1. **Jira sandbox** - crie um site Atlassian Cloud grátis (separado do trabalho). Crie o projeto `PROJ` e os tickets da Acme (`PROJ-123`, `PROJ-130`, ...). Conecte o MCP do Atlassian/Jira a esse site.
2. **Google de teste** - uma conta Google separada (NÃO a do trabalho). Popule Gmail (threads da Acme) e Calendar (rituais da Acme). Conecte os MCP de Gmail/Calendar a essa conta.
3. **Slack de teste** - um workspace Slack grátis. Crie `#squad-core` etc. e as mensagens da Acme. Conecte o MCP do Slack.
4. **Transcrições** - um doc no Drive de teste com a seção de action items da Acme.

## Seed (a partir da Acme)

Use [`empresa-ficticia/acme.md`](empresa-ficticia/acme.md) e o cenário da skill como roteiro de seed. Parte dá para automatizar - ex: Jira via API REST com um token do sandbox. **Quando você tiver o site criado, eu gero o script de seed.**

## Como rodar

Com os conectores de teste ativos, rode a skill de verdade (ex: peça "daily") e compare a saída com a **mesma rubrica** do nível 1 (`skills/.../evals/rubrica.md`).

## Estado atual deste ambiente

- Conectados: Google (Gmail, Calendar, Drive) - **na conta real**, não num sandbox.
- Não conectados: Slack, Jira.

Recomendação: **não** usar a conta real para teste (polui a caixa e arrisca PII). Crie os sandboxes acima.
