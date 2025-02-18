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
adj_matrix_3 <- make_adj_matrix_w_tfns(
  lower_adj_matrix_3, mode_adj_matrix_3, upper_adj_matrix_3
)
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
adj_matrix_4 <- make_adj_matrix_w_tfns(
  lower_adj_matrix_4, mode_adj_matrix_4, upper_adj_matrix_4
)

fcms_w_tfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)

# Note that Row (1), Column(2) of adj_matrix 3 has false-zero lower and mode
# edge weights. See how the aggregate incorporates those values even though
# include_zeroes = FALSE
aggregate_fcms_w_tfns(fcms_w_tfns, "mean", include_zeroes_in_sampling = FALSE)
aggregate_fcms_w_tfns(fcms_w_tfns, "mean", include_zeroes_in_sampling = TRUE)

