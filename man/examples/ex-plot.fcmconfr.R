
# Example using TFN FCMs fcmconfr
tfn_example_fcmconfr <- fcmconfr(
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
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)


# Plot Defaults
plot(tfn_example_fcmconfr,
     interactive = FALSE, # Set to TRUE to open shiny app
     # Plot Formatting Parameters
     filter_limit = 1e-4,
     xlim = c(-1, 1),
     coord_flip = FALSE,
     text_font_size = NA,
     # Plot Aesthetic Parameters
     mc_avg_and_CIs_color = "blue",
     mc_inferences_color = "blue",
     mc_inferences_alpha = 0.3,
     mc_inferences_shape = 3,
     ind_inferences_color = "black",
     ind_inferences_alpha = 1,
     ind_inferences_shape = 16,
     agg_inferences_color = "red",
     agg_inferences_alpha = 1,
     agg_inferences_shape = 17,
     ind_ivfn_and_tfn_linewidth = 0.1,
     agg_ivfn_and_tfn_linewidth = 0.6
)

# Different from Plot Defaults
plot(tfn_example_fcmconfr,
     interactive = FALSE, # Set to TRUE to open shiny app
     # Plot Formatting Parameters
     filter_limit = 1e-4,
     xlim = c(-0.6, 0.6),
     coord_flip = FALSE,
     # Plot Aesthetic Parameters
     mc_avg_and_CIs_color = "darkblue",
     mc_inferences_color = "darkblue",
     mc_inferences_shape = 3,
     ind_inferences_color = "maroon",
     ind_inferences_shape = 16,
     agg_inferences_color = "grey",
     agg_inferences_shape = 17,
     ind_ivfn_and_tfn_linewidth = 0.1,
     agg_ivfn_and_tfn_linewidth = 0.6
)


# Plot Defaults w/ Shiny App
# plot(tfn_example_fcmconfr,
#      shiny = TRUE, # Set to TRUE to open shiny app
#      # Plot Formatting Parameters
#      filter_limit = 1e-4,
#      coord_flip = FALSE,
#      text_font_size = 12,
#      # Plot Aesthetic Parameters
#      mc_avg_and_CIs_color = "blue",
#      mc_inferences_color = "blue",
#      mc_inferences_shape = 3,
#      ind_inferences_color = "black",
#      ind_inferences_shape = 16,
#      agg_inferences_color = "red",
#      agg_inferences_shape = 17,
#      ind_ivfn_and_tfn_linewidth = 0.1,
#      agg_ivfn_and_tfn_linewidth = 0.6
# )
