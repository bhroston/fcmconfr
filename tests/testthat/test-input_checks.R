# test-input_checks.R
#
#   - check_fcmconfr_input
#   - check_square_adj_matrix
#   - check_numeric_vector
#   - check_choice_selection
#   - check_positive_number
#   - check_positive_integer
#   - check_logical
#   - assert_var_name
#   - check_access_to_parallel_processing_and_progress_display_functionalities
#
################################################################################

requireNamespace("data.table")
requireNamespace("Matrix")


test_that("check_fcmconfr_input works", {
  test_mat <- sample_fcms$simple_fcms$conventional_fcms[[1]]

  # Confirm error if check is not an available option
  expect_error(check_fcmconfr_input(x = 1, check = "not_available"))

  # Confirm error if chocie_selection but no choice_selection_opts given
  expect_error(check_fcmconfr_input(x = "sigmoid", check = "choice_selection", var_name = "squashing"))

  # Confirm error if choices left blank
  expect_error(check_fcmconfr_input(x = "sigmoid", check = "choice_selection", var_name = "squashing", choice_selection_opts = c()))

  # Confirm error if multiple checks given
  expect_error(check_fcmconfr_input(x = 1, check = c("square_adj_matrix", "choice_selection")))

  expect_no_error(check_fcmconfr_input(sample_fcms$simple_fcms$conventional_fcms, check = "adj_matrix_list"))
  expect_no_error(check_fcmconfr_input(test_mat, check = "square_adj_matrix", "adj_matrix"))
  expect_no_error(check_fcmconfr_input("sigmoid", check = "choice_selection", var_name = "squashing", choice_selection_opts = c("sigmoid", "squashing")))
  expect_no_error(check_fcmconfr_input(c(1, 1, 1), check = "numeric_vector", "state_vector"))
  expect_no_error(check_fcmconfr_input(c(ivfn(1, 1), ivfn(1, 1)), check = "ivfn_vector", "state_vector"))
  expect_no_error(check_fcmconfr_input(c(tfn(1, 1, 1), tfn(1, 1, 1)), check = "tfn_vector", "state_vector"))
  expect_no_error(check_fcmconfr_input(1.1, check = "positive_number", "lambda"))
  expect_no_error(check_fcmconfr_input(1, check = "positive_integer", "max_iter"))
  expect_no_error(check_fcmconfr_input(TRUE, check = "logical", "include_zeroes"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_fcmconfr_input")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_adj_matrix_list works", {

  # Confirm no error if only 1 adj matrix
  expect_no_error(check_adj_matrix_list(sample_fcms$simple_fcms$conventional_fcms[[1]]))

  # Confirm error if multiple FCM classes
  test_adj_mat_list <- c(sample_fcms$simple_fcms$conventional_fcms, sample_fcms$simple_fcms$ivfn_fcms)
  expect_error(check_adj_matrix_list(test_adj_mat_list))

  # Confirm error if FCM class is not Conventional, IVFN, or TFN
  test_adj_mat_list <- sample_fcms$simple_fcms$conventional_fcms
  test_adj_mat_list <- lapply(test_adj_mat_list, function(mat) rbind(mat, mat))
  suppressMessages(expect_error(check_adj_matrix_list(test_adj_mat_list)))

  # Confirm error if FCMs have different dimensions
  test_adj_mat_list <- sample_fcms$simple_fcms$conventional_fcms
  test_adj_mat_list <- lapply(test_adj_mat_list, function(mat) rbind(mat, mat))
  test_adj_mat_list <- lapply(test_adj_mat_list, function(mat) cbind(mat, mat))
  test_adj_mat_list <- c(test_adj_mat_list, sample_fcms$simple_fcms$conventional_fcms)
  expect_error(check_adj_matrix_list(test_adj_mat_list))

  # Confirm true if only 1 adj. matrix given
  test_adj_mat_list <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  expect_true(check_adj_matrix_list(test_adj_mat_list))

  # Confirm true if only 1 adj. matrix given
  test_adj_mat_list <- list(sample_fcms$simple_fcms$conventional_fcms[[1]])
  expect_true(check_adj_matrix_list(test_adj_mat_list))

  # Confirm error if any missing adjacency matrices
  test_adj_mat_list <- list(sample_fcms$simple_fcms$conventional_fcms[[1]], NA)
  expect_error(check_adj_matrix_list(test_adj_mat_list))

  expect_true(check_adj_matrix_list(sample_fcms$simple_fcms$conventional_fcms))

  expect_true(check_adj_matrix_list(sample_fcms$simple_fcms$ivfn_fcms))

  expect_true(check_adj_matrix_list(sample_fcms$simple_fcms$tfn_fcms))

  # test_adj_mat_list <- lapply(test_adj_mat_list,
  #                             function(adj_mat) {
  #                               class(adj_mat) <- NULL
  #                               adj_mat <- do.call(cbind, adj_mat)
  #                               structure(.Data = adj_mat, class = "Different")
  #                             })

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_adj_matrix_list")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_square_adj_matrix works", {

  # Confirm error on multiple input adj. matrices
  test_mats <- list(matrix(1:9, nrow = 3), matrix(1:9, nrow = 3))
  expect_error(check_square_adj_matrix(test_mats))

  # Confirm no warning on sparseMatrix
  test_mat <- Matrix::Matrix(1:9, nrow = 3, sparse = TRUE)
  expect_true(check_square_adj_matrix(test_mat))

  # Confirm no warning on custom class
  test_mat <- structure(.Data = matrix(1:9, nrow = 3), class = "different")
  expect_true(check_square_adj_matrix(test_mat))

  # Confirm error on improper format data that cannot be turned into dataframe
  test_mat <- structure(.Data = list(c(1, 1), c(1, 1, 1), c(1)), class = "different")
  expect_error(check_square_adj_matrix(test_mat))

  # Confirm error on non-square matrices
  test_mat <- matrix(1:12, nrow = 4)
  expect_error(check_square_adj_matrix(test_mat))

  # Confirm error if adjacency matrix = NA
  expect_error(check_square_adj_matrix(NA))

  # Confirm error if adjacency matrix contains missing data
  test_mat <- sample_fcms$simple_fcms$conventional_fcms[[1]]
  test_mat[1, 4] <- NA
  expect_error(check_square_adj_matrix(test_mat))

  test_mat <- matrix(1:9, nrow = 3)
  expect_true(check_square_adj_matrix(test_mat))

  test_mat <- array(data = 1:9, dim = c(3, 3))
  expect_true(check_square_adj_matrix(test_mat))

  test_mat <- data.frame(matrix(1:9, nrow = 3))
  expect_true(check_square_adj_matrix(test_mat))

  test_mat <- data.table::data.table(matrix(1:9, nrow = 3))
  expect_true(check_square_adj_matrix(test_mat))

  test_mat <- tibble::as_tibble(matrix(1:9, nrow = 3), .name_repair = "minimal")
  expect_true(check_square_adj_matrix(test_mat))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_square_adj_matrix")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_numeric_vector works", {

  # Confirm error if NA values found
  test_vec <- c(1, NA, 1)
  expect_error(check_numeric_vector(test_vec, "test_vec"))

  # Confirm error if non-numeric values found
  test_vec <- c(1, "a", 1)
  expect_error(check_numeric_vector(test_vec))

  # Confirm no error if non-numeric values can be converted to numeric
  test_vec <- c("1", "2")
  expect_true(check_numeric_vector(test_vec, var_name = "test_vec"))

  # Confirm error if non-numeric values cannot be converted to numeric
  test_vec <- c("one", "two")
  expect_error(check_numeric_vector(test_vec, var_name = "test_vec"))

  test_vec <- c(1, 1, 1, 1)
  expect_true(check_numeric_vector(test_vec, var_name = "test_vec"))

  expect_true(check_numeric_vector(c(), var_name = "empty"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_fcmconfr_inputs")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_ivfn_vector works", {

  # Confirm error if vector contains NA values
  test_vec <- c(ivfn(1, 1), NA)
  expect_error(check_ivfn_vector(test_vec))

  # Confirm error for multiple input types
  test_vec <- c(ivfn(1, 1), 1)
  expect_error(check_ivfn_vector(test_vec, var_name = "test_vec"))

  # Confirm error for incorrect input types
  test_vec <- c(1, 1)
  expect_error(check_ivfn_vector(test_vec, var_name = "test_vec"))

  test_vec <- c(ivfn(1, 1), ivfn(1, 1))
  expect_true(check_ivfn_vector(test_vec, var_name = "test_vec"))
})


test_that("check_tfn_vector works", {

  # Confirm error if vector contains NA values
  test_vec <- c(tfn(1, 1, 1), NA)
  expect_error(check_tfn_vector(test_vec))

  # Confirm error for multiple input types
  expect_error(check_tfn_vector(c(tfn(1, 1), 1), var_name = "test_vec"))

  # Confirm error for incorrect input types
  test_vec <- c(1, 1)
  expect_error(check_tfn_vector(test_vec, var_name = "test_vec"))

  test_vec <- c(tfn(1, 1, 1), tfn(1, 1, 1))
  expect_true(check_tfn_vector(test_vec, var_name = "test_vec"))
})


test_that("check_choice_selection works", {

  # Confirm error for multiple inputs
  expect_error(check_choice_selection(opts, choices = opts))

  # Confirm error for non-match
  random_chars <- paste0(sample(c(letters, LETTERS), size = 10), collapse = "")
  expect_error(check_choice_selection(random_chars, c("sigmoig", "tanh")))

  opts <- c("sigmoid", "tanh")
  expect_true(check_choice_selection("sigmoid", opts, "test"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_choice_selection")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_fcmconfr_inputs")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_positive_number works", {

  # Confirm error if missing value
  expect_error(check_positive_number(NA))

  # Confirm error if more than one input given
  expect_error(check_positive_number(c(1, 1), "lambda"))

  # Confirm error if character value cannot be transformed using as.numeric
  expect_error(check_positive_number("one", "lambda"))

  # Confirm error on negative input
  expect_error(check_positive_number(-1, "lambda"))

  expect_true(check_positive_number(1, "lambda"))

  expect_true(check_positive_integer("1", "lambda"))

  expect_true(check_positive_number(1.1, "lambda"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_positive_number")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_positive_integer works", {

  # Confirm error if missing value
  expect_error(check_positive_integer(NA))

  # Confirm error if negative value
  expect_error(check_positive_integer(-1, "max_iter"))

  # Confirm error if numeric but not integer
  expect_error(check_positive_integer(1.1, "max_iter"))

  # Confirm error if more than one input given
  expect_error(check_positive_integer(c(1, 1), "max_iter"))

  # Confirm error if non-integer
  expect_error(check_positive_integer("one", "max_iter"))

  expect_true(check_positive_integer(1, "max_iter"))

  expect_true(check_positive_integer("1", "max_iter"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_positive_integer")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_logical works", {

  # Confirm error on multiple value input
  expect_error(check_logical(c(TRUE, FALSE), var_name = "include_zeroes"))

  # Confirm no error if string can be converted to logical
  expect_no_error(check_logical("TRUE", var_name = "include_zeroes"))

  # Confirm error on non-logical input
  expect_error(check_logical(1.23421, var_name = "include_zeroes"))

  expect_true(check_logical(TRUE, var_name = "include_zeroes"))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_logical")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("assert_var_name works", {

  # Confirm error if multiple var_names given
  expect_error(assert_var_name(var_name_input = c("asdv", "asdfas")))

  # Confirm error if var_name is NA
  expect_error(assert_var_name(var_name_input = NA))

  expect_no_error(assert_var_name(var_name = 1))

  expect_no_error(assert_var_name(var_name = "test_var_name"))
})


test_that("check_access_to_parallel_processing_and_progress_display_functionalities works", {

  # Confirm warning if 'parallel' 'doSNOW' or 'foreach' packages missing and use_parallel = TRUE and use_show_progress = TRUE
  # testing_use_parallel = TRUE testing_use_show_progress = FALSE
  expect_warning(
    check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = TRUE, testing_use_parallel = TRUE, testing_use_show_progress = FALSE)
  )

  # Confirm warning if 'parallel' 'doSNOW' or 'foreach' packages missing and use_parallel = TRUE and use_show_progress = TRUE
  # testing_use_parallel = TRUE testing_use_show_progress = TRUE
  expect_warning(
    check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = TRUE, testing_use_parallel = TRUE, testing_use_show_progress = TRUE)
  )

  # Confirm warning if 'parallel' 'doSNOW' or 'foreach' packages missing and use_parallel = TRUE and use_show_progress = FALSE
  # testing_use_parallel = TRUE testing_use_show_progress = FALSE
  expect_warning(
    check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = FALSE, testing_use_parallel = TRUE, testing_use_show_progress = FALSE)
  )

  # Confirm warning if 'parallel' 'doSNOW' or 'foreach' packages missing and use_parallel = TRUE and use_show_progress = FALSE
  # testing_use_parallel = TRUE testing_use_show_progress = TRUE
  expect_warning(
    check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = FALSE, testing_use_parallel = TRUE, testing_use_show_progress = TRUE)
  )

  # Confirm warning if 'pbapply' package missing and use_parallel = FALSE and use_show_progress = TRUE
  # testing_use_parallel = FALSE testing_use_show_progress = TRUE
  expect_warning(
    check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = FALSE, use_show_progress = TRUE, testing_use_parallel = FALSE, testing_use_show_progress = TRUE)
  )

  expect_no_error(check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = TRUE))

  expect_no_error(check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = TRUE, use_show_progress = FALSE))

  expect_no_error(check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = FALSE, use_show_progress = FALSE))

  expect_no_error(check_access_to_parallel_processing_and_progress_display_functionalities(use_parallel = FALSE, use_show_progress = TRUE))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_access_to_parallel_processing_and_progress_display_functionalities")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})



#
# functions_to_check <- c("check_square_adj_matrix",
#                          "check_numeric_vector",
#                          "check_choice_selection",
#                          "check_positive_number",
#                          "check_positive_integer")
#  yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
#  res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
#
#
# yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_fcmconfr_input")
# res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
#
#
#
#
# test_data <- autotest::autotest_types()
#
# test_data <- test_data[test_data$test_name %in% tests_to_check, ]
# res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE, test_data = test_data)
#
# res <- autotest::autotest_yaml(yaml = yaml_list,
#                                test = TRUE,
#                                test_data = test_data)
# print (xt2)
#
