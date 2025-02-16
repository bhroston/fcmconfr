
################################################################################
# fcmconfr_gui.R
#
# These functions are involved with operating the fcmconfr_gui
#
#   - fcmconfr_gui
#     -> server.R and ui.R in inst/shiny/fcmconfr_gui
#
################################################################################

#' fcmconfr_gui
#'
#' @description
#' This function opens a shiny application window designed to help users
#' determine inputs for the \code{\link{fcmconfr}} function.
#'
#' @returns On exit, this function outputs a copy-and-paste-able sample script
#' to call \code{\link{fcmconfr}} with the selected inputs.
#'
#' @importFrom cli format_error
#'
#' @export
#' @examples
#' NULL
fcmconfr_gui <- function() {

  # These bslib and shinyWidgets calls are only here to be acknowledged in
  # R CMD Check, they have no impact on the rest of the function and can be
  # ignored.
  bslib::versions()
  shinyWidgets::animations

  # This is here to pass the user-selected inputs from the gui into this
  # function's (fcmconfr_gui) environment, which can then be passed to the
  # console.
  shiny_env_check <- 1

  shiny::runApp(appDir = system.file(file.path('shiny', 'fcmconfr_gui'), package = 'fcmconfr'))

  fcmconfr_gui_vars <- names(fcmconfr_gui_input)

  if (identical(fcmconfr_gui_input$adj_matrices, "")) {
    stop(cli::format_error(c(
      "x" = "Error: No adj matrix list was selected.",
      "+++++ Please call fcmconfr_gui() again to make a selection."
    )))
  }

  if (!("clamping_vector" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$clamping_vector <- rep(0, length(fcmconfr_gui_input$initial_state_vector))
  }

  if (!("agg_function" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$agg_function <- "mean"
  }

  if (!("monte_carlo_samples" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$monte_carlo_samples <- 1000
  }

  if (!("mc_ci_centering_function" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$mc_ci_centering_function <- "mean"
  }

  if (!("mc_confidence_interval" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$mc_confidence_interval <- 0.95
  }

  if (!("mc_inference_bootstrap_reps" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$mc_inference_bootstrap_reps <- 1000
  }

  if (!("n_cores" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$n_cores <- 2
  }

  if (!("include_zeroes_in_sampling" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$include_zeroes_in_sampling <- FALSE
  }

  if (!("include_sims_in_output" %in% fcmconfr_gui_vars)) {
    fcmconfr_gui_input$include_sims_in_output <- FALSE
  }

  fcmconfr_gui_input$initial_state_vector <- paste0("c(", paste(fcmconfr_gui_input$initial_state_vector, collapse = ", "), ")")
  fcmconfr_gui_input$clamping_vector <- paste0("c(", paste(fcmconfr_gui_input$clamping_vector, collapse = ", "), ")")
  fcmconfr_gui_input$concepts <- paste0("c('", paste(fcmconfr_gui_input$concepts, collapse = "', '"), "')")

  fcmconfr_gui_inputs <- structure(
    .Data = fcmconfr_gui_input,
    class = "fcmconfr_gui_input"
  )

  # assign(
  #   x = "fcmconfr_gui_inputs",
  #   value = fcmconfr_gui_inputs,
  #   envir = sys.frame()
  # )

  fcmconfr_gui_inputs
}
