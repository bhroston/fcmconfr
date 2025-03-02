
# microbenchmark(
#   build_monte_carlo_fcms_from_conventional_adj_matrices(adj_matrix_list, N_samples, include_zeroes = TRUE, show_progress),
#   build_monte_carlo_fcms_from_conventional_adj_matrices(adj_matrix_list, N_samples, include_zeroes = FALSE, show_progress)
# )
#
# microbenchmark(
#   build_monte_carlo_fcms_from_fuzzy_adj_matrices(adj_matrix_list, adj_matrix_list_class, N_samples, include_zeroes = TRUE, show_progress),
#   build_monte_carlo_fcms_from_fuzzy_adj_matrices(adj_matrix_list, adj_matrix_list_class, N_samples, include_zeroes = FALSE, show_progress)
# )

requireNamespace("igraph")

# All checks pass (and autotest returns NULL)
test_that("build_monte_carlo_fcms works", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0, 0, 0, 1),
    "C" = c(0, 1, 0, 0),
    "D" = c(0, 0, 1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.25, 0, 0, 0.25),
    "C" = c(0, 0.25, 0, 0),
    "D" = c(0, 0, 0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.75, 0, 0, 0.75),
    "C" = c(0, 0.75, 0, 0),
    "D" = c(0, 0, 0.75, 0)
  )
  test_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.5, 0, 0, 0.5),
    "C" = c(0, 0.5, 0, 0),
    "D" = c(0, 0, 0.5, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)

  mc_fcms_show_progress <- build_monte_carlo_fcms(test_fcms, n_samples = 1000, include_zeroes_in_sampling = FALSE, show_progress = TRUE, silent = FALSE)
  mc_fcms_no_show_progress <- build_monte_carlo_fcms(test_fcms, n_samples = 1000, include_zeroes_in_sampling = FALSE, show_progress = FALSE, silent = FALSE)

  expect_true(all(unique(unlist(lapply(mc_fcms_show_progress, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))
  expect_true(all(unique(unlist(lapply(mc_fcms_no_show_progress, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))

  expect_no_error(build_monte_carlo_fcms(sample_fcms$simple_fcms$tfn_fcms[[1]], include_zeroes_in_sampling = FALSE, show_progress = TRUE, silent = FALSE))


  lower_adj_matrix <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.25, 0, 0, 0.25),
    "C" = c(0, 0.25, 0, 0),
    "D" = c(0, 0, 0.25, 0)
  )
  upper_adj_matrix <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.75, 0, 0, 0.75),
    "C" = c(0, 0.75, 0, 0),
    "D" = c(0, 0, 0.75, 0)
  )
  ivfn_mat_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  ivfn_mat_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix*1.2, upper_adj_matrix*1.2)
  ivfn_mat_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix*0.8, upper_adj_matrix*0.8)
  test_fcms <- list(ivfn_mat_1, ivfn_mat_2, ivfn_mat_3)

  mc_fcms_show_progress <- build_monte_carlo_fcms(test_fcms, n_samples = 1000, include_zeroes_in_sampling = FALSE, show_progress = TRUE, silent = FALSE)
  mc_fcms_no_show_progress <- build_monte_carlo_fcms(test_fcms, n_samples = 1000, include_zeroes_in_sampling = FALSE, show_progress = FALSE, silent = FALSE)

  mc_samples_row1_col2 <- unlist(lapply(mc_fcms_show_progress, function(x) x[1, 2]))
  expected_samples_row1_col2 <- c(runif(1000, 0.25, 0.75), runif(1000, 0.3, 0.9), runif(1000, 0.2, 0.6))
  diff_in_means <- abs(mean(mc_samples_row1_col2) - mean(expected_samples_row1_col2))
  diff_in_var <- abs(var(mc_samples_row1_col2) - var(expected_samples_row1_col2))

  expect_lt(diff_in_means, 0.05)
  expect_lt(diff_in_var, 0.05)

  # Check when differrent edges across maps
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0.33, 0, 0),
    "B" = c(0, 0, 0.33, 0),
    "C" = c(0, 0, 0, 0.33),
    "D" = c(0.33, 0, 0, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0.88, 0, 0),
    "B" = c(0, 0, 0.88, 0),
    "C" = c(0, 0, 0, 0.88),
    "D" = c(0.88, 0, 0, 0)
  )
  ivfn_mat_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  adj_matrices <- list(ivfn_mat_1, ivfn_mat_2, ivfn_mat_3, ivfn_mat_4)

  tri_matrix_1 <- make_adj_matrix_w_tfns(
    lower = matrix(data = c(0, 0.2, 0, 0.5), nrow = 2, ncol = 2),
    mode = matrix(data = c(0, 0.3, 0, 0.6), nrow = 2, ncol = 2),
    upper = matrix(data = c(0, 0.4, 0, 0.7), nrow = 2, ncol = 2)
  )
  tri_matrix_2 <- make_adj_matrix_w_tfns(
    lower = matrix(data = c(0, 0.4, 0, 0.1), nrow = 2, ncol = 2),
    mode = matrix(data = c(0, 0.6, 0, 0.3), nrow = 2, ncol = 2),
    upper = matrix(data = c(0, 0.8, 0, 0.4), nrow = 2, ncol = 2)
  )
  tri_matrix_3 <- make_adj_matrix_w_tfns(
    lower = matrix(data = c(0, 0.4, 0.1, 0.1), nrow = 2, ncol = 2),
    mode = matrix(data = c(0, 0.6, 0.2, 0.3), nrow = 2, ncol = 2),
    upper = matrix(data = c(0, 0.8, 0.3, 0.4), nrow = 2, ncol = 2)
  )
  triangular_adj_matrices <- list(tri_matrix_1, tri_matrix_2, tri_matrix_3)

  test_mc_fcms <- build_monte_carlo_fcms(triangular_adj_matrices, n_samples = 1000, include_zeroes_in_sampling = TRUE, show_progress = FALSE, silent = TRUE)
  mc_samples_row2_col1 <- unlist(lapply(test_mc_fcms, function(x) x[2, 1]))

  expected_samples_row2_col1 <- c(rtriangular_dist(1000, 0.2, 0.3, 0.4), rtriangular_dist(1000, 0.4, 0.6, 0.8), rtriangular_dist(1000, 0.4, 0.6, 0.8))
  diff_in_means <- abs(mean(mc_samples_row2_col1) - mean(expected_samples_row2_col1))
  diff_in_var <- abs(var(mc_samples_row2_col1) - var(expected_samples_row2_col1))

  expect_lt(diff_in_means, 0.02)
  expect_lt(diff_in_var, 0.02)
})



test_that("get_quantiles_and_bootstrapped_CIs_of_inferences works", {
  lower_adj_matrix <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.25, 0, 0, 0.25),
    "C" = c(0, 0.25, 0, 0),
    "D" = c(0, 0, 0.25, 0)
  )
  upper_adj_matrix <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.75, 0, 0, 0.75),
    "C" = c(0, 0.75, 0, 0),
    "D" = c(0, 0, 0.75, 0)
  )
  ivfn_mat_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  ivfn_mat_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix*1.2, upper_adj_matrix*1.2)
  ivfn_mat_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix*0.8, upper_adj_matrix*0.8)
  adj_matrices <- list(ivfn_mat_1, ivfn_mat_2, ivfn_mat_3)
  test_mc_fcms <- build_monte_carlo_fcms(adj_matrices, n_samples = 1000, include_zeroes_in_sampling = FALSE, show_progress = FALSE)

  test_mc_fcms_inferences <- infer_fcm_set(
    adj_matrices = test_mc_fcms,
    initial_state_vector <- c(1, 1, 1, 1),
    clamping_vector <- c(1, 0, 0, 0),
    activation = "rescale",
    squashing = "sigmoid",
    lambda = 1,
    point_of_inference = "final",
    max_iter = 100,
    min_error = 1e-3,
    parallel = TRUE,
    show_progress = FALSE,
    n_cores = 2
  )

  # Check for median estimation
  expect_no_error(
    invisible(capture.output(
      mc_CIs_median_p_and_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "median", 0.95, parallel = TRUE, show_progress = TRUE, n_cores = 2),
      mc_CIs_median_p_and_no_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "median", 0.95, parallel = TRUE, show_progress = FALSE, n_cores = 2),
      mc_CIs_median_no_p_and_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "median", 0.95, parallel = FALSE, show_progress = TRUE),
      mc_CIs_median_no_p_and_no_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "median", 0.95, parallel = FALSE, show_progress = FALSE)
    ))
  )

  # Confirm all methods produce similar output (cannot produce exactly the same
  # because of stochasticity in bootstrapping methods)
  expect_true(all(abs(mc_CIs_median_p_and_sp$CI_by_node[, -1] - mc_CIs_median_p_and_no_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs(mc_CIs_median_p_and_no_sp$CI_by_node[, -1] - mc_CIs_median_no_p_and_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs( mc_CIs_median_no_p_and_sp$CI_by_node[, -1] - mc_CIs_median_no_p_and_no_sp$CI_by_node[, -1]) < 0.3))


  # Check for mean estimate
  expect_no_error(
    invisible(capture.output(
      mc_CIs_mean_p_and_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "mean", 0.95, parallel = TRUE, show_progress = TRUE, n_cores = 2),
      mc_CIs_mean_p_and_no_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "mean", 0.95, parallel = TRUE, show_progress = FALSE, n_cores = 2),
      mc_CIs_mean_no_p_and_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "mean", 0.95, parallel = FALSE, show_progress = TRUE),
      mc_CIs_mean_no_p_and_no_sp <- get_quantiles_and_bootstrapped_CIs_of_inferences(test_mc_fcms_inferences, "mean", 0.95, parallel = FALSE, show_progress = FALSE)
    ))
  )

  # Confirm all methods produce similar output (cannot produce exactly the same
  # because of stochasticity in bootstrapping methods)
  expect_true(all(abs(mc_CIs_mean_p_and_sp$CI_by_node[, -1] - mc_CIs_mean_p_and_no_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs(mc_CIs_mean_p_and_no_sp$CI_by_node[, -1] - mc_CIs_mean_no_p_and_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs( mc_CIs_mean_no_p_and_sp$CI_by_node[, -1] - mc_CIs_mean_no_p_and_no_sp$CI_by_node[, -1]) < 0.3))


  # Check rejects non-dataframe objects
  expect_error(get_quantiles_and_bootstrapped_CIs_of_inferences("a", "median", 0.95, parallel = FALSE))
})

