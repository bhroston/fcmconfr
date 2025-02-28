simulate_conventional_fcm(sample_fcms$simple_fcms$conventional_fcms[[1]],
                          initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                          clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                          activation = "kosko",
                          squashing = "sigmoid",
                          lambda = 1.0,
                          point_of_inference = "final",
                          max_iter = 100,
                          min_error = 1e-5,
                          skip_checks = FALSE)

