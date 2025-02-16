
################################################################################
# aggregate_fcms.R
#
# These functions are involved with FCM aggregation (conventional, ivfn, and tfn)
#
#   - aggregate_fcms
#   - aggregate_conventional_fcms
#   - aggregate_fcms_w_ivfns
#   - aggregate_fcms_w_tfns
#   - print.aggregate
#
################################################################################


#' Aggregate FCMs
#'
#' @family aggregate_fcms
#'
#' @description
#' Generate an aggregate adj. matrix from a list of adj. matrices. FCM
#' aggregation works by calculating the mean/median edge weight for all edges
#' across the input adj. matrices (i.e. the mean/median of the edge weight
#' connecting A -> B across all maps, the mean/median of the edge weight
#' connecting B -> C across all maps, and so on). The user may dictate whether
#' to incorporate 0-valued edge weights in the mean/median calculations.
#'
#' All input adj. matrices must have the same dimensions and concept names to
#' generate an aggregate. Call \code{\link{standardize_adj_matrices}} to make
#' sure all adj. matrices have the same dimensions.
#'
#' @details
#' This function implements FCM aggregation methods used in
#' Aminpout 2020 (https://doi.org/10.1038/s41893-019-0467-z) for use with
#' conventional FCMs, and expands upon them for IVFN- and TFN-FCMs.
#'
#' \strong{Conventional FCMs}
#'
#' The mean aggregate FCM of a set of conventional FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\frac{\sum _{p\ =\ 1}^{N} A_{ij}^{FCM_{p}}}{N}
#' }
#' where \eqn{A_{ij}^{aggregate}} is the weight in the aggregate adjacency
#' matrix for the element in row i and column j, and \eqn{FCM_{p}} is the
#' weight for the element in row i and column j in the adjacency matrix of
#' the p-th FCM.
#'
#' If not including zeroe-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\frac{\sum _{p\ =\ 1}^{N} A_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|A_{ij}^{FCM_{p}} \neq 0}
#' }
#'
#' The median aggregate FCM of a set of conventional FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\mathrm{Median} (A_{ij}^{FCM_{1}} ,A_{ij}^{FCM_{2}} ,...,A_{ij}^{FCM_{N}} )\
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\mathrm{Median} (A_{ij}^{FCM_{1}} ,A_{ij}^{FCM_{2}} ,...,A_{ij}^{FCM_{N}} )\ |\ A_{ij}^{FCM_{p}} \neq 0
#' }
#'
#' \strong{IVFN-FCMs}
#'
#' The mean aggregate FCM of a set of IVFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{N} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{N}\right]
#' }
#' where \eqn{\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}}} is the IVFN
#' weight (with lower bound \eqn{A^{L}} and upper bound \eqn{A^{U}}) of the
#' element in row i and column j of the aggregate, and
#' \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}} and \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}}
#' are the lower and upper bounds of the IVFN weight of the element in row i and
#' column j for the p-th FCM adjacency matrix.
#'
#' If not including zeroe-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{L}\right]_{ij}^{FCM_{p}} \neq 0} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{U}\right]_{ij}^{FCM_{p}} \neq 0}\right]
#' }
#'
#' The median aggregate FCM of a set of IVFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ \mathrm{Median}\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) , \mathrm{Median}\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right)\right]
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\
#' [ \mathrm{Median}\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -U} \neq 0,\\
#'   \ \mathrm{Median}\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -U} \neq 0]
#' }
#'
#' \strong{TFN-FCMs}
#'
#' The mean aggregate FCM of a set of TFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{M} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{N} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{M}\right]_{ij}^{FCM_{p}}}{N} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{N}\right]
#' }
#'
#' where \eqn{\left[ A^{L} , A^{M}, A^{U} \ \right]_{ij}^{FCM_{aggregate}}} is the TFN
#' weight (with lower bound \eqn{A^{L}}, mode \eqn{A^{M}}, and upper bound \eqn{A^{U}}) of the
#' element in row i and column j of the aggregate, and
#' \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}}, \eqn{\left[ A^{M}\right]_{ij}^{FCM_{p}}}, and
#' \eqn{\left[ A^{U}\right]_{ij}^{FCM_{p}}} are the lower bound, mode, and upper
#' bound of the TFN weight of the element in row i and column j for the p-th
#' FCM adjacency matrix.
#'
#' If not including zero-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{M} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{L}\right]_{ij}^{FCM_{p}} \neq 0} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{M}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{M}\right]_{ij}^{FCM_{p}} \neq 0} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{U}\right]_{ij}^{FCM_{p}} \neq 0}\right]
#' }
#'
#' The median aggregate FCM of a set of TFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =[ Median\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) ,\ \ \\
#' Median\left( A_{ij}^{FCM_{1} -M} ,A_{ij}^{FCM_{2} -M} ,...,A_{ij}^{FCM_{N} -M}\right) ,\ \\
#' Median\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right)]
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\ \newline
#' [ Median\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0,\ \newline
#'   [ Median\left( A_{ij}^{FCM_{1} -M} ,A_{ij}^{FCM_{2} -M} ,...,A_{ij}^{FCM_{N} -M}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0,\ \newline
#'     \ Median\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0]
#' }
#'
#' @param adj_matrices A list of adj. matrix objects; these can represent
#' conventional FCM, IVFN FCM, and TFN FCM, but all adj. matrices must be of
#' the same type between the three options.
#' @param agg_function Calculate aggregate edge weights as either the
#' "mean" or "median" of the input edge weights across inputs
#' @param include_zeroes_in_sampling TRUE/FALSE Whether to include zeroes in the mean/median
#' calculations. (i.e. if edges not included in a map should count as a zero-weighted
#' edge or not at all)
#'
#' @references \insertRef{aminpourWisdomStakeholderCrowds2020}{fcmconfr}
#'
#' @returns An aggregate adj. matrix (of class 'aggregate') with edges represented
#' as the same data types as the inputs (i.e. Numerics for conventional, IVFNs, or TFNs)
#'
#' @importFrom Rdpack reprompt
#'
#' @export
#' @example  man/examples/ex-aggregate_fcms.R
aggregate_fcms <- function(adj_matrices = list(matrix()),
                           agg_function = c("mean", "median"),
                           include_zeroes_in_sampling = FALSE) {

  adj_matrices_input_type <- get_adj_matrices_input_type(adj_matrices)
  if (!adj_matrices_input_type$adj_matrices_input_is_list) {
    adj_matrices <- list(adj_matrices)
  }

  dimensions_of_input_adj_matrices <- lapply(adj_matrices, dim)
  all_adj_matrices_have_same_dimensions <- length(unique(dimensions_of_input_adj_matrices)) == 1
  if (!all_adj_matrices_have_same_dimensions) {
    stop("All input adjacency matrices must have the same dimensions (n x n) throughout the entire list")
  }

  concepts_in_adj_matrices <- lapply(adj_matrices, function(x) get_node_IDs_from_input(x))
  node_names <- unlist(unique(concepts_in_adj_matrices))

  all_adj_matrices_have_same_concepts <- length(unique(concepts_in_adj_matrices)) == 1
  if (!all_adj_matrices_have_same_concepts) {
    stop("All input adjacency matrices must have the same concepts.")
  }

  fcm_class <- adj_matrices_input_type$object_types_in_list[1]
  if (fcm_class == "conventional") {
    aggregate_adj_matrix <- aggregate_conventional_fcms(adj_matrices, agg_function, include_zeroes_in_sampling)
  } else if (fcm_class == "ivfn") {
    aggregate_adj_matrix <- aggregate_fcms_w_ivfns(adj_matrices, agg_function, include_zeroes_in_sampling)
  } else if (fcm_class == "tfn") {
    aggregate_adj_matrix <- aggregate_fcms_w_tfns(adj_matrices, agg_function, include_zeroes_in_sampling)
  }

  class(aggregate_adj_matrix) <- "aggregate"

  aggregate_adj_matrix
}




#' Aggregate (Conventional) FCMs
#'
#' @family aggregate_fcms
#'
#' @description
#' Generate an aggregate adj. matrix from a list of (Conventional) adj. matrices.
#' FCM aggregation works by calculating the mean/median edge weight for all edges
#' across the input adj. matrices (i.e. the mean/median of the edge weight
#' connecting A -> B across all maps, the mean/median of the edge weight
#' connecting B -> C across all maps, and so on). The user may dictate whether
#' to incorporate 0-valued edge weights in the mean/median calculations.
#'
#' All input adj. matrices must have the same dimensions and concept names to
#' generate an aggregate. Call \code{\link{standardize_adj_matrices}} to make
#' sure all adj. matrices have the same dimensions.
#'
#' @details
#' #' This function implements FCM aggregation methods used in
#' Aminpour 2020 (https://doi.org/10.1038/s41893-019-0467-z)
#'
#' The mean aggregate FCM of a set of conventional FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\frac{\sum _{p\ =\ 1}^{N} A_{ij}^{FCM_{p}}}{N}
#' }
#' where \eqn{A_{ij}^{aggregate}} is the weight in the aggregate adjacency
#' matrix for the element in row i and column j, and \eqn{FCM_{p}} is the
#' weight for the element in row i and column j in the adjacency matrix of
#' the p-th FCM.
#'
#' If not including zeroe-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\frac{\sum _{p\ =\ 1}^{N} A_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|A_{ij}^{FCM_{p}} \neq 0}
#' }
#'
#' The median aggregate FCM of a set of conventional FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\mathrm{Median} (A_{ij}^{FCM_{1}} ,A_{ij}^{FCM_{2}} ,...,A_{ij}^{FCM_{N}} )\
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\mathrm{Median} (A_{ij}^{FCM_{1}} ,A_{ij}^{FCM_{2}} ,...,A_{ij}^{FCM_{N}} )\ |\ A_{ij}^{FCM_{p}} \neq 0
#' }
#'
#' @param adj_matrices A list of Conventional FCM adj. matrix objects
#' @param agg_function Calculate aggregate edge weights as either the
#' "mean" or "median" of the input edge weights across inputs
#' @param include_zeroes_in_sampling TRUE/FALSE Whether to include zeroes in the mean/median
#' calculations. (i.e. if edges not included in a map should count as a zero-weighted
#' edge or not at all)
#' @param false_zero_locs_by_adj_matrix !FOR DEVELOPER USE ONLY! A list of array
#' indexes for IVFN and TFN matrices that contain false-zero edges (False-zero
#' edges are those that contain zero as a lower bound for IVFNs and/or mode for
#' TFNs but a non-zero value for the upper bound)
#'
#' @returns An aggregate adj. matrix (of class 'aggregate') with edges represented
#' as numeric data types
#'
#' @importFrom stats median
#'
#' @keywords internal
#'
#' @export
#' @example man/examples/ex-aggregate_conventional_fcms.R
aggregate_conventional_fcms <- function(adj_matrices = list(matrix()),
                                        agg_function = c("mean", "median"),
                                        include_zeroes_in_sampling = TRUE,
                                        false_zero_locs_by_adj_matrix = list()) {

  concepts_in_adj_matrices <- lapply(adj_matrices, function(x) get_node_IDs_from_input(x))
  node_names <- unlist(unique(concepts_in_adj_matrices))
  n_nodes <- length(node_names)
  n_maps <- length(adj_matrices)

  if (!include_zeroes_in_sampling & identical(false_zero_locs_by_adj_matrix, list())) {
    adj_matrices <- lapply(adj_matrices, function(x) replace(x, x == 0, NA))
  } else if (!include_zeroes_in_sampling & !identical(false_zero_locs_by_adj_matrix, list())) {
    adj_matrices <- lapply(adj_matrices, function(x) replace(x, x == 0, NA))
    adj_matrices <- mapply(
      function(adj_matrix, false_zero_locs) {
        adj_matrix[false_zero_locs] <- 0
        adj_matrix
      },
      adj_matrix = adj_matrices,
      false_zero_locs = false_zero_locs_by_adj_matrix,
      SIMPLIFY = FALSE
    )
  }

  if (agg_function == "mean") {
    aggregate_adj_matrix <- apply(
      array(unlist(adj_matrices), c(n_nodes, n_nodes, n_maps)), 1:2,
      function(x) {
        mean(x, na.rm = TRUE)
      }
    )
  } else if (agg_function == "median") {
    aggregate_adj_matrix <- apply(
      array(unlist(adj_matrices), c(n_nodes, n_nodes, n_maps)), 1:2,
      function(x) stats::median(x, na.rm = TRUE)
    )
  }

  aggregate_adj_matrix[is.na(aggregate_adj_matrix)] <- 0
  adj_matrices <- lapply(adj_matrices, function(x) replace(x, is.na(x), 0))

  colnames(aggregate_adj_matrix) <- node_names
  rownames(aggregate_adj_matrix) <- node_names

  structure(
    .Data = list(
      adj_matrix = as.data.frame(aggregate_adj_matrix),
      params = list(
        input_adj_matrices = adj_matrices,
        aggregation_fun = agg_function,
        IDs = node_names
      )
    ),
    class = "aggregate_of_conventional_fcms"
  )
}


#' Aggregate (IVFN) FCMs
#'
#' @family aggregate_fcms
#'
#' @description
#' Generate an aggregate adj. matrix from a list of (IVFN) adj. matrices.
#' FCM aggregation works by calculating the mean/median edge weight for all edges
#' across the input adj. matrices (i.e. the mean/median of the edge weight
#' connecting A -> B across all maps, the mean/median of the edge weight
#' connecting B -> C across all maps, and so on). The user may dictate whether
#' to incorporate 0-valued edge weights in the mean/median calculations.
#'
#' All input adj. matrices must have the same dimensions and concept names to
#' generate an aggregate. Call \code{\link{standardize_adj_matrices}} to make
#' sure all adj. matrices have the same dimensions.
#'
#' @details
#' #' This function implements FCM aggregation methods used in
#' Aminpout 2020 (https://doi.org/10.1038/s41893-019-0467-z) for use with
#' conventional FCMs, and expands upon them for IVFN-FCMs.
#'
#' The mean aggregate FCM of a set of IVFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{N} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{N}\right]
#' }
#' where \eqn{\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}}} is the IVFN
#' weight (with lower bound \eqn{A^{L}} and upper bound \eqn{A^{U}}) of the
#' element in row i and column j of the aggregate, and
#' \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}} and \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}}
#' are the lower and upper bounds of the IVFN weight of the element in row i and
#' column j for the p-th FCM adjacency matrix.
#'
#' If not including zeroe-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{L}\right]_{ij}^{FCM_{p}} \neq 0} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{U}\right]_{ij}^{FCM_{p}} \neq 0}\right]
#' }
#'
#' The median aggregate FCM of a set of IVFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ \mathrm{Median}\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) , \mathrm{Median}\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right)\right]
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\
#' [ \mathrm{Median}\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -U} \neq 0,\\
#'   \ \mathrm{Median}\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -U} \neq 0]
#' }
#'
#' @param adj_matrices A list of IVFN FCM adj. matrix objects
#' @param agg_function Calculate aggregate edge weights as either the
#' "mean" or "median" of the input edge weights across inputs
#' @param include_zeroes_in_sampling TRUE/FALSE Whether to include zeroes in the mean/median
#' calculations. (i.e. if edges not included in a map should count as a zero-weighted
#' edge or not at all)
#'
#' @returns An aggregate adj. matrix (of class 'aggregate') with edges represented
#' as IVFN data types
#'
#' @keywords internal
#'
#' @export
#' @example  man/examples/ex-aggregate_fcms_w_ivfns.R
aggregate_fcms_w_ivfns <- function(adj_matrices = list(matrix()),
                                   agg_function = c("mean", "median"),
                                   include_zeroes_in_sampling = TRUE) {

  concepts_in_adj_matrices <- lapply(adj_matrices, function(x) get_node_IDs_from_input(x))
  node_names <- unlist(unique(concepts_in_adj_matrices))
  n_nodes <- length(node_names)
  n_maps <- length(adj_matrices)

  lower_adj_matrices <- lapply(adj_matrices, function(adj_matrix) apply(adj_matrix, c(1, 2), function(x) x[[1]]$lower))
  upper_adj_matrices <- lapply(adj_matrices, function(adj_matrix) apply(adj_matrix, c(1, 2), function(x) x[[1]]$upper))

  if (include_zeroes_in_sampling) {
    lower_aggregate_adj_matrix <- aggregate_conventional_fcms(lower_adj_matrices, agg_function, include_zeroes_in_sampling)
  } else {
    # Do NOT count IVFNs with a 0-lower bound as 0-weighted edges!!!!!!
    false_zero_ivfn_locs_across_adj_matrices <- lapply(adj_matrices, function(adj_matrix) {
      which(apply(adj_matrix, c(1, 2), function(element) (element[[1]]$lower == 0 & element[[1]]$upper != 0)), arr.ind = TRUE)
    })
    lower_aggregate_adj_matrix <- aggregate_conventional_fcms(lower_adj_matrices, agg_function, include_zeroes_in_sampling, false_zero_ivfn_locs_across_adj_matrices)
  }
  upper_aggregate_adj_matrix <- aggregate_conventional_fcms(upper_adj_matrices, agg_function, include_zeroes_in_sampling)

  aggregate_adj_matrix_w_ivfns <- make_adj_matrix_w_ivfns(lower_aggregate_adj_matrix$adj_matrix, upper_aggregate_adj_matrix$adj_matrix)
  colnames(aggregate_adj_matrix_w_ivfns) <- node_names
  rownames(aggregate_adj_matrix_w_ivfns) <- node_names

  structure(
    .Data = list(
      adj_matrix = aggregate_adj_matrix_w_ivfns,
      params = list(
        input_adj_matrices = adj_matrices,
        aggregation_fun = agg_function,
        IDs = node_names
      )
    ),
    class = "aggregate_of_fcms_w_ivfns"
  )
}


#' Aggregate (TFN) FCMs
#'
#' @family aggregate_fcms
#'
#' @description
#' Generate an aggregate adj. matrix from a list of (TFN) adj. matrices.
#' FCM aggregation works by calculating the mean/median edge weight for all edges
#' across the input adj. matrices (i.e. the mean/median of the edge weight
#' connecting A -> B across all maps, the mean/median of the edge weight
#' connecting B -> C across all maps, and so on). The user may dictate whether
#' to incorporate 0-valued edge weights in the mean/median calculations.
#'
#' #' All input adj. matrices must have the same dimensions and concept names to
#' generate an aggregate. Call \code{\link{standardize_adj_matrices}} to make
#' sure all adj. matrices have the same dimensions.
#'
#' @details
#' This function implements FCM aggregation methods used in
#' Aminpout 2020 (https://doi.org/10.1038/s41893-019-0467-z) for use with
#' conventional FCMs, and expands upon them for TFN-FCMs.
#'
#' The mean aggregate FCM of a set of TFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{M} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{N} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{M}\right]_{ij}^{FCM_{p}}}{N} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{N}\right]
#' }
#'
#' where \eqn{\left[ A^{L} , A^{M}, A^{U} \ \right]_{ij}^{FCM_{aggregate}}} is the TFN
#' weight (with lower bound \eqn{A^{L}}, mode \eqn{A^{M}}, and upper bound \eqn{A^{U}}) of the
#' element in row i and column j of the aggregate, and
#' \eqn{\left[ A^{L}\right]_{ij}^{FCM_{p}}}, \eqn{\left[ A^{M}\right]_{ij}^{FCM_{p}}}, and
#' \eqn{\left[ A^{U}\right]_{ij}^{FCM_{p}}} are the lower bound, mode, and upper
#' bound of the TFN weight of the element in row i and column j for the p-th
#' FCM adjacency matrix.
#'
#' If not including zero-valued edges in aggregation calculations, the mean
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\left[ A^{L} ,A^{M} ,A^{U} \ \right]_{ij}^{FCM_{aggregate}} =\left[\frac{\sum _{p\ =\ 1}^{N}\left[ A^{L}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{L}\right]_{ij}^{FCM_{p}} \neq 0} ,\frac{\sum _{p\ =\ 1}^{N}\left[ A^{M}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{M}\right]_{ij}^{FCM_{p}} \neq 0} ,\ \frac{\sum _{p\ =\ 1}^{N}\left[ A^{U}\right]_{ij}^{FCM_{p}}}{\sum _{p\ =\ 1}^{N} 1|\left[ A^{U}\right]_{ij}^{FCM_{p}} \neq 0}\right]
#' }
#'
#' The median aggregate FCM of a set of TFN-FCMs is:
#' \deqn{
#' A_{ij}^{aggregate} =[ Median\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) ,\ \ \\
#' Median\left( A_{ij}^{FCM_{1} -M} ,A_{ij}^{FCM_{2} -M} ,...,A_{ij}^{FCM_{N} -M}\right) ,\ \\
#' Median\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right)]
#' }
#' If not including zero-valued edges in aggregation calculations, the median
#' aggregate equation becomes:
#' \deqn{
#' A_{ij}^{aggregate} =\ \newline
#' [ Median\left( A_{ij}^{FCM_{1} -L} ,A_{ij}^{FCM_{2} -L} ,...,A_{ij}^{FCM_{N} -L}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0,\ \newline
#'   [ Median\left( A_{ij}^{FCM_{1} -M} ,A_{ij}^{FCM_{2} -M} ,...,A_{ij}^{FCM_{N} -M}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0,\ \newline
#'     \ Median\left( A_{ij}^{FCM_{1} -U} ,A_{ij}^{FCM_{2} -U} ,...,A_{ij}^{FCM_{N} -U}\right) |A_{ij}^{FCM_{1} -L} \neq A_{ij}^{FCM_{1} -M} \neq A_{ij}^{FCM_{1} -U} \neq 0]
#' }
#'
#' @param adj_matrices A list of TFN FCM adj. matrix objects
#' @param agg_function Calculate aggregate edge weights as either the
#' "mean" or "median" of the input edge weights across inputs
#' @param include_zeroes_in_sampling TRUE/FALSE Whether to include zeroes in the mean/median
#' calculations. (i.e. if edges not included in a map should count as a zero-weighted
#' edge or not at all)
#'
#' @returns An aggregate adj. matrix (of class 'aggregate') with edges represented
#' as TFN data types
#'
#' @keywords internal
#'
#' @export
#' @example  man/examples/ex-aggregate_fcms_w_tfns.R
aggregate_fcms_w_tfns <- function(adj_matrices = list(matrix()),
                                  agg_function = c("mean", "median"),
                                  include_zeroes_in_sampling = TRUE) {

  concepts_in_adj_matrices <- lapply(adj_matrices, function(x) get_node_IDs_from_input(x))
  node_names <- unlist(unique(concepts_in_adj_matrices))
  n_nodes <- length(node_names)
  n_maps <- length(adj_matrices)

  lower_adj_matrices <- lapply(adj_matrices, function(adj_matrix) apply(adj_matrix, c(1, 2), function(x) x[[1]]$lower))
  mode_adj_matrices <- lapply(adj_matrices, function(adj_matrix) apply(adj_matrix, c(1, 2), function(x) x[[1]]$mode))
  upper_adj_matrices <- lapply(adj_matrices, function(adj_matrix) apply(adj_matrix, c(1, 2), function(x) x[[1]]$upper))

  if (include_zeroes_in_sampling) {
    lower_aggregate_adj_matrix <- aggregate_conventional_fcms(lower_adj_matrices, agg_function, include_zeroes_in_sampling)
    mode_aggregate_adj_matrix <- aggregate_conventional_fcms(mode_adj_matrices, agg_function, include_zeroes_in_sampling)
  } else {
    # Do NOT count TFNs with a 0-lower and 0-mode bounds as 0-weighted edges!!!!!!
    false_zero_lower_tfn_locs_across_adj_matrices <- lapply(adj_matrices, function(adj_matrix) {
      which(apply(adj_matrix, c(1, 2), function(element) (element[[1]]$lower == 0 & element[[1]]$upper != 0)), arr.ind = TRUE)
    })
    false_zero_mode_tfn_locs_across_adj_matrices <- lapply(adj_matrices, function(adj_matrix) {
      which(apply(adj_matrix, c(1, 2), function(element) (element[[1]]$lower == 0 & element[[1]]$mode == 0 & element[[1]]$upper != 0)), arr.ind = TRUE)
    })
    lower_aggregate_adj_matrix <- aggregate_conventional_fcms(lower_adj_matrices, agg_function, include_zeroes_in_sampling, false_zero_lower_tfn_locs_across_adj_matrices)
    mode_aggregate_adj_matrix <- aggregate_conventional_fcms(mode_adj_matrices, agg_function, include_zeroes_in_sampling, false_zero_mode_tfn_locs_across_adj_matrices)
  }

  upper_aggregate_adj_matrix <- aggregate_conventional_fcms(upper_adj_matrices, agg_function, include_zeroes_in_sampling)

  aggregate_adj_matrix_w_tfns <- make_adj_matrix_w_tfns(lower_aggregate_adj_matrix$adj_matrix, mode_aggregate_adj_matrix$adj_matrix, upper_aggregate_adj_matrix$adj_matrix)

  colnames(aggregate_adj_matrix_w_tfns) <- node_names
  rownames(aggregate_adj_matrix_w_tfns) <- node_names

  structure(
    .Data = list(
      adj_matrix = aggregate_adj_matrix_w_tfns,
      params = list(
        input_adj_matrices = adj_matrices,
        aggregation_fun = agg_function,
        IDs = node_names
      )
    ),
    class = "aggregate_of_fcms_w_tfns"
  )
}


#' Print method for aggregate
#'
#' @family aggregate_fcms
#'
#' @param x an aggregate object
#' @param ... additional inputs
#'
#' @returns A console printout of aggregate_fcm output
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
print.aggregate <- function(x, ...) {
  print(x$adj_matrix)
  cat(paste0("\nAggregate (", x$params$aggregation_fun, ") of ", length(x$params$input_adj_matrices), " adj. matrices"))
}

