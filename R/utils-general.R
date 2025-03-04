
################################################################################
# utils-general.R
#
# These functions do not facilitate a specific analysis, but are rather genral
# tools used throughout the package.
#
#   Exported
#   - standardize_adj_matrices
#
#   Internal
#   - get_fcm_class_from_adj_matrix
#   - get_node_IDs_from_input
#
################################################################################


#' Standardize a List of Adjacency Matrices
#'
#' @family utils-general
#'
#' @description
#' Given a list of adj. matrices of different sizes, transforms the inputs into
#' adj. matrices of the same size with 0 values added where edges are undefined
#' or not included in maps.
#'
#' Solves the problem where Map 1 has nodes A and B but Map 2 has nodes B and C
#' and need to analyse them both together.
#'
#' @param adj_matrices  \[`list()`]\cr A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#'
#' @returns \[`list()`]\cr A list of adjacency matrices constructed from the
#' input adj. matrices, that contain the same concepts (and dimensions).
#' Rows/Columns of added concepts are all 0's.
#'
#' @export
#'
#' @examples  NULL # man/examples/ex-standardize_adj_matrices.R
standardize_adj_matrices <- function(adj_matrices = list()) {

  if (!is.null(dim(adj_matrices))) {
    adj_matrices <- list(adj_matrices)
  }
  # check_fcmconfr_input("adj_matrices", check = "adj_matrix_list", var_name = "adj_matrices")
  lapply(adj_matrices, function(x) check_fcmconfr_input(x, "square_adj_matrix", var_name = "adj_matrices"))

  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
  adj_matrices <- lapply(adj_matrices, function(x) assert_matrix(x, fcm_class, var_name_input = "adj_matrices"))

  nodes_by_adj_matrix <- lapply(adj_matrices, colnames)
  nodes_in_adj_matrices <- unique(unlist(nodes_by_adj_matrix))
  n_total_nodes <- length(nodes_in_adj_matrices)
  adj_matrices_already_standardized <- all(unlist(lapply(nodes_by_adj_matrix, function(nodes) all(nodes_in_adj_matrices %in% nodes))))
  if (adj_matrices_already_standardized) {
    return(adj_matrices)
  }

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
      for (row_index in seq_along(rownames(weight_locs_df))) {
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
      for (row_index in seq_along(rownames(weight_locs_df))) {
        standardized_adj_matrix[weight_locs_df$output_row[row_index], weight_locs_df$output_col[row_index]][[1]] <- weight_locs_df$weight[row_index]
      }
      standardized_adj_matrices[[i]] <- standardized_adj_matrix
    }
  }

  return(standardized_adj_matrices)
}


#' Get FCM Class from Individual Adjacency Matrix
#'
#' @family utils-general
#'
#' @description
#' Get the FCM class of an adjacency matrix. May be one of the following:
#' \itemize{
#'  \item{'conventional' if all elements are numeric}
#'  \item{'ivfn' if all elements are Interval-Value Fuzzy Numbers}
#'  \item{'tfn' if all elements are Triangular Fuzzy Numbers}
#' }
#'
#' @param adj_matrix  \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#'
#' @returns \[`character(1)`]\cr The fcm class. Either 'conventional',
#' 'ivfn', or 'tfn' (or will throw an error if none are identified)
#'
#' @keywords internal
#' @noRd
#'
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
#' @family utils-general
#'
#' @description
#' Get the column names of an adjacency matrix as the names of concepts. If no
#' column names are given, use generic column names (C1, C2, ..., Cn)
#'
#' Intended for developer use only to improve package readability.
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single adjacency matrix
#' (n x n) representing FCMs. An adjacency matrix can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#'
#' @returns \[`vector("character")`]\cr A vector of concept names
#'
#' @example man/examples/ex-get_node_IDs_from_input.R
#' @keywords internal
#' @noRd
get_node_IDs_from_input <- function(adj_matrix = data.frame()) {
  empty_colnames <- identical(colnames(adj_matrix), NULL)
  if (empty_colnames) {
    IDs <- paste0("C", 1:nrow(adj_matrix))
  } else if (!empty_colnames) {
    IDs <- colnames(adj_matrix)
  }

  IDs
}


