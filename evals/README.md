# Evals (simulação para testar skills)

Como a gente garante que uma skill faz o que promete: roda a skill contra um cenário fictício e checa a saída contra uma rubrica. **Nível 1** (sintético, sem conector) é o padrão. **Nível 2** (sandbox com conectores reais) está em [`sandbox-nivel-2.md`](sandbox-nivel-2.md).

Isso é o loop do `writing-skills` (TDD para skills): rodar -> ver onde falha -> corrigir -> repetir.

## Peças

- **Empresa fictícia** ([`empresa-ficticia/acme.md`](empresa-ficticia/acme.md)): o mundo de mentira, reutilizado entre skills.
- **Cenário** (`skills/<cat>/<skill>/evals/cenario-*.md`): uma situação concreta - entradas que simulam o que os conectores retornariam, puxando da Acme.
- **Rubrica** (`.../evals/rubrica.md`): os invariantes que a saída TEM que satisfazer (cada um PASS/FAIL), mais as armadilhas conhecidas.

## Como rodar (nível 1, com subagentes)

1. **Aplicador** - dispare um subagente:
   > "Leia a skill em `<caminho do SKILL.md>`. Aplique-a SOMENTE aos dados do cenário abaixo. Não há conectores reais; não invente nada além dos dados. Produza a saída no formato da skill." (cole o cenário)
2. **Avaliador** - dispare outro subagente:
   > "Aqui está a rubrica e a saída produzida. Para cada invariante da rubrica, responda PASS/FAIL com evidência. Liste qualquer dado inventado (alucinação) e qualquer furo." (cole rubrica + saída)
3. Leia o veredito. Qualquer FAIL = corrige a skill e repete.
4. Registre o placar em [RESULTS.md](RESULTS.md) (a última rodada de cada skill).

Manter aplicador e avaliador **separados** evita que quem produziu a resposta também se auto-aprove.

Opcional: um Workflow pode rodar todas as evals de uma vez (aplicador -> avaliador por skill) e reportar um placar.

## Convenção

Toda skill nasce com **≥1 cenário + rubrica**. Sem eval, a skill não está "pronta".
