#' @srrstats {G5.10} Extended tests can be switched on via setting the
#' environment variable FCMCONFR_EXTENDED_TESTS to "true".
#' @srrstats {G5.11, G5.11a} No large data sets are used in the extended tests.
#' @srrstats {G5.12} Instructions on how to run extended tests is provided in
#' tests/README.md.
#' @srrstatsTODO {BS7.3} Tests include scaling tests for algorithmic efficiency
#' with sizes of input data.
#' @srrstatsTODO {G5.7} Tests include algorithm performance tests.



run_extended_tests <- identical(Sys.getenv("FCMCONFR_EXTENDED_TESTS"), "true")

test_that("fcmconfr scales appropriately with additional adjacency matrices", {
  skip_if_not(run_extended_tests)

  get_runtime_of_standard_fcmconfr_call <- function(fcm_set) {
    start_time <- Sys.time()
    test_fcmconfr <- invisible(capture.output(
       fcmconfr(
        adj_matrices = fcm_set,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = 1000,
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
        parallel = FALSE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = TRUE,
        include_sims_in_output = TRUE
      )
    ))
    finish_time <- Sys.time()
    run_time <- finish_time - start_time
    return(run_time)
  }

  fcm_set_conventional_n_5 <- sample_fcms$simple_fcms$conventional_fcms[1:5]
  fcm_set_conventional_n_10 <- sample_fcms$simple_fcms$conventional_fcms[1:10]
  fcm_set_conventional_n_15 <- sample_fcms$simple_fcms$conventional_fcms[1:15]
  fcm_set_conventional_n_20 <- sample_fcms$simple_fcms$conventional_fcms[1:20]
  fcm_set_conventional_n_25 <- sample_fcms$simple_fcms$conventional_fcms[1:25]
  fcm_set_conventional_n_30 <- sample_fcms$simple_fcms$conventional_fcms[1:30]

  runtime_conventional_n_5 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_5)
  runtime_conventional_n_10 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_10)
  runtime_conventional_n_15 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_15)
  runtime_conventional_n_20 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_20)
  runtime_conventional_n_25 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_25)
  runtime_conventional_n_30 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30)
  # beepr::beep(1)

  scale_test_res_conventional <- data.frame(
    n_fcms = c(5, 10, 15, 20, 25, 30),
    runtime = c(runtime_conventional_n_5, runtime_conventional_n_10, runtime_conventional_n_15,
                runtime_conventional_n_20, runtime_conventional_n_25, runtime_conventional_n_30)
  )
  scale_test_res_conventional$fcm_class <- "conventional"


  fcm_set_ivfn_n_5 <- sample_fcms$simple_fcms$ivfn_fcms[1:5]
  fcm_set_ivfn_n_10 <- sample_fcms$simple_fcms$ivfn_fcms[1:10]
  fcm_set_ivfn_n_15 <- sample_fcms$simple_fcms$ivfn_fcms[1:15]
  fcm_set_ivfn_n_20 <- sample_fcms$simple_fcms$ivfn_fcms[1:20]
  fcm_set_ivfn_n_25 <- sample_fcms$simple_fcms$ivfn_fcms[1:25]
  fcm_set_ivfn_n_30 <- sample_fcms$simple_fcms$ivfn_fcms[1:30]

  runtime_ivfn_n_5 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_5)
  runtime_ivfn_n_10 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_10)
  runtime_ivfn_n_15 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_15)
  runtime_ivfn_n_20 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_20)
  runtime_ivfn_n_25 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_25)
  runtime_ivfn_n_30 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30)
  # beepr::beep(1)

  scale_test_res_ivfn <- data.frame(
    n_fcms = c(5, 10, 15, 20, 25, 30),
    runtime = c(runtime_ivfn_n_5, runtime_ivfn_n_10, runtime_ivfn_n_15,
                runtime_ivfn_n_20, runtime_ivfn_n_25, runtime_ivfn_n_30)
  )
  scale_test_res_ivfn$fcm_class <- "ivfn"


  fcm_set_tfn_n_5 <- sample_fcms$simple_fcms$tfn_fcms[1:5]
  fcm_set_tfn_n_10 <- sample_fcms$simple_fcms$tfn_fcms[1:10]
  fcm_set_tfn_n_15 <- sample_fcms$simple_fcms$tfn_fcms[1:15]
  fcm_set_tfn_n_20 <- sample_fcms$simple_fcms$tfn_fcms[1:20]
  fcm_set_tfn_n_25 <- sample_fcms$simple_fcms$tfn_fcms[1:25]
  fcm_set_tfn_n_30 <- sample_fcms$simple_fcms$tfn_fcms[1:30]

  runtime_tfn_n_5 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_5)
  runtime_tfn_n_10 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_10)
  runtime_tfn_n_15 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_15)
  runtime_tfn_n_20 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_20)
  runtime_tfn_n_25 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_25)
  runtime_tfn_n_30 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30)
  # beepr::beep(1)

  scale_test_res_tfn <- data.frame(
    n_fcms = c(5, 10, 15, 20, 25, 30),
    runtime = c(runtime_tfn_n_5, runtime_tfn_n_10, runtime_tfn_n_15,
                runtime_tfn_n_20, runtime_tfn_n_25, runtime_tfn_n_30)
  )
  scale_test_res_tfn$fcm_class <- "tfn"


  fcmconfr_n_fcms_runtimes <- rbind(scale_test_res_conventional, scale_test_res_ivfn, scale_test_res_tfn)

  # Add theme-ing
  ggplot2::ggplot(fcmconfr_n_fcms_runtimes) +
    # ggplot2::geom_point(aes(x = n_fcms, y = runtime/60, color = fcm_class)) +
    ggplot2::geom_line(aes(x = n_fcms, y = runtime/60, color = fcm_class)) +
    ggplot2::geom_text(aes(x = n_fcms, y = runtime/60, label = fcm_class), fill = "white") +
    ggplot2::theme_classic() +
    ggplot2::labs(
      x = "# FCMs in Input Set",
      y = "Runtime \n(mins)",
      color = NULL
    )
})



test_that("fcmconfr scales appropriately with additional adjacency matrices", {
  skip_if_not(run_extended_tests)

  get_runtime_of_standard_fcmconfr_call <- function(fcm_set, num_mc_fcms) {
    start_time <- Sys.time()
    test_fcmconfr <- invisible(capture.output(
      fcmconfr(
        adj_matrices = fcm_set,
        # Aggregation and Monte Carlo Sampling
        agg_function = 'mean',
        num_mc_fcms = num_mc_fcms,
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
        parallel = FALSE,
        n_cores = 2,
        # Additional Options
        run_agg_calcs = TRUE,
        run_mc_calcs = TRUE,
        run_ci_calcs = TRUE,
        include_zeroes_in_sampling = TRUE,
        include_sims_in_output = TRUE
      )
    ))
    finish_time <- Sys.time()
    run_time <- finish_time - start_time
    return(run_time)
  }

  fcm_set_conventional_n_30 <- sample_fcms$simple_fcms$conventional_fcms[1:30]

  runtime_conventional_n_30_mc_100 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30, 100)
  runtime_conventional_n_30_mc_200 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30, 200)
  runtime_conventional_n_30_mc_500 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30, 500)
  runtime_conventional_n_30_mc_1000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30, 1000)
  runtime_conventional_n_30_mc_2000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_conventional_n_30, 2000)
  # beepr::beep(1)

  scale_test_res_conventional <- data.frame(
    n_mc_fcms = c(100, 200, 500, 1000, 2000),
    runtime = c(runtime_conventional_n_30_mc_100, runtime_conventional_n_30_mc_200, runtime_conventional_n_30_mc_500,
                runtime_conventional_n_30_mc_1000, runtime_conventional_n_30_mc_2000)
  )
  scale_test_res_conventional$fcm_class <- "conventional"


  fcm_set_ivfn_n_30 <- sample_fcms$simple_fcms$ivfn_fcms[1:30]

  runtime_ivfn_n_30_mc_100 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30, 100)
  runtime_ivfn_n_30_mc_200 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30, 200)
  runtime_ivfn_n_30_mc_500 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30, 500)
  runtime_ivfn_n_30_mc_1000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30, 1000)
  runtime_ivfn_n_30_mc_2000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_ivfn_n_30, 2000)
  # beepr::beep(1)

  scale_test_res_ivfn <- data.frame(
    n_mc_fcms = c(100, 200, 500, 1000, 2000),
    runtime = c(runtime_ivfn_n_30_mc_100, runtime_ivfn_n_30_mc_200, runtime_ivfn_n_30_mc_500,
                runtime_ivfn_n_30_mc_1000, runtime_ivfn_n_30_mc_2000)
  )
  scale_test_res_ivfn$fcm_class <- "ivfn"




  fcm_set_tfn_n_30 <- sample_fcms$simple_fcms$tfn_fcms[1:30]

  runtime_tfn_n_30_mc_100 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30, 100)
  runtime_tfn_n_30_mc_200 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30, 200)
  runtime_tfn_n_30_mc_500 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30, 500)
  runtime_tfn_n_30_mc_1000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30, 1000)
  runtime_tfn_n_30_mc_2000 <- get_runtime_of_standard_fcmconfr_call(fcm_set_tfn_n_30, 2000)
  # beepr::beep(1)

  scale_test_res_tfn <- data.frame(
    n_mc_fcms = c(100, 200, 500, 1000, 2000),
    runtime = c(runtime_tfn_n_30_mc_100, runtime_tfn_n_30_mc_200, runtime_tfn_n_30_mc_500,
                runtime_tfn_n_30_mc_1000, runtime_tfn_n_30_mc_2000)
  )
  scale_test_res_tfn$fcm_class <- "tfn"


  fcmconfr_n_mc_fcms_runtimes <- rbind(scale_test_res_conventional, scale_test_res_ivfn, scale_test_res_tfn)
  # saveRDS(fcmconfr_n_mc_fcms_runtimes, "fcmconfr_n_mc_fcms_runtimes.RDS")

  # Add theme-ing
  ggplot2::ggplot(fcmconfr_n_mc_fcms_runtimes) +
    # ggplot2::geom_point(aes(x = n_fcms, y = runtime/60, color = fcm_class)) +
    ggplot2::geom_line(aes(x = n_mc_fcms, y = runtime/60, color = fcm_class)) +
    ggplot2::geom_text(aes(x = n_mc_fcms, y = runtime/60, label = fcm_class)) +
    ggplot2::theme_classic() +
    ggplot2::labs(
      x = "# FCMs in Input Set",
      y = "Runtime \n(mins)",
      color = NULL
    )
})



