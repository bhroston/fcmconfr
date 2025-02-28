
# Inference w/ Interval-Valued Fuzzy Numbers (IVFNs)
simulate_ivfn_or_tfn_fcm(adj_matrix = sample_fcms$simple_fcms$ivfn_fcms[[1]],
                         initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                         clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                         activation = "kosko",
                         squashing = "sigmoid",
                         lambda = 1.0,
                         point_of_inference = "final",
                         max_iter = 100,
                         min_error = 1e-5,
                         skip_checks = FALSE)


# Inference w/ Triangular Fuzzy Numbers (TFNs)
simulate_ivfn_or_tfn_fcm(adj_matrix = sample_fcms$simple_fcms$tfn_fcms[[1]],
                         initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                         clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                         activation = "kosko",
                         squashing = "sigmoid",
                         lambda = 1,
                         point_of_inference = "final",
                         max_iter = 100,
                         min_error = 1e-5,
                         skip_checks = FALSE)
