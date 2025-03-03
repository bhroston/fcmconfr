
################################################################################
# fcm_view.R
#
# This function plots an FCM network in visNetwork
#
#   Exported
#   - fcm_view
#
################################################################################


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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM.
#' fcm_view accepts either an adj_matrix or fcm_visNetwork input
#' but NOT both. Accepts [data.frame, tbl_df, tbl] objects representing
#' conventional, IVFN-, or TFN- adj. matrices.
#' @param fcm_visNetwork An fcm_view visNetwork object output. fcm_view accepts
#' either an adj_matrix or fcm_visNetwork input but NOT both.
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
fcm_view <- function(adj_matrix = data.frame(),
                     fcm_visNetwork = list(), # A visNetwork Object
                     shiny = FALSE,
                     ...) {

  requireNamespace(c("shiny", "shinyWidgets", "bslib", "igraph", "visNetwork"))

  if (identical(adj_matrix, data.frame())) {
    adj_matrix_is_dummy <- TRUE
    adj_matrix <- matrix(0)
  } else {
    adj_matrix_is_dummy <- FALSE
  }

  # Checks ----
  check_fcmconfr_input(adj_matrix, "square_adj_matrix", var_name = "adj_matrix")
  check_fcmconfr_input(shiny, "logical", var_name = "shiny")

  if (is.null(dim(adj_matrix)) && methods::is(adj_matrix)[1] == "list") {
    adj_matrix <- adj_matrix[[1]]
  }

  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class, var_name_input = "adj_matrix")

  if (fcm_class == "conventional") {
    adj_matrix <- adj_matrix
  } else if (fcm_class == "ivfn") {
    adj_matrix <- apply(adj_matrix, c(1, 2), function(x) mean(x[[1]]$lower, x[[1]]$upper))
  } else if (fcm_class == "tfn") {
    adj_matrix <- apply(adj_matrix, c(1, 2), function(x) mean(x[[1]]$lower, x[[1]]$mode,  x[[1]]$upper))
  }

  if (identical(fcm_visNetwork, list())) {
    # Create a dummy visNetwork object
    fcm_visNetwork <- visNetwork::visNetwork(list(0), list(0))
    fcm_visNetwork_is_dummy <- TRUE
  } else {
    fcm_visNetwork_is_dummy <- FALSE
  }

  if (!identical(methods::is(fcm_visNetwork), "visNetwork")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var fcm_visNetwork} must a visNetwork object.",
      "+++++> Input {.var fcm_visNetwork} was of type: {methods::is(fcm_visNetwork)[1]}"
    )))
    return(invisible(NULL))
  }

  if (!(is.logical(shiny)) | length(shiny) != 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var shiny} must be a logical (TRUE/FALSE) value.",
      "+++++> Input {.var shiny} was: {shiny}"
    )))
  }

  if (!identical(adj_matrix, data.frame()) & !fcm_visNetwork_is_dummy) {
    stop(cli::format_error(c(
        "x" = "Error: fcm_view accepts either {.var adj_matrix} OR {.var fcm_visNetwork} as inputs",
        "+++++> Either input only a {.var adj_matrix} OR {.var fcm_visNetwork} (a visNetwork object)"
    )))
  }

  additional_params <- list(...)
  additional_params_names <- names(additional_params)
  if (length(additional_params) > 0 & !("alert_on_open" %in% additional_params_names)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var ...} may only be {.var alert_on_open} = TRUE/FALSE",
      "+++++> Input {.var ...} contained: {names(additional_params)}"
    )))
  }

  if (("alert_on_open" %in% additional_params_names) & !shiny) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var alert_on_open} is only used if {.var shiny} is TRUE",
      "~~~~~ Ignoring {.var alert_on_open}"
    )))
  }

  if (("alert_on_open" %in% additional_params_names) & shiny) {
    alert_on_open <- additional_params$alert_on_open
  } else {
    alert_on_open <- TRUE
  }

  if ((!is.logical(alert_on_open) | (length(alert_on_open) != 1))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var alert_on_open} must be a logical (TRUE/FALSE) value.",
      "+++++> Input {.var alert_on_open} was: {additional_params$alert_on_open}"
    )))
  }

  if (identical(methods::is(adj_matrix), "visNetwork")) {
    options(warn = 1) # Make sure warning shows before launching shiny app
    warning(cli::format_warning(c(
      "!" = "Warning: {.var adj_matrix} is a 'visNetwork' object",
      "~~~~~ Replacing {.var adj_matrix} with {.var fcm_visNetwork} in function call"
    )))
    options(warn = 0)
    fcm_visNetwork <- adj_matrix
    adj_matrix <- matrix()
  }
  # ----

  if (!adj_matrix_is_dummy) {
    # Translate fcm into an igraph object and then convert to visNetwork
    fcm_as_igraph_obj <- igraph::graph_from_adjacency_matrix(as.matrix(adj_matrix), weighted = TRUE, mode = "directed")
    fcm_visNetwork <- visNetwork::visIgraph(fcm_as_igraph_obj) %>%
      visNetwork::visIgraphLayout()

    # Add aesthetics for nodes
    fcm_visNetwork$x$nodes$color <- "lightgrey"
    fcm_visNetwork$x$nodes$base_color <- "lightgrey"
    fcm_visNetwork$x$options$nodes$size <- 25 # 25 is the default value for visNetwork
    fcm_visNetwork$x$options$nodes$font <- list(size = 14)
    fcm_visNetwork$x$nodes$physics <- FALSE

    # Add aesthetics for edges
    edges_df <- fcm_visNetwork$x$edges
    edges_df$label <- paste(round(edges_df$weight, 2))
    edges_df$color <- ifelse(edges_df$weight >= 0, "black", "red")
    edges_df$base_color <- edges_df$color
    edges_df$width <- abs(edges_df$weight*2)
    fcm_visNetwork$x$edges <- edges_df

    # Load plot
    fcm_visNetwork <- fcm_visNetwork %>%
      visNetwork::visIgraphLayout() %>%
      visNetwork::visEdges(
        arrows = list(to = list(enabled = TRUE, scaleFactor = 1)),
        smooth = list(enabled = TRUE, type = "continuous", roundness = 0.4),
        physics = FALSE
      )

    # Increase space between nodes
    node_x_coords <- fcm_visNetwork$x$nodes$x
    node_y_coords <- fcm_visNetwork$x$nodes$y
    spaced_node_x_coords <- node_x_coords*1.5
    spaced_node_y_coords <- node_y_coords*2
    fcm_visNetwork$x$nodes$x <- spaced_node_x_coords
    fcm_visNetwork$x$nodes$y <- spaced_node_y_coords
  }

  if (shiny) {
    # Calculate optimal sidebar width so all variable names fit on individual lines
    # with their corresponding check box
    node_names <- fcm_visNetwork$x$nodes$id
    nchars_in_node_names <- vapply(node_names, nchar, numeric(1))
    node_name_w_max_nchars <- node_names[nchars_in_node_names == max(nchars_in_node_names)]
    max_node_name_px_width <- graphics::strwidth(node_name_w_max_nchars, font = 12, units = 'in')*96 # 1px = 1/96in
    sidebar_width <- as.character(round(max_node_name_px_width + 101)) # The +101 adds room for the checkboxes
    sidebar_width <- paste0(sidebar_width, "px")

    # Create temp env to pass variables into and out of shiny app
    shiny_env <- new.env()
    assign("fcm_visNetwork", fcm_visNetwork, shiny_env)
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
    shiny_fcm_visNetwork <- shiny_env$updated_fcm_visNetwork
    shiny_fcm_visNetwork$x$nodes$x <- shiny_fcm_visNetwork$x$nodes$x/100
    shiny_fcm_visNetwork$x$nodes$y <- shiny_fcm_visNetwork$x$nodes$y/100

    # if (max(abs(shiny_fcm_visNetwork$x$nodes$x)) > 100) {
    #   shiny_fcm_visNetwork$x$nodes$x <- shiny_fcm_visNetwork$x$nodes$x/100
    # } else if ((max(abs(shiny_fcm_visNetwork$x$nodes$x)) > 10)) {
    #   shiny_fcm_visNetwork$x$nodes$x <- shiny_fcm_visNetwork$x$nodes$x/10
    # }
    # if (max(abs(shiny_fcm_visNetwork$x$nodes$y)) > 100) {
    #   shiny_fcm_visNetwork$x$nodes$y <- shiny_fcm_visNetwork$x$nodes$y/100
    # } else if ((max(abs(shiny_fcm_visNetwork$x$nodes$y)) > 10)) {
    #   shiny_fcm_visNetwork$x$nodesyx <- shiny_fcm_visNetwork$x$nodes$y/10
    # }
    # ----

    shiny_fcm_visNetwork
  } else {
    fcm_visNetwork
  }
}
