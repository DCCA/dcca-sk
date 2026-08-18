# Eval das regras do `AGENTS.md`

As evals de skill (ver [`../README.md`](../README.md)) checam se uma **skill** faz o que promete.
Esta aqui checa outra coisa: se as **regras de comportamento** do `AGENTS.md`
canonico, hoje mantido no `dcca-env`, realmente mudam o que o agente faz. O
runner recebe esse arquivo por `--agents-file`; o dcca-sk continua dono do
harness e dos casos, sem manter uma copia da policy.

Regra em prosa falha calada. Ou o modelo ignora, ou - o caso mais chato - a regra dispara
onde nao devia e vira imposto em toda tarefa trivial. Os dois casos sao invisiveis sem medir.

## O que ela mede

Cada regra tem **dois** casos, e o segundo e o que quase todo mundo esquece:

| Caso | Pergunta |
|---|---|
| `*-fire` | a regra dispara quando deve? |
| `*-nofire` | a regra fica quieta quando **nao** deve disparar? |

Regras cobertas hoje (`cases.py`): `evidence-before-claims` (R1),
`options-before-implementation` (R2), `audit-means-fix` (R3), `wsl-environment` (R4).

Cada trial roda headless (`claude -p`) numa copia descartavel de `fixture/` e passa por dois
crivos. Um trial so passa se os dois concordarem:

1. **Deterministico** - o arquivo observado (`watch`) mudou quando devia (ou ficou intacto quando devia).
2. **Juiz** - um modelo le a resposta **e o diff real que a rodada produziu** e da PASS/FAIL contra o criterio do caso.

## Rodar

```bash
POLICY=~/projects/dcca-env/home/dot_config/dcca-env/AGENTS.md
./run.py --agents-file "$POLICY" --dry-run
./run.py --agents-file "$POLICY" --trials 1 --only R2
./run.py --agents-file "$POLICY" --trials 5 --jobs 5
```

**Consome cota de modelo:** a rodada de migracao de 2026-08-18 custou o equivalente
a **US$ 0,70 por trial** (subject + juiz), ou US$ 5,58 para 8 casos x 1 trial.
Em assinatura Max o custo direto foi US$ 0, mas a cota foi consumida. Sempre confira
o `--dry-run` e o metodo de autenticacao antes.

Saida transitoria (`runs/`, `results.json`, `eval.log`) e gitignorada. O placar duravel vai
pro [`../RESULTS.md`](../RESULTS.md), mesma convencao das evals de skill.

## Limitacoes conhecidas (medidas, nao supostas)

- **Ruido do juiz: 1 a 2 em 40 trials (2-5%), sempre falso negativo.** Nas duas rodadas de
  2026-08-09 as regras acertaram 80/80; o que apareceu como falha foi sempre erro de
  correcao. Exemplo real: o juiz reprovou uma resposta certa porque ela escapou as crases
  de um jeito diferente. Consequencia pratica: uma regra que caisse de verdade pra ~95%
  seria indistinguivel de ruido. Casos com `watch=None` sao os mais expostos, porque nao
  tem evidencia deterministica pra ancorar o juiz. Se um caso novo depender dessa resolucao,
  troque a parte factual do criterio por um assert de substring no codigo e deixe o juiz so
  com a pergunta de comportamento.
- **A fixture e o controle.** Um probe de preflight ja escreveu dentro de `fixture/` e mudou
  calado o que todos os trials seguintes viram. Por isso `protect_fixture()` deixa ela
  read-only e um manifesto sha256 e reconferido no fim da rodada. Se aparecer o aviso de que
  a fixture mudou, joga a rodada fora.

## Adicionar uma regra

1. Escreva a regra no `AGENTS.md` canonico do dcca-env e suba via PR la.
2. Adicione **os dois** casos no `cases.py` (`*-fire` e `*-nofire`). Sem o `nofire` voce nao
   mede o modo de falha mais provavel.
3. Se a regra deve produzir (ou impedir) uma edicao, aponte `watch` pro arquivo e defina
   `must_change` - e o unico sinal que nao depende do juiz.
4. Rode com `--trials 5` e registre o placar no [`../RESULTS.md`](../RESULTS.md).
