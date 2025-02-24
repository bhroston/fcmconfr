
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


#' Get FCM Class from Individual Adjacency Matrix
#'
#' @family utility
#'
#' @description
#' Get the FCM class of an adjacency matrix. May be one of the following:
#' \itemize{
#'  \item{'conventional' if all elements are numeric}
#'  \item{'ivfn' if all elements are Interval-Value Fuzzy Numbers}
#'  \item{'tfn' if all elements are Triangular Fuzzy Numbers}
#' }
#'
#' @param adj_matrix  A [data.frame]-like object of single adjacency matrix
#' (n x n) representing an FCMs. Matrices can have conventional edge weights,
#' IVFN edge weights or TFN edge weights
#'
#' @returns A [character] string of the fcm class. Either 'conventional',
#' 'ivfn', or 'tfn' (or will throw an error if none are identified)
#'
#' @keywords internal
#' @noRd
#'
#' @export
#' @example man/examples/ex-get_fcm_class_from_adj_matrix.R
get_fcm_class_from_adj_matrix <- function(adj_matrix = data.frame()) {
  check_fcmconfr_input(adj_matrix, check = "square_adj_matrix", var_name = "adj_matrix")

  element_types_in_adj_matrix <- unique(as.vector(as.matrix(apply(adj_matrix, c(1, 2), function(x) methods::is(x[[1]])))))

  if (identical(element_types_in_adj_matrix, methods::is(numeric()))) {
    fcm_class <- "conventional"
  } else if (identical(element_types_in_adj_matrix, "ivfn")) {
    fcm_class <- "ivfn"
  } else if (identical(element_types_in_adj_matrix, "tfn")) {
    fcm_class <- "tfn"
  } else {
    # if (shiny::isRunning()) {
    #   object_types_in_input_list <- "unavailable"
    # } else {
    #   stop(cli::format_error(c(
    #     "x" = "Error: {.var adj_matrix} must be an adjacency matrix with edges represented as either numeric values, ivfns, or tfns"
    #   )))
    # }
    stop(cli::format_error(c(
      "x" = "Error: Unrecognized element types in input {.var adj_matrix}",
      "+++++> Adjacency matrix elements must be either numeric, ivfn, or tfn, and all matrices must have elements of the same type.",
      "+++++> Input {.var adj_matrix} had elements of type: {element_types_in_adj_matrix[1]}"
    )))
  }

  return(fcm_class)
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


