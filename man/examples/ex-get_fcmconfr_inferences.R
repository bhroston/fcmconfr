ex_conventional_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
  # adj_matrices = group_conventional_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 100L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 100L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual"))
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual", "aggregate"))
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual", "aggregate", "mc"))
get_fcmconfr_inferences(ex_conventional_fcmconfr)


ex_ivfn_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
  # adj_matrices = group_ivfn_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 10L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 10L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual"))
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual", "aggregate"))
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual", "aggregate", "mc"))
get_fcmconfr_inferences(ex_ivfn_fcmconfr)


ex_tfn_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
  # adj_matrices = group_tfn_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 1000L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 1000L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 1000L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual"))
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual", "aggregate"))
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual", "aggregate", "mc"))
get_fcmconfr_inferences(ex_tfn_fcmconfr)
