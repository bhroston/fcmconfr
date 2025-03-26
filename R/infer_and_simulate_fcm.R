
################################################################################
# infer_and_simulate_fcm.R
#
# These functions help with fcm inference estimation. Note that some are
# intended for developer use only.
#
#   Exported
#   - infer_fcm_set
#   - infer_fcm
#
#   Internal
#   - infer_conventional_fcm
#   - infer_ivfn_or_tfn_fcm
#   - simulate_fcm
#   - simulate_conventional_fcm
#   - simulate_ivfn_or_tfn_fcm
#   - squash
#   - get_next_state_vector
#   - check_infer_fcm_set_inputs
#   - calculate_next_conventional_fcm_state_vector
#   - calculate_next_fuzzy_set_fcm_state_vector
#   - convert_element_to_ivfn_or_tfn_if_numeric
#   - convert_fuzzy_set_elements_in_matrix_to_distributions
#   - clean_simulation_output
#   - check_simulation_inputs
#   - print.infer_conventional_fcm
#   - print.infer_ivfn_or_tfn_fcm
#
################################################################################


#' Infer Multiple FCMs in a List
#'
#' @family infer_and_simulate_fcm
#'
#' @description
#' This function simulates a set of FCMs (Conventional, IVFN, and/or TFN)
#' (whose edge weights were sampled using monte carlo methods) by repetitively
#' calling the infer_fcm function for each adj. matrix in the set.
#'
#' @details
#' The show_progress and parallel inputs change how the function is run, but do
#'  NOT change the output! These are allowed to be toggled on/off to increase
#'  user control at runtime.
#'
#' @param adj_matrices \[`list()`]\cr A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel processing.
#' @param n_cores \[`integer(1)` - Positive]\cr The number of cores to use in parallel
#' processing. If no input given, all available cores will be used. Should be a
#' positive integer.
#' @param show_progress \[`logical(1)`]\cr If TRUE, show progress bars and print
#' runtime updates in the console when performing FCM simulations.
#' @param include_sims_in_output \[`logical(1)`]\cr If TRUE, include simulations
#' and inferences in output. Set to FALSE to reduce output size.
#' @param silent \[`logical(1)`]\cr If TRUE, suppress warning and error
#' messages.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`inference_of_fcm_set`]\cr A list/data.frame of the inferences
#' (and simulations if included) for each FCM in the set
#'
#' @export
#'
#' @example man/examples/ex-infer_fcm_set.R
infer_fcm_set <- function(adj_matrices = list(matrix()),
                          initial_state_vector = c(),
                          clamping_vector = c(),
                          activation = c("kosko", "modified-kosko", "rescale"),
                          squashing = c("sigmoid", "tanh"),
                          lambda = 1.0,
                          point_of_inference = c("peak", "final"),
                          max_iter = 100L,
                          min_error = 1e-5,
                          parallel = TRUE,
                          n_cores = 1L,
                          show_progress = TRUE,
                          include_sims_in_output = FALSE,
                          silent = FALSE,
                          skip_checks = FALSE) {

  # Adding for R CMD check. Does not impact logic.
  i <- NULL

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  check_fcmconfr_input(silent, check = "logical", var_name = "silent")
  silent <- as.logical(silent)
  if (silent) {
    sink(file = file(nullfile(), open = "wt"), type = "message")
  }

  if (!skip_checks) {
    if (!is.null(dim(adj_matrices))) {
      adj_matrices <- list(adj_matrices)
    }
    check_fcmconfr_input(adj_matrices, check = "adj_matrix_list")
    fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
    adj_matrices <- lapply(adj_matrices, function(x) assert_matrix(x, fcm_class, var_name_input = "adj_matrix"))
    checks <- check_simulation_inputs(adj_matrices[[1]], initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel, n_cores, show_progress, include_sims_in_output, skip_checks)
    fcm_class <- checks$fcm_class
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
    parallel <- checks$parallel
    n_cores <- checks$n_cores
    show_progress <- checks$show_progress
    include_sims_in_output <- checks$include_sims_in_output
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  parallel <- as.logical(parallel)
  n_cores <- as.integer(n_cores)
  show_progress <- as.logical(show_progress)
  include_sims_in_output <- as.logical(include_sims_in_output)
  # ----

  if (silent && parallel) {
    suppressMessages(requireNamespace("parallel"))
  } else if (!silent && parallel) {
    requireNamespace("parallel")
  }
  if (silent && show_progress) {
    suppressMessages(requireNamespace("pbapply"))
  } else if (!silent && show_progress) {
    requireNamespace("pbapply")
  }
  # ----

  if (parallel && show_progress) {
    # Parallal and Show Progress ----
    print("Initializing cluster", quote = FALSE)
    cl <- parallel::makeCluster(n_cores)
    fcmconfr_env <- rlang::search_envs()[[which(names(rlang::search_envs()) == "package:fcmconfr")]]
    parallel::clusterExport(cl, names(fcmconfr_env))
    print("Running Simulations in Parallel", quote = FALSE)
    suppressWarnings(
      inferences_for_adj_matrices <- pbapply::pblapply(
        adj_matrices,
        function(adj_matrix) {
          infer_fcm(
            adj_matrix = adj_matrix,
            initial_state_vector = initial_state_vector,
            clamping_vector = clamping_vector,
            activation = activation,
            squashing = squashing,
            lambda = lambda,
            point_of_inference = point_of_inference,
            max_iter = max_iter,
            min_error = min_error,
            skip_checks = TRUE
          )
        },
        cl = cl
      )
    )
    names(inferences_for_adj_matrices) <- paste0("adj_matrix_", seq_along(inferences_for_adj_matrices))
    parallel::stopCluster(cl)
    # ----
  } else if (parallel && !show_progress) {
    # Parallel and NOT Show Progress ----
    # print("Initializing cluster", quote = FALSE)
    cl <- parallel::makeCluster(n_cores)
    fcmconfr_env <- rlang::search_envs()[[which(names(rlang::search_envs()) == "package:fcmconfr")]]
    parallel::clusterExport(cl, names(fcmconfr_env))
    # cat("\n")
    # print("Running simulations", quote = FALSE)
    suppressWarnings(
      inferences_for_adj_matrices <- parallel::parLapply(
        cl,
        adj_matrices,
        function(adj_matrix) {
          infer_fcm(
            adj_matrix = adj_matrix,
            initial_state_vector = initial_state_vector,
            clamping_vector = clamping_vector,
            activation = activation,
            squashing = squashing,
            lambda = lambda,
            point_of_inference = point_of_inference,
            max_iter = max_iter,
            min_error = min_error,
            skip_checks = TRUE
          )
        }
      )
    )
    parallel::stopCluster(cl)
    # ----
  } else if (!parallel && show_progress) {
    # NOT Parallel and Show Progress ----
    cat("\n")
    print("Running Simulations", quote = FALSE)
    inferences_for_adj_matrices <- pbapply::pblapply(
      adj_matrices,
      function(adj_matrix) {
        infer_fcm(
          adj_matrix = adj_matrix,
          initial_state_vector = initial_state_vector,
          clamping_vector = clamping_vector,
          activation = activation,
          squashing = squashing,
          lambda = lambda,
          point_of_inference = point_of_inference,
          max_iter = max_iter,
          min_error = min_error,
          skip_checks = TRUE
        )
      }
    )
    # ----
  } else if (!parallel && !show_progress) {
    # NOT Parallel and NOT Show Progres ----
    # cat("\n")
    # print("Running simulations", quote = FALSE)
    inferences_for_adj_matrices <- lapply(
      adj_matrices,
      function(adj_matrix) {
        infer_fcm(
          adj_matrix = adj_matrix,
          initial_state_vector = initial_state_vector,
          clamping_vector = clamping_vector,
          activation = activation,
          squashing = squashing,
          lambda = lambda,
          point_of_inference = point_of_inference,
          max_iter = max_iter,
          min_error = min_error,
          skip_checks = TRUE
        )
      }
    )
    # ----
  }

  if (identical(fcm_class, "conventional")) {
    inference_values_by_sim <- lapply(inferences_for_adj_matrices, function(sim) sim$inferences)
  } else {
    inference_values_by_sim <- lapply(inferences_for_adj_matrices, function(sim) sim$inferences)
  }

  inference_values_by_sim <- do.call(rbind, inference_values_by_sim)
  if (is.null(names(adj_matrices))) {
    inference_values_by_sim <- cbind("adj_matrix_index" = paste0("adj_matrix_", seq_along(adj_matrices)), inference_values_by_sim)
  } else {
    inference_values_by_sim <- cbind("adj_matrix_index" = names(adj_matrices), inference_values_by_sim)
  }
  rownames(inference_values_by_sim) <- NULL
  attr(inference_values_by_sim, "index") <- "adj_matrix_index"

  if (include_sims_in_output) {
    return(structure(
      .Data = list(
        inferences = inference_values_by_sim,
        simulations = inferences_for_adj_matrices
      ),
      class = "inference_of_fcm_set"
    ))
  } else {
    return(structure(
      .Data = list(
        inferences = inference_values_by_sim
      ),
      class = "inference_of_fcm_set"
    ))
  }
}



#' Infer FCM
#'
#' @description
#' This compares the baseline simulation of an fcm with the input scenario
#' (scenario vector) to estimate how outputs change compared to the structural
#' or expected behavior of the system.
#'
#' @details
#' This function performs two fcm simulations and compares the output between
#' the two. The first simulation considers the baseline activity where no nodes
#' are "clamped" and the system behaves without any outside inputs. The second
#' simulation considers a scenario where one or multiple nodes are "clamped" so
#' that the system is reactive to additional inputs. The function returns the
#' difference in simulation results between the scenario and baseline activity
#' to understand how system manipulations compare to structural expectations of
#' the system.
#'
#' This function produces the same output as mental modeler for the following
#' inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`infer_conventional_fcm` or `infer_ivfn_or_tfn_fcm`]\cr A list of
#' FCM inference results (including baseline and simulation outputs)
#'
#' @export
#'
#' @example man/examples/ex-infer_fcm.R
infer_fcm <- function(adj_matrix = data.frame(),
                      initial_state_vector = c(),
                      clamping_vector = c(),
                      activation = c("kosko", "modified-kosko", "rescale"),
                      squashing = c("sigmoid", "tanh"),
                      lambda = 1.0,
                      point_of_inference = c("peak", "final"),
                      max_iter = 100L,
                      min_error = 1e-5,
                      skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  # ----

  if (fcm_class == "conventional") {
    inference <- infer_conventional_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    inference <- infer_ivfn_or_tfn_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
  }

  return(inference)
}




#' Infer (Conventional) FCM
#'
#' @description
#' This compares the baseline simulation of an fcm with the input scenario (scenario vector)
#' to estimate how outputs change compared to the structural or expected behavior
#' of the system.
#'
#' @details
#' This function performs two fcm simulations and compares the output between the two.
#' The first simulation considers the baseline activity where no nodes are "clamped" and the
#' system behaves without any outside inputs. The second simulation considers a scenario where
#' one or multiple nodes are "clamped" so that the system is reactive to additional inputs.
#' The function returns the difference in simulation results between the scenario and baseline
#' activity to understand how system manipulations compare to structural expectations of the system.
#'
#' This function produces the same output as mental modeler for the following inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`infer_conventional_fcm`]\cr A list of (conventional) FCM
#' inference results (including baseline and simulation outputs)
#'
#' @example man/examples/ex-infer_conventional_fcm.R
#' @keywords internal
#' @noRd
infer_conventional_fcm <- function(adj_matrix = data.frame(),
                                   initial_state_vector = c(),
                                   clamping_vector = c(),
                                   activation = c("kosko", "modified-kosko", "rescale"),
                                   squashing = c("sigmoid", "tanh"),
                                   lambda = 1.0,
                                   point_of_inference = c("peak", "final"),
                                   max_iter = 100L,
                                   min_error = 1e-5,
                                   skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  # ----

  iter <- NULL # for R CMD Check, does not impact logic

  if (!identical(fcm_class, "conventional")) {
    stop(cli::format_error(c(
      "x" = "{.var adj_matrix} must be an adjacency matrix with edges represented as discrete numeric values (Conventional) only",
      "+++++> Edges in input {.var adj_matrix} are represented as {fcm_class}'s"
    )))
  }

  # Get scenario simulation
  scenario_initial_state_vector <- initial_state_vector
  scenario_clamping_vector <- clamping_vector
  scenario_simulation <- simulate_fcm(adj_matrix, scenario_initial_state_vector, scenario_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)

  if (all(clamping_vector == 0)) {
    dummy_initial_state_vector <- rep(0, length(initial_state_vector))
    dummy_clamping_vector <- rep(0, length(initial_state_vector))
    # Use activation = "kosko" and squashing = "tanh" to force 0's to remain 0's, rather than converting
    # 0's to 0.5's if squashing = "sigmoid"
    baseline_simulation <- simulate_fcm(adj_matrix, dummy_initial_state_vector, dummy_clamping_vector, activation = "kosko", squashing = "tanh", lambda, point_of_inference, max_iter, min_error, skip_checks)
    baseline_simulation_is_dummy <- TRUE
  } else {
    # Get baseline simulation
    baseline_initial_state_vector <- rep(1, length(initial_state_vector))
    baseline_clamping_vector <- rep(0, length(clamping_vector))
    baseline_simulation <- simulate_fcm(adj_matrix, baseline_initial_state_vector, baseline_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
    baseline_simulation_is_dummy <- FALSE
  }

  inferences <- scenario_simulation$inferences - baseline_simulation$inferences
  inferences[clamping_vector != 0] <- clamping_vector[clamping_vector != 0]

  inference_plot_data <- data.frame(
    node = colnames(inferences),
    value = unlist(inferences)
  )

  if (baseline_simulation_is_dummy) {
    baseline_simulation <- NULL
  }

  structure(
    .Data = list(
      inferences = inferences,
      simulations = list(
        scenario_simulation = scenario_simulation,
        baseline_simulation = baseline_simulation
      )
    ),
    class = "infer_conventional_fcm"
  )
}


#' Infer (IVFN or TFN) FCM
#'
#' @description
#' This compares the baseline simulation of an fcm with the input scenario (scenario vector)
#' to estimate how outputs change compared to the structural or expected behavior
#' of the system.
#'
#' @details
#' This function performs two fcm simulations and compares the output between the two.
#' The first simulation considers the baseline activity where no nodes are "clamped" and the
#' system behaves without any outside inputs. The second simulation considers a scenario where
#' one or multiple nodes are "clamped" so that the system is reactive to additional inputs.
#' The function returns the difference in simulation results between the scenario and baseline
#' activity to understand how system manipulations compare to structural expectations of the system.
#'
#' This function produces the same output as mental modeler for the following inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`infer_ivfn_or_tfn_fcm`]\cr A list of (ivfn or tfn) FCM
#' inference results (including baseline and simulation outputs)
#'
#' @example man/examples/ex-infer_ivfn_or_tfn_fcm.R
#' @keywords internal
#' @noRd
infer_ivfn_or_tfn_fcm <- function(adj_matrix = data.frame(),
                                  initial_state_vector = c(),
                                  clamping_vector = c(),
                                  activation = c("kosko", "modified-kosko", "rescale"),
                                  squashing = c("sigmoid", "tanh"),
                                  lambda = 1.0,
                                  point_of_inference = c("peak", "final"),
                                  max_iter = 100L,
                                  min_error = 1e-5,
                                  skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  # ----

  requireNamespace("tidyr")

  if (!(fcm_class %in% c("ivfn", "tfn"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrix} must be an adjacency matrix with edges represented as
      ivfns or tfns to call `simulate_ivfn_or_tfn_fcm()`",
      "+++++> {.var adj_matrix} contains {fcm_class} elements"
    )))
  }
  concept_names <- colnames(adj_matrix)

  # Get scenario simulation
  scenario_initial_state_vector <- initial_state_vector
  # scenario_initial_state_vector <- c(1, 0, 0)
  scenario_clamping_vector <- clamping_vector
  scenario_simulation <- simulate_fcm(adj_matrix, scenario_initial_state_vector, scenario_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)

  if (all(clamping_vector == 0)) {
    dummy_initial_state_vector <- rep(0, length(initial_state_vector))
    dummy_clamping_vector <- rep(0, length(initial_state_vector))
    # Use squashing = "tanh" to force 0's to remain 0's, rather than converting
    # 0's to 0.5's if squashing = "sigmoid"
    baseline_simulation <- simulate_fcm(adj_matrix, dummy_initial_state_vector, dummy_clamping_vector, activation = "kosko", squashing = "tanh", lambda, point_of_inference, max_iter, min_error, skip_checks)
    baseline_simulation_is_dummy <- TRUE
  } else {
    # Get baseline simulation
    baseline_initial_state_vector <- rep(1, length(initial_state_vector))
    # baseline_initial_state_vector <- initial_state_vector
    baseline_clamping_vector <- rep(0, length(clamping_vector))
    baseline_simulation <- simulate_fcm(adj_matrix, baseline_initial_state_vector, baseline_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
    baseline_simulation_is_dummy <- FALSE
  }

  if (fcm_class == "ivfn") {
    raw_inferences <- mapply(
      function(scenario_inference, baseline_inference) {
        subtract_ivfn(scenario_inference[[1]], baseline_inference[[1]])
      },
      scenario_inference = scenario_simulation$inferences,
      baseline_inference = baseline_simulation$inferences,
      SIMPLIFY = FALSE
    )
    ivfn_constants <- clamping_vector[clamping_vector != 0]
    raw_inferences[clamping_vector != 0] <- sapply(ivfn_constants, function(x) list(ivfn(x, x)))
  } else if (fcm_class == "tfn") {
    raw_inferences <- mapply(
      function(scenario_inference, baseline_inference) {
        subtract_tfn(scenario_inference[[1]], baseline_inference[[1]])
      },
      scenario_inference = scenario_simulation$inferences,
      baseline_inference = baseline_simulation$inferences,
      SIMPLIFY = FALSE
    )
    tfn_constants <- clamping_vector[clamping_vector != 0]
    raw_inferences[clamping_vector != 0] <- sapply(tfn_constants, function(x) list(tfn(x, x, x)))
  }

  inferences <- data.frame(matrix(data = list(), nrow = 1, ncol = length(concept_names)))
  for (i in seq_along(raw_inferences)) {
    inferences[1, i][[1]] <- raw_inferences[i]
  }
  colnames(inferences) <- concept_names
  # rownames(inferences) <- point_of_inference

  if (fcm_class == "ivfn") {
    crisp_inferences <- vapply(inferences, function(ivfn_value) mean(ivfn_value[[1]]$lower, ivfn_value[[1]]$upper), numeric(1))
    inferences_df <- data.frame(
      concepts = concept_names,
      crisp = crisp_inferences,
      lower = vapply(inferences, function(x) x[[1]]$lower, numeric(1)),
      upper = vapply(inferences, function(x) x[[1]]$upper, numeric(1))
    )
    colnames(inferences_df) <- c("concept", "crisp", "lower", "upper")
    rownames(inferences_df) <- NULL
  } else if (fcm_class == "tfn") {
    crisp_inferences <- vapply(inferences, function(tfn_value) mean(tfn_value[[1]]$lower, tfn_value[[1]]$mode, tfn_value[[1]]$upper), numeric(1))
    inferences_df <- data.frame(
      concepts = concept_names,
      crisp = crisp_inferences,
      lower = vapply(inferences, function(x) x[[1]]$lower, numeric(1)),
      mode = vapply(inferences, function(x) x[[1]]$mode, numeric(1)),
      upper = vapply(inferences, function(x) x[[1]]$upper, numeric(1))
    )
    colnames(inferences_df) <- c("concept", "crisp", "lower", "mode", "upper")
    rownames(inferences_df) <- NULL
  }

  inferences_plot_data <- tidyr::pivot_longer(inferences_df, cols = 2:ncol(inferences_df))

  return(structure(
    .Data = list(
      inferences = inferences,
      inferences_df = inferences_df,
      simulations = list(
        scenario_simulation = scenario_simulation,
        baseline_simulation = baseline_simulation
      )
    ),
    class = "infer_ivfn_or_tfn_fcm"
  ))
}



#' Simulate FCM
#'
#' @description
#' This simulates an fcm (conventional, ivfn, or tfn) based on its adjacency matrix.
#'
#' @details
#' This function performs two fcm simulations and compares the output between the two.
#' The first simulation considers the baseline activity where no nodes are "clamped" and the
#' system behaves without any outside inputs. The second simulation considers a scenario where
#' one or multiple nodes are "clamped" so that the system is reactive to additional inputs.
#' The function returns the difference in simulation results between the scenario and baseline
#' activity to understand how system manipulations compare to structural expectations of the system.
#'
#' This function produces the same output as mental modeler for the following inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`fcm_simulation`]\cr A list of FCM simulation results
#'
#' @example man/examples/ex-simulate_fcm.R
#' @keywords internal
#' @noRd
simulate_fcm <- function(adj_matrix = data.frame(),
                         initial_state_vector = c(),
                         clamping_vector = c(),
                         activation = c("kosko", "modified-kosko", "rescale"),
                         squashing = c("sigmoid", "tanh"),
                         lambda = 1.0,
                         point_of_inference = c("peak", "final"),
                         max_iter = 100,
                         min_error = 1e-5,
                         skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    lambda <- checks$lambda
    activation <- checks$activation
    squashing <- checks$squashing
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  # ----

  if (fcm_class == "conventional") {
    simulation <- simulate_conventional_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    simulation <- simulate_ivfn_or_tfn_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks)
  }

  return(simulation)
}



#' Simulate (Conventional) FCM
#'
#' @description
#' This simulates a conventional fcm based on its adjacency matrix.
#'
#' @details
#' This function performs two fcm simulations and compares the output between the two.
#' The first simulation considers the baseline activity where no nodes are "clamped" and the
#' system behaves without any outside inputs. The second simulation considers a scenario where
#' one or multiple nodes are "clamped" so that the system is reactive to additional inputs.
#' The function returns the difference in simulation results between the scenario and baseline
#' activity to understand how system manipulations compare to structural expectations of the system.
#'
#' This function produces the same output as mental modeler for the following inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @param adj_matrix \[`data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`fcm_simulation`]\cr A list of FCM simulation results
#'
#' @example man/examples/ex-simulate_conventional_fcm.R
#' @keywords internal
#' @noRd
simulate_conventional_fcm <- function(adj_matrix = matrix(),
                                      initial_state_vector = c(),
                                      clamping_vector = c(),
                                      activation = c("kosko", "modified-kosko", "rescale"),
                                      squashing = c("sigmoid", "tanh"),
                                      lambda = 1.0,
                                      point_of_inference = c("peak", "final"),
                                      max_iter = 100,
                                      min_error = 1e-5,
                                      skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)

  # ----

  if (!identical(fcm_class, "conventional")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrix} must be an adjacency matrix with edges represented as
      discrete numeric values (i.e. Conventional FCM) to call `simulate_conventional_fcm()`",
      "+++++> {.var adj_matrix} contains {fcm_class} elements"
    )))
  }
  concept_names <- colnames(adj_matrix)

  state_vectors <- data.frame(matrix(data = numeric(), nrow = max_iter + 1, ncol = length(initial_state_vector)))
  state_vectors[1, ] <- initial_state_vector
  errors <-  data.frame(matrix(data = numeric(), nrow = max_iter, ncol = length(initial_state_vector)))
  errors[1, ] <- 0

  for (i in 2:(max_iter + 1)) {
    state_vector <- state_vectors[i - 1, ]
    next_state_vector <- get_next_state_vector(adj_matrix, state_vector, activation, fcm_class = "conventional", skip_checks = TRUE)
    normalized_state_vector <- vapply(next_state_vector, function(x) squash(x, squashing = squashing, lambda = lambda, skip_checks = TRUE), numeric(1))
    normalized_state_vector[clamping_vector != 0] <- clamping_vector[clamping_vector != 0]
    state_vectors[i, ] <- normalized_state_vector
    errors[i, ] <- abs(as.matrix(state_vectors[i - 1,]) - as.matrix(state_vectors[i, ]))
    if (all(errors[i, ] < min_error)) {
      state_vectors <- stats::na.omit(state_vectors)
      errors <- stats::na.omit(errors)
      break
    }
  }
  if (i >= max_iter) {
    warning(cli::format_warning(c(
      "!" = "Warning: The simulation reached the maximum number of iterations (max_iter = {max_iter})
      before achieving the minimum allowable error (min_error = {min_error})",
      "~~~~~ It is possible that the simulation requires more iterations to converge within the input {.var min_error}",
      "~~~~~ Try increasing {.var max_iter} or {min_error}", " ",
      "~~~~~ Also possible that the simulation reached a limit-cycle or is endlessly chaotic."
    )))
  }

  state_vectors <- clean_simulation_output(state_vectors, concept_names)
  errors <- clean_simulation_output(errors, concept_names)

  if (point_of_inference == "peak") {
    inferences <- as.data.frame(t(apply(state_vectors, 2,
                                        function(col) {
                                          unique(col[abs(col) == max(abs(col))])
                                        })))
    inferences$iter <- NULL
    rownames(inferences) <- "peak"
  } else if (point_of_inference == "final") {
    inferences <- state_vectors[nrow(state_vectors), ]
    inferences$iter <- NULL
    rownames(inferences) <- "final"
  }

  return(structure(
    .Data = list(
      inferences = inferences,
      state_vectors = state_vectors,
      errors = errors,
      params = list(
        adj_matrix = adj_matrix,
        initial_state_vector = initial_state_vector,
        activation = activation,
        squashing = squashing,
        lambda = lambda,
        max_iter = max_iter,
        min_error = min_error,
        concepts = concept_names
      )
    ),
    class = "fcm_simulation"
  ))
}



#' Simulate (IVFN or TFN) FCM
#'
#' @description
#' This simulates a (IVFN or TFN) fcm based on its adjacency matrix.
#'
#' @details
#' This function performs two fcm simulations and compares the output between the two.
#' The first simulation considers the baseline activity where no nodes are "clamped" and the
#' system behaves without any outside inputs. The second simulation considers a scenario where
#' one or multiple nodes are "clamped" so that the system is reactive to additional inputs.
#' The function returns the difference in simulation results between the scenario and baseline
#' activity to understand how system manipulations compare to structural expectations of the system.
#'
#' This function produces the same output as mental modeler for the following inputs:
#'  - initial_state_vector = c(1, 1, ..., 1)
#'  - activation = "kosko"
#'  - squashing = either "sigmoid" or "tanh"
#'  - lambda = 1
#'
#' @references \insertRef{yesil_triangular_2014}{fcmconfr}
#'
#' @param adj_matrix \[`data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`fcm_simulation`]\cr A list of FCM simulation results
#'
#' @example man/examples/ex-simulate_ivfn_or_tfn_fcm.R
#' @keywords internal
#' @noRd
simulate_ivfn_or_tfn_fcm <- function(adj_matrix = data.frame(),
                                     initial_state_vector = c(),
                                     clamping_vector = c(),
                                     activation = c("kosko", "modified-kosko", "rescale"),
                                     squashing = c("sigmoid", "tanh"),
                                     lambda = 1.0,
                                     point_of_inference = c("peak", "final"),
                                     max_iter = 100,
                                     min_error = 1e-5,
                                     skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel = FALSE, n_cores = 1, show_progress = FALSE, include_sims_in_output = FALSE, skip_checks = skip_checks)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    lambda <- checks$lambda
    point_of_inference <- checks$point_of_inference
    max_iter <- checks$max_iter
    min_error <- checks$min_error
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class)
  activation <- tolower(as.character(activation))
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  point_of_inference <- tolower(as.character(point_of_inference))
  max_iter <- as.integer(max_iter)
  min_error <- as.numeric(min_error)
  # ----

  if (!(fcm_class %in% c("ivfn", "tfn"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrix} must be an adjacency matrix with edges represented as
      ivfns or tfns to call `simulate_ivfn_or_tfn_fcm()`",
      "+++++> {.var adj_matrix} contains {fcm_class} elements"
    )))
  }
  concept_names <- colnames(adj_matrix)

  # Convert elements in initial_state_vectors, and clamping_vectors to
  # ivfn or tfn objects to streamline data management in simulation
  formatted_initial_state_vector <- vapply(initial_state_vector, function(x) list(convert_element_to_ivfn_or_tfn_if_numeric(x, desired_class = fcm_class)), list(1))
  clamped_node_locs <- which(clamping_vector != 0)
  formatted_clamped_nodes <- vapply(clamping_vector[clamped_node_locs], function(x) list(convert_element_to_ivfn_or_tfn_if_numeric(x, desired_class = fcm_class)), list(1))

  # Generate empty output objects prior to looping to improve runtime speed
  fuzzy_set_state_vectors <- vector(mode = "list", length = max_iter)
  fuzzy_set_state_vectors[[1]] <- formatted_initial_state_vector

  fuzzy_set_errors <- vector(mode = "list", length = max_iter)
  fuzzy_set_errors[[1]] <- rep(list(tfn(0, 0, 0)), length(initial_state_vector))

  crisp_state_vectors <- data.frame(matrix(data = numeric(), nrow = max_iter, ncol = length(initial_state_vector)))
  crisp_state_vectors[1, ] <- initial_state_vector

  crisp_errors <- data.frame(matrix(data = numeric(), nrow = max_iter, ncol = length(initial_state_vector)))
  crisp_errors[1, ] <- 0

  # Perform simulation
  for (i in 2:(max_iter + 1)) {
    # Calculate simulation step
    fuzzy_set_state_vector <- fuzzy_set_state_vectors[[i - 1]]
    crisp_state_vector <- crisp_state_vectors[i - 1, ]
    next_fuzzy_set_state_vector <- get_next_state_vector(adj_matrix, fuzzy_set_state_vector, activation, fcm_class, skip_checks = TRUE)
    normalized_next_fuzzy_set_state_vector <- lapply(
      next_fuzzy_set_state_vector,
      function(element) {
        if (fcm_class == "ivfn") {
          ivfn(squash(element$lower, squashing, lambda), squash(element$upper, squashing, lambda))
        } else if (fcm_class == "tfn") {
          tfn(squash(element$lower, squashing, lambda), squash(element$mode, squashing, lambda), squash(element$upper, squashing, lambda))
        }
      }
    )
    normalized_next_fuzzy_set_state_vector[clamped_node_locs] <- formatted_clamped_nodes
    crisp_normalized_next_state_vector <- lapply(normalized_next_fuzzy_set_state_vector, defuzz_ivfn_or_tfn)

    # Store result in output objects
    fuzzy_set_state_vectors[[i]] <- normalized_next_fuzzy_set_state_vector
    crisp_state_vectors[i, ] <- crisp_normalized_next_state_vector
    fuzzy_set_errors[[i]] <- mapply(
      function(state_vector, next_state_vector) {
        if (fcm_class == "ivfn") {
          data.frame(
            error_in_lower = abs(state_vector$lower - next_state_vector$lower),
            error_in_upper = abs(state_vector$upper - next_state_vector$upper)
          )
        } else if (fcm_class == "tfn") {
          data.frame(
            error_in_lower = abs(state_vector$lower - next_state_vector$lower),
            error_in_mode = abs(state_vector$mode - next_state_vector$mode),
            error_in_upper = abs(state_vector$upper - next_state_vector$upper)
          )
        }
      },
      state_vector = fuzzy_set_state_vector,
      next_state_vector = normalized_next_fuzzy_set_state_vector,
      SIMPLIFY = FALSE
    )
    crisp_errors[i, ] <- abs(crisp_state_vector - crisp_normalized_next_state_vector)
    # total_error <- sum(crisp_errors[i, ])
    # if (total_error < min_error) {
    if (all(crisp_errors[i, ] < min_error)) {
      break
    }
  }
  if (i >= max_iter) {
    warning(cli::format_warning(c(
      "!" = "Warning: The simulation reached the maximum number of iterations (max_iter = {max_iter})
      before achieving the minimum allowable error (min_error = {min_error})",
      "~~~~~ It is possible that the simulation requires more iterations to converge within the input {.var min_error}",
      "~~~~~ Try increasing {.var max_iter} or {min_error}", " ",
      "~~~~~ Also possible that the simulation reached a limit-cycle or is endlessly chaotic."
    )))
  }

  # Clean output objects
  fuzzy_set_state_vectors <- clean_simulation_output(fuzzy_set_state_vectors, concept_names)
  fuzzy_set_errors <- clean_simulation_output(fuzzy_set_errors, concept_names)
  crisp_state_vectors <- clean_simulation_output(crisp_state_vectors, concept_names)
  crisp_errors <- clean_simulation_output(crisp_errors, concept_names)

  if (point_of_inference == "peak") {
    fuzzy_set_state_vectors_upper_values <- apply(
      fuzzy_set_state_vectors, c(1, 2),
      function(element) {
        ifelse((methods::is(element[[1]]) %in% c("ivfn", "tfn")), element[[1]]$upper, element[[1]])
      }
    )

    max_value_indexes <- data.frame(matrix(data = NA, nrow = 2, ncol = ncol(fuzzy_set_state_vectors)))
    max_value_indexes[1, ] <- 0:(ncol(max_value_indexes) - 1)
    max_value_indexes[2, ] <- apply(
      fuzzy_set_state_vectors_upper_values, 2,
      function(column) {
        column <- unlist(column)
        which(column == unique(column[abs(column) == max(abs(column))]))[[1]]
      }, simplify = FALSE
    )
    colnames(max_value_indexes) <- c("iter", concept_names)
    rownames(max_value_indexes) <- c("node_number", "max_value_index")
    max_value_indexes$iter <- NULL

    raw_inferences <- apply(
      max_value_indexes, 2,
      function(index_info) {
        node_index <- index_info[1] + 1 # Since there's an extra 'iter' column in fuzzy_set_state_vectors
        max_value_index <- index_info[2]
        # print(c(node_index, max_value_index))
        fuzzy_set_state_vectors[max_value_index, node_index][[1]]
      }
    )
    inferences <- data.frame(matrix(data = list(), nrow = 1, ncol = length(concept_names)))
    for (i in seq_along(raw_inferences)) {
      inferences[1, i][[1]] <- raw_inferences[i]
    }
    colnames(inferences) <- concept_names
    rownames(inferences) <- "peak"
  } else if (point_of_inference == "final") {
    inferences <- fuzzy_set_state_vectors[nrow(fuzzy_set_state_vectors), ]
    inferences$iter <- NULL
    rownames(inferences) <- "final"
  }

  attr(fuzzy_set_state_vectors, "index") <- "iter"
  attr(crisp_state_vectors, "index") <- "iter"
  attr(fuzzy_set_errors, "index") <- "iter"
  attr(crisp_errors, "index") <- "iter"

  return(structure(
    .Data = list(
      inferences = inferences,
      state_vectors = fuzzy_set_state_vectors,
      crisp_state_vectors = crisp_state_vectors,
      errors = fuzzy_set_errors,
      crisp_errors = crisp_errors,
      params = list(
        adj_matrix = adj_matrix,
        initial_state_vector = initial_state_vector,
        clamping_vector = clamping_vector,
        activation = activation,
        squashing = squashing,
        lambda = lambda,
        max_iter = max_iter,
        min_error = min_error,
        concepts = concept_names
      )
    ),
    class = "fcm_simulation"
  ))
}


#' Squash
#'
#' @description
#' Calculate squashing function output of an input value and lambda values. This
#' function calculates the 'squashed' value of a state based upon the sigmoid
#' and hyperbolic tangent (tanh) transfer functions.
#'
#' @references \insertRef{dikopoulou_fuzzy_2021}{fcmconfr}
#'
#' @param value \[`double(1)` - Unrestricted (positive or negative)]\cr A value
#' to 'squash' using the selected squashing function.
#' @param squashing \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)` - Positive]\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`double(1)`]\cr A "squashed" value, the output of the selected
#' transfer ("squashing") function
#'
#' @examples
#' squash(1, "sigmoid", lambda = 1)
#' squash(0.6, "tanh", lambda = 0.7)
#' @keywords internal
#' @noRd
squash <- function(value = double(),
                   squashing = c("sigmoid", "tanh"),
                   lambda = 1,
                   skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    check_fcmconfr_input(abs(value), check = "positive_number", var_name = "value", zero_is_positive = TRUE)
    value <- as.numeric(value)
    check_fcmconfr_input(squashing, check = "choice_selection", choice_selection_opts = c("sigmoid", "tanh"), var_name = "squashing")
    check_fcmconfr_input(lambda, check = "positive_number", var_name = "lambda", zero_is_positive = FALSE)
  }
  value <- as.numeric(value)
  squashing <- tolower(as.character(squashing))
  lambda <- as.numeric(lambda)
  # ----

  # Use full names here instead of abbreviations to improve readability even
  # though developers will need to type more characters.
  if (squashing == "tanh") {
    squashed_value <- (exp(2*lambda*value) - 1)/(exp(2*lambda*value) + 1)
  } else if (squashing == "sigmoid") {
    squashed_value <- 1/(1 + exp(-lambda*value))
  }

  return(squashed_value)
}




#' Calculate Next FCM State Vector
#'
#' @description
#' This calculates the next iteration of a state vector in an fcm simulation
#' based on the kosko, modified-kosko, or rescale activation functions
#'
#' The state of the art of fcm typically applies one of three activation functions
#' in calculating iterative state vector values: kosko, modified-kosko, and
#' rescale.
#'
#' kosko: Only considers the current iteration
#' (Kosko, 1986 - https://doi.org/10.1016/S0020-7373(86)80040-2)
#' \deqn{
#'   A_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'   j\ =\ i\\
#'   i\ \neq \ j
#'   \end{array}}^{M} w_{ji} A_{j}^{( t)}\right)
#' }
#'
#' modified-kosko: The previous value of a node influences its future value
#' (Stylio & Groumpos, 2004 - https://doi.org/10.1109/TSMCA.2003.818878)
#' \deqn{
#'  A_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'  j\ =\ i\\
#'  i\ \neq \ j
#'  \end{array}}^{M} w_{ji} A_{j}^{( t)} +A_{i}^{( t)}\right)
#' }
#'
#' rescale: Like modified-kosko, but assigns nodes with no value with a
#' value of 0.5 to reduce the influence that a lack of initial state information
#' can have on the simulation output
#' (Papageorgiou, 2011 - https://doi.org/10.1016/j.asoc.2009.12.010)
#' \deqn{
#'  A_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'  j\ =\ i\\
#'  i\ \neq \ j
#'  \end{array}}^{M} w_{ji}\left( 2A_{j}^{( t)} -1\right) +\left( 2A_{i}^{( t)} -1\right)\right)
#' }
#'
#' @details
#' Use vignette("fcmconfr") for more information.
#'
#' @references \insertRef{kosko_fuzzy_1986}{fcmconfr}
#' @references \insertRef{styliosIntroducingTheoryFuzzy1997}{fcmconfr}
#' @references \insertRef{papageorgiou_new_2011}{fcmconfr}
#' @references \insertRef{dikopoulou_fuzzy_2021}{fcmconfr}
#'
#' @param adj_matrix \[`data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param state_vector \[`vector()`]\cr A list of state values
#' (one per node) at a particular iteration in a FCM simulation. Each value
#' object type must correlate with the fcm_class: numeric for 'conventional',
#' 'ivfn' for 'ivfn', and 'tfn' for 'tfn'.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param fcm_class \[`character(1)`]\cr The type of FCM represented by the
#' adjacency matrix. Must be one of the following: 'conventional', 'ivfn', or
#' 'tfn'
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`matrix or list`]\cr The (i + 1) iteration of the input
#' state_vector based on the adj_matrix and activation function
#'
#' @example man/examples/ex-get_next_state_vector.R
#' @keywords internal
#' @noRd
get_next_state_vector <- function(adj_matrix = data.frame(),
                                  state_vector = c(),
                                  activation = c("kosko", "modified-kosko", "rescale"),
                                  fcm_class = c("conventional", "ivfn", "tfn"),
                                  skip_checks = FALSE) {

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    check_fcmconfr_input(adj_matrix, check = "square_adj_matrix", var_name = "adj_matrix")
    check_fcmconfr_input(activation, check = "choice_selection", choice_selection_opts = c("kosko", "modified-kosko", "rescale"), var_name = "activation")
    check_fcmconfr_input(fcm_class, check = "choice_selection", choice_selection_opts = c("conventional", "ivfn", "tfn"), var_name = "fcm_class")
  }

  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class, var_name_input = "adj_matrix")
  activation <- as.character(tolower(activation))
  fcm_class <- as.character(tolower(fcm_class))
  # ----

  if (fcm_class == "conventional") {
    check_fcmconfr_input(state_vector, check = "numeric_vector", var_name = "state_vector")
    state_vector <- as.matrix(state_vector)
    adj_matrix <- as.matrix(adj_matrix)
    if (dim(state_vector)[2] != unique(dim(adj_matrix))) {
      state_vector <- t(state_vector)
    }
    if (activation == "kosko") {
      next_state_vector <- state_vector %*% adj_matrix
    } else if (activation == "modified-kosko") {
      next_state_vector <- state_vector %*% adj_matrix + state_vector
    } else if (activation == "rescale") {
      next_state_vector <- (2*state_vector - 1) %*% adj_matrix + (2*state_vector - 1)
    }
  }

  if (fcm_class == "ivfn") {
    # Next IVFN state vector ----
    check_fcmconfr_input(state_vector, check = "ivfn_vector", var_name = "state_vector")

    get_next_ivfn_state_vector <- function(ivfn_state_vector, crisp_ivfn_state_vector, adj_matrix) {
      dot_product <- vector(mode = "list", length = length(crisp_ivfn_state_vector))
      for (col in seq_along(colnames(adj_matrix))) {
        element_wise_products <- mapply(
          function(crisp_ivfn_state_vector_value, column_vector) {
            if (activation == "rescale") {
              crisp_ivfn_state_vector_value <- 2*crisp_ivfn_state_vector_value - 1
            }
            value_is_positive <- (crisp_ivfn_state_vector_value >= 0)
            if (value_is_positive) {
              ivfn(lower = crisp_ivfn_state_vector_value*column_vector$lower, upper = crisp_ivfn_state_vector_value*column_vector$upper)
            } else {
              ivfn(lower = crisp_ivfn_state_vector_value*column_vector$upper, upper = crisp_ivfn_state_vector_value*column_vector$lower)
            }
          },
          crisp_ivfn_state_vector_value = crisp_ivfn_state_vector,
          column_vector = adj_matrix[, col]
        )
        dot_product_entry <- apply(element_wise_products, 1, function(row) sum(unlist(row)))
        dot_product[[col]] <- ivfn(lower = dot_product_entry[1], upper = dot_product_entry[2])
      }
      if (activation == "kosko") {
        next_ivfn_state_vector <-  dot_product
      } else if (activation == "modified-kosko") {
        next_ivfn_state_vector <- mapply(
          function(prev_ivfn_state, dot_product_ivfn_state) {
            ivfn(lower = prev_ivfn_state$lower + dot_product_ivfn_state$lower, upper = prev_ivfn_state$upper + dot_product_ivfn_state$upper)
          },
          prev_ivfn_state = ivfn_state_vector,
          dot_product_ivfn_state = dot_product,
          SIMPLIFY = FALSE
        )
      } else if (activation == "rescale") {
        next_ivfn_state_vector <- mapply(
          function(prev_ivfn_state, dot_product_ivfn_state) {
            ivfn(lower = (2*prev_ivfn_state$lower - 1) + dot_product_ivfn_state$lower, upper = (2*prev_ivfn_state$upper - 1) + dot_product_ivfn_state$upper)
          },
          prev_ivfn_state = ivfn_state_vector,
          dot_product_ivfn_state = dot_product,
          SIMPLIFY = FALSE
        )
      }
      return(next_ivfn_state_vector)
    }

    crisp_ivfn_state_vector <- vapply(state_vector, function(x) (x$lower + x$upper)/2, numeric(1))
    next_state_vector <- get_next_ivfn_state_vector(state_vector, crisp_ivfn_state_vector, adj_matrix)
    # ----
  } else if (fcm_class == "tfn") {
    # Next TFN state vector ----
    check_fcmconfr_input(state_vector, check = "tfn_vector", var_name = "state_vector")

    get_next_tfn_state_vector <- function(tfn_state_vector, crisp_tfn_state_vector, adj_matrix) {
      dot_product <- vector(mode = "list", length = length(crisp_tfn_state_vector))
      for (col in seq_along(colnames(adj_matrix))) {
        element_wise_products <- mapply(
          function(crisp_tfn_state_vector_value, column_vector) {
            if (activation == "rescale") {
              crisp_tfn_state_vector_value <- 2*crisp_tfn_state_vector_value - 1
            }
            value_is_positive <- (crisp_tfn_state_vector_value >= 0)
            if (value_is_positive) {
              tfn(lower = crisp_tfn_state_vector_value*column_vector$lower, mode = crisp_tfn_state_vector_value*column_vector$mode, upper = crisp_tfn_state_vector_value*column_vector$upper)
            } else {
              tfn(lower = crisp_tfn_state_vector_value*column_vector$upper, mode = crisp_tfn_state_vector_value*column_vector$mode, upper = crisp_tfn_state_vector_value*column_vector$lower)
            }
          },
          crisp_tfn_state_vector_value = crisp_tfn_state_vector,
          column_vector = adj_matrix[, col]
        )
        dot_product_entry <- apply(element_wise_products, 1, function(row) sum(unlist(row)))
        dot_product[[col]] <- tfn(lower = dot_product_entry[1], mode = dot_product_entry[2], upper = dot_product_entry[3])
      }

      if (activation == "kosko") {
        next_tfn_state_vector <-  dot_product
      } else if (activation == "modified-kosko") {
        next_tfn_state_vector <- mapply(
          function(prev_tfn_state, dot_product_tfn_state) {
            tfn(lower = prev_tfn_state$lower + dot_product_tfn_state$lower, mode = prev_tfn_state$mode + dot_product_tfn_state$mode, upper = prev_tfn_state$upper + dot_product_tfn_state$upper)
          },
          prev_tfn_state = tfn_state_vector,
          dot_product_tfn_state = dot_product,
          SIMPLIFY = FALSE
        )
      } else if (activation == "rescale") {
        next_tfn_state_vector <- mapply(
          function(prev_tfn_state, dot_product_tfn_state) {
            tfn(lower = (2*prev_tfn_state$lower - 1) + dot_product_tfn_state$lower, mode = (2*prev_tfn_state$mode - 1) + dot_product_tfn_state$mode, upper = (2*prev_tfn_state$upper - 1) + dot_product_tfn_state$upper)
          },
          prev_tfn_state = tfn_state_vector,
          dot_product_tfn_state = dot_product,
          SIMPLIFY = FALSE
        )
      }
      return(next_tfn_state_vector)
    }

    crisp_tfn_state_vector <- vapply(state_vector, function(x) (x$lower + x$mode + x$upper)/3, numeric(1))
    next_state_vector <- get_next_tfn_state_vector(state_vector, crisp_tfn_state_vector, adj_matrix)
    # ----
  }

  return(next_state_vector)
}


#' Convert Value to IVFN or TFN if Value is Numeric
#'
#' @description
#' This checks whether the input element is an number (integer/double/numeric),
#' an IVFN, or a TFN. If it is an IVFN or TFN, it returns the input, but if it
#' is a numeric type object, it will convert that number into an 'ivfn' or 'tfn'
#' object.
#'
#' @param element \[`double(1)`]\cr A numeric element in an adjacency
#' matrix.
#' @param desired_class \[`character(1)`]\cr Transform the element into an
#' 'ivfn' or 'tfn'.
#'
#' @returns \[`ivfn or tfn`]\cr An IVFN or TFN representation of a crisp,
#' numeric value.
#'
#' @examples
#' convert_element_to_ivfn_or_tfn_if_numeric(0.6, "ivfn")
#' convert_element_to_ivfn_or_tfn_if_numeric(0.7, "tfn")
#' @keywords internal
#' @noRd
convert_element_to_ivfn_or_tfn_if_numeric <- function(element = double(),
                                                      desired_class = c("ivfn", "tfn")) {
  desired_class <- tolower(desired_class)

  numeric_class <- methods::is(numeric())

  if (identical(methods::is(element), numeric_class) & identical(desired_class, "ivfn")) {
    converted_element <- ivfn(element, element)
  } else if (identical(methods::is(element), numeric_class) & identical(desired_class, "tfn")) {
    converted_element <- tfn(element, element, element)
  }

  return(converted_element)
}



#' Convert IVFN or TFN Elements in Adj. Matrix to Distributions (i.e. sets)
#'
#' @description
#' Given a list of adjacency matrices which include either ivfns or
#' tfns, convert those objects to their corresponding
#' distributions representative of those values.
#'
#' @details
#' This function assists with subtracting the baseline from the scenario
#' simulation when calling infer_fcm with IVFN-FCMs or TFN-FCMs.
#'
#' @param adj_matrix \[`data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param fcm_class \[`character(1)`]\cr The type of FCM represented by the
#' adjacency matrix. For this function, may be either 'ivfn' or 'tfn', but
#' will not work for 'conventional' FCMs.
#' @param n_samples \[`integer(1) - Positive`]\cr The number of samples to draw from the
#' corresponding distribution (runif for IVFN; rtri for TFN)
#'
#' @returns \[`matrix`]\cr An adj. matrix of IVFNs or TFNs represented as
#' lists (sets) of their representative distributions (runif for IVFN; rtri for
#' TFN)
#'
#' @example man/examples/ex-convert_fuzzy_set_elements_in_matrix_to_dists.R
#' @keywords internal
#' @noRd
convert_fuzzy_set_elements_in_matrix_to_distributions <- function(adj_matrix = data.frame(),
                                                                  fcm_class = c("ivfn", "tfn"),
                                                                  n_samples = integer()) {

  if (!(fcm_class %in% c("ivfn", "tfn"))) {
    stop("Input fcm_class must be either 'ivfn' or 'tfn'")
  }

  if (fcm_class == "ivfn") {
    adj_matrix_w_distributions <- apply(
      adj_matrix, c(1, 2),
      function(element) {
        element <- list(stats::runif(n_samples, element[[1]]$lower, element[[1]]$upper))
      }
    )
  } else if (fcm_class == "tfn") {
    adj_matrix_w_distributions <- apply(
      adj_matrix, c(1, 2),
      function(element) {
        if (identical(methods::is(element[[1]]), "tfn")) {
          list(rtriangular_dist(n_samples, lower = element[[1]]$lower, mode = element[[1]]$mode, upper = element[[1]]$upper))
        }
      }
    )
  }

  return(adj_matrix_w_distributions)
}


#' Clean Simulation Output
#'
#' @description
#' This adds quality-of-life improvements and detail to simulation output objects
#' such as adding column names and an iter column
#'
#' @param simulation_output \[`ivfn_or_tfn_simulation`]\cr A direct output
#' object from \code{simulate_ivfn_or_tfn_fcm}
#' @param concepts \[`vector("character")`]\cr A vector of names for each node.
#' If not defined, will use column names of adjacency matrix in
#' simulation_output object.
#'
#' @returns \[`data.frame()` or `list()`]\cr The simulation output data.frames
#' with NA values omitted and rows named 1 through # rows.
#'
#' @examples NULL
#' @keywords internal
#' @noRd
clean_simulation_output <- function(simulation_output, concepts) {
  if (identical(methods::is(data.frame()), methods::is(simulation_output))) {
    # simulation_output is a data.frame
    cleaned_simulation_output <- stats::na.omit(simulation_output)
  } else {
    # simulation_output is a list of lists
    cleaned_simulation_output <- data.frame(do.call(rbind, simulation_output))
  }

  if ("iter" %in% colnames(simulation_output)) {
    cleaned_simulation_output$iter <- 0:(nrow(cleaned_simulation_output) - 1)
  } else {
    colnames(cleaned_simulation_output) <- concepts
    cleaned_simulation_output <- cbind(iter = 0:(nrow(cleaned_simulation_output) - 1), cleaned_simulation_output)
  }

  attr(cleaned_simulation_output, "index") <- "iter"

  return(cleaned_simulation_output)
}


#' Check Simulation Inputs
#'
#' @description
#' Confirm that all inputs will work with the simulation function and return
#' appropriate error messages where necessary. Also get the class of the FCM
#' represented by the input adjacency matrix (Conventional, IVFN, or TFN).
#'
#' @details
#' This checks that all inputs for a simulation function are of an appropriate
#' format, and also fills in missing inputs for initial_state_vector,
#' clamping_vector, activation, squashing, lambda, and point_of_inference.
#'
#' @param adj_matrix \[`data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)` - Positive]\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel processing.
#' @param show_progress  \[`logical(1)`]\cr If TRUE, show progress bars and
#' print runtime updates in the console when performing FCM simulations.
#' @param n_cores \[`integer(1)` - Positive]\cr The number of cores to use in
#' parallel processing. If no input given, all available cores will be used.
#' @param include_sims_in_output \[`logical(1)`]\cr If TRUE, incorporate
#' zero-weighted edges during FCM aggregation and Monte Carlo sampling.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`list()`]\cr A list of all inputs asserted to their defined
#' object type (i.e. via as.character, as.numeric, as.integer). Errors/Warnings
#' displayed if any input is rejected.
#'
#' @example man/examples/ex-check_simulation_inputs.R
#' @keywords internal
#' @noRd
check_simulation_inputs <- function(adj_matrix = data.frame(),
                                    initial_state_vector = c(),
                                    clamping_vector = c(),
                                    activation = c("kosko", "modified-kosko", "rescale"),
                                    squashing = c("sigmoid", "tanh"),
                                    lambda = 1.0,
                                    point_of_inference = c("peak", "final"),
                                    max_iter = 100,
                                    min_error = 1e-4,
                                    parallel = FALSE,
                                    n_cores = 1L,
                                    show_progress = FALSE,
                                    include_sims_in_output = FALSE,
                                    skip_checks = FALSE) {

  # Have to check adj_matrix input before continuing with other checks
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  adj_matrix_check <- check_fcmconfr_input(adj_matrix, check = "square_adj_matrix", var_name = "adj_matrix")
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrix)
  adj_matrix <- assert_matrix(adj_matrix, fcm_class = fcm_class, var_name_input = "adj_matrix")

  if (skip_checks) {
    return(list(
      fcm_class = fcm_class,
      adj_matrix = adj_matrix,
      initial_state_vector = initial_state_vector,
      clamping_vector = clamping_vector,
      activation = tolower(as.character(activation)),
      squashing = tolower(as.character(squashing)),
      lambda = as.numeric(round(lambda, abs(log(.Machine$double.eps)))),
      point_of_inference = tolower(as.character(point_of_inference)),
      max_iter = as.integer(max_iter),
      min_error = as.numeric(round(min_error, abs(log(.Machine$double.eps)))),
      parallel = as.logical(parallel),
      n_cores = as.integer(n_cores),
      show_progress = as.logical(show_progress),
      include_sims_in_output = as.logical(include_sims_in_output)
    ))
  }

  n_nodes <- unique(dim(adj_matrix))

  # Make assumptions for empty inputs ----
  if (identical(initial_state_vector, c())) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var initial_state_vector} given",
      "~~~~~ Assuming all nodes have an initial state of 1; i.e. initial_state_vector = c(1, 1, ..., 1)"
    )))
    initial_state_vector <- rep(1, n_nodes)
  }
  if (identical(clamping_vector, c())) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var initial_state_vector} given",
      "~~~~~ Assuming no nodes are clamped; i.e. clamping_vector = c(0, 0, ..., 0)"
    )))
    clamping_vector <- rep(0, n_nodes)
  }
  if (identical(activation, c("kosko", "modified-kosko", "rescale"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var activation_function} given",
      "~~~~~ Assuming activation = 'kosko'"
    )))
    activation <- "kosko"
  }
  if (identical(squashing, c("sigmoid", "tanh"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var squashing_function} given",
      "~~~~~ Assuming squashing = 'sigmoid'"
    )))
    squashing <- "sigmoid"
  }
  if (identical(point_of_inference, c("peak", "final"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var point_of_inference} given",
      "~~~~~ Assuming point_of_inference = 'final'"
    )))
    point_of_inference <- "final"
  }
  # ----

  # Generic type (autotest-passing) checkmate tests ----
  initial_state_vector_check <- check_fcmconfr_input(initial_state_vector, check = "numeric_vector", var_name = "initial_state_vector")
  clamping_vector_check <- check_fcmconfr_input(clamping_vector, check = "numeric_vector", var_name = "clamping_vector")
  activation_check <- check_fcmconfr_input(activation, check = "choice_selection", choice_selection_opts = c("kosko", "modified-kosko", "rescale"), var_name = "activation")
  squashing_check <- check_fcmconfr_input(squashing, check = "choice_selection", choice_selection_opts = c("sigmoid", "tanh"), var_name = "squashing")
  lambda_check <- check_fcmconfr_input(lambda, check = "positive_number", var_name = "lambda")
  point_of_inference_check <- check_fcmconfr_input(point_of_inference, check = "choice_selection", choice_selection_opts = c("peak", "final"), var_name = "point_of_inference")
  max_iter_check <- check_fcmconfr_input(max_iter, check = "positive_integer", var_name = "max_iter")
  min_error_check <- check_fcmconfr_input(min_error, check = "positive_number", var_name = "min_error")
  parallel_check <- check_fcmconfr_input(parallel, check = "logical", var_name = "parallel")
  n_cores_check <- check_fcmconfr_input(n_cores, check = "positive_integer", var_name = "n_cores", zero_is_positive = FALSE)
  show_progress_check <- check_fcmconfr_input(show_progress, check = "logical", var_name = "show_progress")
  include_sims_in_output_check <- check_fcmconfr_input(include_sims_in_output, check = "logical", var_name = "include_sims_in_output")

  activation = tolower(as.character(activation))
  squashing = tolower(as.character(squashing))
  lambda =  as.numeric(round(lambda, abs(log(.Machine$double.eps))))
  point_of_inference = tolower(as.character(point_of_inference))
  max_iter = as.integer(max_iter)
  min_error = as.numeric(round(min_error, abs(log(.Machine$double.eps))))
  parallel = as.logical(parallel)
  n_cores = as.integer(n_cores)
  show_progress = as.logical(show_progress)
  include_sims_in_output = as.logical(include_sims_in_output)

  # generic_input_checks <- c(adj_matrix_check, initial_state_vector_check, clamping_vector_check, activation_check, squashing_check, lambda_check, point_of_inference_check, max_iter_check, min_error_check, parallel_check, n_cores_check, show_progress_check, include_sims_in_output_check)
  # ----

  # Additional checks ----
  # Additional initial_state_vector_checks
  initial_state_vector_generic_check_passed <- isTRUE(initial_state_vector_check)
  if (initial_state_vector_generic_check_passed && (!setequal(length(initial_state_vector), n_nodes))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var initial_state_vector} must be the same length as the number of nodes in input {.var adj_matrix}",
      "+++++ Length of {.var initial_state_vector} is {length(initial_state_vector)}, but should be {n_nodes}"
    )))
  }

  # Additional clamping_vector_checks
  clamping_vector_generic_check_passed <- isTRUE(clamping_vector_check)
  if (clamping_vector_generic_check_passed && (!setequal(length(clamping_vector), n_nodes))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var clamping_vector} must be the same length as the number of nodes in input {.var adj_matrix}",
      "+++++ Length of {.var clamping_vector} is {length(clamping_vector)}, but should be {n_nodes}"
    )))
  }

  initial_state_and_clamping_vector_generic_checks_passed <- initial_state_vector_generic_check_passed && clamping_vector_generic_check_passed
  if ((initial_state_and_clamping_vector_generic_checks_passed) && ((any(clamping_vector != 0) & !all(initial_state_vector == 1)))) {
    stop(cli::format_error(c(
      "x" = "Error: If any nodes are clamped (i.e. {.var clamping_vector} contains non-zero elements),
      all elements in {.var initial_state_vector} must be set to 1 to perform the analysis correctly; i.e. initial_state_vector = c(1, 1, ..., 1)"
    )))
  }

  # Additional activation and squashing checks
  if (activation == "rescale" & squashing != "sigmoid") {
    stop(cli::format_error(c(
      "x" = "Error: '{squashing}' is not compatible with the 'rescale' activation function",
      "+++++ The 'rescale' activation function is designed to optimize performance of the sigmoid squashing function",
      "+++++ Results are unreliable with incompatible squashing functions."
    )))
  } else if (activation == "modified-kosko" & squashing == "tanh") {
    warning(cli::format_warning(c(
      "!" = "Warning: The 'tanh' squashing function performs poorly with the 'modified-kosko' activation function",
      "~~~~~ Simulation inference values tend to approach 0 as the number of simulation iterations increases"
    )))
  }

  # Additional lambda checks
  if (lambda > 10) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var lambda} is typically less than 10 and greater than 0, with 1 being the typical value",
      "~~~~~ Input {.var lambda} was {lambda}"
    )))
  }

  # Additional point_of_inference checks
  if (point_of_inference == "peak" & all(initial_state_vector == 1)) {
    warning(cli::format_warning(c(
      "!" = "Warning: Simulation inferences will return all 1's if {.var point_of_inferences} = 'peak' and all concept activation levels start at 1; i.e. initial_state_vector = c(1, 1, ..., 1) "
    )))
  }

  # Additional min_error checks
  if (min_error >= 1) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var point_of_inference} value of {point_of_inference} may be too high.",
      "~~~~~ Typically {.var min_error} < 0.001, but greater than 0"
    )))
  }
  # ----

  # Additional parallel and show_progress checks
  parallel <- as.logical(parallel)
  show_progress <- as.logical(show_progress)

  # Additional n_cores checks
  available_cores <- parallel::detectCores()
  if (n_cores > available_cores) {
    stop(cli::format_error(c(
      "x" = "Error: {.var n_cores} was {n_cores} but machine only has {available_cores} cores.",
      "+++++> Reduce {.var n_cores} to a value lower than {available_cores}."
    )))
  }

  return(list(
    fcm_class = fcm_class,
    adj_matrix = adj_matrix,
    initial_state_vector = initial_state_vector,
    clamping_vector = clamping_vector,
    activation = tolower(as.character(activation)),
    squashing = tolower(as.character(squashing)),
    lambda =  as.numeric(round(lambda, abs(log(.Machine$double.eps)))),
    point_of_inference = tolower(as.character(point_of_inference)),
    max_iter = as.integer(max_iter),
    min_error = as.numeric(round(min_error, abs(log(.Machine$double.eps)))),
    parallel = as.logical(parallel),
    n_cores = as.integer(n_cores),
    show_progress = as.logical(show_progress),
    include_sims_in_output = as.logical(include_sims_in_output)
  ))
}


#' Print method for infer_conventional_fcm objects
#'
#' @param x \[`infer_conventional_fcm`]\cr an object directly output from
#' \code{infer_conventional_fcm}
#' @param ... additional inputs
#'
#' @returns \[`NULL`]\cr A console printout of
#' \code{infer_conventional_fcm} results
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
print.infer_conventional_fcm <- function(x, ...) {
  cat(paste0("fcmconfr: ", "conventional"),
      "\n $inference\n",
      paste0("  ", colnames(x$inference), ": ", round(x$inference, digits = 2), sep = "\n"),
      "$inference_for_plotting\n",
      paste0("  - inference data transformed to streamline plotting with ggplot"),
      "\n $inference_state_vectors\n",
      paste0("  - inferences across all iterations of the simulation"),
      "\n $scenario_simulation\n",
      "$baseline_simulation"
  )
}


#' Print method for infer_ivfn_or_tfn_fcm objects
#'
#' @param x \[`infer_ivfn_or_tfn_fcm`]\cr an object directly output from
#' \code{infer_ivfn_or_tfn_fcm}
#' @param ... additional inputs
#'
#' @returns \[`NULL`]\cr A console printout of
#' \code{infer_ivfn_or_tfn_fcm} results
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
print.infer_ivfn_or_tfn_fcm <- function(x, ...) {
  fcm_class <- methods::is(x$inferences[1, 1][[1]])
  if (fcm_class == "ivfn") {
    cat(paste0("infer_fcm: ", "ivfn"),
        "\n $inferences_df\n",
        paste0("  ", x$inference_df$concept, ": [", round(x$inferences_df$lower, 2), ", ", round(x$inferences_df$upper, 2), "] (", round(x$inferences_df$crisp, 2), ")", sep = "\n"),
        "$inferences_for_plotting\n",
        paste0("  - inference data transformed to streamline plotting with ggplot"),
        "\n $inference_state_vectors\n",
        paste0("  - inferences as fuzzy sets across all iterations of the simulation"),
        "\n $scenario_simulation\n",
        "$baseline_simulation"
    )
  } else if (fcm_class == "tfn") {
    cat(paste0("infer_fcm: ", "tfn"),
        "\n $inferences_df\n",
        paste0("  ", x$inferences_df$concept, ": [", round(x$inferences_df$lower, 2), ", ", round(x$inferences_df$mode, 2), ", ", round(x$inferences_df$upper, 2), "] (", round(x$inferences_df$crisp, 2), ")", sep = "\n"),
        "$inferences_for_plotting\n",
        paste0("  - inference data transformed to streamline plotting with ggplot"),
        "\n $inference_state_vectors\n",
        paste0("  - inferences as fuzzy sets across all iterations of the simulation"),
        "\n $scenario_simulation\n",
        "$baseline_simulation"
    )
  }
}

