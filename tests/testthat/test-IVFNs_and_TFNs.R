

test_that("defuzz_ivfn_or_tfn works", {
  expect_equal(defuzz_ivfn_or_tfn(1), 1)
  expect_equal(defuzz_ivfn_or_tfn(ivfn(0.2, 0.6)), 0.4)
  expect_equal(defuzz_ivfn_or_tfn(tfn(0.1, 0.3, 0.8)), 0.4)


  test_val <- structure(.Data = 1, class = "not_correct")
  expect_error(defuzz_ivfn_or_tfn(test_val))

})


# IVFN Tests ----
test_that("make_adj_matrix_w_ivfns works", {
  expect_no_error(make_adj_matrix_w_ivfns(
    lower = matrix(data = c(0, 0.2, 0, 0.5), nrow = 2, ncol = 2),
    upper = matrix(data = c(0, 0.4, 0, 0.7), nrow = 2, ncol = 2)
  ))

  test_lower_adj_matrix <- data.frame(
    "C1" = c(0, 0, 0.51, -0.9, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.7, -0.52, 0, 0, 0),
    "C3" = c(0.13, 0, 0, 0, 0, 0.3, 0, 0),
    "C4" = c(0.28, 0.6, 0, 0, 0, 0, 0.2, 0),
    "C5" = c(0, 0.5, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.35),
    "C7" = c(0, 0, 0, -0.16, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.43, 0, 0)
  )
  test_upper_adj_matrix <- data.frame(
    "C1" = c(0, 0, 1.00, -0.7, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.9, -0.32, 0, 0, 0),
    "C3" = c(0.43, 0, 0, 0, 0, 0.5, 0, 0),
    "C4" = c(0.48, 0.8, 0, 0, 0, 0, 0.4, 0),
    "C5" = c(0, 0.7, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.85),
    "C7" = c(0, 0, 0, 0.34, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.63, 0, 0)
  )
  test_ivfn_adj_matrix <- make_adj_matrix_w_ivfns(test_lower_adj_matrix, test_upper_adj_matrix)

  testthat::expect_equal(methods::is(test_ivfn_adj_matrix), "adj_matrix_w_ivfns")
  testthat::expect_equal(nrow(test_ivfn_adj_matrix), 8)
  testthat::expect_equal(ncol(test_ivfn_adj_matrix), 8)
  testthat::expect_equal(test_ivfn_adj_matrix[[3]][[6]], ivfn(0.3, 0.5))

  colnames(test_lower_adj_matrix) <- NULL
  colnames(test_upper_adj_matrix) <- NULL
  make_adj_matrix_w_ivfns(test_lower_adj_matrix, test_upper_adj_matrix)


  # Catches unequal sized lower and upper matrices
  test_upper_adj_matrix <- data.frame(
    "C1" = c(0, 0, 1.00, -0.7, 0, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.9, -0.32, 0, 0, 0, 0),
    "C3" = c(0.43, 0, 0, 0, 0, 0.5, 0, 0, 0),
    "C4" = c(0.48, 0.8, 0, 0, 0, 0, 0.4, 0, 0),
    "C5" = c(0, 0.7, 0, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.85, 0),
    "C7" = c(0, 0, 0, 0.34, 0, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.63, 0, 0, 0),
    "C9" = c(0, 0, 0, 0, 0, 0, 1, 0, 0)
  )
  expect_error(make_adj_matrix_w_ivfns(test_lower_adj_matrix, test_upper_adj_matrix))

  # Catches non-square matrices
  test_lower_adj_matrix <- data.frame(
    "C1" = c(0, 0, 0.51, -0.9, 0, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.7, -0.52, 0, 0, 0, 0),
    "C3" = c(0.13, 0, 0, 0, 0, 0.3, 0, 0, 0),
    "C4" = c(0.28, 0.6, 0, 0, 0, 0, 0.2, 0, 0),
    "C5" = c(0, 0.5, 0, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.35, 0),
    "C7" = c(0, 0, 0, -0.16, 0, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.43, 0, 0, 0)
  )
  test_upper_adj_matrix <- data.frame(
    "C1" = c(0, 0, 1.00, -0.7, 0, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.9, -0.32, 0, 0, 0, 0),
    "C3" = c(0.43, 0, 0, 0, 0, 0.5, 0, 0, 0),
    "C4" = c(0.48, 0.8, 0, 0, 0, 0, 0.4, 0, 0),
    "C5" = c(0, 0.7, 0, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.85, 0),
    "C7" = c(0, 0, 0, 0.34, 0, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.63, 0, 0, 0)
  )
  expect_error(make_adj_matrix_w_ivfns(test_lower_adj_matrix, test_upper_adj_matrix))


  # Confirm error if any IVFN edges are invalid
  test_lower_adj_matrix <- data.frame(
    "C1" = c(0, 0, 0.51, 1, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.7, -0.52, 0, 0, 0),
    "C3" = c(0.13, 0, 0, 0, 0, 0.3, 0, 0),
    "C4" = c(0.28, 0.6, 0, 0, 0, 0, 0.2, 0),
    "C5" = c(0, 0.5, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.35),
    "C7" = c(0, 0, 0, -0.16, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.43, 0, 0)
  )
  test_upper_adj_matrix <- data.frame(
    "C1" = c(0, 0, 1.00, -0.7, 0, 0, 0, 0),
    "C2" = c(0, 0, 0, 0.9, -0.32, 0, 0, 0),
    "C3" = c(0.43, 0, 0, 0, 0, 0.5, 0, 0),
    "C4" = c(0.48, 0.8, 0, 0, 0, 0, 0.4, 0),
    "C5" = c(0, 0.7, 0, 0, 0, 0, 0, 0),
    "C6" = c(0, 0, 0, 0, 0, 0, 0, 0.85),
    "C7" = c(0, 0, 0, 0.34, 0, 0, 0, 0),
    "C8" = c(0, 0, 0, 0, 0, 0.63, 0, 0)
  )
  expect_error(make_adj_matrix_w_ivfns(test_lower_adj_matrix, test_upper_adj_matrix))


  # Works with objects imported from xlsx
  # filepath <- system.file(
  #   file.path("vignettes", "vignette_example_data", "ivfn_fcms", "sample_ivfn_fcm.xlsx"),
  #   package = "fcmconfr"
  # ) # Your directory path above
  # sheets <- readxl::excel_sheets(filepath)
  # lower_and_upper_adj_matrices <- lapply(
  #   sheets,
  #   function(sheet) readxl::read_excel(filepath, sheet = sheet)
  # )
  # lower_adj_matrix <- lower_and_upper_adj_matrices[[1]]
  # upper_adj_matrix <- lower_and_upper_adj_matrices[[2]]
  # expect_no_error(
  #   ivfn_adj_matrix <- make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
  # )
})


test_that("ivfn works", {
  test_ivfn <- ivfn(-1, 1)
  expect_equal(test_ivfn$lower, -1)
  expect_equal(test_ivfn$upper, 1)
  expect_error(ivfn(1, -1))
  expect_error(ivfn(-Inf, Inf))
  expect_error(ivfn("a", "b"))
})


test_that("subtract_ivfn works", {
  expect_equal(subtract_ivfn(ivfn(0.5, 0.8), ivfn(0.2, 0.5)), ivfn(0, 0.6))
  expect_equal(subtract_ivfn(ivfn(-0.5, 0.3), ivfn(0.4, 0.6)), ivfn(-1.1, -0.1))
  expect_equal(subtract_ivfn(ivfn(-1, 1), ivfn(-0.5, 0.5)), ivfn(-1.5, 1.5))

  expect_error(subtract_ivfn(2, ivfn(0, 1)))
})


test_that("print.ivfn works", {
  invisible(capture.output(
    expect_no_error(print(ivfn(-1, 1)))
  ))
})


test_that("c.ivfn works", {
  test_set <- c(ivfn(-1, 1), ivfn(-0.8, 0.8))
  expect_equal(length(test_set), 2)
  expect_equal(test_set[[2]], ivfn(-0.8, 0.8))
})


# ----
# TFN Tests ----
test_that("make_adj_matrix_w_tfns works", {
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.85, 0, 0, 0.35, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.7, 0.6, -1, 0, -1, 0),
    C5 = c(0.1, 0, 0, -0.8, 0, 0),
    C6 = c(0, -0.95, 0, 0, -0.95, 0)
  )
  mode_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.65, 0, 0, 0.80, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.6, 0.65, -0.85, 0, -0.95, 0),
    C5 = c(0.6, 0, 0, -0.2, 0, 0),
    C6 = c(0, -0.85, 0.1, 0, -0.75, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0, 0, 0, 0),
    C2 = c(-0.1, 0, 0, 1, 0, 0),
    C3 = c(0, 0, 0, 0, 0, 0),
    C4 = c(-0.4, 0.7, -0.7, 0, -0.1, 0),
    C5 = c(0.7, 0, 0, -0.1, 0, 0),
    C6 = c(0, -0.2, 0.25, 0, -0.7, 0)
  )
  test_tfn_adj_matrix <- make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix)

  testthat::expect_equal(methods::is(test_tfn_adj_matrix), "adj_matrix_w_tfns")
  testthat::expect_equal(nrow(test_tfn_adj_matrix), 6)
  testthat::expect_equal(ncol(test_tfn_adj_matrix), 6)
  testthat::expect_equal(test_tfn_adj_matrix[[2]][[4]], tfn(0.35, 0.8, 1))

  colnames(lower_adj_matrix) <- NULL
  colnames(mode_adj_matrix) <- NULL
  colnames(upper_adj_matrix) <- NULL
  expect_no_error(make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix))



  # Check catches different sized matrices
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0),
    C2 = c(-0.85, 0)
  )
  mode_adj_matrix <- data.frame(
    C1 = c(0, 0),
    C2 = c(-0.65, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0),
    C2 = c(-0.1, 0, 0),
    C3 = c(0, 0, 0)
  )
  expect_error(make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix))

  # Check catches non-square matrices
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0, 0),
    C2 = c(-0.85, 0, 0)
  )
  mode_adj_matrix <- data.frame(
    C1 = c(0, 0, 0),
    C2 = c(-0.65, 0, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0, 0),
    C2 = c(-0.1, 0, 0)
  )
  expect_error(make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix))

  # Check catches invalid TFNs and identifies locs
  lower_adj_matrix <- data.frame(
    C1 = c(0, 0),
    C2 = c(-0.85, 0)
  )
  mode_adj_matrix <- data.frame(
    C1 = c(0, 0),
    C2 = c(1, 0)
  )
  upper_adj_matrix <- data.frame(
    C1 = c(0, 0),
    C2 = c(-0.1, 0)
  )
  expect_error(make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix))



})


test_that("tfn works", {
  test_tfn <- tfn(-1, 0, 1)
  expect_equal(test_tfn$lower, -1)
  expect_equal(test_tfn$mode, 0)
  expect_equal(test_tfn$upper, 1)
  expect_error(tfn(1, 0, -1))
  expect_error(tfn(-1, 1, 0.5))
  expect_error(tfn(-Inf, 0, Inf))
  expect_error(tfn("a", 0, 1))
})


test_that("subtract_tfn works", {
  expect_equal(subtract_tfn(tfn(0.5, 0.6, 0.8), tfn(0.2, 0.3, 0.5)), tfn(0, 0.3, 0.6))
  expect_equal(subtract_tfn(tfn(-0.5, -0.2, 0.3), tfn(0.4, 0.5, 0.6)), tfn(-1.1, -0.7, -0.1))
  expect_equal(subtract_tfn(tfn(-1, 0, 1), tfn(-0.5, 0, 0.5)), tfn(-1.5, 0, 1.5))

  expect_error(subtract_tfn(0, tfn(0, 0.5, 1)))
})


test_that("print.ivfn works", {
  invisible(capture.output(
    expect_no_error(print(tfn(-1, 0, 1)))
  ))
})


test_that("c.tfn works", {
  test_set <- c(tfn(-1, 0, 1), tfn(-0.8, 0, 0.8))
  expect_equal(length(test_set), 2)
  expect_equal(test_set[[2]], tfn(-0.8, 0, 0.8))
})


test_that("rtriangular_dist works", {
  test_lower <- 0.25
  test_mode <- 0.5
  test_upper <- 0.75

  test_rtriangular_dist <- rtriangular_dist(test_lower, test_mode, test_upper, n = 1000)
  test_mean <- mean(test_rtriangular_dist)
  test_variance <- var(test_rtriangular_dist)

  expected_mean <- (test_lower + test_mode + test_upper)/3
  expected_variance <- (test_lower^2 + test_mode^2 + test_upper^2 - test_lower*test_mode - test_lower*test_upper - test_mode*test_upper)/18

  perc_error_of_means <- abs(expected_mean - test_mean)/expected_mean
  perc_error_of_vars <- abs(expected_variance - test_variance)/expected_variance

  expect_lt(perc_error_of_means, 0.001)
  expect_lt(perc_error_of_vars, 0.01)

  test_lower <- -0.5
  test_mode <- 0
  test_upper <- 0.5

  test_rtriangular_dist <- rtriangular_dist(test_lower, test_mode, test_upper, n = 1000)
  test_mean <- mean(test_rtriangular_dist)
  test_variance <- var(test_rtriangular_dist)

  expected_mean <- (test_lower + test_mode + test_upper)/3 + 1e-10
  expected_variance <- (test_lower^2 + test_mode^2 + test_upper^2 - test_lower*test_mode - test_lower*test_upper - test_mode*test_upper)/18

  error_of_means <- abs(expected_mean - test_mean)
  perc_error_of_vars <- abs(expected_variance - test_variance)/expected_variance

  expect_lt(error_of_means, 0.001)
  expect_lt(perc_error_of_vars, 0.01)

  expect_error(rtriangular_dist(100, 1, 0, 1))
  expect_error(rtriangular_dist(100, lower = 0, upper = 1))

  expect_error(rtriangular_dist(n = "a", 0, 0.5, 1))
  expect_error(rtriangular_dist(n = 50.5, 0, 0.5, 1))

  expect_no_error(rtriangular_dist(100, 1, 1, 1))
})


test_that("plot.rtriangular_dist works", {
  expect_no_error(plot(rtriangular_dist(1000, -0.5, 0.1, 0.5)))
})
