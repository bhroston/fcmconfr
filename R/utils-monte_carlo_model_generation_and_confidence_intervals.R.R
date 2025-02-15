
################################################################################
# utils-monte_carlo_model_generation_and_simulation.R
#
# These utility functions are involved with Monte Carlo FCM generation
#
#   - check_build_monte_carlo_fcms_inputs
#   - check_monte_carlo_bootstrap_inputs
#
################################################################################


#' Check inputs for building monte carlo fcm inputs
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @param adj_matrix_list A list of n x n adjacency matrices representing fcms
#' @param N_samples The number of samples to draw from the corresponding distribution
#' @param include_zeroes TRUE/FALSE Whether to incorporate zeroes as intentionally-defined
#' edge weights or ignore them in aggregation
#' @param show_progress TRUE/FALSE Show progress bar when creating fmcm. Uses pbmapply
#' from the pbapply package as the underlying function.
#'
#' @returns NULL; Errors if checks fail
#'
#' @keywords internal
#'
#' @importFrom cli format_error
#'
#' @export
#' @examples
#' NULL
check_build_monte_carlo_fcms_inputs <- function(adj_matrix_list,
                                                N_samples,
                                                include_zeroes,
                                                show_progress) {

  adj_matrix_list_class <- get_adj_matrices_input_type(adj_matrix_list)$object_types_in_list[1]

  # Check N_samples
  if (!is.numeric(N_samples)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var N_samples} must be a positive integer",
      "+++++> Input {.var N_samples} was {N_samples}"
    )))
  }

  if (!(N_samples == round(N_samples))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var N_samples} must be a positive integer",
      "+++++> Input {.var N_samples} was {N_samples}"
    )))
  }
  # ----

  # Check include_zeroes
  if (!is.logical(include_zeroes)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var include_zeroes} must be logical (TRUE/FALSE)",
      "+++++> Input {.var include_zeroes} was {include_zeroes}"
    )))
  }

  # Check show_progress
  show_progress = check_if_local_machine_has_access_to_show_progress_functionalities(use_parallel = FALSE, show_progress)

  list(
    adj_matrix_list_class = adj_matrix_list_class,
    show_progress = show_progress
  )
}



#' Check inputs for monte carlo bootstrap analysis
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @param ci_centering_function Estimate confidence intervals about the "mean" or "median" of
#' inferences from the monte carlo simulations
#' @param confidence_interval What are of the distribution should be bounded by the
#' confidence intervals? (e.g. 0.95)
#' @param num_ci_bootstraps Repetitions for bootstrap process, if chosen
#' @param parallel TRUE/FALSE Whether to perform the function using parallel processing
#' @param n_cores Number of cores to use in parallel processing. If no input given,
#' will use all available cores in the machine.
#' @param show_progress TRUE/FALSE Show progress bar when creating fmcm. Uses pbmapply
#' from the pbapply package as the underlying function.
#'
#' @returns NULL; Errors if checks fail
#'
#' @keywords internal
#'
#' @importFrom cli format_error format_warning
#' @importFrom parallel detectCores
#'
#' @export
#' @examples
#' NULL
check_monte_carlo_bootstrap_inputs <- function(ci_centering_function = c("mean", "median"),
                                               confidence_interval = 0.95,
                                               num_ci_bootstraps = 1000,
                                               parallel = TRUE,
                                               n_cores = integer(),
                                               show_progress = TRUE) {

  # Check ci_centering_function ----
  if (identical(ci_centering_function, c("mean", "median"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var ci_centering_function} given",
      "~~~~~ Assuming {.var ci_centering_function} is 'mean'"
    )))
    ci_centering_function <- "mean"
  }
  if (!(ci_centering_function %in% c("mean", "median"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var ci_centering_function} must be one of the following: 'mean' or 'median'",
      "+++++> Input {.var ci_centering_function} was '{ci_centering_function}'"
    )))
  }
  # ----

  # Check confidence_interval ----

  if (!is.numeric(confidence_interval)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var confidence_interval} must be a positive value between 0 and 1",
      "+++++> Input {.var confidence_interval} was '{confidence_interval}'"
    )))
  }

  if (confidence_interval < 0 | confidence_interval >= 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var confidence_interval} must be a positive value between 0 and 1",
      "+++++> Input {.var confidence_interval} was {confidence_interval}"
    )))
  }
  # ----

  # Check num_ci_bootstraps
  if (!is.numeric(num_ci_bootstraps)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var num_ci_bootstraps} must be a positive integer, typically greater than 1000",
      "+++++> Input {.var num_ci_bootstraps} was '{num_ci_bootstraps}'"
    )))
  }

  if (!(num_ci_bootstraps == round(num_ci_bootstraps))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var num_ci_bootstraps} must be a positive integer, typically greater than 1000",
      "+++++> Input {.var num_ci_bootstraps} was {num_ci_bootstraps}"
    )))
  }
  if (num_ci_bootstraps <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {.var num_ci_bootstraps} must be a positive value (typically > 1000)",
      "+++++> Input {.var num_ci_bootstraps} was {num_ci_bootstraps}"
    )))
  }
  # ----

  # Check Runtime Options ----
  show_progress <- check_if_local_machine_has_access_to_show_progress_functionalities(parallel, show_progress)
  parallel <- check_if_local_machine_has_access_to_parallel_processing_functionalities(parallel, show_progress)
  if (parallel) {
    if (identical(n_cores, integer())) {
      warning(cli::format_warning(c(
        "!" = "Warning: No {.var n_cores} given.",
        "~~~~~ Assuming {.var n_cores} is {parallel::detectCores() - 1} (i.e. the max available cores minus 1)"
      )))
      n_cores <- parallel::detectCores() - 1
    }
    if (!is.numeric(n_cores)) {
      stop(cli::format_error(c(
        "x" = "Error: {.var n_cores} must be a positive integer",
        "+++++ Input {.var n_cores} was '{n_cores}'"
      )))
    }
    if (!(n_cores == round(n_cores))) {
      stop(cli::format_error(c(
        "x" = "Error: {.var n_cores} must be a positive integer",
        "+++++ Input {.var n_cores} was {n_cores}"
      )))
    }
    if (n_cores <= 0) {
      stop(cli::format_error(c(
        "x" = "Error: {.var n_cores} must be a positive integer",
        "+++++ Input {.var n_cores} was {n_cores}"
      )))
    }
    if (n_cores > parallel::detectCores()) {
      stop(cli::format_error(c(
        "x" = "Error: {.var n_cores} must be a positive integer less than or equal to {parallel::detectCores()} (i.e. the max available cores on your machine)",
        "+++++ Input {.var n_cores} was {n_cores}"
      )))
    }
  }
  if (!parallel & !identical(n_cores, integer())) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var n_cores} given but {.var parallel} = FALSE.",
      "~~~~~ Ignoring {.var n_cores} input."
    )))
  }
  # ----

  list(
    ci_centering_function = ci_centering_function,
    parallel = parallel,
    n_cores = n_cores,
    show_progress = show_progress
  )
}


