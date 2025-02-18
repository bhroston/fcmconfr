
test_that("aggregate_fcms functions pass autotest", {
  functions_to_test <- c(
    "aggregate_fcms",
    "aggregate_conventional_fcms", "aggregate_fcms_w_ivfns", "aggregate_fcms_w_tfns",
    "print.aggregate"
  )

  test_data <- autotest::autotest_types()
  test_data$notes <- ""

  x <- autotest::autotest_package(
    functions = functions_to_test,
    test = TRUE,
    test_data = test_data
  )

  autotest::expect_autotest_no_err(x)
  autotest::expect_autotest_no_warn(x)
})


test_that("estimate_fcm_lambda passes autotest", {
  test_data <- autotest::autotest_types()
  test_data$notes <- ""

  x <- autotest::autotest_package(
    functions = "estimate_fcm_lambda",
    test = TRUE,
    test_data = test_data
  )

  autotest::expect_autotest_no_err(x)
  autotest::expect_autotest_no_warn(x)
})


test_that("fcm_view passes autotest", {
  test_data <- autotest::autotest_types(notest = "negate_logical")
  test_data$notes <- ""
  test_data$note[test_data$test == "negate_logical"] <-
    "This test is not applicable because it opens a Shiny app that requires
    user input and would stall autotest run."

  x <- autotest::autotest_package(
    functions = "fcm_view",
    test = TRUE,
    test_data = test_data
  )

  autotest::expect_autotest_no_err(x)
  autotest::expect_autotest_no_warn(x)
})



yaml_list <- examples_to_yaml(package = ".", functions = functions_to_test)
res <- autotest_yaml(yaml = yaml_list, test = TRUE)

autotest::expect_autotest_no_err(res)
autotest::expect_autotest_no_warn(res)
