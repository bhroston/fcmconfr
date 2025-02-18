

################################################################################
# test-utility.R
#
# Unit tests for functions in utility.R, ordered as they appear in the source
# file.
#
# These functions do not facilitate a specific analysis, but are rather tools
# to navigate throughout the package
#
#   - check_if_local_machine_has_access_to_parallel_processing_functionalities
#   - check_if_local_machine_has_access_to_show_progress_functionalities
#   - get_adj_matrices_input_type
#   - get_adj_matrix_from_edgelist
#   - get_edgelist_from_adj_matrix
#   - get_node_IDs_from_input
#   - standardize_adj_matrices
#
################################################################################


test_that("check_if_local_machine_has_access_to_parallel_processing_functionalities works", {
  expect_no_error(check_if_local_machine_has_access_to_parallel_processing_functionalities(use_parallel = TRUE, use_show_progress = TRUE))
  expect_no_error(check_if_local_machine_has_access_to_parallel_processing_functionalities(use_parallel = TRUE, use_show_progress = FALSE))
  expect_no_error(check_if_local_machine_has_access_to_parallel_processing_functionalities(use_parallel = FALSE, use_show_progress = FALSE))
  expect_no_error(check_if_local_machine_has_access_to_parallel_processing_functionalities(use_parallel = FALSE, use_show_progress = TRUE))
})


test_that("check_if_local_machine_has_access_to_show_progress_functionalities works", {
  expect_no_error(check_if_local_machine_has_access_to_show_progress_functionalities(use_parallel = TRUE, use_show_progress = TRUE))
  expect_no_error(check_if_local_machine_has_access_to_show_progress_functionalities(use_parallel = TRUE, use_show_progress = FALSE))
  expect_no_error(check_if_local_machine_has_access_to_show_progress_functionalities(use_parallel = FALSE, use_show_progress = FALSE))
  expect_no_error(check_if_local_machine_has_access_to_show_progress_functionalities(use_parallel = FALSE, use_show_progress = TRUE))
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


test_that("get_adj_matrix_from_edgelist works", {
  test_edgelist <- data.frame(
    from = c("A"),
    to = c("B"),
    weight = c(0.55)
  )
  test_adj_matrix <- get_adj_matrix_from_edgelist(test_edgelist, source_colname = "from", target_colname = "to")
  expected_adj_matrix <- data.frame(A = c(0, 0), B = c(0.55, 0))
  rownames(expected_adj_matrix) <- c("A", "B")
  ### Check this test case for error or function pass with "to" and "from" instead of "source" and "target"
  expect_equal(test_adj_matrix, expected_adj_matrix)

  # Test from Koutsellis et al. 2022 - https://doi.org/10.1007/s12351-022-00717-x
  # Confirmed to reproduce results
  test_source_nodes <- c(
    "C1", "C1", "C1", "C2", "C2", "C3", "C3", "C3", "C4", "C4",
    "C4", "C5", "C6", "C7", "C8", "C8", "C9", "C10", "C10", "C11",
    "C12", "C13", "C14", "C14", "C15", "C15", "C15", "C15", "C16", "C16",
    "C17", "C17", "C18", "C19", "C20", "C20", "C21", "C22", "C23", "C23",
    "C24", "C25", "C28", "C29"
  )
  test_target_nodes <- c(
    "C15", "C20", "C23", "C12", "C25", "C14", "C16", "C23", "C15", "C20",
    "C23", "C16", "C15", "C15", "C10", "C12", "C23", "C11", "C13", "C26",
    "C14", "C28", "C13", "C23", "C17", "C18", "C24", "C30", "C15", "C28",
    "C21", "C22", "C19", "C20", "C26", "C28", "C27", "C29", "C19", "C24",
    "C29", "C15", "C27", "C27"
  )
  test_edge_weights <- c(
    -0.442, -0.375, -0.348, 0.549, 0.706, -0.421, -0.132, -0.245, -0.52, 0.261,
    -0.29, 0.651, 0.487, 0.229, 0.776, 0.319, 0.792, 0.319, 0.391, -0.402,
    -0.381, 0.481, 0.097, 0.11, -0.852, 0.902, 0.226, -0.852, -0.719, -0.274,
    0.722, 0.888, -0.521, -0.311, -0.932, -0.419, 0.322, 0.21, 0.9, 0.189,
    0.196, -0.311, 0.481, 0.378
  )

  edgelist <- data.frame(
    "source" = test_source_nodes,
    "target" = test_target_nodes,
    "weight" = test_edge_weights
  )

  # Confirm return the same output as igraph
  # g <- igraph::graph_from_data_frame(edgelist, directed = TRUE)
  # igraph_adj_matrix <- data.frame(igraph::as_adjacency_matrix(g, attr = "weight", sparse = FALSE))
  # test_adj_matrix <- get_adj_matrix_from_edgelist(edgelist)
  # expect_equal(igraph_adj_matrix, test_adj_matrix)
  expect_no_error(get_adj_matrix_from_edgelist(edgelist))

  expect_error(get_adj_matrix_from_edgelist(edgelist, source_colname = "wrong_sourcename"))
  expect_error(get_adj_matrix_from_edgelist(edgelist, node_order = c("A", "B", "C")))

  edgelist <- data.frame(
    "source" = c("A", "B", "C"),
    "target" = c("B", "C", "A"),
    "weight" = c(1, 1, 1)
  )
  expect_identical(colnames(get_adj_matrix_from_edgelist(edgelist, node_order = c("C", "B", "A"))), c("C", "B", "A"))
})


test_that("get_edgelist_from_adj_matrix works", {
  test_adj_matrix <- data.frame(
    "C1" = c(0, 0.36, 0.45, -0.90, 0),
    "C2" = c(-0.4, 0, 0, 0, 0.6),
    "C3" = c(-0.25, 0, 0, 0, 0),
    "C4" = c(0, 0, 0, 0, 0.3),
    "C5" = c(0.3, 0, 0, 0, 0)
  )

  goal_edgelist <- data.frame(
    "source" = c("C2", "C3", "C4", "C1", "C5", "C1", "C5", "C1"),
    "target" = c("C1", "C1", "C1", "C2", "C2", "C3", "C4", "C5"),
    "weight" = c(0.36, 0.45, -0.90, -0.40, 0.60, -0.25, 0.30, 0.30)
  )

  expect_identical(get_edgelist_from_adj_matrix(test_adj_matrix), goal_edgelist)

  df_adj_matrix <- data.frame(
    "A" = c(0, 1, 0),
    "B" = c(1, 0, 0)
  )
  expect_error(get_edgelist_from_adj_matrix(df_adj_matrix))

  df_adj_matrix <- data.frame(
    "A" = c(0, 1),
    "B" = c(1, "a")
  )
  expect_error(get_edgelist_from_adj_matrix(df_adj_matrix))

  df_adj_matrix <- data.frame(
    c(0, 1),
    c(1, 0)
  )
  colnames(df_adj_matrix) <- NULL
  expect_identical(get_edgelist_from_adj_matrix(df_adj_matrix)$source, c("C2", "C1"))
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
