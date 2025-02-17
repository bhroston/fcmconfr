

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
})
