# Inference w/ Interval-Valued Fuzzy Numbers (IVFNs)
ivfn_inference <- infer_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$ivfn_fcms[[4]],
                                        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                        activation = "rescale",
                                        squashing = "sigmoid",
                                        lambda = 1.0,
                                        point_of_inference = "final",
                                        max_iter = 100,
                                        min_error = 1e-5,
                                        skip_checks = FALSE)


# Inference w/ Triangular Fuzzy Numbers (TFNs)
tfn_inference <- infer_ivfn_or_tfn_fcm(sample_fcms$simple_fcms$tfn_fcms[[4]],
                                       initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                       clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                       activation = "rescale",
                                       squashing = "sigmoid",
                                       lambda = 1.0,
                                       point_of_inference = "final",
                                       max_iter = 100,
                                       min_error = 1e-5,
                                       skip_checks = FALSE)
