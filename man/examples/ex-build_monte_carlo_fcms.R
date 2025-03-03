
# Conventional FCMs
conventional_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$conventional_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)

# IVFN FCMs
ivfn_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$ivfn_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)

# TFN FCMs
tfn_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$tfn_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)


