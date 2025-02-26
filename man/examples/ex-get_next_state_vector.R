
get_next_state_vector(sample_fcms$simple_fcms$conventional_fcms[[1]],
                      state_vector = c(1, 1, 1, 1, 1, 1, 1),
                      activation = "modified-kosko",
                      fcm_class = "conventional")

get_next_state_vector(sample_fcms$simple_fcms$ivfn_fcms[[1]],
                      state_vector = c(1, 1, 1, 1, 1, 1, 1),
                      activation = "modified-kosko",
                      fcm_class = "ivfn")

get_next_state_vector(sample_fcms$simple_fcms$tfn_fcms[[1]],
                      state_vector = c(1, 1, 1, 1, 1, 1, 1),
                      activation = "modified-kosko",
                      fcm_class = "tfn")
