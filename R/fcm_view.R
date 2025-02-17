
#' View FCM Network
#'
#' @family utility
#'
#' @description
#' Display an FCM in the Viewer pane as an interactive visNetwork object. Use
#' the shiny parameter to interact with the FCM visNetwork object and
#' store its output in the global environment.
#'
#' The shiny app provides the following functionalities: (1) interactive node
#' placement, (2) the ability to toggle node labels and edge labels on and off,
#' (3) the ability to change node size and shape, (4) the ability to change
#' font size, (5) the ability to change the size of the arrowhead on directional
#' edges, and (6) the ability to change the curvature of edges and the smoothing
#' method used.
#'
#' @param fcm_adj_matrix An adjacency matrix representing an FCM. fcm_view
#' accepts either an fcm_adj_matrix or fcm_visNetwork input but NOT both.
#' @param fcm_visNetwork An fcm_view visNetwork object output. fcm_view accepts
#' either an fcm_adj_matrix or fcm_visNetwork input but NOT both.
#' @param shiny View visNetwork output in an interactive shiny app. Allows the
#' user to manipulate and save node locations and other plot characteristics.
#' Outputs are saved as fcm_visNetwork objects.
#' @param ... For advanced use. Set alert_on_open = FALSE to remove the alert
#' pop-up that describes how to save visNetwork outputs.
#'
#' @returns a visNetwork object that plots FCM networks in the Viewer pane;
#' if shiny = TRUE, plots FCM networks in a shiny app
#'
#' @importFrom cli format_error format_warning
#' @importFrom methods is
#' @importFrom igraph graph_from_adjacency_matrix
#' @importFrom visNetwork visIgraph visIgraphLayout visEdges
#' @importFrom graphics strwidth
#' @importFrom shiny shinyApp runApp
#'
#' @export
#' @example man/examples/ex-fcm_view.R
fcm_view <- function(fcm_adj_matrix = matrix(),
                     fcm_visNetwork = list(), # A visNetwork Object
                     shiny = FALSE,
                     ...) {

  # Checks ----
  if (!identical(fcm_adj_matrix, matrix()) & !identical(fcm_visNetwork, list())) {
    stop(cli::format_error(c(
      "x" = "Error: fcm_view accepts either {.var fcm_adj_matrix} OR {.var fcm_visNetwork} as inputs",
      "+++++> Either input only a {.var fcm_adj_matrix} OR {.var fcm_visNetwork} (a visNetwork object)"
    )))
  }

  if (!(is.logical(shiny))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var shiny} must be a logical (TRUE/FALSE) value.",
      "+++++> Input {.var shiny} was: {shiny}"
    )))
  }

  additional_params <- list(...)
  if (length(additional_params) > 0 & (!("alert_on_open" %in% names(additional_params)))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var ...} may only be {.var alert_on_open} = TRUE/FALSE",
      "+++++> Input {.var ...} contained: {names(additional_params)}"
    )))
  }
  if ("alert_on_open" %in% names(additional_params) & !shiny) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var alert_on_open} is only used if {.var shiny} is TRUE",
      "~~~~~ Ignoring {.var alert_on_open}"
    )))
  }
  if ("alert_on_open" %in% names(additional_params) & !is.logical(additional_params$alert_on_open)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var alert_on_open} must be a logical (TRUE/FALSE) value.",
      "+++++> Input {.var alert_on_open} was: {additional_params$alert_on_open}"
    )))
  }
  if ("alert_on_open" %in% names(additional_params)) {
    alert_on_open <- additional_params$alert_on_open
  } else {
    alert_on_open <- TRUE
  }


  if (identical(methods::is(fcm_adj_matrix), "visNetwork")) {
    options(warn = 1) # Make sure warning shows before launching shiny app
    warning(cli::format_warning(c(
      "!" = "Warning: {.var fcm_adj_matrix} is a 'visNetwork' object",
      "~~~~~ Replacing {.var fcm_adj_matrix} with {.var fcm_visNetwork} in function call"
    )))
    options(warn = 0)
    fcm_visNetwork <- fcm_adj_matrix
    fcm_adj_matrix <- matrix()
  }
  # ----

  if (!identical(fcm_visNetwork, list()) & !identical(methods::is(fcm_visNetwork), "visNetwork")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var fcm_visNetwork} must be a visNetwork object (preferrably directly from fcm_view",
      "+++++> Input {.var fcm_visNetwork} was of type: {methods::is(fcm_visNetwork)[1]}"
    )))
  } else if (!identical(fcm_visNetwork, list()) & identical(methods::is(fcm_visNetwork), "visNetwork")) {
    fcm_as_visNetwork_obj <- fcm_visNetwork
  }

  if (!identical(fcm_adj_matrix, matrix())) {
    if (length(unique(dim(fcm_adj_matrix))) > 1) {
      stop(cli::format_error(c(
        "x" = "Error: {.var fcm_adj_matrix} must be a single (n x n) adj. matrix.",
        "+++++> Input {.var fcm_adj_matrix} had dimensions: {dim(fcm_adj_matrix)}"
      )))
    }

    fcm_adj_matrix_input_type <- get_adj_matrices_input_type(fcm_adj_matrix)

    if ((fcm_adj_matrix_input_type$adj_matrices_input_is_list) & (length(fcm_adj_matrix) > 1)) {
      stop(cli::format_error(c(
        "x" = "Error: {.var fcm_adj_matrix} must be a single adj. matrix.",
        "+++++> Input {.var fcm_adj_matrix} was a list of {length(fcm_adj_matrix)} adj. matrices."
      )))
    } else if ((fcm_adj_matrix_input_type$adj_matrices_input_is_list) & (length(fcm_adj_matrix) == 1)) {
      fcm_adj_matrix <- fcm_adj_matrix[[1]]
    }

    fcm_adj_matrix_class <- fcm_adj_matrix_input_type$fcm_class
    if (fcm_adj_matrix_class == "conventional") {
      conventional_fcm <- fcm_adj_matrix
    } else if (fcm_adj_matrix_class == "ivfn") {
      conventional_fcm <- apply(fcm_adj_matrix, c(1, 2), function(x) mean(x[[1]]$lower, x[[1]]$upper))
    } else if (fcm_adj_matrix_class == "tfn") {
      conventional_fcm <- apply(fcm_adj_matrix, c(1, 2), function(x) mean(x[[1]]$lower, x[[1]]$mode,  x[[1]]$upper))
    }

    # Translate fcm into an igraph object and then convert to visNetwork
    fcm_as_igraph_obj <- igraph::graph_from_adjacency_matrix(as.matrix(conventional_fcm), weighted = TRUE, mode = "directed")
    fcm_as_visNetwork_obj <- visNetwork::visIgraph(fcm_as_igraph_obj) %>%
      visNetwork::visIgraphLayout()

    # Add aesthetics for nodes
    fcm_as_visNetwork_obj$x$nodes$color <- "lightgrey"
    fcm_as_visNetwork_obj$x$nodes$base_color <- "lightgrey"
    fcm_as_visNetwork_obj$x$options$nodes$size <- 25 # 25 is the default value for visNetwork
    fcm_as_visNetwork_obj$x$options$nodes$font <- list(size = 14)
    fcm_as_visNetwork_obj$x$nodes$physics <- FALSE

    # Add aesthetics for edges
    edges_df <- fcm_as_visNetwork_obj$x$edges
    edges_df$label <- paste(round(edges_df$weight, 2))
    edges_df$color <- ifelse(edges_df$weight >= 0, "black", "red")
    edges_df$base_color <- edges_df$color
    edges_df$width <- abs(edges_df$weight*2)
    # edges_df$hidden <- FALSE
    fcm_as_visNetwork_obj$x$edges <- edges_df

    # Load plot
    fcm_as_visNetwork_obj <- fcm_as_visNetwork_obj %>%
      visNetwork::visIgraphLayout() %>%
      visNetwork::visEdges(
        arrows = list(to = list(enabled = TRUE, scaleFactor = 1)),
        smooth = list(enabled = TRUE, type = "continuous", roundness = 0.4),
        physics = FALSE
      )

    node_x_coords <- fcm_as_visNetwork_obj$x$nodes$x
    node_y_coords <- fcm_as_visNetwork_obj$x$nodes$y

    spaced_node_x_coords <- node_x_coords*1.5
    spaced_node_y_coords <- node_y_coords*2

    fcm_as_visNetwork_obj$x$nodes$x <- spaced_node_x_coords
    fcm_as_visNetwork_obj$x$nodes$y <- spaced_node_y_coords
    # ----
  }

  if (!shiny) {
    fcm_as_visNetwork_obj
  } else {
    # Using shiny ----

    # Calculate optimal sidebar width so all variable names fit on individual lines
    # with their corresponding check box
    node_names <- fcm_as_visNetwork_obj$x$nodes$id
    nchars_in_node_names <- vapply(node_names, nchar, numeric(1))
    node_name_w_max_nchars <- node_names[nchars_in_node_names == max(nchars_in_node_names)]
    max_node_name_px_width <- graphics::strwidth(node_name_w_max_nchars, font = 12, units = 'in')*96 # 1px = 1/96in
    sidebar_width <- as.character(round(max_node_name_px_width + 101)) # The +101 adds room for the checkboxes
    sidebar_width <- paste0(sidebar_width, "px")

    # Create temp env to pass variables into and out of shiny app
    shiny_env <- new.env()
    assign("fcm_as_visNetwork_obj", fcm_as_visNetwork_obj, shiny_env)
    assign("sidebar_width", sidebar_width, shiny_env)
    assign("alert_on_open", alert_on_open, shiny_env)
    server <- source(system.file(file.path('shiny', 'fcm_view', 'server.R'), package = 'fcmconfr'), local = TRUE)$value
    ui <- source(system.file(file.path('shiny', 'fcm_view', 'ui.R'), package = 'fcmconfr'), local = TRUE)$value
    environment(ui) <- shiny_env
    environment(server) <- shiny_env

    # Call shinyApp
    app <- shiny::shinyApp(
      ui = ui,
      server = server
    )
    shiny::runApp(app)

    # Scale things down to decimal point
    shiny_fcm_visNetwork <- shiny_env$updated_fcm_visNetwork_obj
    if (max(abs(shiny_fcm_visNetwork$x$nodes$x)) > 100) {
      shiny_fcm_visNetwork$x$nodes$x <- shiny_fcm_visNetwork$x$nodes$x/100
    } else if ((max(abs(shiny_fcm_visNetwork$x$nodes$x)) > 10)) {
      shiny_fcm_visNetwork$x$nodes$x <- shiny_fcm_visNetwork$x$nodes$x/10
    }
    if (max(abs(shiny_fcm_visNetwork$x$nodes$y)) > 100) {
      shiny_fcm_visNetwork$x$nodes$y <- shiny_fcm_visNetwork$x$nodes$y/100
    } else if ((max(abs(shiny_fcm_visNetwork$x$nodes$y)) > 10)) {
      shiny_fcm_visNetwork$x$nodesyx <- shiny_fcm_visNetwork$x$nodes$y/10
    }
    # ----

    shiny_fcm_visNetwork
  }
}
