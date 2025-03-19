
################################################################################
# monte_carlo_model_generation_and_confidence_intervals.R
#
# These functions assist in generating empirical FCMs via Monte Carlo methods
# and estimating quantiles and confidence intervals.
#
#   - build_monte_carlo_fcms
#   - get_quantiles_and_bootstrapped_CIs_of_inferences
#
################################################################################

#' Build Monte Carlo FCMs
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @description
#' This function generates N fcm adjacency matrices whose edge weights are
#' sampled from edge values (that may be numeric, IVFNs, or TFNs) and
#' stores them as a list of adjacency matrices.
#'
#' The show_progress and parallel inputs change the functions called, but do NOT
#' change the output! These are allowed to be toggled on/off to increase user
#' control at runtime.
#'
#' @details
#' For Conventional FCMs, edge weights are sampled the edge weight explicitly
#' defined in the input FCMs.
#'
#' For IVFN and TFN FCMs, edge weights are sampled from the combined
#' distributions representative of the IVFN/TFN edge weights. For example,
#' if an edge is given the following weights across two maps: IVFN(0.4, 0.8) and
#' IVFN \[0.5, 0.7]\, the samples will be drawn from the combined distribution:
#' sample(N, c(runif(N, 0.4, 0.8), runif(N, 0.5, 0.7)), replace = TRUE).
#'
#' @param adj_matrices  \[`list()`]\cr A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param n_samples \[`integer()` - Positive]\cr The number of samples to draw
#' with the selected sampling method. Also, the number of sampled models to
#' generate.
#' @param include_zeroes_in_sampling \[`logical(1)`]\cr If TRUE, incorporate
#' zero-weighted edges during Monte Carlo sampling.
#' @param show_progress \[`logical(1)`]\cr If TRUE, show progress bars and print
#' runtime updates in the console when performing FCM simulations.
#' @param silent \[`logical(1)`]\cr If TRUE, suppress warning and error
#' messages.
#' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`list()`]\cr A list of empirical (Conventional) FCM adj. matrices
#' generated via monte carlo methods
#'
#' @export
#'
#' @srrstats {BS4.0} Using Base R sampling algorithms.
#'
#' @example man/examples/ex-build_monte_carlo_fcms.R
build_monte_carlo_fcms <- function(adj_matrices = list(),
                                   n_samples = 1000L,
                                   include_zeroes_in_sampling = TRUE,
                                   show_progress = TRUE,
                                   silent = FALSE,
                                   skip_checks = FALSE) {

  requireNamespace("Matrix")

  # Check inputs ----
  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  check_fcmconfr_input(silent, check = "logical", var_name = "silent")
  silent <- as.logical(silent)
  if (silent) {
    sink(file = file(nullfile(), open = "wt"), type = "message")
  }

  if (!skip_checks) {
    check_fcmconfr_input(adj_matrices, check = "adj_matrix_list")
    if (!is.null(dim(adj_matrices))) {
      adj_matrices <- list(adj_matrices)
    }
    fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
    check_fcmconfr_input(n_samples, check = "positive_integer", var_name = "n_samples")
    check_fcmconfr_input(include_zeroes_in_sampling, check = "logical", var_name = "include_zeroes_in_sampling")
    check_fcmconfr_input(show_progress, check = "logical", var_name = "show_progress")
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
  n_samples <- as.integer(n_samples)
  include_zeroes_in_sampling <- as.logical(include_zeroes_in_sampling)
  show_progress <- as.logical(show_progress)
  # ----

  n_nodes <- unique(unlist(lapply(adj_matrices, dim)))

  # Conventional FCM Set
  if (fcm_class == "conventional") {
    flatten_conventional_adj_matrix <- function(adj_matrix) {
      if (identical(methods::is(as.vector(adj_matrix)), methods::is(list()))) {
        flattened_adj_matrix <- do.call(c, as.vector(adj_matrix))
      } else {
        flattened_adj_matrix <- as.vector(adj_matrix)
      }
      names(flattened_adj_matrix) <- seq_along(flattened_adj_matrix)
      flattened_adj_matrix
    }
    flattened_adj_matrices <- do.call(rbind, lapply(adj_matrices, flatten_conventional_adj_matrix))
    if (!include_zeroes_in_sampling) {
      flattened_adj_matrices[flattened_adj_matrices == 0] <- NA
    }

    if (show_progress) {
      cat(print("Sampling from column vectors", quote = FALSE))
      column_samples <- pbapply::pbapply(flattened_adj_matrices, 2, function(column_vec) {
        na_omit_column_vec <- stats::na.omit(column_vec)
        if (length(na_omit_column_vec) != 0) {
          sample(na_omit_column_vec, n_samples, replace = TRUE)
        } else {
          rep(0, n_samples)
        }
      })
      cat(print("Constructing monte carlo fcms from samples", quote = FALSE))
      sampled_adj_matrices <- pbapply::pbapply(column_samples, 1, function(row_vec) matrix(row_vec, nrow = n_nodes, ncol = n_nodes), simplify = FALSE)
    } else {
      column_samples <- apply(flattened_adj_matrices, 2, function(column_vec) {
        na_omit_column_vec <- stats::na.omit(column_vec)
        if (length(na_omit_column_vec) != 0) {
          sample(na_omit_column_vec, n_samples, replace = TRUE)
        } else {
          rep(0, n_samples)
        }
      })
      sampled_adj_matrices <- apply(column_samples, 1, function(row_vec) matrix(row_vec, nrow = n_nodes, ncol = n_nodes), simplify = FALSE)
    }
  }

  # IVFN or TFN Set
  if (fcm_class %in% c("ivfn", "tfn")) {
    flatten_fuzzy_adj_matrix <- function(fuzzy_adj_matrix) do.call(cbind, lapply(as.vector(fuzzy_adj_matrix), rbind))
    flattened_adj_matrices <- do.call(rbind, lapply(adj_matrices, flatten_fuzzy_adj_matrix))
    flattened_adj_matrices_w_distributions <- convert_fuzzy_set_elements_in_matrix_to_distributions(adj_matrix = flattened_adj_matrices, fcm_class = fcm_class, n_samples = n_samples)
    if (!include_zeroes_in_sampling) {
      flattened_adj_matrices_w_distributions <- apply(flattened_adj_matrices_w_distributions, c(1, 2), function(element) ifelse(element[[1]][[1]] == 0, NA, element[[1]][[1]]), simplify = FALSE)
    } else {
      flattened_adj_matrices_w_distributions <- apply(flattened_adj_matrices_w_distributions, c(1, 2), function(element) element[[1]][[1]], simplify = FALSE)
    }

    if (show_progress) {
      cat(print("Sampling from column vectors", quote = FALSE))
      column_samples <- pbapply::pbapply(
        flattened_adj_matrices_w_distributions, 2,
        function(column_vec) {
          # sample_list_of_vectors_ignoring_NAs
          na_omit_column_vec <- stats::na.omit(do.call(c, column_vec))
          if (length(na_omit_column_vec) != 0) {
            column_vecs_w_NAs <- lapply(
              column_vec, function(value) value
            )
            column_vecs_w_NAs <- stats::na.omit(do.call(c, column_vecs_w_NAs))
            sample(column_vecs_w_NAs, n_samples, replace = TRUE)
          } else {
            rep(0, n_samples)
          }
        })
      cat(print("Constructing monte carlo fcms from samples", quote = FALSE))
      sampled_adj_matrices <- pbapply::pbapply(column_samples, 1, function(row_vec) matrix(row_vec, nrow = n_nodes, ncol = n_nodes), simplify = FALSE)
    } else {
      column_samples <- apply(flattened_adj_matrices_w_distributions, 2, function(column_vec) {
        # sample_list_of_vectors_ignoring_NAs
        na_omit_column_vec <- stats::na.omit(do.call(c, column_vec))
        if (length(na_omit_column_vec) != 0) {
          na_omit_column_vec <- stats::na.omit(do.call(c, column_vec))
          if (length(na_omit_column_vec) != 0) {
            column_vecs_w_NAs <- lapply(
              column_vec, function(value) value
            )
            column_vecs_w_NAs <- stats::na.omit(do.call(c, column_vecs_w_NAs))
            sample(column_vecs_w_NAs, n_samples, replace = TRUE)
          }
        } else {
          rep(0, n_samples)
        }
      })
      sampled_adj_matrices <- apply(column_samples, 1, function(row_vec) matrix(row_vec, nrow = n_nodes, ncol = n_nodes), simplify = FALSE)
    }
  }

  return(sampled_adj_matrices)
}



#' Calculate Quantiles and Bootstrapped CI's of Inferences from an FCM Set
#'
#' @family monte-carlo-model-generation-and-simulation
#'
#' @description
#' This calculates the mean/median of the distribution of simulated values
#' across a given iter. Also returns the bootstrapped mean of means of the
#' distribution of simulated values across a given iter if called.
#'
#' @details
#' This function is designed to streamline the process of getting the mean or
#' bootstrapped mean of means of a distribution of simulated values across
#' individual iterations. Use get_bootstrapped_means to estimate the confidence
#' intervals for the mean value across simulations.
#'
#' The show_progress and parallel inputs change the functions called, but do NOT
#' change the output! These are allowed to be toggled on/off to increase user
#' control at runtime.
#'
#' @param infer_fcm_set_inference_obj \[`inference_of_fcm_set`]\cr A direct
#' output from \code{link{infer_fcm_set}}, specifically, this is the
#' inference_df object from that output.
#' @param ci_centering_function \[`character(1)`]\cr Estimate confidence
#' intervals about the "mean" or "median" of inferences from Monte Carlo
#' simulations
#' @param confidence_interval \[`double(1)` - Positive (between 0 and 1)]\cr
#' Bootstrapped confidence level
#' @param num_ci_bootstraps \[`integer(1)` - Positive] Number of bootstrap draws
#' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel processing.
#' @param n_cores \[`integer(1)` - Positive]\cr The number of cores to use in parallel
#' processing. If no input given, all available cores will be used.
#' @param show_progress \[`logical(1)`]\cr If TRUE, show progress bars and print
#' runtime updates in the console when performing FCM simulations.
#' @param skip_checks  \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' call to \code{check_simulation_inputs} (internal function)
#'
#' @returns \[`quantiles_and_bootstrapped_CIs_of_inferences`]\cr A list
#' containing a dataframe of quantiles and bootstrapped CIs of inferences, and
#' another dataframe of raw bootstrap draws.
#'
#' @example man/examples/ex-get_quantiles_and_bootstrapped_CIs_of_inferences.R
#' @keywords internal
#' @noRd
get_quantiles_and_bootstrapped_CIs_of_inferences <- function(infer_fcm_set_inference_obj = list(),
                                                             ci_centering_function = c("mean", "median"),
                                                             confidence_interval = 0.95,
                                                             bootstrap_reps = 1000L,
                                                             parallel = FALSE,
                                                             n_cores = 1L,
                                                             show_progress = TRUE,
                                                             skip_checks = FALSE) {

  # Check inputs ----
  if (!identical(methods::is(infer_fcm_set_inference_obj)[1], "inference_of_fcm_set")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var infer_fcm_set_inference_obj} must be a direct output from infer_fcm_set",
      "+++++++> Input {.var infer_fcm_set_inference_obj} had class: {methods::is(infer_fcm_set_inference_obj)[1]}"
    )))
  }
  infer_fcm_set_inference_df <- infer_fcm_set_inference_obj$inferences
  infer_fcm_set_inference_df <- infer_fcm_set_inference_df[colnames(infer_fcm_set_inference_df) != attr(infer_fcm_set_inference_df, "index")]

  check_fcmconfr_input(skip_checks, check = "logical", var_name = "skip_checks")
  skip_checks <- as.logical(skip_checks)

  if (!skip_checks) {
    check_fcmconfr_input(ci_centering_function, check = "choice_selection", var_name = "ci_centering_function", choice_selection_opts = c("mean", "median"))
    check_fcmconfr_input(parallel, check = "logical", var_name = "parallel")
    check_fcmconfr_input(n_cores, check = "positive_integer", var_name = "n_cores")
    check_fcmconfr_input(show_progress, check = "logical", var_name = "show_progress")
  }
  ci_centering_function <- tolower(as.character(ci_centering_function))
  parallel <- as.logical(parallel)
  n_cores <- as.integer(n_cores)
  show_progress <- as.logical(show_progress)

  parallel_and_show_progress_checks <- check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = parallel, use_show_progress = show_progress)
  parallel <- parallel_and_show_progress_checks$parallel
  show_progress <- parallel_and_show_progress_checks$show_progress
  # ----

  bootstrap_draws_per_rep <- nrow(infer_fcm_set_inference_df)
  node_names <- colnames(infer_fcm_set_inference_df)


  if (show_progress) {
    # Show Progress ----
    print("Performing bootstrap simulations", quote = FALSE)
    bootstrapped_means_of_inference_by_node <- vector(mode = "list", length = bootstrap_reps)
    rep_inference_by_node <- vector(mode = "list", length = bootstrap_reps)
    rep_inference_by_node <- lapply(rep_inference_by_node, function(duplicate) duplicate <- infer_fcm_set_inference_df)
    if (ci_centering_function == "mean") {
      bootstrapped_means_of_inference_by_node <- pbapply::pblapply(
        rep_inference_by_node,
        function(inference_by_node_duplicate) {
          apply(
            inference_by_node_duplicate, 2,
            function(inference) {
              random_draws <- sample(inference, bootstrap_draws_per_rep, replace = TRUE)
              mean(random_draws)
            }
          )
        }
      )
    } else if (ci_centering_function == "median") {
      bootstrapped_medians_of_inference_by_node <- pbapply::pblapply(
        rep_inference_by_node,
        function(inference_by_node_duplicate) {
          apply(
            inference_by_node_duplicate, 2,
            function(inference) {
              random_draws <- sample(inference, bootstrap_draws_per_rep, replace = TRUE)
              stats::median(random_draws)
            }
          )
        }
      )
    }
    # ----
  } else if (!show_progress) {
    # Don't Show Progress ----
    rep_inference_by_node <- vector(mode = "list", length = bootstrap_reps)
    rep_inference_by_node <- lapply(rep_inference_by_node, function(duplicate) duplicate <- infer_fcm_set_inference_df)
    if (ci_centering_function == "mean") {
      bootstrapped_means_of_inference_by_node <- lapply(
        rep_inference_by_node,
        function(inference_by_node_duplicate) {
          apply(
            inference_by_node_duplicate, 2,
            function(inference) {
              random_draws <- sample(inference, bootstrap_draws_per_rep, replace = TRUE)
              mean(random_draws)
            }
          )
        }
      )
    } else if (ci_centering_function == "median") {
      bootstrapped_medians_of_inference_by_node <- lapply(
        rep_inference_by_node,
        function(inference_by_node_duplicate) {
          apply(
            inference_by_node_duplicate, 2,
            function(inference) {
              random_draws <- sample(inference, bootstrap_draws_per_rep, replace = TRUE)
              stats::median(random_draws)
            }
          )
        }
      )
    }
    # ----
  }

  # Estimate CIs and Quantiles ----
  if (ci_centering_function == "mean") {
    bootstrapped_expectations_of_inference_by_node <- do.call(rbind, bootstrapped_means_of_inference_by_node)
  } else if (ci_centering_function == "median") {
    bootstrapped_expectations_of_inference_by_node <- do.call(rbind, bootstrapped_medians_of_inference_by_node)
  }
  colnames(bootstrapped_expectations_of_inference_by_node) <- node_names
  expected_value_of_inference_by_node <- apply(bootstrapped_expectations_of_inference_by_node, 2, mean)

  # print("Getting upper and lower quantile estimates of mean", quote = FALSE)
  lower_CI <- (1 - confidence_interval)/2
  upper_CI <- (1 + confidence_interval)/2
  lower_CIs_by_node <- apply(bootstrapped_expectations_of_inference_by_node, 2, function(bootstrapped_expectations) stats::quantile(bootstrapped_expectations, lower_CI), simplify = TRUE)
  upper_CIs_by_node <- apply(bootstrapped_expectations_of_inference_by_node, 2, function(bootstrapped_expectations) stats::quantile(bootstrapped_expectations, upper_CI), simplify = TRUE)

  nodes <- ifelse(names(lower_CIs_by_node) == names(upper_CIs_by_node), names(lower_CIs_by_node), stop("Error with quantiles calculation"))
  # ----

  # Organize Output ----
  CIs_by_node <- data.frame(
    node = nodes,
    expected_value = expected_value_of_inference_by_node,
    lower_CI = vector(mode = "numeric", length = length(nodes)),
    upper_CI = vector(mode = "numeric", length = length(nodes))
  )
  for (i in seq_along(nodes)) {
    CIs_by_node$lower_CI[i] <- lower_CIs_by_node[i][[1]] # not sure why this [[1]] is necessary but it is
    CIs_by_node$upper_CI[i] <- upper_CIs_by_node[i][[1]] # not sure why this [[1]] is necessary but it is
  }

  quantiles_of_fcm_set_simulation_inferences <- data.frame(t(apply(infer_fcm_set_inference_df, 2, stats::quantile)))
  fcm_set_inference_distributions_df <- data.frame(cbind(
    CIs_by_node$node, CIs_by_node$expected_value, CIs_by_node$lower_CI, CIs_by_node$upper_CI,
    quantiles_of_fcm_set_simulation_inferences$X0., quantiles_of_fcm_set_simulation_inferences$X25., quantiles_of_fcm_set_simulation_inferences$X50.,
    quantiles_of_fcm_set_simulation_inferences$X75., quantiles_of_fcm_set_simulation_inferences$X100.
  ))

  colnames(fcm_set_inference_distributions_df) <- c(
    "node", "expected_value", paste0(lower_CI, "_CI"), paste0(upper_CI, "_CI"),
    "min",  "0.25_quantile", "median", "0.75_quantile", "max"
  )

  for (col in 2:ncol(fcm_set_inference_distributions_df)) {
    fcm_set_inference_distributions_df[, col] <- as.numeric(fcm_set_inference_distributions_df[, col])
  }

  attr(fcm_set_inference_distributions_df, "index") <- "node"

  if (show_progress) print("Done", quote = FALSE)
  # ----

  return(structure(
    .Data = list(
      CIs_and_quantiles_by_node = fcm_set_inference_distributions_df,
      bootstrap_expected_values = bootstrapped_expectations_of_inference_by_node
    ),
    class = "quantiles_and_bootstrapped_CIs_of_inferences"
  ))

}
