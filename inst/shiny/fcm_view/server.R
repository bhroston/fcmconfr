
server <- function(input, output) {

  # Load input visNetwork obj ----
  input_visNetwork <- shiny::reactive({
    fcm_visNetwork
  })

  input_nodes <- shiny::reactive({
    input_visNetwork()$x$nodes
  })

  input_edges <- shiny::reactive({
    input_visNetwork()$x$edges
  })

  input_opts <- shiny::reactive({
    input_visNetwork()$x$options
  })
  # ----


  # fcm_display and visNetworkProxy ----
  output$fcm_display <- visNetwork::renderVisNetwork({
    fcm_visNetwork %>%
      visNetwork::visOptions(nodesIdSelection = TRUE) %>%
      visNetwork::visInteraction(zoomSpeed = 0.5) %>%
      visNetwork::visEdges(
        smooth = list(
          enabled = TRUE,
          type = input_opts()$edges$smooth$type,
          roundness = input_opts()$edges$smooth$roundness
        ),
        physics = FALSE
      )
  })

  fcm_display <- visNetwork::visNetworkProxy("fcm_display")

  shiny::observe({
    shiny::invalidateLater(1000)
    fcm_display %>%
      visNetwork::visGetNodes() %>%
      visNetwork::visGetEdges() %>%
      visNetwork::visGetPositions()
  })

  if (alert_on_open) {
    shinyWidgets::sendSweetAlert(
      title = "",
      text = shiny::tags$div(
        shiny::HTML(
          "Store call to fcm_view() in a variable to save changes
        <br>
        <br>
        <pre>fcm_view_output <- fcm_view(...)</pre>"
        )
      ), type = "info"
    )
  }
  # ----


  # nodes, edges, and coords data ----
  nodes <- shiny::reactive({
    if (!is.null(input$fcm_display_nodes)) {
      nodes_df <- data.frame(do.call(rbind, input$fcm_display_nodes))
      nodes_df <- as.data.frame(apply(nodes_df, c(1, 2), function(element) element[[1]], simplify = TRUE))
      nodes_df$x <- as.numeric(nodes_df$x)
      nodes_df$y <- as.numeric(nodes_df$y)
      nodes_df
    }
  })

  edges <- shiny::reactive({
    if (!is.null(input$fcm_display_edges)) {
      edges_df <- data.frame(do.call(rbind, input$fcm_display_edges))
      edges_df <- as.data.frame(apply(edges_df, c(1, 2), function(element) element[[1]], simplify = TRUE))
      edges_df$weight <- as.numeric(edges_df$weight)
      edges_df
    }
  })

  coords <- shiny::reactive({
    if (!is.null(input$fcm_display_positions)) {
      data.frame(do.call(rbind, input$fcm_display_positions))
    }
  })
  # ----


  # uiOutput calls ----
  output$show_node_labels <- shiny::renderUI({
    shinyWidgets::prettyCheckbox(
      inputId = "show_node_labels",
      label = "Node labels",
      value = ifelse(all(nodes()$label == ""), FALSE, TRUE),
      inline = TRUE,
      status = "primary"
    )
  })

  output$show_edge_labels <- shiny::renderUI({
    shinyWidgets::prettyCheckbox(
      inputId = "show_edge_labels",
      label = "Edge labels",
      value = ifelse(all(edges()$label == " "), FALSE, TRUE),
      inline = TRUE,
      status = "primary"
    )
  })

  output$nodes_to_display <- shiny::renderUI({
    if (!is.null(input_nodes())) {
      shinyWidgets::virtualSelectInput(
        inputId = "nodes_to_display",
        label = "",
        choices = input_nodes()$id,
        multiple = TRUE,
        selected = input_nodes()$id[input_nodes()$color != "transparent"]
      )
    }
  })

  output$node_shape <- shiny::renderUI({
    shiny::selectInput(
      inputId = "node_shape",
      label = "Node shape:",
      choices = c("dot", "box", "text"),
      selected = input_opts()$nodes$shape
    )
  })

  output$node_size <- shiny::renderUI({
    shiny::numericInput(
      inputId = "node_size",
      label = "Node size ('dot' only):",
      value = unique(input_opts()$nodes$size),
      min = 1,
      step = 5,
    )
  })

  output$arrow_size <- shiny::renderUI({
    shiny::numericInput(
      inputId = "arrow_size",
      label = "Arrow size",
      value = input_opts()$edges$arrows$to$scaleFactor,
      min = 0,
      step = 0.5
    )
  })

  output$edge_roundness <- shiny::renderUI({
    shiny::sliderInput(
      inputId = "edge_roundness",
      label = "Edge roundness:",
      value = input_opts()$edges$smooth$roundness,
      step = 0.1,
      min = 0,
      max = 1
    )
  })

  output$edge_smoothing <- shiny::renderUI({
    shiny::selectInput(
      inputId = "edge_smoothing",
      label = "Edge smoothing method:",
      choices = c(
        'dynamic', 'continuous', 'discrete', 'diagonalCross', 'straightCross',
        'horizontal', 'vertical', 'curvedCW', 'curvedCCW', 'cubicBezier'
      ),
      selected = input_opts()$edges$smooth$type
    )
  })

  output$font_size <- shiny::renderUI({
    shiny::numericInput(
      inputId = "font_size",
      label = "Font size:",
      value = input_opts()$nodes$font$size,
      step = 1
    )
  })
  # ----


  # ui value updates ----
  shiny::observeEvent(input$node_shape, {
    fcm_display %>%
      visNetwork::visNodes(shape = input$node_shape)
  })

  shiny::observeEvent(input$node_size, {
    fcm_display %>%
      visNetwork::visNodes(size = input$node_size)
  })

  shiny::observeEvent(input$arrow_size, {
    fcm_display %>%
      visNetwork::visEdges(
        arrows = list(to = list(enabled = TRUE, scaleFactor = input$arrow_size))
      )
  })

  shiny::observeEvent(input$edge_roundness, {
    fcm_display %>%
      visNetwork::visEdges(
        smooth = list(
          roundness = input$edge_roundness
        )
      )
  })

  shiny::observeEvent(input$edge_smoothing, {
    fcm_display %>%
      visNetwork::visEdges(
        smooth = list(
          type = input$edge_smoothing
        )
      )
  })

  shiny::observeEvent(input$font_size, {
    fcm_display %>%
      visNetwork::visNodes(font = list(size = input$font_size)) %>%
      visNetwork::visEdges(font = list(size = input$font_size))
  })
  # ----


  # nodes/edges to display ----
  shiny::observe({
    if (!is.null(input$nodes_to_display) & !is.null(nodes()) & !is.null(edges())) {
      nodes_to_display <- nodes()$id[nodes()$id %in% input$nodes_to_display]
      nodes_to_hide <- nodes()$id[!(nodes()$id %in% input$nodes_to_display)]

      # Filter nodes ----
      nodes_to_display_indices <- which(nodes()$id %in% input$nodes_to_display)
      node_color <- vector(mode = "character", length = nrow(nodes()))
      for (i in seq_along(node_color)) {
        if (i %in% nodes_to_display_indices) {
          node_color[i] <- nodes()$base_color[i]
        } else {
          node_color[i] <- "transparent"
        }
      }
      updated_nodes_df <- nodes()
      updated_nodes_df$color <- node_color

      if (input$show_node_labels) {
        updated_nodes_df$label <- ifelse(updated_nodes_df$color == "transparent", "", input_nodes()$id)
      } else {
        updated_nodes_df$label <- ""
      }
      # ----

      # Filter edges ----
      edge_color <- ifelse((edges()$from %in% nodes_to_hide | edges()$to %in% nodes_to_hide), "transparent", input_edges()$base_color)
      updated_edges_df <- edges()
      updated_edges_df$color <- edge_color

      if (input$show_edge_labels) {
        updated_edges_df$label <- ifelse(updated_edges_df$color == "transparent", " ", as.character(input_edges()$weight))
      } else {
        updated_edges_df$label <- " "
      }
      # ----

      visNetwork::visUpdateEdges(fcm_display, edges = updated_edges_df)
      visNetwork::visUpdateNodes(fcm_display, nodes = updated_nodes_df)
    }
  })
  # ----

  # observe({
  #   print(nodes()[, c(1, 2)])
  #   print(edges()[, c(1:4)])
  # })

  updated_fcm_visNetwork <- shiny::reactive({
    if (!is.null(fcm_display)) {
      updated_visNetwork <- fcm_visNetwork
      # Node updates
      updated_visNetwork$x$nodes <- nodes()
      updated_visNetwork$x$options$nodes$shape <- input$node_shape
      updated_visNetwork$x$options$nodes$size <- input$node_size
      updated_visNetwork$x$options$nodes$font <- list(size = input$font_size)
      # Edge updates
      updated_visNetwork$x$edges <- edges()
      updated_visNetwork$x$options$edges$arrows$to$scaleFactor <- input$arrow_size
      updated_visNetwork$x$options$edges$smooth$roundness <- input$edge_roundness
      updated_visNetwork$x$options$edges$smooth$type <- input$edge_smoothing
      updated_visNetwork$x$options$edges$font <- list(size = input$font_size)
      # Return object
      updated_visNetwork
    }
  })

  shiny::observeEvent(input$close_app, {
    assign(x = "updated_fcm_visNetwork", value = shiny::isolate(updated_fcm_visNetwork()), envir = shiny_env)
    shiny::stopApp()
  })

  shiny::onStop(
    function() {
      assign(x = "updated_fcm_visNetwork", value = shiny::isolate(updated_fcm_visNetwork()), envir = shiny_env)
    }
  )
}
