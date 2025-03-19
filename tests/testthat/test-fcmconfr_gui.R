

#
# test_that("fcmconfr_gui console output works", {
#   agg_and_no_mc_and_no_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Aggregation
#       agg_function = 'mean',
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Runtime Options
#       show_progress = TRUE,
#       # Additional Options
#       run_agg_calcs = TRUE,
#       run_mc_calcs = FALSE,
#       run_ci_calcs = FALSE,
#       include_zeroes_in_sampling = TRUE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Aggregation
#   #   agg_function = 'mean',
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   # Additional Options
#   #   run_agg_calcs = TRUE,
#   #   run_mc_calcs_analysis = FALSE,
#   #   run_mc_calcs_inference_bootstrap_analysis = FALSE,
#   #   include_zeroes_in_sampling = TRUE
#   # )
#   expect_snapshot(agg_and_no_mc_and_no_bs)
#
#   agg_and_mc_and_no_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Aggregation and Monte Carlo Sampling
#       agg_function = 'mean',
#       monte_carlo_samples = 1000,
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Runtime Options
#       show_progress = TRUE,
#       parallel = TRUE,
#       n_cores = 1,
#       # Additional Options
#       run_agg_calcs = TRUE,
#       run_mc_calcs = TRUE,
#       run_ci_calcs = FALSE,
#       include_zeroes_in_sampling = TRUE,
#       mc_sims_in_output = TRUE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Aggregation and Monte Carlo Sampling
#   #   agg_function = 'mean',
#   #   num_mc_fcms = 50,
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   parallel = TRUE,
#   #   n_cores = 2,
#   #   # Additional Options
#   #   run_agg_calcs = TRUE,
#   #   run_mc_calcs_analysis = TRUE,
#   #   run_mc_calcs_inference_bootstrap_analysis = FALSE,
#   #   include_zeroes_in_sampling = TRUE,
#   #   mc_sims_in_output = TRUE
#   # )
#   expect_snapshot(agg_and_mc_and_no_bs)
#
#   agg_and_mc_and_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Aggregation and Monte Carlo Sampling
#       agg_function = 'mean',
#       monte_carlo_samples = 1000,
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Inference Estimation (bootstrap)
#       mc_ci_centering_function = "mean",
#       mc_confidence_interval = 0.95,
#       mc_inference_bootstrap_reps = 1000,
#       mc_inference_bootstrap_draws_per_rep = 1000,
#       # Runtime Options
#       show_progress = TRUE,
#       parallel = TRUE,
#       n_cores = 1,
#       # Additional Options
#       run_agg_calcs = TRUE,
#       run_mc_calcs = TRUE,
#       run_ci_calcs = TRUE,
#       include_zeroes_in_sampling = TRUE,
#       mc_sims_in_output = TRUE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Aggregation and Monte Carlo Sampling
#   #   agg_function = 'mean',
#   #   num_mc_fcms = 10,
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Inference Estimation (bootstrap)
#   #   ci_centering_function = mean,
#   #   confidence_interval = 0.95,
#   #   num_ci_bootstraps = 100,
#   #   inference_estimation_bootstrap_draws_per_rep = 100,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   parallel = TRUE,
#   #   n_cores = 2,
#   #   # Additional Options
#   #   run_agg_calcs = TRUE,
#   #   run_mc_calcs_analysis = TRUE,
#   #   run_mc_calcs_inference_bootstrap_analysis = TRUE,
#   #   include_zeroes_in_sampling = FALSE,
#   #   mc_sims_in_output = FALSE
#   # )
#   expect_snapshot(agg_and_mc_and_bs)
#
#   no_agg_and_mc_and_no_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Monte Carlo Sampling
#       monte_carlo_samples = 1000,
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Runtime Options
#       show_progress = TRUE,
#       parallel = TRUE,
#       n_cores = 1,
#       # Additional Options
#       run_agg_calcs = FALSE,
#       run_mc_calcs = TRUE,
#       run_ci_calcs = FALSE,
#       include_zeroes_in_sampling = TRUE,
#       mc_sims_in_output = TRUE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Monte Carlo Sampling
#   #   num_mc_fcms = 10,
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   parallel = TRUE,
#   #   n_cores = 2,
#   #   # Additional Options
#   #   run_agg_calcs = FALSE,
#   #   run_mc_calcs_analysis = TRUE,
#   #   run_mc_calcs_inference_bootstrap_analysis = FALSE,
#   #   include_zeroes_in_sampling = TRUE,
#   #   mc_sims_in_output = TRUE
#   # )
#   expect_snapshot(no_agg_and_mc_and_no_bs)
#
#   no_agg_and_mc_and_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Monte Carlo Sampling
#       monte_carlo_samples = 1000,
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Inference Estimation (bootstrap)
#       mc_ci_centering_function = "mean",
#       mc_confidence_interval = 0.95,
#       mc_inference_bootstrap_reps = 1000,
#       mc_inference_bootstrap_draws_per_rep = 1000,
#       # Runtime Options
#       show_progress = TRUE,
#       parallel = TRUE,
#       n_cores = 1,
#       # Additional Options
#       run_agg_calcs = FALSE,
#       run_mc_calcs = TRUE,
#       run_ci_calcs = TRUE,
#       include_zeroes_in_sampling = TRUE,
#       mc_sims_in_output = TRUE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Monte Carlo Sampling
#   #   num_mc_fcms = 10,
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Inference Estimation (bootstrap)
#   #   ci_centering_function = mean,
#   #   confidence_interval = 0.95,
#   #   num_ci_bootstraps = 100,
#   #   inference_estimation_bootstrap_draws_per_rep = 100,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   parallel = TRUE,
#   #   n_cores = 2,
#   #   # Additional Options
#   #   run_agg_calcs = FALSE,
#   #   run_mc_calcs_analysis = TRUE,
#   #   run_mc_calcs_inference_bootstrap_analysis = TRUE,
#   #   include_zeroes_in_sampling = TRUE,
#   #   mc_sims_in_output = TRUE
#   # )
#   expect_snapshot(no_agg_and_mc_and_bs)
#
#   no_agg_and_no_mc_and_no_bs <- structure(
#     .Data = list(
#       adj_matrices = "salinization_ses_fcms",
#       # Simulation
#       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#       clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#       activation = 'kosko',
#       squashing = 'sigmoid',
#       lambda = 1,
#       max_iter = 100,
#       min_error = 1e-05,
#       # Runtime Options
#       show_progress = TRUE,
#       # Additional Options
#       run_agg_calcs = FALSE,
#       run_mc_calcs = FALSE,
#       run_ci_calcs = FALSE
#     ),
#     class = "fcmconfr_gui_input"
#   )
#   # test <- fcmconfr(
#   #   adj_matrices = salinization_ses_fcms,
#   #   # Simulation
#   #   initial_state_vector = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
#   #   clamping_vector = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#   #   activation = 'kosko',
#   #   squashing = 'sigmoid',
#   #   lambda = 1,
#   #   max_iter = 100,
#   #   min_error = 1e-05,
#   #   # Runtime Options
#   #   show_progress = TRUE,
#   #   # Additional Options
#   #   run_agg_calcs = FALSE,
#   #   run_mc_calcs_analysis = FALSE,
#   #   run_mc_calcs_inference_bootstrap_analysis = FALSE,
#   # )
#   expect_snapshot(no_agg_and_no_mc_and_no_bs)
# })
#
#
#
#
# # # test_adj_matrix <- data.frame(
# # #   "A" = rep(0, 26),
# # #   "B" = rep(0, 26),
# # #   "C" = rep(0, 26),
# # #   "D" = rep(0, 26),
# # #   "E" = rep(0, 26),
# # #   "F" = rep(0, 26),
# # #   "G" = rep(0, 26),
# # #   "H" = rep(0, 26),
# # #   "I" = rep(0, 26),
# # #   "J" = rep(0, 26),
# # #   "K" = rep(0, 26),
# # #   "L" = rep(0, 26),
# # #   "M" = rep(0, 26),
# # #   "N" = rep(0, 26),
# # #   "O" = rep(0, 26),
# # #   "P" = rep(0, 26),
# # #   "Q" = rep(0, 26),
# # #   "R" = rep(0, 26),
# # #   "S" = rep(0, 26),
# # #   "T" = rep(0, 26),
# # #   "U" = rep(0, 26),
# # #   "V" = rep(0, 26),
# # #   "W" = rep(0, 26),
# # #   "X" = rep(0, 26),
# # #   "Y" = rep(0, 26),
# # #   "Z" = rep(0, 26)
# # # )
# # #
# # # test_adj_matrix_1 <- data.frame(
# # #   "A" = c(0, 0, 0, 0),
# # #   "B" = c(1, 0, 0, 1),
# # #   "C" = c(0, 1, 0, 0),
# # #   "D" = c(0, 0, 1, 0)
# # # )
# # # test_adj_matrix_2 <- data.frame(
# # #   "A" = c(0, 0, 0, 0),
# # #   "B" = c(0.25, 0, 0, 0.25),
# # #   "C" = c(0, 0.25, 0, 0),
# # #   "D" = c(0, 0, 0.25, 0)
# # # )
# # # test_adj_matrix_3 <- data.frame(
# # #   "A" = c(0, 0, 0, 0),
# # #   "B" = c(0.75, 0, 0, 0.75),
# # #   "C" = c(0, 0.75, 0, 0),
# # #   "D" = c(0, 0, 0.75, 0)
# # # )
# # # test_adj_matrix_4 <- data.frame(
# # #   "A" = c(0, 0, 0, 0),
# # #   "B" = c(0.5, 0, 0, 0.5),
# # #   "C" = c(0, 0.5, 0, 0),
# # #   "D" = c(0, 0, 0.5, 0)
# # # )
# # # test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
# # #
# # # shinytest2::load_app_env(renv = rlang::global_env(), globalrenv = rlang::global_env())
# # #
# # # shinytest2::record_test("inst/shiny")
# # #
# # # library(shinytest2)
# # #
# # #
# # #
# # #
# # # app <- AppDriver$new(app_dir = "inst/shiny")
# # # app$set_inputs(test_adj_matrices = test_fcms)
# # # app$set_inputs(activation = "modified-kosko")
# # #
# # # app$get_value(input = "adj_matrices")
# # #
# # # app$get_values()
# #
# # test_dir(
# #   "tests/testthat",
# #   shiny::loadSupport(appDir = "inst/shiny"),
# #   reporter = c("progress", "fail")
# # )
# #
# #
# #
