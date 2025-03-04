example_fcm_set <- sample_fcms$simple_fcms$conventional_fcms

mc_fcms_from_example_fcm_set <- build_monte_carlo_fcms(
  adj_matrices = example_fcm_set,
  n_samples = 1000,
  include_zeroes = FALSE,
  show_progress = TRUE
)

mc_fcms_inferences <- infer_fcm_set(
  adj_matrices = mc_fcms_from_example_fcm_set,
  initial_state_vector <- c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector <- c(1, 0, 0, 0, 0, 0, 0),
  activation = "rescale",
  squashing = "sigmoid",
  lambda = 1,
  point_of_inference = "final",
  max_iter = 100,
  min_error = 1e-3,
  parallel = FALSE,
  show_progress = TRUE
)

mc_sims_inferences <- get_quantiles_and_bootstrapped_CIs_of_inferences(
  infer_fcm_set_inference_df = mc_fcms_inferences$inferences,
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  bootstrap_reps = 1000L,
  parallel = TRUE,
  n_cores = 2L,
  show_progress = TRUE,
  skip_checks = FALSE
)

