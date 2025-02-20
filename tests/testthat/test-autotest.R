
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


test_that("utils-general functions pass autotest", {
  functions_to_test <- c(
    "standardize_adj_matrices",
    "check_if_local_machine_has_access_to_parallel_processing_functionalities",
    "check_if_local_machine_has_access_to_show_progress_functionalities",
    "get_adj_matrices_input_type",
    "get_node_IDs_from_input"
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


test_that("infer_and_simulate_fcm functions pass autotest", {

  #   Exported
  #   - infer_fcm_set
  #   - infer_fcm
  #   - infer_conventional_fcm
  #   - infer_ivfn_or_tfn_fcm
  #   - simulate_fcm
  #   - simulate_conventional_fcm
  #   - simulate_ivfn_or_tfn_fcm
  #   - squash
  #
  #   Not Exported
  #   - check_infer_fcm_set_inputs
  #   (No Autotest) - calculate_next_conventional_fcm_state_vector (Add examples? Include in package?)
  #   (No Autotest) - calculate_next_fuzzy_set_fcm_state_vector (Add examples? Include in package?)
  #   (Good) - convert_element_to_ivfn_or_tfn_if_numeric
  #   - convert_fuzzy_set_elements_in_matrix_to_distributions
  #   (No Autotest) - clean_simulation_output
  #   (No Autotest) - check_simulation_inputs
  #   (No Autotest) - print.infer_conventional_fcm
  #   (No Autotest) - print.infer_ivfn_or_tfn_fcm

  test_data <- autotest::autotest_types()
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

  yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_simulation_inputs")
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)


  yaml_list <- autotest::examples_to_yaml(package = ".", functions = "convert_fuzzy_set_elements_in_matrix_to_distributions")
  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)


})



# yaml_list <- examples_to_yaml(package = ".", functions = functions_to_test)
# res <- autotest_yaml(yaml = yaml_list, test = TRUE)
#
# autotest::expect_autotest_no_err(res)
# autotest::expect_autotest_no_warn(res)
