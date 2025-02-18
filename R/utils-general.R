
################################################################################
# utils-general.R
#
# These functions do not facilitate a specific analysis, but are rather genral
# tools used throughout the package.
#
#   - standardize_adj_matrices
#   - check_if_local_machine_has_access_to_parallel_processing_functionalities
#   - check_if_local_machine_has_access_to_show_progress_functionalities
#   - get_adj_matrices_input_type
#   - get_adj_matrix_from_edgelist
#   - get_edgelist_from_adj_matrix
#   - get_node_IDs_from_input
#
################################################################################


#' Standardize a List of Adjacency Matrices
#'
#' @family utility
#'
#' @description
#' Given a list of adj. matrices of different sizes, transforms the inputs into
#' adj. matrices of the same size with 0 values added where edges are undefined
#' or not included in maps.
#'
#' Solves the problem where Map 1 has nodes A and B but Map 2 has nodes B and C
#' and need to analyse them both together.
#'
#' @param adj_matrices A list of adj. matrix objects
#'
#' @returns A list of adj. matrices constructed from the input adj. matrices,
#' that contain the same concepts (and dimensions). Rows/Columns of added
#' concepts are all 0's.
#'
#' @export
#' @example man/examples/ex-standardize_adj_matrices.R
standardize_adj_matrices <- function(adj_matrices = list(matrix())) {
  adj_matrices_dims <- lapply(adj_matrices, function(x) unique(dim(x)))
  all_adj_matrices_are_square <- all(unlist(lapply(adj_matrices_dims, function(x) length(x) == 1)))
  if (!all_adj_matrices_are_square) {
    stop("Failed in standardize_size_of_adj_matrices
       All matrices must be square (n x n)")
  }

  nodes_by_adj_matrix <- lapply(adj_matrices, colnames)
  nodes_in_adj_matrices <- unique(unlist(nodes_by_adj_matrix))
  n_total_nodes <- length(nodes_in_adj_matrices)
  adj_matrices_already_standardized <- all(unlist(lapply(nodes_by_adj_matrix, function(nodes) all(nodes_in_adj_matrices %in% nodes))))
  if (adj_matrices_already_standardized) {
    return(adj_matrices)
  }

  adj_matrices_input_type <- get_adj_matrices_input_type(adj_matrices)
  fcm_class <- adj_matrices_input_type$object_types_in_list[1]


  standardized_adj_matrices <- vector(mode = "list", length = length(adj_matrices))

  if (fcm_class == "conventional") {
    for (i in seq_along(standardized_adj_matrices)) {
      standardized_adj_matrix <- data.frame(matrix(data = 0, nrow = n_total_nodes, ncol = n_total_nodes))
      colnames(standardized_adj_matrix) <- nodes_in_adj_matrices
      standardized_weight_locs <- which(nodes_in_adj_matrices %in% nodes_by_adj_matrix[[i]])
      n_nodes_in_input_matrix <- length(nodes_by_adj_matrix[[i]])
      weight_locs_df <- cbind(expand.grid(c(1:n_nodes_in_input_matrix), c(1:n_nodes_in_input_matrix)), expand.grid(standardized_weight_locs, standardized_weight_locs))
      colnames(weight_locs_df) <- c("input_row", "input_col", "output_row", "output_col")
      weight_locs_df$weight <- apply(weight_locs_df, 1, function(row_vec) adj_matrices[[i]][row_vec[1], row_vec[2]])
      for (row_index in 1:nrow(weight_locs_df)) {
        standardized_adj_matrix[weight_locs_df$output_row[row_index], weight_locs_df$output_col[row_index]] <- weight_locs_df$weight[row_index]
      }
      standardized_adj_matrices[[i]] <- standardized_adj_matrix
    }
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    if (fcm_class == "ivfn") {
      empty_standardized_adj_matrix <- data.frame(matrix(data = list(ivfn(0, 0)), nrow = n_total_nodes, ncol = n_total_nodes))
    } else if (fcm_class == "tfn") {
      empty_standardized_adj_matrix <- data.frame(matrix(data = list(tfn(0, 0, 0)), nrow = n_total_nodes, ncol = n_total_nodes))
    }
    for (i in seq_along(standardized_adj_matrices)) {
      standardized_adj_matrix <- empty_standardized_adj_matrix
      colnames(standardized_adj_matrix) <- nodes_in_adj_matrices
      standardized_weight_locs <- which(nodes_in_adj_matrices %in% nodes_by_adj_matrix[[i]])
      n_nodes_in_input_matrix <- length(nodes_by_adj_matrix[[i]])
      weight_locs_df <- cbind(expand.grid(c(1:n_nodes_in_input_matrix), c(1:n_nodes_in_input_matrix)), expand.grid(standardized_weight_locs, standardized_weight_locs))
      colnames(weight_locs_df) <- c("input_row", "input_col", "output_row", "output_col")
      weight_locs_df$weight <- apply(weight_locs_df, 1, function(row_vec) adj_matrices[[i]][row_vec[1], row_vec[2]][[1]])
      for (row_index in 1:nrow(weight_locs_df)) {
        standardized_adj_matrix[weight_locs_df$output_row[row_index], weight_locs_df$output_col[row_index]][[1]] <- weight_locs_df$weight[row_index]
      }
      standardized_adj_matrices[[i]] <- standardized_adj_matrix
    }
  }

  standardized_adj_matrices
}



#' Check if the local machine can access internal parallel processing functionalities
#'
#' @family utility
#'
#' @description
#' Check whether the local machine has access to the necessary packages to
#' run code in parallel and/or using a progress bar. Specifically, checks for
#' the parallel, doSNOW, foreach, and pbapply packages.
#'
#' @details
#' Confirms that a local machine can access the required packages for parallel
#' processing and/or displaying progress bars at runtime. Will revise inputs
#' if particular packages are unavailable and warn the user of such changes, but will
#' not halt a run.
#'
#' @param use_parallel TRUE/FALSE The user intends to use parallel processing
#' @param use_show_progress TRUE/FALSE The user intends to display progress bars
#'
#' @returns TRUE/FALSE Whether the machine has access to the dependencies to
#' access internal parallel processing functionalities
#'
#' @export
#' @example man/examples/ex-check_if_local_machine_has_access_to_parallel_processing_functionalities.R
check_if_local_machine_has_access_to_parallel_processing_functionalities <- function(use_parallel, use_show_progress) {

  if (!is.logical(use_parallel) | length(use_parallel) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var use_parallel} must be logical (TRUE/FALSE)",
      "+++++> Input {.var use_parallel} was: {use_parallel}"
    )))
  }

  if (!is.logical(use_show_progress) | length(use_show_progress) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var use_show_progress} must be logical (TRUE/FALSE)",
      "+++++> Input {.var use_show_progress} was: {use_show_progress}"
    )))
  }

  parallel_check <- use_parallel
  show_progress_check <- use_show_progress

  if (use_parallel) {
    if (use_show_progress) {
      local_machine_has_access_to_doSNOW <- requireNamespace("doSNOW")
      local_machine_has_access_to_foreach <- requireNamespace("foreach")
      if (!local_machine_has_access_to_doSNOW | !local_machine_has_access_to_foreach) {
        parallel_check <- FALSE
        warning("\tShowing progress with parallel processing requires the 'doSNOW' and 'foreach' packages which are
        currently not installed. Running in parallel but without showing progress.")
      }
    } else {
      local_machine_has_access_to_parallel <- requireNamespace("parallel")
      if (!local_machine_has_access_to_parallel) {
        parallel_check <- FALSE
        warning("\tParallel processing requires the 'parallel' package which is
        currently not installed. Running without parallel processing.")
      }
    }
  }
  parallel_check
}



#' Check if the local machine can access internal 'show_progress' functionalities
#'
#' @family utility
#'
#' @description
#' Check whether the local machine has access to the necessary packages to
#' run code in parallel and/or using a progress bar. Specifically, checks for
#' the doSNOW, foreach, and pbapply packages.
#'
#' @details
#' Confirms that a local machine can access the required packages for
#' displaying progress bars at runtime. Will revise inputs
#' if particular packages are unavailable and warn the user of such changes, but will
#' not halt a run.
#'
#' @param use_parallel TRUE/FALSE The user intends to use parallel processing
#' @param use_show_progress TRUE/FALSE The user intends to display progress bars
#'
#' @returns TRUE/FALSE Whether the machine has access to the dependencies to
#' access internal 'show_progress' functionalities
#'
#' @export
#' @example man/examples/ex-check_if_local_machine_has_access_to_show_progress_functionalities.R
check_if_local_machine_has_access_to_show_progress_functionalities <- function(use_parallel, use_show_progress) {

  if (!is.logical(use_parallel) | length(use_parallel) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var use_parallel} must be logical (TRUE/FALSE)",
      "+++++> Input {.var use_parallel} was: {use_parallel}"
    )))
  }

  if (!is.logical(use_show_progress) | length(use_show_progress) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var use_show_progress} must be logical (TRUE/FALSE)",
      "+++++> Input {.var use_show_progress} was: {use_show_progress}"
    )))
  }

  parallel_check <- use_parallel
  show_progress_check <- use_show_progress

  if (use_show_progress) {
    if (use_parallel) {
      local_machine_has_access_to_doSNOW <- requireNamespace("doSNOW")
      local_machine_has_access_to_foreach <- requireNamespace("foreach")
      if (!local_machine_has_access_to_doSNOW | !local_machine_has_access_to_foreach) {
        show_progress_check <- FALSE
        warning("\tShowing progress with parallel processing requires the 'doSNOW' and 'foreach' packages which are
        currently not installed. Running in parallel but without showing progress.")
      }
    } else {
      local_machine_has_access_to_pbapply <- requireNamespace("pbapply")
      if (!local_machine_has_access_to_pbapply) {
        show_progress_check <- FALSE
        warning("\tShowing progress requires the 'pbapply' package which is
        currently not installed. Running without showing progress.")
      }
    }
  }

  show_progress_check
}



#' Get the data types of adjacency matrices in a list
#'
#' @family utility
#'
#' @description
#' This function performs two actions:
#' \enumerate{
#'    \item This function identifies whether the input is a list of adjacency
#'    matrices or is an individual adj matrix (input_type)
#'    \item This function identifies the 'class' of the input adj. matrices from
#'    the following options: 'conventional' 'ivfn' 'tfn' or 'unavailable'
#'    \itemize{
#'        \item 'conventional' means that the adj. matrices contain only
#'        numeric objects
#'        \item 'ivfn' means that the adj. matrices contain only 'ivfn' objects
#'        (interval-valued fuzzy number) NOTE: also returns the matrix class
#'        type (i.e. data.frame, tibble, etc.)
#'        \item 'tfn' means that the adj. matrices contain only 'tfn' objects
#'        (triangular fuzzy number)
#'        \item 'unavailable' means that the adj. matrices contain non-numeric
#'        data that are not of types 'ivfn' or 'tfn'
#'    }
#' }
#'
#' @param adj_matrix_list_input A [list] of adj matrices or an
#' individual adj matrix [data.frame]. Converts an individual adj.
#' matrix to a list if not already.
#'
#' @returns a named list with two variables:
#' \itemize{
#'    \item adj_matrices_input_is_list: TRUE/FALSE Whether the input is a list
#'    of adj. matrices
#'    \item object_types_in_list: The 'class' of the input adj. matrices
#' }
#'
#' @importFrom methods is
#' @importFrom data.table data.table
#' @importFrom tibble tibble
#' @importFrom Matrix Matrix
#' @importFrom shiny isRunning
#' @importFrom cli format_error
#'
#' @export
#' @example man/examples/ex-get_adj_matrices_input_type.R
get_adj_matrices_input_type <- function(adj_matrix_list_input = list()) {
  classes_in_list_objects <- methods::is(list())
  # classes_in_dataframe_objects <- methods::is(data.frame())
  # classes_in_matrix_objects <- methods::is(matrix())
  # classes_in_datatable_objects <- methods::is(data.table::data.table())
  # classes_in_tibble_objects <- methods::is(tibble::tibble())
  # classes_in_sparseMatrix_objects <- methods::is(Matrix::Matrix(data = 1:2, sparse = TRUE)) # add data = 1:2 to get accurate datatyps is methods::is

  classes_in_adj_matrix_list_input <- methods::is(adj_matrix_list_input)
  if (identical(classes_in_adj_matrix_list_input, classes_in_list_objects)) {
    adj_matrices_input_is_list <- TRUE
  } else {
    adj_matrices_input_is_list <- FALSE
  }

  if (adj_matrices_input_is_list) {
    num_object_types_in_input_list <- length(unique(lapply(adj_matrix_list_input, methods::is)))
    if (shiny::isRunning() & num_object_types_in_input_list != 1) {
      object_types_in_input_list = "unavailable"
    } else if (!shiny::isRunning() & num_object_types_in_input_list != 1) {
      stop(cli::format_error(c(
        "x" = "Error: All objects in {.var adj_matrix_list} must be of the same type."
      )))
    }
    object_types_in_input_list <- unique(lapply(adj_matrix_list_input, methods::is))[[1]]
  } else {
    object_types_in_input_list <- methods::is(adj_matrix_list_input)
    adj_matrix_list_input <- list(adj_matrix_list_input)
  }

  # if (identical(object_types_in_input_list, classes_in_dataframe_objects)) {
  #   object_types_in_input_list <- c("data.frame")
  # } else if (identical(object_types_in_input_list, classes_in_matrix_objects)) {
  #   object_types_in_input_list <- c("matrix")
  # } else if (identical(object_types_in_input_list, classes_in_datatable_objects)) {
  #   object_types_in_input_list <- c("data.table")
  # } else if (identical(object_types_in_input_list, classes_in_tibble_objects)) {
  #   object_types_in_input_list <- c("tibble")
  # } else if (identical(object_types_in_input_list, classes_in_sparseMatrix_objects)) {
  #   object_types_in_input_list <- c("sparseMatrix")
  # }

  element_types_in_objects_in_input_list <- unique(
    lapply(adj_matrix_list_input,
           function(adj_matrix) {
             unique(as.vector(as.matrix(apply(adj_matrix, c(1, 2), function(x) methods::is(x[[1]])))))
           })
  )[[1]]

  if (identical(element_types_in_objects_in_input_list, methods::is(numeric()))) {
    fcm_class <- "conventional"
    object_types_in_input_list <- c("conventional", object_types_in_input_list)
  } else if (identical(element_types_in_objects_in_input_list, "ivfn")) {
    fcm_class <- "ivfn"
    object_types_in_input_list <- "ivfn"
  } else if (identical(element_types_in_objects_in_input_list, "tfn")) {
    fcm_class <- "tfn"
    object_types_in_input_list <- "tfn"
  } else {
    if (shiny::isRunning()) {
      object_types_in_input_list <- "unavailable"
    } else {
      stop(cli::format_error(c(
        "x" = "Error: {.var adj_matrix} must be an adjacency matrix with edges represented as either numeric values, ivfns, or tfns"
      )))
    }
    stop(cli::format_error(c(
      "x" = "Error: Unrecognized element types in input matrices.",
      "+++++> Adjacency matrix elements must be either numeric, ivfn, or tfn, and all matrices must have elements of the same type."
    )))
  }

  list(
    fcm_class = fcm_class,
    adj_matrices_input_is_list = adj_matrices_input_is_list,
    object_types_in_list = object_types_in_input_list
  )
}



#' Get Node IDs (Concepts) from Adj. Matrix
#'
#' @family utility
#'
#' @description
#' Get the column names of an adjacency matrix as the names of concepts. If no
#' column names are given, use generic column names (C1, C2, ..., Cn)
#'
#' Intended for developer use only to improve package readability.
#'
#' @param adj_matrix An [data.frame] n x n adjacency matrix that represents
#' an FCM
#'
#' @returns A vector of concept names
#'
#' @export
#' @example man/examples/ex-get_node_IDs_from_input.R
get_node_IDs_from_input <- function(adj_matrix = data.frame()) {
  empty_colnames <- identical(colnames(adj_matrix), NULL)
  if (empty_colnames) {
    IDs <- paste0("C", 1:nrow(adj_matrix))
  } else if (!empty_colnames) {
    IDs <- colnames(adj_matrix)
  }

  IDs
}


