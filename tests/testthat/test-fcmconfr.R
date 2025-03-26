
requireNamespace("igraph")


# fcmconfr ----
test_that("fcmconfr works", {

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

  expect_snapshot(print(test))

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
        parallel = TRUE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = FALSE,
        include_sims_in_output = TRUE,
        silent = TRUE
      )
    ))
  )

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

  expect_snapshot(print(test))


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

  expect_snapshot(print(test))
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
  })
  fcms_from_igraph_objects <- lapply(fcms_as_igraph_objects, igraph::as_adjacency_matrix, attr = "weight")

  test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  test_clamping_vector[3] <- 1

  expect_no_error(
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
# ----


test_that("check_fcmconfr_inputs works", {

  # Confirm warnings if no agg_function defined ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms[1:5],
      # Aggregation and Monte Carlo Sampling
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "median",
      confidence_interval = 0.95,
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

  # Confirm warnings if no ci_centering_function defined ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms[1:5],
      # Aggregation and Monte Carlo Sampling
      agg_function = "mean",
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      confidence_interval = 0.95,
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = TRUE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

  # Confirm warnings if fcm_class = "conventional" and trying to aggregate ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms[[1]],
      # Aggregation and Monte Carlo Sampling
      agg_function = "mean",
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      confidence_interval = 0.95,
      ci_centering_function = "mean",
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

  # Confirm warnings if fcm_class = "conventional" and trying to build_mc_fcms ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms[[1]],
      # Aggregation and Monte Carlo Sampling
      agg_function = "mean",
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      confidence_interval = 0.95,
      ci_centering_function = "mean",
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

  # Confirm warnings if fcm_class = "ivfn" or "tfn" and trying to aggregate ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms[[1]],
      # Aggregation and Monte Carlo Sampling
      agg_function = "mean",
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      confidence_interval = 0.95,
      ci_centering_function = "mean",
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = TRUE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

  # Confirm warnings if run_ci_calcs is TRUE and run_mc_calcs is FALSE ----
  expect_warning(
    test <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms[1:5],
      # Aggregation and Monte Carlo Sampling
      agg_function = "mean",
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
      clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      confidence_interval = 0.95,
      ci_centering_function = "mean",
      num_ci_bootstraps = 10,
      # Runtime Options
      show_progress = FALSE,
      parallel = FALSE,
      n_cores = 1,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = TRUE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  )
  # ----

})


test_that("get_fcmconfr_inferences works", {

  invisible(capture.output(
    conventional_fcmconfr <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(0, 0, 1, 0, 0, 0, 0),
      clamping_vector = c(0, 0, 0, 0, 0, 0, 0),
      activation = 'kosko',
      squashing = 'tanh',
      lambda = 0.5,
      point_of_inference = "final",
      max_iter = 10,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "mean",
      confidence_interval = 0.95,
      num_ci_bootstraps = 10,
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

  expect_error(get_fcmconfr_inferences(12413))
  expect_error(get_fcmconfr_inferences(conventional_fcmconfr, analysis = "not correct"))

  test_get_fcmconfr_inferences <- get_fcmconfr_inferences(conventional_fcmconfr)
  expect_equal(names(test_get_fcmconfr_inferences), c("individual_inferences", "aggregate_inferences", "mc_inferences", "mc_CIs_and_quantiles"))
  test_get_fcmconfr_inferences <- get_fcmconfr_inferences(conventional_fcmconfr, analysis = c("individual", "aggregate"))
  expect_equal(names(test_get_fcmconfr_inferences), c("individual_inferences", "aggregate_inferences"))

  invisible(capture.output(
    ivfn_fcmconfr <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 10,
      # Simulation
      initial_state_vector = c(0, 0, 1, 0, 0, 0, 0),
      clamping_vector = c(0, 0, 0, 0, 0, 0, 0),
      activation = 'rescale',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 100,
      min_error = 1e-05,
      # Inference Estimation (bootstrap)
      ci_centering_function = "mean",
      confidence_interval = 0.95,
      num_ci_bootstraps = 10,
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
  expect_no_error(get_fcmconfr_inferences(ivfn_fcmconfr))

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
  expect_no_error(get_fcmconfr_inferences(tfn_fcmconfr))

})


test_that("summary.fcmconfr and print.summary.fcmconfr works", {

  # Individuals, Aggregate, Monte Carlo, and Bootstrap
  test_fcmconfr <- fcmconfr(
    adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
    # Aggregation and Monte Carlo Sampling
    agg_function = 'mean',
    num_mc_fcms = 100,
    # Simulation
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = 'rescale',
    squashing = 'sigmoid',
    lambda = 1,
    point_of_inference = 'final',
    max_iter = 100,
    min_error = 1e-05,
    # Inference Estimation (bootstrap)
    ci_centering_function = 'mean',
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

  summary_object <- summary(test_fcmconfr)
  expect_no_error(
    print(summary_object)
  )



  # Individuals, Aggregate, Monte Carlo, and NO Bootstrap
  test_fcmconfr <- fcmconfr(
    adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
    # Aggregation and Monte Carlo Sampling
    agg_function = 'mean',
    num_mc_fcms = 100,
    # Simulation
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = 'rescale',
    squashing = 'sigmoid',
    lambda = 1,
    point_of_inference = 'final',
    max_iter = 100,
    min_error = 1e-05,
    # Inference Estimation (bootstrap)
    ci_centering_function = 'mean',
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
    include_zeroes_in_sampling = TRUE,
    include_sims_in_output = TRUE
  )

  summary_object <- summary(test_fcmconfr)
  expect_no_error(
    print(summary_object)
  )


  # Individuals, Aggregate, NO Monte Carlo, and NO Bootstrap
  test_fcmconfr <- fcmconfr(
    adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
    # Aggregation and Monte Carlo Sampling
    agg_function = 'mean',
    num_mc_fcms = 100,
    # Simulation
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = 'rescale',
    squashing = 'sigmoid',
    lambda = 1,
    point_of_inference = 'final',
    max_iter = 100,
    min_error = 1e-05,
    # Inference Estimation (bootstrap)
    ci_centering_function = 'mean',
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
    include_zeroes_in_sampling = TRUE,
    include_sims_in_output = TRUE
  )

  summary_object <- summary(test_fcmconfr)
  expect_no_error(
    print(summary_object)
  )

  # Individuals, NO Aggregate, NO Monte Carlo, and NO Bootstrap
  test_fcmconfr <- fcmconfr(
    adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
    # Aggregation and Monte Carlo Sampling
    agg_function = 'mean',
    num_mc_fcms = 100,
    # Simulation
    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
    activation = 'rescale',
    squashing = 'sigmoid',
    lambda = 1,
    point_of_inference = 'final',
    max_iter = 100,
    min_error = 1e-05,
    # Inference Estimation (bootstrap)
    ci_centering_function = 'mean',
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
    include_zeroes_in_sampling = TRUE,
    include_sims_in_output = TRUE
  )

  summary_object <- summary(test_fcmconfr)
  expect_no_error(
    print(summary_object)
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
