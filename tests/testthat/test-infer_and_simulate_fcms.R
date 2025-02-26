
# functions_to_check <- c("infer_fcm_set")
# yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
# res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
# beepr::beep()

requireNamespace("Matrix")

# All checks pass
test_that("infer_fcm_set works", {

  # functions_to_check <- c("infer_fcm_set")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
  # beepr::beep()

  # lambda1 <- 1
  # lambda2 <- lambda1 + 100*.Machine$double.eps
  # lambda1_test <- infer_fcm_set(adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
  #                               initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  #                               clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  #                               activation = "modified-kosko",
  #                               squashing = "sigmoid",
  #                               lambda = lambda1,
  #                               point_of_inference = "final",
  #                               max_iter = 100,
  #                               min_error = 1e-5,
  #                               parallel = FALSE,
  #                               show_progress = FALSE,
  #                               silent = FALSE)
  # lambda2_test <- infer_fcm_set(adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
  #                               initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  #                               clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  #                               activation = "modified-kosko",
  #                               squashing = "sigmoid",
  #                               lambda = lambda2,
  #                               point_of_inference = "final",
  #                               max_iter = 100,
  #                               min_error = 1e-5,
  #                               parallel = FALSE,
  #                               show_progress = FALSE,
  #                               silent = FALSE)


  # Confirm no warning messages when silent = TRUE
  test_fcm_set <- sample_fcms$simple_fcms$conventional_fcms
  test_fcm_set <- lapply(test_fcm_set, function(mat) structure(.Data = as.matrix(mat), class = "Different"))
  expect_no_error(
    sink(file = file(nullfile()), type = "message"),
    infer_fcm_set(adj_matrices = test_fcm_set,
                  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                  activation = "modified-kosko",
                  squashing = "sigmoid",
                  lambda = 1,
                  point_of_inference = "final",
                  max_iter = 100,
                  min_error = 1e-5,
                  parallel = FALSE,
                  show_progress = FALSE,
                  silent = TRUE),
    sink()
  )

  # Confirm works if only a single adj matrix given
  test_fcm <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  expect_no_error(infer_fcm_set(adj_matrices = test_fcm,
                                initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                activation = "modified-kosko",
                                squashing = "sigmoid",
                                lambda = 1,
                                point_of_inference = "final",
                                max_iter = 100,
                                min_error = 1e-5,
                                parallel = FALSE,
                                show_progress = FALSE,
                                silent = FALSE))


  # Confirm same results across different parallel/show_progress algorithms ----
  test_fcm_set <- sample_fcms$simple_fcms$conventional_fcms
  sink(file = file("output.Rout"), type = "output")
  parallel_and_show_progress <- infer_fcm_set(
    adj_matrices = test_fcm_set,
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = "modified-kosko",
    squashing = "sigmoid",
    lambda = 1,
    point_of_inference = "final",
    max_iter = 100,
    min_error = 1e-5,
    parallel = TRUE,
    n_cores = 2,
    show_progress = TRUE
  )
  parallel_and_not_show_progress <- infer_fcm_set(
    adj_matrices = test_fcm_set,
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = "modified-kosko",
    squashing = "sigmoid",
    lambda = 1,
    point_of_inference = "final",
    max_iter = 100,
    min_error = 1e-5,
    parallel = TRUE,
    n_cores = 2,
    show_progress = FALSE
  )
  not_parallel_and_show_progress <- infer_fcm_set(
    adj_matrices = test_fcm_set,
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = "modified-kosko",
    squashing = "sigmoid",
    lambda = 1,
    point_of_inference = "final",
    max_iter = 100,
    min_error = 1e-5,
    parallel = FALSE,
    show_progress = TRUE
  )
  not_parallel_and_not_show_progress <- infer_fcm_set(
    adj_matrices = test_fcm_set,
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = "modified-kosko",
    squashing = "sigmoid",
    lambda = 1,
    point_of_inference = "final",
    max_iter = 100,
    min_error = 1e-5,
    parallel = FALSE,
    show_progress = FALSE
  )
  expect_identical(parallel_and_show_progress, parallel_and_not_show_progress)
  expect_identical(parallel_and_not_show_progress, not_parallel_and_show_progress)
  expect_identical(not_parallel_and_show_progress, not_parallel_and_not_show_progress)
  expect_identical(not_parallel_and_not_show_progress, parallel_and_show_progress)
  sink(file = file("output.Rout"))
  # ----

  # Confirm also works with IVFN and TFN fcm lists ----
  expect_no_error(infer_fcm_set(adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
                                  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                  activation = "modified-kosko",
                                  squashing = "sigmoid",
                                  lambda = 1,
                                  point_of_inference = "final",
                                  max_iter = 100,
                                  min_error = 1e-5,
                                  parallel = FALSE,
                                  show_progress = FALSE,
                                  silent = TRUE))

  expect_no_error(infer_fcm_set(adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
                                initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                activation = "modified-kosko",
                                squashing = "sigmoid",
                                lambda = 1,
                                point_of_inference = "final",
                                max_iter = 100,
                                min_error = 1e-5,
                                parallel = FALSE,
                                show_progress = FALSE,
                                silent = TRUE))
  # ----
})


# All checks pass
test_that("infer_fcm works", {
  # See infer_conventional_fcm and infer_ivfn_or_tfn_fcm tests for additional info
  expect_true(TRUE) # Just so this isn't an empty test

  # functions_to_check <- c("infer_fcm")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


# All checks pass
test_that("infer_conventional_fcm works", {
  adj_matrix <- data.frame(
    A = c(0, 1, 1),
    B = c(1, 0, -1),
    C = c(0, -1, 0)
  )
  # Ensure same results as PyFCM package (https://github.com/payamaminpour/PyFCM)
  # Kosko
  # PyFCM & MentalModeler: infer_scenario - infer_steady()
  PyFCM_infer <- infer_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  expect_equal(unlist(round(PyFCM_infer$inferences, 2)), c(1, 0.07, -0.02), ignore_attr = TRUE)

  # Modified-Kosko
  # PyFCM: infer_scenario - infer_steady()
  PyFCM_infer <- infer_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  expect_equal(unlist(round(PyFCM_infer$inferences, 2)), c(1, 0.02, -0.01), ignore_attr = TRUE)

  # Rescale
  # PyFCM: infer_scenario - infer_steady()
  PyFCM_infer <- infer_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "rescale", squashing = "sigmoid", point_of_inference = "final", lambda = 1, max_iter = 1000,  min_error = 0.00001)
  expect_equal(unlist(round(PyFCM_infer$inferences, 2)), c(1, 0.40, -0.29), ignore_attr = TRUE)


  # Check infer_conventional_fcm cannot take ivfn matrices
  n_nodes <- unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]]))
  expect_error( # When input adj_matrix is not a conventional fcm
    infer_conventional_fcm(sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = rep(1, n_nodes), clamping_vector = rep(0, n_nodes), activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
})


# All checks pass
test_that("infer_ivfn_or_tfn_fcm works", {
  # functions_to_check <- c("infer_ivfn_or_tfn_fcm")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)

  lower_adj_matrix <- data.frame(
    A = c(0, 0.2, 0.4),
    B = c(0.6, 0, -1),
    C = c(0, -1, 0)
  )
  mode_adj_matrix <- data.frame(
    A = c(0, 0.6, 0.8),
    B = c(0.8, 0, -0.6),
    C = c(0, -0.4, 0)
  )
  upper_adj_matrix <- data.frame(
    A = c(0, 0.8, 1),
    B = c(1, 0, -0.2),
    C = c(0, -0.2, 0)
  )
  test_ivfn_adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  test_tfn_adj_matrix <- make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix)

  ivfn_infer <- infer_ivfn_or_tfn_fcm(test_ivfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  tfn_infer <- infer_ivfn_or_tfn_fcm(test_tfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)


  # Check infer_ivfn_or_tfn_fcm cannot take conventional matrices
  expect_error(
    infer_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1), clamping_vector = c(0, 1, 0, 0, 0, 0, 0, 0, 0), activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  )

  # Check additional example
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.2, 0, 0, 0.9, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.3, 0.9, -0.5, 0, -0.5, 0),
    C5 = c(0.5, 0, 0, -0.3, 0, 0),
    C6 = c(0, -0.4, 0, 0, -0.5, 0)
  )
  adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)

  test_sim <- infer_ivfn_or_tfn_fcm(adj_matrix,
                                    initial_state_vector = c(1, 1, 1, 1, 1, 1),
                                    clamping_vector = c(1, 0, 0, 0, 0, 0),
                                    activation = "kosko",
                                    squashing = "sigmoid",
                                    lambda = 1,
                                    point_of_inference = "final")
  test_baseline <- simulate_ivfn_or_tfn_fcm(adj_matrix,
                                            initial_state_vector = c(1, 1, 1, 1, 1, 1),
                                            clamping_vector = c(0, 0, 0, 0, 0, 0),
                                            activation = "kosko",
                                            squashing = "sigmoid",
                                            lambda = 1,
                                            point_of_inference = "final")
  test_scenario <- simulate_ivfn_or_tfn_fcm(adj_matrix,
                                            initial_state_vector = c(1, 1, 1, 1, 1, 1),
                                            clamping_vector = c(1, 0, 0, 0, 0, 0),
                                            activation = "kosko",
                                            squashing = "sigmoid",
                                            lambda = 1,
                                            point_of_inference = "final")

  test_baseline_final_state <- test_baseline$inferences
  test_scenario_final_state <- test_scenario$inferences

  test_baseline_final_state_dists <- convert_fuzzy_set_elements_in_matrix_to_distributions(test_baseline_final_state, "ivfn", 1000)
  test_scenario_final_state_dists <- convert_fuzzy_set_elements_in_matrix_to_distributions(test_scenario_final_state, "ivfn", 1000)

  inferences_as_dists <- vector(mode = "list", length = length(test_baseline_final_state))
  for (i in seq_along(test_baseline_final_state)) {
    inferences_as_dists[[i]] <- test_scenario_final_state_dists[i][[1]][[1]] - test_baseline_final_state_dists[i][[1]][[1]]
  }

  expected_inference_lowers <- unlist(lapply(inferences_as_dists, min))
  expected_inference_uppers <- unlist(lapply(inferences_as_dists, max))

  actual_inference_lowers <- test_sim$inference_df$lower
  actual_inference_uppers <- test_sim$inference_df$upper

  error_in_lowers <- sum(abs(expected_inference_lowers - actual_inference_lowers))
  error_in_uppers <- sum(abs(expected_inference_uppers - actual_inference_uppers))
  total_error <- error_in_lowers + error_in_uppers

  expect_lt(total_error, 0.1)

  # Check inference function with all 0's in clamping vector is same as baseline simulation
  zero_clamping_vector_inference <- infer_ivfn_or_tfn_fcm(adj_matrix,
                        initial_state_vector = c(1, 1, 1, 1, 1, 1),
                        clamping_vector = c(0, 0, 0, 0, 0, 0),
                        activation = "kosko",
                        squashing = "sigmoid",
                        lambda = 1,
                        point_of_inference = "final")
  inference_lowers <- vapply(zero_clamping_vector_inference$inferences, function(x) x[[1]]$lower, numeric(1))
  simulation_lowers <- vapply(test_baseline$inferences, function(x) x[[1]]$lower, numeric(1))
  expect_identical(inference_lowers, simulation_lowers)

  inference_uppers <- vapply(zero_clamping_vector_inference$inferences, function(x) x[[1]]$upper, numeric(1))
  simulation_uppers <- vapply(test_baseline$inferences, function(x) x[[1]]$upper, numeric(1))
  expect_identical(inference_uppers, simulation_uppers)


  # Compare Ex. Matrices IVFN and TFN Sim Results
  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector[3] <- 1
  salinization_sim_ivfn <- infer_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$ivfn_fcms[[1]],
                                                initial_state_vector = test_initial_state_vector,
                                                clamping_vector = test_clamping_vector,
                                                activation = "modified-kosko",
                                                squashing = "sigmoid",
                                                lambda = 1,
                                                point_of_inference = "final",
                                                max_iter = 1000,
                                                min_error = 1e-5)

  salinization_sim_tfn <- infer_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$tfn_fcms[[1]],
                                    initial_state_vector = test_initial_state_vector,
                                    clamping_vector = test_clamping_vector,
                                    activation = "modified-kosko",
                                    squashing = "sigmoid",
                                    lambda = 1,
                                    point_of_inference = "final",
                                    max_iter = 1000,
                                    min_error = 1e-5)
  lower_differences <- sum(abs(salinization_sim_ivfn$inference$lower - salinization_sim_tfn$inference$lower))^2
  upper_differences <- sum(abs(salinization_sim_ivfn$inference$upper - salinization_sim_tfn$inference$upper))^2
  crisp_differences <- sum(abs(salinization_sim_ivfn$inference$crisp - salinization_sim_tfn$inference$crisp))^2
  expect_true(lower_differences < 1e-3 & upper_differences < 1e-3 & crisp_differences < 1e-3)

})


# All checks pass
test_that("simulate_fcm works", {
  # See simulate_conventional_fcm and simulate_ivfn_or_tfn_fcm tests for additional info
  expect_true(TRUE) # Just so this isn't an empty test
})


# All checks pass
test_that("simulate_conventional_fcm works", {
  # functions_to_check <- c("simulate_conventional_fcm")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
  # beepr::beep()

  adj_matrix <- data.frame(
    A = c(0, 1, 1),
    B = c(1, 0, -1),
    C = c(0, -1, 0)
  )
  # Ensure same results as PyFCM package (https://github.com/payamaminpour/PyFCM)
  # Kosko
  # PyFCM: infer_steady() - pulse, point_of_inference = "final"
  PyFCM_SteadyState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(0, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  expect_equal(unlist(round(PyFCM_SteadyState$inferences, 2)), c(0.72, 0.59, 0.36), ignore_attr = TRUE)
  # PyFCM: infer_scenario() - clamping, point_of_inference = "final"
  PyFCM_ScenarioState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1)
  expect_equal(unlist(round(PyFCM_ScenarioState$inferences, 2)), c(1, 0.66, 0.34), ignore_attr = TRUE)

  # Modified-Kosko
  # PyFCM: infer_steady() - pulse, point_of_inference = "final"
  PyFCM_SteadyState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(0, 0, 0), activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  expect_equal(unlist(round(PyFCM_SteadyState$inferences, 2)), c(0.89, 0.78, 0.41), ignore_attr = TRUE)
  # PyFCM: infer_scenario() - clamping, point_of_inference = "final"
  PyFCM_ScenarioState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1)
  expect_equal(unlist(round(PyFCM_ScenarioState$inferences, 2)), c(1, 0.80, 0.40), ignore_attr = TRUE)

  # Rescale
  # PyFCM: infer_steady() - pulse, point_of_inference = "final"
  PyFCM_SteadyState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(0, 0, 0), activation = "rescale", squashing = "sigmoid", point_of_inference = "final", lambda = 1, max_iter = 1000)
  expect_equal(unlist(round(PyFCM_SteadyState$inferences, 2)), c(0.5, 0.52, 0.48), ignore_attr = TRUE)
  # PyFCM: infer_scenario() - clamping, point_of_inference = "final"
  PyFCM_ScenarioState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "rescale", squashing = "sigmoid", point_of_inference = "final", lambda = 1)
  expect_equal(unlist(round(PyFCM_ScenarioState$inferences, 2)), c(1, 0.92, 0.19), ignore_attr = TRUE)

  # Confirm works with point_of_inference == "peak"
  peak_SteadyState <- simulate_fcm(adj_matrix, initial_state_vector = c(1, 0, 0), clamping_vector = c(0, 0, 0), activation = "rescale", squashing = "sigmoid", point_of_inference = "peak", lambda = 1, min_error = 0.00001)
  expect_equal(unlist(round(peak_SteadyState$inferences, 2)), c(1, 0.73, 0.5), ignore_attr = TRUE)
  expect_warning( # For 'peak' when initial_state_vector = c(1, 1, ..., 1)
    peak_ScenarioState <- simulate_conventional_fcm(adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "rescale", squashing = "sigmoid", point_of_inference = "peak", lambda = 1, min_error = 0.00001, skip_checks = FALSE)
  )

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector[3] <- 1
  # Check infer_conventional_fcm cannot take ivfn matrices
  expect_error(
    simulate_conventional_fcm(sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  )
  # Check warning message if simulation runs longer than max_iter
  expect_warning(expect_warning(
    test_res <- simulate_conventional_fcm(sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "tanh", lambda = 1, point_of_inference = "final")
  ))
})


# All checks pass
test_that("simulate_ivfn_or_tfn_fcm works", {
  # functions_to_check <- c("simulate_ivfn_or_tfn_fcm works")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
  # beepr::beep()

  lower_adj_matrix <- data.frame(
    A = c(0, 0.2, 0.4),
    B = c(0.6, 0, -1),
    C = c(0, -1, 0)
  )
  mode_adj_matrix <- data.frame(
    A = c(0, 0.6, 0.8),
    B = c(0.8, 0, -0.6),
    C = c(0, -0.4, 0)
  )
  upper_adj_matrix <- data.frame(
    A = c(0, 0.8, 1),
    B = c(1, 0, -0.2),
    C = c(0, -0.2, 0)
  )
  test_ivfn_adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  test_tfn_adj_matrix <- make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix)

  # IVFN - Kosko, Sigmoid, Final
  ivfn_kosko_sigmoid_final <- simulate_fcm(test_ivfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(0, 0, 0), activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  inferences_lowers <- round(apply(ivfn_kosko_sigmoid_final$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_uppers <- round(apply(ivfn_kosko_sigmoid_final$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(0.57, 0.49, 0.36), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(0.70, 0.63, 0.47), ignore_attr = TRUE)

  # IVFN - Modified-Kosko, Sigmoid, Peak
  ivfn_modifiedkosko_sigmoid_peak <- simulate_fcm(test_ivfn_adj_matrix, initial_state_vector = c(1, 0, 0), clamping_vector = c(0, 0, 0), activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "peak")
  inferences_lowers <- round(apply(ivfn_modifiedkosko_sigmoid_peak$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_uppers <- round(apply(ivfn_modifiedkosko_sigmoid_peak$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(1.00, 0.65, 0.42), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(1.00, 0.82, 0.61), ignore_attr = TRUE)

  # IVFN - Rescale, Sigmoid, Peak
  ivfn_rescale_sigmoid_peak <- simulate_fcm(test_ivfn_adj_matrix, initial_state_vector = c(1, 0, 0), clamping_vector = c(0, 0, 0), activation = "rescale", squashing = "sigmoid", lambda = 1, point_of_inference = "peak")
  inferences_lowers <- round(apply(ivfn_rescale_sigmoid_peak$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_uppers <- round(apply(ivfn_rescale_sigmoid_peak$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(1.00, 0.45, 0.50), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(1.00, 0.73, 0.50), ignore_attr = TRUE)

  # TFN - Kosko, Tanh, Final
  expect_warning( # Should see a limit cycle behavior
    tfn_kosko_tanh_peak <- simulate_fcm(test_tfn_adj_matrix, initial_state_vector = c(1, 0, 0), clamping_vector = c(0, 0, 0), activation = "kosko", squashing = "tanh", lambda = 1, point_of_inference = "peak", min_error = 1e-3)
  )
  inferences_lowers <- round(apply(tfn_kosko_tanh_peak$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_modes <- round(apply(tfn_kosko_tanh_peak$inferences, 2, function(element) element[[1]]$mode), 2)
  inferences_uppers <- round(apply(tfn_kosko_tanh_peak$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(1, 0.54, 0.05), ignore_attr = TRUE)
  expect_equal(inferences_modes, c(1, 0.66, 0.1), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(1, 0.76, 0.25), ignore_attr = TRUE)

  # TFN - Modified-Kosko, Sigmoid, Peak
  tfn_modifiedkosko_sigmoid_peak <- simulate_fcm(test_tfn_adj_matrix, initial_state_vector = c(1, 0, 0), clamping_vector = c(0, 0, 0), activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "peak")
  inferences_lowers <- round(apply(tfn_modifiedkosko_sigmoid_peak$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_modes <- round(apply(tfn_modifiedkosko_sigmoid_peak$inferences, 2, function(element) element[[1]]$mode), 2)
  inferences_uppers <- round(apply(tfn_modifiedkosko_sigmoid_peak$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(1.00, 0.65, 0.42), ignore_attr = TRUE)
  expect_equal(inferences_modes, c(1.00, 0.75, 0.57), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(1.00, 0.82, 0.61), ignore_attr = TRUE)

  # TFN - Rescale, Sigmoid, Final
  tfn_rescale_sigmoid_final <- simulate_fcm(test_tfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "rescale", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  inferences_lowers <- round(apply(tfn_rescale_sigmoid_final$inferences, 2, function(element) element[[1]]$lower), 2)
  inferences_modes <- round(apply(tfn_rescale_sigmoid_final$inferences, 2, function(element) element[[1]]$mode), 2)
  inferences_uppers <- round(apply(tfn_rescale_sigmoid_final$inferences, 2, function(element) element[[1]]$upper), 2)
  expect_equal(inferences_lowers, c(1.00, 0.77, 0.23), ignore_attr = TRUE)
  expect_equal(inferences_modes, c(1.00, 0.84, 0.37), ignore_attr = TRUE)
  expect_equal(inferences_uppers, c(1.00, 0.89, 0.43), ignore_attr = TRUE)

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector[3] <- 1
  # Check infer_ivfn_or_tfn_fcm cannot take conventional matrices
  expect_error(
    simulate_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, point_of_inference = "final", activation = "kosko", squashing = "sigmoid")
  )
})


# All checks pass (and autotest returns NULL)
test_that("get_next_state_vector works", {

  # functions_to_check <- c("get_next_state_vector")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
  # beepr::beep()

  # Tests for Conventional FCMs ----
  adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  # test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 0, 0, 0, 0, 0), activation = "kosko")
  test_next_state <- get_next_state_vector(adj_matrix, state_vector = c(1, 0, 0, 0, 0, 0), activation = "kosko", fcm_class = "conventional", skip_checks = FALSE)
  expect_equal(test_next_state[1, ], c(0, -0.85, 0, -0.7, 0.1, 0), ignore_attr = TRUE)

  # test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "modified-kosko")
  test_next_state <- get_next_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "modified-kosko", fcm_class = "conventional", skip_checks = FALSE)
  expect_equal(test_next_state[1, ], c(1, 0.5, 1, -1.1, 0.3, -0.9), ignore_attr = TRUE)

  # test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "rescale")
  test_next_state <- get_next_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "rescale", fcm_class = "conventional", skip_checks = FALSE)
  expect_equal(test_next_state[1, ], c(1, 0.5, 1, -1.1, 0.3, -0.9), ignore_attr = TRUE)
  # ----

  # Tests for IVFN FCMs ----
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.2, 0, 0, 0.9, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.3, 0.9, -0.5, 0, -0.5, 0),
    C5 = c(0.5, 0, 0, -0.3, 0, 0),
    C6 = c(0, -0.4, 0, 0, -0.5, 0)
  )
  adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  test_state_vector <- c(ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1))

  test_next_state <- get_next_state_vector(adj_matrix, state_vector = test_state_vector, activation = "kosko", fcm_class = "ivfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(ivfn(0, 0), ivfn(-0.5, 0.7), ivfn(0, 0), ivfn(-2.1, -0.4), ivfn(-0.7, 0.2), ivfn(-1.9, -0.9)), ignore_attr = TRUE)

  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "modified-kosko", fcm_class = "ivfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1)), ignore_attr = TRUE)

  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "rescale", fcm_class = "ivfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1)), ignore_attr = TRUE)

  test_state_vector <- c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1))
  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "rescale", fcm_class = "ivfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(ivfn(1, 1), ivfn(-2.2, 1.675), ivfn(1, 1), ivfn(-4.68, 0.23), ivfn(0.15, 3.1), ivfn(-4.415, -1.53)), ignore_attr = TRUE)
  # ----

  # Tests for TFN FCMs ----
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(-0.25, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  adj_matrix <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
  test_state_vector <- c(tfn(1, 1, 1), tfn(1, 1, 1))

  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "kosko", fcm_class = "tfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(tfn(0, 0, 0), tfn(-0.25, 0.5, 0.75)), ignore_attr = TRUE) # Test failing

  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "modified-kosko", fcm_class = "tfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(tfn(1, 1, 1), tfn(0.75, 1.5, 1.75)), ignore_attr = TRUE)

  test_next_state <- get_next_state_vector(adj_matrix, test_state_vector, activation = "rescale", fcm_class = "tfn", skip_checks = FALSE)
  expect_equal(test_next_state, c(tfn(1, 1, 1), tfn(0.75, 1.5, 1.75)), ignore_attr = TRUE)
  # ----
})


# All checks pass
test_that("squash works", {
  expect_error(squash(1, "squasher"))

  expect_error(squash(1, "sigmoid", lambda = 0))

  expect_equal(round(squash(1, "sigmoid", lambda = 1), 5), 0.73106)
  expect_equal(round(squash(1, "sigmoid", lambda = 0.5), 5), 0.62246)

  expect_equal(round(squash(1, "tanh", lambda = 1), 5), 0.76159)
  expect_equal(round(squash(1, "tanh", lambda = 0.5), 5), 0.46212)
})


# All checks pass
test_that("convert_element_to_ivfn_or_tfn_if_numeric works", {
  expect_equal(convert_element_to_ivfn_or_tfn_if_numeric(1, "ivfn"), ivfn(1, 1))
  expect_equal(convert_element_to_ivfn_or_tfn_if_numeric(1, "tfn"), tfn(1, 1, 1))
})


# All checks pass
test_that("convert_fuzzy_set_elements_in_matrix_to_distributions works", {
  adj_matrix <- data.frame(
    "A" = c(0, 1),
    "B" = c(1, 0)
  )
  expect_error(convert_fuzzy_set_elements_in_matrix_to_distributions(adj_matrix, "conventional", 1000))

  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.2, 0, 0, 0.9, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.3, 0.9, -0.5, 0, -0.5, 0),
    C5 = c(0.5, 0, 0, -0.3, 0, 0),
    C6 = c(0, -0.4, 0, 0, -0.5, 0)
  )
  adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  adj_matrix_w_distributions <- convert_fuzzy_set_elements_in_matrix_to_distributions(adj_matrix, "ivfn", 1000)
  test_dist <- adj_matrix_w_distributions[1, 2][[1]][[1]]
  test_dist_based_on <- ivfn(-0.85, -0.2)
  expect_gte(min(test_dist), test_dist_based_on$lower)
  expect_lte(max(test_dist), test_dist_based_on$upper)
  expect_equal(length(test_dist), 1000)

  expect_lt(abs(mean(test_dist) - (test_dist_based_on$lower + test_dist_based_on$upper)/2), 0.1)
  expect_lt(abs(var(test_dist) - ((test_dist_based_on$upper - test_dist_based_on$lower)^2)/12), 0.1)
})


# All checks pass
test_that("clean_simulation_output works", {
  adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  test_sim <- simulate_fcm(adj_matrix, c(1, 1, 1, 1, 1, 1), clamping_vector = c(1, 0, 0, 0, 0, 0), activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  clean_df <- clean_simulation_output(test_sim$state_vectors, c("C1", "C2", "C3", "C4", "C5", "C6"))
  expect_identical(colnames(clean_df), c("iter", "C1", "C2", "C3", "C4", "C5", "C6"))
})


# All checks pass (and autotest returns NULL)
test_that("check_simulation_inputs works", {

  # functions_to_check <- c("check_simulation_inputs")
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
  # beepr::beep()

  test_adj_matrix <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$ivfn_fcms[[1]])))
  test_clamping_vector[3] <- 1

  # Check for individual adj_matrix ----
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector)
  )
  # ----

  # Check adj_matrices ----
  expect_error(
    check_simulation_inputs(cbind(test_adj_matrix, sample_fcms$simple_fcms$conventional_fcms[[2]]))
  )
  test_sparseMatrix <- Matrix::Matrix(as.matrix(test_adj_matrix), sparse = TRUE)
  expect_warning(
    check_simulation_inputs(adj_matrix = test_sparseMatrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = test_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = test_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh",point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = test_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )

  # Confirm no error if class of adj. matrix is unusual
  test_adj_matrix <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  class(test_adj_matrix) <- NULL
  test_adj_matrix <- do.call(cbind, test_adj_matrix)
  test_adj_matrix <- structure(.Data = test_adj_matrix, class = "Different")
  expect_no_error(
    check_simulation_inputs(adj_matrix = test_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = 'sigmoid', point_of_inference = 'final')
  )

  test_lambda <- 1.00000000000000002
  lambda_test <- check_simulation_inputs(adj_matrix = test_adj_matrix, initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = 'sigmoid', lambda = test_lambda, point_of_inference = 'final')
  expect_equal(lambda_test$lambda, 1)
  # ----

  # Check initial_state_vector ----
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$tfn_fcms[[1]], initial_state_vector = c(), clamping_vector = test_clamping_vector, activation = "kosko",  squashing = "tanh",  point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = c(1, 1, 1), clamping_vector = test_clamping_vector, activation = "kosko",  squashing = "tanh", point_of_inference = "final")
  )
  bad_initial_state_vector <- test_initial_state_vector
  bad_initial_state_vector[3] <- "a"
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = bad_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko",  squashing = "tanh", point_of_inference = "final")
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  # ----

  # Check clamping_vector ----
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$tfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = c(), activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = c(0, 0, 1), activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  bad_clamping_vector <- test_clamping_vector
  bad_clamping_vector[3] <- "A"
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = bad_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = c(1, 0, 0, 0, 0, 0, 0, 0, 0), activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  # ----

  # Check activation ----
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, squashing = "tanh", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "wrong", squashing = "tanh",  point_of_inference = "final")
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh",  point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid",  point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "rescale", squashing = "sigmoid",  point_of_inference = "final")
  )
  # ----

  # Check squashing ----
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko",  point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "wrong", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "rescale", squashing = "tanh", point_of_inference = "final")
  )
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "tanh", point_of_inference = "final")
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "sigmoid", point_of_inference = "final")
  )
  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "tanh", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "saturation", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "bivalent", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "kosko", squashing = "trivalent", point_of_inference = "final")
  )
  # ----

  # Check lambda ----
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = "a", point_of_inference = "final")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = -1, point_of_inference = "final")
  )
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = 12, point_of_inference = "final")
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  )
  # ----

  # Check point_of_inference ----
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "incorrect")
  )
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "peak")
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  )
  # ----

  # Check max_iter ----
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = "a")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = 2.4)
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = -1)
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", max_iter = 1000)
  )
  # ----

  # Check min_error ----
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = 100, min_error = "a")
  )
  expect_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = 100, min_error = -1)
  )
  expect_warning(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", point_of_inference = "final", max_iter = 100, min_error = 1)
  )

  expect_no_error(
    check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]], initial_state_vector = test_initial_state_vector, clamping_vector = test_clamping_vector, activation = "modified-kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final", max_iter = 1000, min_error = 1e-3)
  )
  # ----
})


# Can't run test interactively
test_that("print.infer_conventional_fcm works", {
  adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  test_infer <- infer_conventional_fcm(adj_matrix,
                                       initial_state_vector = c(1, 1, 1, 1, 1, 1),
                                       clamping_vector = c(1, 0, 0, 0, 0, 0),
                                       activation = "kosko",
                                       squashing = "sigmoid",
                                       lambda = 1,
                                       point_of_inference = "final")

  expect_snapshot(test_infer)
})


# Can't run test interactively
test_that("print.infer_ivfn_or_tfn_fcm works", {
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.2, 0, 0, 0.9, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.3, 0.9, -0.5, 0, -0.5, 0),
    C5 = c(0.5, 0, 0, -0.3, 0, 0),
    C6 = c(0, -0.4, 0, 0, -0.5, 0)
  )
  adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)

  # Test print infer_conventional_fcm
  test_sim <- infer_ivfn_or_tfn_fcm(adj_matrix, c(1, 1, 1, 1, 1, 1), clamping_vector = c(1, 0, 0, 0, 0, 0), activation = "kosko", squashing = "sigmoid", lambda = 1, point_of_inference = "final")
  expect_snapshot(test_sim)

  lower_adj_matrix <- data.frame(
    A = c(0, 0.2, 0.4),
    B = c(0.6, 0, -1),
    C = c(0, -1, 0)
  )
  mode_adj_matrix <- data.frame(
    A = c(0, 0.6, 0.8),
    B = c(0.8, 0, -0.6),
    C = c(0, -0.4, 0)
  )
  upper_adj_matrix <- data.frame(
    A = c(0, 0.8, 1),
    B = c(1, 0, -0.2),
    C = c(0, -0.2, 0)
  )
  test_ivfn_adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  test_tfn_adj_matrix <- make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix)

  # Test print infer_ivfn_or_tfn_fcm
  ivfn_infer <- infer_ivfn_or_tfn_fcm(test_ivfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)
  tfn_infer <- infer_ivfn_or_tfn_fcm(test_tfn_adj_matrix, initial_state_vector = c(1, 1, 1), clamping_vector = c(1, 0, 0), activation = "kosko", squashing = "sigmoid", point_of_inference = "final", lambda = 1, min_error = 0.00001)

  # Adding to make sure these get caught by covr
  # print(ivfn_infer)
  # print(tfn_infer)

  expect_snapshot(print(ivfn_infer))
  expect_snapshot(print(tfn_infer))
})




# test_that("infer_fcm_set works with salinization data sets", {
#   mc_adj_matrices <- build_monte_carlo_fcms(sample_fcms$large_fcms$conventional_fcms, N_samples = 100, include_zeroes = FALSE, show_progress = TRUE)
#   test <- infer_fcm_set(
#     mc_adj_matrices,
#     initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
#     clamping_vector = c(),
#     activation = "modified-kosko", squashing = "sigmoid", lambda = 1,
#     max_iter = 1000, min_error = 1e-5,
#     parallel = TRUE, n_cores = 2, show_progress = TRUE
#   )
# })


#
#
# test_that("calculate_next_conventional_fcm_state_vector", {
#   adj_matrix <- data.frame(
#     C1 = c(0, 0, 0, 0, 0, 0),
#     C2 = c(-0.85, 0, 0, 0.35, 0, 0),
#     C3 = c(0, 0, 0, 0, 0, 0),
#     C4 = c(-0.7, 0.6, -1, 0, -1, 0),
#     C5 = c(0.1, 0, 0, -0.8, 0, 0),
#     C6 = c(0, -0.95, 0, 0, -0.95, 0)
#   )
#   test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 0, 0, 0, 0, 0), activation = "kosko")
#   expect_equal(test_next_state[1, ], c(0, -0.85, 0, -0.7, 0.1, 0), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "modified-kosko")
#   expect_equal(test_next_state[1, ], c(1, 0.5, 1, -1.1, 0.3, -0.9), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_conventional_fcm_state_vector(adj_matrix, state_vector = c(1, 1, 1, 1, 1, 1), activation = "rescale")
#   expect_equal(test_next_state[1, ], c(1, 0.5, 1, -1.1, 0.3, -0.9), ignore_attr = TRUE)
# })
#
#
# test_that("calculate_next_fuzzy_set_fcm_state_vector", {
#   lower_adj_matrix <- data.frame(
#     C1 = c(0, 0, 0, 0, 0, 0),
#     C2 = c(-0.85, 0, 0, 0.35, 0, 0),
#     C3 = c(0, 0, 0, 0, 0, 0),
#     C4 = c(-0.7, 0.6, -1, 0, -1, 0),
#     C5 = c(0.1, 0, 0, -0.8, 0, 0),
#     C6 = c(0, -0.95, 0, 0, -0.95, 0)
#   )
#   upper_adj_matrix <- data.frame(
#     C1 = c(0, 0, 0, 0, 0, 0),
#     C2 = c(-0.2, 0, 0, 0.9, 0, 0),
#     C3 = c(0, 0, 0, 0, 0, 0),
#     C4 = c(-0.3, 0.9, -0.5, 0, -0.5, 0),
#     C5 = c(0.5, 0, 0, -0.3, 0, 0),
#     C6 = c(0, -0.4, 0, 0, -0.5, 0)
#   )
#   adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix,
#                                                                fuzzy_set_state_vector = c(ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1)),
#                                                                crisp_state_vector = c(1, 1, 1, 1, 1, 1),
#                                                                activation = "kosko",
#                                                                fcm_class = "ivfn")
#   expect_equal(test_next_state, c(ivfn(0, 0), ivfn(-0.5, 0.7), ivfn(0, 0), ivfn(-2.1, -0.4), ivfn(-0.7, 0.2), ivfn(-1.9, -0.9)), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix,
#                                                                fuzzy_set_state_vector = c(ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1)),
#                                                                crisp_state_vector = c(1, 1, 1, 1, 1, 1),
#                                                                activation = "modified-kosko",
#                                                                fcm_class = "ivfn")
#   expect_equal(test_next_state, c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1)), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix,
#                                                                fuzzy_set_state_vector = c(ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1), ivfn(1, 1)),
#                                                                crisp_state_vector = c(1, 1, 1, 1, 1, 1),
#                                                                activation = "rescale",
#                                                                fcm_class = "ivfn")
#   expect_equal(test_next_state, c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1)), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix,
#                                                                fuzzy_set_state_vector = c(ivfn(1, 1), ivfn(0.5, 1.7), ivfn(1, 1), ivfn(-1.1, 0.6), ivfn(0.3, 1.2), ivfn(-0.9, 0.1)),
#                                                                crisp_state_vector = c(1, 1.1, 1, -0.25, 0.75, -0.4),
#                                                                activation = "rescale",
#                                                                fcm_class = "ivfn")
#   expect_equal(test_next_state, c(ivfn(1, 1), ivfn(-2.2, 1.675), ivfn(1, 1), ivfn(-4.68, 0.23), ivfn(0.15, 3.1), ivfn(-4.415, -1.53)), ignore_attr = TRUE)
#
#
#   # Test w/ TFNs
#   lower_adj_matrix_1 <- data.frame(
#     "A" = c(0, 0),
#     "B" = c(-0.25, 0)
#   )
#   mode_adj_matrix_1 <- data.frame(
#     "A" = c(0, 0),
#     "B" = c(0.5, 0)
#   )
#   upper_adj_matrix_1 <- data.frame(
#     "A" = c(0, 0),
#     "B" = c(0.75, 0)
#   )
#   adj_matrix_w_tfns <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix_w_tfns,
#                                                                fuzzy_set_state_vector = c(tfn(1, 1, 1), tfn(1, 1, 1)),
#                                                                crisp_state_vector = c(1, 1),
#                                                                activation = "kosko",
#                                                                fcm_class = "tfn")
#   expect_equal(test_next_state, c(tfn(0, 0, 0), tfn(-0.25, 0.5, 0.75)), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix_w_tfns,
#                                                                fuzzy_set_state_vector = c(tfn(1, 1, 1), tfn(1, 1, 1)),
#                                                                crisp_state_vector = c(-1, 1),
#                                                                activation = "modified-kosko",
#                                                                fcm_class = "tfn")
#   expect_equal(test_next_state, c(tfn(1, 1, 1), tfn(0.25, 0.5, 1.25)), ignore_attr = TRUE)
#
#   test_next_state <- calculate_next_fuzzy_set_fcm_state_vector(adj_matrix_w_tfns,
#                                                                fuzzy_set_state_vector = c(tfn(1, 1, 1), tfn(1, 1, 1)),
#                                                                crisp_state_vector = c(1, 1),
#                                                                activation = "rescale",
#                                                                fcm_class = "tfn")
#   expect_equal(test_next_state, c(tfn(1, 1, 1), tfn(0.75, 1.5, 1.75)), ignore_attr = TRUE)
# })


# test_that("infer_fcm_set works with ivfn fcms", {
#   lower_adj_matrix <- data.frame(
#     "A" = c(0, 0, 0, 0),
#     "B" = c(0.25, 0, 0, 0.25),
#     "C" = c(0, 0.25, 0, 0),
#     "D" = c(0, 0, 0.25, 0)
#   )
#   upper_adj_matrix <- data.frame(
#     "A" = c(0, 0, 0, 0),
#     "B" = c(0.75, 0, 0, 0.75),
#     "C" = c(0, 0.75, 0, 0),
#     "D" = c(0, 0, 0.75, 0)
#   )
#   ivfn_mat_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
#   ivfn_mat_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix*1.2, upper_adj_matrix*1.2)
#   ivfn_mat_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix*0.8, upper_adj_matrix*0.8)
#   adj_matrices <- list(ivfn_mat_1, ivfn_mat_2, ivfn_mat_3)
#   invisible(capture.output(
#     test_mc_fcms <- build_monte_carlo_fcms_from_fuzzy_set_adj_matrices(adj_matrices, "ivfn", 50, include_zeroes = FALSE)
#   ))
#
#   # Parallel NOT working; using wrong versions of functions for some reason
#   # # Check parallel and show_progress run
#   invisible(capture.output(
#     expect_no_error(
#       test_fmcm_inference_p_sp <- infer_fcm_set(
#         adj_matrices = test_mc_fcms,
#         initial_state_vector <- c(1, 1, 1, 1),
#         clamping_vector <- c(1, 0, 0, 0),
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 1000,
#         min_error = 1e-5,
#         parallel = TRUE,
#         show_progress = TRUE,
#         n_cores = 2
#       )
#     )
#   ))
#
#   # # Check parallel and show_progress = FALSE run
#   invisible(capture.output(
#     expect_no_error(
#       test_fmcm_inference_p_and_no_sp <- infer_fcm_set(
#         adj_matrices = test_mc_fcms,
#         initial_state_vector <- c(1, 1, 1, 1),
#         clamping_vector <- c(1, 0, 0, 0),
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 1000,
#         min_error = 1e-5,
#         parallel = TRUE,
#         show_progress = FALSE,
#         n_cores = 2
#       )
#     )
#   ))
#
#   # Check parallel = FALSE and show_progress run
#   invisible(capture.output(
#     expect_warning(
#       test_fmcm_inference_no_p_and_sp <- infer_fcm_set(
#         adj_matrices = test_mc_fcms,
#         initial_state_vector <- c(1, 1, 1, 1),
#         clamping_vector <- c(1, 0, 0, 0),
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 1000,
#         min_error = 1e-5,
#         parallel = FALSE,
#         show_progress = TRUE,
#         n_cores = 2
#       )
#     )
#   ))
#
#   # Check parallel = FALSE and show_progress = FALSE run
#   invisible(capture.output(
#     expect_no_error(
#       test_fmcm_inference_no_p_and_no_sp <- infer_fcm_set(
#         adj_matrices = test_mc_fcms,
#         initial_state_vector <- c(1, 1, 1, 1),
#         clamping_vector <- c(1, 0, 0, 0),
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 1000,
#         min_error = 1e-5,
#         parallel = FALSE,
#         show_progress = FALSE
#       )
#     )
#   ))
#
#   # Confirm all methods produce same output
#   max_error <- 1e-5
#   expect_true(all(abs(test_fmcm_inference_p_sp$inference - test_fmcm_inference_no_p_and_sp$inference) <= max_error))
#   expect_true(all(abs(test_fmcm_inference_no_p_and_sp$inference - test_fmcm_inference_p_and_no_sp$inference) <= max_error))
#   expect_true(all(abs(test_fmcm_inference_p_and_no_sp$inference - test_fmcm_inference_no_p_and_no_sp$inference) <= max_error))
#   expect_true(all(abs(test_fmcm_inference_no_p_and_sp$inference - test_fmcm_inference_no_p_and_no_sp$inference) <= max_error))
# })
#
#
# test_that("infer_fcm_set catches invalid parallel processing inputs", {
#   # This test specifically messes with R CMD Check
#   # invisible(capture.output(
#   #   expect_warning( # When no n_cores input given but parallel processing is intended
#   #     infer_fcm_set(
#   #       sample_fcms$large_fcms$conventional_fcms,
#   #       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #       clamping_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
#   #       activation = "kosko",
#   #       squashing = "sigmoid",
#   #       lambda = 1,
#   #       max_iter = 100,
#   #       min_error = 1e-5,
#   #       parallel = TRUE
#   #     )
#   #   )
#   # ))
#
#   test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
#   test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
#   test_clamping_vector[3] <- 1
#
#   invisible(capture.output(
#     expect_error( # When no n_cores input is not an integer
#       infer_fcm_set(
#         sample_fcms$large_fcms$conventional_fcms,
#         initial_state_vector = test_initial_state_vector,
#         clamping_vector = test_clamping_vector,
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 100,
#         min_error = 1e-5,
#         parallel = TRUE,
#         n_cores = 1.5
#       )
#     )
#   ))
#
#   invisible(capture.output(
#     expect_no_error( # When n_cores is a positive, odd integer
#       infer_fcm_set(
#         sample_fcms$large_fcms$conventional_fcms,
#         initial_state_vector = test_initial_state_vector,
#         clamping_vector = test_clamping_vector,
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 100,
#         min_error = 1e-5,
#         parallel = TRUE,
#         n_cores = 1
#       )
#     )
#   ))
#
#   # Messes w/ R CMD Check
#   # invisible(capture.output(
#   #   expect_warning( # When n_cores is larger than number of available cores
#   #     infer_fcm_set(
#   #       sample_fcms$large_fcms$conventional_fcms,
#   #       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #       clamping_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
#   #       activation = "kosko",
#   #       squashing = "sigmoid",
#   #       lambda = 1,
#   #       max_iter = 100,
#   #       min_error = 1e-5,
#   #       parallel = TRUE,
#   #       n_cores = parallel::detectCores() + 1
#   #     )
#   #   )
#   # ))
#
#   invisible(capture.output(
#     expect_warning( # When n_cores input given but parallel processing is not intended
#       infer_fcm_set(
#         sample_fcms$large_fcms$conventional_fcms,
#         initial_state_vector = test_initial_state_vector,
#         clamping_vector = test_clamping_vector,
#         activation = "kosko",
#         squashing = "sigmoid",
#         lambda = 1,
#         point_of_inference = "final",
#         max_iter = 100,
#         min_error = 1e-5,
#         parallel = FALSE,
#         n_cores = 2
#       )
#     )
#   ))
# })



