


test_that("fcm_view catches errors works", {

  test <- sample_fcms$simple_fcms$conventional_fcms

  expect_error(
    fcm_view(adj_matrix = test)
  )

  expect_error(
    fcm_view(adj_matrix = test[[1]], fcm_visNetwork = "nope")
  )

  expect_error(
    fcm_view(fcm_visNetwork = "wrong")
  )

  expect_error(
    fcm_view(adj_matrix = test[[1]], shiny = "wrong")
  )

  expect_error(
    fcm_view(adj_matrix = unlist(test[[1]][1, ]))
  )

  expect_error(
    fcm_view(adj_matrix = test[[1]][1, ])
  )

  expect_error(
    fcm_view(adj_matrix = test[[1]], shiny = TRUE, wrong_param = TRUE)
  )

  expect_warning(
    fcm_view(adj_matrix = test[[1]], shiny = FALSE, alert_on_open = TRUE)
  )

  expect_error(
    fcm_view(adj_matrix = test[[1]], shiny = TRUE, alert_on_open = "wrong")
  )

  # expect_no_error (Will need to run outside testing)
  # fcm_view(adj_matrix = test[[1]], shiny = TRUE, alert_on_open = TRUE)
  # fcm_view(adj_matrix = test[[1]], shiny = TRUE, alert_on_open = FALSE)

  expect_no_error(
    fcm_view(adj_matrix = list(test[[1]]))
  )

  expect_no_error(
    fcm_view(adj_matrix = test[[1]])
  )

  expect_no_error(
    fcm_view()
  )

  # works with conventional fcms
  # test1 <- fcm_view(test[[1]], shiny = TRUE)
  # test2 <- fcm_view(test1, shiny = TRUE)
  # Able to pass the output from test1 into test2

  # works with ivfn fcms
  # test1 <- fcm_view(sample_fcms$simple_fcms$ivfn_fcms[[1]], shiny = TRUE)
  # test2 <- fcm_view(test1, shiny = TRUE)
  # Able to pass the output from test1 into test2

  # works with tfn fcms
  # test1 <- fcm_view(sample_fcms$simple_fcms$tfn_fcms[[1]], shiny = TRUE)
  # test2 <- fcm_view(test1, shiny = TRUE)
  # Able to pass the output from test1 into test2
})
