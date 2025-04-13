
test_that("aggregate_fcms works", {

  # Check w/ conventional fcms ----
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  test_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.625)

  test_adj_matrix_3[1, 2] <- 0
  test_adj_matrix_2[1, 2] <- 0
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms, "mean", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.75)

  test_adj_matrix_2[1, 2] <- 0.6
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.6)

  test_aggregate <- aggregate_fcms(test_fcms, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.55)

  # ----
  # Check w/ ivfn fcms ----
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_4, upper_adj_matrix_4)

  test_fcms_w_ivfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms_w_ivfns, "mean", include_zeroes_in_sampling = FALSE)
  # adj_matrix[[4]], loc[1, 2] = ivfn(0, 0.4) which is a false-zero edge
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.65))

  test_aggregate <- aggregate_fcms(test_fcms_w_ivfns, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.65))

  test_aggregate <- aggregate_fcms(test_fcms_w_ivfns, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.6))

  test_aggregate <- aggregate_fcms(test_fcms_w_ivfns, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.6))

  # ----
  # Check w/ tfn fcms ----
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  mode_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.7, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_tfns(lower_adj_matrix_2, mode_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  mode_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_tfns(lower_adj_matrix_3, mode_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  mode_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_tfns(lower_adj_matrix_4, mode_adj_matrix_4, upper_adj_matrix_4)

  test_fcms_w_tfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms_w_tfns, "mean", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.375, 0.65))

  test_aggregate <- aggregate_fcms(test_fcms_w_tfns, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.375, 0.65))

  test_aggregate <- aggregate_fcms(test_fcms_w_tfns, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.4, 0.6))

  test_aggregate <- aggregate_fcms(test_fcms_w_tfns, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.4, 0.6))

  # ----
  # Check w/ Large fcms  ----
  test_ivfn_fcms <- sample_fcms$large_fcms$ivfn_fcms
  expect_no_error(
    ivfn_agg <- aggregate_fcms(test_ivfn_fcms, agg_function = "mean", include_zeroes_in_sampling = FALSE)
  )

  test_tfn_fcms <- sample_fcms$large_fcms$tfn_fcms
  expect_no_error(
    tfn_agg <- aggregate_fcms(test_tfn_fcms, agg_function = "mean", include_zeroes_in_sampling = FALSE)
  )

  # ----



  })


test_that("aggregate_fcms catches boundary cases", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  expect_no_error(test_aggregate <- aggregate_fcms(test_adj_matrix_1, "mean", include_zeroes_in_sampling = TRUE))


  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0, 0),
    "B" = c(1, 0, 1),
    "C" = c(0, 1, 0)
  )
  test_adj_matrices <- list(test_adj_matrix_1, test_adj_matrix_2)
  expect_error(aggregate_fcms(test_adj_matrices, "mean", include_zeroes_in_sampling = TRUE))


  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "C" = c(0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "B" = c(0, 0),
    "D" = c(0.75, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3)
  expect_error(aggregate_fcms(test_fcms, "mean", include_zeroes_in_sampling = TRUE))
})


test_that("aggregate_conventional_fcms works", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  test_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_conventional_fcms(test_fcms, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.625)

  test_adj_matrix_3[1, 2] <- 0
  test_adj_matrix_2[1, 2] <- 0
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_conventional_fcms(test_fcms, "mean", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.75)

  test_adj_matrix_2[1, 2] <- 0.6
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_conventional_fcms(test_fcms, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.6)

  test_aggregate <- aggregate_conventional_fcms(test_fcms, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2], 0.55)
})


test_that("aggregate_fcms_w_ivfns works", {
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_4, upper_adj_matrix_4)

  test_fcms_w_ivfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  test_aggregate <- aggregate_fcms_w_ivfns(test_fcms_w_ivfns, "mean", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.65))

  test_aggregate <- aggregate_fcms_w_ivfns(test_fcms_w_ivfns, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.65))

  test_aggregate <- aggregate_fcms_w_ivfns(test_fcms_w_ivfns, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.6))

  test_aggregate <- aggregate_fcms_w_ivfns(test_fcms_w_ivfns, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], ivfn(0.3, 0.6))
})


test_that("fcm_w_tfn_aggregation works", {
  lower_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  mode_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_1 <- make_adj_matrix_w_tfns(lower_adj_matrix_1, mode_adj_matrix_1, upper_adj_matrix_1)
  lower_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  mode_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.7, 0)
  )
  upper_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  adj_matrix_2 <- make_adj_matrix_w_tfns(lower_adj_matrix_2, mode_adj_matrix_2, upper_adj_matrix_2)
  lower_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.2, 0)
  )
  mode_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  upper_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.6, 0)
  )
  adj_matrix_3 <- make_adj_matrix_w_tfns(lower_adj_matrix_3, mode_adj_matrix_3, upper_adj_matrix_3)
  lower_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.0, 0)
  )
  mode_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0, 0)
  )
  upper_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.4, 0)
  )
  adj_matrix_4 <- make_adj_matrix_w_tfns(lower_adj_matrix_4, mode_adj_matrix_4, upper_adj_matrix_4)

  test_fcms_w_tfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
  test_aggregate <- aggregate_fcms_w_tfns(test_fcms_w_tfns, "mean", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.375, 0.65))

  test_aggregate <- aggregate_fcms_w_tfns(test_fcms_w_tfns, "mean", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.375, 0.65))

  test_aggregate <- aggregate_fcms_w_tfns(test_fcms_w_tfns, "median", include_zeroes_in_sampling = TRUE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.4, 0.6))

  test_aggregate <- aggregate_fcms_w_tfns(test_fcms_w_tfns, "median", include_zeroes_in_sampling = FALSE)
  expect_equal(test_aggregate$adj_matrix[1, 2][[1]], tfn(0.3, 0.4, 0.6))
})


test_that("print.aggregate works", {
  test_adj_matrix_1 <- data.frame(
    "A" = c(0, 0),
    "B" = c(1, 0)
  )
  test_adj_matrix_2 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.25, 0)
  )
  test_adj_matrix_3 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.75, 0)
  )
  test_adj_matrix_4 <- data.frame(
    "A" = c(0, 0),
    "B" = c(0.5, 0)
  )
  test_fcms <- list(test_adj_matrix_1, test_adj_matrix_2, test_adj_matrix_3, test_adj_matrix_4)
  test_aggregate <- aggregate_fcms(test_fcms, "mean", include_zeroes_in_sampling = TRUE)

  output <- capture.output(test_aggregate)
  expect_identical(output[length(output)], "Aggregate (mean) of 4 adj. matrices")

  expect_snapshot(print(test_aggregate))
})
