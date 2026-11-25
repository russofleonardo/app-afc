# Laboratório de Psicometria – Análise Fatorial Confirmatória
# © 2026 Leonardo Ferreira Russo — licença CC BY-NC-ND 4.0 (veja o arquivo LICENSE)
# =====================================================================
# glossario.R  —  O "DICIONÁRIO" DO APP
# ---------------------------------------------------------------------
# Definições curtas dos termos principais. No texto do app, use
# termo("chave") ou termo_html("chave") (veja base_laboratorio.R): o termo
# ganha um sublinhado pontilhado e mostra a definição ao passar o mouse.
# Acrescente aqui os termos novos que forem aparecendo.
# =====================================================================

GLOSSARIO <- c(
  fator             = "Variável que não pode ser observada diretamente (como a Extroversão), mas que influencia as respostas a vários itens.",
  afe               = "Análise fatorial exploratória: os dados mostram quantos fatores há e quais itens se ligam a cada um.",
  afc               = "Análise fatorial confirmatória: o pesquisador define de antemão qual item pertence a qual fator, e o modelo testa se os dados concordam com essa hipótese.",
  especificacao     = "Escrever o modelo: dizer quais fatores existem, quais itens cada um influencia e quais fatores se correlacionam.",
  identificacao     = "Condição para o modelo poder ser estimado: é preciso haver informação suficiente nos dados (por exemplo, fixar a escala de cada fator).",
  carga             = "Força da ligação entre um item e um fator. Na AFC, só existem as cargas que o modelo permite; as demais são fixadas em zero.",
  carga_padronizada = "Carga na escala de uma correlação (de −1 a 1), o que permite comparar itens e fatores entre si.",
  graus_liberdade   = "Quantas informações dos dados “sobram” depois de estimar o modelo. Modelos mais simples têm mais graus de liberdade.",
  qui_quadrado      = "Teste do ajuste exato do modelo. Com amostras grandes, quase sempre dá significativo, mesmo com diferenças pequenas.",
  cfi               = "Índice de ajuste comparativo: compara o modelo com um modelo sem relações entre os itens. Quanto maior, melhor: 0,95 ou mais é bom.",
  tli               = "Índice de Tucker-Lewis: parecido com o CFI, mas penaliza modelos complexos. Quanto maior, melhor: 0,95 ou mais é bom.",
  rmsea             = "Erro médio de aproximação do modelo, que penaliza a complexidade. Quanto menor, melhor: até 0,06 é bom; até 0,08, aceitável.",
  srmr              = "Média dos resíduos padronizados (diferença entre as correlações observadas e as do modelo). Quanto menor, melhor: até 0,08 é bom.",
  residuo           = "Diferença entre a correlação observada e a que o modelo reproduz: o que o modelo não explicou.",
  indice_modificacao = "Quanto o qui-quadrado melhoraria se um parâmetro hoje fixado fosse liberado (por exemplo, uma carga cruzada). Usar com cuidado e com justificativa teórica.",
  modelos_aninhados = "Quando um modelo é uma versão restrita do outro (por exemplo, fatores correlacionados × não correlacionados). Podem ser comparados por diferença de qui-quadrado.",
  invertido         = "Item escrito no sentido contrário ao traço: concordar com ele indica MENOS do traço (ex.: “Fala pouco”, para Extroversão)."
)
