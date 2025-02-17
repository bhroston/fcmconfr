
################################################################################
# utils-general.R
#
# These functions do not facilitate a specific analysis, but are rather genral
# tools used throughout the package.
#
#   - standardize_adj_matrices
#   - estimate_fcm_lambda
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
  # Confirm packages necessary packages are available. If not, change run options
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
  # Confirm packages necessary packages are available. If not, change run options
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
#'
#'  1. This function identifies whether the input is a list of adjacency matrices
#'     or is an individual adj matrix (input_type)
#'
#'  2. This function identifies the 'class' of the input adj. matrices from the
#'     following options: 'conventional' 'ivfn' 'tfn' or 'unavailable'
#'
#'      - 'conventional' means that the adj. matrices contain only numeric objects
#'
#'      - 'ivfn' means that the adj. matrices contain only 'ivfn' objects (interval-
#'        valued fuzzy number) NOTE: also returns the matrix class type (i.e.
#'        data.frame, tibble, etc.)
#'
#'      - 'tfn' means that the adj. matrices contain only 'tfn' objects (triangular
#'        fuzzy number)
#'
#'      - 'unavailable' means that the adj. matrices contain non-numeric data that
#'        are not of types 'ivfn' or 'tfn'
#'
#' @param adj_matrix_list_input A list of adj matrices or an individual adj matrix
#'
#' @returns a named list with two variables:
#'  adj_matrices_input_is_list: TRUE/FALSE Whether the input is a list of adj. matrices
#'  object_types_in_list: The 'class' of the input adj. matrices
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
get_adj_matrices_input_type <- function(adj_matrix_list_input) {
  classes_in_list_objects <- methods::is(list())
  classes_in_dataframe_objects <- methods::is(data.frame())
  classes_in_matrix_objects <- methods::is(matrix())
  classes_in_datatable_objects <- methods::is(data.table::data.table())
  classes_in_tibble_objects <- methods::is(tibble::tibble())
  classes_in_sparseMatrix_objects <- methods::is(Matrix::Matrix(data = 1:2, sparse = TRUE)) # add data = 1:2 to get accurate datatyps is methods::is

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

  if (identical(object_types_in_input_list, classes_in_dataframe_objects)) {
    object_types_in_input_list <- c("data.frame")
  } else if (identical(object_types_in_input_list, classes_in_matrix_objects)) {
    object_types_in_input_list <- c("matrix")
  } else if (identical(object_types_in_input_list, classes_in_datatable_objects)) {
    object_types_in_input_list <- c("data.table")
  } else if (identical(object_types_in_input_list, classes_in_tibble_objects)) {
    object_types_in_input_list <- c("tibble")
  } else if (identical(object_types_in_input_list, classes_in_sparseMatrix_objects)) {
    object_types_in_input_list <- c("sparseMatrix")
  }

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



#' Create an Adjacency Matrix from an Edgelist
#'
#'
#' @description
#' Creates an adjacency matrix from an edgelist
#'
#' @details
#' The input edgelist must have the following column names: 'source' or 'from',
#' 'target' or 'to'. The user must manually note if different names are used
#' for the edgelist. An additional column may be selected to describe a value
#' attributed to a given edge (default value column name is 'weight').
#'
#' The input edgelist can be either a matrix, data.frame, tibble, or
#' data.table type object.
#'
#' @param edgelist An edgelist representing an fcm. Default column names are
#' "source", "target", and "weight", but these may be defined explicitly.
#' @param source_colname Column name in the input eddgelist that represents
#' edge source nodes
#' @param target_colname Column name in the input edgelist that represents
#' edge target nodes
#' @param value_colname Column name in the input edgelist that represents represents
#' the values displayed in the adjacency matrix (i.e. weight, standard_deviation)
#' @param node_order The order in which concepts should be arranged in the output
#' adjacency matrix. If no input given, concepts will be arranged alphabetically.
#'
#' @returns An adjacency matrix (data.frame)
#'
#' @export
#' @example man/examples/ex-get_adj_matrix_from_edgelist.R
get_adj_matrix_from_edgelist <- function(edgelist = matrix(),
                                         source_colname = "source",
                                         target_colname = "target",
                                         value_colname = "weight",
                                         node_order = c()) {

  edgelist_column_inputs <- c(source_colname, target_colname, value_colname)
  edgelist_columns_match_inputs <- identical(colnames(edgelist), edgelist_column_inputs)

  if (!edgelist_columns_match_inputs) {
    stop("Edgelist column names do not match inputs source_colname, target_colname
         or value_colname. The default values for these are 'sourrce', 'target',
         and 'weight'. Check to make sure that these match the actual column
         names of the input edgelist.")
  }

  source_nodes <- edgelist[[source_colname]]
  target_nodes <- edgelist[[target_colname]]
  edge_values <- edgelist[[value_colname]]

  nodes <- unique(c(source_nodes, target_nodes))

  adj_matrix <- data.frame(matrix(data = 0, nrow = length(nodes), ncol = length(nodes)))
  colnames(adj_matrix) <- nodes
  rownames(adj_matrix) <- nodes

  for (i in seq_along(edge_values)) {
    edge <- edgelist[i, ]
    edge_row_loc <- which(nodes == edge[[source_colname]])
    edge_col_loc <- which(nodes == edge[[target_colname]])
    adj_matrix[edge_row_loc, edge_col_loc] <- edge_values[i]
  }

  node_order_given <- !identical(node_order, c())
  node_order_is_not_correct_length <- length(node_order) != length(nodes)
  node_order_input_is_not_type_character <- !identical(unique(typeof(node_order)), "character")
  if (!node_order_given) {
    adj_matrix <- adj_matrix
  } else if (node_order_given & (node_order_is_not_correct_length | node_order_input_is_not_type_character)) {
    stop("Input node_order must only contain character strings and must contain
         as many values as their are unique nodes depicted in the input edgelist.")
  } else {
    adj_matrix <- adj_matrix[node_order, node_order]
  }

  adj_matrix
}



#' Convert an Adjacency Matrix to an Edgelist
#'
#' @family utility
#'
#' @description
#' Converts an adjacency matrix into an edgelist
#'
#' @details
#' The input adjacency matrix must be a square n x n matrix. It can be either
#' a matrix, data.frame, tibble, or data.table type object.
#'
#' If the input matrix has named columns, those names will be used as concepts
#' in the edgelist. Otherwise, generic node IDs will be used (C1, C2, ... Cn)
#'
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#'
#' @returns An edgelist with the following columns: source, target, weight
#'
#' @importFrom data.table data.table
#'
#' @export
#' @example man/examples/ex-get_edgelist_from_adj_matrix.R
get_edgelist_from_adj_matrix <- function(adj_matrix = matrix()) {
  # Check adj matrix
  rows <- nrow(adj_matrix)
  cols <- ncol(adj_matrix)
  if (rows != cols) {
    stop("Failed Input Validation: Input adjacency matrix must be a square (n x n) matrix")
  }

  # Confirm adj_matrix has either Conventional, IVFN, or TFN data types
  get_adj_matrices_input_type(adj_matrix)$object_types_in_list[1]

  # #data_types_in_adj_matrix <- unique(do.call(c, (apply(adj_matrix, c(1, 2), function(x) list(methods::is(x[[1]]))))))
  # all_data_are_numeric <- all(apply(adj_matrix, c(1, 2), is.numeric))
  # if (!all_data_are_numeric) {
  #   stop("Failed Input Validation: Input adjacency matrix must contain objects of the same type. Either numerics, ivfns, or tfns.")
  # }

  empty_colnames <- identical(colnames(adj_matrix), NULL)
  if (empty_colnames) {
    IDs <- paste0("C", 1:nrow(adj_matrix))
    colnames(adj_matrix) <- IDs
  } else if (!empty_colnames) {
    IDs <- colnames(adj_matrix)
  }

  edge_locs <- data.table::data.table(which(adj_matrix != 0, arr.ind = TRUE))
  edge_weights <- mapply(function(row, col) adj_matrix[row, col], row = edge_locs$row, col = edge_locs$col)

  source_IDs <- IDs[edge_locs$row]
  target_IDs <- IDs[edge_locs$col]

  edgelist <- data.frame(
    source = source_IDs,
    target = target_IDs,
    weight = edge_weights
  )

  edgelist
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
#' @param adj_matrix An n x n adjacency matrix that represents an FCM
#'
#' @returns A vector of concept names
#'
#' @export
#' @example man/examples/ex-get_node_IDs_from_input.R
get_node_IDs_from_input <- function(adj_matrix = matrix()) {
  empty_colnames <- identical(colnames(adj_matrix), NULL)
  if (empty_colnames) {
    IDs <- paste0("C", 1:nrow(adj_matrix))
  } else if (!empty_colnames) {
    IDs <- colnames(adj_matrix)
  }

  IDs
}


