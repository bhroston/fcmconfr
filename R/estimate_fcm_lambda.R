
#' Estimate lambda
#'
#' @description
#' This function calculates the largest possible lambda for sigmoid and
#' tanh squashing functions that guarantees convergence of an FCM simulation.
#' Lambda is estimated such that 'squashed' simulation values are contained
#' within the near-linear region of the sigmoid or tanh functions.
#'
#' Note: The lambda value estimated will vary for different FCMs.
#'
#' This algorithm is intended for conventional fCMs. If an Interval Value
#' Fuzzy Number (IVFN) FCM or a Triangular Fuzzy Number (TFN) FCM is provided,
#' \code{estimate_fcm_lambda()} will create a conventional FCM by averaging
#' the edge weights (upper and lower) for IVFN-FCMs and upper, mode, and lower
#' for TFN-FCMs) for use in calculating lambda,.
#'
#' @details
#' This algorithm was first explored by Kottas et al. 2010 (https://doi.org/10.1007/978-3-642-03220-2_5),
#' and expanded upon by Harmati et al. 2018 (https://doi.org/10.1109/FUZZ-IEEE.2018.8491447), and
#' Koutsellis et al. 2022 (https://doi.org/10.1007/s12351-022-00717-x)
#'
#' The function applies an algorithm that can be used to optimize lambda which
#' comparing the lambda calculated based on the Frobenius-norm
#' (\eqn{\lambda^{'}}) and S-norm  (\eqn{\lambda^{*}}) of an
#' adjacency matrix and selects the minimum.
#'
#' \deqn{
#' \lambda _{s} < \min\left( \lambda _{s}^{'} ,\lambda _{s}^{*}\right)
#' }
#' \deqn{
#' \lambda _{h} < \min\left( \lambda _{h}^{'} ,\lambda _{h}^{*}\right)
#' }
#'
#' where \eqn{\lambda _{s}} is the lambda calculation when using the sigmoid
#' squashing function and \eqn{\lambda _{h}} is the lambda calculation when
#' using tanh.
#'
#' The equations for \eqn{\lambda ^{'}} were developed by
#' Harmati et al. 2018 (https://doi.org/10.1109/FUZZ-IEEE.2018.8491447) and are
#' given below.
#'
#' \deqn{
#' \lambda _{s} < \lambda _{s}^{'} =\frac{4}{\| \mathbf{W} \| _{F}}
#' }
#'
#' \deqn{
#' \lambda _{h} < \lambda _{h}^{'} =\frac{1}{\| \mathbf{W} \| _{F}}
#' }
#'
#' where \eqn{\| \mathbf{W} \| _{F} \ =\ \sqrt{\sum\limits _{i=1}^{n}\sum\limits _{j=1}^{n}\left( w_{ij}^{2}\right)}}
#' is the Frobenius norm of the adj. matrix (or \code{norm(x, type = "F")}).
#'
#' The equations for \eqn{\lambda ^{*}} were developed by
#' Koutsellis et al. 2022 (https://doi.org/10.1007/s12351-022-00717-x). Unlike
#' for \eqn{\lambda ^{'}}, the calculations for \eqn{\lambda ^{*}} follow
#' different steps based on whether calculating \eqn{\lambda} for the sigmoid
#' or tanh squashing function.
#'
#' For sigmoid:
#' \deqn{
#' |x_{i}^{k} \| _{\max} =\max\left(\left| 0.211\cdot \sum _{i=1}^{p} w_{ij}^{+} +0.789\cdot \sum _{i=1}^{p} w_{ij}^{-}\right| ,\left| 0.211\cdot \sum _{i=1}^{p} w_{ij}^{-} +0.789\cdot \sum _{i=1}^{p} w_{ij}^{+}\right| \right)
#' }
#' \deqn{
#' \| \mathbf{W} \| _{s} =\underset{i}{\max}\left( |x_{i}^{k} \| _{\max}\right)
#' }
#' \deqn{
#' \lambda _{s} < \lambda _{s}^{*} =\frac{1.317}{\| \mathbf{W} \| _{s}}
#' }
#'
#' For tanh:
#' \deqn{
#' \lambda _{h} < \lambda _{h}^{*} =\frac{1}{\| \mathbf{W} \| _{\infty }}
#' }
#' \deqn{
#' \| \mathbf{W} \| _{\infty } =\underset{i}{\max}\sum _{j=1}^{n}| w_{ij}|
#' }
#'
#' Finally, the maximum lambda the ensures convergence of the simulation for
#' the input adjacency matrix is the minimum of \eqn{\lambda ^{'}} and
#' \eqn{\lambda ^{*}}.
#'
#' Note: This is only algorithm included at present, but the code for
#' \code{estimate_fcm_lambda} is organized to streamline the addition of
#' new algorithms in the future.
#'
#' @param fcm_adj_matrix An n x n adjacency matrix that represents an FCM
#' @param squashing The squashing function used. Must be one of the following: 'tanh', or 'sigmoid'.
#'
#' @returns The maximum lambda that ensures simulation convergence for the
#' input FCM.
#'
#' @importFrom cli format_error
#'
#' @references \insertRef{kacprzyk_fuzzy_2010}{fcmconfr}
#' @references \insertRef{harmati_existence_2018}{fcmconfr}
#' @references \insertRef{koutsellis_parameter_2022}{fcmconfr}
#'
#' @export
#' @example man/examples/ex-estimate_fcm_lambda.R
estimate_fcm_lambda <- function(fcm_adj_matrix = matrix(),
                                squashing = c("sigmoid", "tanh")) {

  if (is.null(dim(fcm_adj_matrix))) {
    warning(cli::format_error(c(
      "x" = "Error: {.var fcm_adj_matrix} must be an (n x n) adj. matrix",
      "+++++> Input The operation dim(fcm_adj_matrix) returned NULL"
    )))
    return(invisible(NULL))
  }

  fcm_class <- get_adj_matrices_input_type(fcm_adj_matrix)$object_types_in_list[1]
  if (fcm_class == "conventional") {
    as_conventional_adj_matrix <- fcm_adj_matrix
  } else if (fcm_class == "ivfn") {
    as_conventional_adj_matrix <- apply(fcm_adj_matrix, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$upper)/2)
  } else if (fcm_class == "tfn") {
    as_conventional_adj_matrix <- apply(fcm_adj_matrix, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$mode + element[[1]]$upper)/3)
  }

  squashing <- tolower(squashing)

  if (identical(squashing, c("sigmoid", "tanh"))) {
    stop(cli::format_error(c(
      "x" = "Error: Please include an input for {.var squashing}",
      "+++++> Input {.var squashing} amust be either 'sigmoid' or 'tanh'"
    )))
  }
  if (!(squashing %in% c("sigmoid", "tanh"))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var squashing} amust be either 'sigmoid' or 'tanh'",
      "+++++> Input {.var squashing} was: {squashing}"
    )))
  }

  source_only_nodes <- which(rowSums(as_conventional_adj_matrix) == 0)
  if (length(source_only_nodes) > 0) {
    weight_matrix_of_nonsteady_nodes <- as.matrix(as_conventional_adj_matrix[-source_only_nodes, ])
  } else {
    weight_matrix_of_nonsteady_nodes <- as.matrix(as_conventional_adj_matrix)
  }

  frobenius_norm <- sqrt(sum(apply(weight_matrix_of_nonsteady_nodes, c(1, 2), function(element) element^2)))

  if (squashing == "sigmoid") {
    lambda_prime <- 4/frobenius_norm

    # Calculate lambda_star
    row_wise_max_norms <- vector(mode = "numeric", length = nrow(fcm_adj_matrix))
    for (i in seq_along(1:nrow(weight_matrix_of_nonsteady_nodes))) {
      row_edge_weights <- weight_matrix_of_nonsteady_nodes[i, ]
      positive_row_edge_weights <- row_edge_weights[row_edge_weights > 0]
      negative_row_edge_weights <- row_edge_weights[row_edge_weights < 0]
      row_wise_max_norms[i] <- max(
        abs(0.211*sum(positive_row_edge_weights) + 0.789*sum(negative_row_edge_weights)),
        abs(0.211*sum(negative_row_edge_weights) + 0.789*sum(positive_row_edge_weights))
      )
    }
    s_norm <- max(row_wise_max_norms)
    lambda_star <- 1.317/s_norm
  } else if (squashing == "tanh") {
    lambda_prime <- 1/frobenius_norm

    # Calculate lambda_star
    abs_weight_matrix_of_nonsteady_nodes <- abs(weight_matrix_of_nonsteady_nodes)
    max_abs_row_sum_norm <- max(apply(weight_matrix_of_nonsteady_nodes, 1, sum))
    infinum_norm <- max_abs_row_sum_norm
    lambda_star <- 1.14/infinum_norm
  }

  lambda_estimate <- min(lambda_prime, lambda_star)

  lambda_estimate
}
