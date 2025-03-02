
# aggregate_fcms.R - Checks pass
test_that("aggregate_fcms functions pass autotest", {
  functions_to_check <- c("aggregate_fcms", "print.aggregate")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)

  autotest::expect_autotest_no_err(x)
  autotest::expect_autotest_no_warn(x)
})


# estimate_fcm_lambda - Checks pass
test_that("estimate_fcm_lambda passes autotest", {
  functions_to_check <- c("estimate_fcm_lambda")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


# test_that("fcm_view passes autotest", {
#   test_data <- autotest::autotest_types(notest = "negate_logical")
#   test_data$notes <- ""
#   test_data$note[test_data$test == "negate_logical"] <-
#     "This test is not applicable because it opens a Shiny app that requires
#     user input and would stall autotest run."
#
#   x <- autotest::autotest_package(
#     functions = "fcm_view",
#     test = TRUE,
#     test_data = test_data
#   )
#
#   autotest::expect_autotest_no_err(x)
#   autotest::expect_autotest_no_warn(x)
# })

# infer_and_simulate_fcm - Checks pass
test_that("infer_and_simulate_fcm functions pass autotest", {
  functions_to_check <- c("infer_fcm_set", "infer_fcm")
  # functions_to_check <- c("infer_fcm")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


# IVFNs_and_TFNs - Checks pass
test_that("IVFNs_and_TFNs functions pass autotest", {
  functions_to_check <- c("defuzz_ivfn_or_tfn",
                          "make_adj_matrix_w_ivfns", "ivfn", "subtract_ivfn", "print.ivfn", "c.ivfn",
                          "make_adj_matrix_w_tfns", "tfn", "subtract_tfn", "print.tfn", "c.tfn", "rtriangular_dist", "plot.rtriangular_dist")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


# monte_carlo_model_generation_and_confidence_intervals
test_that("monte_carlo and CI functions pass", {
  functions_to_check <- c("build_monte_carlo_fcms")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})





# utils-general.R - Checks pass
test_that("utils-general.R functions pass autotest", {
  functions_to_check <- c("standardize_adj_matrices")
  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})
