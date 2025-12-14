
requireNamespace("vdiffr")

test_that("fcmconfr_plot additional inputs work", {

  # Load fcmconfr object ----
  test_initial_state_vector <- c(1, 1, 1, 1, 1, 1, 1)
  test_pulse_initial_state_vector <- c(1, 0, 0, 0, 0, 0, 0)
  test_clamping_vector <- c(1, 0, 0, 0, 0, 0, 0)
  test_pulse_clamping_vector <- c(0, 0, 0, 0, 0, 0, 0)

  invisible(capture.output(
    tfn_clamping_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
  # ----

  # interactive ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, shiny = "A")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, shiny = FALSE)
  )
  # ----

  # Plot Formatting Parameters

  # filter_limit ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, filter_limit = "a")
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, filter_limit = -1)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, filter_limit = 2)
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, filter_limit = 1e-4)
  )
  # ----

  # xlim ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, xlim = "a")
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, xlim = -1)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, xlim = c(2, 1))
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, xlim = c(-0.5, 0.5))
  )
  # ----

  # coord_flip ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, coord_flip = "a")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, coord_flip = TRUE)
  )
  # ----


  # Plot Aesthetic Parameters

  # mc_avg_and_CIs_color ----
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_avg_and_CIs_color = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_avg_and_CIs_color = "not a color")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_avg_and_CIs_color = "orange")
  )
  # ----

  # mc_inferences_color ----
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_color = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_color = "not a color")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_color = "orange")
  )
  # ----

  # mc_inferences_shape ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_shape = 1.2345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_shape = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_shape = "not a shape")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, mc_inferences_shape = "square")
  )
  # ----

  # ind_inferences_color ----
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_color = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_color = "not a color")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_color = "orange")
  )
  # ----

  # ind_inferences_shape ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_shape = 1.2345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_shape = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_shape = "not a shape")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_inferences_shape = "square")
  )
  # ----

  # agg_inferences_color ----
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_color = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_color = "not a color")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_color = "orange")
  )
  # ----

  # agg_inferences_shape ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_shape = 1.2345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_shape = 12345)
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_shape = "not a shape")
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_inferences_shape = "square")
  )
  # ----

  # ind_ivfn_and_tfn_linewidth ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_ivfn_and_tfn_linewidth = "asdfads")
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_ivfn_and_tfn_linewidth = -1)
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, ind_ivfn_and_tfn_linewidth = 0.2)
  )
  # ----

  # agg_ivfn_and_tfn_linewidth ----
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_ivfn_and_tfn_linewidth = "asdfads")
  )
  expect_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_ivfn_and_tfn_linewidth = -1)
  )
  expect_no_error(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, agg_ivfn_and_tfn_linewidth = 0.2)
  )
  # ----

  # acceptable/unacceptable inputs ----
  expect_warning(
    plot(tfn_clamping_inputs_agg_and_mc_w_bs, wrong_input = "asdfads")
  )
  # ----

  # Test plot w/ different parameter options ----
  invisible(capture.output(
    expect_no_error(
      plot(tfn_clamping_inputs_agg_and_mc_w_bs,
           shiny = FALSE,
           # Plot Formatting Parameters
           filter_limit = 1e-4,
           coord_flip = FALSE,
           # Plot Aesthetic Parameters
           mc_avg_and_CIs_color = "orange",
           mc_inferences_color = "orange",
           mc_inferences_shape = 25,
           ind_inferences_color = "black",
           ind_inferences_shape = 4,
           agg_inferences_color = "red",
           agg_inferences_shape = 2,
           ind_ivfn_and_tfn_linewidth = 0.1,
           agg_ivfn_and_tfn_linewidth = 0.6
      )
    )
  ))
  # ----
})



test_that("fcmconfr_plot works with Conventional FCMs", {
  set.seed(100)

  # test_initial_state_vector <- rep(1, unique(dim(sample_fcms$simple_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector[5] <- 1 # Activate Guidance Docs
  #
  # test_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$conventional_fcms[[1]])))
  # test_pulse_clamping_vector <- rep(0, unique(dim(sample_fcms$simple_fcms$conventional_fcms[[1]])))
  # test_clamping_vector[5] <- 1 # Activate Guidance Docs

  test_initial_state_vector = c(1, 1, 1, 1, 1, 1, 1)
  test_pulse_initial_state_vector = c(1, 0, 0, 0, 0, 0, 0)
  test_clamping_vector = c(1, 0, 0, 0, 0, 0, 0)
  test_pulse_clamping_vector = c(0, 0, 0, 0, 0, 0, 0)

  # Clamping: Inputs Only
  invisible(capture.output(
    conventional_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Clamping Inputs Only", plot(conventional_clamping_inputs_only))
  # )

  # Pulse: Inputs Only
  invisible(capture.output(
    conventional_pulse_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "peak",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Pulse Inputs Only", plot(conventional_pulse_inputs_only))
  # )

  # Clamping: Inputs and Agg
  invisible(capture.output(
    conventional_clamping_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
      activation = 'rescale',
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
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Clamping Inputs and Agg", plot(conventional_clamping_inputs_and_agg))
  # )

  # Pulse: Inputs and Agg
  invisible(capture.output(
    conventional_pulse_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Pulse Inputs and Agg", plot(conventional_pulse_inputs_and_agg))
  # )

  # Clamping: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    conventional_clamping_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
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
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Clamping Inputs Agg and MC NO BS", plot(conventional_clamping_inputs_agg_and_mc_no_bs))
  # )

  # Pulse: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    conventional_pulse_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
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
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Pulse Inputs Agg and Mc NO BS", plot(conventional_pulse_inputs_agg_and_mc_no_bs))
  # )


  # Clamping: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    conventional_clamping_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Clamping Inputs Agg and Mc w/ BS", plot(conventional_clamping_inputs_agg_and_mc_w_bs))
  # )

  # Pulse: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    conventional_pulse_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
      # adj_matrices = group_conventional_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
      activation = 'kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "peak",
      max_iter = 1000,
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
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("Conventional Pulse Inputs Agg and Mc w/ BS", plot(conventional_pulse_inputs_agg_and_mc_w_bs))
  # )
})



test_that("fcmconfr_plot works with IVFN FCMs", {
  set.seed(100)

  # Large IVFN FCMs Inputs
  # test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector[5] <- 1 # Activate Guidance Docs
  #
  # test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_clamping_vector[5] <- 1 # Activate Guidance Docs

  # Small IVFN FCMs inputs
  test_initial_state_vector = c(1, 1, 1, 1, 1, 1, 1)
  test_pulse_initial_state_vector = c(1, 0, 0, 0, 0, 0, 0)
  test_clamping_vector = c(1, 0, 0, 0, 0, 0, 0)
  test_pulse_clamping_vector = c(0, 0, 0, 0, 0, 0, 0)

  # Clamping: Inputs Only
  invisible(capture.output(
    ivfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 1,
      point_of_inference = "final",
      max_iter = 1000,
      min_error = 1e-05,
      # Runtime Options
      show_progress = TRUE,
      parallel = TRUE,
      n_cores = 2,
      # Additional Options
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Clamping Inputs Only", plot(ivfn_clamping_inputs_only, filter_limit = 1e-10))
  # )

  # Pulse: Inputs Only
  invisible(capture.output(
    ivfn_pulse_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Pulse Inputs Only", plot(ivfn_pulse_inputs_only))
  # )


  # Clamping: Inputs and Agg
  invisible(capture.output(
    ivfn_clamping_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Clamping Inputs and Agg", plot(ivfn_clamping_inputs_and_agg))
  # )

  # Pulse: Inputs and Agg
  invisible(capture.output(
    ivfn_pulse_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Pulse Inputs and Agg", plot(ivfn_pulse_inputs_and_agg))
  # )

  # Clamping: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    ivfn_clamping_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = TRUE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Pulse Inputs and Agg", plot(ivfn_clamping_inputs_agg_and_mc_no_bs))
  # )

  # Pulse: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    ivfn_pulse_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Pulse Inputs and Agg", plot(ivfn_pulse_inputs_agg_and_mc_no_bs))
  # )


  # Clamping: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    ivfn_clamping_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("IVFN Pulse Inputs and Agg", plot(ivfn_clamping_inputs_agg_and_mc_w_bs))
  # )



  # Pulse: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    ivfn_pulse_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
      # adj_matrices = group_ivfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))

})



test_that("fcmconfr_plot works with TFN FCMs", {
  set.seed(100)

  # test_initial_state_vector <- rep(1, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_initial_state_vector[5] <- 1 # Activate Guidance Docs
  #
  # test_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_pulse_clamping_vector <- rep(0, unique(dim(sample_fcms$large_fcms$conventional_fcms[[1]])))
  # test_clamping_vector[5] <- 1 # Activate Guidance Docs

  test_initial_state_vector <- c(1, 1, 1, 1, 1, 1, 1)
  test_pulse_initial_state_vector <- c(1, 0, 0, 0, 0, 0, 0)
  test_clamping_vector <- c(1, 0, 0, 0, 0, 0, 0)
  test_pulse_clamping_vector <- c(0, 0, 0, 0, 0, 0, 0)

  # Clamping: Inputs Only
  invisible(capture.output(
    tfn_clamping_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Clamping Inputs Only", plot(tfn_clamping_inputs_only))
  # )

  # Pulse: Inputs Only
  invisible(capture.output(
    tfn_pulse_inputs_only <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      run_agg_calcs = FALSE,
      run_mc_calcs = FALSE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Pulse Inputs Only", plot(tfn_pulse_inputs_only))
  # )


  # Clamping: Inputs and Agg
  invisible(capture.output(
    tfn_clamping_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Clamping Inputs and Agg", plot(tfn_clamping_inputs_and_agg))
  # )

  # Pulse: Inputs and Agg
  invisible(capture.output(
    tfn_pulse_inputs_and_agg <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # Aggregation
      agg_function = 'mean',
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = FALSE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Pulse Inputs and Agg", plot(tfn_pulse_inputs_and_agg))
  # )

  # Clamping: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    tfn_clamping_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = TRUE,
      include_sims_in_output = TRUE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Pulse Inputs and Agg", plot(tfn_clamping_inputs_agg_and_mc_no_bs))
  # )

  # Pulse: Inputs, Agg, and MC (NO Bootstrap)
  invisible(capture.output(
    tfn_pulse_inputs_agg_and_mc_no_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
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
      run_mc_calcs = TRUE,
      run_ci_calcs = FALSE,
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Pulse Inputs and Agg", plot(tfn_pulse_inputs_agg_and_mc_no_bs))
  # )


  # Clamping: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    tfn_clamping_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_initial_state_vector,
      clamping_vector = test_clamping_vector,
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
  # vdiffr is too sensitive for this test, run in personal testing only
  # suppressWarnings(
  #   vdiffr::expect_doppelganger("TFN Pulse Inputs and Agg", plot(tfn_clamping_inputs_agg_and_mc_w_bs))
  # )



  # Pulse: Inputs, Agg, and MC (w/ Bootstrap)
  invisible(capture.output(
    tfn_pulse_inputs_agg_and_mc_w_bs <- fcmconfr(
      adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
      # adj_matrices = group_tfn_fcms,
      # Aggregation and Monte Carlo Sampling
      agg_function = 'mean',
      num_mc_fcms = 100,
      # Simulation
      # initial_state_vector = c(0, 0, 1, 0, 0, 0, 0, 0, 0),
      # clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
      initial_state_vector = test_pulse_initial_state_vector,
      clamping_vector = test_pulse_clamping_vector,
      activation = 'modified-kosko',
      squashing = 'sigmoid',
      lambda = 0.5,
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
      include_zeroes_in_sampling = FALSE,
      include_sims_in_output = TRUE
    )
  ))

})
