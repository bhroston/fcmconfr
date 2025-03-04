

test_that("estimate_fcm_lambda works", {
  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$conventional_fcms[[1]], "sigmoid"), 2),
    2.23
  )
  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$conventional_fcms[[1]], "tanh"), 2),
    0.89
  )

  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$ivfn_fcms[[1]], "sigmoid"), 2),
    2.47
  )
  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$ivfn_fcms[[1]], "tanh"), 2),
    0.92
  )

  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$tfn_fcms[[1]], "sigmoid"), 2),
    2.38
  )
  expect_equal(
    round(estimate_fcm_lambda(sample_fcms$simple_fcms$tfn_fcms[[1]], "tanh"), 2),
    0.91
  )

  # Confirm works when no nodes are source only
  test_adj_matrix <- data.frame(
    "A" = c(0, 1),
    "B" = c(1, 0)
  )
  expect_no_error(estimate_fcm_lambda(test_adj_matrix, "sigmoid"))
})
