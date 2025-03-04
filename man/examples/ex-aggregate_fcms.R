# Aggregate Conventional FCMs
aggregate_fcms(sample_fcms$simple_fcms$conventional_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)

# Aggregate IVFN FCMs
aggregate_fcms(sample_fcms$simple_fcms$ivfn_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)

# Aggregate TFN FCMs
aggregate_fcms(sample_fcms$simple_fcms$tfn_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)

# NOTE: If the lower bound of an edge weight is 0, but the upper bound is > 0,
# the assumption that a stakeholder simply did not include the edge is invalid.
# Thus, since the 0-lower bound is meaningful, it is included in mean/median
# calculations even if include_zeroes = FALSE
aggregate_fcms(sample_fcms$simple_fcms$ivfn_fcms, "mean", include_zeroes_in_sampling = FALSE)
