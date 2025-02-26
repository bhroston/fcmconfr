
check_simulation_inputs(adj_matrix = sample_fcms$simple_fcms$conventional_fcms[[1]],
                        initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                        clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                        activation = "kosko",
                        squashing = "tanh",
                        point_of_inference = "final")
