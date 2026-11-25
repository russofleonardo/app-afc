# Laboratório de Psicometria – Análise Fatorial Confirmatória
# © 2026 Leonardo Ferreira Russo — licença CC BY-NC-ND 4.0 (veja o arquivo LICENSE)
# =====================================================================
# missoes.R  —  O "ROTEIRO" DAS MISSÕES GUIADAS
# ---------------------------------------------------------------------
# Cada missão tem:
#   id (FIXO: é por ele que o progresso fica salvo no navegador — pode
#       reordenar as missões à vontade, mas nunca mude o id de uma missão),
#   titulo, nivel (Básico, Intermediário, Avançado, Desafio),
#   aba (onde ela acontece; um dos nomes de NOMES_ABAS), objetivo,
#   passos (o que fazer), condicoes (o que o app confere antes de liberar
#   o "Concluí"), reflexao (a pergunta) e comentario (a resposta comentada).
#
# As condições prontas (cond, cond_aba, cond_amostra_completa) e a função
# conferir_missao() ficam em base_laboratorio.R.
#
# Por enquanto há só 2 missões de EXEMPLO, para mostrar o formato.
# =====================================================================

NOMES_ABAS <- c(
  inicio      = "0. Comece aqui",
  itens       = "1. Itens",
  modelo      = "2. Especificar o modelo",
  ajuste      = "3. Ajuste do modelo",
  cargas      = "4. Cargas e resíduos",
  comparar    = "5. Comparar modelos"
)

MISSOES <- list(

  list(
    id = "comece_aqui",
    titulo = "Comece por aqui",
    nivel = "Básico", aba = "inicio",
    objetivo = "Entender o que é a análise fatorial confirmatória e como ela se diferencia da exploratória.",
    passos = c(
      "Leia a aba “0. Comece aqui”.",
      "Preste atenção na diferença entre explorar uma estrutura (AFE) e confirmar uma estrutura (AFC)."
    ),
    condicoes = list(cond_aba("inicio")),
    reflexao = "Por que não basta rodar uma AFE para “provar” que um questionário mede cinco traços?",
    comentario = "Porque a AFE descobre a estrutura a partir dos dados: ela é ótima para gerar hipóteses, mas não para testá-las. A AFC faz o caminho contrário: o pesquisador diz, antes de olhar os dados, qual item pertence a qual fator — e o modelo verifica se os dados são compatíveis com essa hipótese. O ideal é que a AFC seja feita em outra amostra, diferente da usada na AFE."
  ),

  list(
    id = "conhecendo_itens",
    titulo = "Conhecendo os itens",
    nivel = "Básico", aba = "itens",
    objetivo = "Conhecer os itens que vão entrar no modelo.",
    passos = c(
      "Abra a aba “1. Itens” e leia os 25 itens.",
      "Pense: a qual fator cada item deveria pertencer, segundo a teoria?"
    ),
    condicoes = list(cond_aba("itens")),
    reflexao = "Algum item parece poder pertencer a dois fatores? O que isso significaria num modelo confirmatório?",
    comentario = "Na AFC, cada item costuma ser ligado a um único fator, e todas as outras cargas são fixadas em zero. Um item ambíguo, que na verdade mede um pouco de dois traços, tende a piorar o ajuste do modelo — e aparece nos índices de modificação. É por isso que a qualidade dos itens e a teoria pesam tanto numa AFC."
  )
)

N_MISSOES <- length(MISSOES)
IDS_MISSOES <- vapply(MISSOES, `[[`, "", "id")
stopifnot(!anyDuplicated(IDS_MISSOES))
