adj_matrix <- data.frame(
  C1 = c(0, 0, 0, 0, 0, 0),
  C2 = c(-0.85, 0, 0, 0.35, 0, 0),
  C3 = c(0, 0, 0, 0, 0, 0),
  C4 = c(-0.7, 0.6, -1, 0, -1, 0),
  C5 = c(0.1, 0, 0, -0.8, 0, 0),
  C6 = c(0, -0.95, 0, 0, -0.95, 0)
)

simulate_conventional_fcm(adj_matrix,
                          initial_state_vector = c(1, 1, 1, 1, 1, 1),
                          clamping_vector = c(1, 0, 0, 0, 0, 0),
                          activation = "kosko",
                          squashing = "sigmoid",
                          lambda = 1,
                          point_of_inference = "final",
                          skip_checks = FALSE)

# To simulate an fcm without clamping (i.e. don't calculate the difference
# from steady-state), change the values in the initial_state_vector while
# leaving all values in the clamping_vector at 0
simulate_conventional_fcm(adj_matrix,
                          initial_state_vector = c(1, 0, 0, 0, 0, 0),
                          clamping_vector = c(0, 0, 0, 0, 0, 0),
                          activation = "kosko",
                          squashing = "sigmoid",
                          lambda = 1,
                          point_of_inference = "final",
                          skip_checks = FALSE)
