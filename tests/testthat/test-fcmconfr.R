#
# test_that("fcmconfr works with sample data", {
#
#   ivfn_fcms <- sample_fcms$simple_fcms$ivfn_fcms
#
#   ivfn_fcmconfr <- fcmconfr(
#     adj_matrices = ivfn_fcms,
#     # Aggregation and Monte Carlo Sampling
#     agg_function = 'mean',
#     num_mc_fcms = 1000,
#     # Simulation
#     initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
#     clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
#     activation = 'modified-kosko',
#     squashing = 'sigmoid',
#     lambda = 1,
#     point_of_inference = 'final',
#     max_iter = 100,
#     min_error = 1e-05,
#     # Inference Estimation (bootstrap)
#     ci_centering_function = 'mean',
#     confidence_interval = 0.95,
#     num_ci_bootstraps = 1000,
#     # Runtime Options
#     show_progress = TRUE,
#     parallel = TRUE,
#     n_cores = 10,
#     # Additional Options
#     run_agg_calcs = TRUE,
#     run_mc_calcs = TRUE,
#     run_ci_calcs = TRUE,
#     include_zeroes_in_sampling = FALSE,
#     include_sims_in_output = FALSE
#   )
# })


test_that("streamlined fcmconfr works", {

  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
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

  # aggregate_fcms(test_fcms, "mean")

  expect_no_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  expect_snapshot(test)

  expect_no_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = FALSE,
        parallel = FALSE,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # ggplot() +
  #   geom_jitter(data = test$inferences$individual_fcms$inferences, aes(x = node, y = value)) +
  #   geom_crossbar(data = bootstrapped_means, aes(x = node, y = lower_0.025, ymin = lower_0.025, ymax = upper_0.975), fill = "red", color = "red", size = 0.1)


  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  adj_matrix_w_ivfns_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.15, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.85, 0)
  )
  adj_matrix_w_ivfns_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  test_fcms <- list(adj_matrix_w_ivfns_1, adj_matrix_w_ivfns_2)

  expect_no_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1),
        clamping_vector = c(0, 1),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "mean",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = FALSE,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  expect_snapshot(test)


  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  adj_matrix_w_tfns_1 <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)

  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.15, 0)
  )
  mode_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.65, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.85, 0)
  )
  adj_matrix_w_tfns_2 <- make_adj_matrix_w_tfns(lower_adj_matrix_2, mode_adj_matrix_2, upper_adj_matrix_2)

  test_fcms <- list(adj_matrix_w_tfns_1, adj_matrix_w_tfns_2)

  # test_aggregate <- aggregate_fcms(test_fcms, "mean")

  expect_no_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = adj_matrix_w_tfns_1,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1),
        clamping_vector = c(0, 1),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = FALSE,
        # Additional Options
        run_agg_calcs = FALSE,
        run_mc_calcs = FALSE,
        run_ci_calcs = FALSE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = FALSE
      )
    ))
  )

  expect_snapshot(test)




  # adj_matrices = test_fcms
  # # Aggregation and Monte Carlo Sampling
  # agg_function = 'mean'
  # num_mc_fcms = 1000
  # # Simulation
  # initial_state_vector = c(1, 1, 1, 1)
  # clamping_vector = c(0, 0, 0, 0)
  # activation = 'kosko'
  # squashing = 'sigmoid'
  # lambda = 1
  # max_iter = 100
  # min_error = 1e-05
  # fuzzy_set_samples = 1000
  # # Inference Estimation (bootstrap)
  # confidence_interval = 0.95
  # num_ci_bootstraps = 1000
  # # Runtime Options
  # show_progress = TRUE
  # parallel = FALSE
  # n_cores = 10
  # # Additional Options
  # include_zeroes_in_sampling = FALSE
  # include_sims_in_output = TRUE
  # estimate_inference_CI_w_bootstrap = TRUE

  # ggplot() +
  #   geom_jitter(data = test$inference_for_plotting, aes(x = node, y = value)) +
  #   geom_crossbar(data = bootstrapped_means, aes(x = node, y = lower_0.025, ymin = lower_0.025, ymax = upper_0.975), fill = "red", color = "red", size = 0.1)
})


test_that("pulse only fcmconfr works", {
  # salinization_conventional_fcms <- salinization_conventional_fcms

  test_initial_state_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_initial_state_vector[3] <- 1
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))

  expect_no_error(
    invisible(capture.output(
      test_fcmconfr_conventional_sigmoid <- fcmconfr(
        adj_matrices = sample_fcms$large_fcms$conventional_fcms[[1]],
        # Simulation
        initial_state_vector = test_initial_state_vector,
        clamping_vector = test_clamping_vector,
        activation = 'modified-kosko',
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
        run_agg_calcs = FALSE,
        run_mc_calcs = FALSE,
        run_ci_calcs = FALSE,
        include_zeroes_in_sampling = TRUE,
        include_sims_in_output = TRUE
      )
    ))
  )
  test_inferences <- test_fcmconfr_conventional_sigmoid$inferences$individual_fcms$inferences[, -1]

  expected_inferences <- c(
    0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.788, 0.788, 0.659,
    0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659, 0.659,
    0.659, 0.416, 0.659, 0.659
  )
  avg_error <- sum(abs(test_inferences - expected_inferences))/(length(test_inferences))
  max_allowable_avg_error <- 10e-2
  expect_lt(avg_error, max_allowable_avg_error)

  expect_no_error(
    invisible(capture.output(
      test_fcmconfr_conventional_tanh <- fcmconfr(
        adj_matrices = sample_fcms$large_fcms$conventional_fcms[[1]],
        # Simulation
        initial_state_vector = test_initial_state_vector,
        clamping_vector = test_clamping_vector,
        activation = 'kosko',
        squashing = 'tanh',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-03,
        # Inference Estimation (bootstrap)
        ci_centering_function = mean,
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = FALSE,
        run_mc_calcs = FALSE,
        run_ci_calcs = FALSE,
        include_zeroes_in_sampling = TRUE,
        include_sims_in_output = TRUE
      )
    ))
  )
  test_inferences <- test_fcmconfr_conventional_tanh$inferences$individual_fcms$inferences[, -1]

  # expected_inferences <- c(0, 0, 0.131, 0, 0.804, 0, 0.882, 0.612, 0)
  expected_inferences <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  avg_error <- sum(abs(test_inferences - expected_inferences))/(length(test_inferences))
  max_allowable_avg_error <- 10e-4
  expect_lt(avg_error, max_allowable_avg_error)
})


test_that("fcmconfr works with igraph inputs", {
  fcms_as_igraph_objects <- lapply(sample_fcms$large_fcms$conventional_fcms, function(fcm) {
    igraph::graph_from_adjacency_matrix(as.matrix(fcm), mode = "directed", weighted = TRUE)
    }
  )
  fcms_from_igraph_objects <- lapply(fcms_as_igraph_objects, igraph::as_adjacency_matrix, attr = "weight")

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector[3] <- 1

  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = fcms_from_igraph_objects,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = test_initial_state_vector,
        clamping_vector = test_clamping_vector,
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )
})


test_that("check_fcmconfr_inputs work", {

  # Expect error w/ different sized adj. matrices
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
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
    "A" = c(0, 0, 0, 0, 0),
    "B" = c(0.75, 0, 0, 0.75, 0),
    "C" = c(0, 0.75, 0, 0, 0),
    "D" = c(0, 0, 0.75, 0, 0),
    "E" = c(0, 0, 0, 0, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3)

  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # Expect error if run_agg_calcs is not logical()
  expect_error(
  invisible(capture.output(
    tfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = 2,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  )

  # Expect error if run_mc_calcs is not logical()
  expect_error(
    invisible(capture.output(
      tfn_clamping_inputs_only <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'modified-kosko',
        squashing = 'sigmoid',
        lambda = 0.5,
        point_of_inference = "final",
        max_iter = 1000,
        min_error = 1e-05,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = 2,
        run_ci_calcs = FALSE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = FALSE
      )
    ))
  )

  # Expect error if run_ci_calcs is not logical()
  expect_error(
  invisible(capture.output(
    tfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = 2,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  )

  # Expect error if include_zeroes_in_sampling is not logical()
  expect_error(
  invisible(capture.output(
    tfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = 2,
      include_sims_in_output = FALSE
    )
  ))
  )

  # Expect error if include_sims_in_output is not logical()
  expect_error(
  invisible(capture.output(
    tfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = 2
    )
  ))
  )


  # Expect warning w/ blank initial_state_vector, clamping_vector, activation, or squashing
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
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
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3)

  # Blank initial_state_vector
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Blank clamping_vector
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Blank activation
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Blank clamping
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = "kosko",
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error when any clamping_vector != 0 and !all initial_state_vector = 1
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 0, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error with different concepts across adj. matrices
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
    "C" = c(0, 1, 0, 0),
    "D" = c(0, 0, 1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "C" = c(0.25, 0, 0, 0.25),
    "E" = c(0, 0.25, 0, 0),
    "F" = c(0, 0, 0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "K" = c(0, 0, 0, 0),
    "J" = c(0.75, 0, 0, 0.75),
    "Q" = c(0, 0.75, 0, 0),
    "T" = c(0, 0, 0.75, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3)

  # Blank initial_state_vector
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # Check cannot aggregate an individual, conventional FCM
  test_adj_matrix <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
    "C" = c(0, 1, 0, 0),
    "D" = c(0, 0, 1, 0)
  )
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_adj_matrix,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = FALSE,
        run_ci_calcs = FALSE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # Check cannot aggregate individual ivfn/tfn FCM
  lower_adj_matrix <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  upper_adj_matrix <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  adj_matrix_w_ivfns <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = adj_matrix_w_ivfns,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1),
        clamping_vector = c(0, 1),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Check aggregate_function must be either 'mean' or 'median'
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'wrong name',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # Expect warning when trying to bootstrap w/o performing monte carlo analysis
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
    "C" = c(0, 1, 0, 0),
    "D" = c(0, 0, 1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(0.25, 0, 0, 0.25),
    "C" = c(0, 0.25, 0, 0),
    "D" = c(0, 0, 0.25, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2)

  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = FALSE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect warning if no aggregate_function defined
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )


  # Expect warning if no ci_centering_function defined
  expect_warning(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = test_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = "mean",
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1),
        clamping_vector = c(0, 1, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error is num_mc_fcms is not numeric
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 'a',
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect errorr if num_mc_fcms is not an integer
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100.5,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error if num_mc_fcms <= 0
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = -1,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
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
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error if n_cores is not numeric
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 'z',
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error if n_cores is not an integer
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 2.5,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

  # Expect error if n_nodes is <= 0
  expect_error(
    invisible(capture.output(
      test <- fcmconfr(
        adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 100,
        # Simulation
        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
        activation = 'kosko',
        squashing = 'sigmoid',
        lambda = 1,
        point_of_inference = "final",
        max_iter = 100,
        min_error = 1e-05,
        # Inference Estimation (bootstrap)
        ci_centering_function = "median",
        confidence_interval = 0.95,
        num_ci_bootstraps = 1000,
        # Runtime Options
        show_progress = TRUE,
        parallel = TRUE,
        n_cores = 0,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE
      )
    ))
  )

})


test_that("print.fcmconfr works", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0, 0, 0),
    "B" = c(1, 0, 0, 1),
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

  # Perform aggregate & Perform monte carlo & Perform bootstrap
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(print(test))

  # Perform aggregate & Perform monte carlo & !Perform bootstrap
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(print(test))

  # !Perform aggregate & Perform monte carlo & Perform bootstrap
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(test)

  # !Perform aggregate & Perform monte carlo & !Perform bootstrap
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(test)

  # Perform aggregate & !Perform monte carlo
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(test)

  # !Perform aggregate & !Perform monte carlo
  invisible(capture.output(
    test <- fcmconfr(
      adj_matrices = test_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1),
      clamping_vector = c(0, 1, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 1000,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  expect_snapshot(test)

})
