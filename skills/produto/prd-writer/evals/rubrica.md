# Rubrica - prd-writer (cenário 01)

Invariantes da saída do [cenário 01](cenario-01.md). Cada item PASS/FAIL.

## Estrutura

1. Segue o "Formato de saída" (Problema, Objetivo & métrica, Não-objetivos, Usuários/JTBD, Escopo v1, Fora de escopo, Requisitos, Riscos & dependências, Perguntas em aberto, Suposições).
2. Nenhum campo do template fica vazio sem marcação (usa "perguntas em aberto"/"(assumido)" quando falta info).

## Problema antes da solução

3. **Reconstrói o problema** (ativação W4 abaixo da meta / contas não chegam ao 1º valor) - não abre direto pelo "tour guiado".
4. O tour guiado aparece como **solução proposta dentro do escopo**, não como a razão de ser do PRD.

## Sucesso e escopo

5. **Métrica de sucesso** definida e ligada a uma métrica real (Ativação W4), não genérica.
6. **Não-objetivos** explícitos.
7. **Escopo v1 + fora de escopo** presentes, com a v1 mínima e ligada ao problema.

## Honestidade

8. Marca como **aberto/(assumido)** o que o cenário diz não estar resolvido: funil não analisado, ausência de pesquisa, "ação-chave" indefinida (com dono Marina).
9. **Não inventa** dado de pesquisa nem número de usuário; o 38% (que foi dado) pode ser usado, o resto não é fabricado.

## Armadilhas conhecidas

- Abrir o PRD pela solução ("a feature é um tour de 3 passos...") sem o problema -> FAIL.
- Afirmar que o atrito está no primeiro uso como fato (o funil não foi analisado) sem marcar como hipótese -> FAIL.
- Inventar uma meta numérica específica de uplift ("+12% de ativação") como se fosse dada -> FAIL.
