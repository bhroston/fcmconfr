# Aggregate Conventional FCMs
adj_matrix_1 <- data.frame(
  "A" = c(0, 0.8),
  "B" = c(1, 0)
)
adj_matrix_2 <- data.frame(
  "A" = c(0, 0.4),
  "B" = c(0.25, 0)
)
adj_matrix_3 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.75, 0)
)
adj_matrix_4 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.5, 0)
)
fcms <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)
aggregate_fcms(fcms, "mean", include_zeroes_in_sampling = TRUE)


# Aggregate IVFN FCMs
lower_adj_matrix_1 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
upper_adj_matrix_1 <- data.frame(
  "A" = c(0, 0.2),
  "B" = c(0.6, 0)
)
adj_matrix_1 <- make_adj_matrix_w_ivfns(lower_adj_matrix_1, upper_adj_matrix_1)
lower_adj_matrix_2 <- data.frame(
  "A" = c(0, 0.3),
  "B" = c(0.6, 0)
)
upper_adj_matrix_2 <- data.frame(
  "A" = c(0, 0.4),
  "B" = c(1, 0)
)
adj_matrix_2 <- make_adj_matrix_w_ivfns(lower_adj_matrix_2, upper_adj_matrix_2)
lower_adj_matrix_3 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.2, 0)
)
upper_adj_matrix_3 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.6, 0)
)
adj_matrix_3 <- make_adj_matrix_w_ivfns(lower_adj_matrix_3, upper_adj_matrix_3)
lower_adj_matrix_4 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.0, 0)
)
upper_adj_matrix_4 <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
adj_matrix_4 <- make_adj_matrix_w_ivfns(lower_adj_matrix_4, upper_adj_matrix_4)

fcms_w_ivfns <- list(adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4)

# NOTE: If the lower bound of an edge weight is 0, but the upper bound is > 0,
# the assumption that a stakeholder simply did not include the edge is invalid.
# Thus, since the 0-lower bound is meaningful, it is included in mean/median
# calculations even if include_zeroes = FALSE
aggregate_fcms(fcms_w_ivfns, "mean", include_zeroes_in_sampling = FALSE)
