# dcca-sk - glue de shell pras ferramentas de IA.
#
# Sourceado pelo seu rc por um bloco guardado que o install.sh adiciona,
# SEPARADO do bloco do ade-stack (que cuida do terminal: PATH, eza/yazi/starship).
# Regra: tudo aqui e idempotente e defensivo - nada quebra se a ferramenta faltar.
#
# Fluxo: edite este arquivo, rode `./install.sh` pra instalar em toda maquina
# (ou `./capture.sh` pra trazer edicoes locais de volta pro repo). Sem segredo
# aqui (repo publico): nada de `export ANTHROPIC_API_KEY=...` etc.

# --- aliases (exemplos - descomente/ajuste, adicione os seus) ---
# command -v codex    >/dev/null 2>&1 && alias cx='codex'
# command -v openspec >/dev/null 2>&1 && alias osp='openspec'

# --- funcoes ---
# (adicione as suas aqui)
