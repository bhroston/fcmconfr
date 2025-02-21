
test_that("check_square_adj_matrix works", {

  # Confirm matrix, array, data.frame, data.table, and tibble classes accepted
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

  test_mat <- Matrix::Matrix(1:9, nrow = 3, sparse = TRUE)
  expect_false(isTRUE(suppressMessages(
    check_square_adj_matrix(test_mat)
  )))

  # Confirm error on non-acceptable classes
  test_mat <- structure(.Data = matrix(1:9, nrow = 3), class = "wrong_class")
  expect_error(suppressMessages(
    check_square_adj_matrix(test_mat)
  ))

  # Confirm error on non-square matrices
  test_mat <- matrix(1:12, nrow = 4)
  expect_error(suppressMessages(check_square_adj_matrix(test_mat)))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_square_adj_matrix")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_numeric_vector works", {
  test_vec <- c(1, 1, 1, 1)
  expect_true(check_numeric_vector(test_vec, var_name = "test_vec"))

  test_vec <- c("1", "2")
  expect_true(check_numeric_vector(test_vec, var_name = "test_vec"))

  test_vec <- c("one", "two")
  expect_error(suppressMessages(check_numeric_vector(test_vec, var_name = "test_vec")))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_simulation_inputs")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_choice_selection works", {

  opts <- c("sigmoid", "tanh")
  expect_true(check_choice_selection("sigmoid", opts, "test"))

  random_chars <- paste0(sample(c(letters, LETTERS), size = 10), collapse = "")
  expect_error(check_choice_selection(random_chars, c("sigmoig", "tanh")))

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_choice_selection")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)

  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_simulation_inputs")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_positive_number works", {
  expect_true(check_positive_number(1, "lambda"))
  expect_true(check_positive_integer("1", "lambda"))
  expect_error(suppressMessages(check_positive_number(-1, "lambda")))
  expect_true(check_positive_number(1.1, "lambda")) # Check error
  expect_error(suppressMessages(check_positive_number("one", "lambda")))
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_positive_number")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})


test_that("check_positive_integer works", {
  expect_true(check_positive_integer(1, "max_iter"))
  expect_true(check_positive_integer("1", "max_iter"))
  expect_error(suppressMessages(check_positive_integer(-1, "max_iter")))
  expect_error(suppressMessages(check_positive_integer(1.1, "max_iter")))
  expect_error(suppressMessages(check_positive_integer("one", "max_iter")))
  # yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_positive_integer")
  # res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)
})

functions_to_check <- c("check_square_adj_matrix",
                         "check_numeric_vector",
                         "check_choice_selection",
                         "check_positive_number",
                         "check_positive_integer")
 yaml_list <- autotest::examples_to_yaml(package = ".", functions = functions_to_check)
 res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)


yaml_list <- autotest::examples_to_yaml(package = ".", functions = "check_simulation_inputs")
res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE)


test_data <- autotest::autotest_types()
test_data <- test_data[test_data$test_name == "vector_custom_class", ]
res <- autotest::autotest_yaml(yaml = yaml_list, test = TRUE, test_data = test_data)

