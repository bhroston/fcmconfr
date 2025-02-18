ex_adj_matrix_1 <- data.frame(
  "A" = c(0, 0),
  "B" = c(1, 0)
)
ex_adj_matrix_2 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.25, 0)
)
ex_adj_matrix_3 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.75, 0)
)
ex_adj_matrix_4 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.5, 0)
)
ex_fcms <- list(
  ex_adj_matrix_1, ex_adj_matrix_2, ex_adj_matrix_3, ex_adj_matrix_4
)
aggregate_conventional_fcms(ex_fcms, "mean", include_zeroes_in_sampling = TRUE)
aggregate_conventional_fcms(ex_fcms, "mean", include_zeroes_in_sampling = FALSE)
aggregate_conventional_fcms(ex_fcms, "median")
