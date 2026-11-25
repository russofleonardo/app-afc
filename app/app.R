# Laboratório de Psicometria – Análise Fatorial Confirmatória
# © 2026 Leonardo Ferreira Russo — licença CC BY-NC-ND 4.0 (veja o arquivo LICENSE)
# =====================================================================
# app.R  —  O "MAESTRO" DO APP (ESQUELETO)
# ---------------------------------------------------------------------
# Junta as partes:
#   dados.R            os dados (Big Five) e os rótulos dos itens;
#   glossario.R        as definições dos termos;
#   base_laboratorio.R as peças comuns do laboratório (visual, missões,
#                      glossário, relatório, autoria);
#   missoes.R          o roteiro das missões.
# Depois define a TELA (ui) e o CÉREBRO (server).
#
# ESTADO ATUAL: esqueleto. As abas 1 a 5 estão "em construção" e ainda não
# há nenhum cálculo de AFC. A AFC será feita com o pacote "sem" (o
# "lavaan" não roda no navegador — veja o CLAUDE.md).
# =====================================================================

library(shiny)
library(bslib)

# Identidade deste app (usada no cabeçalho, no relatório e na autoria)
TITULO_APP <- "Laboratório de Psicometria – Análise Fatorial Confirmatória"
URL_APP    <- "https://russofleonardo.github.io/app-afc/"
CHAVE_APP  <- "afc_missoes"   # nome do progresso das missões guardado no navegador

source("dados.R",            encoding = "UTF-8", local = TRUE)
source("glossario.R",        encoding = "UTF-8", local = TRUE)
source("base_laboratorio.R", encoding = "UTF-8", local = TRUE)
source("missoes.R",          encoding = "UTF-8", local = TRUE)

# O controle deslizante anda de 50 em 50; o último passo significa "todas".
N_MAX_SLIDER <- ceiling(N_TOTAL / 50) * 50

# ---------------------------------------------------------------------
# A TELA
# ---------------------------------------------------------------------

# Barra lateral, na ordem em que as decisões são tomadas numa AFC
barra_lateral <- sidebar(
  width = 280,
  title = "Controles da análise",

  titulo_bloco("1. Dados"),
  sliderInput("n_amostra", "Tamanho da amostra",
              min = 50, max = N_MAX_SLIDER, value = N_MAX_SLIDER, step = 50, ticks = FALSE, sep = "."),
  div(class = "small text-muted", style = "margin-top:-.6rem;", textOutput("resumo_amostra", inline = TRUE)),
  actionButton("sortear", "Sortear outra amostra", icon = icon("shuffle"), class = "btn-sm btn-outline-primary"),

  titulo_bloco("2. Modelo"),
  p(class = "small text-muted fst-italic", "Em construção: aqui entra a especificação do modelo (quais itens em quais fatores)."),

  titulo_bloco("3. Estimação"),
  p(class = "small text-muted fst-italic", "Em construção: aqui entram as opções de estimação."),

  rodape_autoria()
)

# --- Aba 0: comece aqui
aba_inicio <- nav_panel(
  "0. Comece aqui", value = "inicio",
  div(
    style = "max-width:980px;",
    h4(class = "mt-1", paste("Bem-vindo ao", TITULO_APP)),
    ph(class = "lead", style = "font-size:1.1rem;",
       "Aqui você vai aprender Análise Fatorial Confirmatória (AFC) <strong>fazendo</strong>: especificando modelos, testando hipóteses sobre a estrutura de um questionário e vendo as consequências de cada escolha."),

    h5(class = "mt-4", "A escala que vamos analisar"),
    ph("Vamos trabalhar com <strong>25 itens de personalidade</strong> do modelo dos <strong>Cinco Grandes Fatores</strong> (Big Five). Os itens vêm do <em>International Personality Item Pool</em> (IPIP) e foram respondidos on-line por 2.800 pessoas no projeto de pesquisa <em>SAPA</em> (conjunto <code>bfi</code> do pacote psych do R); usamos as <strong>2.436 pessoas</strong> que responderam a todos os itens."),
    legenda_dominios(),

    h5(class = "mt-4", "O que é a Análise Fatorial Confirmatória?"),
    ph(paste0("Na ", termo_html("afe", "análise fatorial exploratória (AFE)"), ", os dados mostram quantos fatores existem e quais itens se ligam a cada um. Na ",
              termo_html("afc", "análise fatorial confirmatória (AFC)"), ", o caminho é o inverso: <strong>o pesquisador diz de antemão</strong> qual item pertence a qual fator, e o modelo testa se os dados são compatíveis com essa hipótese.")),
    em_construcao("Esta seção será ampliada com: a ideia de especificar um modelo, os índices de ajuste, a comparação de modelos e o uso responsável dos índices de modificação."),

    h5(class = "mt-4", "AFE × AFC"),
    caixa_info(tags$ul(class = "mb-0",
      tags$li(HTML("<strong>AFE:</strong> explora — usada quando ainda estamos descobrindo a estrutura.")),
      tags$li(HTML("<strong>AFC:</strong> confirma — usada para testar uma estrutura definida antes (pela teoria ou por uma AFE feita em outra amostra).")))),

    h5(class = "mt-4", "A atividade"),
    em_construcao("Aqui vai a pergunta de pesquisa e o caminho pelas abas (1 a 5), como no laboratório de AFE."),

    h5(class = "mt-4", "Como usar o laboratório"),
    tags$ul(
      tags$li(HTML("<strong>Missões guiadas:</strong> no alto da página. Cada missão diz o que fazer, confere se você fez e termina com uma pergunta para refletir. O seu progresso fica salvo neste navegador.")),
      tags$li(HTML("<strong>Barra lateral:</strong> os controles da análise. Mexa à vontade: tudo é recalculado na hora.")),
      tags$li(HTML(paste0("<strong>Glossário:</strong> palavras com ", termo_html("afc", "sublinhado pontilhado"),
                          " têm uma definição curta — passe o mouse sobre elas. Experimente aqui mesmo!")))),
    botao_comecar_missoes(),

    secao_autoria(creditos_dados = "Dados: conjunto <code>bfi</code> do pacote psych (W. Revelle), com itens do International Personality Item Pool, coletados no projeto SAPA. Feito com R, Shiny, bslib, psych, sem e Shinylive, que mantêm suas próprias licenças.")
  )
)

# --- Abas 1 a 5: em construção (nomes sugeridos; podem mudar)
aba_itens <- nav_panel("1. Itens", value = "itens",
  em_construcao("Aqui vai a lista dos 25 itens (e, mais tarde, as decisões sobre eles)."), legenda_dominios())
aba_modelo <- nav_panel("2. Especificar o modelo", value = "modelo",
  em_construcao("Aqui a pessoa define o modelo: quais fatores existem, quais itens cada um influencia e se os fatores se correlacionam."))
aba_ajuste <- nav_panel("3. Ajuste do modelo", value = "ajuste",
  em_construcao("Aqui vão os índices de ajuste (qui-quadrado, CFI, TLI, RMSEA, SRMR) e a leitura deles."))
aba_cargas <- nav_panel("4. Cargas e resíduos", value = "cargas",
  em_construcao("Aqui vão as cargas padronizadas, os resíduos e os índices de modificação."))
aba_comparar <- nav_panel("5. Comparar modelos", value = "comparar",
  em_construcao("Aqui a pessoa compara modelos concorrentes (por exemplo, 1 × 5 fatores; fatores correlacionados × independentes)."))

abas <- navset_card_tab(
  id = "aba",
  aba_inicio, aba_itens, aba_modelo, aba_ajuste, aba_cargas, aba_comparar
)

ui <- pagina_laboratorio(barra_lateral, abas)

# ---------------------------------------------------------------------
# O CÉREBRO
# ---------------------------------------------------------------------
server <- function(input, output, session) {

  # --- A amostra
  semente <- reactiveVal(2026)
  observeEvent(input$sortear, semente(semente() + 1))
  n_amostra <- debounce(reactive(min(input$n_amostra, N_TOTAL)), 500)
  amostra <- reactive(sortear_amostra(n_amostra(), semente()))

  output$resumo_amostra <- renderText({
    n <- n_amostra()
    if (n >= N_TOTAL) sprintf("Usando todas as %s pessoas.", fmt_int(N_TOTAL))
    else sprintf("%s de %s pessoas (sorteio nº %d).", fmt_int(n), fmt_int(N_TOTAL), semente() - 2025)
  })

  # --- Missões: o que as condições podem conferir (acrescente aqui o que precisar)
  estado_missoes <- reactive(reactiveValuesToList(input))

  # --- Relatório (modelo vazio; será preenchido quando a AFC existir)
  relatorio <- function(info) div(
    class = "relatorio",
    relatorio_cabecalho(info, "Análise fatorial confirmatória de itens do Big Five"),
    h2("Método"), p(class = "vazio", "(Em construção.)"),
    h2("Resultados"), p(class = "vazio", "(Em construção.)"),
    h2("Justificativa das escolhas"), relatorio_justificativa(info),
    relatorio_rodape())

  servidor_missoes(input, output, session, estado_missoes, gerar_relatorio = relatorio)
}

shinyApp(ui, server)
