check_fcmconfr_function_inputs(adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
                               # Aggregation and Monte Carlo Sampling
                               agg_function = "mean",
                               num_mc_fcms = 1000L,
                               # Simulation
                               initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                               clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                               activation = "modified-kosko",
                               squashing = "sigmoid",
                               lambda = 1.0,
                               point_of_inference = "final",
                               max_iter = 100L,
                               min_error = 1e-5,
                               # Inference Estimation (bootstrap)
                               ci_centering_function = "mean",
                               confidence_interval = 0.95,
                               num_ci_bootstraps = 5000L,
                               # Runtime Options
                               show_progress = TRUE,
                               parallel = TRUE,
                               n_cores = 1L,
                               # Additional Options
                               run_agg_calcs = TRUE,
                               run_mc_calcs = TRUE,
                               run_ci_calcs = FALSE,
                               include_zeroes_in_sampling = FALSE,
                               include_sims_in_output = TRUE)
