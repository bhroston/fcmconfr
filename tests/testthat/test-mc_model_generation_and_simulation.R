
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

test_that("get_mc_simulations_inference_CIs_w_bootstrap", {
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

  invisible(capture.output(
    test_mc_fcms <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 1000, include_zeroes = FALSE)
  ))
  invisible(capture.output(
    test_mc_fcms_inferences <- infer_fcm_set(
      adj_matrices = test_mc_fcms,
      initial_state_vector <- c(1, 1, 1, 1),
      clamping_vector <- c(1, 0, 0, 0),
      activation = "kosko",
      squashing = "sigmoid",
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-5,
      parallel = TRUE,
      show_progress = TRUE,
      n_cores = 2
    )
  ))

  # Check for median estimation
  expect_no_error(
    invisible(capture.output(
      mc_CIs_median_p_and_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "median", 0.95, parallel = TRUE, show_progress = TRUE, n_cores = 2),
      mc_CIs_median_p_and_no_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "median", 0.95, parallel = TRUE, show_progress = FALSE, n_cores = 2),
      mc_CIs_median_no_p_and_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "median", 0.95, parallel = FALSE, show_progress = TRUE),
      mc_CIs_median_no_p_and_no_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "median", 0.95, parallel = FALSE, show_progress = FALSE)
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
      mc_CIs_mean_p_and_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "mean", 0.95, parallel = TRUE, show_progress = TRUE, n_cores = 2),
      mc_CIs_mean_p_and_no_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "mean", 0.95, parallel = TRUE, show_progress = FALSE, n_cores = 2),
      mc_CIs_mean_no_p_and_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "mean", 0.95, parallel = FALSE, show_progress = TRUE),
      mc_CIs_mean_no_p_and_no_sp <- get_mc_simulations_inference_CIs_w_bootstrap(test_mc_fcms_inferences$inference, "mean", 0.95, parallel = FALSE, show_progress = FALSE)
    ))
  )

  # Confirm all methods produce similar output (cannot produce exactly the same
  # because of stochasticity in bootstrapping methods)
  expect_true(all(abs(mc_CIs_mean_p_and_sp$CI_by_node[, -1] - mc_CIs_mean_p_and_no_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs(mc_CIs_mean_p_and_no_sp$CI_by_node[, -1] - mc_CIs_mean_no_p_and_sp$CI_by_node[, -1]) < 0.3))
  expect_true(all(abs( mc_CIs_mean_no_p_and_sp$CI_by_node[, -1] - mc_CIs_mean_no_p_and_no_sp$CI_by_node[, -1]) < 0.3))


  # Check rejects non-dataframe objects
  expect_error(get_mc_simulations_inference_CIs_w_bootstrap("a", "median", 0.95, parallel = FALSE))
})


test_that("get_mc_simulations_inference_CIs_w_bootstrap catches invalid parallel processing inputs", {

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector[3] <- 1

  test_mc_fcms <- build_monte_carlo_fcms(sample_fcms$large_fcms$conventional_fcms, N_samples = 100, include_zeroes = TRUE, show_progress = FALSE)
  invisible(capture.output(
    test_mc_fcms_inferences <- infer_fcm_set(
      adj_matrices = test_mc_fcms,
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
      activation = "kosko",
      squashing = "sigmoid",
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-5,
      parallel = FALSE,
      show_progress = FALSE
    )
  ))

  invisible(capture.output(
    expect_error( # When n_cores input is not an integer
      get_mc_simulations_inference_CIs_w_bootstrap(
        mc_simulations_inference_df = test_mc_fcms_inferences$inference,
        inference_function = "mean",
        confidence_interval = 0.95,
        bootstrap_reps = 100,
        parallel = TRUE,
        n_cores = 1.5
      )
    )
  ))

  invisible(capture.output(
    expect_no_error( # When n_cores is a positive, odd integer
      get_mc_simulations_inference_CIs_w_bootstrap(
        mc_simulations_inference_df = test_mc_fcms_inferences$inference,
        inference_function = "mean",
        confidence_interval = 0.95,
        bootstrap_reps = 100,
        parallel = TRUE,
        n_cores = 1
      )
    )
  ))

  # Messes w/ R CMD Check
  # invisible(capture.output(
  #   expect_warning( # When n_cores is larger than number of available cores
  #     get_mc_simulations_inference_CIs_w_bootstrap(
  #       mc_simulations_inference_df = test_mc_fcms_inferences$inference,
  #       inference_function = "mean",
  #       confidence_interval = 0.95,
  #       bootstrap_reps = 100,
  #       parallel = TRUE,
  #       n_cores = parallel::detectCores() + 1
  #     )
  #   )
  # ))

  invisible(capture.output(
    expect_warning( # When n_cores is larger than number of available cores
      get_mc_simulations_inference_CIs_w_bootstrap(
        mc_simulations_inference_df = test_mc_fcms_inferences$inference,
        inference_function = "mean",
        confidence_interval = 0.95,
        bootstrap_reps = 100,
        parallel = FALSE,
        n_cores = 2
      )
    )
  ))
})


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
  invisible(capture.output(
    mc_fcms_sp <- build_monte_carlo_fcms(test_fcms, N_samples = 1000, include_zeroes = FALSE, show_progress = TRUE),
    mc_fcms_no_sp <- build_monte_carlo_fcms(test_fcms, N_samples = 1000, include_zeroes = FALSE, show_progress = FALSE)
  ))
  expect_true(all(unique(unlist(lapply(mc_fcms_sp, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))
  expect_true(all(unique(unlist(lapply(mc_fcms_no_sp, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))



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

  invisible(capture.output(
    test_mc_fcms_sp <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = TRUE),
    test_mc_fcms_no_sp <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = FALSE)
  ))
  mc_samples_row1_col2 <- unlist(lapply(test_mc_fcms_sp, function(x) x[1, 2]))

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

  invisible(capture.output(
    build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = TRUE)
  ))


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
  invisible(capture.output(
    test_mc_fcms <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(triangular_adj_matrices, "tfn", 1000, include_zeroes = FALSE)
  ))
  mc_samples_row2_col1 <- unlist(lapply(test_mc_fcms, function(x) x[2, 1]))

  expected_samples_row2_col1 <- c(rtriangular_dist(1000, 0.2, 0.3, 0.4), rtriangular_dist(1000, 0.4, 0.6, 0.8), rtriangular_dist(1000, 0.4, 0.6, 0.8))
  diff_in_means <- abs(mean(mc_samples_row2_col1) - mean(expected_samples_row2_col1))
  diff_in_var <- abs(var(mc_samples_row2_col1) - var(expected_samples_row2_col1))

  expect_lt(diff_in_means, 0.02)
  expect_lt(diff_in_var, 0.02)


  # Confirm error with invalid class
  expect_error(build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(triangular_adj_matrices, "invalid_class", 1000, include_zeroes = FALSE))

})


test_that("build_monte_carlo_fcms_from_conventional_adj_matrices works", {
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
  invisible(capture.output(
    mc_fcms_sp <- build_monte_carlo_fcms(test_fcms, N_samples = 50, include_zeroes = FALSE, show_progress = TRUE),
    mc_fcms_no_sp <- build_monte_carlo_fcms(test_fcms, N_samples = 50, include_zeroes = FALSE, show_progress = FALSE)
  ))
  expect_true(all(unique(unlist(lapply(mc_fcms_sp, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))
  expect_true(all(unique(unlist(lapply(mc_fcms_no_sp, function(fcm) fcm[1, 2]))) %in% c(0.5, 0.25, 0.75)))
})


test_that("build_monte_carlo_fcms_from_fuzzy_set_adj_matrices works", {
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

  # Include_zeroes = FALSE
  invisible(capture.output(
    test_mc_fcms_sp <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = TRUE),
    test_mc_fcms_no_sp <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = FALSE)
  ))
  mc_samples_row1_col2 <- unlist(lapply(test_mc_fcms_sp, function(x) x[1, 2]))

  # Include_zerpoes = TRUE
  invisible(capture.output(
    test_mc_fcms_include_zeroes <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = TRUE, show_progress = TRUE)
  ))

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

  invisible(capture.output(
    build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 100, include_zeroes = FALSE, show_progress = TRUE)
  ))


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
  invisible(capture.output(
    test_mc_fcms <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(triangular_adj_matrices, "tfn", 1000, include_zeroes = FALSE)
  ))
  mc_samples_row2_col1 <- unlist(lapply(test_mc_fcms, function(x) x[2, 1]))

  expected_samples_row2_col1 <- c(rtriangular_dist(1000, 0.2, 0.3, 0.4), rtriangular_dist(1000, 0.4, 0.6, 0.8), rtriangular_dist(1000, 0.4, 0.6, 0.8))
  diff_in_means <- abs(mean(mc_samples_row2_col1) - mean(expected_samples_row2_col1))
  diff_in_var <- abs(var(mc_samples_row2_col1) - var(expected_samples_row2_col1))

  expect_lt(diff_in_means, 0.02)
  expect_lt(diff_in_var, 0.02)


  # Confirm error with invalid class
  expect_error(build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(triangular_adj_matrices, "invalid_class", 1000, include_zeroes = FALSE))

})


test_that("check_infer_fcm_set_inputs works", {

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector[3] <- 1

  # Check adj matrices # ----
  ind_adj_matrix <- sample_fcms$large_fcms$conventional_fcms[[1]]
  check_converts_matrix_to_list <- check_infer_fcm_set_inputs(ind_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 2)
  expect_identical(
    list(ind_adj_matrix), check_converts_matrix_to_list$adj_matrices
  )

  bad_adj_matrix_1 <- ind_adj_matrix
  colnames(bad_adj_matrix_1) <- 1:ncol(bad_adj_matrix_1)
  bad_adj_matrix_2 <- ind_adj_matrix
  colnames(bad_adj_matrix_2) <- (ncol(bad_adj_matrix_2) + 1):(2*ncol(bad_adj_matrix_2) + 1)
  wrong_size_adj_matrix <- tibble::tibble(cbind(bad_adj_matrix_1, bad_adj_matrix_2))
  different_sized_adj_matrices <- sample_fcms$large_fcms$conventional_fcms
  different_sized_adj_matrices[[length(different_sized_adj_matrices) + 1]] <- wrong_size_adj_matrix
  expect_error(
    check_infer_fcm_set_inputs(different_sized_adj_matrices, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 2)
  )

  different_named_adj_matrices <- sample_fcms$large_fcms$conventional_fcms
  colnames(different_named_adj_matrices[[1]]) <- paste0(colnames(different_named_adj_matrices[[1]]), "_wrong")
  expect_error(
    check_infer_fcm_set_inputs(different_named_adj_matrices, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  )

  salinization_conventional_fcms_igraph_objects <- lapply(sample_fcms$large_fcms$conventional_fcms, function(adj_matrix) igraph::graph_from_adjacency_matrix(as.matrix(adj_matrix), mode = "directed", weighted = TRUE))
  igraph_sparse_matrices <- lapply(salinization_conventional_fcms_igraph_objects, function(igraph_obj) igraph::as_adjacency_matrix(igraph_obj, attr = "weight"))
  expect_warning(
    check_infer_fcm_set_inputs(igraph_sparse_matrices, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 2)
  )
  # ----

  # Check Runtime Options ----
  expect_warning(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", parallel = TRUE)
  )
  expect_error(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = "a")
  )
  expect_error(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 5.6)
  )
  expect_error(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = -3)
  )
  expect_error(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 2, include_simulations_in_output = 2)
  )
  expect_error(
    check_infer_fcm_set_inputs(sample_fcms$large_fcms$ivfn_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", n_cores = 1000)
  )
  # ----
})


test_that("check_build_monte_carlo_fcms_inputs works", {
  # Check N_samples ----
  expect_error(
    check_build_monte_carlo_fcms_inputs(sample_fcms$large_fcms$tfn_fcms, N_samples = "a", include_zeroes = TRUE, show_progress = TRUE)
  )
  expect_error(
    check_build_monte_carlo_fcms_inputs(sample_fcms$large_fcms$tfn_fcms, N_samples = 100.5, include_zeroes = TRUE, show_progress = TRUE)
  )
  expect_no_error(
    check_build_monte_carlo_fcms_inputs(sample_fcms$large_fcms$tfn_fcms, N_samples = 1001, include_zeroes = TRUE, show_progress = TRUE)
  )
  # ----

  # Check include_zeroes
  expect_error(
    check_build_monte_carlo_fcms_inputs(sample_fcms$large_fcms$tfn_fcms, N_samples = 1001, include_zeroes = 109, show_progress = TRUE)
  )
  expect_no_error(
    check_build_monte_carlo_fcms_inputs(sample_fcms$large_fcms$tfn_fcms, N_samples = 1001, include_zeroes = FALSE, show_progress = TRUE)
  )
  # ----
})


test_that("check_monte_carlo_bootstrap_inputs works", {
  # Check ci_centering_function ----
  expect_warning(
    check_monte_carlo_bootstrap_inputs(confidence_interval = 0.95, num_ci_bootstraps = 100, n_cores = 2)
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "wrong", confidence_interval = 0.95, num_ci_bootstraps = 100)
  )
  # ----

  # Chcek confidence_interval ----
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = "a", num_ci_bootstraps = 100)
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 100, num_ci_bootstraps = 100)
  )
  # ----

  # Chcek confidence_interval ----
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = "a")
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 100.1)
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = -1)
  )
  # ----

  # Check n_cores
  expect_warning(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 100)
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 100, n_cores = 200)
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 100, n_cores = "a")
  )
  expect_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 100, n_cores = -2)
  )
  expect_no_error(
    check_monte_carlo_bootstrap_inputs(ci_centering_function = "mean", confidence_interval = 0.95, num_ci_bootstraps = 10000, n_cores = 2)
  )
})

