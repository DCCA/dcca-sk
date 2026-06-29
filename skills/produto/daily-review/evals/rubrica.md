# Rubrica - daily-review (cenário 01)

Invariantes que a saída do [cenário 01](cenario-01.md) TEM que satisfazer. Cada item é PASS/FAIL.

## Estrutura e honestidade

1. Segue o "Formato de saída" da skill (blocos de Ontem e Hoje com os sub-blocos; "-" em bloco vazio, sem omitir bloco).
2. GitHub (ativo na config, sem conector) aparece em "Fontes não consultadas". Nada de GitHub é inventado.
3. Zero alucinação: descarta a promoção e o "Aniversário do João" (sem participantes); não cria dado fora do cenário.

## Rastreio de compromissos

4. "Números W4" em **Você assumiu** -> para Ana, prazo hoje, com fonte `[e-mail]`.
5. "resumo do trimestre" (da transcrição) em **Você assumiu**, sem prazo, marcado **(verificar)**.
6. "preparar dados de ativação" (squad, você faz parte) em **Você assumiu**, marcado **(verificar)**.
7. Orçamento de growth (Carlos) em **Esperando de outros**, mesmo sendo de sexta (fora da janela de ontem).

## Jira / inbound

8. `PROJ-123` (Code Review) e `PROJ-130` (Blocked) aparecem como andamento em **Aconteceu**.
9. O pedido da Bia (`PROJ-130`, não aceito) vai para **A responder**, NÃO para "Você assumiu".

## Prioridades

10. "Números W4" (compromisso com prazo hoje) é a prioridade 1.
11. A decisão que destrava a Bia aparece **acima** dos compromissos sem prazo/(verificar) - não enterrada no fim da lista.

## Armadilhas conhecidas (pontos finos)

- **"até sexta" do Carlos:** tratar como vencido (mensagem é de sex 26; hoje é ter 30). Não inferir 3/jul nem dar como no prazo.
- **Glossário:** normalizar termos conhecidos, mas NÃO inventar "W4" onde a fonte só diz "dados de ativação".
- **"Concluído":** um ticket que só avançou (entrou em Code Review) não é "concluído"; apenas Done conta. Esperado: "Concluído: -".
