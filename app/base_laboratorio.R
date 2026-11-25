# Laboratório de Psicometria
# © 2026 Leonardo Ferreira Russo — licença CC BY-NC-ND 4.0 (veja o arquivo LICENSE)
# =====================================================================
# base_laboratorio.R  —  AS PEÇAS COMUNS DO LABORATÓRIO
# ---------------------------------------------------------------------
# Tudo o que é igual em todos os apps do Laboratório de Psicometria:
#   * números no formato brasileiro;
#   * peças visuais (selos, caixas, títulos da barra lateral);
#   * glossário (termos com definição ao passar o mouse);
#   * painel de missões guiadas (progresso salvo no navegador, por id);
#   * base do relatório em PDF;
#   * autoria, licença e o visual (cores, abas, links).
#
# Este arquivo NÃO tem nada específico de um app. Para começar um app
# novo do laboratório, copie este arquivo junto com a estrutura da pasta.
# Se melhorar algo aqui, vale levar a melhoria aos outros apps.
#
# O app precisa definir, antes de usar estas peças:
#   GLOSSARIO (glossario.R), MISSOES e NOMES_ABAS (missoes.R),
#   itens / DOMINIOS / CORES_DOMINIO (dados.R), e o navset das abas com id = "aba".
# =====================================================================

# ---------------------------------------------------------------------
# 1. Números no formato brasileiro
# ---------------------------------------------------------------------
fmt <- function(x, d = 2) {
  ifelse(is.na(x), "—",
         formatC(x, format = "f", digits = d, decimal.mark = ",", big.mark = "."))
}
fmt_int <- function(x) formatC(x, format = "d", big.mark = ".", decimal.mark = ",")
fmt_pct <- function(x, d = 1) paste0(fmt(100 * x, d), "%")
fmt_p <- function(p) if (p < 0.001) "< 0,001" else fmt(p, 3)
# Sinal de menos tipográfico e sem "−0,00": -0,45 -> "−0,45"
fmt_sinal <- function(x, d = 2) {
  x <- round(x, d)
  x[x == 0] <- 0
  sub("^-", "−", fmt(x, d))
}

# ---------------------------------------------------------------------
# 2. Cores e peças visuais
# ---------------------------------------------------------------------
TINTA       <- "#0b0b0b"
TINTA_2     <- "#52514e"
TINTA_FRACA <- "#898781"
AZUL        <- "#2a78d6"
MARINHO     <- "#2c3e50"

# Selo de situação: ícone + texto (nunca só cor)
selo <- function(nivel, texto) {
  estilos <- list(bom = c("✔︎", "#0ca30c"), atencao = c("⚠︎", "#c98500"),
                  ruim = c("✖︎", "#d03b3b"))
  e <- estilos[[nivel]]
  htmltools::tags$span(
    htmltools::tags$span(style = sprintf("color:%s;font-weight:700;margin-right:.3em;", e[2]), e[1]), texto)
}

# Um item com o quadradinho colorido do domínio + nome
chip_item <- function(codigo) {
  htmltools::tags$span(
    htmltools::tags$span(style = sprintf(
      "display:inline-block;width:.8em;height:.8em;border-radius:2px;margin-right:.45em;vertical-align:-.05em;background:%s;",
      itens[codigo, "cor"])),
    itens[codigo, "nome"])
}

# Legenda das cores dos domínios
legenda_dominios <- function() {
  htmltools::div(
    class = "d-flex flex-wrap gap-3 small mb-2",
    lapply(names(DOMINIOS), function(l) htmltools::tags$span(
      htmltools::tags$span(style = sprintf(
        "display:inline-block;width:.85em;height:.85em;border-radius:2px;margin-right:.35em;vertical-align:-.05em;background:%s;",
        CORES_DOMINIO[[l]])),
      paste0(l, " = ", DOMINIOS[[l]]))),
    htmltools::tags$span(class = "text-muted", "(−) = item invertido"))
}

# Parágrafo escrito em HTML (o negrito fica "colado" à pontuação)
ph <- function(texto, ...) shiny::p(shiny::HTML(texto), ...)

# Caixa de destaque com fundo claro (e, se quiser, uma barra colorida à esquerda)
caixa_info <- function(..., cor = "#f4f3ef", borda = NULL) shiny::div(
  class = "p-3 mb-3 rounded",
  style = paste0("background:", cor, ";", if (!is.null(borda)) paste0("border-left:5px solid ", borda, ";")),
  ...)

# Título de bloco na barra lateral ("1. Dados", "2. Modelo"…)
titulo_bloco <- function(texto) shiny::div(
  class = "small text-uppercase fw-bold mt-1 mb-n1",
  style = sprintf("letter-spacing:.05em;color:%s;border-bottom:1px solid #d9dde3;padding-bottom:.15rem;", MARINHO),
  texto)

# Caixa de resultado (value box) clara: verde = bom, azul = aceitável,
# amarelo = medíocre, vermelho = ruim. "nivel" também aceita TRUE/FALSE.
CORES_CAIXA <- list(
  bom       = c(borda = "#0ca30c", fundo = "#eef8ee"),
  aceitavel = c(borda = "#2a78d6", fundo = "#eef4fc"),
  mediocre  = c(borda = "#c98500", fundo = "#fdf5e6"),
  ruim      = c(borda = "#d03b3b", fundo = "#fbeeee"))
caixa_clara <- function(nivel, ..., icone = NULL) {
  if (is.logical(nivel)) nivel <- if (isTRUE(nivel)) "aceitavel" else "ruim"
  cores <- if (nivel %in% names(CORES_CAIXA)) CORES_CAIXA[[nivel]] else CORES_CAIXA$aceitavel
  bslib::value_box(
    ...,
    showcase = if (!is.null(icone)) shiny::icon(icone, style = sprintf("color:%s;", cores[["borda"]])),
    theme = bslib::value_box_theme(bg = cores[["fundo"]], fg = "#1f1f1f"),
    style = sprintf("border-left: 6px solid %s;", cores[["borda"]]))
}
# Linha de referência dentro de uma caixa clara
nota_caixa <- function(...) shiny::p(class = "small mb-0", style = "color:#52514e;", ...)

# Aviso "em construção" (para as abas que ainda vão ser feitas)
em_construcao <- function(...) caixa_info(
  cor = "#fdf5e6", borda = "#c98500",
  shiny::p(class = "fw-bold mb-1", "\U0001F6A7 Em construção"),
  shiny::p(class = "mb-0", ...))

# ---------------------------------------------------------------------
# 3. Glossário (as definições ficam em glossario.R, no objeto GLOSSARIO)
# ---------------------------------------------------------------------
termo <- function(chave, texto = chave) {
  htmltools::tags$span(class = "termo", tabindex = "0",
                       `data-bs-toggle` = "tooltip", `data-bs-title` = GLOSSARIO[[chave]], texto)
}
termo_html <- function(chave, texto = chave) {
  sprintf("<span class='termo' tabindex='0' data-bs-toggle='tooltip' data-bs-title='%s'>%s</span>",
          htmltools::htmlEscape(GLOSSARIO[[chave]], attribute = TRUE), texto)
}

# ---------------------------------------------------------------------
# 4. Missões: condições prontas e conferência
# ---------------------------------------------------------------------
# Cada condição tem um rótulo e um teste. O teste recebe "i" (os controles
# do app + o que o app quiser acrescentar) e devolve TRUE ou FALSE.
cond <- function(rotulo, teste) list(rotulo = rotulo, teste = teste)
cond_aba <- function(aba) cond(sprintf("Abrir a aba “%s”", NOMES_ABAS[[aba]]),
                               function(i) identical(i$aba, aba))
cond_amostra_completa <- function() cond("Tamanho da amostra no máximo (todas as pessoas)",
                                         function(i) isTRUE(i$n_amostra >= N_TOTAL))

conferir_missao <- function(m, i) {
  vapply(m$condicoes, function(cd) isTRUE(tryCatch(cd$teste(i), error = function(e) FALSE)), logical(1))
}

# ---------------------------------------------------------------------
# 5. Missões: peças visuais do painel
# ---------------------------------------------------------------------
CORES_NIVEL <- c("Básico" = "#1baf7a", "Intermediário" = "#2a78d6",
                 "Avançado" = "#6250d6", "Desafio" = "#d03b3b")
selo_nivel <- function(nivel) htmltools::tags$span(
  class = "badge rounded-pill", style = sprintf("background:%s;", CORES_NIVEL[[nivel]]), nivel)

botoes_missoes <- function(atual, concluidas) {
  htmltools::div(
    class = "d-flex flex-wrap gap-1 mb-2",
    lapply(seq_along(MISSOES), function(k) {
      m <- MISSOES[[k]]; feita <- k %in% concluidas
      classe <- if (k == atual && feita) "btn-success" else if (k == atual) "btn-primary"
                else if (feita) "btn-outline-success" else "btn-outline-secondary"
      htmltools::tags$button(
        type = "button", class = paste("btn btn-sm botao-missao", classe),
        title = sprintf("Missão %d (%s): %s%s", k, m$nivel, m$titulo, if (feita) " — concluída" else ""),
        onclick = sprintf("Shiny.setInputValue('missao_escolhida', %d, {priority: 'event'})", k),
        if (feita) paste0(k, " ✔︎") else as.character(k))
    }))
}

progresso_missoes <- function(concluidas) {
  n <- length(concluidas); total <- length(MISSOES)
  htmltools::div(
    class = "mb-2",
    htmltools::div(class = "small text-muted mb-1", sprintf("%d de %d missões concluídas", n, total)),
    htmltools::div(class = "progress", style = "height:6px;",
                   htmltools::div(class = "progress-bar bg-success", role = "progressbar",
                                  style = sprintf("width:%.0f%%;", 100 * n / total))))
}

conteudo_missao <- function(k) {
  m <- MISSOES[[k]]
  htmltools::tagList(
    htmltools::div(class = "d-flex flex-wrap align-items-center gap-2 mb-2",
                   selo_nivel(m$nivel), htmltools::tags$strong(sprintf("Missão %d: %s", k, m$titulo))),
    htmltools::tags$button(
      type = "button", class = "btn btn-sm btn-outline-primary mb-2",
      onclick = sprintf("Shiny.setInputValue('ir_para_aba', '%s', {priority: 'event'})", m$aba),
      paste0("Ir para a aba “", NOMES_ABAS[[m$aba]], "” →")),
    htmltools::p(class = "mb-2", htmltools::strong("Objetivo: "), m$objetivo),
    htmltools::div(class = "fw-bold small text-uppercase text-muted", "O que fazer"),
    htmltools::tags$ol(class = "ps-3 mb-2", lapply(m$passos, htmltools::tags$li)))
}

lista_conferencia <- function(m, ok) {
  htmltools::tagList(
    htmltools::div(class = "fw-bold small text-uppercase text-muted", "Conferência do app"),
    htmltools::tags$ul(class = "list-unstyled mb-2 small", lapply(seq_along(m$condicoes), function(j) htmltools::tags$li(
      if (ok[j]) htmltools::tags$span(style = "color:#0ca30c;font-weight:700;", "✔︎ ")
      else htmltools::tags$span(style = sprintf("color:%s;font-weight:700;", TINTA_FRACA), "○ "),
      htmltools::tags$span(class = if (!ok[j]) "text-muted", m$condicoes[[j]]$rotulo)))))
}

reflexao_missao <- function(k) {
  m <- MISSOES[[k]]
  htmltools::div(
    class = "mt-3 p-2 rounded", style = "background:#f4f3ef;",
    htmltools::div(class = "fw-bold small text-uppercase text-muted", "Para refletir"),
    htmltools::p(class = "mb-1", m$reflexao),
    htmltools::tags$details(
      htmltools::tags$summary(class = "small", "Pense um pouco… e depois clique para ver o comentário"),
      htmltools::p(class = "small mt-2 mb-0", m$comentario)))
}

# Painel completo (cabeçalho que abre e fecha + conteúdo). Começa fechado,
# com o botão "Abrir as missões" pulsando até a primeira abertura.
painel_missoes_ui <- function() {
  shiny::tagList(
    bslib::card(
      class = "painel-missoes", fill = FALSE,
      bslib::card_header(
        class = "p-0",
        htmltools::tags$button(
          type = "button", id = "botao_recolher_missoes",
          class = "botao-recolher btn w-100 d-flex align-items-center gap-2 text-start px-3 py-2",
          `data-bs-toggle` = "collapse", `data-bs-target` = "#corpo_missoes",
          `aria-expanded` = "false", `aria-controls` = "corpo_missoes",
          shiny::span(class = "seta", "▾"),
          shiny::span(class = "fw-semibold text-nowrap", "Missões guiadas"),
          shiny::span(class = "small text-muted text-truncate", style = "min-width:0;",
                      shiny::uiOutput("missoes_resumo", inline = TRUE)),
          shiny::span(class = "rotulo ms-auto small text-nowrap"))),
      bslib::card_body(
        padding = 0, gap = 0, fillable = FALSE,
        shiny::div(id = "corpo_missoes", class = "collapse",
          shiny::div(class = "corpo-missoes p-3",
            shiny::uiOutput("missoes_topo"), shiny::uiOutput("missao_texto"),
            shiny::uiOutput("missao_conferencia"), shiny::uiOutput("missao_reflexao"),
            shiny::div(class = "mt-3 text-end",
                       shiny::actionLink("recomecar_missoes", "Recomeçar as missões", class = "small text-muted")))))),
    # Progresso salvo no navegador (localStorage), pelo id de cada missão.
    # "chave" separa o progresso de cada app do laboratório.
    shiny::tags$script(shiny::HTML(sprintf("
      $(document).on('shiny:connected', function() {
        var salvo = null;
        try { salvo = JSON.parse(localStorage.getItem('%1$s')); } catch (e) {}
        Shiny.setInputValue('missoes_salvas', salvo || {versao: 2, concluidas: [], atual: null});
      });
      Shiny.addCustomMessageHandler('salvar_missoes', function(x) {
        try { localStorage.setItem('%1$s', JSON.stringify(x)); } catch (e) {}
      });
      $(function() {
        var corpo = document.getElementById('corpo_missoes');
        var botao = document.getElementById('botao_recolher_missoes');
        var salvo = null;
        try { salvo = localStorage.getItem('%1$s_fechado'); } catch (e) {}
        if (salvo === '0') { corpo.classList.add('show'); botao.setAttribute('aria-expanded', 'true'); }
        if (salvo === null) botao.classList.add('nunca-aberto');
        corpo.addEventListener('hidden.bs.collapse', function() { try { localStorage.setItem('%1$s_fechado', '1'); } catch (e) {} });
        corpo.addEventListener('shown.bs.collapse', function() {
          botao.classList.remove('nunca-aberto');
          try { localStorage.setItem('%1$s_fechado', '0'); } catch (e) {}
        });
      });", CHAVE_APP))))
}

# Botão que abre o painel de missões já na missão 1 (para a aba 0)
botao_comecar_missoes <- function() htmltools::tags$button(
  type = "button", class = "btn btn-primary mt-1 mb-4",
  onclick = paste0(
    "Shiny.setInputValue('missao_escolhida', 1, {priority: 'event'});",
    "bootstrap.Collapse.getOrCreateInstance(document.getElementById('corpo_missoes')).show();",
    "setTimeout(function() { document.querySelector('.painel-missoes').scrollIntoView({behavior: 'smooth', block: 'start'}); }, 50);"),
  "Começar pela missão 1 →")

# ---------------------------------------------------------------------
# 6. Missões: o servidor (progresso, troca, conclusão, relatório)
# ---------------------------------------------------------------------
# estado: reactive com tudo o que as condições das missões podem conferir
#         (em geral, reactiveValuesToList(input) + o que o app acrescentar).
# gerar_relatorio: função(info) que devolve o HTML do relatório; o botão
#         do relatório aparece na última missão.
servidor_missoes <- function(input, output, session, estado, gerar_relatorio = NULL) {
  ids <- vapply(MISSOES, `[[`, "", "id")
  stopifnot(!anyDuplicated(ids))
  total <- length(MISSOES)
  missao_atual <- shiny::reactiveVal(1L)
  concluidas <- shiny::reactiveVal(integer(0))

  salvar <- function() session$sendCustomMessage("salvar_missoes", list(
    versao = 2, concluidas = as.list(ids[concluidas()]), atual = ids[[missao_atual()]]))

  shiny::observeEvent(input$missoes_salvas, {
    s <- input$missoes_salvas
    feitas <- match(as.character(unlist(s$concluidas)), ids)
    concluidas(sort(unique(feitas[!is.na(feitas)])))
    a <- match(as.character(unlist(s$atual)), ids)
    if (length(a) == 1 && !is.na(a)) missao_atual(a)
  }, once = TRUE)

  shiny::observeEvent(input$missao_escolhida, {
    k <- as.integer(input$missao_escolhida)
    if (!is.na(k) && k >= 1 && k <= total) { missao_atual(k); salvar() }
  })
  shiny::observeEvent(input$missao_concluida, {
    k <- as.integer(input$missao_concluida)
    if (!is.na(k) && all(conferir_missao(MISSOES[[k]], estado()))) {
      concluidas(sort(unique(c(concluidas(), k)))); salvar()
    }
  })
  shiny::observeEvent(input$ir_para_aba, bslib::nav_select("aba", input$ir_para_aba))
  shiny::observeEvent(input$recomecar_missoes, { concluidas(integer(0)); missao_atual(1L); salvar() })

  output$missoes_topo <- shiny::renderUI(shiny::tagList(
    progresso_missoes(concluidas()), botoes_missoes(missao_atual(), concluidas())))
  output$missoes_resumo <- shiny::renderUI({
    k <- missao_atual()
    shiny::span(sprintf("· Missão %d: %s%s · %d de %d concluídas", k, MISSOES[[k]]$titulo,
                        if (k %in% concluidas()) " ✔︎" else "", length(concluidas()), total))
  })
  output$missao_texto <- shiny::renderUI(conteudo_missao(missao_atual()))
  output$missao_reflexao <- shiny::renderUI(reflexao_missao(missao_atual()))

  output$missao_conferencia <- shiny::renderUI({
    k <- missao_atual(); m <- MISSOES[[k]]
    feita <- k %in% concluidas()
    ok <- conferir_missao(m, estado())
    botao <- if (feita) {
      shiny::div(class = "d-flex flex-wrap align-items-center gap-2",
        shiny::span(class = "fw-bold", style = "color:#0ca30c;", "✔︎ Missão concluída!"),
        if (k < total) htmltools::tags$button(
          type = "button", class = "btn btn-sm btn-primary",
          onclick = sprintf("Shiny.setInputValue('missao_escolhida', %d, {priority: 'event'})", k + 1),
          "Próxima missão →")
        else shiny::span(class = "small", "Você concluiu todas as missões. Parabéns!"))
    } else {
      shiny::tagList(
        htmltools::tags$button(
          type = "button", class = "btn btn-sm btn-success", disabled = if (!all(ok)) NA,
          onclick = sprintf("Shiny.setInputValue('missao_concluida', %d, {priority: 'event'})", k),
          "✔︎ Concluí esta missão"),
        if (!all(ok)) shiny::div(class = "small text-muted mt-1",
                                 "O botão é liberado quando todos os itens da conferência estiverem marcados."))
    }
    botao_rel <- if (!is.null(gerar_relatorio) && k == total) shiny::div(
      class = "mt-3 p-2 rounded", style = "background:#eef4fc;",
      shiny::p(class = "small mb-2", shiny::strong("Relatório da sua pesquisa: "),
               "monte um relatório no estilo de artigo e salve em PDF."),
      htmltools::tags$button(
        type = "button", class = paste("btn btn-sm", if (feita) "btn-primary" else "btn-outline-primary"),
        onclick = "Shiny.setInputValue('abrir_relatorio', Math.random(), {priority: 'event'})",
        shiny::icon("file-lines"), " Gerar o relatório da sua pesquisa"))
    shiny::tagList(lista_conferencia(m, ok), botao, botao_rel)
  })

  # --- Relatório (formulário -> visualização -> PDF/HTML)
  if (!is.null(gerar_relatorio)) {
    ou_vazio <- function(x) if (is.null(x)) "" else as.character(x)
    rel <- shiny::reactiveValues(autor = "", titulo = "", justificativa = "")
    formulario <- function() shiny::modalDialog(
      title = "Relatório da sua pesquisa",
      shiny::p(class = "small text-muted", "O relatório usa a solução escolhida agora no app. Os campos são opcionais."),
      shiny::textInput("rel_autor", "Seu nome", value = rel$autor, width = "100%"),
      shiny::textInput("rel_titulo", "Título do estudo", value = rel$titulo, width = "100%"),
      shiny::textAreaInput("rel_justificativa", "Justificativa das suas escolhas",
                           value = rel$justificativa, width = "100%", rows = 7),
      footer = shiny::tagList(shiny::modalButton("Cancelar"),
                              shiny::actionButton("ver_relatorio", "Gerar relatório", icon = shiny::icon("file-lines"),
                                                  class = "btn-primary")),
      easyClose = TRUE)
    info_relatorio <- shiny::reactive(list(autor = rel$autor, titulo = rel$titulo,
                                           justificativa = rel$justificativa, data = format(Sys.Date(), "%d/%m/%Y")))
    shiny::observeEvent(input$abrir_relatorio, shiny::showModal(formulario()))
    shiny::observeEvent(input$editar_relatorio, shiny::showModal(formulario()))
    shiny::observeEvent(input$ver_relatorio, {
      rel$autor <- ou_vazio(input$rel_autor); rel$titulo <- ou_vazio(input$rel_titulo)
      rel$justificativa <- ou_vazio(input$rel_justificativa)
      shiny::showModal(shiny::modalDialog(
        size = "xl", easyClose = TRUE, title = NULL,
        shiny::div(class = "nao-imprimir small p-2 mb-3 rounded", style = "background:#fdf5e6;",
                   shiny::strong("Para salvar em PDF: "), "clique em “Salvar como PDF” e, na janela de impressão, escolha ",
                   shiny::em("Salvar como PDF"), " como destino."),
        gerar_relatorio(info_relatorio()),
        footer = shiny::div(class = "nao-imprimir d-flex flex-wrap gap-2",
          htmltools::tags$button(type = "button", class = "btn btn-primary", onclick = "window.print()",
                                 shiny::icon("file-pdf"), " Salvar como PDF"),
          shiny::downloadButton("baixar_relatorio", "Baixar (HTML)", class = "btn-outline-secondary"),
          shiny::actionButton("editar_relatorio", "Voltar e editar", icon = shiny::icon("pen"), class = "btn-outline-secondary"),
          shiny::modalButton("Fechar"))))
    })
    output$baixar_relatorio <- shiny::downloadHandler(
      filename = function() "relatorio.html",
      content = function(arquivo) writeLines(relatorio_pagina(gerar_relatorio(info_relatorio())), arquivo, useBytes = TRUE))
  }

  list(missao_atual = missao_atual, concluidas = concluidas)
}

# ---------------------------------------------------------------------
# 7. Relatório: estilo (tela e impressão em A4) e página para baixar
# ---------------------------------------------------------------------
CSS_RELATORIO <- "
.relatorio { font-family: Georgia, 'Times New Roman', serif; color: #111; font-size: 11.5pt; line-height: 1.5; }
.relatorio h1 { font-size: 17pt; margin: 0 0 .3rem; }
.relatorio h2 { font-size: 13.5pt; margin: 1.3rem 0 .4rem; border-bottom: 1px solid #999; padding-bottom: .15rem; }
.relatorio h3 { font-size: 11.5pt; font-style: italic; margin: .8rem 0 .2rem; }
.relatorio p { margin: 0 0 .55rem; text-align: justify; }
.relatorio .rel-autor { font-size: 12pt; margin: 0; }
.relatorio .rel-data { font-size: 9.5pt; color: #555; }
.relatorio .tab-titulo { margin: .9rem 0 .25rem; text-align: left; }
.relatorio .tab-rel { border-collapse: collapse; width: 100%; font-size: 9.5pt; margin-bottom: .6rem; }
.relatorio .tab-rel th, .relatorio .tab-rel td { padding: .12rem .4rem; vertical-align: top; }
.relatorio .tab-rel thead th { border-top: 1.5px solid #111; border-bottom: 1px solid #111; text-align: left; }
.relatorio .tab-rel tbody tr:last-child td, .relatorio .tab-rel tbody tr:last-child th { border-bottom: 1.5px solid #111; }
.relatorio .tab-rel .num { text-align: right; font-variant-numeric: tabular-nums; white-space: nowrap; }
.relatorio .vazio { color: #777; font-style: italic; }
.relatorio .rel-rodape { margin-top: 1.5rem; padding-top: .4rem; border-top: 1px solid #999; font-size: 8.5pt; color: #444; }
.relatorio .rel-rodape p { margin: 0 0 .2rem; text-align: left; }
@media print {
  @page { size: A4; margin: 16mm 15mm; }
  body * { visibility: hidden !important; }
  .relatorio, .relatorio * { visibility: visible !important; }
  .relatorio { position: absolute; left: 0; top: 0; width: 100%; }
  .modal, .modal-dialog, .modal-content, .modal-body { position: static !important; overflow: visible !important;
    transform: none !important; max-width: none !important; margin: 0 !important; padding: 0 !important; border: 0 !important; box-shadow: none !important; }
  .modal-backdrop, .nao-imprimir { display: none !important; }
  .relatorio .tab-rel tr { page-break-inside: avoid; }
  .relatorio h2, .relatorio h3, .relatorio .tab-titulo { page-break-after: avoid; }
}
"

relatorio_pagina <- function(conteudo) {
  htmltools::doRenderTags(htmltools::tags$html(
    htmltools::tags$head(htmltools::tags$meta(charset = "utf-8"), htmltools::tags$title(TITULO_APP),
                         htmltools::tags$style(htmltools::HTML(paste0(CSS_RELATORIO,
                           " body { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }")))),
    htmltools::tags$body(conteudo)))
}

# Cabeçalho e rodapé padrão de um relatório do laboratório
relatorio_cabecalho <- function(info, titulo_padrao) htmltools::div(
  class = "rel-cabecalho",
  htmltools::tags$h1(if (nzchar(trimws(info$titulo))) info$titulo else titulo_padrao),
  htmltools::p(class = "rel-autor", if (nzchar(trimws(info$autor))) info$autor else "Autor(a) não informado(a)"),
  htmltools::p(class = "rel-data", sprintf("Relatório gerado em %s · %s", info$data, TITULO_APP)))

relatorio_rodape <- function() htmltools::div(
  class = "rel-rodape",
  htmltools::p(sprintf("Russo, L. F. (2026). %s [Aplicativo web]. %s", TITULO_APP, URL_APP)),
  htmltools::p("Laboratório licenciado sob CC BY-NC-ND 4.0."))

relatorio_justificativa <- function(info) {
  if (nzchar(trimws(info$justificativa))) lapply(strsplit(trimws(info$justificativa), "\n+")[[1]], htmltools::p)
  else htmltools::p(class = "vazio", "(Não preenchida.)")
}

# ---------------------------------------------------------------------
# 8. Autoria e licença
# ---------------------------------------------------------------------
URL_LICENCA <- "https://creativecommons.org/licenses/by-nc-nd/4.0/deed.pt-br"

# Rodapé da barra lateral (sempre visível)
rodape_autoria <- function() shiny::div(
  class = "small text-muted mt-4 pt-2 border-top",
  shiny::HTML(paste0(
    "© 2026 <strong>Leonardo Ferreira Russo</strong><br>",
    "Licença <a href='", URL_LICENCA, "' target='_blank' rel='noopener'>CC BY-NC-ND 4.0</a>",
    " · <a href='#' onclick=\"document.querySelector('a[data-value=inicio]').click(); setTimeout(function(){document.getElementById('autoria').scrollIntoView({behavior:'smooth'});}, 150); return false;\">como citar</a>")))

# Seção "Autoria, licença e como citar" (no fim da aba 0)
secao_autoria <- function(creditos_dados = NULL) shiny::tagList(
  shiny::h5(class = "mt-4", id = "autoria", "Autoria, licença e como citar"),
  caixa_info(
    ph(class = "mb-2", sprintf(
      "Este laboratório foi criado por <strong>Leonardo Ferreira Russo</strong> © 2026. O código, os textos, as missões e o material didático estão licenciados sob a licença <a href='%s' target='_blank' rel='noopener'>Creative Commons Atribuição-NãoComercial-SemDerivações 4.0 (CC BY-NC-ND 4.0)</a>.", URL_LICENCA)),
    ph(class = "small mb-2",
       "Você pode <strong>usar e compartilhar</strong> o laboratório (por exemplo, em aulas), desde que <strong>cite o autor</strong>, <strong>não use para fins comerciais</strong> e <strong>não distribua versões modificadas</strong>. Outros usos dependem de autorização do autor."),
    ph(class = "small mb-2", sprintf("<strong>Como citar:</strong> Russo, L. F. (2026). <em>%s</em> [Aplicativo web]. %s", TITULO_APP, URL_APP)),
    if (!is.null(creditos_dados)) ph(class = "small text-muted mb-0", creditos_dados)))

# ---------------------------------------------------------------------
# 9. Visual comum: tema, estilos e scripts
# ---------------------------------------------------------------------
tema_laboratorio <- function() bslib::bs_theme(
  version = 5, bootswatch = "flatly", "link-color" = "#2a78d6", "link-hover-color" = "#1f62b3")

estilos_laboratorio <- function() shiny::tagList(
  shiny::tags$style(shiny::HTML("
    .nav-tabs .nav-link { padding: .5rem .55rem; font-size: .97rem; }
    .nav-tabs .nav-link, .nav-underline .nav-link { color: #2c3e50; }
    .nav-tabs .nav-link:hover, .nav-underline .nav-link:hover { color: #1a252f; text-decoration: underline; }
    .nav-tabs .nav-link.active, .nav-underline .nav-link.active { color: #1f1f1f; font-weight: 600; }
    .botao-missao { min-width: 2.3rem; }
    .termo { border-bottom: 1.5px dotted #6c8bb5; cursor: help; }
    .termo:focus { outline: 2px solid #b7d3f6; outline-offset: 1px; }
    .tooltip-inner { max-width: 320px; text-align: left; font-size: .85rem; }
    .botao-recolher { border: 0; border-radius: 0; }
    .botao-recolher:hover { background: rgba(0,0,0,.04); }
    .botao-recolher .seta { display: inline-block; transition: transform .2s; }
    .botao-recolher[aria-expanded='false'] .seta { transform: rotate(-90deg); }
    .botao-recolher .rotulo { color: #6c757d; }
    .botao-recolher .rotulo::after { content: 'fechar \\25B4'; }
    .botao-recolher[aria-expanded='false'] .rotulo { color: #fff; background: #2a78d6; border-radius: 999px; padding: .25rem .8rem; font-weight: 600; }
    .botao-recolher[aria-expanded='false'] .rotulo::after { content: 'Abrir as missões \\25BE'; }
    .botao-recolher[aria-expanded='false']:hover .rotulo { background: #1f62b3; }
    .botao-recolher[aria-expanded='false'] { background: #eef4fc; }
    @keyframes pulso-missoes { 0%, 100% { box-shadow: 0 0 0 0 rgba(42,120,214,.55); } 50% { box-shadow: 0 0 0 7px rgba(42,120,214,0); } }
    .botao-recolher.nunca-aberto[aria-expanded='false'] .rotulo { animation: pulso-missoes 2s ease-in-out infinite; }
    @media (prefers-reduced-motion: reduce) { .botao-recolher.nunca-aberto .rotulo { animation: none; } }
    .painel-missoes { height: auto !important; }
    .painel-missoes .corpo-missoes { overflow-y: auto; max-height: 55vh; }
    @media (max-width: 1399.98px) { .bslib-grid > :has(> .painel-missoes) { order: -1; } }
    @media (min-width: 1400px) {
      .painel-missoes { position: sticky; top: 1rem; }
      .painel-missoes .corpo-missoes { max-height: calc(100vh - 7rem); }
    }
  ")),
  shiny::tags$style(shiny::HTML(CSS_RELATORIO)),
  # Balões do glossário em todo o app (inclusive no conteúdo que aparece depois)
  shiny::tags$script(shiny::HTML("
    $(function() { new bootstrap.Tooltip(document.body, {selector: '[data-bs-toggle=\"tooltip\"]', trigger: 'hover focus'}); });
  ")))

# Página padrão do laboratório: cabeçalho, barra lateral, abas + painel de missões
pagina_laboratorio <- function(barra_lateral, abas) bslib::page_sidebar(
  title = TITULO_APP,
  theme = tema_laboratorio(),
  sidebar = barra_lateral,
  fillable = FALSE,
  estilos_laboratorio(),
  bslib::layout_columns(
    col_widths = bslib::breakpoints(sm = 12, xxl = c(8, 4)),
    abas,
    painel_missoes_ui()))
