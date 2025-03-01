
lower_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
upper_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.6, 0)
)
make_adj_matrix_w_ivfns(lower_adj_matrix, upper_adj_matrix)
