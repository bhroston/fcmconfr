

################################################################################
# test-utility.R
#
# Unit tests for functions in utility.R, ordered as they appear in the source
# file.
#
# These functions do not facilitate a specific analysis, but are rather tools
# to navigate throughout the package
#
#   - get_adj_matrices_input_type
#   - get_node_IDs_from_input
#   - standardize_adj_matrices
#
################################################################################


test_that("get_fcm_class_from_adj_matrix works", {

  # Confirm error if elements are non-numeric (and not ivfn's or tfn's)
  test_element <- structure(.Data = "a", class = "Different")
  test_mat <- data.frame(
    c(test_element, test_element),
    c(test_element, test_element)
  )
  expect_error(get_fcm_class_from_adj_matrix(test_mat))

  test_mat <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  expect_identical(get_fcm_class_from_adj_matrix(test_mat), "conventional")

  test_mat <- sample_fcms$simple_fcms$ivfn_fcms[[1]]
  expect_identical(get_fcm_class_from_adj_matrix(test_mat), "ivfn")

  test_mat <- sample_fcms$simple_fcms$tfn_fcms[[1]]
  expect_identical(get_fcm_class_from_adj_matrix(test_mat), "tfn")

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "get_fcm_class_from_adj_matrix")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})





test_that("get_adj_matrices_input_type works", {
  # Individual Conventional Adj. Matrix ----
  adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  input_type <- get_adj_matrices_input_type(adj_matrix_1)
  expect_false(input_type$adj_matrices_input_is_list)
  expect_identical(input_type$object_types_in_list, c("conventional", "data.frame"))

  # Incorrect data type in Adj. Matrix
  bad_adj_matrix <- data.frame(sample_fcms$large_fcms$conventional_fcms[[1]])
  bad_adj_matrix[2, 4] <- "a"
  expect_error(
    get_adj_matrices_input_type(bad_adj_matrix)
  )

  # List of Multiple Conventional FCM Adj. Matrices ----
  adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  fcms <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  input_type <- get_adj_matrices_input_type(fcms)
  expect_true(input_type$adj_matrices_input_is_list)
  expect_identical(input_type$object_types_in_list, c("conventional", "data.frame"))


  # List of Multiple IVFN FCM Adj. Matrices ----
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_4, upper_adj_matrix_4)
  fcms_w_ivfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  input_type <- get_adj_matrices_input_type(fcms_w_ivfns)
  expect_true(input_type$adj_matrices_input_is_list)
  expect_identical(input_type$object_types_in_list, "ivfn")


  # List of Multiple TFN FCM Adj. Matrices ----
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  mode_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.7, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_tfns(lower_adj_matrix_2, mode_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  mode_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_tfns(lower_adj_matrix_3, mode_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  mode_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_tfns(lower_adj_matrix_4, mode_adj_matrix_4, upper_adj_matrix_4)
  fcms_w_tfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  input_type <- get_adj_matrices_input_type(fcms_w_tfns)
  expect_true(input_type$adj_matrices_input_is_list)
  expect_identical(input_type$object_types_in_list, "tfn")


  df_adj_matrix <- data.frame(
    "A" = c(0, 1),
    "B" = c(1, 0)
  )
  dt_adj_matrix <- data.table::data.table(
    "A" = c(0, 1),
    "B" = c(1, 0)
  )
  adj_matrices <- list(df_adj_matrix, dt_adj_matrix)
  expect_error(get_adj_matrices_input_type(adj_matrices))

  expect_identical(get_adj_matrices_input_type(dt_adj_matrix)$object_types_in_list, c("conventional", "data.table"))

  tib_adj_matrix <- tibble::tibble(
    "A" = c(0, 1),
    "B" = c(0, 1)
  )
  expect_identical(get_adj_matrices_input_type(tib_adj_matrix)$object_types_in_list, c("conventional", "tibble"))

  expect_error(get_adj_matrices_input_type(list("A", "B")))

  df_adj_matrix <- data.frame(
    "A" = c(0, 1),
    "B" = c("A", 0)
  )
  expect_error(get_adj_matrices_input_type(df_adj_matrix))
})


test_that("get_node_IDs_from_input works", {
  test_adj_matrix <- data.frame(
    "A" = c(0, 0.36, 0.45, -0.90, 0),
    "B" = c(-0.4, 0, 0, 0, 0.6),
    "C" = c(-0.25, 0, 0, 0, 0),
    "D" = c(0, 0, 0, 0, 0.3),
    "E" = c(0.3, 0, 0, 0, 0)
  )

  nodes <- get_node_IDs_from_input(test_adj_matrix)
  expect_identical(nodes, c("A", "B", "C", "D", "E"))

  colnames(test_adj_matrix) <- NULL
  nodes <- get_node_IDs_from_input(test_adj_matrix)
  expect_identical(nodes, c("C1", "C2", "C3", "C4", "C5"))
})


test_that("standardize_adj_matrices works", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.25, 0, 1),
    "C" = c(0, 0.7, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.75, 0)
  )
  test_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.3, 0),
    "B" = c(0.5, 0, 0, 0.6),
    "E" = c(0, 0, 0, 0),
    "F" = c(1, 0, 1, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  standardized_adj_matrices <- standardize_adj_matrices(test_fcms)
  expect_equal(unique(lapply(standardized_adj_matrices, colnames)), list(c("A", "B", "C", "D", "E", "F")))


  test_adj_matrix_5 <- data.frame(
    "A" = c(0, 1, 0),
    "B" = c(1, 0, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4, test_adj_matrix_5)
  expect_error(standardize_adj_matrices(test_fcms))

  test_adj_matrix_6 <- data.frame(
    "A" = c(0, 1),
    "B" = c(1, 1)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_6)
  expect_equal(length(unique(unlist(lapply(standardize_adj_matrices(test_fcms), dim)))), 1)

  expected_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0, 0, 0.3, 0),
    "B" = c(0.5, 0, 0, 0, 0, 0.6),
    "C" = c(0, 0, 0, 0, 0, 0),
    "D" = c(0, 0, 0, 0, 0, 0),
    "E" = c(0, 0, 0, 0, 0, 0),
    "F" = c(1, 0, 0, 0, 1, 0)
  )
  expect_equal(standardized_adj_matrices[[4]], expected_adj_matrix_4)


  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.25, 0, 0.8),
    "C" = c(0, 0.7, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.45, 0, 1),
    "C" = c(0, 0.9, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.75, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.8, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.3, 0),
    "B" = c(0.5, 0, 0, 0.6),
    "E" = c(0, 0, 0, 0),
    "F" = c(0.8, 0, 0.8, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.4, 0),
    "B" = c(0.7, 0, 0, 0.8),
    "E" = c(0, 0, 0, 0),
    "F" = c(1, 0, 1, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_4, upper_adj_matrix_4)
  test_fcms_w_ivfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  standardized_adj_matrices <- standardize_adj_matrices(test_fcms_w_ivfns)

  expect_equal(standardized_adj_matrices[[3]][2, 4][[1]], ivfn(0.75, 0.8))


  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.25, 0, 0.8),
    "C" = c(0, 0.7, 0)
  )
  mode_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.3, 0, 0.9),
    "C" = c(0, 0.8, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(0.45, 0, 1),
    "C" = c(0, 0.9, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_tfns(lower_adj_matrix_2, mode_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.75, 0)
  )
  mode_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.77, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.8, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_tfns(lower_adj_matrix_3, mode_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.3, 0),
    "B" = c(0.5, 0, 0, 0.6),
    "E" = c(0, 0, 0, 0),
    "F" = c(0.8, 0, 0.8, 0)
  )
  mode_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.35, 0),
    "B" = c(0.6, 0, 0, 0.7),
    "E" = c(0, 0, 0, 0),
    "F" = c(0.9, 0, 0.9, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0, 0.4, 0),
    "B" = c(0.7, 0, 0, 0.8),
    "E" = c(0, 0, 0, 0),
    "F" = c(1, 0, 1, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_tfns(lower_adj_matrix_4, mode_adj_matrix_4, upper_adj_matrix_4)

  test_fcms_w_tfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)

  standardized_adj_matrices <- standardize_adj_matrices(test_fcms_w_tfns)

  expect_equal(standardized_adj_matrices[[3]][2, 4][[1]], tfn(0.75, 0.77, 0.8))

})


test_that("get_inferences works", {

  invisible(capture.output(
    conventional_fcmconfr <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(0, 0, 1, 0, 0, 0, 0),
      clamping_vector = c(0, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'tanh',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 10000,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "mean",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = TRUE
    )
  ))

  expect_error(get_inferences(12413))
  expect_error(get_inferences(conventional_fcmconfr, analysis = "not correct"))

  test_get_inferences <- get_inferences(conventional_fcmconfr)
  expect_equal(names(test_get_inferences), c("individual_inferences", "aggregate_inferences", "mc_inferences", "mc_CIs_and_quantiles"))
  test_get_inferences <- get_inferences(conventional_fcmconfr, analysis = c("individual", "aggregate"))
  expect_equal(names(test_get_inferences), c("individual_inferences", "aggregate_inferences"))

  invisible(capture.output(
    ivfn_fcmconfr <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(0, 0, 1, 0, 0, 0, 0),
      clamping_vector = c(0, 0, 0, 0, 0, 0, 0),
      activation = 'rescale',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = mean,
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = TRUE
    )
  ))
  expect_no_error(get_inferences(ivfn_fcmconfr))

  invisible(capture.output(
    tfn_fcmconfr <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'rescale',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = mean,
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = TRUE
    )
  ))
  expect_no_error(get_inferences(tfn_fcmconfr))
})


#######

# # test_that("here works for R CMD Check", {
# #   expect_no_error(here::here())
# # })
#
#
#
