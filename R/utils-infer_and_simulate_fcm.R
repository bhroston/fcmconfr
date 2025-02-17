

################################################################################
# utils-fcmconfr.R
#
# These utility functions are involved with FCM inference and simulation.
#
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



#' Check inputs for running infer_fcm on a list of adj. matrices
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @param adj_matrices A list of adjecency matrices
#' @param initial_state_vector A list state values at the start of an fcm simulation
#' @param clamping_vector A list of values representing specific actions taken to
#' control the behavior of an FCM. Specifically, non-zero values defined in this vector
#' will remain constant throughout the entire simulation as if they were "clamped" at those values.
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'papageorgiou'.
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
#' @param mc_sims_in_output TRUE/FALSE whether to include simulations of monte-carlo-generated
#' FCM. Will dramatically increase size of output if TRUE.
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
check_infer_fcm_set_inputs <- function(adj_matrices = list(matrix()),
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
                                       mc_sims_in_output = FALSE) {

  # Check adj_matrices ----
  adj_matrices_input_type <- get_adj_matrices_input_type(adj_matrices)
  fcm_class <- adj_matrices_input_type$fcm_class
  if (!adj_matrices_input_type$adj_matrices_input_is_list) {
    adj_matrices <- list(adj_matrices)
  }
  adj_matrices_dims <- lapply(adj_matrices, dim)
  if (length(unique(unlist(adj_matrices_dims))) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrices} are either different sizes or contain non-square matrices",
      "+++++> Call standardize_adj_matrices() to standardize the sizes of {.var adj. matrices}"
    )))
  }
  n_nodes <- unique(unlist(adj_matrices_dims))
  dummy_adj_matrix <- matrix(0, n_nodes, n_nodes)

  identified_concepts <- unique(lapply(adj_matrices, colnames))
  if (length(identified_concepts) != 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrices} must have the same concepts",
      "+++++> Call standardize_adj_matrices() to standardize concepts across {.var adj. matrices}"
    )))
  } else {
    concept_names <- unlist(identified_concepts)
  }

  if (identical(adj_matrices_input_type$object_types_in_list, c("conventional", "sparseMatrix"))) {
    adj_matrices <- lapply(adj_matrices, as.matrix)
    warning(cli::format_warning(c(
      "!" = "Warning: Changed {.var adj_matrices} from sparseMatrix to an ordinary matrix (i.e. using as.matrix)"
    )))
  }
  # ----

  # Check Simulation Inputs ----
  sim_checks <- check_simulation_inputs(dummy_adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error)
  initial_state_vector <- sim_checks$initial_state_vector
  clamping_vector <- sim_checks$clamping_vector
  activation <- sim_checks$activation
  squashing <- sim_checks$squashing
  point_of_inference <- sim_checks$point_of_inference
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

  # Check Output Options ----
  if (!is.logical(mc_sims_in_output)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var mc_sims_in_output} must be logical (TRUE/FALSE)",
      "+++++> Input {.var mc_sims_in_output} was {mc_sims_in_output}"
    )))
  }
  # ----

  list(
    fcm_class = fcm_class,
    adj_matrices = adj_matrices,
    concept_names = concept_names,
    initial_state_vector = initial_state_vector,
    clamping_vector = clamping_vector,
    activation = activation,
    squashing = squashing,
    point_of_inference = point_of_inference,
    show_progress = show_progress,
    parallel = parallel
  )
}


#' Calculate Next (Conventional) FCM State
#' Vector
#'
#' @description
#' This calculates the next iteration of a state vector in an fcm simulation
#' based on the kosko, modified-kosko, or rescale activation functions
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' The state of the art of fcm typically applies one of three activation functions
#' in calculating iterative state vector values: kosko, modified-kosko, and
#' rescale.
#'
#' kosko: Only considers the current iteration (Kosko, 1986 - https://doi.org/10.1016/S0020-7373(86)80040-2)
#'
#' modified-kosko: The previous value of a node influences its future value (Stylio & Groumpos, 2004 - https://doi.org/10.1109/TSMCA.2003.818878)
#'
#' rescale: Like modified-kosko, but assigns nodes with no value with a
#' value of 0.5 to reduce the influence that a lack of initial state information
#' can have on the simulation output (Papageorgiou, 2011 - https://doi.org/10.1016/j.asoc.2009.12.010)
#'
#' Use vignette("fcm-class") for more information.
#'
#' @references Kosko, 1986
#'
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#' @param state_vector A list state values at a particular iteration in an fcm simulation
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#'
#' @returns The (i + 1) iteration of the input state_vector based on the
#' adj_matrix and activation function
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
calculate_next_conventional_fcm_state_vector <- function(adj_matrix = matrix(),
                                                         state_vector = c(),
                                                         activation = c("kosko", "modified-kosko", "rescale")) {
  adj_matrix <- as.matrix(adj_matrix)
  state_vector <- as.matrix(state_vector)

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
  next_state_vector
}


#' Calculate Next (IVFN-FCM or TFN-FCM) State
#' Vector
#'
#' @description
#' This calculates the next iteration of a state vector in an fcm simulation
#' based on the kosko, modified-kosko, or rescale activation functions
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' The state of the art of fcm typically applies one of three activation functions
#' in calculating iterative state vector values: kosko, modified-kosko, and
#' rescale (as identified in Gonzales et al. 2018 - https://doi.org/10.1142/S0218213018600102).
#'
#' kosko: Only considers the current iteration (Kosko, 1986 - https://doi.org/10.1016/S0020-7373(86)80040-2)
#'
#' modified-kosko: The previous value of a node influences its future value (Stylio & Groumpos, 2004 - https://doi.org/10.1109/TSMCA.2003.818878)
#'
#' rescale: Like modified-kosko, but assigns nodes with no value with a
#' value of 0.5 to reduce the influence that a lack of initial state information
#' can have on the simulation output (rescale, 2011 - https://doi.org/10.1016/j.asoc.2009.12.010)=
#'
#' @param fuzzy_set_adj_matrix An n x n adjacency matrix that represents an FCM
#' and every element in the matrix is a tfn.
#' @param fuzzy_set_state_vector A list of state values as tfn objects
#' @param crisp_state_vector A list of state values as defuzzed tfn objects
#' @param activation The activation function to be applied. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param fcm_class Class of edges in fuzzy_set_adj_matrix. Either 'ivfn' or 'tfn'
#'
#' @returns The (i + 1) iteration of the input state_vector based on the
#' adj_matrix and activation function
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
calculate_next_fuzzy_set_fcm_state_vector <- function(fuzzy_set_adj_matrix = matrix(),
                                                      fuzzy_set_state_vector = c(),
                                                      crisp_state_vector = c(),
                                                      activation = c("kosko", "modified-kosko", "rescale"),
                                                      fcm_class = c("ivfn", "tfn")) {

  next_fuzzy_set_state_vector <- vector(mode = "list", length = length(fuzzy_set_state_vector))
  for (col in seq_along(fuzzy_set_adj_matrix)) {
    dot_product_multiplication_only <- mapply(
      function(coefficient, column_vector) {
        if (activation == "rescale") coefficient <- 2*coefficient - 1
        if (coefficient >= 0) {
          if (fcm_class == "ivfn") {
            ivfn(coefficient*column_vector$lower, coefficient*column_vector$upper)
          } else if (fcm_class == "tfn") {
            tfn(coefficient*column_vector$lower, coefficient*column_vector$mode, coefficient*column_vector$upper)
          }
        } else {
          if (fcm_class == "ivfn") {
            ivfn(coefficient*column_vector$upper, coefficient*column_vector$lower)
          } else if (fcm_class == "tfn") {
            tfn(coefficient*column_vector$upper, coefficient*column_vector$mode, coefficient*column_vector$lower)
          }
        }
      },
      coefficient = crisp_state_vector,
      column_vector = fuzzy_set_adj_matrix[, col]
    )
    dot_product <- apply(dot_product_multiplication_only, 1, function(row) sum(unlist(row)))
    if (fcm_class == "ivfn") {
      next_fuzzy_set_state_vector_column <- ivfn(dot_product[1], dot_product[2])
    } else if (fcm_class == "tfn") {
      next_fuzzy_set_state_vector_column <- tfn(dot_product[1], dot_product[2], dot_product[3])
    }
    next_fuzzy_set_state_vector[[col]] <- next_fuzzy_set_state_vector_column
  }

  if (activation == "kosko") {
    next_fuzzy_set_state_vector <-  next_fuzzy_set_state_vector
  } else if (activation == "modified-kosko") {
    next_fuzzy_set_state_vector <- mapply(
      function(fuzzy_set_1, fuzzy_set_2) {
        if (fcm_class == "ivfn") {
          ivfn(fuzzy_set_1$lower + fuzzy_set_2$lower, fuzzy_set_1$upper + fuzzy_set_2$upper)
        } else if (fcm_class == "tfn") {
          tfn(fuzzy_set_1$lower +  fuzzy_set_2$lower, fuzzy_set_1$mode +  fuzzy_set_2$mode, fuzzy_set_1$upper +  fuzzy_set_2$upper)
        }
      },
      fuzzy_set_1 = fuzzy_set_state_vector,
      fuzzy_set_2 = next_fuzzy_set_state_vector,
      SIMPLIFY = FALSE
    )
  } else if (activation == "rescale") {
    next_fuzzy_set_state_vector <- mapply(
      function(fuzzy_set_1, fuzzy_set_2) {
        if (fcm_class == "ivfn") {
          ivfn((2*fuzzy_set_1$lower - 1) + fuzzy_set_2$lower, (2*fuzzy_set_1$upper - 1) + fuzzy_set_2$upper)
        } else if (fcm_class == "tfn") {
          tfn((2*fuzzy_set_1$lower - 1) +  fuzzy_set_2$lower, (2*fuzzy_set_1$mode - 1) +  fuzzy_set_2$mode, (2*fuzzy_set_1$upper - 1) +  fuzzy_set_2$upper)
        }
      },
      fuzzy_set_1 = fuzzy_set_state_vector,
      fuzzy_set_2 = next_fuzzy_set_state_vector,
      SIMPLIFY = FALSE
    )
  }

  next_fuzzy_set_state_vector
}


#' Convert Value to IVFN or TFN if Value is Numeric
#'
#' @description
#' This checks whether the input element is an ordinary number or a triangular number.
#' If it is an ivfn or tfn, it returns the input, but if it is a numeric type
#' object (ordinary number), it will convert that number into an ivfn or tfn
#'
#' @param element An element in a matrix
#' @param desired_class Transform the element into an 'ivfn' or 'tfn'
#'
#' @returns An IVFN or TFN representation of a crisp, numeric value
#'
#' @keywords internal
#'
#' @importFrom methods is
#'
#' @export
#' @examples
#' convert_element_to_ivfn_or_tfn_if_numeric(0.6, "ivfn")
#' convert_element_to_ivfn_or_tfn_if_numeric(0.7, "tfn")
convert_element_to_ivfn_or_tfn_if_numeric <- function(element, desired_class = c("ivfn", "tfn")) {
  numeric_class <- methods::is(numeric())

  if (identical(methods::is(element), numeric_class) & identical(desired_class, "ivfn")) {
    converted_element <- ivfn(element, element)
  } else if (identical(methods::is(element), numeric_class) & identical(desired_class, "tfn")) {
    converted_element <- tfn(element, element, element)
  }
  converted_element
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
#' @param fuzzy_set_matrix A matrix that contains fuzzy sets as elements
#' @param object_class Values are represented either as ivfns or tfns. Options: 'ivfn' or 'tfn'
#' @param N_samples The number of samples to draw from the corresponding distribution
#'
#' @returns An adj. matrix of IVFNs or TFNs represented as lists (sets) of their
#' representative distributions
#'
#' @keywords internal
#'
#' @importFrom stats runif
#' @importFrom methods is
#'
#' @export
#' @example man/examples/ex-convert_fuzzy_set_elements_in_matrix_to_dists.R
convert_fuzzy_set_elements_in_matrix_to_distributions <- function(fuzzy_set_matrix = matrix(),
                                                                  object_class = c("ivfn", "tfn"),
                                                                  N_samples = integer()) {

  if (!(object_class %in% c("ivfn", "tfn"))) {
    stop("Input object_class must be either 'ivfn' or 'tfn'")
  }

  if (object_class == "ivfn") {
    fuzzy_set_matrix_w_distributions <- apply(
      fuzzy_set_matrix, c(1, 2),
      function(element) {
        element <- list(stats::runif(N_samples, element[[1]]$lower, element[[1]]$upper))
      }
    )
  } else if (object_class == "tfn") {
    fuzzy_set_matrix_w_distributions <- apply(
      fuzzy_set_matrix, c(1, 2),
      function(element) {
        if (identical(methods::is(element[[1]]), "tfn")) {
          list(rtriangular_dist(N_samples, lower = element[[1]]$lower, mode = element[[1]]$mode, upper = element[[1]]$upper))
        }
      }
    )
  }

  fuzzy_set_matrix_w_distributions
}


#' Clean Simulation Output
#'
#' @description
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' This adds quality-of-life improvements and detail to simulation output objects
#' such as adding column names and an iter column
#'
#' @param output_obj An fcm_w_fcm_w_tfn simulation output object
#' @param concepts A list of names for each node (must have n items). If empty, will use
#' column names of adjacancy matrix (if given).
#'
#' @returns A cleaned up simulation output
#'
#' @keywords internal
#'
#' @importFrom methods is
#' @importFrom stats na.omit
#'
#' @export
#' @examples
#' NULL
clean_simulation_output <- function(output_obj, concepts) {
  if (identical(methods::is(data.frame()), methods::is(output_obj))) {
    # output_obj is a data.frame
    clean_output_obj <- stats::na.omit(output_obj)
  } else {
    # output_obj is a list of lists
    clean_output_obj <- data.frame(do.call(rbind, output_obj))
  }

  if ("iter" %in% colnames(output_obj)) {
    clean_output_obj$iter <- 0:(nrow(clean_output_obj) - 1)
  } else {
    colnames(clean_output_obj) <- concepts
    clean_output_obj <- cbind(iter = 0:(nrow(clean_output_obj) - 1), clean_output_obj)
  }

  clean_output_obj
}


#' Check Simulation Inputs
#'
#' @description
#' Confirm that all inputs will work with the simulation function and return
#' appropriate error messages where necessary
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' This checks that all inputs for a simulation function are of an appropriate
#' format, and also fills in missing inputs for initial_state_vector, clamping_vector,
#' and IDs when appropriate.
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
#' @returns A formatted initial_state_vector and clamping_vector
#'
#' @keywords internal
#'
#' @importFrom cli format_error format_warning
#' @importFrom methods is
#'
#' @export
#' @examples
#' NULL
check_simulation_inputs <- function(adj_matrix = matrix(),
                                    initial_state_vector = c(),
                                    clamping_vector = c(),
                                    activation = c("kosko", "modified-kosko", "rescale"),
                                    squashing = c("sigmoid", "tanh"),
                                    lambda = 1,
                                    point_of_inference = c("peak", "final"),
                                    max_iter = 100,
                                    min_error = 1e-4) {

  adj_matrix_input_type <- get_adj_matrices_input_type(adj_matrix)

  # Check for individal adj_matrix ----
  adj_matrix_is_list <- adj_matrix_input_type$adj_matrices_input_is_list
  if (adj_matrix_is_list) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrix} must be an individual adj. matrix",
      "+++++> Input {.var adj_matrix} is a list of adj_matrices"
    )))
  }

  # Check adj_matrix ----
  rows <- nrow(adj_matrix)
  cols <- ncol(adj_matrix)
  if (rows != cols) {
    stop(cli::format_error(c(
      "x" = "Error: {.var adj_matrix} must be a square (n x n) matrix"
    )))
  }
  n_nodes <- unique(dim(adj_matrix))

  if (identical(adj_matrix_input_type$object_types_in_list, c("conventional", "sparseMatrix"))) {
    adj_matrix <- as.matrix(adj_matrix)
    warning(cli::format_warning(c(
      "!" = "Warning: Changed {.var adj_matrix} from sparseMatrix to an ordinary matrix (i.e. using as.matrix)"
    )))
  }
  # ----

  # Check initial_state_vector ----
  if (identical(initial_state_vector, c())) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var initial_state_vector} given",
      "~~~~~ Assuming all nodes have an initial state of 1; i.e. initial_state_vector = c(1, 1, ..., 1)"
    )))
    initial_state_vector <- rep(1, nrow(adj_matrix))
  }
  if (length(initial_state_vector) != n_nodes) {
    stop(cli::format_error(c(
      "x" = "Error: {.var initial_state_vector} must be the same length as the number of nodes in input {.var adj_matrix}",
      "+++++ Length of {.var initial_state_vector} is {length(initial_state_vector)}, but should be {n_nodes}"
    )))
  }
  data_types_in_initial_state_vector <- unlist(unique(sapply(initial_state_vector, methods::is, simplify = FALSE)))
  if (!identical(data_types_in_initial_state_vector, methods::is(numeric()))) {
    invalid_indexes <- is.na(suppressWarnings(as.numeric(initial_state_vector)))
    stop(cli::format_error(c(
      "x" = "Error: {.var initial_state_vector} must contain only numeric values.",
      "+++++ Invalid element(s): {initial_state_vector[invalid_indexes]}"
    )))
  }

  # ----

  # Check clamping_vector ----
  if (identical(clamping_vector, c())) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var initial_state_vector} given",
      "~~~~~ Assuming no nodes are clamped; i.e. clamping_vector = c(0, 0, ..., 0)"
    )))
    clamping_vector <- rep(0, length(initial_state_vector))
  }

  if (length(clamping_vector) != n_nodes) {
    stop(cli::format_error(c(
      "x" = "Error: {.var clamping_vector} must be the same length as the number of nodes in input {.var adj_matrix}",
      "+++++ Length of {.var clamping_vector} is {length(clamping_vector)}, but should be {n_nodes}"
    )))
  }

  data_types_in_clamping_vector <- unlist(unique(sapply(clamping_vector, methods::is, simplify = FALSE)))
  if (!identical(data_types_in_clamping_vector, methods::is(numeric()))) {
    invalid_indexes <- is.na(suppressWarnings(as.numeric(clamping_vector)))
    stop(cli::format_error(c(
      "x" = "Error: {.var clamping_vector} must contain only numeric values.",
      "+++++ Invalid element(s): {clamping_vector[invalid_indexes]}"
    )))
  }

  if (any(clamping_vector != 0) & !all(initial_state_vector == 1)) {
    stop(cli::format_error(c(
      "x" = "Error: If any nodes are clamped (i.e. {.var clamping_vector} contains non-zero elements),
      all elements in {.var initial_state_vector} must be seet to 1 to perform the analysis correctly; i.e. initial_state_vector = c(1, 1, ..., 1)"
    )))
  }
  # ----

  # Check point_of_inference ----
  if (identical(point_of_inference, c("peak", "final"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var point_of_inference} given",
      "~~~~~ Assuming point_of_inference = 'final'"
    )))
    point_of_inference <- "final"
  }
  if (!(point_of_inference %in% c("peak", "final"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var point_of_inference} must be one of the following: 'peak' or 'final'",
      "+++++ Input {.var point_of_inference} was '{point_of_inference}'"
    )))
  }
  if (point_of_inference == "peak" & all(initial_state_vector == 1)) {
    warning(cli::format_warning(c(
      "!" = "Warning: Simulation inferences will return all 1's if {.var point_of_difference} = 'peak' and all concept activation levels start at 1; i.e. initial_state_vector = c(1, 1, ..., 1) "
    )))
  }
  # ----

  # Check activation and squashing ----
  if (identical(activation, c("kosko", "modified-kosko", "rescale"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var activation_function} given",
      "~~~~~ Assuming activation = 'kosko'"
    )))
    activation <- "kosko"
  }
  if (!(activation %in% c("kosko", "modified-kosko", "rescale"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var activation} must be one of the following: 'kosko', 'modified-kosko', or 'rescale'",
      "+++++ Input {.var activation} was '{activation}'"
    )))
  }

  if (identical(squashing, c("sigmoid", "tanh"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var squashing_function} given",
      "~~~~~ Assuming squashing = 'sigmoid'"
    )))
    squashing <- "sigmoid"
  }
  if (!(squashing %in% c("sigmoid", "tanh"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var squashing} must be one of the following: 'sigmoid', 'tanh'",
      "+++++ Input {.var squashing} was '{squashing}'"
    )))
  }
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
  # ----

  # Check lambda ----
  if (!is.numeric(lambda)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var lambda} must be numeric",
      "+++++ Input {.var lambda} was {lambda}"
    )))
  }
  if (lambda <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {.var lambda} must be greater than 0",
      "+++++ Input {.var lambda} was {lambda}"
    )))
  }
  if (lambda > 10) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var lambda} is typically less than 10 and greater than 0, with 1 being the typical value",
      "~~~~~ Input {.var lambda} was {lambda}"
    )))
  }
  # ----


  # Check max_iter ----
  if (!is.numeric(max_iter)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var max_iter} must be a positive integer",
      "+++++ Input {.var max_iter} was {max_iter}"
    )))
  }
  if (!(max_iter == round(max_iter))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var max_iter} must be a positive integer",
      "+++++ Input {.var max_iter} was {max_iter}"
    )))
  }
  if (max_iter <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {.var max_iter} must be a positive integer",
      "+++++ Input {.var max_iter} was {max_iter}"
    )))
  }
  # ----

  # Check min_error ----
  if (!is.numeric(min_error)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var min_error} must be a positive number",
      "+++++ Input {.var min_error} was {min_error}"
    )))
  }
  if (min_error <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {.var min_error} must be a positive number",
      "+++++ Input {.var min_error} was {min_error}"
    )))
  }
  if (min_error >= 1) {
    warning(cli::format_warning(c(
      "!" = "Warning: {.var point_of_inference} value of {point_of_inference} may be too high.",
      "~~~~~ Typically {.var min_error} < 0.001, but greater than 0"
    )))
  }
  # ----

  list(
    fcm_class = adj_matrix_input_type$fcm_class,
    adj_matrix = adj_matrix,
    initial_state_vector = initial_state_vector,
    clamping_vector = clamping_vector,
    activation = activation,
    squashing = squashing,
    point_of_inference = point_of_inference
  )
}


#' Print method for infer_conventional_fcm objects
#'
#' @param x an infer_conventional_fcm object
#' @param ... additional inputs
#'
#' @returns A console printout of infer_conventional_fcm results
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
#' @param x an infer_ivfn_or_tfn_fcm object
#' @param ... additional inputs
#'
#' @returns A console printout of infer_ivfn_or_tfn_fcm results
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
