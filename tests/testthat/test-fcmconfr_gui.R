
# File: tests/testthat/test-sample_app.R
library(shinytest2)

test_that("fcmconfr_gui works", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  x <- sample_fcms$simple_fcms$conventional_fcms
  test_env <- new.env()
  test_env$x <- x
  app_obj <- fcmconfr_gui(test_env)
  suppressWarnings({
    app <- shinytest2::AppDriver$new(app_obj, variant = shinytest2::platform_variant())
  })

  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(adj_matrices = "x")
  # Update output value
  app$set_inputs(state_vector_tabs = "Clamping Vector")
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(`clamping_Salts.Added.during.Water.Treatment` = 1)
  # Update output value
  app$set_inputs(nav_panel = "Agg. and Monte Carlo Options")
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(perform_monte_carlo = FALSE)
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(perform_monte_carlo = TRUE)
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(num_mc_fcms = 2000)
  app$set_inputs(nav_panel = "Simulation Options")
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$set_inputs(activation = "modified-kosko")
  # Update output value
  app$set_inputs(squashing = "tanh")
  # Update output value
  app$set_inputs(lambda = 0.5)
  app$set_inputs(point_of_inference = "peak")
  app$click("get_code")
  # Update output value
  app$set_window_size(width = 1201, height = 765)
  app$run_js("document.querySelector('#fcmconfr_code_snippet')?.scrollIntoView({block: 'center'});")
  app$expect_screenshot()
})


#   app$set_inputs(adj_matrices = x, wait_ = FALSE)
#   app$get_html(id = "adj_matrix")
#
#   shinytest2::record_test(app)
#
#   expect_true(app$exists(id = "adj_matrices"))
#
#
#
#   x <- sample_fcms$simple_fcms$conventional_fcms
#
#   app <- local({
#     foo3 <- 19  # Nested local variable
#     fcmconfr_gui
#   })
#
#
#
#
#
#
#
#   dummy_function <- function() {
#     x <- sample_fcms$simple_fcms$conventional_fcms
#     environment(x) <- .pkg_ns
#   }
#   dummy_function_injection_script_1 <- as.list(body(dummy_function))[[2]]
#   dummy_function_injection_script_2 <- as.list(body(dummy_function))[[3]]
#
#
#   app <- shinytest2::AppDriver$new(test_fcmconfr_gui, name = "hello")
#
#   app$set_inputs(c("adj_matrices", sample_fcms$simple_fcms$conventional_fcms))
#
#   app_dir_body <- body(app[[".__enclos_env__"]][["private"]][["dir"]])
#   new_app_dir_body <- vector(mode = "list", length = length(app_dir_body)+2)
#   new_app_dir_body[1:3] <- as.list(app_dir_body)[1:3]
#   new_app_dir_body[[4]] <- dummy_function_injection_script_1
#   new_app_dir_body[[5]] <- dummy_function_injection_script_2
#   new_app_dir_body[6:8] <- as.list(app_dir_body)[4:6]
#   body(app[[".__enclos_env__"]][["private"]][["dir"]]) <- new_app_dir_body
#
#
#
#   shinytest2::record_test(app)
#
#
#
#
#
#   .GlobalEnv$myvar <- 123
#   app <- shinytest2::AppDriver$new(fcmconfr_gui, name = "hello")
#   app$set_inputs(adj_matrices = sample_fcms$simple_fcms$conventional_fcms)
#   shinytest2::record_test(app)
#
#   shiny_env <- new.env()
#   fcmconfr_gui()
#
#   # server <- source(system.file(file.path('shiny', 'fcmconfr_gui', 'server.R'), package = 'fcmconfr'), local = TRUE)$value
#   # ui <- source(system.file(file.path('shiny', 'fcmconfr_gui', 'ui.R'), package = 'fcmconfr'), local = TRUE)$value
#   # environment(ui) <- shiny_env
#   # environment(server) <- shiny_env
#
#
#
#
#
#   testapp_fcmconfr_gui <- function() {
#     library(fcmconfr)
#     shiny::shinyApp(
#       ui = source(system.file(file.path('shiny', 'fcmconfr_gui', 'ui.R'), package = 'fcmconfr'), local = TRUE)$value,
#       server = source(system.file(file.path('shiny', 'fcmconfr_gui', 'server.R'), package = 'fcmconfr'), local = TRUE)$value
#     )
#   }
#
#   shiny_app <- testapp_fcmconfr_gui()
#
#   # Load app1's support files (modules.R, etc.)
#   x <- sample_fcms$simple_fcms$conventional_fcms
#   environment(x) <-
#   app <- shinytest2::AppDriver$new(shiny_app, name = "hello")
#   shinytest2::record_test(app)
#
#
#   app$expect_values()
#
#
#   x <- sample_fcms$simple_fcms$conventional_fcms
#
#   fcmconfr_gui_test <- function(data, ...) {
#     .GlobalEnv$myvar <- x
#
#     library(fcmconfr)
#     app_path <- file.path(getwd(), "tests", "testthat", "apps", "testapp-fcmconfr_gui")
#     shiny::runApp(app_path)
#   }
#
#   function_gui_data_test <- function(data, ...) {
#     shiny::runApp(fcmconfr_gui_test(data, ...))
#   }
#
#   app <- shinytest2::AppDriver$new(fcmconfr_gui_test, name = "hello")
#
#   shinytest2::record_test()
#
#
#   test_shiny_env <- new.env()
#   app <- shinytest2::AppDriver$new(fcmconfr_gui, name = "hello")
#   environment(app) <- test_shiny_env
#   x <- sample_fcms$simple_fcms$conventional_fcms
#   environment(x) <- test_shiny_env
#   shinytest2::record_test(app)
#
#   app_dir <- testthat::test_path("apps/testapp-fcmconfr_gui")
#   app <- shinytest2::AppDriver$new(shiny_app, name = "hello")
#   environment(app) <- test_shiny_env
#
#   app_fun <- function() {
#     shiny_env <- new.env()
#     fcmconfr_gui()
#   }
#
#   test_shiny_env <- new.env()
#   drv <- shinytest2::AppDriver$new(app = fcmconfr_gui())
#   environment(drv) <- test_shiny_env
#   drv$record_test()
#
#
#
# })


# test_that("fcmconfr_gui works (manually)", {
#
#   test_conventional_fcms <- sample_fcms$simple_fcms$conventional_fcms
#
#   fcmconfr_gui()
#
#   x <- fcmconfr(
#     adj_matrices = test_conventional_fcms,
#     # Aggregation and Monte Carlo Sampling
#     agg_function = 'mean',
#     num_mc_fcms = 1000,
#     # Simulation
#     initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
#     clamping_vector = c(0, 1, 0, 0, 0, 0, 0),
#     activation = 'kosko',
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
#     n_cores = 1,
#     # Additional Options
#     run_agg_calcs = TRUE,
#     run_mc_calcs = TRUE,
#     run_ci_calcs = TRUE,
#     include_zeroes_in_sampling = TRUE,
#     include_sims_in_output = TRUE
#   )
#
#   x <- fcmconfr(
#     adj_matrices = test_conventional_fcms,
#     # Aggregation and Monte Carlo Sampling
#     agg_function = 'mean',
#     num_mc_fcms = 1000,
#     # Simulation
#     initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
#     clamping_vector = c(0, 1, 0, 0, 0, 0, 0),
#     activation = 'kosko',
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
#     parallel = FALSE,
#     n_cores = 1,
#     # Additional Options
#     run_agg_calcs = TRUE,
#     run_mc_calcs = TRUE,
#     run_ci_calcs = TRUE,
#     include_zeroes_in_sampling = TRUE,
#     include_sims_in_output = TRUE
#   )
# })


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
