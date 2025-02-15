
################################################################################
# infer_and_simulate_fcm.R
#
# These functions help with fcm inference estimation. Note that some are
# intended for developer use only.
#
#   - infer_fcm_set
#   - infer_fcm
#   - infer_conventional_fcm
#   - infer_ivfn_or_tfn_fcm
#   - simulate_fcm
#   - simulate_conventional_fcm
#   - simulate_ivfn_or_tfn_fcm
#   - squash
#
################################################################################


#' Infer Multiple FCMs in a List
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @description
#' This function mass simulates a set of FCMs (Conventional, IVFN, and/or TFN)
#' (whose edge weights were sampled using monte carlo methods) by repetitively
#' calling the infer_fcm function for each empirical (monte carlo) adj. matrix.
#'
#' @details
#' The show_progress and parallel inputs change the functions called, but do NOT
#' change the output! These are allowed to be toggled on/off to increase user
#' control at runtime.
#'
#' @param adj_matrices A list of adjecency matrices generated from simulation using build_fmcm_models.
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#' @param parallel TRUE/FALSE Whether to utilize parallel processing
#' @param show_progress TRUE/FALSE Show progress bar when creating fmcm. Uses pbmapply
#' from the pbapply package as the underlying function.
#' @param n_cores Number of cores to use in parallel processing. If no input given,
#' will use all available cores in the machine.
#' @param include_sims_in_output TRUE/FALSE whether to include simulations of monte-carlo-generated
#' FCM. Will dramatically increase size of output if TRUE.
#' @param skip_checks FOR DEVELOPER USE ONLY. TRUE if infer_fcm is called within
#' fcmconfr() and checks have already been performed
#'
#' @returns A list of two dataframes: the first contains all inference estimates
#' across the empirical (monte carlo) FCM inferences, and the second is an
#' elongated version of the first dataframe that organizes the data for
#' plotting (particularly with ggplot2)
#'
#' @importFrom cli format_error
#' @importFrom parallel makeCluster clusterExport stopCluster parLapply
#' @importFrom rlang search_envs
#' @importFrom pbapply pblapply
#'
#' @export
#' @example man/examples/ex-infer_fcm_set.R
infer_fcm_set <- function(adj_matrices = list(matrix()),
                          initial_state_vector = c(),
                          clamping_vector = c(),
                          activation = c("kosko", "modified-kosko", "rescale"),
                          squashing = c("sigmoid", "tanh"),
                          lambda = 1,
                          point_of_inference = c("peak", "final"),
                          max_iter = 100,
                          min_error = 1e-5,
                          parallel = TRUE,
                          n_cores = integer(),
                          show_progress = TRUE,
                          include_sims_in_output = FALSE,
                          skip_checks = FALSE) {

  # Adding for R CMD check. Does not impact logic.
  i <- NULL

  if (!is.logical(skip_checks)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var skip_checks} must be a logical value (TRUE/FALSE)",
      "+++++> Input {.var skip_checks} was: {skip_checks}"
    )))
  }
  # Perform input checks ----
  if (!skip_checks) {
    checks <- check_infer_fcm_set_inputs(
      adj_matrices,
      initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error,
      parallel, n_cores, show_progress, include_sims_in_output
    )
    fcm_class <- checks$fcm_class
    adj_matrices <- checks$adj_matrices
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    point_of_inference <- checks$point_of_inference
    show_progress <- checks$show_progress
    parallel <- checks$parallel
  } else {
    fcm_class <- get_adj_matrices_input_type(adj_matrices)$object_types_in_list[1]
  }
  # ----

  if (parallel & show_progress) {
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
            min_error = min_error
          )
        },
        cl = cl
      )
    )
    names(inferences_for_adj_matrices) <- paste0("adj_matrix_", seq_along(inferences_for_adj_matrices))
    parallel::stopCluster(cl)
  } else if (parallel & !show_progress) {
    print("Initializing cluster", quote = FALSE)
    cl <- parallel::makeCluster(n_cores)
    fcmconfr_env <- rlang::search_envs()[[which(names(rlang::search_envs()) == "package:fcmconfr")]]
    parallel::clusterExport(cl, names(fcmconfr_env))
    cat("\n")
    print("Running simulations", quote = FALSE)
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
            min_error = min_error
          )
        }
      )
    )
    parallel::stopCluster(cl)

  } else if (!parallel & show_progress) {
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
          min_error = min_error
        )
      }
    )

  } else if (!parallel & !show_progress) {
    cat("\n")
    print("Running simulations", quote = FALSE)
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
          min_error = min_error
        )
      }
    )
  }

  if (identical(fcm_class, "conventional")) {
    inference_values_by_sim <- lapply(inferences_for_adj_matrices, function(sim) sim$inferences)
  } else {
    inference_values_by_sim <- lapply(inferences_for_adj_matrices, function(sim) sim$inferences)
  }

  inference_values_by_sim <- do.call(rbind, inference_values_by_sim)
  rownames(inference_values_by_sim) <- 1:nrow(inference_values_by_sim)

  if (include_sims_in_output) {
    structure(
      .Data = list(
        inferences = inference_values_by_sim,
        simulations = inferences_for_adj_matrices
      ),
      class = "inference_of_fcm_set"
    )
  } else {
    structure(
      .Data = list(
        inferences = inference_values_by_sim
      ),
      class = "inference_of_fcm_set"
    )
  }
}



#' Infer FCM
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#' @param skip_checks FOR DEVELOPER USE ONLY. TRUE if infer_fcm is called within
#' fcmconfr() and checks have already been performed
#'
#' @returns A list of fcm inference results (including baseline and simulation outputs)
#'
#' @importFrom cli format_error
#'
#' @export
#'
#' @example man/examples/ex-infer_fcm.R
infer_fcm <- function(adj_matrix = matrix(),
                      initial_state_vector = c(),
                      clamping_vector = c(),
                      activation = c("kosko", "modified-kosko", "rescale"),
                      squashing = c("sigmoid", "tanh"),
                      lambda = 1,
                      point_of_inference = c("peak", "final"),
                      max_iter = 100,
                      min_error = 1e-5,
                      skip_checks = FALSE) {

  if (!is.logical(skip_checks)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var skip_checks} must be a logical value (TRUE/FALSE)",
      "+++++> Input {.var skip_checks} was: {skip_checks}"
    )))
  }

  if (!skip_checks) {
    checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
    fcm_class <- checks$fcm_class
    adj_matrix <- checks$adj_matrix
    initial_state_vector <- checks$initial_state_vector
    clamping_vector <- checks$clamping_vector
    activation <- checks$activation
    squashing <- checks$squashing
    point_of_inference <- checks$point_of_inference
  } else {
    fcm_class <- get_adj_matrices_input_type(adj_matrix)$object_types_in_list[1]
  }

  if (fcm_class == "conventional") {
    inference <- infer_conventional_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    inference <- infer_ivfn_or_tfn_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  }

  inference
  #infer_conventional_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, max_iter, min_error)

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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#'
#' @returns A list of (conventional) fcm inference results (including baseline
#' and simulation outputs)
#'
#' @importFrom cli format_error
#'
#' @export
#' @example man/examples/ex-infer_conventional_fcm.R
infer_conventional_fcm <- function(adj_matrix = matrix(),
                                   initial_state_vector = c(),
                                   clamping_vector = c(),
                                   activation = c("kosko", "modified-kosko", "rescale"),
                                   squashing = c("sigmoid", "tanh"),
                                   lambda = 1,
                                   point_of_inference = c("peak", "final"),
                                   max_iter = 100,
                                   min_error = 1e-5) {


  iter <- NULL # for R CMD Check, does not impact logic

  fcm_class <- get_adj_matrices_input_type(adj_matrix)$fcm_class
  if (!(fcm_class %in% c("conventional"))) {
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
    baseline_simulation <- simulate_fcm(adj_matrix, dummy_initial_state_vector, dummy_clamping_vector, activation = "kosko", squashing = "tanh", lambda, point_of_inference, max_iter, min_error)
    baseline_simulation_is_dummy <- TRUE
  } else {
    # Get baseline simulation
    baseline_initial_state_vector <- rep(1, length(initial_state_vector))
    baseline_clamping_vector <- rep(0, length(clamping_vector))
    baseline_simulation <- simulate_fcm(adj_matrix, baseline_initial_state_vector, baseline_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#'
#' @returns A list of (ivfn or tfn) fcm inference results (including baseline
#' and simulation outputs)
#'
#' @importFrom cli format_error
#' @importFrom tidyr pivot_longer
#'
#' @export
#' @example man/examples/ex-infer_ivfn_or_tfn_fcm.R
infer_ivfn_or_tfn_fcm <- function(adj_matrix = matrix(),
                                  initial_state_vector = c(),
                                  clamping_vector = c(),
                                  activation = c("kosko", "modified-kosko", "rescale"),
                                  squashing = c("sigmoid", "tanh"),
                                  lambda = 1,
                                  point_of_inference = c("peak", "final"),
                                  max_iter = 100,
                                  min_error = 1e-5) {

  fcm_class <- get_adj_matrices_input_type(adj_matrix)$fcm_class
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
  scenario_simulation <- simulate_fcm(adj_matrix, scenario_initial_state_vector, scenario_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)

  if (all(clamping_vector == 0)) {
    dummy_initial_state_vector <- rep(0, length(initial_state_vector))
    dummy_clamping_vector <- rep(0, length(initial_state_vector))
    # Use squashing = "tanh" to force 0's to remain 0's, rather than converting
    # 0's to 0.5's if squashing = "sigmoid"
    baseline_simulation <- simulate_fcm(adj_matrix, dummy_initial_state_vector, dummy_clamping_vector, activation = "kosko", squashing = "tanh", lambda, point_of_inference, max_iter, min_error)
    baseline_simulation_is_dummy <- TRUE
  } else {
    # Get baseline simulation
    baseline_initial_state_vector <- rep(1, length(initial_state_vector))
    # baseline_initial_state_vector <- initial_state_vector
    baseline_clamping_vector <- rep(0, length(clamping_vector))
    baseline_simulation <- simulate_fcm(adj_matrix, baseline_initial_state_vector, baseline_clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
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
  rownames(inferences) <- point_of_inference

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

  structure(
    .Data = list(
      inferences = inferences,
      inferences_df = inferences_df,
      # inferences_for_plotting = inferences_plot_data,
      simulations = list(
        scenario_simulation = scenario_simulation,
        baseline_simulation = baseline_simulation
      )
    ),
    class = "infer_ivfn_or_tfn_fcm"
  )
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#'
#' @returns (Conventional, IVFN, or TFN) FCM simulation results
#'
#' @export
#' @example man/examples/ex-simulate_fcm.R
simulate_fcm <- function(adj_matrix = matrix(),
                         initial_state_vector = c(),
                         clamping_vector = c(),
                         activation = c("kosko", "modified-kosko", "rescale"),
                         squashing = c("sigmoid", "tanh"),
                         lambda = 1,
                         point_of_inference = c("peak", "final"),
                         max_iter = 100,
                         min_error = 1e-5) {

  checks <- check_simulation_inputs(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  fcm_class <- checks$fcm_class
  adj_matrix <- checks$adj_matrix
  initial_state_vector <- checks$initial_state_vector
  clamping_vector <- checks$clamping_vector
  activation <- checks$activation
  squashing <- checks$squashing
  point_of_inference <- checks$point_of_inference

  if (fcm_class == "conventional") {
    simulation <- simulate_conventional_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    simulation <- simulate_ivfn_or_tfn_fcm(adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  }

  simulation
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#'
#' @returns (Conventional) FCM simulation results
#'
#' @importFrom stats na.omit
#' @importFrom cli format_error format_warning
#'
#' @export
#' @example man/examples/ex-simulate_conventional_fcm.R
simulate_conventional_fcm <- function(adj_matrix = matrix(),
                                      initial_state_vector = c(),
                                      clamping_vector = c(),
                                      activation = c("kosko", "modified-kosko", "rescale"),
                                      squashing = c("sigmoid", "tanh"),
                                      lambda = 1,
                                      point_of_inference = c("peak", "final"),
                                      max_iter = 100,
                                      min_error = 1e-5) {

  fcm_class <- get_adj_matrices_input_type(adj_matrix)$object_types_in_list[1]
  if (!(fcm_class %in% c("conventional"))) {
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
    next_state_vector <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector, activation)
    normalized_state_vector <- squash(next_state_vector, squashing = squashing, lambda = lambda)
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

  structure(
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
  )
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing A squashing function to apply. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the slope of the
#' squashing function when tanh or sigmoid are applied
#' @param point_of_inference The point along the simulation time-series to be
#' identified as the inference. Must be one of the following: 'peak' or 'final'
#' @param max_iter The maximum number of iterations to run if the minimum error value is not achieved
#' @param min_error The lowest error (sum of the absolute value of the current state
#' vector minus the previous state vector) at which no more iterations are necessary
#' and the simulation will stop
#'
#' @returns (IVFN or TFN) FCM simulation results
#'
#' @importFrom methods is
#' @importFrom cli format_error format_warning
#'
#' @export
#' @example man/examples/ex-simulate_ivfn_or_tfn_fcm.R
simulate_ivfn_or_tfn_fcm <- function(adj_matrix = matrix(),
                                     initial_state_vector = c(),
                                     clamping_vector = c(),
                                     activation = c("kosko", "modified-kosko", "rescale"),
                                     squashing = c("sigmoid", "tanh"),
                                     lambda = 1,
                                     point_of_inference = c("peak", "final"),
                                     max_iter = 100,
                                     min_error = 1e-5) {

  fcm_class <- get_adj_matrices_input_type(adj_matrix)$object_types_in_list[1]
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
    next_fuzzy_set_state_vector <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix, fuzzy_set_state_vector, crisp_state_vector, activation, fcm_class)
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

  structure(
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
    class = "ivfn_or_tfn_simulation"
  )
}


#' Squash
#'
#' @description
#' Calculate squashing function output of an input value and lambda values
#'
#' @details
#' This function calculates the 'squashed' value of a state based upon five
#' available squashing functions typical in the literature (as identified in
#' Gonzales et al. 2018 - https://doi.org/10.1142/S0218213018600102)
#'
#' @param value A numeric value to 'squash'
#' @param squashing A squashing function to apply. Must be one of the following: 'tanh', or 'sigmoid'
#' @param lambda A numeric value that defines the steepness of the slope of the squashing function when tanh or sigmoid are applied
#'
#' @returns A "squashed" value, the output of the selected transfer ("squashing")
#' function
#'
#' @export
#' @examples
#' squash(1, "sigmoid", lambda = 1)
#' squash(0.6, "tanh", lambda = 0.7)
squash <- function(value = numeric(),
                   squashing = c("sigmoid", "tanh"),
                   lambda = 1) {
  if (lambda <= 0) {
    stop("Input lambda must be greater than zero")
  }

  # Use full names here instead of abbreviations to improve readability even
  # though developers will need to type more characters.
  if (squashing == "tanh") {
    squashed_value <- (exp(2*lambda*value) - 1)/(exp(2*lambda*value) + 1)
  } else if (squashing == "sigmoid") {
    squashed_value <- 1/(1 + exp(-lambda*value))
  } else {
    stop("squashing value must be one of the following:
      'tanh', or 'sigmoid'")
  }

  squashed_value
}
