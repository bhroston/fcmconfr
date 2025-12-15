# Get inferences from an fcmconfr output

Given an fcmconfr output object, return the inferences of all or just a
specific analysis

## Usage

``` r
get_fcmconfr_inferences(
  fcmconfr_result_obj = list(),
  analysis = c("individual", "aggregate", "mc")
)
```

## Arguments

- fcmconfr_result_obj:

  \[`fcmconfr`\]  
  A direct output from the
  [`fcmconfr`](https://bhroston.github.io/fcmconfr/reference/fcmconfr.md)
  function

- analysis:

  \[[`character()`](https://rdrr.io/r/base/character.html)\]  
  The analysis for which inferences to return (HELP?)

## Value

\[[`list()`](https://rdrr.io/r/base/list.html) or
[`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
A dataframe (or list of dataframes) of inferences from the selected
analysis (analyses)

## See also

Other utility:
[`fcm_view()`](https://bhroston.github.io/fcmconfr/reference/fcm_view.md)

## Examples

``` r
ex_conventional_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$conventional_fcms,
  # adj_matrices = group_conventional_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 100L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 100L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
#> [1] Simulating Input FCMs
#> 
#> [1] Running Simulations
#> [1] Sampling from column vectors
#> Sampling from column vectors[1] Constructing monte carlo fcms from samples
#> Constructing monte carlo fcms from samples
#> [1] Running Simulations
#> [1] Performing bootstrap simulations
#> [1] Done
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual"))
#> $individual_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              1.883739e-07
#> 2      adj_matrix_2                                 1              2.119206e-07
#> 3      adj_matrix_3                                 1              6.862192e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              1.291707e-06
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -8.073167e-08
#> 14    adj_matrix_14                                 1              3.417641e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              2.152845e-07
#> 22    adj_matrix_22                                 1              3.431096e-06
#> 23    adj_matrix_23                                 1              1.614633e-07
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              6.875648e-06
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        1.883739e-07
#> 2                       -1.996777e-06
#> 3                        6.862192e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       1.291707e-06
#> 12                       2.119206e-07
#> 13                      -8.073167e-08
#> 14                       3.417641e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       2.152845e-07
#> 22                       3.431096e-06
#> 23                       1.614633e-07
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       6.875648e-06
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01      0.137976692
#> 2                                 -2.785142e-01      0.149998461
#> 3                                 -1.419821e-01      0.191007238
#> 4                                 -1.823903e-01      0.072280641
#> 5                                 -2.912555e-01      0.139532225
#> 6                                  0.000000e+00      0.000000000
#> 7                                  0.000000e+00      0.000000000
#> 8                                  0.000000e+00      0.000000000
#> 9                                  0.000000e+00      0.067405908
#> 10                                -2.504156e-01      0.139108046
#> 11                                -3.031899e-01      0.006035625
#> 12                                -2.677088e-01      0.179095480
#> 13                                -9.747190e-02      0.014645036
#> 14                                -2.504155e-01      0.333186200
#> 15                                -2.785133e-01      0.076891967
#> 16                                 0.000000e+00      0.071950317
#> 17                                -4.967028e-02      0.007425519
#> 18                                 0.000000e+00      0.000000000
#> 19                                -1.419758e-01      0.081281718
#> 20                                 0.000000e+00      0.000000000
#> 21                                -9.746972e-02      0.012141400
#> 22                                -3.031989e-01      0.089287945
#> 23                                 1.614633e-07      0.179812221
#> 24                                -1.823909e-01      0.132036742
#> 25                                 0.000000e+00      0.000000000
#> 26                                 0.000000e+00      0.000000000
#> 27                                 0.000000e+00      0.000000000
#> 28                                -2.912555e-01      0.235741308
#> 29                                 0.000000e+00      0.000000000
#> 30                                 0.000000e+00      0.000000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                1.883739e-07                   -0.19378115
#> 2                                2.119206e-07                   -0.19939472
#> 3                                6.862192e-06                   -0.28190525
#> 4                                0.000000e+00                   -0.09776002
#> 5                                4.171136e-07                   -0.19620375
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                0.000000e+00                   -0.09747273
#> 10                               2.085568e-07                   -0.16295320
#> 11                               1.291707e-06                   -0.03023763
#> 12                               2.119206e-07                   -0.23025834
#> 13                              -8.073167e-08                   -0.02093391
#> 14                               3.417641e-06                   -0.17292786
#> 15                               1.614633e-07                   -0.15628163
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -6.458534e-07                   -0.03711496
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10344715
#> 20                               0.000000e+00                    0.00000000
#> 21                              -4.857875e-03                   -0.02432385
#> 22                               3.431096e-06                   -0.18248038
#> 23                               1.614633e-07                   -0.21848846
#> 24                               8.073167e-08                   -0.15384686
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               6.875648e-06                   -0.34532517
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual", "aggregate"))
#> $individual_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              1.883739e-07
#> 2      adj_matrix_2                                 1              2.119206e-07
#> 3      adj_matrix_3                                 1              6.862192e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              1.291707e-06
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -8.073167e-08
#> 14    adj_matrix_14                                 1              3.417641e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              2.152845e-07
#> 22    adj_matrix_22                                 1              3.431096e-06
#> 23    adj_matrix_23                                 1              1.614633e-07
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              6.875648e-06
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        1.883739e-07
#> 2                       -1.996777e-06
#> 3                        6.862192e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       1.291707e-06
#> 12                       2.119206e-07
#> 13                      -8.073167e-08
#> 14                       3.417641e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       2.152845e-07
#> 22                       3.431096e-06
#> 23                       1.614633e-07
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       6.875648e-06
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01      0.137976692
#> 2                                 -2.785142e-01      0.149998461
#> 3                                 -1.419821e-01      0.191007238
#> 4                                 -1.823903e-01      0.072280641
#> 5                                 -2.912555e-01      0.139532225
#> 6                                  0.000000e+00      0.000000000
#> 7                                  0.000000e+00      0.000000000
#> 8                                  0.000000e+00      0.000000000
#> 9                                  0.000000e+00      0.067405908
#> 10                                -2.504156e-01      0.139108046
#> 11                                -3.031899e-01      0.006035625
#> 12                                -2.677088e-01      0.179095480
#> 13                                -9.747190e-02      0.014645036
#> 14                                -2.504155e-01      0.333186200
#> 15                                -2.785133e-01      0.076891967
#> 16                                 0.000000e+00      0.071950317
#> 17                                -4.967028e-02      0.007425519
#> 18                                 0.000000e+00      0.000000000
#> 19                                -1.419758e-01      0.081281718
#> 20                                 0.000000e+00      0.000000000
#> 21                                -9.746972e-02      0.012141400
#> 22                                -3.031989e-01      0.089287945
#> 23                                 1.614633e-07      0.179812221
#> 24                                -1.823909e-01      0.132036742
#> 25                                 0.000000e+00      0.000000000
#> 26                                 0.000000e+00      0.000000000
#> 27                                 0.000000e+00      0.000000000
#> 28                                -2.912555e-01      0.235741308
#> 29                                 0.000000e+00      0.000000000
#> 30                                 0.000000e+00      0.000000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                1.883739e-07                   -0.19378115
#> 2                                2.119206e-07                   -0.19939472
#> 3                                6.862192e-06                   -0.28190525
#> 4                                0.000000e+00                   -0.09776002
#> 5                                4.171136e-07                   -0.19620375
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                0.000000e+00                   -0.09747273
#> 10                               2.085568e-07                   -0.16295320
#> 11                               1.291707e-06                   -0.03023763
#> 12                               2.119206e-07                   -0.23025834
#> 13                              -8.073167e-08                   -0.02093391
#> 14                               3.417641e-06                   -0.17292786
#> 15                               1.614633e-07                   -0.15628163
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -6.458534e-07                   -0.03711496
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10344715
#> 20                               0.000000e+00                    0.00000000
#> 21                              -4.857875e-03                   -0.02432385
#> 22                               3.431096e-06                   -0.18248038
#> 23                               1.614633e-07                   -0.21848846
#> 24                               8.073167e-08                   -0.15384686
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               6.875648e-06                   -0.34532517
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $aggregate_inferences
#> # A tibble: 7 × 3
#>   adj_matrix_index node                                             value
#>   <chr>            <chr>                                            <dbl>
#> 1 aggregate        Guidance.Docs.for.Salt.Management             1       
#> 2 aggregate        Public.Education.Programs                     0.00833 
#> 3 aggregate        Salts.Added.during.Water.Treatment           -0.000139
#> 4 aggregate        Salts.Added.by.Winter.Maintenance.Activities -0.136   
#> 5 aggregate        Ecosystem.Health                              0.0848  
#> 6 aggregate        Public.Awareness.of.Reservoir.Salinization   -0.000845
#> 7 aggregate        Salinization.of.the.Reservoir                -0.127   
#> 
get_fcmconfr_inferences(ex_conventional_fcmconfr, analysis = c("individual", "aggregate", "mc"))
#> $individual_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              1.883739e-07
#> 2      adj_matrix_2                                 1              2.119206e-07
#> 3      adj_matrix_3                                 1              6.862192e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              1.291707e-06
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -8.073167e-08
#> 14    adj_matrix_14                                 1              3.417641e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              2.152845e-07
#> 22    adj_matrix_22                                 1              3.431096e-06
#> 23    adj_matrix_23                                 1              1.614633e-07
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              6.875648e-06
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        1.883739e-07
#> 2                       -1.996777e-06
#> 3                        6.862192e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       1.291707e-06
#> 12                       2.119206e-07
#> 13                      -8.073167e-08
#> 14                       3.417641e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       2.152845e-07
#> 22                       3.431096e-06
#> 23                       1.614633e-07
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       6.875648e-06
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01      0.137976692
#> 2                                 -2.785142e-01      0.149998461
#> 3                                 -1.419821e-01      0.191007238
#> 4                                 -1.823903e-01      0.072280641
#> 5                                 -2.912555e-01      0.139532225
#> 6                                  0.000000e+00      0.000000000
#> 7                                  0.000000e+00      0.000000000
#> 8                                  0.000000e+00      0.000000000
#> 9                                  0.000000e+00      0.067405908
#> 10                                -2.504156e-01      0.139108046
#> 11                                -3.031899e-01      0.006035625
#> 12                                -2.677088e-01      0.179095480
#> 13                                -9.747190e-02      0.014645036
#> 14                                -2.504155e-01      0.333186200
#> 15                                -2.785133e-01      0.076891967
#> 16                                 0.000000e+00      0.071950317
#> 17                                -4.967028e-02      0.007425519
#> 18                                 0.000000e+00      0.000000000
#> 19                                -1.419758e-01      0.081281718
#> 20                                 0.000000e+00      0.000000000
#> 21                                -9.746972e-02      0.012141400
#> 22                                -3.031989e-01      0.089287945
#> 23                                 1.614633e-07      0.179812221
#> 24                                -1.823909e-01      0.132036742
#> 25                                 0.000000e+00      0.000000000
#> 26                                 0.000000e+00      0.000000000
#> 27                                 0.000000e+00      0.000000000
#> 28                                -2.912555e-01      0.235741308
#> 29                                 0.000000e+00      0.000000000
#> 30                                 0.000000e+00      0.000000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                1.883739e-07                   -0.19378115
#> 2                                2.119206e-07                   -0.19939472
#> 3                                6.862192e-06                   -0.28190525
#> 4                                0.000000e+00                   -0.09776002
#> 5                                4.171136e-07                   -0.19620375
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                0.000000e+00                   -0.09747273
#> 10                               2.085568e-07                   -0.16295320
#> 11                               1.291707e-06                   -0.03023763
#> 12                               2.119206e-07                   -0.23025834
#> 13                              -8.073167e-08                   -0.02093391
#> 14                               3.417641e-06                   -0.17292786
#> 15                               1.614633e-07                   -0.15628163
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -6.458534e-07                   -0.03711496
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10344715
#> 20                               0.000000e+00                    0.00000000
#> 21                              -4.857875e-03                   -0.02432385
#> 22                               3.431096e-06                   -0.18248038
#> 23                               1.614633e-07                   -0.21848846
#> 24                               8.073167e-08                   -0.15384686
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               6.875648e-06                   -0.34532517
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $aggregate_inferences
#> # A tibble: 7 × 3
#>   adj_matrix_index node                                             value
#>   <chr>            <chr>                                            <dbl>
#> 1 aggregate        Guidance.Docs.for.Salt.Management             1       
#> 2 aggregate        Public.Education.Programs                     0.00833 
#> 3 aggregate        Salts.Added.during.Water.Treatment           -0.000139
#> 4 aggregate        Salts.Added.by.Winter.Maintenance.Activities -0.136   
#> 5 aggregate        Ecosystem.Health                              0.0848  
#> 6 aggregate        Public.Awareness.of.Reservoir.Salinization   -0.000845
#> 7 aggregate        Salinization.of.the.Reservoir                -0.127   
#> 
#> $mc_inferences
#>      adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1     mc_adj_matrix_1                                 1
#> 2     mc_adj_matrix_2                                 1
#> 3     mc_adj_matrix_3                                 1
#> 4     mc_adj_matrix_4                                 1
#> 5     mc_adj_matrix_5                                 1
#> 6     mc_adj_matrix_6                                 1
#> 7     mc_adj_matrix_7                                 1
#> 8     mc_adj_matrix_8                                 1
#> 9     mc_adj_matrix_9                                 1
#> 10   mc_adj_matrix_10                                 1
#> 11   mc_adj_matrix_11                                 1
#> 12   mc_adj_matrix_12                                 1
#> 13   mc_adj_matrix_13                                 1
#> 14   mc_adj_matrix_14                                 1
#> 15   mc_adj_matrix_15                                 1
#> 16   mc_adj_matrix_16                                 1
#> 17   mc_adj_matrix_17                                 1
#> 18   mc_adj_matrix_18                                 1
#> 19   mc_adj_matrix_19                                 1
#> 20   mc_adj_matrix_20                                 1
#> 21   mc_adj_matrix_21                                 1
#> 22   mc_adj_matrix_22                                 1
#> 23   mc_adj_matrix_23                                 1
#> 24   mc_adj_matrix_24                                 1
#> 25   mc_adj_matrix_25                                 1
#> 26   mc_adj_matrix_26                                 1
#> 27   mc_adj_matrix_27                                 1
#> 28   mc_adj_matrix_28                                 1
#> 29   mc_adj_matrix_29                                 1
#> 30   mc_adj_matrix_30                                 1
#> 31   mc_adj_matrix_31                                 1
#> 32   mc_adj_matrix_32                                 1
#> 33   mc_adj_matrix_33                                 1
#> 34   mc_adj_matrix_34                                 1
#> 35   mc_adj_matrix_35                                 1
#> 36   mc_adj_matrix_36                                 1
#> 37   mc_adj_matrix_37                                 1
#> 38   mc_adj_matrix_38                                 1
#> 39   mc_adj_matrix_39                                 1
#> 40   mc_adj_matrix_40                                 1
#> 41   mc_adj_matrix_41                                 1
#> 42   mc_adj_matrix_42                                 1
#> 43   mc_adj_matrix_43                                 1
#> 44   mc_adj_matrix_44                                 1
#> 45   mc_adj_matrix_45                                 1
#> 46   mc_adj_matrix_46                                 1
#> 47   mc_adj_matrix_47                                 1
#> 48   mc_adj_matrix_48                                 1
#> 49   mc_adj_matrix_49                                 1
#> 50   mc_adj_matrix_50                                 1
#> 51   mc_adj_matrix_51                                 1
#> 52   mc_adj_matrix_52                                 1
#> 53   mc_adj_matrix_53                                 1
#> 54   mc_adj_matrix_54                                 1
#> 55   mc_adj_matrix_55                                 1
#> 56   mc_adj_matrix_56                                 1
#> 57   mc_adj_matrix_57                                 1
#> 58   mc_adj_matrix_58                                 1
#> 59   mc_adj_matrix_59                                 1
#> 60   mc_adj_matrix_60                                 1
#> 61   mc_adj_matrix_61                                 1
#> 62   mc_adj_matrix_62                                 1
#> 63   mc_adj_matrix_63                                 1
#> 64   mc_adj_matrix_64                                 1
#> 65   mc_adj_matrix_65                                 1
#> 66   mc_adj_matrix_66                                 1
#> 67   mc_adj_matrix_67                                 1
#> 68   mc_adj_matrix_68                                 1
#> 69   mc_adj_matrix_69                                 1
#> 70   mc_adj_matrix_70                                 1
#> 71   mc_adj_matrix_71                                 1
#> 72   mc_adj_matrix_72                                 1
#> 73   mc_adj_matrix_73                                 1
#> 74   mc_adj_matrix_74                                 1
#> 75   mc_adj_matrix_75                                 1
#> 76   mc_adj_matrix_76                                 1
#> 77   mc_adj_matrix_77                                 1
#> 78   mc_adj_matrix_78                                 1
#> 79   mc_adj_matrix_79                                 1
#> 80   mc_adj_matrix_80                                 1
#> 81   mc_adj_matrix_81                                 1
#> 82   mc_adj_matrix_82                                 1
#> 83   mc_adj_matrix_83                                 1
#> 84   mc_adj_matrix_84                                 1
#> 85   mc_adj_matrix_85                                 1
#> 86   mc_adj_matrix_86                                 1
#> 87   mc_adj_matrix_87                                 1
#> 88   mc_adj_matrix_88                                 1
#> 89   mc_adj_matrix_89                                 1
#> 90   mc_adj_matrix_90                                 1
#> 91   mc_adj_matrix_91                                 1
#> 92   mc_adj_matrix_92                                 1
#> 93   mc_adj_matrix_93                                 1
#> 94   mc_adj_matrix_94                                 1
#> 95   mc_adj_matrix_95                                 1
#> 96   mc_adj_matrix_96                                 1
#> 97   mc_adj_matrix_97                                 1
#> 98   mc_adj_matrix_98                                 1
#> 99   mc_adj_matrix_99                                 1
#> 100 mc_adj_matrix_100                                 1
#>     Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1               -7.534956e-07                      -7.534956e-07
#> 2                3.767478e-07                       3.767478e-07
#> 3                3.390730e-06                       3.390730e-06
#> 4                1.506991e-06                       1.506991e-06
#> 5                0.000000e+00                       0.000000e+00
#> 6                0.000000e+00                       0.000000e+00
#> 7                4.171136e-07                       4.171136e-07
#> 8                4.238413e-07                       4.238413e-07
#> 9                0.000000e+00                       0.000000e+00
#> 10               0.000000e+00                       0.000000e+00
#> 11               3.229267e-06                       3.229267e-06
#> 12               0.000000e+00                       0.000000e+00
#> 13               0.000000e+00                       0.000000e+00
#> 14               4.171136e-07                       4.171136e-07
#> 15               0.000000e+00                       0.000000e+00
#> 16               8.476826e-07                       8.476826e-07
#> 17               8.342273e-07                      -6.998549e-06
#> 18               3.441188e-06                       3.441188e-06
#> 19               5.382112e-08                       5.382112e-08
#> 20               1.345528e-08                       1.345528e-08
#> 21               1.883739e-07                       1.883739e-07
#> 22               4.272051e-07                       4.272051e-07
#> 23               0.000000e+00                       0.000000e+00
#> 24               8.476826e-07                      -7.139424e-06
#> 25               1.883739e-07                       1.883739e-07
#> 26               0.000000e+00                       0.000000e+00
#> 27               1.695365e-06                       1.695365e-06
#> 28               0.000000e+00                       0.000000e+00
#> 29               0.000000e+00                       0.000000e+00
#> 30              -5.382112e-08                      -5.382112e-08
#> 31              -6.458534e-07                      -6.458534e-07
#> 32              -1.614633e-07                      -1.614633e-07
#> 33               0.000000e+00                       0.000000e+00
#> 34               0.000000e+00                       0.000000e+00
#> 35              -5.382112e-08                      -5.382112e-08
#> 36              -1.291707e-06                      -1.291707e-06
#> 37               8.073167e-07                       8.073167e-07
#> 38              -4.305689e-07                      -4.305689e-07
#> 39               0.000000e+00                       0.000000e+00
#> 40               1.715548e-06                       1.715548e-06
#> 41               1.708820e-06                       1.708820e-06
#> 42               8.544102e-07                       8.544102e-07
#> 43               0.000000e+00                       0.000000e+00
#> 44               0.000000e+00                       0.000000e+00
#> 45               2.152845e-07                       2.152845e-07
#> 46               2.152845e-07                       2.152845e-07
#> 47              -1.614633e-07                      -1.614633e-07
#> 48               6.862192e-06                       6.862192e-06
#> 49               2.184841e-01                      -2.152845e-07
#> 50               0.000000e+00                       0.000000e+00
#> 51               0.000000e+00                       0.000000e+00
#> 52               4.036584e-07                       4.036584e-07
#> 53               1.883739e-07                       1.883739e-07
#> 54               8.544102e-07                       8.544102e-07
#> 55               2.184874e-01                       0.000000e+00
#> 56               3.767478e-07                       3.767478e-07
#> 57               2.018292e-07                       2.018292e-07
#> 58               2.184875e-01                       3.336909e-06
#> 59               4.171136e-07                       4.171136e-07
#> 60               8.476826e-07                       8.476826e-07
#> 61               1.883739e-07                       1.883739e-07
#> 62               1.883739e-07                       1.883739e-07
#> 63               0.000000e+00                       0.000000e+00
#> 64               0.000000e+00                       0.000000e+00
#> 65               0.000000e+00                       0.000000e+00
#> 66               3.336909e-06                       3.336909e-06
#> 67               0.000000e+00                       0.000000e+00
#> 68               4.238413e-07                       4.238413e-07
#> 69               0.000000e+00                       0.000000e+00
#> 70               0.000000e+00                       0.000000e+00
#> 71               1.614633e-07                      -1.475221e-06
#> 72               3.767478e-07                       3.767478e-07
#> 73               0.000000e+00                       0.000000e+00
#> 74               8.544102e-07                       8.544102e-07
#> 75               0.000000e+00                       0.000000e+00
#> 76              -6.458534e-07                      -6.458534e-07
#> 77              -5.382112e-08                      -5.382112e-08
#> 78               0.000000e+00                       0.000000e+00
#> 79               7.534956e-07                       7.534956e-07
#> 80               3.437824e-06                       3.437824e-06
#> 81               0.000000e+00                       0.000000e+00
#> 82               3.229267e-07                       3.229267e-07
#> 83               2.152845e-07                       2.152845e-07
#> 84               1.076422e-07                      -9.655405e-07
#> 85               3.767478e-07                       3.767478e-07
#> 86               1.715548e-06                       1.715548e-06
#> 87               2.085568e-07                       2.085568e-07
#> 88               0.000000e+00                       0.000000e+00
#> 89              -3.767478e-07                      -3.767478e-07
#> 90               0.000000e+00                       0.000000e+00
#> 91               1.708820e-06                       1.708820e-06
#> 92               8.476826e-07                       8.476826e-07
#> 93               0.000000e+00                       0.000000e+00
#> 94               5.382112e-08                       5.382112e-08
#> 95               3.417641e-06                       3.417641e-06
#> 96               0.000000e+00                       0.000000e+00
#> 97               0.000000e+00                       0.000000e+00
#> 98               1.695365e-06                       1.695365e-06
#> 99               8.073167e-08                       8.073167e-08
#> 100              1.506991e-06                       1.506991e-06
#>     Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  -1.823854e-01     3.583183e-02
#> 2                                  -1.823916e-01     3.767478e-07
#> 3                                  -2.677077e-01     7.103345e-02
#> 4                                  -2.425477e-06     1.797959e-01
#> 5                                   0.000000e+00     0.000000e+00
#> 6                                  -1.419722e-01     9.265583e-02
#> 7                                  -2.785139e-01     1.588091e-01
#> 8                                  -3.031963e-01     1.521855e-01
#> 9                                   0.000000e+00     0.000000e+00
#> 10                                  0.000000e+00     0.000000e+00
#> 11                                 -2.912530e-01     7.168666e-03
#> 12                                  0.000000e+00     0.000000e+00
#> 13                                  0.000000e+00     7.804836e-02
#> 14                                 -2.912555e-01     1.524788e-01
#> 15                                  0.000000e+00     0.000000e+00
#> 16                                 -3.031961e-01     1.098823e-01
#> 17                                 -2.504156e-01     1.480956e-01
#> 18                                 -3.032004e-01     2.648744e-01
#> 19                                 -5.096808e-07     3.883449e-02
#> 20                                 -9.747256e-02     4.894938e-02
#> 21                                 -1.823910e-01     9.555170e-02
#> 22                                 -2.504157e-01     1.540205e-01
#> 23                                  0.000000e+00     0.000000e+00
#> 24                                 -1.823909e-01     2.417474e-01
#> 25                                 -2.504156e-01     1.021914e-01
#> 26                                  0.000000e+00     9.390562e-02
#> 27                                 -2.912542e-01     1.850628e-02
#> 28                                  0.000000e+00     0.000000e+00
#> 29                                  0.000000e+00     0.000000e+00
#> 30                                 -4.967107e-02     3.549106e-02
#> 31                                 -9.747005e-02     1.934383e-02
#> 32                                 -4.967097e-02     2.463721e-02
#> 33                                  0.000000e+00     0.000000e+00
#> 34                                  0.000000e+00     1.256037e-01
#> 35                                 -9.747122e-02     4.429092e-02
#> 36                                 -9.746787e-02    -1.291707e-06
#> 37                                 -1.419779e-01     3.366669e-02
#> 38                                 -9.746991e-02     8.589623e-03
#> 39                                  0.000000e+00     0.000000e+00
#> 40                                 -3.031958e-01     1.781086e-01
#> 41                                 -2.912555e-01     1.973477e-01
#> 42                                 -9.747759e-02     5.106911e-02
#> 43                                  0.000000e+00     0.000000e+00
#> 44                                  0.000000e+00     0.000000e+00
#> 45                                 -9.747257e-02     1.947810e-03
#> 46                                  2.152845e-07     1.370156e-01
#> 47                                 -9.747186e-02     6.079128e-02
#> 48                                 -3.032015e-01     1.751653e-01
#> 49                                 -1.419743e-01     3.648935e-02
#> 50                                  0.000000e+00     0.000000e+00
#> 51                                  0.000000e+00     0.000000e+00
#> 52                                 -2.785138e-01     5.118915e-02
#> 53                                 -1.823903e-01     5.183704e-02
#> 54                                 -2.785149e-01     1.430670e-01
#> 55                                  0.000000e+00     0.000000e+00
#> 56                                  3.767478e-07     2.785119e-01
#> 57                                 -2.504158e-01     1.467342e-01
#> 58                                 -1.823897e-01     3.336909e-06
#> 59                                 -2.504164e-01     6.831333e-02
#> 60                                 -3.031961e-01     1.431412e-01
#> 61                                 -2.677081e-01     8.952663e-02
#> 62                                 -2.504156e-01     1.243539e-01
#> 63                                  0.000000e+00     0.000000e+00
#> 64                                  0.000000e+00     0.000000e+00
#> 65                                  0.000000e+00     1.050123e-01
#> 66                                 -5.003946e-06     1.538490e-01
#> 67                                  0.000000e+00     0.000000e+00
#> 68                                 -2.785138e-01     1.267207e-01
#> 69                                  0.000000e+00     0.000000e+00
#> 70                                  0.000000e+00     0.000000e+00
#> 71                                 -1.475221e-06     2.785120e-01
#> 72                                 -9.747304e-02     4.728087e-02
#> 73                                  0.000000e+00     0.000000e+00
#> 74                                 -3.031965e-01     1.521870e-01
#> 75                                  0.000000e+00     0.000000e+00
#> 76                                 -9.747005e-02     9.373202e-02
#> 77                                 -4.967107e-02     2.449706e-02
#> 78                                  0.000000e+00     0.000000e+00
#> 79                                 -1.202018e-01     3.112357e-02
#> 80                                 -2.912576e-01     1.395462e-01
#> 81                                  0.000000e+00     0.000000e+00
#> 82                                 -1.823902e-01     3.361201e-02
#> 83                                 -1.823895e-01     2.316391e-02
#> 84                                 -1.823902e-01     5.184491e-02
#> 85                                 -1.823908e-01     1.305066e-02
#> 86                                 -3.031962e-01     2.141839e-01
#> 87                                 -2.785138e-01     1.267225e-01
#> 88                                  0.000000e+00     0.000000e+00
#> 89                                 -9.747126e-02     7.495468e-02
#> 90                                  0.000000e+00     0.000000e+00
#> 91                                 -2.785139e-01     1.144522e-01
#> 92                                 -3.031961e-01     9.831713e-02
#> 93                                  0.000000e+00     0.000000e+00
#> 94                                 -1.202010e-01     1.583222e-02
#> 95                                 -9.747835e-02     1.778773e-01
#> 96                                  0.000000e+00     0.000000e+00
#> 97                                  0.000000e+00     9.743164e-03
#> 98                                 -2.785153e-01     3.970502e-02
#> 99                                 -9.747287e-02     3.360292e-02
#> 100                                -9.747421e-02     7.199305e-03
#>     Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                -7.534956e-07                 -7.193752e-02
#> 2                                 3.767478e-07                 -1.225782e-01
#> 3                                 3.390730e-06                 -3.601117e-01
#> 4                                 1.506991e-06                 -2.184893e-01
#> 5                                 0.000000e+00                  0.000000e+00
#> 6                                 0.000000e+00                 -2.371042e-01
#> 7                                 4.171136e-07                 -1.891189e-01
#> 8                                 4.238413e-07                 -2.027005e-01
#> 9                                 0.000000e+00                  0.000000e+00
#> 10                                0.000000e+00                  0.000000e+00
#> 11                                3.229267e-06                 -7.180147e-02
#> 12                                0.000000e+00                  0.000000e+00
#> 13                                0.000000e+00                 -1.202016e-01
#> 14                                4.171136e-07                 -1.625190e-01
#> 15                                0.000000e+00                  0.000000e+00
#> 16                                8.476826e-07                 -2.523196e-01
#> 17                                8.342273e-07                 -3.145119e-01
#> 18                                3.441188e-06                 -3.249258e-01
#> 19                                5.382112e-08                 -9.747398e-02
#> 20                                1.345528e-08                 -5.795988e-02
#> 21                                1.883739e-07                 -1.305957e-01
#> 22                                4.272051e-07                 -1.826435e-01
#> 23                                0.000000e+00                  0.000000e+00
#> 24                                8.476826e-07                 -3.175589e-01
#> 25                                1.883739e-07                 -1.314106e-01
#> 26                                0.000000e+00                 -1.202013e-01
#> 27                                1.695365e-06                 -1.853357e-01
#> 28                                0.000000e+00                  0.000000e+00
#> 29                                0.000000e+00                  0.000000e+00
#> 30                               -5.382112e-08                 -3.957012e-02
#> 31                               -6.458534e-07                 -4.842383e-02
#> 32                               -1.614633e-07                 -4.934797e-02
#> 33                                0.000000e+00                  0.000000e+00
#> 34                                0.000000e+00                 -2.184892e-01
#> 35                               -5.382112e-08                 -6.363144e-02
#> 36                               -1.291707e-06                 -7.207256e-02
#> 37                                8.073167e-07                 -1.351009e-01
#> 38                               -4.305689e-07                 -8.598165e-02
#> 39                                0.000000e+00                  0.000000e+00
#> 40                                1.715548e-06                 -2.946346e-01
#> 41                                1.708820e-06                 -2.750302e-01
#> 42                                8.544102e-07                 -6.857846e-02
#> 43                                0.000000e+00                  0.000000e+00
#> 44                                0.000000e+00                  0.000000e+00
#> 45                                2.152845e-07                 -1.947552e-02
#> 46                                2.152845e-07                 -2.184884e-01
#> 47                               -1.614633e-07                 -7.675143e-02
#> 48                                6.862192e-06                 -2.383302e-01
#> 49                               -2.152845e-07                 -9.160010e-02
#> 50                                0.000000e+00                  0.000000e+00
#> 51                                0.000000e+00                  0.000000e+00
#> 52                                4.036584e-07                 -6.875044e-02
#> 53                                1.883739e-07                 -1.160629e-01
#> 54                                8.544102e-07                 -1.891212e-01
#> 55                                0.000000e+00                  0.000000e+00
#> 56                                3.767478e-07                  5.704189e-06
#> 57                                2.018292e-07                 -1.729344e-01
#> 58                                3.336909e-06                 -2.550566e-01
#> 59                                4.171136e-07                 -1.729368e-01
#> 60                                8.476826e-07                 -2.523196e-01
#> 61                                1.883739e-07                 -1.829849e-01
#> 62                                1.883739e-07                 -1.729336e-01
#> 63                                0.000000e+00                  0.000000e+00
#> 64                                0.000000e+00                  0.000000e+00
#> 65                                0.000000e+00                 -1.202015e-01
#> 66                                3.336909e-06                 -1.824018e-01
#> 67                                0.000000e+00                  0.000000e+00
#> 68                                4.238413e-07                 -1.891188e-01
#> 69                                0.000000e+00                  0.000000e+00
#> 70                                0.000000e+00                  0.000000e+00
#> 71                                1.614633e-07                 -7.329113e-06
#> 72                                3.767478e-07                 -7.209254e-02
#> 73                                0.000000e+00                  0.000000e+00
#> 74                                8.544102e-07                 -2.027015e-01
#> 75                                0.000000e+00                  0.000000e+00
#> 76                               -6.458534e-07                 -1.919739e-01
#> 77                               -5.382112e-08                 -2.726434e-02
#> 78                                0.000000e+00                  0.000000e+00
#> 79                                7.534956e-07                 -7.804617e-02
#> 80                                3.437824e-06                 -1.962132e-01
#> 81                                0.000000e+00                  0.000000e+00
#> 82                                3.229267e-07                 -1.686398e-01
#> 83                                2.152845e-07                 -1.160574e-01
#> 84                                1.076422e-07                 -1.305913e-01
#> 85                                3.767478e-07                 -1.305934e-01
#> 86                                1.715548e-06                 -3.046656e-01
#> 87                                2.085568e-07                 -1.891187e-01
#> 88                                0.000000e+00                  0.000000e+00
#> 89                               -3.767478e-07                 -9.511926e-02
#> 90                                0.000000e+00                  0.000000e+00
#> 91                                1.708820e-06                 -2.371884e-01
#> 92                                8.476826e-07                 -2.523196e-01
#> 93                                0.000000e+00                  0.000000e+00
#> 94                                5.382112e-08                 -2.400336e-02
#> 95                                3.417641e-06                 -2.588521e-01
#> 96                                0.000000e+00                  0.000000e+00
#> 97                                0.000000e+00                 -9.747207e-02
#> 98                                1.695365e-06                 -1.993928e-01
#> 99                                8.073167e-08                 -6.740640e-02
#> 100                               1.506991e-06                 -7.209028e-02
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   6.708020e-03  5.277867e-07
#> 3           Salts.Added.during.Water.Treatment   3.546662e-07  5.288203e-08
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.221578e-01 -1.447032e-01
#> 5                             Ecosystem.Health   6.562354e-02  5.126582e-02
#> 6   Public.Awareness.of.Reservoir.Salinization   5.390131e-07  3.586261e-07
#> 7                Salinization.of.the.Reservoir  -1.098303e-01 -1.308960e-01
#>        0.975_CI           min 0.25_quantile        median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00     1.0000000  1.000000e+00  1.000000e+00
#> 2  1.529442e-02 -1.291707e-06     0.0000000  1.749186e-07  8.375911e-07
#> 3  6.313833e-07 -7.139424e-06     0.0000000  6.727640e-09  4.246822e-07
#> 4 -9.952035e-02 -3.032015e-01    -0.2504157 -9.747256e-02  0.000000e+00
#> 5  7.922928e-02 -1.291707e-06     0.0000000  3.766192e-02  1.246664e-01
#> 6  7.715787e-07 -1.291707e-06     0.0000000  9.418695e-08  7.669509e-07
#> 7 -9.074160e-02 -3.601117e-01    -0.1891189 -9.335968e-02  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 2.184875e-01
#> 3 6.862192e-06
#> 4 3.767478e-07
#> 5 2.785120e-01
#> 6 6.862192e-06
#> 7 5.704189e-06
#> 
get_fcmconfr_inferences(ex_conventional_fcmconfr)
#> $individual_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              1.883739e-07
#> 2      adj_matrix_2                                 1              2.119206e-07
#> 3      adj_matrix_3                                 1              6.862192e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              1.291707e-06
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -8.073167e-08
#> 14    adj_matrix_14                                 1              3.417641e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              2.152845e-07
#> 22    adj_matrix_22                                 1              3.431096e-06
#> 23    adj_matrix_23                                 1              1.614633e-07
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              6.875648e-06
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        1.883739e-07
#> 2                       -1.996777e-06
#> 3                        6.862192e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       1.291707e-06
#> 12                       2.119206e-07
#> 13                      -8.073167e-08
#> 14                       3.417641e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       2.152845e-07
#> 22                       3.431096e-06
#> 23                       1.614633e-07
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       6.875648e-06
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01      0.137976692
#> 2                                 -2.785142e-01      0.149998461
#> 3                                 -1.419821e-01      0.191007238
#> 4                                 -1.823903e-01      0.072280641
#> 5                                 -2.912555e-01      0.139532225
#> 6                                  0.000000e+00      0.000000000
#> 7                                  0.000000e+00      0.000000000
#> 8                                  0.000000e+00      0.000000000
#> 9                                  0.000000e+00      0.067405908
#> 10                                -2.504156e-01      0.139108046
#> 11                                -3.031899e-01      0.006035625
#> 12                                -2.677088e-01      0.179095480
#> 13                                -9.747190e-02      0.014645036
#> 14                                -2.504155e-01      0.333186200
#> 15                                -2.785133e-01      0.076891967
#> 16                                 0.000000e+00      0.071950317
#> 17                                -4.967028e-02      0.007425519
#> 18                                 0.000000e+00      0.000000000
#> 19                                -1.419758e-01      0.081281718
#> 20                                 0.000000e+00      0.000000000
#> 21                                -9.746972e-02      0.012141400
#> 22                                -3.031989e-01      0.089287945
#> 23                                 1.614633e-07      0.179812221
#> 24                                -1.823909e-01      0.132036742
#> 25                                 0.000000e+00      0.000000000
#> 26                                 0.000000e+00      0.000000000
#> 27                                 0.000000e+00      0.000000000
#> 28                                -2.912555e-01      0.235741308
#> 29                                 0.000000e+00      0.000000000
#> 30                                 0.000000e+00      0.000000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                1.883739e-07                   -0.19378115
#> 2                                2.119206e-07                   -0.19939472
#> 3                                6.862192e-06                   -0.28190525
#> 4                                0.000000e+00                   -0.09776002
#> 5                                4.171136e-07                   -0.19620375
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                0.000000e+00                   -0.09747273
#> 10                               2.085568e-07                   -0.16295320
#> 11                               1.291707e-06                   -0.03023763
#> 12                               2.119206e-07                   -0.23025834
#> 13                              -8.073167e-08                   -0.02093391
#> 14                               3.417641e-06                   -0.17292786
#> 15                               1.614633e-07                   -0.15628163
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -6.458534e-07                   -0.03711496
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10344715
#> 20                               0.000000e+00                    0.00000000
#> 21                              -4.857875e-03                   -0.02432385
#> 22                               3.431096e-06                   -0.18248038
#> 23                               1.614633e-07                   -0.21848846
#> 24                               8.073167e-08                   -0.15384686
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               6.875648e-06                   -0.34532517
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $aggregate_inferences
#> # A tibble: 7 × 3
#>   adj_matrix_index node                                             value
#>   <chr>            <chr>                                            <dbl>
#> 1 aggregate        Guidance.Docs.for.Salt.Management             1       
#> 2 aggregate        Public.Education.Programs                     0.00833 
#> 3 aggregate        Salts.Added.during.Water.Treatment           -0.000139
#> 4 aggregate        Salts.Added.by.Winter.Maintenance.Activities -0.136   
#> 5 aggregate        Ecosystem.Health                              0.0848  
#> 6 aggregate        Public.Awareness.of.Reservoir.Salinization   -0.000845
#> 7 aggregate        Salinization.of.the.Reservoir                -0.127   
#> 
#> $mc_inferences
#>      adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1     mc_adj_matrix_1                                 1
#> 2     mc_adj_matrix_2                                 1
#> 3     mc_adj_matrix_3                                 1
#> 4     mc_adj_matrix_4                                 1
#> 5     mc_adj_matrix_5                                 1
#> 6     mc_adj_matrix_6                                 1
#> 7     mc_adj_matrix_7                                 1
#> 8     mc_adj_matrix_8                                 1
#> 9     mc_adj_matrix_9                                 1
#> 10   mc_adj_matrix_10                                 1
#> 11   mc_adj_matrix_11                                 1
#> 12   mc_adj_matrix_12                                 1
#> 13   mc_adj_matrix_13                                 1
#> 14   mc_adj_matrix_14                                 1
#> 15   mc_adj_matrix_15                                 1
#> 16   mc_adj_matrix_16                                 1
#> 17   mc_adj_matrix_17                                 1
#> 18   mc_adj_matrix_18                                 1
#> 19   mc_adj_matrix_19                                 1
#> 20   mc_adj_matrix_20                                 1
#> 21   mc_adj_matrix_21                                 1
#> 22   mc_adj_matrix_22                                 1
#> 23   mc_adj_matrix_23                                 1
#> 24   mc_adj_matrix_24                                 1
#> 25   mc_adj_matrix_25                                 1
#> 26   mc_adj_matrix_26                                 1
#> 27   mc_adj_matrix_27                                 1
#> 28   mc_adj_matrix_28                                 1
#> 29   mc_adj_matrix_29                                 1
#> 30   mc_adj_matrix_30                                 1
#> 31   mc_adj_matrix_31                                 1
#> 32   mc_adj_matrix_32                                 1
#> 33   mc_adj_matrix_33                                 1
#> 34   mc_adj_matrix_34                                 1
#> 35   mc_adj_matrix_35                                 1
#> 36   mc_adj_matrix_36                                 1
#> 37   mc_adj_matrix_37                                 1
#> 38   mc_adj_matrix_38                                 1
#> 39   mc_adj_matrix_39                                 1
#> 40   mc_adj_matrix_40                                 1
#> 41   mc_adj_matrix_41                                 1
#> 42   mc_adj_matrix_42                                 1
#> 43   mc_adj_matrix_43                                 1
#> 44   mc_adj_matrix_44                                 1
#> 45   mc_adj_matrix_45                                 1
#> 46   mc_adj_matrix_46                                 1
#> 47   mc_adj_matrix_47                                 1
#> 48   mc_adj_matrix_48                                 1
#> 49   mc_adj_matrix_49                                 1
#> 50   mc_adj_matrix_50                                 1
#> 51   mc_adj_matrix_51                                 1
#> 52   mc_adj_matrix_52                                 1
#> 53   mc_adj_matrix_53                                 1
#> 54   mc_adj_matrix_54                                 1
#> 55   mc_adj_matrix_55                                 1
#> 56   mc_adj_matrix_56                                 1
#> 57   mc_adj_matrix_57                                 1
#> 58   mc_adj_matrix_58                                 1
#> 59   mc_adj_matrix_59                                 1
#> 60   mc_adj_matrix_60                                 1
#> 61   mc_adj_matrix_61                                 1
#> 62   mc_adj_matrix_62                                 1
#> 63   mc_adj_matrix_63                                 1
#> 64   mc_adj_matrix_64                                 1
#> 65   mc_adj_matrix_65                                 1
#> 66   mc_adj_matrix_66                                 1
#> 67   mc_adj_matrix_67                                 1
#> 68   mc_adj_matrix_68                                 1
#> 69   mc_adj_matrix_69                                 1
#> 70   mc_adj_matrix_70                                 1
#> 71   mc_adj_matrix_71                                 1
#> 72   mc_adj_matrix_72                                 1
#> 73   mc_adj_matrix_73                                 1
#> 74   mc_adj_matrix_74                                 1
#> 75   mc_adj_matrix_75                                 1
#> 76   mc_adj_matrix_76                                 1
#> 77   mc_adj_matrix_77                                 1
#> 78   mc_adj_matrix_78                                 1
#> 79   mc_adj_matrix_79                                 1
#> 80   mc_adj_matrix_80                                 1
#> 81   mc_adj_matrix_81                                 1
#> 82   mc_adj_matrix_82                                 1
#> 83   mc_adj_matrix_83                                 1
#> 84   mc_adj_matrix_84                                 1
#> 85   mc_adj_matrix_85                                 1
#> 86   mc_adj_matrix_86                                 1
#> 87   mc_adj_matrix_87                                 1
#> 88   mc_adj_matrix_88                                 1
#> 89   mc_adj_matrix_89                                 1
#> 90   mc_adj_matrix_90                                 1
#> 91   mc_adj_matrix_91                                 1
#> 92   mc_adj_matrix_92                                 1
#> 93   mc_adj_matrix_93                                 1
#> 94   mc_adj_matrix_94                                 1
#> 95   mc_adj_matrix_95                                 1
#> 96   mc_adj_matrix_96                                 1
#> 97   mc_adj_matrix_97                                 1
#> 98   mc_adj_matrix_98                                 1
#> 99   mc_adj_matrix_99                                 1
#> 100 mc_adj_matrix_100                                 1
#>     Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1               -7.534956e-07                      -7.534956e-07
#> 2                3.767478e-07                       3.767478e-07
#> 3                3.390730e-06                       3.390730e-06
#> 4                1.506991e-06                       1.506991e-06
#> 5                0.000000e+00                       0.000000e+00
#> 6                0.000000e+00                       0.000000e+00
#> 7                4.171136e-07                       4.171136e-07
#> 8                4.238413e-07                       4.238413e-07
#> 9                0.000000e+00                       0.000000e+00
#> 10               0.000000e+00                       0.000000e+00
#> 11               3.229267e-06                       3.229267e-06
#> 12               0.000000e+00                       0.000000e+00
#> 13               0.000000e+00                       0.000000e+00
#> 14               4.171136e-07                       4.171136e-07
#> 15               0.000000e+00                       0.000000e+00
#> 16               8.476826e-07                       8.476826e-07
#> 17               8.342273e-07                      -6.998549e-06
#> 18               3.441188e-06                       3.441188e-06
#> 19               5.382112e-08                       5.382112e-08
#> 20               1.345528e-08                       1.345528e-08
#> 21               1.883739e-07                       1.883739e-07
#> 22               4.272051e-07                       4.272051e-07
#> 23               0.000000e+00                       0.000000e+00
#> 24               8.476826e-07                      -7.139424e-06
#> 25               1.883739e-07                       1.883739e-07
#> 26               0.000000e+00                       0.000000e+00
#> 27               1.695365e-06                       1.695365e-06
#> 28               0.000000e+00                       0.000000e+00
#> 29               0.000000e+00                       0.000000e+00
#> 30              -5.382112e-08                      -5.382112e-08
#> 31              -6.458534e-07                      -6.458534e-07
#> 32              -1.614633e-07                      -1.614633e-07
#> 33               0.000000e+00                       0.000000e+00
#> 34               0.000000e+00                       0.000000e+00
#> 35              -5.382112e-08                      -5.382112e-08
#> 36              -1.291707e-06                      -1.291707e-06
#> 37               8.073167e-07                       8.073167e-07
#> 38              -4.305689e-07                      -4.305689e-07
#> 39               0.000000e+00                       0.000000e+00
#> 40               1.715548e-06                       1.715548e-06
#> 41               1.708820e-06                       1.708820e-06
#> 42               8.544102e-07                       8.544102e-07
#> 43               0.000000e+00                       0.000000e+00
#> 44               0.000000e+00                       0.000000e+00
#> 45               2.152845e-07                       2.152845e-07
#> 46               2.152845e-07                       2.152845e-07
#> 47              -1.614633e-07                      -1.614633e-07
#> 48               6.862192e-06                       6.862192e-06
#> 49               2.184841e-01                      -2.152845e-07
#> 50               0.000000e+00                       0.000000e+00
#> 51               0.000000e+00                       0.000000e+00
#> 52               4.036584e-07                       4.036584e-07
#> 53               1.883739e-07                       1.883739e-07
#> 54               8.544102e-07                       8.544102e-07
#> 55               2.184874e-01                       0.000000e+00
#> 56               3.767478e-07                       3.767478e-07
#> 57               2.018292e-07                       2.018292e-07
#> 58               2.184875e-01                       3.336909e-06
#> 59               4.171136e-07                       4.171136e-07
#> 60               8.476826e-07                       8.476826e-07
#> 61               1.883739e-07                       1.883739e-07
#> 62               1.883739e-07                       1.883739e-07
#> 63               0.000000e+00                       0.000000e+00
#> 64               0.000000e+00                       0.000000e+00
#> 65               0.000000e+00                       0.000000e+00
#> 66               3.336909e-06                       3.336909e-06
#> 67               0.000000e+00                       0.000000e+00
#> 68               4.238413e-07                       4.238413e-07
#> 69               0.000000e+00                       0.000000e+00
#> 70               0.000000e+00                       0.000000e+00
#> 71               1.614633e-07                      -1.475221e-06
#> 72               3.767478e-07                       3.767478e-07
#> 73               0.000000e+00                       0.000000e+00
#> 74               8.544102e-07                       8.544102e-07
#> 75               0.000000e+00                       0.000000e+00
#> 76              -6.458534e-07                      -6.458534e-07
#> 77              -5.382112e-08                      -5.382112e-08
#> 78               0.000000e+00                       0.000000e+00
#> 79               7.534956e-07                       7.534956e-07
#> 80               3.437824e-06                       3.437824e-06
#> 81               0.000000e+00                       0.000000e+00
#> 82               3.229267e-07                       3.229267e-07
#> 83               2.152845e-07                       2.152845e-07
#> 84               1.076422e-07                      -9.655405e-07
#> 85               3.767478e-07                       3.767478e-07
#> 86               1.715548e-06                       1.715548e-06
#> 87               2.085568e-07                       2.085568e-07
#> 88               0.000000e+00                       0.000000e+00
#> 89              -3.767478e-07                      -3.767478e-07
#> 90               0.000000e+00                       0.000000e+00
#> 91               1.708820e-06                       1.708820e-06
#> 92               8.476826e-07                       8.476826e-07
#> 93               0.000000e+00                       0.000000e+00
#> 94               5.382112e-08                       5.382112e-08
#> 95               3.417641e-06                       3.417641e-06
#> 96               0.000000e+00                       0.000000e+00
#> 97               0.000000e+00                       0.000000e+00
#> 98               1.695365e-06                       1.695365e-06
#> 99               8.073167e-08                       8.073167e-08
#> 100              1.506991e-06                       1.506991e-06
#>     Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  -1.823854e-01     3.583183e-02
#> 2                                  -1.823916e-01     3.767478e-07
#> 3                                  -2.677077e-01     7.103345e-02
#> 4                                  -2.425477e-06     1.797959e-01
#> 5                                   0.000000e+00     0.000000e+00
#> 6                                  -1.419722e-01     9.265583e-02
#> 7                                  -2.785139e-01     1.588091e-01
#> 8                                  -3.031963e-01     1.521855e-01
#> 9                                   0.000000e+00     0.000000e+00
#> 10                                  0.000000e+00     0.000000e+00
#> 11                                 -2.912530e-01     7.168666e-03
#> 12                                  0.000000e+00     0.000000e+00
#> 13                                  0.000000e+00     7.804836e-02
#> 14                                 -2.912555e-01     1.524788e-01
#> 15                                  0.000000e+00     0.000000e+00
#> 16                                 -3.031961e-01     1.098823e-01
#> 17                                 -2.504156e-01     1.480956e-01
#> 18                                 -3.032004e-01     2.648744e-01
#> 19                                 -5.096808e-07     3.883449e-02
#> 20                                 -9.747256e-02     4.894938e-02
#> 21                                 -1.823910e-01     9.555170e-02
#> 22                                 -2.504157e-01     1.540205e-01
#> 23                                  0.000000e+00     0.000000e+00
#> 24                                 -1.823909e-01     2.417474e-01
#> 25                                 -2.504156e-01     1.021914e-01
#> 26                                  0.000000e+00     9.390562e-02
#> 27                                 -2.912542e-01     1.850628e-02
#> 28                                  0.000000e+00     0.000000e+00
#> 29                                  0.000000e+00     0.000000e+00
#> 30                                 -4.967107e-02     3.549106e-02
#> 31                                 -9.747005e-02     1.934383e-02
#> 32                                 -4.967097e-02     2.463721e-02
#> 33                                  0.000000e+00     0.000000e+00
#> 34                                  0.000000e+00     1.256037e-01
#> 35                                 -9.747122e-02     4.429092e-02
#> 36                                 -9.746787e-02    -1.291707e-06
#> 37                                 -1.419779e-01     3.366669e-02
#> 38                                 -9.746991e-02     8.589623e-03
#> 39                                  0.000000e+00     0.000000e+00
#> 40                                 -3.031958e-01     1.781086e-01
#> 41                                 -2.912555e-01     1.973477e-01
#> 42                                 -9.747759e-02     5.106911e-02
#> 43                                  0.000000e+00     0.000000e+00
#> 44                                  0.000000e+00     0.000000e+00
#> 45                                 -9.747257e-02     1.947810e-03
#> 46                                  2.152845e-07     1.370156e-01
#> 47                                 -9.747186e-02     6.079128e-02
#> 48                                 -3.032015e-01     1.751653e-01
#> 49                                 -1.419743e-01     3.648935e-02
#> 50                                  0.000000e+00     0.000000e+00
#> 51                                  0.000000e+00     0.000000e+00
#> 52                                 -2.785138e-01     5.118915e-02
#> 53                                 -1.823903e-01     5.183704e-02
#> 54                                 -2.785149e-01     1.430670e-01
#> 55                                  0.000000e+00     0.000000e+00
#> 56                                  3.767478e-07     2.785119e-01
#> 57                                 -2.504158e-01     1.467342e-01
#> 58                                 -1.823897e-01     3.336909e-06
#> 59                                 -2.504164e-01     6.831333e-02
#> 60                                 -3.031961e-01     1.431412e-01
#> 61                                 -2.677081e-01     8.952663e-02
#> 62                                 -2.504156e-01     1.243539e-01
#> 63                                  0.000000e+00     0.000000e+00
#> 64                                  0.000000e+00     0.000000e+00
#> 65                                  0.000000e+00     1.050123e-01
#> 66                                 -5.003946e-06     1.538490e-01
#> 67                                  0.000000e+00     0.000000e+00
#> 68                                 -2.785138e-01     1.267207e-01
#> 69                                  0.000000e+00     0.000000e+00
#> 70                                  0.000000e+00     0.000000e+00
#> 71                                 -1.475221e-06     2.785120e-01
#> 72                                 -9.747304e-02     4.728087e-02
#> 73                                  0.000000e+00     0.000000e+00
#> 74                                 -3.031965e-01     1.521870e-01
#> 75                                  0.000000e+00     0.000000e+00
#> 76                                 -9.747005e-02     9.373202e-02
#> 77                                 -4.967107e-02     2.449706e-02
#> 78                                  0.000000e+00     0.000000e+00
#> 79                                 -1.202018e-01     3.112357e-02
#> 80                                 -2.912576e-01     1.395462e-01
#> 81                                  0.000000e+00     0.000000e+00
#> 82                                 -1.823902e-01     3.361201e-02
#> 83                                 -1.823895e-01     2.316391e-02
#> 84                                 -1.823902e-01     5.184491e-02
#> 85                                 -1.823908e-01     1.305066e-02
#> 86                                 -3.031962e-01     2.141839e-01
#> 87                                 -2.785138e-01     1.267225e-01
#> 88                                  0.000000e+00     0.000000e+00
#> 89                                 -9.747126e-02     7.495468e-02
#> 90                                  0.000000e+00     0.000000e+00
#> 91                                 -2.785139e-01     1.144522e-01
#> 92                                 -3.031961e-01     9.831713e-02
#> 93                                  0.000000e+00     0.000000e+00
#> 94                                 -1.202010e-01     1.583222e-02
#> 95                                 -9.747835e-02     1.778773e-01
#> 96                                  0.000000e+00     0.000000e+00
#> 97                                  0.000000e+00     9.743164e-03
#> 98                                 -2.785153e-01     3.970502e-02
#> 99                                 -9.747287e-02     3.360292e-02
#> 100                                -9.747421e-02     7.199305e-03
#>     Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                -7.534956e-07                 -7.193752e-02
#> 2                                 3.767478e-07                 -1.225782e-01
#> 3                                 3.390730e-06                 -3.601117e-01
#> 4                                 1.506991e-06                 -2.184893e-01
#> 5                                 0.000000e+00                  0.000000e+00
#> 6                                 0.000000e+00                 -2.371042e-01
#> 7                                 4.171136e-07                 -1.891189e-01
#> 8                                 4.238413e-07                 -2.027005e-01
#> 9                                 0.000000e+00                  0.000000e+00
#> 10                                0.000000e+00                  0.000000e+00
#> 11                                3.229267e-06                 -7.180147e-02
#> 12                                0.000000e+00                  0.000000e+00
#> 13                                0.000000e+00                 -1.202016e-01
#> 14                                4.171136e-07                 -1.625190e-01
#> 15                                0.000000e+00                  0.000000e+00
#> 16                                8.476826e-07                 -2.523196e-01
#> 17                                8.342273e-07                 -3.145119e-01
#> 18                                3.441188e-06                 -3.249258e-01
#> 19                                5.382112e-08                 -9.747398e-02
#> 20                                1.345528e-08                 -5.795988e-02
#> 21                                1.883739e-07                 -1.305957e-01
#> 22                                4.272051e-07                 -1.826435e-01
#> 23                                0.000000e+00                  0.000000e+00
#> 24                                8.476826e-07                 -3.175589e-01
#> 25                                1.883739e-07                 -1.314106e-01
#> 26                                0.000000e+00                 -1.202013e-01
#> 27                                1.695365e-06                 -1.853357e-01
#> 28                                0.000000e+00                  0.000000e+00
#> 29                                0.000000e+00                  0.000000e+00
#> 30                               -5.382112e-08                 -3.957012e-02
#> 31                               -6.458534e-07                 -4.842383e-02
#> 32                               -1.614633e-07                 -4.934797e-02
#> 33                                0.000000e+00                  0.000000e+00
#> 34                                0.000000e+00                 -2.184892e-01
#> 35                               -5.382112e-08                 -6.363144e-02
#> 36                               -1.291707e-06                 -7.207256e-02
#> 37                                8.073167e-07                 -1.351009e-01
#> 38                               -4.305689e-07                 -8.598165e-02
#> 39                                0.000000e+00                  0.000000e+00
#> 40                                1.715548e-06                 -2.946346e-01
#> 41                                1.708820e-06                 -2.750302e-01
#> 42                                8.544102e-07                 -6.857846e-02
#> 43                                0.000000e+00                  0.000000e+00
#> 44                                0.000000e+00                  0.000000e+00
#> 45                                2.152845e-07                 -1.947552e-02
#> 46                                2.152845e-07                 -2.184884e-01
#> 47                               -1.614633e-07                 -7.675143e-02
#> 48                                6.862192e-06                 -2.383302e-01
#> 49                               -2.152845e-07                 -9.160010e-02
#> 50                                0.000000e+00                  0.000000e+00
#> 51                                0.000000e+00                  0.000000e+00
#> 52                                4.036584e-07                 -6.875044e-02
#> 53                                1.883739e-07                 -1.160629e-01
#> 54                                8.544102e-07                 -1.891212e-01
#> 55                                0.000000e+00                  0.000000e+00
#> 56                                3.767478e-07                  5.704189e-06
#> 57                                2.018292e-07                 -1.729344e-01
#> 58                                3.336909e-06                 -2.550566e-01
#> 59                                4.171136e-07                 -1.729368e-01
#> 60                                8.476826e-07                 -2.523196e-01
#> 61                                1.883739e-07                 -1.829849e-01
#> 62                                1.883739e-07                 -1.729336e-01
#> 63                                0.000000e+00                  0.000000e+00
#> 64                                0.000000e+00                  0.000000e+00
#> 65                                0.000000e+00                 -1.202015e-01
#> 66                                3.336909e-06                 -1.824018e-01
#> 67                                0.000000e+00                  0.000000e+00
#> 68                                4.238413e-07                 -1.891188e-01
#> 69                                0.000000e+00                  0.000000e+00
#> 70                                0.000000e+00                  0.000000e+00
#> 71                                1.614633e-07                 -7.329113e-06
#> 72                                3.767478e-07                 -7.209254e-02
#> 73                                0.000000e+00                  0.000000e+00
#> 74                                8.544102e-07                 -2.027015e-01
#> 75                                0.000000e+00                  0.000000e+00
#> 76                               -6.458534e-07                 -1.919739e-01
#> 77                               -5.382112e-08                 -2.726434e-02
#> 78                                0.000000e+00                  0.000000e+00
#> 79                                7.534956e-07                 -7.804617e-02
#> 80                                3.437824e-06                 -1.962132e-01
#> 81                                0.000000e+00                  0.000000e+00
#> 82                                3.229267e-07                 -1.686398e-01
#> 83                                2.152845e-07                 -1.160574e-01
#> 84                                1.076422e-07                 -1.305913e-01
#> 85                                3.767478e-07                 -1.305934e-01
#> 86                                1.715548e-06                 -3.046656e-01
#> 87                                2.085568e-07                 -1.891187e-01
#> 88                                0.000000e+00                  0.000000e+00
#> 89                               -3.767478e-07                 -9.511926e-02
#> 90                                0.000000e+00                  0.000000e+00
#> 91                                1.708820e-06                 -2.371884e-01
#> 92                                8.476826e-07                 -2.523196e-01
#> 93                                0.000000e+00                  0.000000e+00
#> 94                                5.382112e-08                 -2.400336e-02
#> 95                                3.417641e-06                 -2.588521e-01
#> 96                                0.000000e+00                  0.000000e+00
#> 97                                0.000000e+00                 -9.747207e-02
#> 98                                1.695365e-06                 -1.993928e-01
#> 99                                8.073167e-08                 -6.740640e-02
#> 100                               1.506991e-06                 -7.209028e-02
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   6.708020e-03  5.277867e-07
#> 3           Salts.Added.during.Water.Treatment   3.546662e-07  5.288203e-08
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.221578e-01 -1.447032e-01
#> 5                             Ecosystem.Health   6.562354e-02  5.126582e-02
#> 6   Public.Awareness.of.Reservoir.Salinization   5.390131e-07  3.586261e-07
#> 7                Salinization.of.the.Reservoir  -1.098303e-01 -1.308960e-01
#>        0.975_CI           min 0.25_quantile        median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00     1.0000000  1.000000e+00  1.000000e+00
#> 2  1.529442e-02 -1.291707e-06     0.0000000  1.749186e-07  8.375911e-07
#> 3  6.313833e-07 -7.139424e-06     0.0000000  6.727640e-09  4.246822e-07
#> 4 -9.952035e-02 -3.032015e-01    -0.2504157 -9.747256e-02  0.000000e+00
#> 5  7.922928e-02 -1.291707e-06     0.0000000  3.766192e-02  1.246664e-01
#> 6  7.715787e-07 -1.291707e-06     0.0000000  9.418695e-08  7.669509e-07
#> 7 -9.074160e-02 -3.601117e-01    -0.1891189 -9.335968e-02  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 2.184875e-01
#> 3 6.862192e-06
#> 4 3.767478e-07
#> 5 2.785120e-01
#> 6 6.862192e-06
#> 7 5.704189e-06
#> 


ex_ivfn_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$ivfn_fcms,
  # adj_matrices = group_ivfn_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 10L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 10L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
#> [1] Simulating Input FCMs
#> 
#> [1] Running Simulations
#> [1] Sampling from column vectors
#> Sampling from column vectors[1] Constructing monte carlo fcms from samples
#> Constructing monte carlo fcms from samples
#> [1] Running Simulations
#> [1] Performing bootstrap simulations
#> [1] Done
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual"))
#> $individual_inferences
#> $individual_inferences$ivfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                              1, 1
#> 2      adj_matrix_2                              1, 1
#> 3      adj_matrix_3                              1, 1
#> 4      adj_matrix_4                              1, 1
#> 5      adj_matrix_5                              1, 1
#> 6      adj_matrix_6                              1, 1
#> 7      adj_matrix_7                              1, 1
#> 8      adj_matrix_8                              1, 1
#> 9      adj_matrix_9                              1, 1
#> 10    adj_matrix_10                              1, 1
#> 11    adj_matrix_11                              1, 1
#> 12    adj_matrix_12                              1, 1
#> 13    adj_matrix_13                              1, 1
#> 14    adj_matrix_14                              1, 1
#> 15    adj_matrix_15                              1, 1
#> 16    adj_matrix_16                              1, 1
#> 17    adj_matrix_17                              1, 1
#> 18    adj_matrix_18                              1, 1
#> 19    adj_matrix_19                              1, 1
#> 20    adj_matrix_20                              1, 1
#> 21    adj_matrix_21                              1, 1
#> 22    adj_matrix_22                              1, 1
#> 23    adj_matrix_23                              1, 1
#> 24    adj_matrix_24                              1, 1
#> 25    adj_matrix_25                              1, 1
#> 26    adj_matrix_26                              1, 1
#> 27    adj_matrix_27                              1, 1
#> 28    adj_matrix_28                              1, 1
#> 29    adj_matrix_29                              1, 1
#> 30    adj_matrix_30                              1, 1
#>       Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1    4.171136e-07, 4.171136e-07         4.171136e-07, 4.171136e-07
#> 2    4.238413e-07, 4.238413e-07       -7.287071e-06, -2.716813e-07
#> 3      1.70882e-06, 1.70882e-06           1.70882e-06, 1.70882e-06
#> 4  -1.076422e-07, -1.076422e-07       -1.076422e-07, -1.076422e-07
#> 5    4.036584e-07, 4.036584e-07         4.036584e-07, 4.036584e-07
#> 6                          0, 0                               0, 0
#> 7                          0, 0                               0, 0
#> 8                          0, 0                               0, 0
#> 9                          0, 0                               0, 0
#> 10   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 11   6.458534e-07, 6.458534e-07         6.458534e-07, 6.458534e-07
#> 12   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 13   -8.57774e-07, -8.57774e-07         -8.57774e-07, -8.57774e-07
#> 14   1.695365e-06, 1.695365e-06         1.695365e-06, 1.695365e-06
#> 15   1.614633e-07, 1.614633e-07         1.614633e-07, 1.614633e-07
#> 16       0.04966353, 0.32487741       -2.152845e-07, -2.152845e-07
#> 17 -6.458534e-07, -6.458534e-07       -6.458534e-07, -6.458534e-07
#> 18                         0, 0                               0, 0
#> 19                         0, 0                               0, 0
#> 20                         0, 0                               0, 0
#> 21   3.767478e-07, 3.767478e-07         3.767478e-07, 3.767478e-07
#> 22   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 23                         0, 0                               0, 0
#> 24   5.382112e-08, 5.382112e-08         5.382112e-08, 5.382112e-08
#> 25                         0, 0                               0, 0
#> 26                         0, 0                               0, 0
#> 27                         0, 0                               0, 0
#> 28   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 29                         0, 0                               0, 0
#> 30                         0, 0                               0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities            Ecosystem.Health
#> 1                   -2.649185e-01, 1.263065e-06      0.06469253, 0.17227483
#> 2                        -0.3439474, -0.1419764      0.06108397, 0.14559866
#> 3                   -2.785162e-01, 2.126505e-06      0.08060473, 0.20768978
#> 4                   -3.031966e-01, 3.501569e-06      0.02783340, 0.07845669
#> 5                        -0.3439468, -0.1627196      0.05339747, 0.14519200
#> 6                   -4.509185e-07, 4.509185e-07 -1.650893e-05, 1.650893e-05
#> 7                                          0, 0 -2.326245e-05, 2.326245e-05
#> 8                                          0, 0 -3.672809e-06, 3.672809e-06
#> 9                                          0, 0      0.03741838, 0.12038236
#> 10                     -0.34394685, -0.09747165      0.06506459, 0.12608345
#> 11                       -0.3439454, -0.1823867 -2.289465e-05, 3.765054e-02
#> 12                       -0.3439471, -0.1246364      0.07565469, 0.15926995
#> 13                  -2.504168e-01, 1.783381e-05      0.01310921, 0.04349949
#> 14                     -0.34394690, -0.09747073        0.1754727, 0.3854074
#> 15                       -0.3439467, -0.1419752      0.01306651, 0.11380505
#> 16                 -2.152845e-07, -2.152845e-07 -6.760308e-07, 1.168798e-01
#> 17                  -2.184896e-01, 7.509039e-06 -2.824574e-05, 4.300210e-02
#> 18                                         0, 0 -1.668145e-05, 1.668145e-05
#> 19                  -2.785142e-01, 1.654658e-06      0.03608334, 0.08867611
#> 20                  -9.886287e-07, 9.886287e-07 -1.281902e-05, 1.281902e-05
#> 21                  -2.504168e-01, 4.355196e-06      0.00397327, 0.03586478
#> 22                       -0.3439477, -0.1823909      0.01471456, 0.12700531
#> 23                                         0, 0      0.09154776, 0.17251847
#> 24                  -3.031964e-01, 1.042238e-06      0.05405402, 0.10574555
#> 25                                         0, 0 -8.449817e-06, 8.449817e-06
#> 26                                         0, 0                        0, 0
#> 27                                         0, 0 -2.136079e-05, 2.136079e-05
#> 28                       -0.3439469, -0.1627198        0.1111561, 0.2427314
#> 29                                         0, 0 -1.648369e-05, 1.648369e-05
#> 30                  -8.650037e-07, 8.650037e-07 -1.613378e-05, 1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                  4.171136e-07, 4.171136e-07      -0.32787900, -0.04609143
#> 2                  4.238413e-07, 4.238413e-07      -0.21367455, -0.09485554
#> 3                    1.70882e-06, 1.70882e-06      -0.37253859, -0.09629834
#> 4                -1.076422e-07, -1.076422e-07      -0.13685759, -0.02269413
#> 5                  4.036584e-07, 4.036584e-07      -0.22074222, -0.08687954
#> 6                                        0, 0   -2.103436e-06, 2.103436e-06
#> 7                                        0, 0   -6.586473e-06, 6.586473e-06
#> 8                                        0, 0   -8.743405e-07, 8.743405e-07
#> 9                                        0, 0   -2.504205e-01, 7.038508e-06
#> 10                 2.085568e-07, 2.085568e-07      -0.19786251, -0.06545225
#> 11                 6.458534e-07, 6.458534e-07   -1.260312e-01, 1.466273e-05
#> 12                 2.085568e-07, 2.085568e-07        -0.2076103, -0.1338848
#> 13                 -8.57774e-07, -8.57774e-07   -8.748446e-02, 4.087751e-05
#> 14                 1.695365e-06, 1.695365e-06      -0.19785836, -0.07604704
#> 15                 1.614633e-07, 1.614633e-07        -0.2136648, -0.0482797
#> 16               -2.152845e-07, -2.152845e-07   -3.032049e-01, 9.271562e-06
#> 17               -6.458534e-07, -6.458534e-07        -0.1059742, -0.0380653
#> 18                                       0, 0   -8.926425e-07, 8.926425e-07
#> 19                                       0, 0      -0.13273925, -0.04842825
#> 20                                       0, 0   -5.043371e-06, 5.043371e-06
#> 21                -2.395658e-02, 1.746007e-05   -7.999894e-02, 1.066973e-05
#> 22                 8.476826e-07, 8.476826e-07      -0.22729144, -0.06758692
#> 23                                       0, 0        -0.3248824, -0.0496664
#> 24                 5.382112e-08, 5.382112e-08      -0.14333141, -0.07466872
#> 25                                       0, 0     -1.50192e-06, 1.50192e-06
#> 26                                       0, 0   -2.008037e-05, 2.008037e-05
#> 27                                       0, 0   -2.783859e-06, 2.783859e-06
#> 28                 8.476826e-07, 8.476826e-07        -0.4112664, -0.1635199
#> 29                                       0, 0   -5.991399e-06, 5.991399e-06
#> 30                                       0, 0   -3.572937e-06, 3.572937e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966353e-02
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.469253e-02
#> 2                                 -3.439474e-01     6.108397e-02
#> 3                                 -2.785162e-01     8.060473e-02
#> 4                                 -3.031966e-01     2.783340e-02
#> 5                                 -3.439468e-01     5.339747e-02
#> 6                                 -4.509185e-07    -1.650893e-05
#> 7                                  0.000000e+00    -2.326245e-05
#> 8                                  0.000000e+00    -3.672809e-06
#> 9                                  0.000000e+00     3.741838e-02
#> 10                                -3.439468e-01     6.506459e-02
#> 11                                -3.439454e-01    -2.289465e-05
#> 12                                -3.439471e-01     7.565469e-02
#> 13                                -2.504168e-01     1.310921e-02
#> 14                                -3.439469e-01     1.754727e-01
#> 15                                -3.439467e-01     1.306651e-02
#> 16                                -2.152845e-07    -6.760308e-07
#> 17                                -2.184896e-01    -2.824574e-05
#> 18                                 0.000000e+00    -1.668145e-05
#> 19                                -2.785142e-01     3.608334e-02
#> 20                                -9.886287e-07    -1.281902e-05
#> 21                                -2.504168e-01     3.973270e-03
#> 22                                -3.439477e-01     1.471456e-02
#> 23                                 0.000000e+00     9.154776e-02
#> 24                                -3.031964e-01     5.405402e-02
#> 25                                 0.000000e+00    -8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.136079e-05
#> 28                                -3.439469e-01     1.111561e-01
#> 29                                 0.000000e+00    -1.648369e-05
#> 30                                -8.650037e-07    -1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.278790e-01
#> 2                                4.238413e-07                 -2.136746e-01
#> 3                                1.708820e-06                 -3.725386e-01
#> 4                               -1.076422e-07                 -1.368576e-01
#> 5                                4.036584e-07                 -2.207422e-01
#> 6                                0.000000e+00                 -2.103436e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                                0.000000e+00                 -2.504205e-01
#> 10                               2.085568e-07                 -1.978625e-01
#> 11                               6.458534e-07                 -1.260312e-01
#> 12                               2.085568e-07                 -2.076103e-01
#> 13                              -8.577740e-07                 -8.748446e-02
#> 14                               1.695365e-06                 -1.978584e-01
#> 15                               1.614633e-07                 -2.136648e-01
#> 16                              -2.152845e-07                 -3.032049e-01
#> 17                              -6.458534e-07                 -1.059742e-01
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.327392e-01
#> 20                               0.000000e+00                 -5.043371e-06
#> 21                              -2.395658e-02                 -7.999894e-02
#> 22                               8.476826e-07                 -2.272914e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               5.382112e-08                 -1.433314e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.112664e-01
#> 29                               0.000000e+00                 -5.991399e-06
#> 30                               0.000000e+00                 -3.572937e-06
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.263065e-06     1.722748e-01
#> 2                                 -1.419764e-01     1.455987e-01
#> 3                                  2.126505e-06     2.076898e-01
#> 4                                  3.501569e-06     7.845669e-02
#> 5                                 -1.627196e-01     1.451920e-01
#> 6                                  4.509185e-07     1.650893e-05
#> 7                                  0.000000e+00     2.326245e-05
#> 8                                  0.000000e+00     3.672809e-06
#> 9                                  0.000000e+00     1.203824e-01
#> 10                                -9.747165e-02     1.260835e-01
#> 11                                -1.823867e-01     3.765054e-02
#> 12                                -1.246364e-01     1.592699e-01
#> 13                                 1.783381e-05     4.349949e-02
#> 14                                -9.747073e-02     3.854074e-01
#> 15                                -1.419752e-01     1.138050e-01
#> 16                                -2.152845e-07     1.168798e-01
#> 17                                 7.509039e-06     4.300210e-02
#> 18                                 0.000000e+00     1.668145e-05
#> 19                                 1.654658e-06     8.867611e-02
#> 20                                 9.886287e-07     1.281902e-05
#> 21                                 4.355196e-06     3.586478e-02
#> 22                                -1.823909e-01     1.270053e-01
#> 23                                 0.000000e+00     1.725185e-01
#> 24                                 1.042238e-06     1.057456e-01
#> 25                                 0.000000e+00     8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.136079e-05
#> 28                                -1.627198e-01     2.427314e-01
#> 29                                 0.000000e+00     1.648369e-05
#> 30                                 8.650037e-07     1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.609143e-02
#> 2                                4.238413e-07                 -9.485554e-02
#> 3                                1.708820e-06                 -9.629834e-02
#> 4                               -1.076422e-07                 -2.269413e-02
#> 5                                4.036584e-07                 -8.687954e-02
#> 6                                0.000000e+00                  2.103436e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                                0.000000e+00                  7.038508e-06
#> 10                               2.085568e-07                 -6.545225e-02
#> 11                               6.458534e-07                  1.466273e-05
#> 12                               2.085568e-07                 -1.338848e-01
#> 13                              -8.577740e-07                  4.087751e-05
#> 14                               1.695365e-06                 -7.604704e-02
#> 15                               1.614633e-07                 -4.827970e-02
#> 16                              -2.152845e-07                  9.271562e-06
#> 17                              -6.458534e-07                 -3.806530e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.842825e-02
#> 20                               0.000000e+00                  5.043371e-06
#> 21                               1.746007e-05                  1.066973e-05
#> 22                               8.476826e-07                 -6.758692e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               5.382112e-08                 -7.466872e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.635199e-01
#> 29                               0.000000e+00                  5.991399e-06
#> 30                               0.000000e+00                  3.572937e-06
#> 
#> 
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual", "aggregate"))
#> $individual_inferences
#> $individual_inferences$ivfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                              1, 1
#> 2      adj_matrix_2                              1, 1
#> 3      adj_matrix_3                              1, 1
#> 4      adj_matrix_4                              1, 1
#> 5      adj_matrix_5                              1, 1
#> 6      adj_matrix_6                              1, 1
#> 7      adj_matrix_7                              1, 1
#> 8      adj_matrix_8                              1, 1
#> 9      adj_matrix_9                              1, 1
#> 10    adj_matrix_10                              1, 1
#> 11    adj_matrix_11                              1, 1
#> 12    adj_matrix_12                              1, 1
#> 13    adj_matrix_13                              1, 1
#> 14    adj_matrix_14                              1, 1
#> 15    adj_matrix_15                              1, 1
#> 16    adj_matrix_16                              1, 1
#> 17    adj_matrix_17                              1, 1
#> 18    adj_matrix_18                              1, 1
#> 19    adj_matrix_19                              1, 1
#> 20    adj_matrix_20                              1, 1
#> 21    adj_matrix_21                              1, 1
#> 22    adj_matrix_22                              1, 1
#> 23    adj_matrix_23                              1, 1
#> 24    adj_matrix_24                              1, 1
#> 25    adj_matrix_25                              1, 1
#> 26    adj_matrix_26                              1, 1
#> 27    adj_matrix_27                              1, 1
#> 28    adj_matrix_28                              1, 1
#> 29    adj_matrix_29                              1, 1
#> 30    adj_matrix_30                              1, 1
#>       Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1    4.171136e-07, 4.171136e-07         4.171136e-07, 4.171136e-07
#> 2    4.238413e-07, 4.238413e-07       -7.287071e-06, -2.716813e-07
#> 3      1.70882e-06, 1.70882e-06           1.70882e-06, 1.70882e-06
#> 4  -1.076422e-07, -1.076422e-07       -1.076422e-07, -1.076422e-07
#> 5    4.036584e-07, 4.036584e-07         4.036584e-07, 4.036584e-07
#> 6                          0, 0                               0, 0
#> 7                          0, 0                               0, 0
#> 8                          0, 0                               0, 0
#> 9                          0, 0                               0, 0
#> 10   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 11   6.458534e-07, 6.458534e-07         6.458534e-07, 6.458534e-07
#> 12   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 13   -8.57774e-07, -8.57774e-07         -8.57774e-07, -8.57774e-07
#> 14   1.695365e-06, 1.695365e-06         1.695365e-06, 1.695365e-06
#> 15   1.614633e-07, 1.614633e-07         1.614633e-07, 1.614633e-07
#> 16       0.04966353, 0.32487741       -2.152845e-07, -2.152845e-07
#> 17 -6.458534e-07, -6.458534e-07       -6.458534e-07, -6.458534e-07
#> 18                         0, 0                               0, 0
#> 19                         0, 0                               0, 0
#> 20                         0, 0                               0, 0
#> 21   3.767478e-07, 3.767478e-07         3.767478e-07, 3.767478e-07
#> 22   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 23                         0, 0                               0, 0
#> 24   5.382112e-08, 5.382112e-08         5.382112e-08, 5.382112e-08
#> 25                         0, 0                               0, 0
#> 26                         0, 0                               0, 0
#> 27                         0, 0                               0, 0
#> 28   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 29                         0, 0                               0, 0
#> 30                         0, 0                               0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities            Ecosystem.Health
#> 1                   -2.649185e-01, 1.263065e-06      0.06469253, 0.17227483
#> 2                        -0.3439474, -0.1419764      0.06108397, 0.14559866
#> 3                   -2.785162e-01, 2.126505e-06      0.08060473, 0.20768978
#> 4                   -3.031966e-01, 3.501569e-06      0.02783340, 0.07845669
#> 5                        -0.3439468, -0.1627196      0.05339747, 0.14519200
#> 6                   -4.509185e-07, 4.509185e-07 -1.650893e-05, 1.650893e-05
#> 7                                          0, 0 -2.326245e-05, 2.326245e-05
#> 8                                          0, 0 -3.672809e-06, 3.672809e-06
#> 9                                          0, 0      0.03741838, 0.12038236
#> 10                     -0.34394685, -0.09747165      0.06506459, 0.12608345
#> 11                       -0.3439454, -0.1823867 -2.289465e-05, 3.765054e-02
#> 12                       -0.3439471, -0.1246364      0.07565469, 0.15926995
#> 13                  -2.504168e-01, 1.783381e-05      0.01310921, 0.04349949
#> 14                     -0.34394690, -0.09747073        0.1754727, 0.3854074
#> 15                       -0.3439467, -0.1419752      0.01306651, 0.11380505
#> 16                 -2.152845e-07, -2.152845e-07 -6.760308e-07, 1.168798e-01
#> 17                  -2.184896e-01, 7.509039e-06 -2.824574e-05, 4.300210e-02
#> 18                                         0, 0 -1.668145e-05, 1.668145e-05
#> 19                  -2.785142e-01, 1.654658e-06      0.03608334, 0.08867611
#> 20                  -9.886287e-07, 9.886287e-07 -1.281902e-05, 1.281902e-05
#> 21                  -2.504168e-01, 4.355196e-06      0.00397327, 0.03586478
#> 22                       -0.3439477, -0.1823909      0.01471456, 0.12700531
#> 23                                         0, 0      0.09154776, 0.17251847
#> 24                  -3.031964e-01, 1.042238e-06      0.05405402, 0.10574555
#> 25                                         0, 0 -8.449817e-06, 8.449817e-06
#> 26                                         0, 0                        0, 0
#> 27                                         0, 0 -2.136079e-05, 2.136079e-05
#> 28                       -0.3439469, -0.1627198        0.1111561, 0.2427314
#> 29                                         0, 0 -1.648369e-05, 1.648369e-05
#> 30                  -8.650037e-07, 8.650037e-07 -1.613378e-05, 1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                  4.171136e-07, 4.171136e-07      -0.32787900, -0.04609143
#> 2                  4.238413e-07, 4.238413e-07      -0.21367455, -0.09485554
#> 3                    1.70882e-06, 1.70882e-06      -0.37253859, -0.09629834
#> 4                -1.076422e-07, -1.076422e-07      -0.13685759, -0.02269413
#> 5                  4.036584e-07, 4.036584e-07      -0.22074222, -0.08687954
#> 6                                        0, 0   -2.103436e-06, 2.103436e-06
#> 7                                        0, 0   -6.586473e-06, 6.586473e-06
#> 8                                        0, 0   -8.743405e-07, 8.743405e-07
#> 9                                        0, 0   -2.504205e-01, 7.038508e-06
#> 10                 2.085568e-07, 2.085568e-07      -0.19786251, -0.06545225
#> 11                 6.458534e-07, 6.458534e-07   -1.260312e-01, 1.466273e-05
#> 12                 2.085568e-07, 2.085568e-07        -0.2076103, -0.1338848
#> 13                 -8.57774e-07, -8.57774e-07   -8.748446e-02, 4.087751e-05
#> 14                 1.695365e-06, 1.695365e-06      -0.19785836, -0.07604704
#> 15                 1.614633e-07, 1.614633e-07        -0.2136648, -0.0482797
#> 16               -2.152845e-07, -2.152845e-07   -3.032049e-01, 9.271562e-06
#> 17               -6.458534e-07, -6.458534e-07        -0.1059742, -0.0380653
#> 18                                       0, 0   -8.926425e-07, 8.926425e-07
#> 19                                       0, 0      -0.13273925, -0.04842825
#> 20                                       0, 0   -5.043371e-06, 5.043371e-06
#> 21                -2.395658e-02, 1.746007e-05   -7.999894e-02, 1.066973e-05
#> 22                 8.476826e-07, 8.476826e-07      -0.22729144, -0.06758692
#> 23                                       0, 0        -0.3248824, -0.0496664
#> 24                 5.382112e-08, 5.382112e-08      -0.14333141, -0.07466872
#> 25                                       0, 0     -1.50192e-06, 1.50192e-06
#> 26                                       0, 0   -2.008037e-05, 2.008037e-05
#> 27                                       0, 0   -2.783859e-06, 2.783859e-06
#> 28                 8.476826e-07, 8.476826e-07        -0.4112664, -0.1635199
#> 29                                       0, 0   -5.991399e-06, 5.991399e-06
#> 30                                       0, 0   -3.572937e-06, 3.572937e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966353e-02
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.469253e-02
#> 2                                 -3.439474e-01     6.108397e-02
#> 3                                 -2.785162e-01     8.060473e-02
#> 4                                 -3.031966e-01     2.783340e-02
#> 5                                 -3.439468e-01     5.339747e-02
#> 6                                 -4.509185e-07    -1.650893e-05
#> 7                                  0.000000e+00    -2.326245e-05
#> 8                                  0.000000e+00    -3.672809e-06
#> 9                                  0.000000e+00     3.741838e-02
#> 10                                -3.439468e-01     6.506459e-02
#> 11                                -3.439454e-01    -2.289465e-05
#> 12                                -3.439471e-01     7.565469e-02
#> 13                                -2.504168e-01     1.310921e-02
#> 14                                -3.439469e-01     1.754727e-01
#> 15                                -3.439467e-01     1.306651e-02
#> 16                                -2.152845e-07    -6.760308e-07
#> 17                                -2.184896e-01    -2.824574e-05
#> 18                                 0.000000e+00    -1.668145e-05
#> 19                                -2.785142e-01     3.608334e-02
#> 20                                -9.886287e-07    -1.281902e-05
#> 21                                -2.504168e-01     3.973270e-03
#> 22                                -3.439477e-01     1.471456e-02
#> 23                                 0.000000e+00     9.154776e-02
#> 24                                -3.031964e-01     5.405402e-02
#> 25                                 0.000000e+00    -8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.136079e-05
#> 28                                -3.439469e-01     1.111561e-01
#> 29                                 0.000000e+00    -1.648369e-05
#> 30                                -8.650037e-07    -1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.278790e-01
#> 2                                4.238413e-07                 -2.136746e-01
#> 3                                1.708820e-06                 -3.725386e-01
#> 4                               -1.076422e-07                 -1.368576e-01
#> 5                                4.036584e-07                 -2.207422e-01
#> 6                                0.000000e+00                 -2.103436e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                                0.000000e+00                 -2.504205e-01
#> 10                               2.085568e-07                 -1.978625e-01
#> 11                               6.458534e-07                 -1.260312e-01
#> 12                               2.085568e-07                 -2.076103e-01
#> 13                              -8.577740e-07                 -8.748446e-02
#> 14                               1.695365e-06                 -1.978584e-01
#> 15                               1.614633e-07                 -2.136648e-01
#> 16                              -2.152845e-07                 -3.032049e-01
#> 17                              -6.458534e-07                 -1.059742e-01
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.327392e-01
#> 20                               0.000000e+00                 -5.043371e-06
#> 21                              -2.395658e-02                 -7.999894e-02
#> 22                               8.476826e-07                 -2.272914e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               5.382112e-08                 -1.433314e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.112664e-01
#> 29                               0.000000e+00                 -5.991399e-06
#> 30                               0.000000e+00                 -3.572937e-06
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.263065e-06     1.722748e-01
#> 2                                 -1.419764e-01     1.455987e-01
#> 3                                  2.126505e-06     2.076898e-01
#> 4                                  3.501569e-06     7.845669e-02
#> 5                                 -1.627196e-01     1.451920e-01
#> 6                                  4.509185e-07     1.650893e-05
#> 7                                  0.000000e+00     2.326245e-05
#> 8                                  0.000000e+00     3.672809e-06
#> 9                                  0.000000e+00     1.203824e-01
#> 10                                -9.747165e-02     1.260835e-01
#> 11                                -1.823867e-01     3.765054e-02
#> 12                                -1.246364e-01     1.592699e-01
#> 13                                 1.783381e-05     4.349949e-02
#> 14                                -9.747073e-02     3.854074e-01
#> 15                                -1.419752e-01     1.138050e-01
#> 16                                -2.152845e-07     1.168798e-01
#> 17                                 7.509039e-06     4.300210e-02
#> 18                                 0.000000e+00     1.668145e-05
#> 19                                 1.654658e-06     8.867611e-02
#> 20                                 9.886287e-07     1.281902e-05
#> 21                                 4.355196e-06     3.586478e-02
#> 22                                -1.823909e-01     1.270053e-01
#> 23                                 0.000000e+00     1.725185e-01
#> 24                                 1.042238e-06     1.057456e-01
#> 25                                 0.000000e+00     8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.136079e-05
#> 28                                -1.627198e-01     2.427314e-01
#> 29                                 0.000000e+00     1.648369e-05
#> 30                                 8.650037e-07     1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.609143e-02
#> 2                                4.238413e-07                 -9.485554e-02
#> 3                                1.708820e-06                 -9.629834e-02
#> 4                               -1.076422e-07                 -2.269413e-02
#> 5                                4.036584e-07                 -8.687954e-02
#> 6                                0.000000e+00                  2.103436e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                                0.000000e+00                  7.038508e-06
#> 10                               2.085568e-07                 -6.545225e-02
#> 11                               6.458534e-07                  1.466273e-05
#> 12                               2.085568e-07                 -1.338848e-01
#> 13                              -8.577740e-07                  4.087751e-05
#> 14                               1.695365e-06                 -7.604704e-02
#> 15                               1.614633e-07                 -4.827970e-02
#> 16                              -2.152845e-07                  9.271562e-06
#> 17                              -6.458534e-07                 -3.806530e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.842825e-02
#> 20                               0.000000e+00                  5.043371e-06
#> 21                               1.746007e-05                  1.066973e-05
#> 22                               8.476826e-07                 -6.758692e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               5.382112e-08                 -7.466872e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.635199e-01
#> 29                               0.000000e+00                  5.991399e-06
#> 30                               0.000000e+00                  3.572937e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp         lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.0000000000
#> Public.Education.Programs                     0.0083289587  0.0016667646
#> Salts.Added.during.Water.Treatment           -0.0001386996 -0.0002498283
#> Salts.Added.by.Winter.Maintenance.Activities -0.1292224889 -0.2124023926
#> Ecosystem.Health                              0.0725105589  0.0326894180
#> Public.Awareness.of.Reservoir.Salinization   -0.0011484375 -0.0022974759
#> Salinization.of.the.Reservoir                -0.1148925537 -0.1856959736
#>                                                      upper
#> Guidance.Docs.for.Salt.Management             1.000000e+00
#> Public.Education.Programs                     1.499115e-02
#> Salts.Added.during.Water.Treatment           -2.757085e-05
#> Salts.Added.by.Winter.Maintenance.Activities -4.604259e-02
#> Ecosystem.Health                              1.123317e-01
#> Public.Awareness.of.Reservoir.Salinization    6.008910e-07
#> Salinization.of.the.Reservoir                -4.408913e-02
#> 
get_fcmconfr_inferences(ex_ivfn_fcmconfr, analysis = c("individual", "aggregate", "mc"))
#> $individual_inferences
#> $individual_inferences$ivfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                              1, 1
#> 2      adj_matrix_2                              1, 1
#> 3      adj_matrix_3                              1, 1
#> 4      adj_matrix_4                              1, 1
#> 5      adj_matrix_5                              1, 1
#> 6      adj_matrix_6                              1, 1
#> 7      adj_matrix_7                              1, 1
#> 8      adj_matrix_8                              1, 1
#> 9      adj_matrix_9                              1, 1
#> 10    adj_matrix_10                              1, 1
#> 11    adj_matrix_11                              1, 1
#> 12    adj_matrix_12                              1, 1
#> 13    adj_matrix_13                              1, 1
#> 14    adj_matrix_14                              1, 1
#> 15    adj_matrix_15                              1, 1
#> 16    adj_matrix_16                              1, 1
#> 17    adj_matrix_17                              1, 1
#> 18    adj_matrix_18                              1, 1
#> 19    adj_matrix_19                              1, 1
#> 20    adj_matrix_20                              1, 1
#> 21    adj_matrix_21                              1, 1
#> 22    adj_matrix_22                              1, 1
#> 23    adj_matrix_23                              1, 1
#> 24    adj_matrix_24                              1, 1
#> 25    adj_matrix_25                              1, 1
#> 26    adj_matrix_26                              1, 1
#> 27    adj_matrix_27                              1, 1
#> 28    adj_matrix_28                              1, 1
#> 29    adj_matrix_29                              1, 1
#> 30    adj_matrix_30                              1, 1
#>       Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1    4.171136e-07, 4.171136e-07         4.171136e-07, 4.171136e-07
#> 2    4.238413e-07, 4.238413e-07       -7.287071e-06, -2.716813e-07
#> 3      1.70882e-06, 1.70882e-06           1.70882e-06, 1.70882e-06
#> 4  -1.076422e-07, -1.076422e-07       -1.076422e-07, -1.076422e-07
#> 5    4.036584e-07, 4.036584e-07         4.036584e-07, 4.036584e-07
#> 6                          0, 0                               0, 0
#> 7                          0, 0                               0, 0
#> 8                          0, 0                               0, 0
#> 9                          0, 0                               0, 0
#> 10   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 11   6.458534e-07, 6.458534e-07         6.458534e-07, 6.458534e-07
#> 12   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 13   -8.57774e-07, -8.57774e-07         -8.57774e-07, -8.57774e-07
#> 14   1.695365e-06, 1.695365e-06         1.695365e-06, 1.695365e-06
#> 15   1.614633e-07, 1.614633e-07         1.614633e-07, 1.614633e-07
#> 16       0.04966353, 0.32487741       -2.152845e-07, -2.152845e-07
#> 17 -6.458534e-07, -6.458534e-07       -6.458534e-07, -6.458534e-07
#> 18                         0, 0                               0, 0
#> 19                         0, 0                               0, 0
#> 20                         0, 0                               0, 0
#> 21   3.767478e-07, 3.767478e-07         3.767478e-07, 3.767478e-07
#> 22   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 23                         0, 0                               0, 0
#> 24   5.382112e-08, 5.382112e-08         5.382112e-08, 5.382112e-08
#> 25                         0, 0                               0, 0
#> 26                         0, 0                               0, 0
#> 27                         0, 0                               0, 0
#> 28   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 29                         0, 0                               0, 0
#> 30                         0, 0                               0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities            Ecosystem.Health
#> 1                   -2.649185e-01, 1.263065e-06      0.06469253, 0.17227483
#> 2                        -0.3439474, -0.1419764      0.06108397, 0.14559866
#> 3                   -2.785162e-01, 2.126505e-06      0.08060473, 0.20768978
#> 4                   -3.031966e-01, 3.501569e-06      0.02783340, 0.07845669
#> 5                        -0.3439468, -0.1627196      0.05339747, 0.14519200
#> 6                   -4.509185e-07, 4.509185e-07 -1.650893e-05, 1.650893e-05
#> 7                                          0, 0 -2.326245e-05, 2.326245e-05
#> 8                                          0, 0 -3.672809e-06, 3.672809e-06
#> 9                                          0, 0      0.03741838, 0.12038236
#> 10                     -0.34394685, -0.09747165      0.06506459, 0.12608345
#> 11                       -0.3439454, -0.1823867 -2.289465e-05, 3.765054e-02
#> 12                       -0.3439471, -0.1246364      0.07565469, 0.15926995
#> 13                  -2.504168e-01, 1.783381e-05      0.01310921, 0.04349949
#> 14                     -0.34394690, -0.09747073        0.1754727, 0.3854074
#> 15                       -0.3439467, -0.1419752      0.01306651, 0.11380505
#> 16                 -2.152845e-07, -2.152845e-07 -6.760308e-07, 1.168798e-01
#> 17                  -2.184896e-01, 7.509039e-06 -2.824574e-05, 4.300210e-02
#> 18                                         0, 0 -1.668145e-05, 1.668145e-05
#> 19                  -2.785142e-01, 1.654658e-06      0.03608334, 0.08867611
#> 20                  -9.886287e-07, 9.886287e-07 -1.281902e-05, 1.281902e-05
#> 21                  -2.504168e-01, 4.355196e-06      0.00397327, 0.03586478
#> 22                       -0.3439477, -0.1823909      0.01471456, 0.12700531
#> 23                                         0, 0      0.09154776, 0.17251847
#> 24                  -3.031964e-01, 1.042238e-06      0.05405402, 0.10574555
#> 25                                         0, 0 -8.449817e-06, 8.449817e-06
#> 26                                         0, 0                        0, 0
#> 27                                         0, 0 -2.136079e-05, 2.136079e-05
#> 28                       -0.3439469, -0.1627198        0.1111561, 0.2427314
#> 29                                         0, 0 -1.648369e-05, 1.648369e-05
#> 30                  -8.650037e-07, 8.650037e-07 -1.613378e-05, 1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                  4.171136e-07, 4.171136e-07      -0.32787900, -0.04609143
#> 2                  4.238413e-07, 4.238413e-07      -0.21367455, -0.09485554
#> 3                    1.70882e-06, 1.70882e-06      -0.37253859, -0.09629834
#> 4                -1.076422e-07, -1.076422e-07      -0.13685759, -0.02269413
#> 5                  4.036584e-07, 4.036584e-07      -0.22074222, -0.08687954
#> 6                                        0, 0   -2.103436e-06, 2.103436e-06
#> 7                                        0, 0   -6.586473e-06, 6.586473e-06
#> 8                                        0, 0   -8.743405e-07, 8.743405e-07
#> 9                                        0, 0   -2.504205e-01, 7.038508e-06
#> 10                 2.085568e-07, 2.085568e-07      -0.19786251, -0.06545225
#> 11                 6.458534e-07, 6.458534e-07   -1.260312e-01, 1.466273e-05
#> 12                 2.085568e-07, 2.085568e-07        -0.2076103, -0.1338848
#> 13                 -8.57774e-07, -8.57774e-07   -8.748446e-02, 4.087751e-05
#> 14                 1.695365e-06, 1.695365e-06      -0.19785836, -0.07604704
#> 15                 1.614633e-07, 1.614633e-07        -0.2136648, -0.0482797
#> 16               -2.152845e-07, -2.152845e-07   -3.032049e-01, 9.271562e-06
#> 17               -6.458534e-07, -6.458534e-07        -0.1059742, -0.0380653
#> 18                                       0, 0   -8.926425e-07, 8.926425e-07
#> 19                                       0, 0      -0.13273925, -0.04842825
#> 20                                       0, 0   -5.043371e-06, 5.043371e-06
#> 21                -2.395658e-02, 1.746007e-05   -7.999894e-02, 1.066973e-05
#> 22                 8.476826e-07, 8.476826e-07      -0.22729144, -0.06758692
#> 23                                       0, 0        -0.3248824, -0.0496664
#> 24                 5.382112e-08, 5.382112e-08      -0.14333141, -0.07466872
#> 25                                       0, 0     -1.50192e-06, 1.50192e-06
#> 26                                       0, 0   -2.008037e-05, 2.008037e-05
#> 27                                       0, 0   -2.783859e-06, 2.783859e-06
#> 28                 8.476826e-07, 8.476826e-07        -0.4112664, -0.1635199
#> 29                                       0, 0   -5.991399e-06, 5.991399e-06
#> 30                                       0, 0   -3.572937e-06, 3.572937e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966353e-02
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.469253e-02
#> 2                                 -3.439474e-01     6.108397e-02
#> 3                                 -2.785162e-01     8.060473e-02
#> 4                                 -3.031966e-01     2.783340e-02
#> 5                                 -3.439468e-01     5.339747e-02
#> 6                                 -4.509185e-07    -1.650893e-05
#> 7                                  0.000000e+00    -2.326245e-05
#> 8                                  0.000000e+00    -3.672809e-06
#> 9                                  0.000000e+00     3.741838e-02
#> 10                                -3.439468e-01     6.506459e-02
#> 11                                -3.439454e-01    -2.289465e-05
#> 12                                -3.439471e-01     7.565469e-02
#> 13                                -2.504168e-01     1.310921e-02
#> 14                                -3.439469e-01     1.754727e-01
#> 15                                -3.439467e-01     1.306651e-02
#> 16                                -2.152845e-07    -6.760308e-07
#> 17                                -2.184896e-01    -2.824574e-05
#> 18                                 0.000000e+00    -1.668145e-05
#> 19                                -2.785142e-01     3.608334e-02
#> 20                                -9.886287e-07    -1.281902e-05
#> 21                                -2.504168e-01     3.973270e-03
#> 22                                -3.439477e-01     1.471456e-02
#> 23                                 0.000000e+00     9.154776e-02
#> 24                                -3.031964e-01     5.405402e-02
#> 25                                 0.000000e+00    -8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.136079e-05
#> 28                                -3.439469e-01     1.111561e-01
#> 29                                 0.000000e+00    -1.648369e-05
#> 30                                -8.650037e-07    -1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.278790e-01
#> 2                                4.238413e-07                 -2.136746e-01
#> 3                                1.708820e-06                 -3.725386e-01
#> 4                               -1.076422e-07                 -1.368576e-01
#> 5                                4.036584e-07                 -2.207422e-01
#> 6                                0.000000e+00                 -2.103436e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                                0.000000e+00                 -2.504205e-01
#> 10                               2.085568e-07                 -1.978625e-01
#> 11                               6.458534e-07                 -1.260312e-01
#> 12                               2.085568e-07                 -2.076103e-01
#> 13                              -8.577740e-07                 -8.748446e-02
#> 14                               1.695365e-06                 -1.978584e-01
#> 15                               1.614633e-07                 -2.136648e-01
#> 16                              -2.152845e-07                 -3.032049e-01
#> 17                              -6.458534e-07                 -1.059742e-01
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.327392e-01
#> 20                               0.000000e+00                 -5.043371e-06
#> 21                              -2.395658e-02                 -7.999894e-02
#> 22                               8.476826e-07                 -2.272914e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               5.382112e-08                 -1.433314e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.112664e-01
#> 29                               0.000000e+00                 -5.991399e-06
#> 30                               0.000000e+00                 -3.572937e-06
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.263065e-06     1.722748e-01
#> 2                                 -1.419764e-01     1.455987e-01
#> 3                                  2.126505e-06     2.076898e-01
#> 4                                  3.501569e-06     7.845669e-02
#> 5                                 -1.627196e-01     1.451920e-01
#> 6                                  4.509185e-07     1.650893e-05
#> 7                                  0.000000e+00     2.326245e-05
#> 8                                  0.000000e+00     3.672809e-06
#> 9                                  0.000000e+00     1.203824e-01
#> 10                                -9.747165e-02     1.260835e-01
#> 11                                -1.823867e-01     3.765054e-02
#> 12                                -1.246364e-01     1.592699e-01
#> 13                                 1.783381e-05     4.349949e-02
#> 14                                -9.747073e-02     3.854074e-01
#> 15                                -1.419752e-01     1.138050e-01
#> 16                                -2.152845e-07     1.168798e-01
#> 17                                 7.509039e-06     4.300210e-02
#> 18                                 0.000000e+00     1.668145e-05
#> 19                                 1.654658e-06     8.867611e-02
#> 20                                 9.886287e-07     1.281902e-05
#> 21                                 4.355196e-06     3.586478e-02
#> 22                                -1.823909e-01     1.270053e-01
#> 23                                 0.000000e+00     1.725185e-01
#> 24                                 1.042238e-06     1.057456e-01
#> 25                                 0.000000e+00     8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.136079e-05
#> 28                                -1.627198e-01     2.427314e-01
#> 29                                 0.000000e+00     1.648369e-05
#> 30                                 8.650037e-07     1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.609143e-02
#> 2                                4.238413e-07                 -9.485554e-02
#> 3                                1.708820e-06                 -9.629834e-02
#> 4                               -1.076422e-07                 -2.269413e-02
#> 5                                4.036584e-07                 -8.687954e-02
#> 6                                0.000000e+00                  2.103436e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                                0.000000e+00                  7.038508e-06
#> 10                               2.085568e-07                 -6.545225e-02
#> 11                               6.458534e-07                  1.466273e-05
#> 12                               2.085568e-07                 -1.338848e-01
#> 13                              -8.577740e-07                  4.087751e-05
#> 14                               1.695365e-06                 -7.604704e-02
#> 15                               1.614633e-07                 -4.827970e-02
#> 16                              -2.152845e-07                  9.271562e-06
#> 17                              -6.458534e-07                 -3.806530e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.842825e-02
#> 20                               0.000000e+00                  5.043371e-06
#> 21                               1.746007e-05                  1.066973e-05
#> 22                               8.476826e-07                 -6.758692e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               5.382112e-08                 -7.466872e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.635199e-01
#> 29                               0.000000e+00                  5.991399e-06
#> 30                               0.000000e+00                  3.572937e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp         lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.0000000000
#> Public.Education.Programs                     0.0083289587  0.0016667646
#> Salts.Added.during.Water.Treatment           -0.0001386996 -0.0002498283
#> Salts.Added.by.Winter.Maintenance.Activities -0.1292224889 -0.2124023926
#> Ecosystem.Health                              0.0725105589  0.0326894180
#> Public.Awareness.of.Reservoir.Salinization   -0.0011484375 -0.0022974759
#> Salinization.of.the.Reservoir                -0.1148925537 -0.1856959736
#>                                                      upper
#> Guidance.Docs.for.Salt.Management             1.000000e+00
#> Public.Education.Programs                     1.499115e-02
#> Salts.Added.during.Water.Treatment           -2.757085e-05
#> Salts.Added.by.Winter.Maintenance.Activities -4.604259e-02
#> Ecosystem.Health                              1.123317e-01
#> Public.Awareness.of.Reservoir.Salinization    6.008910e-07
#> Salinization.of.the.Reservoir                -4.408913e-02
#> 
#> $mc_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1   mc_adj_matrix_1                                 1             -1.076422e-07
#> 2   mc_adj_matrix_2                                 1              1.695365e-06
#> 3   mc_adj_matrix_3                                 1              0.000000e+00
#> 4   mc_adj_matrix_4                                 1             -2.152845e-07
#> 5   mc_adj_matrix_5                                 1              0.000000e+00
#> 6   mc_adj_matrix_6                                 1              4.171136e-07
#> 7   mc_adj_matrix_7                                 1              0.000000e+00
#> 8   mc_adj_matrix_8                                 1              0.000000e+00
#> 9   mc_adj_matrix_9                                 1              4.709348e-08
#> 10 mc_adj_matrix_10                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                       -1.076422e-07
#> 2                        1.695365e-06
#> 3                        0.000000e+00
#> 4                       -2.152845e-07
#> 5                        0.000000e+00
#> 6                        4.171136e-07
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        4.709348e-08
#> 10                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                    -0.1555112       0.04660930
#> 2                                    -0.2234106       0.16788785
#> 3                                     0.0000000       0.00000000
#> 4                                    -0.1962732       0.02842436
#> 5                                     0.0000000       0.00000000
#> 6                                    -0.2937528       0.04528439
#> 7                                     0.0000000       0.00000000
#> 8                                     0.0000000       0.00000000
#> 9                                    -0.2400662       0.07968242
#> 10                                    0.0000000       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                               -1.076422e-07                   -0.06626948
#> 2                                1.695365e-06                   -0.30097131
#> 3                                0.000000e+00                    0.00000000
#> 4                               -2.152845e-07                   -0.05247371
#> 5                                0.000000e+00                    0.00000000
#> 6                                4.171136e-07                   -0.08696560
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                4.709348e-08                   -0.09647255
#> 10                               0.000000e+00                    0.00000000
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   2.594851e-07  2.001473e-08
#> 3           Salts.Added.during.Water.Treatment   2.763042e-07  4.899403e-08
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.137757e-01 -1.928427e-01
#> 5                             Ecosystem.Health   4.580366e-02  2.116381e-02
#> 6   Public.Awareness.of.Reservoir.Salinization   1.604542e-07 -6.354256e-08
#> 7                Salinization.of.the.Reservoir  -7.177439e-02 -1.178616e-01
#>        0.975_CI           min 0.25_quantile      median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00    1.00000000  1.00000000  1.000000e+00
#> 2  5.229899e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 3  5.383625e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 4 -5.521534e-02 -2.937528e-01   -0.21662623 -0.07775561  0.000000e+00
#> 5  7.014231e-02  0.000000e+00    0.00000000  0.01421218  4.627808e-02
#> 6  5.790984e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 7 -3.269917e-02 -3.009713e-01   -0.08179157 -0.02623685  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 1.695365e-06
#> 3 1.695365e-06
#> 4 0.000000e+00
#> 5 1.678879e-01
#> 6 1.695365e-06
#> 7 0.000000e+00
#> 
get_fcmconfr_inferences(ex_ivfn_fcmconfr)
#> $individual_inferences
#> $individual_inferences$ivfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                              1, 1
#> 2      adj_matrix_2                              1, 1
#> 3      adj_matrix_3                              1, 1
#> 4      adj_matrix_4                              1, 1
#> 5      adj_matrix_5                              1, 1
#> 6      adj_matrix_6                              1, 1
#> 7      adj_matrix_7                              1, 1
#> 8      adj_matrix_8                              1, 1
#> 9      adj_matrix_9                              1, 1
#> 10    adj_matrix_10                              1, 1
#> 11    adj_matrix_11                              1, 1
#> 12    adj_matrix_12                              1, 1
#> 13    adj_matrix_13                              1, 1
#> 14    adj_matrix_14                              1, 1
#> 15    adj_matrix_15                              1, 1
#> 16    adj_matrix_16                              1, 1
#> 17    adj_matrix_17                              1, 1
#> 18    adj_matrix_18                              1, 1
#> 19    adj_matrix_19                              1, 1
#> 20    adj_matrix_20                              1, 1
#> 21    adj_matrix_21                              1, 1
#> 22    adj_matrix_22                              1, 1
#> 23    adj_matrix_23                              1, 1
#> 24    adj_matrix_24                              1, 1
#> 25    adj_matrix_25                              1, 1
#> 26    adj_matrix_26                              1, 1
#> 27    adj_matrix_27                              1, 1
#> 28    adj_matrix_28                              1, 1
#> 29    adj_matrix_29                              1, 1
#> 30    adj_matrix_30                              1, 1
#>       Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1    4.171136e-07, 4.171136e-07         4.171136e-07, 4.171136e-07
#> 2    4.238413e-07, 4.238413e-07       -7.287071e-06, -2.716813e-07
#> 3      1.70882e-06, 1.70882e-06           1.70882e-06, 1.70882e-06
#> 4  -1.076422e-07, -1.076422e-07       -1.076422e-07, -1.076422e-07
#> 5    4.036584e-07, 4.036584e-07         4.036584e-07, 4.036584e-07
#> 6                          0, 0                               0, 0
#> 7                          0, 0                               0, 0
#> 8                          0, 0                               0, 0
#> 9                          0, 0                               0, 0
#> 10   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 11   6.458534e-07, 6.458534e-07         6.458534e-07, 6.458534e-07
#> 12   2.085568e-07, 2.085568e-07         2.085568e-07, 2.085568e-07
#> 13   -8.57774e-07, -8.57774e-07         -8.57774e-07, -8.57774e-07
#> 14   1.695365e-06, 1.695365e-06         1.695365e-06, 1.695365e-06
#> 15   1.614633e-07, 1.614633e-07         1.614633e-07, 1.614633e-07
#> 16       0.04966353, 0.32487741       -2.152845e-07, -2.152845e-07
#> 17 -6.458534e-07, -6.458534e-07       -6.458534e-07, -6.458534e-07
#> 18                         0, 0                               0, 0
#> 19                         0, 0                               0, 0
#> 20                         0, 0                               0, 0
#> 21   3.767478e-07, 3.767478e-07         3.767478e-07, 3.767478e-07
#> 22   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 23                         0, 0                               0, 0
#> 24   5.382112e-08, 5.382112e-08         5.382112e-08, 5.382112e-08
#> 25                         0, 0                               0, 0
#> 26                         0, 0                               0, 0
#> 27                         0, 0                               0, 0
#> 28   8.476826e-07, 8.476826e-07         8.476826e-07, 8.476826e-07
#> 29                         0, 0                               0, 0
#> 30                         0, 0                               0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities            Ecosystem.Health
#> 1                   -2.649185e-01, 1.263065e-06      0.06469253, 0.17227483
#> 2                        -0.3439474, -0.1419764      0.06108397, 0.14559866
#> 3                   -2.785162e-01, 2.126505e-06      0.08060473, 0.20768978
#> 4                   -3.031966e-01, 3.501569e-06      0.02783340, 0.07845669
#> 5                        -0.3439468, -0.1627196      0.05339747, 0.14519200
#> 6                   -4.509185e-07, 4.509185e-07 -1.650893e-05, 1.650893e-05
#> 7                                          0, 0 -2.326245e-05, 2.326245e-05
#> 8                                          0, 0 -3.672809e-06, 3.672809e-06
#> 9                                          0, 0      0.03741838, 0.12038236
#> 10                     -0.34394685, -0.09747165      0.06506459, 0.12608345
#> 11                       -0.3439454, -0.1823867 -2.289465e-05, 3.765054e-02
#> 12                       -0.3439471, -0.1246364      0.07565469, 0.15926995
#> 13                  -2.504168e-01, 1.783381e-05      0.01310921, 0.04349949
#> 14                     -0.34394690, -0.09747073        0.1754727, 0.3854074
#> 15                       -0.3439467, -0.1419752      0.01306651, 0.11380505
#> 16                 -2.152845e-07, -2.152845e-07 -6.760308e-07, 1.168798e-01
#> 17                  -2.184896e-01, 7.509039e-06 -2.824574e-05, 4.300210e-02
#> 18                                         0, 0 -1.668145e-05, 1.668145e-05
#> 19                  -2.785142e-01, 1.654658e-06      0.03608334, 0.08867611
#> 20                  -9.886287e-07, 9.886287e-07 -1.281902e-05, 1.281902e-05
#> 21                  -2.504168e-01, 4.355196e-06      0.00397327, 0.03586478
#> 22                       -0.3439477, -0.1823909      0.01471456, 0.12700531
#> 23                                         0, 0      0.09154776, 0.17251847
#> 24                  -3.031964e-01, 1.042238e-06      0.05405402, 0.10574555
#> 25                                         0, 0 -8.449817e-06, 8.449817e-06
#> 26                                         0, 0                        0, 0
#> 27                                         0, 0 -2.136079e-05, 2.136079e-05
#> 28                       -0.3439469, -0.1627198        0.1111561, 0.2427314
#> 29                                         0, 0 -1.648369e-05, 1.648369e-05
#> 30                  -8.650037e-07, 8.650037e-07 -1.613378e-05, 1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                  4.171136e-07, 4.171136e-07      -0.32787900, -0.04609143
#> 2                  4.238413e-07, 4.238413e-07      -0.21367455, -0.09485554
#> 3                    1.70882e-06, 1.70882e-06      -0.37253859, -0.09629834
#> 4                -1.076422e-07, -1.076422e-07      -0.13685759, -0.02269413
#> 5                  4.036584e-07, 4.036584e-07      -0.22074222, -0.08687954
#> 6                                        0, 0   -2.103436e-06, 2.103436e-06
#> 7                                        0, 0   -6.586473e-06, 6.586473e-06
#> 8                                        0, 0   -8.743405e-07, 8.743405e-07
#> 9                                        0, 0   -2.504205e-01, 7.038508e-06
#> 10                 2.085568e-07, 2.085568e-07      -0.19786251, -0.06545225
#> 11                 6.458534e-07, 6.458534e-07   -1.260312e-01, 1.466273e-05
#> 12                 2.085568e-07, 2.085568e-07        -0.2076103, -0.1338848
#> 13                 -8.57774e-07, -8.57774e-07   -8.748446e-02, 4.087751e-05
#> 14                 1.695365e-06, 1.695365e-06      -0.19785836, -0.07604704
#> 15                 1.614633e-07, 1.614633e-07        -0.2136648, -0.0482797
#> 16               -2.152845e-07, -2.152845e-07   -3.032049e-01, 9.271562e-06
#> 17               -6.458534e-07, -6.458534e-07        -0.1059742, -0.0380653
#> 18                                       0, 0   -8.926425e-07, 8.926425e-07
#> 19                                       0, 0      -0.13273925, -0.04842825
#> 20                                       0, 0   -5.043371e-06, 5.043371e-06
#> 21                -2.395658e-02, 1.746007e-05   -7.999894e-02, 1.066973e-05
#> 22                 8.476826e-07, 8.476826e-07      -0.22729144, -0.06758692
#> 23                                       0, 0        -0.3248824, -0.0496664
#> 24                 5.382112e-08, 5.382112e-08      -0.14333141, -0.07466872
#> 25                                       0, 0     -1.50192e-06, 1.50192e-06
#> 26                                       0, 0   -2.008037e-05, 2.008037e-05
#> 27                                       0, 0   -2.783859e-06, 2.783859e-06
#> 28                 8.476826e-07, 8.476826e-07        -0.4112664, -0.1635199
#> 29                                       0, 0   -5.991399e-06, 5.991399e-06
#> 30                                       0, 0   -3.572937e-06, 3.572937e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966353e-02
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.469253e-02
#> 2                                 -3.439474e-01     6.108397e-02
#> 3                                 -2.785162e-01     8.060473e-02
#> 4                                 -3.031966e-01     2.783340e-02
#> 5                                 -3.439468e-01     5.339747e-02
#> 6                                 -4.509185e-07    -1.650893e-05
#> 7                                  0.000000e+00    -2.326245e-05
#> 8                                  0.000000e+00    -3.672809e-06
#> 9                                  0.000000e+00     3.741838e-02
#> 10                                -3.439468e-01     6.506459e-02
#> 11                                -3.439454e-01    -2.289465e-05
#> 12                                -3.439471e-01     7.565469e-02
#> 13                                -2.504168e-01     1.310921e-02
#> 14                                -3.439469e-01     1.754727e-01
#> 15                                -3.439467e-01     1.306651e-02
#> 16                                -2.152845e-07    -6.760308e-07
#> 17                                -2.184896e-01    -2.824574e-05
#> 18                                 0.000000e+00    -1.668145e-05
#> 19                                -2.785142e-01     3.608334e-02
#> 20                                -9.886287e-07    -1.281902e-05
#> 21                                -2.504168e-01     3.973270e-03
#> 22                                -3.439477e-01     1.471456e-02
#> 23                                 0.000000e+00     9.154776e-02
#> 24                                -3.031964e-01     5.405402e-02
#> 25                                 0.000000e+00    -8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.136079e-05
#> 28                                -3.439469e-01     1.111561e-01
#> 29                                 0.000000e+00    -1.648369e-05
#> 30                                -8.650037e-07    -1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.278790e-01
#> 2                                4.238413e-07                 -2.136746e-01
#> 3                                1.708820e-06                 -3.725386e-01
#> 4                               -1.076422e-07                 -1.368576e-01
#> 5                                4.036584e-07                 -2.207422e-01
#> 6                                0.000000e+00                 -2.103436e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                                0.000000e+00                 -2.504205e-01
#> 10                               2.085568e-07                 -1.978625e-01
#> 11                               6.458534e-07                 -1.260312e-01
#> 12                               2.085568e-07                 -2.076103e-01
#> 13                              -8.577740e-07                 -8.748446e-02
#> 14                               1.695365e-06                 -1.978584e-01
#> 15                               1.614633e-07                 -2.136648e-01
#> 16                              -2.152845e-07                 -3.032049e-01
#> 17                              -6.458534e-07                 -1.059742e-01
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.327392e-01
#> 20                               0.000000e+00                 -5.043371e-06
#> 21                              -2.395658e-02                 -7.999894e-02
#> 22                               8.476826e-07                 -2.272914e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               5.382112e-08                 -1.433314e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.112664e-01
#> 29                               0.000000e+00                 -5.991399e-06
#> 30                               0.000000e+00                 -3.572937e-06
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1             -1.076422e-07
#> 5      adj_matrix_5                                 1              4.036584e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1              0.000000e+00
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              6.458534e-07
#> 12    adj_matrix_12                                 1              2.085568e-07
#> 13    adj_matrix_13                                 1             -8.577740e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -6.458534e-07
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              8.476826e-07
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              5.382112e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                       -1.076422e-07
#> 5                        4.036584e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        0.000000e+00
#> 10                       2.085568e-07
#> 11                       6.458534e-07
#> 12                       2.085568e-07
#> 13                      -8.577740e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                      -2.152845e-07
#> 17                      -6.458534e-07
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       8.476826e-07
#> 23                       0.000000e+00
#> 24                       5.382112e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.263065e-06     1.722748e-01
#> 2                                 -1.419764e-01     1.455987e-01
#> 3                                  2.126505e-06     2.076898e-01
#> 4                                  3.501569e-06     7.845669e-02
#> 5                                 -1.627196e-01     1.451920e-01
#> 6                                  4.509185e-07     1.650893e-05
#> 7                                  0.000000e+00     2.326245e-05
#> 8                                  0.000000e+00     3.672809e-06
#> 9                                  0.000000e+00     1.203824e-01
#> 10                                -9.747165e-02     1.260835e-01
#> 11                                -1.823867e-01     3.765054e-02
#> 12                                -1.246364e-01     1.592699e-01
#> 13                                 1.783381e-05     4.349949e-02
#> 14                                -9.747073e-02     3.854074e-01
#> 15                                -1.419752e-01     1.138050e-01
#> 16                                -2.152845e-07     1.168798e-01
#> 17                                 7.509039e-06     4.300210e-02
#> 18                                 0.000000e+00     1.668145e-05
#> 19                                 1.654658e-06     8.867611e-02
#> 20                                 9.886287e-07     1.281902e-05
#> 21                                 4.355196e-06     3.586478e-02
#> 22                                -1.823909e-01     1.270053e-01
#> 23                                 0.000000e+00     1.725185e-01
#> 24                                 1.042238e-06     1.057456e-01
#> 25                                 0.000000e+00     8.449817e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.136079e-05
#> 28                                -1.627198e-01     2.427314e-01
#> 29                                 0.000000e+00     1.648369e-05
#> 30                                 8.650037e-07     1.613378e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.609143e-02
#> 2                                4.238413e-07                 -9.485554e-02
#> 3                                1.708820e-06                 -9.629834e-02
#> 4                               -1.076422e-07                 -2.269413e-02
#> 5                                4.036584e-07                 -8.687954e-02
#> 6                                0.000000e+00                  2.103436e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                                0.000000e+00                  7.038508e-06
#> 10                               2.085568e-07                 -6.545225e-02
#> 11                               6.458534e-07                  1.466273e-05
#> 12                               2.085568e-07                 -1.338848e-01
#> 13                              -8.577740e-07                  4.087751e-05
#> 14                               1.695365e-06                 -7.604704e-02
#> 15                               1.614633e-07                 -4.827970e-02
#> 16                              -2.152845e-07                  9.271562e-06
#> 17                              -6.458534e-07                 -3.806530e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.842825e-02
#> 20                               0.000000e+00                  5.043371e-06
#> 21                               1.746007e-05                  1.066973e-05
#> 22                               8.476826e-07                 -6.758692e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               5.382112e-08                 -7.466872e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.635199e-01
#> 29                               0.000000e+00                  5.991399e-06
#> 30                               0.000000e+00                  3.572937e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp         lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.0000000000
#> Public.Education.Programs                     0.0083289587  0.0016667646
#> Salts.Added.during.Water.Treatment           -0.0001386996 -0.0002498283
#> Salts.Added.by.Winter.Maintenance.Activities -0.1292224889 -0.2124023926
#> Ecosystem.Health                              0.0725105589  0.0326894180
#> Public.Awareness.of.Reservoir.Salinization   -0.0011484375 -0.0022974759
#> Salinization.of.the.Reservoir                -0.1148925537 -0.1856959736
#>                                                      upper
#> Guidance.Docs.for.Salt.Management             1.000000e+00
#> Public.Education.Programs                     1.499115e-02
#> Salts.Added.during.Water.Treatment           -2.757085e-05
#> Salts.Added.by.Winter.Maintenance.Activities -4.604259e-02
#> Ecosystem.Health                              1.123317e-01
#> Public.Awareness.of.Reservoir.Salinization    6.008910e-07
#> Salinization.of.the.Reservoir                -4.408913e-02
#> 
#> $mc_inferences
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1   mc_adj_matrix_1                                 1             -1.076422e-07
#> 2   mc_adj_matrix_2                                 1              1.695365e-06
#> 3   mc_adj_matrix_3                                 1              0.000000e+00
#> 4   mc_adj_matrix_4                                 1             -2.152845e-07
#> 5   mc_adj_matrix_5                                 1              0.000000e+00
#> 6   mc_adj_matrix_6                                 1              4.171136e-07
#> 7   mc_adj_matrix_7                                 1              0.000000e+00
#> 8   mc_adj_matrix_8                                 1              0.000000e+00
#> 9   mc_adj_matrix_9                                 1              4.709348e-08
#> 10 mc_adj_matrix_10                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                       -1.076422e-07
#> 2                        1.695365e-06
#> 3                        0.000000e+00
#> 4                       -2.152845e-07
#> 5                        0.000000e+00
#> 6                        4.171136e-07
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                        4.709348e-08
#> 10                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                    -0.1555112       0.04660930
#> 2                                    -0.2234106       0.16788785
#> 3                                     0.0000000       0.00000000
#> 4                                    -0.1962732       0.02842436
#> 5                                     0.0000000       0.00000000
#> 6                                    -0.2937528       0.04528439
#> 7                                     0.0000000       0.00000000
#> 8                                     0.0000000       0.00000000
#> 9                                    -0.2400662       0.07968242
#> 10                                    0.0000000       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                               -1.076422e-07                   -0.06626948
#> 2                                1.695365e-06                   -0.30097131
#> 3                                0.000000e+00                    0.00000000
#> 4                               -2.152845e-07                   -0.05247371
#> 5                                0.000000e+00                    0.00000000
#> 6                                4.171136e-07                   -0.08696560
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                                4.709348e-08                   -0.09647255
#> 10                               0.000000e+00                    0.00000000
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   2.594851e-07  2.001473e-08
#> 3           Salts.Added.during.Water.Treatment   2.763042e-07  4.899403e-08
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.137757e-01 -1.928427e-01
#> 5                             Ecosystem.Health   4.580366e-02  2.116381e-02
#> 6   Public.Awareness.of.Reservoir.Salinization   1.604542e-07 -6.354256e-08
#> 7                Salinization.of.the.Reservoir  -7.177439e-02 -1.178616e-01
#>        0.975_CI           min 0.25_quantile      median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00    1.00000000  1.00000000  1.000000e+00
#> 2  5.229899e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 3  5.383625e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 4 -5.521534e-02 -2.937528e-01   -0.21662623 -0.07775561  0.000000e+00
#> 5  7.014231e-02  0.000000e+00    0.00000000  0.01421218  4.627808e-02
#> 6  5.790984e-07 -2.152845e-07    0.00000000  0.00000000  3.532011e-08
#> 7 -3.269917e-02 -3.009713e-01   -0.08179157 -0.02623685  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 1.695365e-06
#> 3 1.695365e-06
#> 4 0.000000e+00
#> 5 1.678879e-01
#> 6 1.695365e-06
#> 7 0.000000e+00
#> 


ex_tfn_fcmconfr <- fcmconfr(
  adj_matrices = sample_fcms$simple_fcms$tfn_fcms,
  # adj_matrices = group_tfn_fcms,
  # Aggregation and Monte Carlo Sampling
  agg_function = 'mean',
  num_mc_fcms = 1000L,
  # Simulation
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = 'rescale',
  squashing = 'sigmoid',
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 1000L,
  min_error = 1e-05,
  # Inference Estimation (bootstrap)
  ci_centering_function = "mean",
  confidence_interval = 0.95,
  num_ci_bootstraps = 1000L,
  # Runtime Options
  show_progress = TRUE,
  parallel = FALSE,
  n_cores = 1L,
  # Additional Options
  run_agg_calcs = TRUE,
  run_mc_calcs = TRUE,
  run_ci_calcs = TRUE,
  include_zeroes_in_sampling = TRUE,
  include_sims_in_output = TRUE
)
#> [1] Simulating Input FCMs
#> 
#> [1] Running Simulations
#> [1] Sampling from column vectors
#> Sampling from column vectors[1] Constructing monte carlo fcms from samples
#> Constructing monte carlo fcms from samples
#> [1] Running Simulations
#> [1] Performing bootstrap simulations
#> [1] Done
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual"))
#> $individual_inferences
#> $individual_inferences$tfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                           1, 1, 1
#> 2      adj_matrix_2                           1, 1, 1
#> 3      adj_matrix_3                           1, 1, 1
#> 4      adj_matrix_4                           1, 1, 1
#> 5      adj_matrix_5                           1, 1, 1
#> 6      adj_matrix_6                           1, 1, 1
#> 7      adj_matrix_7                           1, 1, 1
#> 8      adj_matrix_8                           1, 1, 1
#> 9      adj_matrix_9                           1, 1, 1
#> 10    adj_matrix_10                           1, 1, 1
#> 11    adj_matrix_11                           1, 1, 1
#> 12    adj_matrix_12                           1, 1, 1
#> 13    adj_matrix_13                           1, 1, 1
#> 14    adj_matrix_14                           1, 1, 1
#> 15    adj_matrix_15                           1, 1, 1
#> 16    adj_matrix_16                           1, 1, 1
#> 17    adj_matrix_17                           1, 1, 1
#> 18    adj_matrix_18                           1, 1, 1
#> 19    adj_matrix_19                           1, 1, 1
#> 20    adj_matrix_20                           1, 1, 1
#> 21    adj_matrix_21                           1, 1, 1
#> 22    adj_matrix_22                           1, 1, 1
#> 23    adj_matrix_23                           1, 1, 1
#> 24    adj_matrix_24                           1, 1, 1
#> 25    adj_matrix_25                           1, 1, 1
#> 26    adj_matrix_26                           1, 1, 1
#> 27    adj_matrix_27                           1, 1, 1
#> 28    adj_matrix_28                           1, 1, 1
#> 29    adj_matrix_29                           1, 1, 1
#> 30    adj_matrix_30                           1, 1, 1
#>                      Public.Education.Programs
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16          0.04966368, 0.21848409, 0.32487741
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>             Salts.Added.during.Water.Treatment
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2  -7.287071e-06, -3.781633e-06, -2.716813e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities
#> 1    -2.649185e-01, -1.202008e-01, 1.139210e-06
#> 2            -0.3439474, -0.2785144, -0.1419764
#> 3    -2.785162e-01, -1.419780e-01, 2.126505e-06
#> 4    -3.031965e-01, -1.823903e-01, 1.890719e-06
#> 5            -0.3439469, -0.2912555, -0.1627199
#> 6     -4.509185e-07, 0.000000e+00, 4.509185e-07
#> 7                                       0, 0, 0
#> 8                                       0, 0, 0
#> 9   -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10        -0.34394686, -0.25041551, -0.09747171
#> 11           -0.3439440, -0.3031899, -0.1823828
#> 12           -0.3439472, -0.2677088, -0.1246366
#> 13   -2.504161e-01, -9.747187e-02, 2.606899e-06
#> 14        -0.34394690, -0.25041556, -0.09747073
#> 15           -0.3439467, -0.2785133, -0.1419752
#> 16                                      0, 0, 0
#> 17   -2.184904e-01, -4.966970e-02, 1.394166e-05
#> 18                                      0, 0, 0
#> 19   -2.785142e-01, -1.419758e-01, 1.654658e-06
#> 20    -9.886287e-07, 0.000000e+00, 9.886287e-07
#> 21   -2.504168e-01, -9.747226e-02, 4.176917e-06
#> 22           -0.3439486, -0.3031974, -0.1823913
#> 23                                      0, 0, 0
#> 24   -3.031964e-01, -1.823909e-01, 5.964684e-07
#> 25                                      0, 0, 0
#> 26                                      0, 0, 0
#> 27                                      0, 0, 0
#> 28           -0.3439469, -0.2912555, -0.1627198
#> 29                                      0, 0, 0
#> 30    -8.650037e-07, 0.000000e+00, 8.650037e-07
#>                             Ecosystem.Health
#> 1         0.06562469, 0.13535978, 0.17443415
#> 2         0.06670194, 0.12905046, 0.15766445
#> 3         0.08583128, 0.17279319, 0.21861527
#> 4         0.02984654, 0.06344861, 0.08392516
#> 5         0.05803894, 0.12066305, 0.15650258
#> 6  -1.823495e-05, 0.000000e+00, 1.823495e-05
#> 7  -2.339399e-05, 0.000000e+00, 2.339399e-05
#> 8  -3.734027e-06, 0.000000e+00, 3.734027e-06
#> 9         0.03467809, 0.07980185, 0.11209770
#> 10        0.06987573, 0.12237908, 0.13478990
#> 11 -0.0000315184, 0.0106128025, 0.0317934762
#> 12        0.08394626, 0.15173773, 0.17475462
#> 13        0.01053170, 0.02454208, 0.03500210
#> 14           0.1781593, 0.3264510, 0.3882986
#> 15        0.01385923, 0.06857068, 0.12021737
#> 16 -9.634720e-07, 6.403258e-02, 1.241829e-01
#> 17 -2.132187e-05, 1.232420e-02, 3.687688e-02
#> 18 -1.785633e-05, 0.000000e+00, 1.785633e-05
#> 19        0.03776046, 0.07470845, 0.09264320
#> 20 -1.313644e-05, 0.000000e+00, 1.313644e-05
#> 21     0.003418647, 0.017170139, 0.030870109
#> 22        0.01581755, 0.07796207, 0.13569403
#> 23        0.09639699, 0.16507281, 0.18061849
#> 24        0.06100563, 0.10751282, 0.11864309
#> 25 -8.614831e-06, 0.000000e+00, 8.614831e-06
#> 26                                   0, 0, 0
#> 27 -2.207469e-05, 0.000000e+00, 2.207469e-05
#> 28           0.1179967, 0.2151298, 0.2542002
#> 29 -2.906392e-05, 0.000000e+00, 2.906392e-05
#> 30 -1.548227e-05, 0.000000e+00, 1.548227e-05
#>     Public.Awareness.of.Reservoir.Salinization
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21  -2.060992e-02, -6.872083e-03, 1.392007e-05
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>                 Salinization.of.the.Reservoir
#> 1       -0.32624208, -0.19827639, -0.04468532
#> 2       -0.22174705, -0.18532772, -0.09925181
#> 3       -0.37279803, -0.28119287, -0.09659356
#> 4       -0.14517113, -0.08721721, -0.02423273
#> 5       -0.22912750, -0.18199123, -0.09103424
#> 6      -2.16743e-06, 0.00000e+00, 2.16743e-06
#> 7   -6.586473e-06, 0.000000e+00, 6.586473e-06
#> 8   -8.743405e-07, 0.000000e+00, 8.743405e-07
#> 9  -2.504205e-01, -9.747409e-02, 4.872594e-06
#> 10      -0.20499898, -0.15158721, -0.06831878
#> 11 -1.318708e-01, -2.758877e-02, 2.662699e-05
#> 12         -0.2153682, -0.2153676, -0.1396386
#> 13 -7.988033e-02, -2.548262e-02, 6.068898e-06
#> 14      -0.20499585, -0.16105880, -0.07934998
#> 15      -0.22173773, -0.14442093, -0.05060377
#> 16 -3.032049e-01, -1.823915e-01, 1.338811e-05
#> 17      -0.08755650, -0.06623863, -0.03117925
#> 18  -8.926425e-07, 0.000000e+00, 8.926425e-07
#> 19      -0.13352584, -0.10219718, -0.04873998
#> 20  -5.044662e-06, 0.000000e+00, 5.044662e-06
#> 21 -7.426995e-02, -2.892287e-02, 9.173772e-06
#> 22      -0.23592075, -0.16873413, -0.07092534
#> 23         -0.3248824, -0.2184897, -0.0496664
#> 24         -0.1519497, -0.1382799, -0.0795642
#> 25     -1.50192e-06, 0.00000e+00, 1.50192e-06
#> 26  -2.008037e-05, 0.000000e+00, 2.008037e-05
#> 27  -2.783859e-06, 0.000000e+00, 2.783859e-06
#> 28         -0.4136693, -0.3389161, -0.1665670
#> 29           -1.138e-05, 0.000e+00, 1.138e-05
#> 30  -3.414352e-06, 0.000000e+00, 3.414352e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966368e-02
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.562469e-02
#> 2                                 -3.439474e-01     6.670194e-02
#> 3                                 -2.785162e-01     8.583128e-02
#> 4                                 -3.031965e-01     2.984654e-02
#> 5                                 -3.439469e-01     5.803894e-02
#> 6                                 -4.509185e-07    -1.823495e-05
#> 7                                  0.000000e+00    -2.339399e-05
#> 8                                  0.000000e+00    -3.734027e-06
#> 9                                 -1.076422e-07     3.467809e-02
#> 10                                -3.439469e-01     6.987573e-02
#> 11                                -3.439440e-01    -3.151840e-05
#> 12                                -3.439472e-01     8.394626e-02
#> 13                                -2.504161e-01     1.053170e-02
#> 14                                -3.439469e-01     1.781593e-01
#> 15                                -3.439467e-01     1.385923e-02
#> 16                                 0.000000e+00    -9.634720e-07
#> 17                                -2.184904e-01    -2.132187e-05
#> 18                                 0.000000e+00    -1.785633e-05
#> 19                                -2.785142e-01     3.776046e-02
#> 20                                -9.886287e-07    -1.313644e-05
#> 21                                -2.504168e-01     3.418647e-03
#> 22                                -3.439486e-01     1.581755e-02
#> 23                                 0.000000e+00     9.639699e-02
#> 24                                -3.031964e-01     6.100563e-02
#> 25                                 0.000000e+00    -8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.207469e-05
#> 28                                -3.439469e-01     1.179967e-01
#> 29                                 0.000000e+00    -2.906392e-05
#> 30                                -8.650037e-07    -1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.262421e-01
#> 2                                4.238413e-07                 -2.217470e-01
#> 3                                1.708820e-06                 -3.727980e-01
#> 4                                0.000000e+00                 -1.451711e-01
#> 5                                4.171136e-07                 -2.291275e-01
#> 6                                0.000000e+00                 -2.167430e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                               -1.076422e-07                 -2.504205e-01
#> 10                               2.085568e-07                 -2.049990e-01
#> 11                               4.305689e-07                 -1.318708e-01
#> 12                               2.119206e-07                 -2.153682e-01
#> 13                              -1.009146e-07                 -7.988033e-02
#> 14                               1.695365e-06                 -2.049958e-01
#> 15                               1.614633e-07                 -2.217377e-01
#> 16                               0.000000e+00                 -3.032049e-01
#> 17                              -1.506991e-06                 -8.755650e-02
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.335258e-01
#> 20                               0.000000e+00                 -5.044662e-06
#> 21                              -2.060992e-02                 -7.426995e-02
#> 22                               1.708820e-06                 -2.359207e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               8.073167e-08                 -1.519497e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.136693e-01
#> 29                               0.000000e+00                 -1.138000e-05
#> 30                               0.000000e+00                 -3.414352e-06
#> 
#> $individual_inferences$mode_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -3.781633e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01       0.13535978
#> 2                                 -2.785144e-01       0.12905046
#> 3                                 -1.419780e-01       0.17279319
#> 4                                 -1.823903e-01       0.06344861
#> 5                                 -2.912555e-01       0.12066305
#> 6                                  0.000000e+00       0.00000000
#> 7                                  0.000000e+00       0.00000000
#> 8                                  0.000000e+00       0.00000000
#> 9                                 -1.076422e-07       0.07980185
#> 10                                -2.504155e-01       0.12237908
#> 11                                -3.031899e-01       0.01061280
#> 12                                -2.677088e-01       0.15173773
#> 13                                -9.747187e-02       0.02454208
#> 14                                -2.504156e-01       0.32645102
#> 15                                -2.785133e-01       0.06857068
#> 16                                 0.000000e+00       0.06403258
#> 17                                -4.966970e-02       0.01232420
#> 18                                 0.000000e+00       0.00000000
#> 19                                -1.419758e-01       0.07470845
#> 20                                 0.000000e+00       0.00000000
#> 21                                -9.747226e-02       0.01717014
#> 22                                -3.031974e-01       0.07796207
#> 23                                 0.000000e+00       0.16507281
#> 24                                -1.823909e-01       0.10751282
#> 25                                 0.000000e+00       0.00000000
#> 26                                 0.000000e+00       0.00000000
#> 27                                 0.000000e+00       0.00000000
#> 28                                -2.912555e-01       0.21512975
#> 29                                 0.000000e+00       0.00000000
#> 30                                 0.000000e+00       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                   -0.19827639
#> 2                                4.238413e-07                   -0.18532772
#> 3                                1.708820e-06                   -0.28119287
#> 4                                0.000000e+00                   -0.08721721
#> 5                                4.171136e-07                   -0.18199123
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                               -1.076422e-07                   -0.09747409
#> 10                               2.085568e-07                   -0.15158721
#> 11                               4.305689e-07                   -0.02758877
#> 12                               2.119206e-07                   -0.21536762
#> 13                              -1.009146e-07                   -0.02548262
#> 14                               1.695365e-06                   -0.16105880
#> 15                               1.614633e-07                   -0.14442093
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -1.506991e-06                   -0.06623863
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10219718
#> 20                               0.000000e+00                    0.00000000
#> 21                              -6.872083e-03                   -0.02892287
#> 22                               1.708820e-06                   -0.16873413
#> 23                               0.000000e+00                   -0.21848965
#> 24                               8.073167e-08                   -0.13827989
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               8.476826e-07                   -0.33891614
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.139210e-06     1.744341e-01
#> 2                                 -1.419764e-01     1.576644e-01
#> 3                                  2.126505e-06     2.186153e-01
#> 4                                  1.890719e-06     8.392516e-02
#> 5                                 -1.627199e-01     1.565026e-01
#> 6                                  4.509185e-07     1.823495e-05
#> 7                                  0.000000e+00     2.339399e-05
#> 8                                  0.000000e+00     3.734027e-06
#> 9                                 -1.076422e-07     1.120977e-01
#> 10                                -9.747171e-02     1.347899e-01
#> 11                                -1.823828e-01     3.179348e-02
#> 12                                -1.246366e-01     1.747546e-01
#> 13                                 2.606899e-06     3.500210e-02
#> 14                                -9.747073e-02     3.882986e-01
#> 15                                -1.419752e-01     1.202174e-01
#> 16                                 0.000000e+00     1.241829e-01
#> 17                                 1.394166e-05     3.687688e-02
#> 18                                 0.000000e+00     1.785633e-05
#> 19                                 1.654658e-06     9.264320e-02
#> 20                                 9.886287e-07     1.313644e-05
#> 21                                 4.176917e-06     3.087011e-02
#> 22                                -1.823913e-01     1.356940e-01
#> 23                                 0.000000e+00     1.806185e-01
#> 24                                 5.964684e-07     1.186431e-01
#> 25                                 0.000000e+00     8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.207469e-05
#> 28                                -1.627198e-01     2.542002e-01
#> 29                                 0.000000e+00     2.906392e-05
#> 30                                 8.650037e-07     1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.468532e-02
#> 2                                4.238413e-07                 -9.925181e-02
#> 3                                1.708820e-06                 -9.659356e-02
#> 4                                0.000000e+00                 -2.423273e-02
#> 5                                4.171136e-07                 -9.103424e-02
#> 6                                0.000000e+00                  2.167430e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                               -1.076422e-07                  4.872594e-06
#> 10                               2.085568e-07                 -6.831878e-02
#> 11                               4.305689e-07                  2.662699e-05
#> 12                               2.119206e-07                 -1.396386e-01
#> 13                              -1.009146e-07                  6.068898e-06
#> 14                               1.695365e-06                 -7.934998e-02
#> 15                               1.614633e-07                 -5.060377e-02
#> 16                               0.000000e+00                  1.338811e-05
#> 17                              -1.506991e-06                 -3.117925e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.873998e-02
#> 20                               0.000000e+00                  5.044662e-06
#> 21                               1.392007e-05                  9.173772e-06
#> 22                               1.708820e-06                 -7.092534e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               8.073167e-08                 -7.956420e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.665670e-01
#> 29                               0.000000e+00                  1.138000e-05
#> 30                               0.000000e+00                  3.414352e-06
#> 
#> 
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual", "aggregate"))
#> $individual_inferences
#> $individual_inferences$tfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                           1, 1, 1
#> 2      adj_matrix_2                           1, 1, 1
#> 3      adj_matrix_3                           1, 1, 1
#> 4      adj_matrix_4                           1, 1, 1
#> 5      adj_matrix_5                           1, 1, 1
#> 6      adj_matrix_6                           1, 1, 1
#> 7      adj_matrix_7                           1, 1, 1
#> 8      adj_matrix_8                           1, 1, 1
#> 9      adj_matrix_9                           1, 1, 1
#> 10    adj_matrix_10                           1, 1, 1
#> 11    adj_matrix_11                           1, 1, 1
#> 12    adj_matrix_12                           1, 1, 1
#> 13    adj_matrix_13                           1, 1, 1
#> 14    adj_matrix_14                           1, 1, 1
#> 15    adj_matrix_15                           1, 1, 1
#> 16    adj_matrix_16                           1, 1, 1
#> 17    adj_matrix_17                           1, 1, 1
#> 18    adj_matrix_18                           1, 1, 1
#> 19    adj_matrix_19                           1, 1, 1
#> 20    adj_matrix_20                           1, 1, 1
#> 21    adj_matrix_21                           1, 1, 1
#> 22    adj_matrix_22                           1, 1, 1
#> 23    adj_matrix_23                           1, 1, 1
#> 24    adj_matrix_24                           1, 1, 1
#> 25    adj_matrix_25                           1, 1, 1
#> 26    adj_matrix_26                           1, 1, 1
#> 27    adj_matrix_27                           1, 1, 1
#> 28    adj_matrix_28                           1, 1, 1
#> 29    adj_matrix_29                           1, 1, 1
#> 30    adj_matrix_30                           1, 1, 1
#>                      Public.Education.Programs
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16          0.04966368, 0.21848409, 0.32487741
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>             Salts.Added.during.Water.Treatment
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2  -7.287071e-06, -3.781633e-06, -2.716813e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities
#> 1    -2.649185e-01, -1.202008e-01, 1.139210e-06
#> 2            -0.3439474, -0.2785144, -0.1419764
#> 3    -2.785162e-01, -1.419780e-01, 2.126505e-06
#> 4    -3.031965e-01, -1.823903e-01, 1.890719e-06
#> 5            -0.3439469, -0.2912555, -0.1627199
#> 6     -4.509185e-07, 0.000000e+00, 4.509185e-07
#> 7                                       0, 0, 0
#> 8                                       0, 0, 0
#> 9   -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10        -0.34394686, -0.25041551, -0.09747171
#> 11           -0.3439440, -0.3031899, -0.1823828
#> 12           -0.3439472, -0.2677088, -0.1246366
#> 13   -2.504161e-01, -9.747187e-02, 2.606899e-06
#> 14        -0.34394690, -0.25041556, -0.09747073
#> 15           -0.3439467, -0.2785133, -0.1419752
#> 16                                      0, 0, 0
#> 17   -2.184904e-01, -4.966970e-02, 1.394166e-05
#> 18                                      0, 0, 0
#> 19   -2.785142e-01, -1.419758e-01, 1.654658e-06
#> 20    -9.886287e-07, 0.000000e+00, 9.886287e-07
#> 21   -2.504168e-01, -9.747226e-02, 4.176917e-06
#> 22           -0.3439486, -0.3031974, -0.1823913
#> 23                                      0, 0, 0
#> 24   -3.031964e-01, -1.823909e-01, 5.964684e-07
#> 25                                      0, 0, 0
#> 26                                      0, 0, 0
#> 27                                      0, 0, 0
#> 28           -0.3439469, -0.2912555, -0.1627198
#> 29                                      0, 0, 0
#> 30    -8.650037e-07, 0.000000e+00, 8.650037e-07
#>                             Ecosystem.Health
#> 1         0.06562469, 0.13535978, 0.17443415
#> 2         0.06670194, 0.12905046, 0.15766445
#> 3         0.08583128, 0.17279319, 0.21861527
#> 4         0.02984654, 0.06344861, 0.08392516
#> 5         0.05803894, 0.12066305, 0.15650258
#> 6  -1.823495e-05, 0.000000e+00, 1.823495e-05
#> 7  -2.339399e-05, 0.000000e+00, 2.339399e-05
#> 8  -3.734027e-06, 0.000000e+00, 3.734027e-06
#> 9         0.03467809, 0.07980185, 0.11209770
#> 10        0.06987573, 0.12237908, 0.13478990
#> 11 -0.0000315184, 0.0106128025, 0.0317934762
#> 12        0.08394626, 0.15173773, 0.17475462
#> 13        0.01053170, 0.02454208, 0.03500210
#> 14           0.1781593, 0.3264510, 0.3882986
#> 15        0.01385923, 0.06857068, 0.12021737
#> 16 -9.634720e-07, 6.403258e-02, 1.241829e-01
#> 17 -2.132187e-05, 1.232420e-02, 3.687688e-02
#> 18 -1.785633e-05, 0.000000e+00, 1.785633e-05
#> 19        0.03776046, 0.07470845, 0.09264320
#> 20 -1.313644e-05, 0.000000e+00, 1.313644e-05
#> 21     0.003418647, 0.017170139, 0.030870109
#> 22        0.01581755, 0.07796207, 0.13569403
#> 23        0.09639699, 0.16507281, 0.18061849
#> 24        0.06100563, 0.10751282, 0.11864309
#> 25 -8.614831e-06, 0.000000e+00, 8.614831e-06
#> 26                                   0, 0, 0
#> 27 -2.207469e-05, 0.000000e+00, 2.207469e-05
#> 28           0.1179967, 0.2151298, 0.2542002
#> 29 -2.906392e-05, 0.000000e+00, 2.906392e-05
#> 30 -1.548227e-05, 0.000000e+00, 1.548227e-05
#>     Public.Awareness.of.Reservoir.Salinization
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21  -2.060992e-02, -6.872083e-03, 1.392007e-05
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>                 Salinization.of.the.Reservoir
#> 1       -0.32624208, -0.19827639, -0.04468532
#> 2       -0.22174705, -0.18532772, -0.09925181
#> 3       -0.37279803, -0.28119287, -0.09659356
#> 4       -0.14517113, -0.08721721, -0.02423273
#> 5       -0.22912750, -0.18199123, -0.09103424
#> 6      -2.16743e-06, 0.00000e+00, 2.16743e-06
#> 7   -6.586473e-06, 0.000000e+00, 6.586473e-06
#> 8   -8.743405e-07, 0.000000e+00, 8.743405e-07
#> 9  -2.504205e-01, -9.747409e-02, 4.872594e-06
#> 10      -0.20499898, -0.15158721, -0.06831878
#> 11 -1.318708e-01, -2.758877e-02, 2.662699e-05
#> 12         -0.2153682, -0.2153676, -0.1396386
#> 13 -7.988033e-02, -2.548262e-02, 6.068898e-06
#> 14      -0.20499585, -0.16105880, -0.07934998
#> 15      -0.22173773, -0.14442093, -0.05060377
#> 16 -3.032049e-01, -1.823915e-01, 1.338811e-05
#> 17      -0.08755650, -0.06623863, -0.03117925
#> 18  -8.926425e-07, 0.000000e+00, 8.926425e-07
#> 19      -0.13352584, -0.10219718, -0.04873998
#> 20  -5.044662e-06, 0.000000e+00, 5.044662e-06
#> 21 -7.426995e-02, -2.892287e-02, 9.173772e-06
#> 22      -0.23592075, -0.16873413, -0.07092534
#> 23         -0.3248824, -0.2184897, -0.0496664
#> 24         -0.1519497, -0.1382799, -0.0795642
#> 25     -1.50192e-06, 0.00000e+00, 1.50192e-06
#> 26  -2.008037e-05, 0.000000e+00, 2.008037e-05
#> 27  -2.783859e-06, 0.000000e+00, 2.783859e-06
#> 28         -0.4136693, -0.3389161, -0.1665670
#> 29           -1.138e-05, 0.000e+00, 1.138e-05
#> 30  -3.414352e-06, 0.000000e+00, 3.414352e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966368e-02
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.562469e-02
#> 2                                 -3.439474e-01     6.670194e-02
#> 3                                 -2.785162e-01     8.583128e-02
#> 4                                 -3.031965e-01     2.984654e-02
#> 5                                 -3.439469e-01     5.803894e-02
#> 6                                 -4.509185e-07    -1.823495e-05
#> 7                                  0.000000e+00    -2.339399e-05
#> 8                                  0.000000e+00    -3.734027e-06
#> 9                                 -1.076422e-07     3.467809e-02
#> 10                                -3.439469e-01     6.987573e-02
#> 11                                -3.439440e-01    -3.151840e-05
#> 12                                -3.439472e-01     8.394626e-02
#> 13                                -2.504161e-01     1.053170e-02
#> 14                                -3.439469e-01     1.781593e-01
#> 15                                -3.439467e-01     1.385923e-02
#> 16                                 0.000000e+00    -9.634720e-07
#> 17                                -2.184904e-01    -2.132187e-05
#> 18                                 0.000000e+00    -1.785633e-05
#> 19                                -2.785142e-01     3.776046e-02
#> 20                                -9.886287e-07    -1.313644e-05
#> 21                                -2.504168e-01     3.418647e-03
#> 22                                -3.439486e-01     1.581755e-02
#> 23                                 0.000000e+00     9.639699e-02
#> 24                                -3.031964e-01     6.100563e-02
#> 25                                 0.000000e+00    -8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.207469e-05
#> 28                                -3.439469e-01     1.179967e-01
#> 29                                 0.000000e+00    -2.906392e-05
#> 30                                -8.650037e-07    -1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.262421e-01
#> 2                                4.238413e-07                 -2.217470e-01
#> 3                                1.708820e-06                 -3.727980e-01
#> 4                                0.000000e+00                 -1.451711e-01
#> 5                                4.171136e-07                 -2.291275e-01
#> 6                                0.000000e+00                 -2.167430e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                               -1.076422e-07                 -2.504205e-01
#> 10                               2.085568e-07                 -2.049990e-01
#> 11                               4.305689e-07                 -1.318708e-01
#> 12                               2.119206e-07                 -2.153682e-01
#> 13                              -1.009146e-07                 -7.988033e-02
#> 14                               1.695365e-06                 -2.049958e-01
#> 15                               1.614633e-07                 -2.217377e-01
#> 16                               0.000000e+00                 -3.032049e-01
#> 17                              -1.506991e-06                 -8.755650e-02
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.335258e-01
#> 20                               0.000000e+00                 -5.044662e-06
#> 21                              -2.060992e-02                 -7.426995e-02
#> 22                               1.708820e-06                 -2.359207e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               8.073167e-08                 -1.519497e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.136693e-01
#> 29                               0.000000e+00                 -1.138000e-05
#> 30                               0.000000e+00                 -3.414352e-06
#> 
#> $individual_inferences$mode_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -3.781633e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01       0.13535978
#> 2                                 -2.785144e-01       0.12905046
#> 3                                 -1.419780e-01       0.17279319
#> 4                                 -1.823903e-01       0.06344861
#> 5                                 -2.912555e-01       0.12066305
#> 6                                  0.000000e+00       0.00000000
#> 7                                  0.000000e+00       0.00000000
#> 8                                  0.000000e+00       0.00000000
#> 9                                 -1.076422e-07       0.07980185
#> 10                                -2.504155e-01       0.12237908
#> 11                                -3.031899e-01       0.01061280
#> 12                                -2.677088e-01       0.15173773
#> 13                                -9.747187e-02       0.02454208
#> 14                                -2.504156e-01       0.32645102
#> 15                                -2.785133e-01       0.06857068
#> 16                                 0.000000e+00       0.06403258
#> 17                                -4.966970e-02       0.01232420
#> 18                                 0.000000e+00       0.00000000
#> 19                                -1.419758e-01       0.07470845
#> 20                                 0.000000e+00       0.00000000
#> 21                                -9.747226e-02       0.01717014
#> 22                                -3.031974e-01       0.07796207
#> 23                                 0.000000e+00       0.16507281
#> 24                                -1.823909e-01       0.10751282
#> 25                                 0.000000e+00       0.00000000
#> 26                                 0.000000e+00       0.00000000
#> 27                                 0.000000e+00       0.00000000
#> 28                                -2.912555e-01       0.21512975
#> 29                                 0.000000e+00       0.00000000
#> 30                                 0.000000e+00       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                   -0.19827639
#> 2                                4.238413e-07                   -0.18532772
#> 3                                1.708820e-06                   -0.28119287
#> 4                                0.000000e+00                   -0.08721721
#> 5                                4.171136e-07                   -0.18199123
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                               -1.076422e-07                   -0.09747409
#> 10                               2.085568e-07                   -0.15158721
#> 11                               4.305689e-07                   -0.02758877
#> 12                               2.119206e-07                   -0.21536762
#> 13                              -1.009146e-07                   -0.02548262
#> 14                               1.695365e-06                   -0.16105880
#> 15                               1.614633e-07                   -0.14442093
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -1.506991e-06                   -0.06623863
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10219718
#> 20                               0.000000e+00                    0.00000000
#> 21                              -6.872083e-03                   -0.02892287
#> 22                               1.708820e-06                   -0.16873413
#> 23                               0.000000e+00                   -0.21848965
#> 24                               8.073167e-08                   -0.13827989
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               8.476826e-07                   -0.33891614
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.139210e-06     1.744341e-01
#> 2                                 -1.419764e-01     1.576644e-01
#> 3                                  2.126505e-06     2.186153e-01
#> 4                                  1.890719e-06     8.392516e-02
#> 5                                 -1.627199e-01     1.565026e-01
#> 6                                  4.509185e-07     1.823495e-05
#> 7                                  0.000000e+00     2.339399e-05
#> 8                                  0.000000e+00     3.734027e-06
#> 9                                 -1.076422e-07     1.120977e-01
#> 10                                -9.747171e-02     1.347899e-01
#> 11                                -1.823828e-01     3.179348e-02
#> 12                                -1.246366e-01     1.747546e-01
#> 13                                 2.606899e-06     3.500210e-02
#> 14                                -9.747073e-02     3.882986e-01
#> 15                                -1.419752e-01     1.202174e-01
#> 16                                 0.000000e+00     1.241829e-01
#> 17                                 1.394166e-05     3.687688e-02
#> 18                                 0.000000e+00     1.785633e-05
#> 19                                 1.654658e-06     9.264320e-02
#> 20                                 9.886287e-07     1.313644e-05
#> 21                                 4.176917e-06     3.087011e-02
#> 22                                -1.823913e-01     1.356940e-01
#> 23                                 0.000000e+00     1.806185e-01
#> 24                                 5.964684e-07     1.186431e-01
#> 25                                 0.000000e+00     8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.207469e-05
#> 28                                -1.627198e-01     2.542002e-01
#> 29                                 0.000000e+00     2.906392e-05
#> 30                                 8.650037e-07     1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.468532e-02
#> 2                                4.238413e-07                 -9.925181e-02
#> 3                                1.708820e-06                 -9.659356e-02
#> 4                                0.000000e+00                 -2.423273e-02
#> 5                                4.171136e-07                 -9.103424e-02
#> 6                                0.000000e+00                  2.167430e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                               -1.076422e-07                  4.872594e-06
#> 10                               2.085568e-07                 -6.831878e-02
#> 11                               4.305689e-07                  2.662699e-05
#> 12                               2.119206e-07                 -1.396386e-01
#> 13                              -1.009146e-07                  6.068898e-06
#> 14                               1.695365e-06                 -7.934998e-02
#> 15                               1.614633e-07                 -5.060377e-02
#> 16                               0.000000e+00                  1.338811e-05
#> 17                              -1.506991e-06                 -3.117925e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.873998e-02
#> 20                               0.000000e+00                  5.044662e-06
#> 21                               1.392007e-05                  9.173772e-06
#> 22                               1.708820e-06                 -7.092534e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               8.073167e-08                 -7.956420e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.665670e-01
#> 29                               0.000000e+00                  1.138000e-05
#> 30                               0.000000e+00                  3.414352e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp        lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000000
#> Public.Education.Programs                     0.0083299458  0.001666766
#> Salts.Added.during.Water.Treatment           -0.0001387161 -0.000249858
#> Salts.Added.by.Winter.Maintenance.Activities -0.1314510965 -0.212402560
#> Ecosystem.Health                              0.0764263364  0.033610635
#> Public.Awareness.of.Reservoir.Salinization   -0.0010549501 -0.002374269
#> Salinization.of.the.Reservoir                -0.1187321006 -0.187328607
#>                                                       mode         upper
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000e+00
#> Public.Education.Programs                     0.0083319182  1.499115e-02
#> Salts.Added.during.Water.Treatment           -0.0001387161 -2.757432e-05
#> Salts.Added.by.Winter.Maintenance.Activities -0.1359080809 -4.604265e-02
#> Ecosystem.Health                              0.0803366216  1.153318e-01
#> Public.Awareness.of.Reservoir.Salinization   -0.0007911801  5.982716e-07
#> Salinization.of.the.Reservoir                -0.1241399760 -4.472772e-02
#> 
get_fcmconfr_inferences(ex_tfn_fcmconfr, analysis = c("individual", "aggregate", "mc"))
#> $individual_inferences
#> $individual_inferences$tfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                           1, 1, 1
#> 2      adj_matrix_2                           1, 1, 1
#> 3      adj_matrix_3                           1, 1, 1
#> 4      adj_matrix_4                           1, 1, 1
#> 5      adj_matrix_5                           1, 1, 1
#> 6      adj_matrix_6                           1, 1, 1
#> 7      adj_matrix_7                           1, 1, 1
#> 8      adj_matrix_8                           1, 1, 1
#> 9      adj_matrix_9                           1, 1, 1
#> 10    adj_matrix_10                           1, 1, 1
#> 11    adj_matrix_11                           1, 1, 1
#> 12    adj_matrix_12                           1, 1, 1
#> 13    adj_matrix_13                           1, 1, 1
#> 14    adj_matrix_14                           1, 1, 1
#> 15    adj_matrix_15                           1, 1, 1
#> 16    adj_matrix_16                           1, 1, 1
#> 17    adj_matrix_17                           1, 1, 1
#> 18    adj_matrix_18                           1, 1, 1
#> 19    adj_matrix_19                           1, 1, 1
#> 20    adj_matrix_20                           1, 1, 1
#> 21    adj_matrix_21                           1, 1, 1
#> 22    adj_matrix_22                           1, 1, 1
#> 23    adj_matrix_23                           1, 1, 1
#> 24    adj_matrix_24                           1, 1, 1
#> 25    adj_matrix_25                           1, 1, 1
#> 26    adj_matrix_26                           1, 1, 1
#> 27    adj_matrix_27                           1, 1, 1
#> 28    adj_matrix_28                           1, 1, 1
#> 29    adj_matrix_29                           1, 1, 1
#> 30    adj_matrix_30                           1, 1, 1
#>                      Public.Education.Programs
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16          0.04966368, 0.21848409, 0.32487741
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>             Salts.Added.during.Water.Treatment
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2  -7.287071e-06, -3.781633e-06, -2.716813e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities
#> 1    -2.649185e-01, -1.202008e-01, 1.139210e-06
#> 2            -0.3439474, -0.2785144, -0.1419764
#> 3    -2.785162e-01, -1.419780e-01, 2.126505e-06
#> 4    -3.031965e-01, -1.823903e-01, 1.890719e-06
#> 5            -0.3439469, -0.2912555, -0.1627199
#> 6     -4.509185e-07, 0.000000e+00, 4.509185e-07
#> 7                                       0, 0, 0
#> 8                                       0, 0, 0
#> 9   -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10        -0.34394686, -0.25041551, -0.09747171
#> 11           -0.3439440, -0.3031899, -0.1823828
#> 12           -0.3439472, -0.2677088, -0.1246366
#> 13   -2.504161e-01, -9.747187e-02, 2.606899e-06
#> 14        -0.34394690, -0.25041556, -0.09747073
#> 15           -0.3439467, -0.2785133, -0.1419752
#> 16                                      0, 0, 0
#> 17   -2.184904e-01, -4.966970e-02, 1.394166e-05
#> 18                                      0, 0, 0
#> 19   -2.785142e-01, -1.419758e-01, 1.654658e-06
#> 20    -9.886287e-07, 0.000000e+00, 9.886287e-07
#> 21   -2.504168e-01, -9.747226e-02, 4.176917e-06
#> 22           -0.3439486, -0.3031974, -0.1823913
#> 23                                      0, 0, 0
#> 24   -3.031964e-01, -1.823909e-01, 5.964684e-07
#> 25                                      0, 0, 0
#> 26                                      0, 0, 0
#> 27                                      0, 0, 0
#> 28           -0.3439469, -0.2912555, -0.1627198
#> 29                                      0, 0, 0
#> 30    -8.650037e-07, 0.000000e+00, 8.650037e-07
#>                             Ecosystem.Health
#> 1         0.06562469, 0.13535978, 0.17443415
#> 2         0.06670194, 0.12905046, 0.15766445
#> 3         0.08583128, 0.17279319, 0.21861527
#> 4         0.02984654, 0.06344861, 0.08392516
#> 5         0.05803894, 0.12066305, 0.15650258
#> 6  -1.823495e-05, 0.000000e+00, 1.823495e-05
#> 7  -2.339399e-05, 0.000000e+00, 2.339399e-05
#> 8  -3.734027e-06, 0.000000e+00, 3.734027e-06
#> 9         0.03467809, 0.07980185, 0.11209770
#> 10        0.06987573, 0.12237908, 0.13478990
#> 11 -0.0000315184, 0.0106128025, 0.0317934762
#> 12        0.08394626, 0.15173773, 0.17475462
#> 13        0.01053170, 0.02454208, 0.03500210
#> 14           0.1781593, 0.3264510, 0.3882986
#> 15        0.01385923, 0.06857068, 0.12021737
#> 16 -9.634720e-07, 6.403258e-02, 1.241829e-01
#> 17 -2.132187e-05, 1.232420e-02, 3.687688e-02
#> 18 -1.785633e-05, 0.000000e+00, 1.785633e-05
#> 19        0.03776046, 0.07470845, 0.09264320
#> 20 -1.313644e-05, 0.000000e+00, 1.313644e-05
#> 21     0.003418647, 0.017170139, 0.030870109
#> 22        0.01581755, 0.07796207, 0.13569403
#> 23        0.09639699, 0.16507281, 0.18061849
#> 24        0.06100563, 0.10751282, 0.11864309
#> 25 -8.614831e-06, 0.000000e+00, 8.614831e-06
#> 26                                   0, 0, 0
#> 27 -2.207469e-05, 0.000000e+00, 2.207469e-05
#> 28           0.1179967, 0.2151298, 0.2542002
#> 29 -2.906392e-05, 0.000000e+00, 2.906392e-05
#> 30 -1.548227e-05, 0.000000e+00, 1.548227e-05
#>     Public.Awareness.of.Reservoir.Salinization
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21  -2.060992e-02, -6.872083e-03, 1.392007e-05
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>                 Salinization.of.the.Reservoir
#> 1       -0.32624208, -0.19827639, -0.04468532
#> 2       -0.22174705, -0.18532772, -0.09925181
#> 3       -0.37279803, -0.28119287, -0.09659356
#> 4       -0.14517113, -0.08721721, -0.02423273
#> 5       -0.22912750, -0.18199123, -0.09103424
#> 6      -2.16743e-06, 0.00000e+00, 2.16743e-06
#> 7   -6.586473e-06, 0.000000e+00, 6.586473e-06
#> 8   -8.743405e-07, 0.000000e+00, 8.743405e-07
#> 9  -2.504205e-01, -9.747409e-02, 4.872594e-06
#> 10      -0.20499898, -0.15158721, -0.06831878
#> 11 -1.318708e-01, -2.758877e-02, 2.662699e-05
#> 12         -0.2153682, -0.2153676, -0.1396386
#> 13 -7.988033e-02, -2.548262e-02, 6.068898e-06
#> 14      -0.20499585, -0.16105880, -0.07934998
#> 15      -0.22173773, -0.14442093, -0.05060377
#> 16 -3.032049e-01, -1.823915e-01, 1.338811e-05
#> 17      -0.08755650, -0.06623863, -0.03117925
#> 18  -8.926425e-07, 0.000000e+00, 8.926425e-07
#> 19      -0.13352584, -0.10219718, -0.04873998
#> 20  -5.044662e-06, 0.000000e+00, 5.044662e-06
#> 21 -7.426995e-02, -2.892287e-02, 9.173772e-06
#> 22      -0.23592075, -0.16873413, -0.07092534
#> 23         -0.3248824, -0.2184897, -0.0496664
#> 24         -0.1519497, -0.1382799, -0.0795642
#> 25     -1.50192e-06, 0.00000e+00, 1.50192e-06
#> 26  -2.008037e-05, 0.000000e+00, 2.008037e-05
#> 27  -2.783859e-06, 0.000000e+00, 2.783859e-06
#> 28         -0.4136693, -0.3389161, -0.1665670
#> 29           -1.138e-05, 0.000e+00, 1.138e-05
#> 30  -3.414352e-06, 0.000000e+00, 3.414352e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966368e-02
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.562469e-02
#> 2                                 -3.439474e-01     6.670194e-02
#> 3                                 -2.785162e-01     8.583128e-02
#> 4                                 -3.031965e-01     2.984654e-02
#> 5                                 -3.439469e-01     5.803894e-02
#> 6                                 -4.509185e-07    -1.823495e-05
#> 7                                  0.000000e+00    -2.339399e-05
#> 8                                  0.000000e+00    -3.734027e-06
#> 9                                 -1.076422e-07     3.467809e-02
#> 10                                -3.439469e-01     6.987573e-02
#> 11                                -3.439440e-01    -3.151840e-05
#> 12                                -3.439472e-01     8.394626e-02
#> 13                                -2.504161e-01     1.053170e-02
#> 14                                -3.439469e-01     1.781593e-01
#> 15                                -3.439467e-01     1.385923e-02
#> 16                                 0.000000e+00    -9.634720e-07
#> 17                                -2.184904e-01    -2.132187e-05
#> 18                                 0.000000e+00    -1.785633e-05
#> 19                                -2.785142e-01     3.776046e-02
#> 20                                -9.886287e-07    -1.313644e-05
#> 21                                -2.504168e-01     3.418647e-03
#> 22                                -3.439486e-01     1.581755e-02
#> 23                                 0.000000e+00     9.639699e-02
#> 24                                -3.031964e-01     6.100563e-02
#> 25                                 0.000000e+00    -8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.207469e-05
#> 28                                -3.439469e-01     1.179967e-01
#> 29                                 0.000000e+00    -2.906392e-05
#> 30                                -8.650037e-07    -1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.262421e-01
#> 2                                4.238413e-07                 -2.217470e-01
#> 3                                1.708820e-06                 -3.727980e-01
#> 4                                0.000000e+00                 -1.451711e-01
#> 5                                4.171136e-07                 -2.291275e-01
#> 6                                0.000000e+00                 -2.167430e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                               -1.076422e-07                 -2.504205e-01
#> 10                               2.085568e-07                 -2.049990e-01
#> 11                               4.305689e-07                 -1.318708e-01
#> 12                               2.119206e-07                 -2.153682e-01
#> 13                              -1.009146e-07                 -7.988033e-02
#> 14                               1.695365e-06                 -2.049958e-01
#> 15                               1.614633e-07                 -2.217377e-01
#> 16                               0.000000e+00                 -3.032049e-01
#> 17                              -1.506991e-06                 -8.755650e-02
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.335258e-01
#> 20                               0.000000e+00                 -5.044662e-06
#> 21                              -2.060992e-02                 -7.426995e-02
#> 22                               1.708820e-06                 -2.359207e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               8.073167e-08                 -1.519497e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.136693e-01
#> 29                               0.000000e+00                 -1.138000e-05
#> 30                               0.000000e+00                 -3.414352e-06
#> 
#> $individual_inferences$mode_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -3.781633e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01       0.13535978
#> 2                                 -2.785144e-01       0.12905046
#> 3                                 -1.419780e-01       0.17279319
#> 4                                 -1.823903e-01       0.06344861
#> 5                                 -2.912555e-01       0.12066305
#> 6                                  0.000000e+00       0.00000000
#> 7                                  0.000000e+00       0.00000000
#> 8                                  0.000000e+00       0.00000000
#> 9                                 -1.076422e-07       0.07980185
#> 10                                -2.504155e-01       0.12237908
#> 11                                -3.031899e-01       0.01061280
#> 12                                -2.677088e-01       0.15173773
#> 13                                -9.747187e-02       0.02454208
#> 14                                -2.504156e-01       0.32645102
#> 15                                -2.785133e-01       0.06857068
#> 16                                 0.000000e+00       0.06403258
#> 17                                -4.966970e-02       0.01232420
#> 18                                 0.000000e+00       0.00000000
#> 19                                -1.419758e-01       0.07470845
#> 20                                 0.000000e+00       0.00000000
#> 21                                -9.747226e-02       0.01717014
#> 22                                -3.031974e-01       0.07796207
#> 23                                 0.000000e+00       0.16507281
#> 24                                -1.823909e-01       0.10751282
#> 25                                 0.000000e+00       0.00000000
#> 26                                 0.000000e+00       0.00000000
#> 27                                 0.000000e+00       0.00000000
#> 28                                -2.912555e-01       0.21512975
#> 29                                 0.000000e+00       0.00000000
#> 30                                 0.000000e+00       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                   -0.19827639
#> 2                                4.238413e-07                   -0.18532772
#> 3                                1.708820e-06                   -0.28119287
#> 4                                0.000000e+00                   -0.08721721
#> 5                                4.171136e-07                   -0.18199123
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                               -1.076422e-07                   -0.09747409
#> 10                               2.085568e-07                   -0.15158721
#> 11                               4.305689e-07                   -0.02758877
#> 12                               2.119206e-07                   -0.21536762
#> 13                              -1.009146e-07                   -0.02548262
#> 14                               1.695365e-06                   -0.16105880
#> 15                               1.614633e-07                   -0.14442093
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -1.506991e-06                   -0.06623863
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10219718
#> 20                               0.000000e+00                    0.00000000
#> 21                              -6.872083e-03                   -0.02892287
#> 22                               1.708820e-06                   -0.16873413
#> 23                               0.000000e+00                   -0.21848965
#> 24                               8.073167e-08                   -0.13827989
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               8.476826e-07                   -0.33891614
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.139210e-06     1.744341e-01
#> 2                                 -1.419764e-01     1.576644e-01
#> 3                                  2.126505e-06     2.186153e-01
#> 4                                  1.890719e-06     8.392516e-02
#> 5                                 -1.627199e-01     1.565026e-01
#> 6                                  4.509185e-07     1.823495e-05
#> 7                                  0.000000e+00     2.339399e-05
#> 8                                  0.000000e+00     3.734027e-06
#> 9                                 -1.076422e-07     1.120977e-01
#> 10                                -9.747171e-02     1.347899e-01
#> 11                                -1.823828e-01     3.179348e-02
#> 12                                -1.246366e-01     1.747546e-01
#> 13                                 2.606899e-06     3.500210e-02
#> 14                                -9.747073e-02     3.882986e-01
#> 15                                -1.419752e-01     1.202174e-01
#> 16                                 0.000000e+00     1.241829e-01
#> 17                                 1.394166e-05     3.687688e-02
#> 18                                 0.000000e+00     1.785633e-05
#> 19                                 1.654658e-06     9.264320e-02
#> 20                                 9.886287e-07     1.313644e-05
#> 21                                 4.176917e-06     3.087011e-02
#> 22                                -1.823913e-01     1.356940e-01
#> 23                                 0.000000e+00     1.806185e-01
#> 24                                 5.964684e-07     1.186431e-01
#> 25                                 0.000000e+00     8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.207469e-05
#> 28                                -1.627198e-01     2.542002e-01
#> 29                                 0.000000e+00     2.906392e-05
#> 30                                 8.650037e-07     1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.468532e-02
#> 2                                4.238413e-07                 -9.925181e-02
#> 3                                1.708820e-06                 -9.659356e-02
#> 4                                0.000000e+00                 -2.423273e-02
#> 5                                4.171136e-07                 -9.103424e-02
#> 6                                0.000000e+00                  2.167430e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                               -1.076422e-07                  4.872594e-06
#> 10                               2.085568e-07                 -6.831878e-02
#> 11                               4.305689e-07                  2.662699e-05
#> 12                               2.119206e-07                 -1.396386e-01
#> 13                              -1.009146e-07                  6.068898e-06
#> 14                               1.695365e-06                 -7.934998e-02
#> 15                               1.614633e-07                 -5.060377e-02
#> 16                               0.000000e+00                  1.338811e-05
#> 17                              -1.506991e-06                 -3.117925e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.873998e-02
#> 20                               0.000000e+00                  5.044662e-06
#> 21                               1.392007e-05                  9.173772e-06
#> 22                               1.708820e-06                 -7.092534e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               8.073167e-08                 -7.956420e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.665670e-01
#> 29                               0.000000e+00                  1.138000e-05
#> 30                               0.000000e+00                  3.414352e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp        lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000000
#> Public.Education.Programs                     0.0083299458  0.001666766
#> Salts.Added.during.Water.Treatment           -0.0001387161 -0.000249858
#> Salts.Added.by.Winter.Maintenance.Activities -0.1314510965 -0.212402560
#> Ecosystem.Health                              0.0764263364  0.033610635
#> Public.Awareness.of.Reservoir.Salinization   -0.0010549501 -0.002374269
#> Salinization.of.the.Reservoir                -0.1187321006 -0.187328607
#>                                                       mode         upper
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000e+00
#> Public.Education.Programs                     0.0083319182  1.499115e-02
#> Salts.Added.during.Water.Treatment           -0.0001387161 -2.757432e-05
#> Salts.Added.by.Winter.Maintenance.Activities -0.1359080809 -4.604265e-02
#> Ecosystem.Health                              0.0803366216  1.153318e-01
#> Public.Awareness.of.Reservoir.Salinization   -0.0007911801  5.982716e-07
#> Salinization.of.the.Reservoir                -0.1241399760 -4.472772e-02
#> 
#> $mc_inferences
#>        adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1       mc_adj_matrix_1                                 1
#> 2       mc_adj_matrix_2                                 1
#> 3       mc_adj_matrix_3                                 1
#> 4       mc_adj_matrix_4                                 1
#> 5       mc_adj_matrix_5                                 1
#> 6       mc_adj_matrix_6                                 1
#> 7       mc_adj_matrix_7                                 1
#> 8       mc_adj_matrix_8                                 1
#> 9       mc_adj_matrix_9                                 1
#> 10     mc_adj_matrix_10                                 1
#> 11     mc_adj_matrix_11                                 1
#> 12     mc_adj_matrix_12                                 1
#> 13     mc_adj_matrix_13                                 1
#> 14     mc_adj_matrix_14                                 1
#> 15     mc_adj_matrix_15                                 1
#> 16     mc_adj_matrix_16                                 1
#> 17     mc_adj_matrix_17                                 1
#> 18     mc_adj_matrix_18                                 1
#> 19     mc_adj_matrix_19                                 1
#> 20     mc_adj_matrix_20                                 1
#> 21     mc_adj_matrix_21                                 1
#> 22     mc_adj_matrix_22                                 1
#> 23     mc_adj_matrix_23                                 1
#> 24     mc_adj_matrix_24                                 1
#> 25     mc_adj_matrix_25                                 1
#> 26     mc_adj_matrix_26                                 1
#> 27     mc_adj_matrix_27                                 1
#> 28     mc_adj_matrix_28                                 1
#> 29     mc_adj_matrix_29                                 1
#> 30     mc_adj_matrix_30                                 1
#> 31     mc_adj_matrix_31                                 1
#> 32     mc_adj_matrix_32                                 1
#> 33     mc_adj_matrix_33                                 1
#> 34     mc_adj_matrix_34                                 1
#> 35     mc_adj_matrix_35                                 1
#> 36     mc_adj_matrix_36                                 1
#> 37     mc_adj_matrix_37                                 1
#> 38     mc_adj_matrix_38                                 1
#> 39     mc_adj_matrix_39                                 1
#> 40     mc_adj_matrix_40                                 1
#> 41     mc_adj_matrix_41                                 1
#> 42     mc_adj_matrix_42                                 1
#> 43     mc_adj_matrix_43                                 1
#> 44     mc_adj_matrix_44                                 1
#> 45     mc_adj_matrix_45                                 1
#> 46     mc_adj_matrix_46                                 1
#> 47     mc_adj_matrix_47                                 1
#> 48     mc_adj_matrix_48                                 1
#> 49     mc_adj_matrix_49                                 1
#> 50     mc_adj_matrix_50                                 1
#> 51     mc_adj_matrix_51                                 1
#> 52     mc_adj_matrix_52                                 1
#> 53     mc_adj_matrix_53                                 1
#> 54     mc_adj_matrix_54                                 1
#> 55     mc_adj_matrix_55                                 1
#> 56     mc_adj_matrix_56                                 1
#> 57     mc_adj_matrix_57                                 1
#> 58     mc_adj_matrix_58                                 1
#> 59     mc_adj_matrix_59                                 1
#> 60     mc_adj_matrix_60                                 1
#> 61     mc_adj_matrix_61                                 1
#> 62     mc_adj_matrix_62                                 1
#> 63     mc_adj_matrix_63                                 1
#> 64     mc_adj_matrix_64                                 1
#> 65     mc_adj_matrix_65                                 1
#> 66     mc_adj_matrix_66                                 1
#> 67     mc_adj_matrix_67                                 1
#> 68     mc_adj_matrix_68                                 1
#> 69     mc_adj_matrix_69                                 1
#> 70     mc_adj_matrix_70                                 1
#> 71     mc_adj_matrix_71                                 1
#> 72     mc_adj_matrix_72                                 1
#> 73     mc_adj_matrix_73                                 1
#> 74     mc_adj_matrix_74                                 1
#> 75     mc_adj_matrix_75                                 1
#> 76     mc_adj_matrix_76                                 1
#> 77     mc_adj_matrix_77                                 1
#> 78     mc_adj_matrix_78                                 1
#> 79     mc_adj_matrix_79                                 1
#> 80     mc_adj_matrix_80                                 1
#> 81     mc_adj_matrix_81                                 1
#> 82     mc_adj_matrix_82                                 1
#> 83     mc_adj_matrix_83                                 1
#> 84     mc_adj_matrix_84                                 1
#> 85     mc_adj_matrix_85                                 1
#> 86     mc_adj_matrix_86                                 1
#> 87     mc_adj_matrix_87                                 1
#> 88     mc_adj_matrix_88                                 1
#> 89     mc_adj_matrix_89                                 1
#> 90     mc_adj_matrix_90                                 1
#> 91     mc_adj_matrix_91                                 1
#> 92     mc_adj_matrix_92                                 1
#> 93     mc_adj_matrix_93                                 1
#> 94     mc_adj_matrix_94                                 1
#> 95     mc_adj_matrix_95                                 1
#> 96     mc_adj_matrix_96                                 1
#> 97     mc_adj_matrix_97                                 1
#> 98     mc_adj_matrix_98                                 1
#> 99     mc_adj_matrix_99                                 1
#> 100   mc_adj_matrix_100                                 1
#> 101   mc_adj_matrix_101                                 1
#> 102   mc_adj_matrix_102                                 1
#> 103   mc_adj_matrix_103                                 1
#> 104   mc_adj_matrix_104                                 1
#> 105   mc_adj_matrix_105                                 1
#> 106   mc_adj_matrix_106                                 1
#> 107   mc_adj_matrix_107                                 1
#> 108   mc_adj_matrix_108                                 1
#> 109   mc_adj_matrix_109                                 1
#> 110   mc_adj_matrix_110                                 1
#> 111   mc_adj_matrix_111                                 1
#> 112   mc_adj_matrix_112                                 1
#> 113   mc_adj_matrix_113                                 1
#> 114   mc_adj_matrix_114                                 1
#> 115   mc_adj_matrix_115                                 1
#> 116   mc_adj_matrix_116                                 1
#> 117   mc_adj_matrix_117                                 1
#> 118   mc_adj_matrix_118                                 1
#> 119   mc_adj_matrix_119                                 1
#> 120   mc_adj_matrix_120                                 1
#> 121   mc_adj_matrix_121                                 1
#> 122   mc_adj_matrix_122                                 1
#> 123   mc_adj_matrix_123                                 1
#> 124   mc_adj_matrix_124                                 1
#> 125   mc_adj_matrix_125                                 1
#> 126   mc_adj_matrix_126                                 1
#> 127   mc_adj_matrix_127                                 1
#> 128   mc_adj_matrix_128                                 1
#> 129   mc_adj_matrix_129                                 1
#> 130   mc_adj_matrix_130                                 1
#> 131   mc_adj_matrix_131                                 1
#> 132   mc_adj_matrix_132                                 1
#> 133   mc_adj_matrix_133                                 1
#> 134   mc_adj_matrix_134                                 1
#> 135   mc_adj_matrix_135                                 1
#> 136   mc_adj_matrix_136                                 1
#> 137   mc_adj_matrix_137                                 1
#> 138   mc_adj_matrix_138                                 1
#> 139   mc_adj_matrix_139                                 1
#> 140   mc_adj_matrix_140                                 1
#> 141   mc_adj_matrix_141                                 1
#> 142   mc_adj_matrix_142                                 1
#> 143   mc_adj_matrix_143                                 1
#> 144   mc_adj_matrix_144                                 1
#> 145   mc_adj_matrix_145                                 1
#> 146   mc_adj_matrix_146                                 1
#> 147   mc_adj_matrix_147                                 1
#> 148   mc_adj_matrix_148                                 1
#> 149   mc_adj_matrix_149                                 1
#> 150   mc_adj_matrix_150                                 1
#> 151   mc_adj_matrix_151                                 1
#> 152   mc_adj_matrix_152                                 1
#> 153   mc_adj_matrix_153                                 1
#> 154   mc_adj_matrix_154                                 1
#> 155   mc_adj_matrix_155                                 1
#> 156   mc_adj_matrix_156                                 1
#> 157   mc_adj_matrix_157                                 1
#> 158   mc_adj_matrix_158                                 1
#> 159   mc_adj_matrix_159                                 1
#> 160   mc_adj_matrix_160                                 1
#> 161   mc_adj_matrix_161                                 1
#> 162   mc_adj_matrix_162                                 1
#> 163   mc_adj_matrix_163                                 1
#> 164   mc_adj_matrix_164                                 1
#> 165   mc_adj_matrix_165                                 1
#> 166   mc_adj_matrix_166                                 1
#> 167   mc_adj_matrix_167                                 1
#> 168   mc_adj_matrix_168                                 1
#> 169   mc_adj_matrix_169                                 1
#> 170   mc_adj_matrix_170                                 1
#> 171   mc_adj_matrix_171                                 1
#> 172   mc_adj_matrix_172                                 1
#> 173   mc_adj_matrix_173                                 1
#> 174   mc_adj_matrix_174                                 1
#> 175   mc_adj_matrix_175                                 1
#> 176   mc_adj_matrix_176                                 1
#> 177   mc_adj_matrix_177                                 1
#> 178   mc_adj_matrix_178                                 1
#> 179   mc_adj_matrix_179                                 1
#> 180   mc_adj_matrix_180                                 1
#> 181   mc_adj_matrix_181                                 1
#> 182   mc_adj_matrix_182                                 1
#> 183   mc_adj_matrix_183                                 1
#> 184   mc_adj_matrix_184                                 1
#> 185   mc_adj_matrix_185                                 1
#> 186   mc_adj_matrix_186                                 1
#> 187   mc_adj_matrix_187                                 1
#> 188   mc_adj_matrix_188                                 1
#> 189   mc_adj_matrix_189                                 1
#> 190   mc_adj_matrix_190                                 1
#> 191   mc_adj_matrix_191                                 1
#> 192   mc_adj_matrix_192                                 1
#> 193   mc_adj_matrix_193                                 1
#> 194   mc_adj_matrix_194                                 1
#> 195   mc_adj_matrix_195                                 1
#> 196   mc_adj_matrix_196                                 1
#> 197   mc_adj_matrix_197                                 1
#> 198   mc_adj_matrix_198                                 1
#> 199   mc_adj_matrix_199                                 1
#> 200   mc_adj_matrix_200                                 1
#> 201   mc_adj_matrix_201                                 1
#> 202   mc_adj_matrix_202                                 1
#> 203   mc_adj_matrix_203                                 1
#> 204   mc_adj_matrix_204                                 1
#> 205   mc_adj_matrix_205                                 1
#> 206   mc_adj_matrix_206                                 1
#> 207   mc_adj_matrix_207                                 1
#> 208   mc_adj_matrix_208                                 1
#> 209   mc_adj_matrix_209                                 1
#> 210   mc_adj_matrix_210                                 1
#> 211   mc_adj_matrix_211                                 1
#> 212   mc_adj_matrix_212                                 1
#> 213   mc_adj_matrix_213                                 1
#> 214   mc_adj_matrix_214                                 1
#> 215   mc_adj_matrix_215                                 1
#> 216   mc_adj_matrix_216                                 1
#> 217   mc_adj_matrix_217                                 1
#> 218   mc_adj_matrix_218                                 1
#> 219   mc_adj_matrix_219                                 1
#> 220   mc_adj_matrix_220                                 1
#> 221   mc_adj_matrix_221                                 1
#> 222   mc_adj_matrix_222                                 1
#> 223   mc_adj_matrix_223                                 1
#> 224   mc_adj_matrix_224                                 1
#> 225   mc_adj_matrix_225                                 1
#> 226   mc_adj_matrix_226                                 1
#> 227   mc_adj_matrix_227                                 1
#> 228   mc_adj_matrix_228                                 1
#> 229   mc_adj_matrix_229                                 1
#> 230   mc_adj_matrix_230                                 1
#> 231   mc_adj_matrix_231                                 1
#> 232   mc_adj_matrix_232                                 1
#> 233   mc_adj_matrix_233                                 1
#> 234   mc_adj_matrix_234                                 1
#> 235   mc_adj_matrix_235                                 1
#> 236   mc_adj_matrix_236                                 1
#> 237   mc_adj_matrix_237                                 1
#> 238   mc_adj_matrix_238                                 1
#> 239   mc_adj_matrix_239                                 1
#> 240   mc_adj_matrix_240                                 1
#> 241   mc_adj_matrix_241                                 1
#> 242   mc_adj_matrix_242                                 1
#> 243   mc_adj_matrix_243                                 1
#> 244   mc_adj_matrix_244                                 1
#> 245   mc_adj_matrix_245                                 1
#> 246   mc_adj_matrix_246                                 1
#> 247   mc_adj_matrix_247                                 1
#> 248   mc_adj_matrix_248                                 1
#> 249   mc_adj_matrix_249                                 1
#> 250   mc_adj_matrix_250                                 1
#> 251   mc_adj_matrix_251                                 1
#> 252   mc_adj_matrix_252                                 1
#> 253   mc_adj_matrix_253                                 1
#> 254   mc_adj_matrix_254                                 1
#> 255   mc_adj_matrix_255                                 1
#> 256   mc_adj_matrix_256                                 1
#> 257   mc_adj_matrix_257                                 1
#> 258   mc_adj_matrix_258                                 1
#> 259   mc_adj_matrix_259                                 1
#> 260   mc_adj_matrix_260                                 1
#> 261   mc_adj_matrix_261                                 1
#> 262   mc_adj_matrix_262                                 1
#> 263   mc_adj_matrix_263                                 1
#> 264   mc_adj_matrix_264                                 1
#> 265   mc_adj_matrix_265                                 1
#> 266   mc_adj_matrix_266                                 1
#> 267   mc_adj_matrix_267                                 1
#> 268   mc_adj_matrix_268                                 1
#> 269   mc_adj_matrix_269                                 1
#> 270   mc_adj_matrix_270                                 1
#> 271   mc_adj_matrix_271                                 1
#> 272   mc_adj_matrix_272                                 1
#> 273   mc_adj_matrix_273                                 1
#> 274   mc_adj_matrix_274                                 1
#> 275   mc_adj_matrix_275                                 1
#> 276   mc_adj_matrix_276                                 1
#> 277   mc_adj_matrix_277                                 1
#> 278   mc_adj_matrix_278                                 1
#> 279   mc_adj_matrix_279                                 1
#> 280   mc_adj_matrix_280                                 1
#> 281   mc_adj_matrix_281                                 1
#> 282   mc_adj_matrix_282                                 1
#> 283   mc_adj_matrix_283                                 1
#> 284   mc_adj_matrix_284                                 1
#> 285   mc_adj_matrix_285                                 1
#> 286   mc_adj_matrix_286                                 1
#> 287   mc_adj_matrix_287                                 1
#> 288   mc_adj_matrix_288                                 1
#> 289   mc_adj_matrix_289                                 1
#> 290   mc_adj_matrix_290                                 1
#> 291   mc_adj_matrix_291                                 1
#> 292   mc_adj_matrix_292                                 1
#> 293   mc_adj_matrix_293                                 1
#> 294   mc_adj_matrix_294                                 1
#> 295   mc_adj_matrix_295                                 1
#> 296   mc_adj_matrix_296                                 1
#> 297   mc_adj_matrix_297                                 1
#> 298   mc_adj_matrix_298                                 1
#> 299   mc_adj_matrix_299                                 1
#> 300   mc_adj_matrix_300                                 1
#> 301   mc_adj_matrix_301                                 1
#> 302   mc_adj_matrix_302                                 1
#> 303   mc_adj_matrix_303                                 1
#> 304   mc_adj_matrix_304                                 1
#> 305   mc_adj_matrix_305                                 1
#> 306   mc_adj_matrix_306                                 1
#> 307   mc_adj_matrix_307                                 1
#> 308   mc_adj_matrix_308                                 1
#> 309   mc_adj_matrix_309                                 1
#> 310   mc_adj_matrix_310                                 1
#> 311   mc_adj_matrix_311                                 1
#> 312   mc_adj_matrix_312                                 1
#> 313   mc_adj_matrix_313                                 1
#> 314   mc_adj_matrix_314                                 1
#> 315   mc_adj_matrix_315                                 1
#> 316   mc_adj_matrix_316                                 1
#> 317   mc_adj_matrix_317                                 1
#> 318   mc_adj_matrix_318                                 1
#> 319   mc_adj_matrix_319                                 1
#> 320   mc_adj_matrix_320                                 1
#> 321   mc_adj_matrix_321                                 1
#> 322   mc_adj_matrix_322                                 1
#> 323   mc_adj_matrix_323                                 1
#> 324   mc_adj_matrix_324                                 1
#> 325   mc_adj_matrix_325                                 1
#> 326   mc_adj_matrix_326                                 1
#> 327   mc_adj_matrix_327                                 1
#> 328   mc_adj_matrix_328                                 1
#> 329   mc_adj_matrix_329                                 1
#> 330   mc_adj_matrix_330                                 1
#> 331   mc_adj_matrix_331                                 1
#> 332   mc_adj_matrix_332                                 1
#> 333   mc_adj_matrix_333                                 1
#> 334   mc_adj_matrix_334                                 1
#> 335   mc_adj_matrix_335                                 1
#> 336   mc_adj_matrix_336                                 1
#> 337   mc_adj_matrix_337                                 1
#> 338   mc_adj_matrix_338                                 1
#> 339   mc_adj_matrix_339                                 1
#> 340   mc_adj_matrix_340                                 1
#> 341   mc_adj_matrix_341                                 1
#> 342   mc_adj_matrix_342                                 1
#> 343   mc_adj_matrix_343                                 1
#> 344   mc_adj_matrix_344                                 1
#> 345   mc_adj_matrix_345                                 1
#> 346   mc_adj_matrix_346                                 1
#> 347   mc_adj_matrix_347                                 1
#> 348   mc_adj_matrix_348                                 1
#> 349   mc_adj_matrix_349                                 1
#> 350   mc_adj_matrix_350                                 1
#> 351   mc_adj_matrix_351                                 1
#> 352   mc_adj_matrix_352                                 1
#> 353   mc_adj_matrix_353                                 1
#> 354   mc_adj_matrix_354                                 1
#> 355   mc_adj_matrix_355                                 1
#> 356   mc_adj_matrix_356                                 1
#> 357   mc_adj_matrix_357                                 1
#> 358   mc_adj_matrix_358                                 1
#> 359   mc_adj_matrix_359                                 1
#> 360   mc_adj_matrix_360                                 1
#> 361   mc_adj_matrix_361                                 1
#> 362   mc_adj_matrix_362                                 1
#> 363   mc_adj_matrix_363                                 1
#> 364   mc_adj_matrix_364                                 1
#> 365   mc_adj_matrix_365                                 1
#> 366   mc_adj_matrix_366                                 1
#> 367   mc_adj_matrix_367                                 1
#> 368   mc_adj_matrix_368                                 1
#> 369   mc_adj_matrix_369                                 1
#> 370   mc_adj_matrix_370                                 1
#> 371   mc_adj_matrix_371                                 1
#> 372   mc_adj_matrix_372                                 1
#> 373   mc_adj_matrix_373                                 1
#> 374   mc_adj_matrix_374                                 1
#> 375   mc_adj_matrix_375                                 1
#> 376   mc_adj_matrix_376                                 1
#> 377   mc_adj_matrix_377                                 1
#> 378   mc_adj_matrix_378                                 1
#> 379   mc_adj_matrix_379                                 1
#> 380   mc_adj_matrix_380                                 1
#> 381   mc_adj_matrix_381                                 1
#> 382   mc_adj_matrix_382                                 1
#> 383   mc_adj_matrix_383                                 1
#> 384   mc_adj_matrix_384                                 1
#> 385   mc_adj_matrix_385                                 1
#> 386   mc_adj_matrix_386                                 1
#> 387   mc_adj_matrix_387                                 1
#> 388   mc_adj_matrix_388                                 1
#> 389   mc_adj_matrix_389                                 1
#> 390   mc_adj_matrix_390                                 1
#> 391   mc_adj_matrix_391                                 1
#> 392   mc_adj_matrix_392                                 1
#> 393   mc_adj_matrix_393                                 1
#> 394   mc_adj_matrix_394                                 1
#> 395   mc_adj_matrix_395                                 1
#> 396   mc_adj_matrix_396                                 1
#> 397   mc_adj_matrix_397                                 1
#> 398   mc_adj_matrix_398                                 1
#> 399   mc_adj_matrix_399                                 1
#> 400   mc_adj_matrix_400                                 1
#> 401   mc_adj_matrix_401                                 1
#> 402   mc_adj_matrix_402                                 1
#> 403   mc_adj_matrix_403                                 1
#> 404   mc_adj_matrix_404                                 1
#> 405   mc_adj_matrix_405                                 1
#> 406   mc_adj_matrix_406                                 1
#> 407   mc_adj_matrix_407                                 1
#> 408   mc_adj_matrix_408                                 1
#> 409   mc_adj_matrix_409                                 1
#> 410   mc_adj_matrix_410                                 1
#> 411   mc_adj_matrix_411                                 1
#> 412   mc_adj_matrix_412                                 1
#> 413   mc_adj_matrix_413                                 1
#> 414   mc_adj_matrix_414                                 1
#> 415   mc_adj_matrix_415                                 1
#> 416   mc_adj_matrix_416                                 1
#> 417   mc_adj_matrix_417                                 1
#> 418   mc_adj_matrix_418                                 1
#> 419   mc_adj_matrix_419                                 1
#> 420   mc_adj_matrix_420                                 1
#> 421   mc_adj_matrix_421                                 1
#> 422   mc_adj_matrix_422                                 1
#> 423   mc_adj_matrix_423                                 1
#> 424   mc_adj_matrix_424                                 1
#> 425   mc_adj_matrix_425                                 1
#> 426   mc_adj_matrix_426                                 1
#> 427   mc_adj_matrix_427                                 1
#> 428   mc_adj_matrix_428                                 1
#> 429   mc_adj_matrix_429                                 1
#> 430   mc_adj_matrix_430                                 1
#> 431   mc_adj_matrix_431                                 1
#> 432   mc_adj_matrix_432                                 1
#> 433   mc_adj_matrix_433                                 1
#> 434   mc_adj_matrix_434                                 1
#> 435   mc_adj_matrix_435                                 1
#> 436   mc_adj_matrix_436                                 1
#> 437   mc_adj_matrix_437                                 1
#> 438   mc_adj_matrix_438                                 1
#> 439   mc_adj_matrix_439                                 1
#> 440   mc_adj_matrix_440                                 1
#> 441   mc_adj_matrix_441                                 1
#> 442   mc_adj_matrix_442                                 1
#> 443   mc_adj_matrix_443                                 1
#> 444   mc_adj_matrix_444                                 1
#> 445   mc_adj_matrix_445                                 1
#> 446   mc_adj_matrix_446                                 1
#> 447   mc_adj_matrix_447                                 1
#> 448   mc_adj_matrix_448                                 1
#> 449   mc_adj_matrix_449                                 1
#> 450   mc_adj_matrix_450                                 1
#> 451   mc_adj_matrix_451                                 1
#> 452   mc_adj_matrix_452                                 1
#> 453   mc_adj_matrix_453                                 1
#> 454   mc_adj_matrix_454                                 1
#> 455   mc_adj_matrix_455                                 1
#> 456   mc_adj_matrix_456                                 1
#> 457   mc_adj_matrix_457                                 1
#> 458   mc_adj_matrix_458                                 1
#> 459   mc_adj_matrix_459                                 1
#> 460   mc_adj_matrix_460                                 1
#> 461   mc_adj_matrix_461                                 1
#> 462   mc_adj_matrix_462                                 1
#> 463   mc_adj_matrix_463                                 1
#> 464   mc_adj_matrix_464                                 1
#> 465   mc_adj_matrix_465                                 1
#> 466   mc_adj_matrix_466                                 1
#> 467   mc_adj_matrix_467                                 1
#> 468   mc_adj_matrix_468                                 1
#> 469   mc_adj_matrix_469                                 1
#> 470   mc_adj_matrix_470                                 1
#> 471   mc_adj_matrix_471                                 1
#> 472   mc_adj_matrix_472                                 1
#> 473   mc_adj_matrix_473                                 1
#> 474   mc_adj_matrix_474                                 1
#> 475   mc_adj_matrix_475                                 1
#> 476   mc_adj_matrix_476                                 1
#> 477   mc_adj_matrix_477                                 1
#> 478   mc_adj_matrix_478                                 1
#> 479   mc_adj_matrix_479                                 1
#> 480   mc_adj_matrix_480                                 1
#> 481   mc_adj_matrix_481                                 1
#> 482   mc_adj_matrix_482                                 1
#> 483   mc_adj_matrix_483                                 1
#> 484   mc_adj_matrix_484                                 1
#> 485   mc_adj_matrix_485                                 1
#> 486   mc_adj_matrix_486                                 1
#> 487   mc_adj_matrix_487                                 1
#> 488   mc_adj_matrix_488                                 1
#> 489   mc_adj_matrix_489                                 1
#> 490   mc_adj_matrix_490                                 1
#> 491   mc_adj_matrix_491                                 1
#> 492   mc_adj_matrix_492                                 1
#> 493   mc_adj_matrix_493                                 1
#> 494   mc_adj_matrix_494                                 1
#> 495   mc_adj_matrix_495                                 1
#> 496   mc_adj_matrix_496                                 1
#> 497   mc_adj_matrix_497                                 1
#> 498   mc_adj_matrix_498                                 1
#> 499   mc_adj_matrix_499                                 1
#> 500   mc_adj_matrix_500                                 1
#> 501   mc_adj_matrix_501                                 1
#> 502   mc_adj_matrix_502                                 1
#> 503   mc_adj_matrix_503                                 1
#> 504   mc_adj_matrix_504                                 1
#> 505   mc_adj_matrix_505                                 1
#> 506   mc_adj_matrix_506                                 1
#> 507   mc_adj_matrix_507                                 1
#> 508   mc_adj_matrix_508                                 1
#> 509   mc_adj_matrix_509                                 1
#> 510   mc_adj_matrix_510                                 1
#> 511   mc_adj_matrix_511                                 1
#> 512   mc_adj_matrix_512                                 1
#> 513   mc_adj_matrix_513                                 1
#> 514   mc_adj_matrix_514                                 1
#> 515   mc_adj_matrix_515                                 1
#> 516   mc_adj_matrix_516                                 1
#> 517   mc_adj_matrix_517                                 1
#> 518   mc_adj_matrix_518                                 1
#> 519   mc_adj_matrix_519                                 1
#> 520   mc_adj_matrix_520                                 1
#> 521   mc_adj_matrix_521                                 1
#> 522   mc_adj_matrix_522                                 1
#> 523   mc_adj_matrix_523                                 1
#> 524   mc_adj_matrix_524                                 1
#> 525   mc_adj_matrix_525                                 1
#> 526   mc_adj_matrix_526                                 1
#> 527   mc_adj_matrix_527                                 1
#> 528   mc_adj_matrix_528                                 1
#> 529   mc_adj_matrix_529                                 1
#> 530   mc_adj_matrix_530                                 1
#> 531   mc_adj_matrix_531                                 1
#> 532   mc_adj_matrix_532                                 1
#> 533   mc_adj_matrix_533                                 1
#> 534   mc_adj_matrix_534                                 1
#> 535   mc_adj_matrix_535                                 1
#> 536   mc_adj_matrix_536                                 1
#> 537   mc_adj_matrix_537                                 1
#> 538   mc_adj_matrix_538                                 1
#> 539   mc_adj_matrix_539                                 1
#> 540   mc_adj_matrix_540                                 1
#> 541   mc_adj_matrix_541                                 1
#> 542   mc_adj_matrix_542                                 1
#> 543   mc_adj_matrix_543                                 1
#> 544   mc_adj_matrix_544                                 1
#> 545   mc_adj_matrix_545                                 1
#> 546   mc_adj_matrix_546                                 1
#> 547   mc_adj_matrix_547                                 1
#> 548   mc_adj_matrix_548                                 1
#> 549   mc_adj_matrix_549                                 1
#> 550   mc_adj_matrix_550                                 1
#> 551   mc_adj_matrix_551                                 1
#> 552   mc_adj_matrix_552                                 1
#> 553   mc_adj_matrix_553                                 1
#> 554   mc_adj_matrix_554                                 1
#> 555   mc_adj_matrix_555                                 1
#> 556   mc_adj_matrix_556                                 1
#> 557   mc_adj_matrix_557                                 1
#> 558   mc_adj_matrix_558                                 1
#> 559   mc_adj_matrix_559                                 1
#> 560   mc_adj_matrix_560                                 1
#> 561   mc_adj_matrix_561                                 1
#> 562   mc_adj_matrix_562                                 1
#> 563   mc_adj_matrix_563                                 1
#> 564   mc_adj_matrix_564                                 1
#> 565   mc_adj_matrix_565                                 1
#> 566   mc_adj_matrix_566                                 1
#> 567   mc_adj_matrix_567                                 1
#> 568   mc_adj_matrix_568                                 1
#> 569   mc_adj_matrix_569                                 1
#> 570   mc_adj_matrix_570                                 1
#> 571   mc_adj_matrix_571                                 1
#> 572   mc_adj_matrix_572                                 1
#> 573   mc_adj_matrix_573                                 1
#> 574   mc_adj_matrix_574                                 1
#> 575   mc_adj_matrix_575                                 1
#> 576   mc_adj_matrix_576                                 1
#> 577   mc_adj_matrix_577                                 1
#> 578   mc_adj_matrix_578                                 1
#> 579   mc_adj_matrix_579                                 1
#> 580   mc_adj_matrix_580                                 1
#> 581   mc_adj_matrix_581                                 1
#> 582   mc_adj_matrix_582                                 1
#> 583   mc_adj_matrix_583                                 1
#> 584   mc_adj_matrix_584                                 1
#> 585   mc_adj_matrix_585                                 1
#> 586   mc_adj_matrix_586                                 1
#> 587   mc_adj_matrix_587                                 1
#> 588   mc_adj_matrix_588                                 1
#> 589   mc_adj_matrix_589                                 1
#> 590   mc_adj_matrix_590                                 1
#> 591   mc_adj_matrix_591                                 1
#> 592   mc_adj_matrix_592                                 1
#> 593   mc_adj_matrix_593                                 1
#> 594   mc_adj_matrix_594                                 1
#> 595   mc_adj_matrix_595                                 1
#> 596   mc_adj_matrix_596                                 1
#> 597   mc_adj_matrix_597                                 1
#> 598   mc_adj_matrix_598                                 1
#> 599   mc_adj_matrix_599                                 1
#> 600   mc_adj_matrix_600                                 1
#> 601   mc_adj_matrix_601                                 1
#> 602   mc_adj_matrix_602                                 1
#> 603   mc_adj_matrix_603                                 1
#> 604   mc_adj_matrix_604                                 1
#> 605   mc_adj_matrix_605                                 1
#> 606   mc_adj_matrix_606                                 1
#> 607   mc_adj_matrix_607                                 1
#> 608   mc_adj_matrix_608                                 1
#> 609   mc_adj_matrix_609                                 1
#> 610   mc_adj_matrix_610                                 1
#> 611   mc_adj_matrix_611                                 1
#> 612   mc_adj_matrix_612                                 1
#> 613   mc_adj_matrix_613                                 1
#> 614   mc_adj_matrix_614                                 1
#> 615   mc_adj_matrix_615                                 1
#> 616   mc_adj_matrix_616                                 1
#> 617   mc_adj_matrix_617                                 1
#> 618   mc_adj_matrix_618                                 1
#> 619   mc_adj_matrix_619                                 1
#> 620   mc_adj_matrix_620                                 1
#> 621   mc_adj_matrix_621                                 1
#> 622   mc_adj_matrix_622                                 1
#> 623   mc_adj_matrix_623                                 1
#> 624   mc_adj_matrix_624                                 1
#> 625   mc_adj_matrix_625                                 1
#> 626   mc_adj_matrix_626                                 1
#> 627   mc_adj_matrix_627                                 1
#> 628   mc_adj_matrix_628                                 1
#> 629   mc_adj_matrix_629                                 1
#> 630   mc_adj_matrix_630                                 1
#> 631   mc_adj_matrix_631                                 1
#> 632   mc_adj_matrix_632                                 1
#> 633   mc_adj_matrix_633                                 1
#> 634   mc_adj_matrix_634                                 1
#> 635   mc_adj_matrix_635                                 1
#> 636   mc_adj_matrix_636                                 1
#> 637   mc_adj_matrix_637                                 1
#> 638   mc_adj_matrix_638                                 1
#> 639   mc_adj_matrix_639                                 1
#> 640   mc_adj_matrix_640                                 1
#> 641   mc_adj_matrix_641                                 1
#> 642   mc_adj_matrix_642                                 1
#> 643   mc_adj_matrix_643                                 1
#> 644   mc_adj_matrix_644                                 1
#> 645   mc_adj_matrix_645                                 1
#> 646   mc_adj_matrix_646                                 1
#> 647   mc_adj_matrix_647                                 1
#> 648   mc_adj_matrix_648                                 1
#> 649   mc_adj_matrix_649                                 1
#> 650   mc_adj_matrix_650                                 1
#> 651   mc_adj_matrix_651                                 1
#> 652   mc_adj_matrix_652                                 1
#> 653   mc_adj_matrix_653                                 1
#> 654   mc_adj_matrix_654                                 1
#> 655   mc_adj_matrix_655                                 1
#> 656   mc_adj_matrix_656                                 1
#> 657   mc_adj_matrix_657                                 1
#> 658   mc_adj_matrix_658                                 1
#> 659   mc_adj_matrix_659                                 1
#> 660   mc_adj_matrix_660                                 1
#> 661   mc_adj_matrix_661                                 1
#> 662   mc_adj_matrix_662                                 1
#> 663   mc_adj_matrix_663                                 1
#> 664   mc_adj_matrix_664                                 1
#> 665   mc_adj_matrix_665                                 1
#> 666   mc_adj_matrix_666                                 1
#> 667   mc_adj_matrix_667                                 1
#> 668   mc_adj_matrix_668                                 1
#> 669   mc_adj_matrix_669                                 1
#> 670   mc_adj_matrix_670                                 1
#> 671   mc_adj_matrix_671                                 1
#> 672   mc_adj_matrix_672                                 1
#> 673   mc_adj_matrix_673                                 1
#> 674   mc_adj_matrix_674                                 1
#> 675   mc_adj_matrix_675                                 1
#> 676   mc_adj_matrix_676                                 1
#> 677   mc_adj_matrix_677                                 1
#> 678   mc_adj_matrix_678                                 1
#> 679   mc_adj_matrix_679                                 1
#> 680   mc_adj_matrix_680                                 1
#> 681   mc_adj_matrix_681                                 1
#> 682   mc_adj_matrix_682                                 1
#> 683   mc_adj_matrix_683                                 1
#> 684   mc_adj_matrix_684                                 1
#> 685   mc_adj_matrix_685                                 1
#> 686   mc_adj_matrix_686                                 1
#> 687   mc_adj_matrix_687                                 1
#> 688   mc_adj_matrix_688                                 1
#> 689   mc_adj_matrix_689                                 1
#> 690   mc_adj_matrix_690                                 1
#> 691   mc_adj_matrix_691                                 1
#> 692   mc_adj_matrix_692                                 1
#> 693   mc_adj_matrix_693                                 1
#> 694   mc_adj_matrix_694                                 1
#> 695   mc_adj_matrix_695                                 1
#> 696   mc_adj_matrix_696                                 1
#> 697   mc_adj_matrix_697                                 1
#> 698   mc_adj_matrix_698                                 1
#> 699   mc_adj_matrix_699                                 1
#> 700   mc_adj_matrix_700                                 1
#> 701   mc_adj_matrix_701                                 1
#> 702   mc_adj_matrix_702                                 1
#> 703   mc_adj_matrix_703                                 1
#> 704   mc_adj_matrix_704                                 1
#> 705   mc_adj_matrix_705                                 1
#> 706   mc_adj_matrix_706                                 1
#> 707   mc_adj_matrix_707                                 1
#> 708   mc_adj_matrix_708                                 1
#> 709   mc_adj_matrix_709                                 1
#> 710   mc_adj_matrix_710                                 1
#> 711   mc_adj_matrix_711                                 1
#> 712   mc_adj_matrix_712                                 1
#> 713   mc_adj_matrix_713                                 1
#> 714   mc_adj_matrix_714                                 1
#> 715   mc_adj_matrix_715                                 1
#> 716   mc_adj_matrix_716                                 1
#> 717   mc_adj_matrix_717                                 1
#> 718   mc_adj_matrix_718                                 1
#> 719   mc_adj_matrix_719                                 1
#> 720   mc_adj_matrix_720                                 1
#> 721   mc_adj_matrix_721                                 1
#> 722   mc_adj_matrix_722                                 1
#> 723   mc_adj_matrix_723                                 1
#> 724   mc_adj_matrix_724                                 1
#> 725   mc_adj_matrix_725                                 1
#> 726   mc_adj_matrix_726                                 1
#> 727   mc_adj_matrix_727                                 1
#> 728   mc_adj_matrix_728                                 1
#> 729   mc_adj_matrix_729                                 1
#> 730   mc_adj_matrix_730                                 1
#> 731   mc_adj_matrix_731                                 1
#> 732   mc_adj_matrix_732                                 1
#> 733   mc_adj_matrix_733                                 1
#> 734   mc_adj_matrix_734                                 1
#> 735   mc_adj_matrix_735                                 1
#> 736   mc_adj_matrix_736                                 1
#> 737   mc_adj_matrix_737                                 1
#> 738   mc_adj_matrix_738                                 1
#> 739   mc_adj_matrix_739                                 1
#> 740   mc_adj_matrix_740                                 1
#> 741   mc_adj_matrix_741                                 1
#> 742   mc_adj_matrix_742                                 1
#> 743   mc_adj_matrix_743                                 1
#> 744   mc_adj_matrix_744                                 1
#> 745   mc_adj_matrix_745                                 1
#> 746   mc_adj_matrix_746                                 1
#> 747   mc_adj_matrix_747                                 1
#> 748   mc_adj_matrix_748                                 1
#> 749   mc_adj_matrix_749                                 1
#> 750   mc_adj_matrix_750                                 1
#> 751   mc_adj_matrix_751                                 1
#> 752   mc_adj_matrix_752                                 1
#> 753   mc_adj_matrix_753                                 1
#> 754   mc_adj_matrix_754                                 1
#> 755   mc_adj_matrix_755                                 1
#> 756   mc_adj_matrix_756                                 1
#> 757   mc_adj_matrix_757                                 1
#> 758   mc_adj_matrix_758                                 1
#> 759   mc_adj_matrix_759                                 1
#> 760   mc_adj_matrix_760                                 1
#> 761   mc_adj_matrix_761                                 1
#> 762   mc_adj_matrix_762                                 1
#> 763   mc_adj_matrix_763                                 1
#> 764   mc_adj_matrix_764                                 1
#> 765   mc_adj_matrix_765                                 1
#> 766   mc_adj_matrix_766                                 1
#> 767   mc_adj_matrix_767                                 1
#> 768   mc_adj_matrix_768                                 1
#> 769   mc_adj_matrix_769                                 1
#> 770   mc_adj_matrix_770                                 1
#> 771   mc_adj_matrix_771                                 1
#> 772   mc_adj_matrix_772                                 1
#> 773   mc_adj_matrix_773                                 1
#> 774   mc_adj_matrix_774                                 1
#> 775   mc_adj_matrix_775                                 1
#> 776   mc_adj_matrix_776                                 1
#> 777   mc_adj_matrix_777                                 1
#> 778   mc_adj_matrix_778                                 1
#> 779   mc_adj_matrix_779                                 1
#> 780   mc_adj_matrix_780                                 1
#> 781   mc_adj_matrix_781                                 1
#> 782   mc_adj_matrix_782                                 1
#> 783   mc_adj_matrix_783                                 1
#> 784   mc_adj_matrix_784                                 1
#> 785   mc_adj_matrix_785                                 1
#> 786   mc_adj_matrix_786                                 1
#> 787   mc_adj_matrix_787                                 1
#> 788   mc_adj_matrix_788                                 1
#> 789   mc_adj_matrix_789                                 1
#> 790   mc_adj_matrix_790                                 1
#> 791   mc_adj_matrix_791                                 1
#> 792   mc_adj_matrix_792                                 1
#> 793   mc_adj_matrix_793                                 1
#> 794   mc_adj_matrix_794                                 1
#> 795   mc_adj_matrix_795                                 1
#> 796   mc_adj_matrix_796                                 1
#> 797   mc_adj_matrix_797                                 1
#> 798   mc_adj_matrix_798                                 1
#> 799   mc_adj_matrix_799                                 1
#> 800   mc_adj_matrix_800                                 1
#> 801   mc_adj_matrix_801                                 1
#> 802   mc_adj_matrix_802                                 1
#> 803   mc_adj_matrix_803                                 1
#> 804   mc_adj_matrix_804                                 1
#> 805   mc_adj_matrix_805                                 1
#> 806   mc_adj_matrix_806                                 1
#> 807   mc_adj_matrix_807                                 1
#> 808   mc_adj_matrix_808                                 1
#> 809   mc_adj_matrix_809                                 1
#> 810   mc_adj_matrix_810                                 1
#> 811   mc_adj_matrix_811                                 1
#> 812   mc_adj_matrix_812                                 1
#> 813   mc_adj_matrix_813                                 1
#> 814   mc_adj_matrix_814                                 1
#> 815   mc_adj_matrix_815                                 1
#> 816   mc_adj_matrix_816                                 1
#> 817   mc_adj_matrix_817                                 1
#> 818   mc_adj_matrix_818                                 1
#> 819   mc_adj_matrix_819                                 1
#> 820   mc_adj_matrix_820                                 1
#> 821   mc_adj_matrix_821                                 1
#> 822   mc_adj_matrix_822                                 1
#> 823   mc_adj_matrix_823                                 1
#> 824   mc_adj_matrix_824                                 1
#> 825   mc_adj_matrix_825                                 1
#> 826   mc_adj_matrix_826                                 1
#> 827   mc_adj_matrix_827                                 1
#> 828   mc_adj_matrix_828                                 1
#> 829   mc_adj_matrix_829                                 1
#> 830   mc_adj_matrix_830                                 1
#> 831   mc_adj_matrix_831                                 1
#> 832   mc_adj_matrix_832                                 1
#> 833   mc_adj_matrix_833                                 1
#> 834   mc_adj_matrix_834                                 1
#> 835   mc_adj_matrix_835                                 1
#> 836   mc_adj_matrix_836                                 1
#> 837   mc_adj_matrix_837                                 1
#> 838   mc_adj_matrix_838                                 1
#> 839   mc_adj_matrix_839                                 1
#> 840   mc_adj_matrix_840                                 1
#> 841   mc_adj_matrix_841                                 1
#> 842   mc_adj_matrix_842                                 1
#> 843   mc_adj_matrix_843                                 1
#> 844   mc_adj_matrix_844                                 1
#> 845   mc_adj_matrix_845                                 1
#> 846   mc_adj_matrix_846                                 1
#> 847   mc_adj_matrix_847                                 1
#> 848   mc_adj_matrix_848                                 1
#> 849   mc_adj_matrix_849                                 1
#> 850   mc_adj_matrix_850                                 1
#> 851   mc_adj_matrix_851                                 1
#> 852   mc_adj_matrix_852                                 1
#> 853   mc_adj_matrix_853                                 1
#> 854   mc_adj_matrix_854                                 1
#> 855   mc_adj_matrix_855                                 1
#> 856   mc_adj_matrix_856                                 1
#> 857   mc_adj_matrix_857                                 1
#> 858   mc_adj_matrix_858                                 1
#> 859   mc_adj_matrix_859                                 1
#> 860   mc_adj_matrix_860                                 1
#> 861   mc_adj_matrix_861                                 1
#> 862   mc_adj_matrix_862                                 1
#> 863   mc_adj_matrix_863                                 1
#> 864   mc_adj_matrix_864                                 1
#> 865   mc_adj_matrix_865                                 1
#> 866   mc_adj_matrix_866                                 1
#> 867   mc_adj_matrix_867                                 1
#> 868   mc_adj_matrix_868                                 1
#> 869   mc_adj_matrix_869                                 1
#> 870   mc_adj_matrix_870                                 1
#> 871   mc_adj_matrix_871                                 1
#> 872   mc_adj_matrix_872                                 1
#> 873   mc_adj_matrix_873                                 1
#> 874   mc_adj_matrix_874                                 1
#> 875   mc_adj_matrix_875                                 1
#> 876   mc_adj_matrix_876                                 1
#> 877   mc_adj_matrix_877                                 1
#> 878   mc_adj_matrix_878                                 1
#> 879   mc_adj_matrix_879                                 1
#> 880   mc_adj_matrix_880                                 1
#> 881   mc_adj_matrix_881                                 1
#> 882   mc_adj_matrix_882                                 1
#> 883   mc_adj_matrix_883                                 1
#> 884   mc_adj_matrix_884                                 1
#> 885   mc_adj_matrix_885                                 1
#> 886   mc_adj_matrix_886                                 1
#> 887   mc_adj_matrix_887                                 1
#> 888   mc_adj_matrix_888                                 1
#> 889   mc_adj_matrix_889                                 1
#> 890   mc_adj_matrix_890                                 1
#> 891   mc_adj_matrix_891                                 1
#> 892   mc_adj_matrix_892                                 1
#> 893   mc_adj_matrix_893                                 1
#> 894   mc_adj_matrix_894                                 1
#> 895   mc_adj_matrix_895                                 1
#> 896   mc_adj_matrix_896                                 1
#> 897   mc_adj_matrix_897                                 1
#> 898   mc_adj_matrix_898                                 1
#> 899   mc_adj_matrix_899                                 1
#> 900   mc_adj_matrix_900                                 1
#> 901   mc_adj_matrix_901                                 1
#> 902   mc_adj_matrix_902                                 1
#> 903   mc_adj_matrix_903                                 1
#> 904   mc_adj_matrix_904                                 1
#> 905   mc_adj_matrix_905                                 1
#> 906   mc_adj_matrix_906                                 1
#> 907   mc_adj_matrix_907                                 1
#> 908   mc_adj_matrix_908                                 1
#> 909   mc_adj_matrix_909                                 1
#> 910   mc_adj_matrix_910                                 1
#> 911   mc_adj_matrix_911                                 1
#> 912   mc_adj_matrix_912                                 1
#> 913   mc_adj_matrix_913                                 1
#> 914   mc_adj_matrix_914                                 1
#> 915   mc_adj_matrix_915                                 1
#> 916   mc_adj_matrix_916                                 1
#> 917   mc_adj_matrix_917                                 1
#> 918   mc_adj_matrix_918                                 1
#> 919   mc_adj_matrix_919                                 1
#> 920   mc_adj_matrix_920                                 1
#> 921   mc_adj_matrix_921                                 1
#> 922   mc_adj_matrix_922                                 1
#> 923   mc_adj_matrix_923                                 1
#> 924   mc_adj_matrix_924                                 1
#> 925   mc_adj_matrix_925                                 1
#> 926   mc_adj_matrix_926                                 1
#> 927   mc_adj_matrix_927                                 1
#> 928   mc_adj_matrix_928                                 1
#> 929   mc_adj_matrix_929                                 1
#> 930   mc_adj_matrix_930                                 1
#> 931   mc_adj_matrix_931                                 1
#> 932   mc_adj_matrix_932                                 1
#> 933   mc_adj_matrix_933                                 1
#> 934   mc_adj_matrix_934                                 1
#> 935   mc_adj_matrix_935                                 1
#> 936   mc_adj_matrix_936                                 1
#> 937   mc_adj_matrix_937                                 1
#> 938   mc_adj_matrix_938                                 1
#> 939   mc_adj_matrix_939                                 1
#> 940   mc_adj_matrix_940                                 1
#> 941   mc_adj_matrix_941                                 1
#> 942   mc_adj_matrix_942                                 1
#> 943   mc_adj_matrix_943                                 1
#> 944   mc_adj_matrix_944                                 1
#> 945   mc_adj_matrix_945                                 1
#> 946   mc_adj_matrix_946                                 1
#> 947   mc_adj_matrix_947                                 1
#> 948   mc_adj_matrix_948                                 1
#> 949   mc_adj_matrix_949                                 1
#> 950   mc_adj_matrix_950                                 1
#> 951   mc_adj_matrix_951                                 1
#> 952   mc_adj_matrix_952                                 1
#> 953   mc_adj_matrix_953                                 1
#> 954   mc_adj_matrix_954                                 1
#> 955   mc_adj_matrix_955                                 1
#> 956   mc_adj_matrix_956                                 1
#> 957   mc_adj_matrix_957                                 1
#> 958   mc_adj_matrix_958                                 1
#> 959   mc_adj_matrix_959                                 1
#> 960   mc_adj_matrix_960                                 1
#> 961   mc_adj_matrix_961                                 1
#> 962   mc_adj_matrix_962                                 1
#> 963   mc_adj_matrix_963                                 1
#> 964   mc_adj_matrix_964                                 1
#> 965   mc_adj_matrix_965                                 1
#> 966   mc_adj_matrix_966                                 1
#> 967   mc_adj_matrix_967                                 1
#> 968   mc_adj_matrix_968                                 1
#> 969   mc_adj_matrix_969                                 1
#> 970   mc_adj_matrix_970                                 1
#> 971   mc_adj_matrix_971                                 1
#> 972   mc_adj_matrix_972                                 1
#> 973   mc_adj_matrix_973                                 1
#> 974   mc_adj_matrix_974                                 1
#> 975   mc_adj_matrix_975                                 1
#> 976   mc_adj_matrix_976                                 1
#> 977   mc_adj_matrix_977                                 1
#> 978   mc_adj_matrix_978                                 1
#> 979   mc_adj_matrix_979                                 1
#> 980   mc_adj_matrix_980                                 1
#> 981   mc_adj_matrix_981                                 1
#> 982   mc_adj_matrix_982                                 1
#> 983   mc_adj_matrix_983                                 1
#> 984   mc_adj_matrix_984                                 1
#> 985   mc_adj_matrix_985                                 1
#> 986   mc_adj_matrix_986                                 1
#> 987   mc_adj_matrix_987                                 1
#> 988   mc_adj_matrix_988                                 1
#> 989   mc_adj_matrix_989                                 1
#> 990   mc_adj_matrix_990                                 1
#> 991   mc_adj_matrix_991                                 1
#> 992   mc_adj_matrix_992                                 1
#> 993   mc_adj_matrix_993                                 1
#> 994   mc_adj_matrix_994                                 1
#> 995   mc_adj_matrix_995                                 1
#> 996   mc_adj_matrix_996                                 1
#> 997   mc_adj_matrix_997                                 1
#> 998   mc_adj_matrix_998                                 1
#> 999   mc_adj_matrix_999                                 1
#> 1000 mc_adj_matrix_1000                                 1
#>      Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1                 0.000000e+00                       0.000000e+00
#> 2                 6.781461e-06                       6.781461e-06
#> 3                 2.018292e-07                       2.018292e-07
#> 4                 6.875648e-06                       6.875648e-06
#> 5                -6.458534e-07                      -6.458534e-07
#> 6                 4.305689e-07                       4.305689e-07
#> 7                -7.534956e-07                      -7.534956e-07
#> 8                 1.668455e-06                       1.668455e-06
#> 9                 1.291707e-06                       1.291707e-06
#> 10                8.073167e-08                       8.073167e-08
#> 11                2.018292e-07                       2.018292e-07
#> 12                6.458534e-07                       6.458534e-07
#> 13                0.000000e+00                       0.000000e+00
#> 14                4.036584e-07                       4.036584e-07
#> 15                1.883739e-07                       1.883739e-07
#> 16                0.000000e+00                       0.000000e+00
#> 17                0.000000e+00                       0.000000e+00
#> 18                0.000000e+00                       0.000000e+00
#> 19                4.171136e-07                       4.171136e-07
#> 20                1.614633e-07                       1.614633e-07
#> 21                1.883739e-07                       1.883739e-07
#> 22                4.171136e-07                       4.171136e-07
#> 23                0.000000e+00                       0.000000e+00
#> 24                0.000000e+00                       0.000000e+00
#> 25                1.668455e-06                       1.668455e-06
#> 26                4.709348e-08                       4.709348e-08
#> 27                0.000000e+00                       0.000000e+00
#> 28                6.875648e-06                       6.875648e-06
#> 29                3.229267e-07                       3.229267e-07
#> 30                5.045730e-09                       5.045730e-09
#> 31                0.000000e+00                       0.000000e+00
#> 32               -2.583414e-06                      -2.583414e-06
#> 33                0.000000e+00                       0.000000e+00
#> 34                1.695365e-06                       1.695365e-06
#> 35                0.000000e+00                       0.000000e+00
#> 36                3.767478e-07                       3.767478e-07
#> 37                1.715548e-06                       1.715548e-06
#> 38               -7.534956e-07                      -7.534956e-07
#> 39               -4.305689e-07                      -4.305689e-07
#> 40               -8.611379e-07                      -8.611379e-07
#> 41                1.708820e-06                       1.708820e-06
#> 42                4.036584e-08                       4.036584e-08
#> 43               -3.767478e-07                      -3.767478e-07
#> 44               -8.073167e-08                      -8.073167e-08
#> 45                3.431096e-06                       3.431096e-06
#> 46               -1.076422e-07                      -1.076422e-07
#> 47                6.781461e-06                       6.781461e-06
#> 48                3.417641e-06                       3.417641e-06
#> 49                0.000000e+00                       0.000000e+00
#> 50                6.727639e-09                       6.727639e-09
#> 51                0.000000e+00                       0.000000e+00
#> 52                0.000000e+00                       0.000000e+00
#> 53                0.000000e+00                       0.000000e+00
#> 54                4.036584e-07                       4.036584e-07
#> 55                8.073167e-08                       8.073167e-08
#> 56                0.000000e+00                       0.000000e+00
#> 57                0.000000e+00                       0.000000e+00
#> 58                3.431096e-06                       3.431096e-06
#> 59                3.013983e-06                       3.013983e-06
#> 60                3.056197e-01                       1.708820e-06
#> 61                3.767478e-07                       3.767478e-07
#> 62                1.883739e-07                       1.883739e-07
#> 63                1.614633e-07                       1.614633e-07
#> 64                0.000000e+00                       0.000000e+00
#> 65                0.000000e+00                       0.000000e+00
#> 66                0.000000e+00                       0.000000e+00
#> 67                2.082887e-01                       1.076422e-07
#> 68                2.691056e-08                       2.691056e-08
#> 69                0.000000e+00                       0.000000e+00
#> 70                8.476826e-07                       8.476826e-07
#> 71                0.000000e+00                       0.000000e+00
#> 72                0.000000e+00                       0.000000e+00
#> 73               -4.305689e-07                      -4.305689e-07
#> 74                0.000000e+00                       0.000000e+00
#> 75                0.000000e+00                       0.000000e+00
#> 76                0.000000e+00                       0.000000e+00
#> 77                0.000000e+00                       0.000000e+00
#> 78                1.883739e-07                       1.883739e-07
#> 79                0.000000e+00                       0.000000e+00
#> 80                1.614633e-07                       1.614633e-07
#> 81                0.000000e+00                       0.000000e+00
#> 82                0.000000e+00                       0.000000e+00
#> 83                5.382112e-08                       5.382112e-08
#> 84               -3.767478e-07                      -3.767478e-07
#> 85                3.437824e-06                       3.437824e-06
#> 86                0.000000e+00                       0.000000e+00
#> 87                0.000000e+00                       0.000000e+00
#> 88                0.000000e+00                       0.000000e+00
#> 89                1.614633e-07                       1.614633e-07
#> 90                0.000000e+00                       0.000000e+00
#> 91                3.417641e-06                       3.417641e-06
#> 92                0.000000e+00                       0.000000e+00
#> 93                1.614633e-06                       1.614633e-06
#> 94               -7.534956e-07                      -7.534956e-07
#> 95                8.342273e-07                       8.342273e-07
#> 96                0.000000e+00                       0.000000e+00
#> 97                3.417641e-06                       3.417641e-06
#> 98                3.229267e-07                       3.229267e-07
#> 99                4.036584e-08                       4.036584e-08
#> 100               0.000000e+00                       0.000000e+00
#> 101               1.708820e-06                       1.708820e-06
#> 102               2.359418e-01                      -7.534956e-07
#> 103               8.073167e-07                       8.073167e-07
#> 104              -8.073167e-07                      -8.073167e-07
#> 105               0.000000e+00                       0.000000e+00
#> 106               3.229267e-06                       3.229267e-06
#> 107              -7.534956e-07                      -7.534956e-07
#> 108               6.835282e-06                       6.835282e-06
#> 109               6.835282e-06                       6.835282e-06
#> 110               3.229267e-07                       3.229267e-07
#> 111               0.000000e+00                       0.000000e+00
#> 112               0.000000e+00                       0.000000e+00
#> 113               0.000000e+00                       0.000000e+00
#> 114               0.000000e+00                       0.000000e+00
#> 115               1.723865e-01                       9.418695e-08
#> 116               4.171136e-07                       4.171136e-07
#> 117               0.000000e+00                       0.000000e+00
#> 118               2.085568e-07                       2.085568e-07
#> 119               1.076422e-07                       1.076422e-07
#> 120               0.000000e+00                       0.000000e+00
#> 121              -5.382112e-08                      -5.382112e-08
#> 122               0.000000e+00                       0.000000e+00
#> 123               0.000000e+00                       0.000000e+00
#> 124               0.000000e+00                       0.000000e+00
#> 125               0.000000e+00                       0.000000e+00
#> 126               0.000000e+00                       0.000000e+00
#> 127               0.000000e+00                       0.000000e+00
#> 128               0.000000e+00                       0.000000e+00
#> 129               2.152845e-07                       2.152845e-07
#> 130               8.342273e-07                       8.342273e-07
#> 131               1.708820e-06                       1.708820e-06
#> 132               0.000000e+00                       0.000000e+00
#> 133               1.614633e-07                       1.614633e-07
#> 134               6.458534e-07                       6.458534e-07
#> 135               0.000000e+00                       0.000000e+00
#> 136               1.076422e-07                       1.076422e-07
#> 137               0.000000e+00                       0.000000e+00
#> 138               1.708820e-06                       1.708820e-06
#> 139               1.708820e-06                       1.708820e-06
#> 140               0.000000e+00                       0.000000e+00
#> 141               1.291707e-06                       1.291707e-06
#> 142               1.524199e-01                       0.000000e+00
#> 143               0.000000e+00                       0.000000e+00
#> 144               8.476826e-07                       8.476826e-07
#> 145               1.009146e-07                       1.009146e-07
#> 146               6.882375e-06                       6.882375e-06
#> 147               1.614633e-07                       1.614633e-07
#> 148               0.000000e+00                       0.000000e+00
#> 149               7.534956e-07                       7.534956e-07
#> 150               1.614633e-07                       1.614633e-07
#> 151               5.382112e-08                       5.382112e-08
#> 152              -1.614633e-06                      -1.614633e-06
#> 153               0.000000e+00                       0.000000e+00
#> 154               3.229267e-07                       3.229267e-07
#> 155               0.000000e+00                       0.000000e+00
#> 156               2.152845e-07                       2.152845e-07
#> 157               0.000000e+00                       0.000000e+00
#> 158               3.417641e-06                       3.417641e-06
#> 159               2.018292e-07                       2.018292e-07
#> 160               8.342273e-07                       8.342273e-07
#> 161               0.000000e+00                       0.000000e+00
#> 162               0.000000e+00                       0.000000e+00
#> 163               1.883739e-07                       1.883739e-07
#> 164               1.614633e-07                       1.614633e-07
#> 165              -1.076422e-07                      -1.076422e-07
#> 166               0.000000e+00                       0.000000e+00
#> 167              -2.152845e-07                      -2.152845e-07
#> 168               0.000000e+00                       0.000000e+00
#> 169               1.883739e-07                       1.883739e-07
#> 170               4.171136e-07                       4.171136e-07
#> 171              -1.076422e-07                       6.580417e-07
#> 172               0.000000e+00                       0.000000e+00
#> 173              -3.229267e-07                      -3.229267e-07
#> 174               1.076422e-07                       1.076422e-07
#> 175               1.883739e-07                       1.883739e-07
#> 176               7.534956e-07                       7.534956e-07
#> 177               7.534956e-07                       7.534956e-07
#> 178               6.835282e-06                       6.835282e-06
#> 179               2.144435e-07                       2.144435e-07
#> 180              -3.229267e-07                      -3.229267e-07
#> 181               3.390730e-06                       3.390730e-06
#> 182               3.417641e-06                       3.417641e-06
#> 183               1.614633e-07                       1.614633e-07
#> 184              -2.018292e-07                      -2.018292e-07
#> 185              -8.342273e-07                      -8.342273e-07
#> 186               8.544102e-07                       8.544102e-07
#> 187               0.000000e+00                       0.000000e+00
#> 188               3.390730e-06                       3.390730e-06
#> 189               0.000000e+00                       0.000000e+00
#> 190               1.883739e-07                       1.883739e-07
#> 191               0.000000e+00                       0.000000e+00
#> 192               3.390730e-06                       3.390730e-06
#> 193               8.073167e-07                       8.073167e-07
#> 194               4.709348e-08                       4.709348e-08
#> 195               2.948995e-01                      -3.767478e-07
#> 196               0.000000e+00                       0.000000e+00
#> 197               0.000000e+00                       0.000000e+00
#> 198              -8.073167e-08                      -8.073167e-08
#> 199               0.000000e+00                       0.000000e+00
#> 200               8.544102e-07                       8.544102e-07
#> 201               0.000000e+00                       0.000000e+00
#> 202               3.437824e-06                       3.437824e-06
#> 203               8.611379e-07                       8.611379e-07
#> 204               0.000000e+00                       0.000000e+00
#> 205              -1.076422e-07                      -1.076422e-07
#> 206               0.000000e+00                       0.000000e+00
#> 207               0.000000e+00                       0.000000e+00
#> 208               8.342273e-07                       8.342273e-07
#> 209               0.000000e+00                       0.000000e+00
#> 210               8.476826e-07                       8.476826e-07
#> 211               1.668455e-06                       1.668455e-06
#> 212               0.000000e+00                       0.000000e+00
#> 213               1.076422e-07                       1.076422e-07
#> 214               2.018292e-07                       2.018292e-07
#> 215               2.152845e-07                       2.152845e-07
#> 216               0.000000e+00                       0.000000e+00
#> 217               0.000000e+00                       0.000000e+00
#> 218               0.000000e+00                       0.000000e+00
#> 219               0.000000e+00                       0.000000e+00
#> 220               0.000000e+00                       0.000000e+00
#> 221               0.000000e+00                       0.000000e+00
#> 222               0.000000e+00                       0.000000e+00
#> 223               0.000000e+00                       0.000000e+00
#> 224               8.342273e-07                       8.342273e-07
#> 225               0.000000e+00                       0.000000e+00
#> 226               2.691056e-08                       2.691056e-08
#> 227               2.963653e-01                       5.382112e-08
#> 228               0.000000e+00                       0.000000e+00
#> 229               3.013983e-06                       3.013983e-06
#> 230               1.839579e-01                       8.577740e-07
#> 231               6.885739e-06                       6.885739e-06
#> 232               3.004644e-01                      -1.076422e-07
#> 233              -1.076422e-07                      -1.076422e-07
#> 234               1.614633e-07                       1.614633e-07
#> 235               0.000000e+00                       0.000000e+00
#> 236              -3.767478e-07                      -3.767478e-07
#> 237               0.000000e+00                       0.000000e+00
#> 238               0.000000e+00                       0.000000e+00
#> 239               0.000000e+00                       0.000000e+00
#> 240               0.000000e+00                       0.000000e+00
#> 241               0.000000e+00                       0.000000e+00
#> 242               0.000000e+00                       0.000000e+00
#> 243               1.614633e-07                       1.614633e-07
#> 244               0.000000e+00                       0.000000e+00
#> 245               0.000000e+00                       0.000000e+00
#> 246               1.708820e-06                       1.708820e-06
#> 247               0.000000e+00                       0.000000e+00
#> 248               0.000000e+00                       0.000000e+00
#> 249               6.781461e-06                       6.781461e-06
#> 250               3.767478e-07                       3.767478e-07
#> 251               1.695365e-06                       1.695365e-06
#> 252               8.342273e-07                       8.342273e-07
#> 253               1.076422e-07                       1.076422e-07
#> 254               0.000000e+00                       0.000000e+00
#> 255               0.000000e+00                       0.000000e+00
#> 256               0.000000e+00                       0.000000e+00
#> 257               8.073167e-07                       8.073167e-07
#> 258              -7.534956e-07                      -7.534956e-07
#> 259               1.695365e-06                       1.695365e-06
#> 260               1.614633e-06                       1.614633e-06
#> 261               2.018292e-08                       2.018292e-08
#> 262               0.000000e+00                       0.000000e+00
#> 263               4.238413e-07                       4.238413e-07
#> 264               1.668455e-06                       1.668455e-06
#> 265               6.882375e-06                       6.882375e-06
#> 266               0.000000e+00                       0.000000e+00
#> 267               0.000000e+00                       0.000000e+00
#> 268               1.715548e-06                       1.715548e-06
#> 269               2.678925e-01                       1.722065e-06
#> 270               4.036584e-07                       4.036584e-07
#> 271               1.668455e-06                      -8.984677e-06
#> 272               0.000000e+00                       0.000000e+00
#> 273               0.000000e+00                       0.000000e+00
#> 274               0.000000e+00                       0.000000e+00
#> 275               2.656960e-01                       4.036584e-07
#> 276               1.009146e-07                       1.009146e-07
#> 277               0.000000e+00                       0.000000e+00
#> 278               1.708820e-06                       1.708820e-06
#> 279               0.000000e+00                       0.000000e+00
#> 280               0.000000e+00                       0.000000e+00
#> 281               0.000000e+00                       0.000000e+00
#> 282               8.073167e-08                       8.073167e-08
#> 283               0.000000e+00                       0.000000e+00
#> 284               0.000000e+00                       0.000000e+00
#> 285              -4.305689e-07                      -4.305689e-07
#> 286               0.000000e+00                       0.000000e+00
#> 287              -4.305689e-07                      -4.305689e-07
#> 288               1.708820e-06                       1.708820e-06
#> 289               7.534956e-07                       7.534956e-07
#> 290               0.000000e+00                       0.000000e+00
#> 291               0.000000e+00                       0.000000e+00
#> 292               0.000000e+00                       0.000000e+00
#> 293               0.000000e+00                       0.000000e+00
#> 294               0.000000e+00                       0.000000e+00
#> 295               0.000000e+00                       0.000000e+00
#> 296               0.000000e+00                       0.000000e+00
#> 297               0.000000e+00                       0.000000e+00
#> 298              -1.614633e-07                      -1.614633e-07
#> 299               0.000000e+00                       0.000000e+00
#> 300               1.076422e-07                       1.076422e-07
#> 301               0.000000e+00                       0.000000e+00
#> 302               8.342273e-07                       8.342273e-07
#> 303               0.000000e+00                       0.000000e+00
#> 304               4.171136e-07                       4.171136e-07
#> 305               0.000000e+00                       0.000000e+00
#> 306              -1.614633e-07                      -1.614633e-07
#> 307               5.382112e-08                       5.382112e-08
#> 308               0.000000e+00                       0.000000e+00
#> 309               0.000000e+00                       0.000000e+00
#> 310               1.614633e-06                       1.614633e-06
#> 311               0.000000e+00                       0.000000e+00
#> 312               0.000000e+00                       0.000000e+00
#> 313               0.000000e+00                       0.000000e+00
#> 314               0.000000e+00                       0.000000e+00
#> 315               0.000000e+00                       0.000000e+00
#> 316               0.000000e+00                       0.000000e+00
#> 317               0.000000e+00                       0.000000e+00
#> 318               8.073167e-07                       8.073167e-07
#> 319               2.152845e-07                       2.152845e-07
#> 320               1.076422e-07                       1.076422e-07
#> 321               1.076422e-07                       1.076422e-07
#> 322               5.382112e-08                       5.382112e-08
#> 323               4.171136e-07                       4.171136e-07
#> 324              -8.611379e-07                      -8.611379e-07
#> 325              -1.614633e-07                      -1.614633e-07
#> 326               0.000000e+00                       0.000000e+00
#> 327               0.000000e+00                       0.000000e+00
#> 328               8.476826e-07                       8.476826e-07
#> 329               1.708820e-06                       1.708820e-06
#> 330               0.000000e+00                       0.000000e+00
#> 331              -8.073167e-07                      -8.073167e-07
#> 332               0.000000e+00                       0.000000e+00
#> 333               1.506991e-06                       1.506991e-06
#> 334               6.458534e-07                       6.458534e-07
#> 335               4.171136e-07                       4.171136e-07
#> 336               7.534956e-07                       7.534956e-07
#> 337               3.437824e-06                       3.437824e-06
#> 338               0.000000e+00                       0.000000e+00
#> 339               0.000000e+00                       0.000000e+00
#> 340               0.000000e+00                       0.000000e+00
#> 341               1.076422e-07                       1.076422e-07
#> 342               8.611379e-07                       8.611379e-07
#> 343               3.390730e-06                       3.390730e-06
#> 344               1.076422e-07                       1.076422e-07
#> 345               0.000000e+00                       0.000000e+00
#> 346               1.076422e-07                       1.076422e-07
#> 347               0.000000e+00                       0.000000e+00
#> 348               3.229267e-07                       3.229267e-07
#> 349               7.534956e-07                       7.534956e-07
#> 350               4.036584e-07                       4.036584e-07
#> 351               0.000000e+00                       0.000000e+00
#> 352               6.027965e-06                       6.027965e-06
#> 353               0.000000e+00                       0.000000e+00
#> 354               8.073167e-07                       8.073167e-07
#> 355               6.781461e-06                       6.781461e-06
#> 356               0.000000e+00                       0.000000e+00
#> 357               0.000000e+00                       0.000000e+00
#> 358               0.000000e+00                       0.000000e+00
#> 359               0.000000e+00                       0.000000e+00
#> 360               8.476826e-07                       8.476826e-07
#> 361               3.767478e-07                       3.767478e-07
#> 362               0.000000e+00                       0.000000e+00
#> 363               8.476826e-07                       8.476826e-07
#> 364               3.336909e-06                       3.336909e-06
#> 365               1.883739e-07                       1.883739e-07
#> 366               2.102387e-10                       2.102387e-10
#> 367               0.000000e+00                       0.000000e+00
#> 368               5.382112e-08                       5.382112e-08
#> 369               0.000000e+00                       0.000000e+00
#> 370               6.875648e-06                       6.875648e-06
#> 371              -7.534956e-07                      -7.534956e-07
#> 372               4.238413e-07                       4.238413e-07
#> 373              -1.076422e-07                      -1.076422e-07
#> 374               0.000000e+00                       0.000000e+00
#> 375               0.000000e+00                       0.000000e+00
#> 376               3.174085e-01                       2.152779e-07
#> 377               1.009146e-07                       1.009146e-07
#> 378              -1.076422e-07                      -1.076422e-07
#> 379               1.883739e-07                       1.883739e-07
#> 380               0.000000e+00                       0.000000e+00
#> 381               8.342273e-07                       8.342273e-07
#> 382               0.000000e+00                       0.000000e+00
#> 383               4.171136e-07                       4.171136e-07
#> 384               0.000000e+00                       0.000000e+00
#> 385               2.152845e-07                       2.152845e-07
#> 386               8.073167e-07                       8.073167e-07
#> 387               1.076422e-07                       1.076422e-07
#> 388               1.009146e-07                       1.009146e-07
#> 389               0.000000e+00                       0.000000e+00
#> 390               1.668455e-06                       1.668455e-06
#> 391              -1.291707e-06                      -1.291707e-06
#> 392              -3.013983e-06                      -3.013983e-06
#> 393               8.476826e-07                       8.476826e-07
#> 394               3.767478e-07                       3.767478e-07
#> 395               0.000000e+00                       0.000000e+00
#> 396               3.229267e-07                       3.229267e-07
#> 397               0.000000e+00                       0.000000e+00
#> 398               2.191649e-01                       6.307162e-09
#> 399               0.000000e+00                       0.000000e+00
#> 400               0.000000e+00                       0.000000e+00
#> 401               5.382112e-08                       5.382112e-08
#> 402               0.000000e+00                       0.000000e+00
#> 403               1.695365e-06                       1.695365e-06
#> 404               4.709348e-08                       4.709348e-08
#> 405               0.000000e+00                       0.000000e+00
#> 406               8.602969e-07                       8.602969e-07
#> 407               0.000000e+00                       0.000000e+00
#> 408               0.000000e+00                       0.000000e+00
#> 409               8.476826e-07                      -1.042382e-05
#> 410               1.705280e-01                       8.577740e-07
#> 411              -7.534956e-07                      -7.534956e-07
#> 412               0.000000e+00                       0.000000e+00
#> 413               0.000000e+00                       0.000000e+00
#> 414               3.767478e-07                       3.767478e-07
#> 415               8.342273e-07                       8.342273e-07
#> 416               6.781461e-06                       6.781461e-06
#> 417               2.018292e-07                       2.018292e-07
#> 418               0.000000e+00                       0.000000e+00
#> 419               0.000000e+00                       0.000000e+00
#> 420               8.073167e-07                       8.073167e-07
#> 421               0.000000e+00                       0.000000e+00
#> 422               0.000000e+00                       0.000000e+00
#> 423              -7.534956e-07                      -7.534956e-07
#> 424               8.342273e-07                       8.342273e-07
#> 425               3.336909e-06                       3.336909e-06
#> 426               0.000000e+00                       0.000000e+00
#> 427              -1.506991e-06                      -1.506991e-06
#> 428               4.238413e-07                       4.238413e-07
#> 429               1.883739e-07                       1.883739e-07
#> 430               3.229267e-07                       3.229267e-07
#> 431               1.614633e-06                       1.614633e-06
#> 432              -1.076422e-07                      -1.076422e-07
#> 433               0.000000e+00                       0.000000e+00
#> 434              -2.152845e-07                      -2.152845e-07
#> 435               4.171136e-07                       4.171136e-07
#> 436               0.000000e+00                       0.000000e+00
#> 437               0.000000e+00                       0.000000e+00
#> 438               1.883739e-07                       1.883739e-07
#> 439               0.000000e+00                       0.000000e+00
#> 440              -3.767478e-07                      -3.767478e-07
#> 441               0.000000e+00                       0.000000e+00
#> 442               2.691056e-08                       2.691056e-08
#> 443               0.000000e+00                       0.000000e+00
#> 444               4.171136e-07                       4.171136e-07
#> 445               1.297208e-01                      -1.614633e-07
#> 446               0.000000e+00                       0.000000e+00
#> 447               3.229267e-07                       3.229267e-07
#> 448               7.534956e-07                       7.534956e-07
#> 449               8.073167e-08                       8.073167e-08
#> 450               0.000000e+00                       0.000000e+00
#> 451               3.437824e-06                       3.437824e-06
#> 452               0.000000e+00                       0.000000e+00
#> 453               0.000000e+00                       0.000000e+00
#> 454              -1.722276e-06                      -1.722276e-06
#> 455               3.336909e-06                       3.336909e-06
#> 456              -6.458534e-07                      -6.458534e-07
#> 457               0.000000e+00                       0.000000e+00
#> 458               1.708820e-06                       1.708820e-06
#> 459               2.742175e-01                       7.534956e-07
#> 460               4.036584e-07                       4.036584e-07
#> 461               1.695365e-06                       1.695365e-06
#> 462               0.000000e+00                       0.000000e+00
#> 463               1.614633e-06                       1.614633e-06
#> 464               1.883739e-07                       1.883739e-07
#> 465               2.471377e-01                       6.862192e-06
#> 466               0.000000e+00                       0.000000e+00
#> 467               0.000000e+00                       0.000000e+00
#> 468               1.883739e-07                       1.883739e-07
#> 469               0.000000e+00                       0.000000e+00
#> 470               0.000000e+00                       0.000000e+00
#> 471               1.718912e-06                       1.718912e-06
#> 472              -3.767478e-07                      -3.767478e-07
#> 473              -4.305689e-07                      -4.305689e-07
#> 474               0.000000e+00                       0.000000e+00
#> 475               3.441188e-06                       3.441188e-06
#> 476               0.000000e+00                       0.000000e+00
#> 477               0.000000e+00                       0.000000e+00
#> 478               3.437824e-06                       3.437824e-06
#> 479               0.000000e+00                       0.000000e+00
#> 480               0.000000e+00                       0.000000e+00
#> 481               0.000000e+00                       0.000000e+00
#> 482               0.000000e+00                       0.000000e+00
#> 483               8.476826e-07                       8.476826e-07
#> 484               0.000000e+00                       0.000000e+00
#> 485              -4.305689e-07                      -4.305689e-07
#> 486               4.036584e-07                       4.036584e-07
#> 487               0.000000e+00                       0.000000e+00
#> 488              -4.305689e-07                      -4.305689e-07
#> 489               0.000000e+00                       0.000000e+00
#> 490               0.000000e+00                       0.000000e+00
#> 491               8.342273e-07                      -7.621268e-06
#> 492              -4.305689e-07                      -4.305689e-07
#> 493               8.073167e-07                       8.073167e-07
#> 494               3.229267e-07                       3.229267e-07
#> 495              -4.305689e-07                      -4.305689e-07
#> 496               5.382112e-08                       5.382112e-08
#> 497               3.437824e-06                       3.437824e-06
#> 498               4.238413e-07                       4.238413e-07
#> 499               6.458534e-07                       6.458534e-07
#> 500               0.000000e+00                       0.000000e+00
#> 501               0.000000e+00                       0.000000e+00
#> 502              -8.611379e-07                      -8.611379e-07
#> 503               2.018292e-07                       2.018292e-07
#> 504               0.000000e+00                       0.000000e+00
#> 505               6.875648e-06                       6.875648e-06
#> 506               1.009146e-07                       1.009146e-07
#> 507               8.342273e-07                       8.342273e-07
#> 508               6.882375e-06                       6.882375e-06
#> 509               0.000000e+00                       0.000000e+00
#> 510               0.000000e+00                       0.000000e+00
#> 511               1.076422e-07                       1.076422e-07
#> 512               0.000000e+00                       0.000000e+00
#> 513               4.238413e-07                       4.238413e-07
#> 514               5.382112e-08                       5.382112e-08
#> 515               1.614633e-07                       1.614633e-07
#> 516               2.018292e-07                       2.018292e-07
#> 517               1.883739e-07                       1.883739e-07
#> 518               0.000000e+00                       0.000000e+00
#> 519               3.767478e-07                       3.767478e-07
#> 520               1.715548e-06                       1.715548e-06
#> 521               1.695365e-06                       1.695365e-06
#> 522               0.000000e+00                       0.000000e+00
#> 523               3.767478e-07                       3.767478e-07
#> 524               8.602969e-07                       8.602969e-07
#> 525               0.000000e+00                       0.000000e+00
#> 526               1.708820e-06                       1.708820e-06
#> 527               0.000000e+00                       0.000000e+00
#> 528               0.000000e+00                       0.000000e+00
#> 529               2.691056e-08                       2.691056e-08
#> 530               0.000000e+00                       0.000000e+00
#> 531               0.000000e+00                       0.000000e+00
#> 532               0.000000e+00                       0.000000e+00
#> 533               0.000000e+00                       0.000000e+00
#> 534               4.036584e-07                       4.036584e-07
#> 535               0.000000e+00                       0.000000e+00
#> 536               0.000000e+00                       0.000000e+00
#> 537               5.382112e-08                       5.382112e-08
#> 538               0.000000e+00                       0.000000e+00
#> 539               0.000000e+00                       0.000000e+00
#> 540               2.018292e-07                       2.018292e-07
#> 541               1.708820e-06                      -5.515155e-06
#> 542               4.238413e-07                       4.238413e-07
#> 543               0.000000e+00                       0.000000e+00
#> 544               0.000000e+00                       0.000000e+00
#> 545               0.000000e+00                       0.000000e+00
#> 546               8.544102e-07                       8.544102e-07
#> 547               0.000000e+00                       0.000000e+00
#> 548               0.000000e+00                       0.000000e+00
#> 549               8.342273e-07                       8.342273e-07
#> 550               0.000000e+00                       0.000000e+00
#> 551               1.883739e-07                       1.883739e-07
#> 552               0.000000e+00                       0.000000e+00
#> 553              -1.506991e-06                      -1.506991e-06
#> 554               0.000000e+00                       0.000000e+00
#> 555              -3.767478e-07                      -3.767478e-07
#> 556              -6.458534e-07                      -6.458534e-07
#> 557              -2.152845e-07                      -2.152845e-07
#> 558               0.000000e+00                       0.000000e+00
#> 559               4.171136e-07                       4.171136e-07
#> 560               5.382112e-08                      -7.901926e-07
#> 561               0.000000e+00                       0.000000e+00
#> 562               8.342273e-07                       8.342273e-07
#> 563               8.476826e-07                       8.476826e-07
#> 564               4.171136e-07                       4.171136e-07
#> 565               0.000000e+00                       0.000000e+00
#> 566               0.000000e+00                       0.000000e+00
#> 567              -2.691056e-08                      -2.691056e-08
#> 568               0.000000e+00                       0.000000e+00
#> 569              -4.305689e-07                      -4.305689e-07
#> 570               8.342273e-07                       8.342273e-07
#> 571               5.382112e-08                       5.382112e-08
#> 572              -4.305689e-07                      -4.305689e-07
#> 573               0.000000e+00                       0.000000e+00
#> 574               1.883739e-07                       1.883739e-07
#> 575               1.009146e-07                       1.009146e-07
#> 576               1.883739e-07                       1.883739e-07
#> 577               1.150829e-01                       5.382112e-08
#> 578               8.073167e-08                       8.073167e-08
#> 579               4.036584e-07                       4.036584e-07
#> 580               0.000000e+00                       0.000000e+00
#> 581               0.000000e+00                       0.000000e+00
#> 582               0.000000e+00                       0.000000e+00
#> 583               0.000000e+00                       0.000000e+00
#> 584               0.000000e+00                       0.000000e+00
#> 585              -2.583414e-06                      -2.583414e-06
#> 586               0.000000e+00                       0.000000e+00
#> 587               1.076422e-07                       1.076422e-07
#> 588               8.073167e-07                       8.073167e-07
#> 589               0.000000e+00                       0.000000e+00
#> 590               0.000000e+00                       0.000000e+00
#> 591               0.000000e+00                       0.000000e+00
#> 592               1.708820e-06                      -7.431832e-06
#> 593               3.767478e-07                       3.767478e-07
#> 594              -1.681910e-09                      -1.681910e-09
#> 595              -1.076422e-07                      -1.076422e-07
#> 596               1.695365e-06                       1.695365e-06
#> 597               1.572797e-01                       1.291707e-06
#> 598               0.000000e+00                       0.000000e+00
#> 599               3.767478e-07                       3.767478e-07
#> 600               2.220428e-01                       3.229267e-06
#> 601               4.238413e-07                       4.238413e-07
#> 602               1.614633e-07                       1.614633e-07
#> 603               0.000000e+00                       0.000000e+00
#> 604              -1.076422e-07                      -1.076422e-07
#> 605               0.000000e+00                       0.000000e+00
#> 606               3.417641e-06                       3.417641e-06
#> 607               1.715548e-06                       1.715548e-06
#> 608               0.000000e+00                       0.000000e+00
#> 609               3.390730e-06                       3.390730e-06
#> 610               6.862192e-06                       6.862192e-06
#> 611               3.431096e-06                       3.431096e-06
#> 612               0.000000e+00                       0.000000e+00
#> 613               0.000000e+00                       0.000000e+00
#> 614               3.767478e-07                       3.767478e-07
#> 615               0.000000e+00                       0.000000e+00
#> 616               2.220439e-01                       0.000000e+00
#> 617               4.171136e-07                       4.171136e-07
#> 618               1.614633e-07                       1.614633e-07
#> 619               1.668455e-06                       1.668455e-06
#> 620              -4.305689e-07                      -4.305689e-07
#> 621               0.000000e+00                       0.000000e+00
#> 622               0.000000e+00                       0.000000e+00
#> 623               0.000000e+00                       0.000000e+00
#> 624               0.000000e+00                       0.000000e+00
#> 625               4.036584e-07                       4.036584e-07
#> 626              -1.291707e-06                      -1.291707e-06
#> 627               0.000000e+00                       0.000000e+00
#> 628               3.767478e-07                       3.767478e-07
#> 629               7.534956e-07                       7.534956e-07
#> 630               0.000000e+00                       0.000000e+00
#> 631               0.000000e+00                       0.000000e+00
#> 632               0.000000e+00                       0.000000e+00
#> 633               0.000000e+00                       0.000000e+00
#> 634               8.476826e-07                       8.476826e-07
#> 635               2.152845e-07                       2.152845e-07
#> 636               4.171136e-07                       4.171136e-07
#> 637              -7.534956e-07                      -7.534956e-07
#> 638               1.059603e-07                       1.059603e-07
#> 639               0.000000e+00                       0.000000e+00
#> 640               4.288870e-07                       4.288870e-07
#> 641               8.342273e-07                       8.342273e-07
#> 642               0.000000e+00                       0.000000e+00
#> 643               6.458534e-07                       6.458534e-07
#> 644               8.476826e-07                       8.476826e-07
#> 645               1.708820e-06                       1.708820e-06
#> 646               0.000000e+00                       0.000000e+00
#> 647               1.614633e-07                       1.614633e-07
#> 648               3.767478e-07                       3.767478e-07
#> 649               3.336909e-06                       3.336909e-06
#> 650               2.040854e-01                       1.506991e-06
#> 651               2.018292e-07                       2.018292e-07
#> 652               1.883739e-07                       1.883739e-07
#> 653               0.000000e+00                       0.000000e+00
#> 654               6.835282e-06                       6.835282e-06
#> 655               8.073167e-07                       8.073167e-07
#> 656               0.000000e+00                       0.000000e+00
#> 657               0.000000e+00                       0.000000e+00
#> 658               1.883739e-07                       1.883739e-07
#> 659               8.611379e-07                       8.611379e-07
#> 660               4.036584e-07                       4.036584e-07
#> 661               0.000000e+00                       0.000000e+00
#> 662              -6.458534e-07                      -6.458534e-07
#> 663               8.073167e-08                      -7.173507e-07
#> 664               0.000000e+00                       0.000000e+00
#> 665               0.000000e+00                       0.000000e+00
#> 666               3.013983e-06                       3.013983e-06
#> 667               1.883739e-07                       1.883739e-07
#> 668               0.000000e+00                       0.000000e+00
#> 669               0.000000e+00                       0.000000e+00
#> 670               3.767478e-07                       3.767478e-07
#> 671               0.000000e+00                       0.000000e+00
#> 672               4.272051e-07                       4.272051e-07
#> 673              -7.534956e-07                      -7.534956e-07
#> 674               0.000000e+00                       0.000000e+00
#> 675               0.000000e+00                       0.000000e+00
#> 676               1.555984e-01                      -3.767478e-07
#> 677              -1.076422e-07                      -1.076422e-07
#> 678               0.000000e+00                       0.000000e+00
#> 679               1.883739e-07                       1.883739e-07
#> 680               0.000000e+00                       0.000000e+00
#> 681               1.345528e-08                       1.345528e-08
#> 682               3.437824e-06                       3.437824e-06
#> 683               0.000000e+00                       0.000000e+00
#> 684               4.036584e-07                       4.036584e-07
#> 685               1.883739e-07                       1.883739e-07
#> 686               0.000000e+00                       0.000000e+00
#> 687               8.544102e-07                       8.544102e-07
#> 688               0.000000e+00                       0.000000e+00
#> 689               8.342273e-07                       8.342273e-07
#> 690               0.000000e+00                       0.000000e+00
#> 691               0.000000e+00                       0.000000e+00
#> 692               6.673818e-06                       6.673818e-06
#> 693               1.506991e-06                       1.506991e-06
#> 694               0.000000e+00                       0.000000e+00
#> 695               8.073167e-07                      -6.712044e-06
#> 696               0.000000e+00                       0.000000e+00
#> 697               1.688660e-01                       0.000000e+00
#> 698               3.229267e-07                       3.229267e-07
#> 699               1.614633e-07                       1.614633e-07
#> 700               1.695365e-06                       1.695365e-06
#> 701               0.000000e+00                       0.000000e+00
#> 702               4.272051e-07                       4.272051e-07
#> 703               2.388889e-01                       2.144435e-07
#> 704               6.673818e-06                       6.673818e-06
#> 705               3.013983e-06                       3.013983e-06
#> 706               4.036584e-07                       4.036584e-07
#> 707              -1.291707e-06                      -1.291707e-06
#> 708               8.476826e-07                       8.476826e-07
#> 709               4.272051e-07                       4.272051e-07
#> 710               0.000000e+00                       0.000000e+00
#> 711               0.000000e+00                       0.000000e+00
#> 712               1.883739e-07                       1.883739e-07
#> 713               0.000000e+00                       0.000000e+00
#> 714               1.668455e-06                       1.668455e-06
#> 715               3.229267e-07                       3.229267e-07
#> 716               1.614633e-06                       1.614633e-06
#> 717               0.000000e+00                       0.000000e+00
#> 718               8.476826e-07                       8.476826e-07
#> 719               0.000000e+00                       0.000000e+00
#> 720               0.000000e+00                       0.000000e+00
#> 721               0.000000e+00                       0.000000e+00
#> 722               0.000000e+00                       0.000000e+00
#> 723               0.000000e+00                       0.000000e+00
#> 724              -1.076422e-07                      -1.076422e-07
#> 725               0.000000e+00                       0.000000e+00
#> 726               1.009146e-07                       1.009146e-07
#> 727               0.000000e+00                       0.000000e+00
#> 728              -1.076422e-07                      -1.076422e-07
#> 729               1.715548e-06                       1.715548e-06
#> 730               0.000000e+00                       0.000000e+00
#> 731               8.476826e-07                       8.476826e-07
#> 732               8.073167e-08                       8.073167e-08
#> 733               4.036584e-07                       4.036584e-07
#> 734              -6.458534e-07                      -6.458534e-07
#> 735               0.000000e+00                       0.000000e+00
#> 736               0.000000e+00                       0.000000e+00
#> 737               1.695365e-06                       1.695365e-06
#> 738               3.767478e-07                       3.767478e-07
#> 739              -8.611379e-07                      -8.611379e-07
#> 740               5.382112e-08                       5.382112e-08
#> 741               3.431096e-06                       3.431096e-06
#> 742               4.171136e-07                       4.171136e-07
#> 743               0.000000e+00                       0.000000e+00
#> 744               0.000000e+00                       0.000000e+00
#> 745               0.000000e+00                       0.000000e+00
#> 746               0.000000e+00                       0.000000e+00
#> 747               0.000000e+00                       0.000000e+00
#> 748               0.000000e+00                       0.000000e+00
#> 749               3.390730e-06                       3.390730e-06
#> 750              -1.614633e-07                      -1.614633e-07
#> 751               0.000000e+00                       0.000000e+00
#> 752              -5.255973e-11                      -5.255973e-11
#> 753              -4.305689e-07                      -4.305689e-07
#> 754               1.718912e-06                       1.718912e-06
#> 755               4.171136e-07                       4.171136e-07
#> 756               0.000000e+00                       0.000000e+00
#> 757               0.000000e+00                       0.000000e+00
#> 758               2.419042e-01                      -3.767478e-07
#> 759              -7.534956e-07                      -7.534956e-07
#> 760               0.000000e+00                       0.000000e+00
#> 761               5.382112e-08                       5.382112e-08
#> 762               1.695365e-06                       1.695365e-06
#> 763               0.000000e+00                       0.000000e+00
#> 764               7.534956e-07                       7.534956e-07
#> 765               0.000000e+00                       0.000000e+00
#> 766              -3.767478e-07                      -3.767478e-07
#> 767               0.000000e+00                       0.000000e+00
#> 768               1.076422e-07                       1.076422e-07
#> 769               0.000000e+00                       0.000000e+00
#> 770               0.000000e+00                       0.000000e+00
#> 771               0.000000e+00                       0.000000e+00
#> 772               1.883739e-07                       1.883739e-07
#> 773               0.000000e+00                       0.000000e+00
#> 774               0.000000e+00                       0.000000e+00
#> 775               8.544102e-07                       8.544102e-07
#> 776               1.614633e-07                       1.614633e-07
#> 777               0.000000e+00                       0.000000e+00
#> 778               0.000000e+00                       0.000000e+00
#> 779              -1.076422e-07                      -1.076422e-07
#> 780              -1.506991e-06                      -1.506991e-06
#> 781              -1.076422e-07                      -1.076422e-07
#> 782               8.476826e-07                       8.476826e-07
#> 783               7.534956e-07                       7.534956e-07
#> 784               0.000000e+00                       0.000000e+00
#> 785               0.000000e+00                       0.000000e+00
#> 786               4.036584e-07                       4.036584e-07
#> 787               0.000000e+00                       0.000000e+00
#> 788               0.000000e+00                       0.000000e+00
#> 789               0.000000e+00                       0.000000e+00
#> 790               0.000000e+00                       0.000000e+00
#> 791               0.000000e+00                       0.000000e+00
#> 792               0.000000e+00                       0.000000e+00
#> 793               0.000000e+00                       0.000000e+00
#> 794               0.000000e+00                       0.000000e+00
#> 795               6.835282e-06                       6.835282e-06
#> 796               0.000000e+00                       0.000000e+00
#> 797              -6.458534e-07                      -6.458534e-07
#> 798               1.668455e-06                       1.668455e-06
#> 799               4.036584e-07                       4.036584e-07
#> 800               0.000000e+00                       0.000000e+00
#> 801               0.000000e+00                       0.000000e+00
#> 802              -4.305689e-07                      -4.305689e-07
#> 803               0.000000e+00                       0.000000e+00
#> 804               0.000000e+00                       0.000000e+00
#> 805               1.695365e-06                       1.695365e-06
#> 806               8.611379e-07                       8.611379e-07
#> 807               0.000000e+00                       0.000000e+00
#> 808               0.000000e+00                       0.000000e+00
#> 809               2.152845e-07                       2.152845e-07
#> 810              -8.611379e-07                      -8.611379e-07
#> 811               4.036584e-07                       4.036584e-07
#> 812               0.000000e+00                       0.000000e+00
#> 813               8.073167e-07                       8.073167e-07
#> 814               8.342273e-07                       8.342273e-07
#> 815               0.000000e+00                       0.000000e+00
#> 816               2.018292e-07                       2.018292e-07
#> 817               1.614633e-07                      -2.247048e-06
#> 818               0.000000e+00                       0.000000e+00
#> 819               2.454281e-01                       8.594559e-07
#> 820               0.000000e+00                       0.000000e+00
#> 821               4.171136e-07                       4.171136e-07
#> 822               1.883739e-07                      -7.474887e-07
#> 823              -1.076422e-07                      -1.076422e-07
#> 824               0.000000e+00                       0.000000e+00
#> 825               4.171136e-07                       4.171136e-07
#> 826               8.073167e-08                       8.073167e-08
#> 827               4.272051e-07                       4.272051e-07
#> 828               2.085568e-07                       2.085568e-07
#> 829               1.009146e-07                       1.009146e-07
#> 830               1.883739e-07                       1.883739e-07
#> 831               4.171136e-07                       4.171136e-07
#> 832               3.437824e-06                       3.437824e-06
#> 833               2.018292e-07                       2.018292e-07
#> 834               0.000000e+00                       0.000000e+00
#> 835               0.000000e+00                       0.000000e+00
#> 836               0.000000e+00                       0.000000e+00
#> 837               0.000000e+00                       0.000000e+00
#> 838               0.000000e+00                       0.000000e+00
#> 839               8.577740e-07                       8.577740e-07
#> 840               1.718912e-06                       1.718912e-06
#> 841               0.000000e+00                       0.000000e+00
#> 842              -3.767478e-07                      -3.767478e-07
#> 843               2.152845e-07                       2.152845e-07
#> 844               0.000000e+00                       0.000000e+00
#> 845              -7.534956e-07                       2.730048e-06
#> 846               0.000000e+00                       0.000000e+00
#> 847               1.614633e-07                       1.614633e-07
#> 848               0.000000e+00                       0.000000e+00
#> 849               0.000000e+00                       0.000000e+00
#> 850               0.000000e+00                       0.000000e+00
#> 851               0.000000e+00                       0.000000e+00
#> 852               1.506991e-06                       1.506991e-06
#> 853              -2.583414e-06                      -2.583414e-06
#> 854              -4.305689e-07                      -4.305689e-07
#> 855               4.238413e-07                       4.238413e-07
#> 856               2.018292e-07                       2.018292e-07
#> 857               0.000000e+00                       0.000000e+00
#> 858               4.288870e-07                       4.288870e-07
#> 859               3.431096e-06                       3.431096e-06
#> 860               1.076422e-07                       1.076422e-07
#> 861               8.544102e-07                       8.544102e-07
#> 862              -8.611379e-07                      -8.611379e-07
#> 863               2.152845e-07                       2.152845e-07
#> 864               0.000000e+00                       0.000000e+00
#> 865              -6.458534e-07                      -6.458534e-07
#> 866              -3.229267e-07                      -3.229267e-07
#> 867               0.000000e+00                       0.000000e+00
#> 868               1.883739e-07                       1.883739e-07
#> 869               0.000000e+00                       0.000000e+00
#> 870               0.000000e+00                       0.000000e+00
#> 871               0.000000e+00                       0.000000e+00
#> 872               0.000000e+00                       0.000000e+00
#> 873               0.000000e+00                       0.000000e+00
#> 874               6.458534e-07                       6.458534e-07
#> 875               6.885739e-06                       6.885739e-06
#> 876               2.079852e-01                       3.437824e-06
#> 877               0.000000e+00                       0.000000e+00
#> 878               1.708820e-06                       1.708820e-06
#> 879               0.000000e+00                       0.000000e+00
#> 880              -4.305689e-07                      -4.305689e-07
#> 881               0.000000e+00                       0.000000e+00
#> 882               3.390730e-06                       3.390730e-06
#> 883               3.229267e-07                       3.229267e-07
#> 884               0.000000e+00                       0.000000e+00
#> 885               0.000000e+00                       0.000000e+00
#> 886              -3.229267e-07                      -3.229267e-07
#> 887               2.569979e-01                       2.085568e-07
#> 888               0.000000e+00                       0.000000e+00
#> 889               4.036584e-07                       4.036584e-07
#> 890               2.061354e-01                       3.431096e-06
#> 891               0.000000e+00                       0.000000e+00
#> 892               3.336909e-06                       3.336909e-06
#> 893               6.887421e-06                       6.887421e-06
#> 894               1.076422e-07                       1.076422e-07
#> 895               4.171136e-07                       4.171136e-07
#> 896               0.000000e+00                       0.000000e+00
#> 897               0.000000e+00                       0.000000e+00
#> 898               0.000000e+00                       0.000000e+00
#> 899               4.171136e-07                       4.171136e-07
#> 900               0.000000e+00                       0.000000e+00
#> 901               0.000000e+00                       0.000000e+00
#> 902               0.000000e+00                       0.000000e+00
#> 903               3.767478e-07                       3.767478e-07
#> 904              -2.152845e-07                      -2.152845e-07
#> 905               6.458534e-07                       6.458534e-07
#> 906               0.000000e+00                       0.000000e+00
#> 907               0.000000e+00                       0.000000e+00
#> 908               1.614633e-07                       1.614633e-07
#> 909               0.000000e+00                       0.000000e+00
#> 910               0.000000e+00                       0.000000e+00
#> 911               0.000000e+00                       0.000000e+00
#> 912               0.000000e+00                       0.000000e+00
#> 913              -8.611379e-07                      -8.611379e-07
#> 914               2.507755e-01                       8.476826e-07
#> 915               1.614633e-07                       1.614633e-07
#> 916               3.437824e-06                       3.437824e-06
#> 917               3.229267e-07                       3.229267e-07
#> 918               0.000000e+00                       0.000000e+00
#> 919               0.000000e+00                       0.000000e+00
#> 920               4.036584e-07                       4.036584e-07
#> 921               6.875648e-06                       6.875648e-06
#> 922               0.000000e+00                       0.000000e+00
#> 923              -8.611379e-07                      -8.611379e-07
#> 924               2.988297e-01                       3.767478e-07
#> 925               0.000000e+00                       0.000000e+00
#> 926               2.085568e-07                       2.085568e-07
#> 927               0.000000e+00                       0.000000e+00
#> 928               0.000000e+00                       0.000000e+00
#> 929               2.018292e-08                       2.018292e-08
#> 930               1.883739e-07                       1.883739e-07
#> 931               3.431096e-06                       3.431096e-06
#> 932               7.534956e-07                       7.534956e-07
#> 933               1.883739e-07                      -1.182783e-06
#> 934               1.614633e-07                       1.614633e-07
#> 935               3.417641e-06                       3.417641e-06
#> 936               3.336909e-06                       3.336909e-06
#> 937              -7.534956e-07                      -7.534956e-07
#> 938              -1.614633e-07                      -1.614633e-07
#> 939               1.668455e-06                       1.668455e-06
#> 940               0.000000e+00                       0.000000e+00
#> 941               0.000000e+00                       0.000000e+00
#> 942               1.695365e-06                       1.695365e-06
#> 943              -3.229267e-07                      -3.229267e-07
#> 944              -6.458534e-07                      -6.458534e-07
#> 945               0.000000e+00                       0.000000e+00
#> 946               6.673818e-06                       6.673818e-06
#> 947               0.000000e+00                       0.000000e+00
#> 948               0.000000e+00                       0.000000e+00
#> 949               8.342273e-07                       8.342273e-07
#> 950               1.076422e-07                       1.076422e-07
#> 951               0.000000e+00                       0.000000e+00
#> 952               0.000000e+00                       0.000000e+00
#> 953               4.288870e-07                       4.288870e-07
#> 954               0.000000e+00                       0.000000e+00
#> 955               3.390730e-06                       3.390730e-06
#> 956               0.000000e+00                       0.000000e+00
#> 957               0.000000e+00                       0.000000e+00
#> 958               1.614633e-07                       1.614633e-07
#> 959               3.229267e-07                       3.229267e-07
#> 960               0.000000e+00                       0.000000e+00
#> 961               1.076422e-07                       1.076422e-07
#> 962               0.000000e+00                       0.000000e+00
#> 963               0.000000e+00                       0.000000e+00
#> 964              -2.152845e-07                      -2.152845e-07
#> 965               2.691056e-08                       2.691056e-08
#> 966               1.883739e-07                       1.883739e-07
#> 967               0.000000e+00                       0.000000e+00
#> 968               0.000000e+00                       0.000000e+00
#> 969               0.000000e+00                       0.000000e+00
#> 970              -1.076422e-07                      -1.076422e-07
#> 971               4.036584e-07                       4.036584e-07
#> 972               3.767478e-07                       3.767478e-07
#> 973              -7.534956e-07                      -7.534956e-07
#> 974               1.614633e-06                       1.614633e-06
#> 975               7.534956e-07                       7.534956e-07
#> 976               0.000000e+00                       0.000000e+00
#> 977               3.437824e-06                       3.437824e-06
#> 978               0.000000e+00                       0.000000e+00
#> 979              -1.076422e-07                      -1.076422e-07
#> 980              -1.076422e-07                      -1.076422e-07
#> 981               4.036584e-08                       4.036584e-08
#> 982              -2.152845e-07                      -2.152845e-07
#> 983               0.000000e+00                       0.000000e+00
#> 984               1.614633e-07                       1.614633e-07
#> 985               4.036584e-07                       4.036584e-07
#> 986               5.382112e-08                       5.382112e-08
#> 987               3.417641e-06                       3.417641e-06
#> 988               0.000000e+00                       0.000000e+00
#> 989               1.668455e-06                       1.668455e-06
#> 990               4.036584e-07                       4.036584e-07
#> 991               8.577740e-07                       8.577740e-07
#> 992               0.000000e+00                       0.000000e+00
#> 993               0.000000e+00                       0.000000e+00
#> 994               3.390730e-06                       3.390730e-06
#> 995               1.708820e-06                       1.708820e-06
#> 996               1.076422e-07                       1.076422e-07
#> 997               0.000000e+00                       0.000000e+00
#> 998               3.767478e-07                       3.767478e-07
#> 999               0.000000e+00                       0.000000e+00
#> 1000              0.000000e+00                       0.000000e+00
#>      Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                    0.000000e+00     0.000000e+00
#> 2                                   -2.915443e-01     6.781461e-06
#> 3                                   -2.232996e-01     1.548583e-01
#> 4                                   -2.086234e-01     3.599561e-01
#> 5                                   -2.689095e-01     1.912593e-02
#> 6                                   -1.252055e-01     4.305689e-07
#> 7                                   -1.002180e-01     4.381413e-02
#> 8                                   -3.066199e-01     4.180752e-02
#> 9                                   -2.191940e-01     8.297809e-03
#> 10                                  -2.324337e-01     8.041809e-02
#> 11                                  -2.390800e-01     1.342381e-01
#> 12                                  -1.288349e-01     7.172790e-02
#> 13                                   0.000000e+00     0.000000e+00
#> 14                                  -1.920253e-01     1.206155e-01
#> 15                                  -2.053598e-01     9.972196e-02
#> 16                                   0.000000e+00     0.000000e+00
#> 17                                  -1.787365e-01     5.942094e-02
#> 18                                   0.000000e+00     0.000000e+00
#> 19                                  -2.774305e-01     1.184153e-01
#> 20                                  -2.809581e-01     7.646841e-02
#> 21                                  -2.773143e-01     8.429904e-02
#> 22                                  -2.962557e-01     1.056118e-01
#> 23                                   0.000000e+00     0.000000e+00
#> 24                                   0.000000e+00     0.000000e+00
#> 25                                  -2.972504e-01     2.670287e-01
#> 26                                  -1.079816e-01     1.150536e-01
#> 27                                   0.000000e+00     0.000000e+00
#> 28                                  -3.127203e-01     1.501876e-01
#> 29                                  -3.103767e-01     4.341699e-02
#> 30                                  -2.718028e-01     1.803437e-01
#> 31                                  -3.535411e-03     9.424716e-04
#> 32                                  -2.583414e-06     4.169540e-02
#> 33                                   0.000000e+00     0.000000e+00
#> 34                                  -3.150432e-01     5.458509e-02
#> 35                                   0.000000e+00     0.000000e+00
#> 36                                  -2.177439e-01     1.191531e-01
#> 37                                  -2.506570e-01     1.115566e-01
#> 38                                  -2.426048e-01     6.156684e-02
#> 39                                  -4.305689e-07     6.064889e-02
#> 40                                  -1.707409e-01     6.875083e-03
#> 41                                  -2.944879e-01     6.751955e-02
#> 42                                  -2.613760e-01     9.446986e-02
#> 43                                  -1.204159e-01     8.369783e-02
#> 44                                  -6.694068e-02     5.213466e-02
#> 45                                  -3.065014e-01     6.899909e-02
#> 46                                  -1.076422e-07     2.161525e-02
#> 47                                  -2.345692e-01     6.781461e-06
#> 48                                  -2.722139e-01     6.259665e-02
#> 49                                   0.000000e+00     0.000000e+00
#> 50                                  -6.319539e-02     4.618786e-02
#> 51                                   0.000000e+00     0.000000e+00
#> 52                                  -1.622193e-01     5.455664e-02
#> 53                                   0.000000e+00     0.000000e+00
#> 54                                  -3.315572e-01     8.686094e-02
#> 55                                  -1.631900e-01     3.363168e-02
#> 56                                   0.000000e+00     0.000000e+00
#> 57                                  -2.202048e-01     9.145685e-02
#> 58                                  -2.695116e-01     2.144903e-01
#> 59                                  -1.382673e-01     1.379370e-02
#> 60                                   1.708820e-06     1.579995e-01
#> 61                                  -2.519775e-01     4.854614e-02
#> 62                                  -1.750089e-01     5.812795e-02
#> 63                                  -2.834803e-01     6.473440e-02
#> 64                                   0.000000e+00     0.000000e+00
#> 65                                   0.000000e+00     0.000000e+00
#> 66                                   0.000000e+00     0.000000e+00
#> 67                                  -1.766678e-01     4.754297e-02
#> 68                                  -5.745576e-02     3.239796e-02
#> 69                                   0.000000e+00     0.000000e+00
#> 70                                  -1.471530e-01     8.440284e-02
#> 71                                   0.000000e+00     0.000000e+00
#> 72                                   0.000000e+00     0.000000e+00
#> 73                                  -5.380221e-02     9.987323e-02
#> 74                                   0.000000e+00     0.000000e+00
#> 75                                   0.000000e+00     0.000000e+00
#> 76                                   0.000000e+00     2.356253e-01
#> 77                                   0.000000e+00     0.000000e+00
#> 78                                  -1.973459e-01     1.038861e-01
#> 79                                  -2.188083e-02     6.134252e-03
#> 80                                  -2.655366e-01     7.657230e-02
#> 81                                   0.000000e+00     0.000000e+00
#> 82                                   0.000000e+00     0.000000e+00
#> 83                                  -4.723690e-07     8.506106e-02
#> 84                                  -1.251840e-01     7.261305e-02
#> 85                                  -2.510167e-01     2.215632e-01
#> 86                                   0.000000e+00     0.000000e+00
#> 87                                   0.000000e+00     0.000000e+00
#> 88                                   0.000000e+00     0.000000e+00
#> 89                                  -3.133963e-01     5.378646e-02
#> 90                                   0.000000e+00     9.794078e-02
#> 91                                  -2.395634e-01     1.350337e-01
#> 92                                   0.000000e+00     0.000000e+00
#> 93                                  -3.138263e-01     1.554171e-02
#> 94                                  -9.367481e-02     4.533846e-02
#> 95                                  -4.358611e-06     1.283919e-01
#> 96                                   0.000000e+00     0.000000e+00
#> 97                                  -2.403934e-01     4.947740e-02
#> 98                                  -9.578088e-02     1.735517e-01
#> 99                                  -8.311886e-02     4.148756e-02
#> 100                                  0.000000e+00     0.000000e+00
#> 101                                 -2.678314e-01     1.816655e-01
#> 102                                 -1.390147e-01     2.738358e-02
#> 103                                 -5.943683e-02     1.527174e-01
#> 104                                 -4.986185e-02     2.314105e-02
#> 105                                  0.000000e+00     0.000000e+00
#> 106                                 -2.638583e-01     2.656416e-01
#> 107                                 -1.262399e-01     5.352228e-02
#> 108                                 -2.865557e-01     6.569328e-02
#> 109                                 -1.366860e-01     1.627381e-01
#> 110                                 -5.407255e-02     2.419252e-02
#> 111                                  0.000000e+00     0.000000e+00
#> 112                                  0.000000e+00     0.000000e+00
#> 113                                  0.000000e+00     0.000000e+00
#> 114                                  0.000000e+00     0.000000e+00
#> 115                                 -2.344038e-01     8.606968e-02
#> 116                                 -3.016036e-01     1.485505e-01
#> 117                                  0.000000e+00     0.000000e+00
#> 118                                 -2.362163e-01     1.005577e-01
#> 119                                 -1.295153e-01     4.503779e-02
#> 120                                  0.000000e+00     0.000000e+00
#> 121                                 -5.795717e-02     2.193620e-02
#> 122                                  0.000000e+00     0.000000e+00
#> 123                                  0.000000e+00     0.000000e+00
#> 124                                  0.000000e+00     0.000000e+00
#> 125                                  0.000000e+00     0.000000e+00
#> 126                                  0.000000e+00     0.000000e+00
#> 127                                  0.000000e+00     0.000000e+00
#> 128                                  0.000000e+00     0.000000e+00
#> 129                                 -3.259139e-01     2.296564e-02
#> 130                                 -2.267218e-01     8.579434e-02
#> 131                                 -2.362260e-01     1.982227e-01
#> 132                                  0.000000e+00     0.000000e+00
#> 133                                 -1.840790e-01     8.206446e-02
#> 134                                  6.458534e-07     2.049370e-01
#> 135                                  0.000000e+00     0.000000e+00
#> 136                                 -1.909029e-01     4.875732e-02
#> 137                                  0.000000e+00     0.000000e+00
#> 138                                 -2.495737e-01     1.678369e-01
#> 139                                 -2.622201e-01     6.919141e-02
#> 140                                  0.000000e+00     0.000000e+00
#> 141                                 -9.630322e-02     4.096219e-02
#> 142                                 -1.499823e-01     8.138241e-02
#> 143                                 -4.063065e-02     4.641078e-04
#> 144                                 -2.047595e-01     8.818830e-02
#> 145                                 -2.248667e-01     1.210075e-01
#> 146                                 -3.048286e-01     2.452473e-01
#> 147                                 -1.447196e-01     1.342166e-01
#> 148                                  0.000000e+00     0.000000e+00
#> 149                                 -2.439366e-01     6.305416e-02
#> 150                                 -8.900973e-07     3.312482e-01
#> 151                                 -5.102346e-02     2.238532e-02
#> 152                                 -1.580608e-01     3.528924e-02
#> 153                                  0.000000e+00     0.000000e+00
#> 154                                 -1.002295e-01     3.229267e-07
#> 155                                  0.000000e+00     0.000000e+00
#> 156                                 -1.816310e-01     3.001455e-02
#> 157                                  0.000000e+00     0.000000e+00
#> 158                                 -2.423214e-01     1.664040e-01
#> 159                                 -2.038469e-01     9.065473e-02
#> 160                                 -1.698530e-01     4.897294e-02
#> 161                                 -3.983066e-02     9.734055e-03
#> 162                                  0.000000e+00     0.000000e+00
#> 163                                 -2.645238e-01     9.887072e-02
#> 164                                 -3.085152e-01     5.805149e-02
#> 165                                 -1.490199e-01     5.736058e-02
#> 166                                  0.000000e+00     0.000000e+00
#> 167                                 -1.193485e-01     2.958982e-02
#> 168                                  0.000000e+00     0.000000e+00
#> 169                                 -2.423199e-01     9.597528e-02
#> 170                                 -2.298613e-01     1.730032e-01
#> 171                                 -1.076422e-07     5.155680e-02
#> 172                                  0.000000e+00     0.000000e+00
#> 173                                 -1.226429e-01     4.410057e-02
#> 174                                 -3.127293e-01     4.302094e-02
#> 175                                 -2.590558e-01     1.347542e-01
#> 176                                 -1.368473e-01     2.915321e-02
#> 177                                  7.534956e-07     2.999382e-01
#> 178                                 -1.557906e-01     1.889477e-01
#> 179                                 -1.154301e-01     1.399787e-01
#> 180                                 -1.691796e-01     7.047433e-02
#> 181                                 -7.930233e-06     1.744149e-01
#> 182                                 -3.065938e-01     3.184882e-02
#> 183                                 -2.517393e-01     7.867977e-02
#> 184                                 -1.540205e-01     6.299633e-02
#> 185                                 -1.306184e-01     1.585093e-02
#> 186                                 -2.698827e-01     1.636841e-01
#> 187                                  0.000000e+00     5.635141e-02
#> 188                                 -2.914246e-01     2.135429e-02
#> 189                                  0.000000e+00     0.000000e+00
#> 190                                 -3.115526e-01     9.463884e-02
#> 191                                  0.000000e+00     0.000000e+00
#> 192                                 -8.569488e-02     2.225485e-01
#> 193                                 -1.473021e-01     1.658710e-01
#> 194                                 -1.617137e-01     7.298477e-02
#> 195                                 -3.767478e-07     4.837017e-02
#> 196                                  0.000000e+00     0.000000e+00
#> 197                                  0.000000e+00     0.000000e+00
#> 198                                 -5.400086e-02     4.666529e-02
#> 199                                  0.000000e+00     0.000000e+00
#> 200                                 -2.959374e-01     1.721454e-01
#> 201                                  0.000000e+00     0.000000e+00
#> 202                                 -2.958611e-01     1.044699e-01
#> 203                                  8.611379e-07     7.103867e-03
#> 204                                  0.000000e+00     0.000000e+00
#> 205                                 -1.683272e-01     5.167723e-02
#> 206                                  0.000000e+00     0.000000e+00
#> 207                                  0.000000e+00     0.000000e+00
#> 208                                 -2.907415e-01     8.391670e-02
#> 209                                  0.000000e+00     0.000000e+00
#> 210                                 -3.011037e-01     7.637851e-02
#> 211                                 -3.161139e-01     1.250138e-01
#> 212                                  0.000000e+00     0.000000e+00
#> 213                                 -1.814653e-01     5.106041e-02
#> 214                                 -3.092319e-01     1.217322e-01
#> 215                                 -1.902021e-01     3.488648e-02
#> 216                                  0.000000e+00     0.000000e+00
#> 217                                  0.000000e+00     0.000000e+00
#> 218                                  0.000000e+00     0.000000e+00
#> 219                                  0.000000e+00     0.000000e+00
#> 220                                  0.000000e+00     0.000000e+00
#> 221                                  0.000000e+00     0.000000e+00
#> 222                                  0.000000e+00     0.000000e+00
#> 223                                  0.000000e+00     0.000000e+00
#> 224                                 -9.343722e-02     5.182674e-02
#> 225                                 -1.505393e-01     9.402232e-02
#> 226                                 -1.279887e-01     2.772212e-02
#> 227                                  5.382112e-08     6.419018e-02
#> 228                                  0.000000e+00     0.000000e+00
#> 229                                 -1.727794e-01     7.440341e-03
#> 230                                 -3.232265e-01     1.385194e-01
#> 231                                 -2.677529e-01     2.307736e-01
#> 232                                 -6.439554e-02     2.805305e-02
#> 233                                 -1.318560e-01     7.436313e-02
#> 234                                 -2.066377e-01     9.044287e-02
#> 235                                  0.000000e+00     0.000000e+00
#> 236                                 -9.210533e-02     5.925035e-02
#> 237                                  0.000000e+00     0.000000e+00
#> 238                                  0.000000e+00     0.000000e+00
#> 239                                  0.000000e+00     0.000000e+00
#> 240                                  0.000000e+00     0.000000e+00
#> 241                                  0.000000e+00     0.000000e+00
#> 242                                  0.000000e+00     0.000000e+00
#> 243                                 -2.372808e-01     7.951448e-02
#> 244                                  0.000000e+00     0.000000e+00
#> 245                                  0.000000e+00     0.000000e+00
#> 246                                 -2.733184e-01     5.996313e-02
#> 247                                  0.000000e+00     0.000000e+00
#> 248                                 -3.362510e-02     1.474955e-02
#> 249                                 -2.318561e-01     6.781461e-06
#> 250                                 -3.039864e-01     1.123211e-01
#> 251                                 -2.509021e-01     2.805338e-01
#> 252                                 -1.430491e-01     1.315224e-01
#> 253                                 -2.818328e-01     4.543591e-02
#> 254                                  0.000000e+00     0.000000e+00
#> 255                                  0.000000e+00     0.000000e+00
#> 256                                  0.000000e+00     0.000000e+00
#> 257                                 -2.891742e-06     1.631873e-01
#> 258                                 -1.313409e-01     5.174490e-02
#> 259                                 -2.751887e-01     7.259886e-02
#> 260                                 -2.693127e-01     1.564818e-02
#> 261                                 -1.415520e-01     8.608374e-02
#> 262                                  0.000000e+00     0.000000e+00
#> 263                                 -6.156540e-06     2.505693e-01
#> 264                                 -2.470552e-01     1.128485e-01
#> 265                                 -3.177361e-01     2.266507e-01
#> 266                                  0.000000e+00     0.000000e+00
#> 267                                  0.000000e+00     0.000000e+00
#> 268                                 -3.193193e-01     1.776015e-01
#> 269                                 -3.037430e-01     1.466741e-01
#> 270                                 -2.807075e-01     7.790356e-02
#> 271                                 -2.982367e-01     2.777221e-02
#> 272                                  0.000000e+00     0.000000e+00
#> 273                                  0.000000e+00     0.000000e+00
#> 274                                  0.000000e+00     0.000000e+00
#> 275                                 -7.274591e-02     9.960991e-03
#> 276                                 -5.592255e-02     1.561889e-01
#> 277                                  0.000000e+00     0.000000e+00
#> 278                                 -2.655055e-01     4.513233e-02
#> 279                                  0.000000e+00     0.000000e+00
#> 280                                  0.000000e+00     0.000000e+00
#> 281                                  0.000000e+00     0.000000e+00
#> 282                                 -2.077294e-01     1.160267e-01
#> 283                                  0.000000e+00     0.000000e+00
#> 284                                 -1.557927e-01     6.661824e-02
#> 285                                 -4.305689e-07     2.929467e-02
#> 286                                  0.000000e+00     0.000000e+00
#> 287                                 -7.674859e-02     8.941143e-03
#> 288                                 -2.327632e-01     1.977636e-01
#> 289                                 -9.259548e-02     2.248030e-01
#> 290                                  0.000000e+00     0.000000e+00
#> 291                                  0.000000e+00     0.000000e+00
#> 292                                  0.000000e+00     0.000000e+00
#> 293                                 -7.147004e-02     1.868357e-01
#> 294                                  0.000000e+00     0.000000e+00
#> 295                                  0.000000e+00     0.000000e+00
#> 296                                  0.000000e+00     0.000000e+00
#> 297                                  0.000000e+00     0.000000e+00
#> 298                                 -1.198254e-01     8.278395e-02
#> 299                                  0.000000e+00     0.000000e+00
#> 300                                 -2.693865e-01     4.271895e-02
#> 301                                  0.000000e+00     0.000000e+00
#> 302                                 -2.374994e-01     1.650338e-01
#> 303                                  0.000000e+00     0.000000e+00
#> 304                                 -3.174057e-01     1.185440e-01
#> 305                                  0.000000e+00     0.000000e+00
#> 306                                 -5.213514e-02     3.231368e-02
#> 307                                 -1.671383e-01     4.110326e-02
#> 308                                  0.000000e+00     0.000000e+00
#> 309                                  0.000000e+00     0.000000e+00
#> 310                                 -8.254896e-06     9.009230e-02
#> 311                                  0.000000e+00     0.000000e+00
#> 312                                  0.000000e+00     0.000000e+00
#> 313                                  0.000000e+00     0.000000e+00
#> 314                                  0.000000e+00     0.000000e+00
#> 315                                  0.000000e+00     7.639860e-02
#> 316                                  0.000000e+00     0.000000e+00
#> 317                                  0.000000e+00     0.000000e+00
#> 318                                 -1.924993e-01     4.676641e-02
#> 319                                  2.152845e-07     2.332896e-01
#> 320                                  1.076422e-07     1.494438e-01
#> 321                                 -2.334518e-01     5.620532e-02
#> 322                                 -1.986355e-01     1.118816e-01
#> 323                                 -2.578397e-01     1.548481e-01
#> 324                                 -1.898761e-01     3.778262e-02
#> 325                                 -6.785918e-02     4.665349e-02
#> 326                                  0.000000e+00     0.000000e+00
#> 327                                  0.000000e+00     0.000000e+00
#> 328                                 -2.911471e-01     1.165686e-01
#> 329                                 -2.119608e-01     7.099088e-02
#> 330                                  0.000000e+00     0.000000e+00
#> 331                                 -9.951703e-02     5.217378e-02
#> 332                                  0.000000e+00     9.353463e-02
#> 333                                  1.506991e-06     3.538019e-02
#> 334                                 -1.760834e-01     1.373690e-02
#> 335                                 -2.691313e-01     1.460795e-01
#> 336                                 -1.060253e-02     1.567921e-01
#> 337                                 -3.013183e-01     2.296621e-01
#> 338                                 -1.456562e-01     7.991739e-02
#> 339                                  0.000000e+00     0.000000e+00
#> 340                                  0.000000e+00     0.000000e+00
#> 341                                 -1.655722e-01     5.286329e-02
#> 342                                 -2.167246e-01     8.611379e-07
#> 343                                 -1.909011e-01     4.461661e-02
#> 344                                  1.076422e-07     1.202567e-01
#> 345                                  0.000000e+00     0.000000e+00
#> 346                                  1.076422e-07     1.432230e-01
#> 347                                  0.000000e+00     0.000000e+00
#> 348                                 -1.705788e-01     7.772138e-02
#> 349                                 -2.583342e-01     2.381889e-02
#> 350                                 -3.032884e-01     8.358580e-02
#> 351                                 -7.044837e-02     9.084416e-03
#> 352                                 -5.511990e-02     1.922556e-02
#> 353                                 -1.012163e-01     9.589528e-02
#> 354                                 -2.989066e-01     5.772849e-02
#> 355                                 -2.880581e-01     1.203934e-02
#> 356                                  0.000000e+00     0.000000e+00
#> 357                                  0.000000e+00     3.362422e-01
#> 358                                  0.000000e+00     0.000000e+00
#> 359                                  0.000000e+00     0.000000e+00
#> 360                                 -1.776238e-01     1.079423e-01
#> 361                                 -2.905179e-01     5.842889e-02
#> 362                                  0.000000e+00     0.000000e+00
#> 363                                 -3.374549e-01     1.082361e-01
#> 364                                 -2.835699e-01     3.336909e-06
#> 365                                 -1.965358e-01     1.252126e-01
#> 366                                  2.102387e-10     8.027801e-02
#> 367                                  0.000000e+00     9.837096e-02
#> 368                                  5.382112e-08     1.488716e-01
#> 369                                  0.000000e+00     3.553618e-03
#> 370                                 -2.859117e-01     2.544921e-01
#> 371                                 -1.241090e-01     3.833030e-02
#> 372                                 -2.182626e-01     1.485557e-01
#> 373                                 -1.554825e-01     5.866223e-02
#> 374                                  0.000000e+00     0.000000e+00
#> 375                                  0.000000e+00     0.000000e+00
#> 376                                 -2.306941e-01     7.499136e-02
#> 377                                 -1.885123e-01     8.845093e-02
#> 378                                 -4.652713e-02     1.840641e-02
#> 379                                 -1.987371e-01     1.144725e-01
#> 380                                  0.000000e+00     0.000000e+00
#> 381                                 -2.800714e-01     1.094750e-01
#> 382                                  0.000000e+00     0.000000e+00
#> 383                                 -3.107301e-01     6.053816e-02
#> 384                                  0.000000e+00     0.000000e+00
#> 385                                 -1.599067e-01     1.805806e-02
#> 386                                 -2.345695e-01     2.763720e-02
#> 387                                 -5.903034e-07     5.188683e-02
#> 388                                 -1.865342e-01     1.187761e-01
#> 389                                  0.000000e+00     0.000000e+00
#> 390                                 -2.588639e-01     1.175696e-01
#> 391                                 -1.291707e-06     1.150047e-01
#> 392                                 -7.914941e-02     5.835232e-03
#> 393                                 -2.760355e-01     1.564682e-01
#> 394                                 -5.226528e-06     1.414161e-01
#> 395                                  0.000000e+00     0.000000e+00
#> 396                                 -1.904544e-01     1.198697e-01
#> 397                                  0.000000e+00     0.000000e+00
#> 398                                 -6.769011e-02     3.082474e-02
#> 399                                  0.000000e+00     0.000000e+00
#> 400                                  0.000000e+00     0.000000e+00
#> 401                                 -1.817755e-01     7.820366e-02
#> 402                                  0.000000e+00     0.000000e+00
#> 403                                 -2.673497e-01     2.016589e-01
#> 404                                 -1.917657e-01     9.847256e-02
#> 405                                  0.000000e+00     0.000000e+00
#> 406                                 -3.227524e-01     2.160656e-01
#> 407                                 -1.858944e-01     5.495433e-02
#> 408                                  0.000000e+00     0.000000e+00
#> 409                                 -2.928091e-01     1.106667e-01
#> 410                                 -1.038985e-01     7.358210e-02
#> 411                                 -1.170769e-01     4.388585e-02
#> 412                                 -1.151270e-01     0.000000e+00
#> 413                                  0.000000e+00     0.000000e+00
#> 414                                 -2.083430e-01     4.989769e-02
#> 415                                 -2.382012e-01     7.069684e-02
#> 416                                 -2.488311e-01     6.781461e-06
#> 417                                 -2.147262e-01     1.429033e-01
#> 418                                 -8.345671e-02     1.033130e-02
#> 419                                  0.000000e+00     0.000000e+00
#> 420                                 -5.789721e-02     3.597510e-02
#> 421                                  0.000000e+00     0.000000e+00
#> 422                                  0.000000e+00     0.000000e+00
#> 423                                 -1.550033e-01     3.777654e-02
#> 424                                 -2.890660e-01     9.826681e-02
#> 425                                 -2.587718e-01     2.527367e-01
#> 426                                 -2.030823e-01     6.336027e-02
#> 427                                 -1.065239e-01     1.480921e-02
#> 428                                 -2.828793e-01     1.004186e-01
#> 429                                 -2.183524e-01     6.693338e-02
#> 430                                 -1.123119e-01     1.635463e-01
#> 431                                 -2.639167e-01     1.570725e-02
#> 432                                 -1.272476e-01     7.532678e-02
#> 433                                  0.000000e+00     3.240881e-02
#> 434                                 -5.159229e-02     9.782040e-03
#> 435                                 -2.557463e-01     1.080730e-01
#> 436                                  0.000000e+00     0.000000e+00
#> 437                                  0.000000e+00     0.000000e+00
#> 438                                 -2.900102e-01     1.131423e-01
#> 439                                  0.000000e+00     0.000000e+00
#> 440                                 -1.414412e-01     4.348880e-02
#> 441                                  0.000000e+00     0.000000e+00
#> 442                                 -1.674044e-07     7.113966e-02
#> 443                                  0.000000e+00     0.000000e+00
#> 444                                 -2.427939e-01     1.000398e-01
#> 445                                 -1.445824e-01     8.724898e-02
#> 446                                  0.000000e+00     1.405776e-01
#> 447                                 -1.932173e-06     6.478072e-02
#> 448                                 -5.106077e-06     4.778443e-02
#> 449                                 -1.978312e-01     1.283638e-01
#> 450                                 -1.641663e-01     6.174913e-02
#> 451                                 -2.863501e-01     1.371752e-01
#> 452                                  0.000000e+00     0.000000e+00
#> 453                                  0.000000e+00     0.000000e+00
#> 454                                 -1.722276e-06     6.193757e-02
#> 455                                 -1.994837e-01     3.336909e-06
#> 456                                 -1.858895e-01     2.571327e-02
#> 457                                 -2.822314e-02     7.968572e-03
#> 458                                 -2.310391e-01     1.885972e-01
#> 459                                 -1.828496e-01     2.330159e-01
#> 460                                 -1.744469e-01     1.172973e-01
#> 461                                 -1.599199e-01     1.872418e-01
#> 462                                  0.000000e+00     0.000000e+00
#> 463                                 -1.219025e-01     1.222759e-01
#> 464                                 -1.873323e-01     2.777159e-02
#> 465                                 -2.947130e-01     6.862192e-06
#> 466                                  0.000000e+00     0.000000e+00
#> 467                                  0.000000e+00     0.000000e+00
#> 468                                 -2.563818e-01     1.194322e-01
#> 469                                  0.000000e+00     0.000000e+00
#> 470                                  0.000000e+00     0.000000e+00
#> 471                                 -2.152731e-01     2.590078e-01
#> 472                                 -4.830024e-02     1.843145e-02
#> 473                                 -9.350665e-03     2.304757e-03
#> 474                                  0.000000e+00     0.000000e+00
#> 475                                 -3.038488e-01     1.507699e-01
#> 476                                  0.000000e+00     0.000000e+00
#> 477                                  0.000000e+00     0.000000e+00
#> 478                                 -2.602158e-01     1.963757e-01
#> 479                                  0.000000e+00     0.000000e+00
#> 480                                  0.000000e+00     0.000000e+00
#> 481                                  0.000000e+00     0.000000e+00
#> 482                                  0.000000e+00     0.000000e+00
#> 483                                 -1.894405e-01     2.947008e-01
#> 484                                  0.000000e+00     0.000000e+00
#> 485                                 -4.305689e-07     7.170681e-02
#> 486                                 -2.936246e-01     5.509394e-02
#> 487                                  0.000000e+00     0.000000e+00
#> 488                                 -1.169262e-01     1.138620e-02
#> 489                                  0.000000e+00     0.000000e+00
#> 490                                  0.000000e+00     0.000000e+00
#> 491                                 -2.958314e-01     6.471051e-02
#> 492                                 -2.780809e-01     1.128943e-02
#> 493                                 -2.792562e-01     4.126878e-02
#> 494                                 -2.665335e-01     1.113678e-02
#> 495                                 -5.102323e-02     1.476818e-01
#> 496                                 -3.154805e-07     1.803405e-01
#> 497                                 -2.833197e-01     2.628828e-01
#> 498                                 -2.883549e-01     1.259782e-01
#> 499                                 -2.514630e-01     1.373225e-02
#> 500                                  0.000000e+00     0.000000e+00
#> 501                                  0.000000e+00     0.000000e+00
#> 502                                 -1.304326e-01     2.251823e-02
#> 503                                 -2.542715e-01     1.249004e-01
#> 504                                  0.000000e+00     0.000000e+00
#> 505                                 -2.469034e-01     1.604088e-01
#> 506                                 -2.116115e-01     8.745682e-02
#> 507                                 -2.220341e-01     4.710496e-02
#> 508                                 -2.701403e-01     2.386295e-01
#> 509                                  0.000000e+00     0.000000e+00
#> 510                                  0.000000e+00     0.000000e+00
#> 511                                 -1.979954e-01     4.645708e-02
#> 512                                  0.000000e+00     0.000000e+00
#> 513                                 -1.636702e-01     8.054777e-02
#> 514                                 -3.065909e-01     6.823796e-02
#> 515                                 -1.665411e-01     1.614633e-07
#> 516                                 -2.403014e-01     1.458517e-01
#> 517                                 -1.589334e-01     1.003654e-01
#> 518                                  0.000000e+00     0.000000e+00
#> 519                                 -2.969383e-01     6.333347e-02
#> 520                                 -2.403047e-01     1.197080e-01
#> 521                                 -2.203764e-01     1.897601e-01
#> 522                                  0.000000e+00     0.000000e+00
#> 523                                 -4.244438e-06     4.701881e-02
#> 524                                 -2.226142e-01     1.516459e-01
#> 525                                  0.000000e+00     0.000000e+00
#> 526                                 -2.850019e-01     7.066631e-02
#> 527                                  0.000000e+00     0.000000e+00
#> 528                                  0.000000e+00     0.000000e+00
#> 529                                 -1.870904e-07     6.178177e-02
#> 530                                  0.000000e+00     0.000000e+00
#> 531                                  0.000000e+00     0.000000e+00
#> 532                                  0.000000e+00     0.000000e+00
#> 533                                  0.000000e+00     0.000000e+00
#> 534                                 -2.746660e-06     1.375873e-01
#> 535                                  0.000000e+00     0.000000e+00
#> 536                                  0.000000e+00     0.000000e+00
#> 537                                 -1.669183e-01     8.255082e-02
#> 538                                  0.000000e+00     0.000000e+00
#> 539                                  0.000000e+00     0.000000e+00
#> 540                                 -2.742653e-01     1.126288e-01
#> 541                                 -2.867006e-01     1.651614e-01
#> 542                                 -9.645005e-02     2.382134e-01
#> 543                                  0.000000e+00     0.000000e+00
#> 544                                  0.000000e+00     1.273746e-01
#> 545                                  0.000000e+00     0.000000e+00
#> 546                                 -3.196378e-01     1.903798e-01
#> 547                                  0.000000e+00     0.000000e+00
#> 548                                 -1.103601e-02     7.546052e-02
#> 549                                 -2.260643e-01     1.259858e-01
#> 550                                  0.000000e+00     0.000000e+00
#> 551                                 -3.081361e-01     8.131353e-02
#> 552                                  0.000000e+00     0.000000e+00
#> 553                                 -7.342566e-02     2.320389e-02
#> 554                                  0.000000e+00     0.000000e+00
#> 555                                 -1.186726e-01     4.568419e-02
#> 556                                 -1.151274e-01     1.349375e-02
#> 557                                 -9.597455e-02     1.280892e-02
#> 558                                  0.000000e+00     0.000000e+00
#> 559                                 -2.927742e-01     1.114443e-01
#> 560                                 -2.354503e-01     9.715629e-03
#> 561                                  0.000000e+00     0.000000e+00
#> 562                                 -5.000333e-06     2.303343e-01
#> 563                                 -3.004894e-01     7.014826e-02
#> 564                                 -3.288895e-01     1.397877e-01
#> 565                                  0.000000e+00     0.000000e+00
#> 566                                  0.000000e+00     0.000000e+00
#> 567                                 -1.801214e-02     1.483562e-02
#> 568                                  0.000000e+00     8.868816e-02
#> 569                                 -4.305689e-07     3.298648e-02
#> 570                                 -2.754591e-01     3.571484e-02
#> 571                                 -1.817755e-01     8.492893e-02
#> 572                                 -2.427680e-01     1.168382e-02
#> 573                                  0.000000e+00     0.000000e+00
#> 574                                 -2.637713e-01     9.131365e-02
#> 575                                 -2.297019e-01     7.722749e-02
#> 576                                 -2.647205e-01     8.104319e-02
#> 577                                 -1.895815e-01     9.633532e-02
#> 578                                 -1.973459e-01     1.024884e-01
#> 579                                 -2.248202e-01     2.021509e-01
#> 580                                  0.000000e+00     0.000000e+00
#> 581                                  0.000000e+00     0.000000e+00
#> 582                                  0.000000e+00     0.000000e+00
#> 583                                  0.000000e+00     0.000000e+00
#> 584                                  0.000000e+00     0.000000e+00
#> 585                                 -2.583414e-06     6.704880e-02
#> 586                                  0.000000e+00     0.000000e+00
#> 587                                 -1.518954e-01     2.702430e-02
#> 588                                 -2.933322e-01     3.348714e-02
#> 589                                  0.000000e+00     0.000000e+00
#> 590                                  0.000000e+00     0.000000e+00
#> 591                                  0.000000e+00     0.000000e+00
#> 592                                 -2.682665e-01     6.351484e-02
#> 593                                 -1.420404e-01     4.133336e-02
#> 594                                 -4.777015e-02     2.155009e-02
#> 595                                 -2.778139e-02     5.518027e-03
#> 596                                 -2.422524e-01     1.487413e-01
#> 597                                  1.291707e-06     1.291707e-06
#> 598                                  0.000000e+00     0.000000e+00
#> 599                                 -3.005186e-01     6.782279e-02
#> 600                                 -7.175896e-02     1.023762e-03
#> 601                                 -2.917806e-01     1.360796e-01
#> 602                                 -2.318644e-01     6.633834e-02
#> 603                                  0.000000e+00     3.861923e-02
#> 604                                 -1.253788e-01     5.536786e-02
#> 605                                  0.000000e+00     0.000000e+00
#> 606                                 -2.063922e-01     1.305024e-01
#> 607                                 -2.721248e-01     1.030894e-01
#> 608                                  0.000000e+00     0.000000e+00
#> 609                                 -2.717011e-01     1.816595e-02
#> 610                                 -2.472024e-01     2.187341e-01
#> 611                                 -2.323596e-01     2.369477e-01
#> 612                                  0.000000e+00     0.000000e+00
#> 613                                  0.000000e+00     2.504287e-02
#> 614                                 -2.644104e-01     6.055029e-02
#> 615                                  0.000000e+00     0.000000e+00
#> 616                                  0.000000e+00     0.000000e+00
#> 617                                 -2.573895e-01     1.234103e-01
#> 618                                 -2.347787e-01     7.960607e-02
#> 619                                 -1.618264e-01     1.756236e-01
#> 620                                 -1.194909e-01     4.684486e-03
#> 621                                  0.000000e+00     0.000000e+00
#> 622                                  0.000000e+00     0.000000e+00
#> 623                                  0.000000e+00     0.000000e+00
#> 624                                  0.000000e+00     0.000000e+00
#> 625                                 -3.001704e-01     1.047311e-01
#> 626                                 -1.414571e-01     8.467227e-03
#> 627                                  0.000000e+00     0.000000e+00
#> 628                                 -2.820628e-01     6.046249e-02
#> 629                                 -1.459342e-01     3.325515e-02
#> 630                                  0.000000e+00     0.000000e+00
#> 631                                  0.000000e+00     0.000000e+00
#> 632                                  0.000000e+00     0.000000e+00
#> 633                                  0.000000e+00     0.000000e+00
#> 634                                 -2.811875e-01     1.135907e-01
#> 635                                 -1.530422e-01     6.728229e-02
#> 636                                 -2.811735e-01     1.368498e-01
#> 637                                 -9.005555e-02     2.476287e-02
#> 638                                 -1.107878e-06     2.989643e-01
#> 639                                  0.000000e+00     0.000000e+00
#> 640                                 -3.106957e-01     1.525668e-01
#> 641                                 -2.949900e-01     7.918950e-02
#> 642                                  0.000000e+00     0.000000e+00
#> 643                                 -1.310261e-01     2.464496e-02
#> 644                                 -3.256639e-01     1.065989e-01
#> 645                                 -3.238363e-01     5.454289e-02
#> 646                                  0.000000e+00     0.000000e+00
#> 647                                 -2.873407e-01     6.568923e-02
#> 648                                 -1.775795e-01     5.157004e-02
#> 649                                 -1.902025e-01     5.718654e-02
#> 650                                 -1.371581e-01     3.870586e-02
#> 651                                 -1.973465e-01     9.864025e-02
#> 652                                 -1.821498e-06     3.219866e-01
#> 653                                  0.000000e+00     6.928163e-02
#> 654                                 -1.968664e-01     2.800282e-01
#> 655                                 -3.196369e-01     4.511678e-02
#> 656                                  0.000000e+00     0.000000e+00
#> 657                                  0.000000e+00     0.000000e+00
#> 658                                 -2.292635e-01     1.056542e-01
#> 659                                  8.611379e-07    -2.175523e-06
#> 660                                 -3.174975e-01     7.520749e-02
#> 661                                 -1.700637e-01     8.396073e-02
#> 662                                 -1.228050e-01     1.802160e-02
#> 663                                 -1.798225e-01     1.146472e-01
#> 664                                  0.000000e+00     0.000000e+00
#> 665                                  0.000000e+00     0.000000e+00
#> 666                                 -1.618710e-02     3.746917e-01
#> 667                                 -2.233492e-01     9.799359e-02
#> 668                                  0.000000e+00     0.000000e+00
#> 669                                  0.000000e+00     0.000000e+00
#> 670                                 -2.659235e-01     5.020240e-02
#> 671                                  0.000000e+00     0.000000e+00
#> 672                                 -2.896780e-01     1.749481e-01
#> 673                                 -1.210138e-01     2.876591e-02
#> 674                                  0.000000e+00     0.000000e+00
#> 675                                  0.000000e+00     9.493512e-02
#> 676                                 -8.278157e-02     4.296154e-02
#> 677                                 -1.267749e-01     6.842532e-02
#> 678                                  0.000000e+00     0.000000e+00
#> 679                                 -2.311067e-01     1.277793e-01
#> 680                                 -2.624054e-01     8.081801e-03
#> 681                                 -9.336063e-02     5.926101e-02
#> 682                                 -3.227624e-01     1.221147e-01
#> 683                                 -2.766105e-01     5.787463e-03
#> 684                                 -1.266198e-01     6.583265e-02
#> 685                                 -2.972191e-01     9.353817e-02
#> 686                                  0.000000e+00     0.000000e+00
#> 687                                 -1.771910e-01     2.413563e-01
#> 688                                  0.000000e+00     0.000000e+00
#> 689                                 -1.474416e-01     4.334525e-02
#> 690                                  0.000000e+00     0.000000e+00
#> 691                                 -2.096172e-01     3.388464e-02
#> 692                                 -1.318633e-01     6.673818e-06
#> 693                                 -8.006513e-06     2.025243e-02
#> 694                                  0.000000e+00     0.000000e+00
#> 695                                 -2.596899e-01     4.693437e-02
#> 696                                  0.000000e+00     0.000000e+00
#> 697                                  0.000000e+00     0.000000e+00
#> 698                                 -2.189947e-01     1.020333e-01
#> 699                                 -1.226713e-01     1.115790e-02
#> 700                                 -2.860511e-01     8.677388e-02
#> 701                                  0.000000e+00     0.000000e+00
#> 702                                 -2.877664e-01     1.449581e-01
#> 703                                  2.144435e-07     9.430851e-02
#> 704                                 -2.773482e-01     6.986150e-03
#> 705                                 -7.437904e-06     2.331294e-02
#> 706                                 -3.041979e-01     1.305449e-01
#> 707                                 -1.314249e-01    -1.291707e-06
#> 708                                 -2.378843e-01     1.073052e-01
#> 709                                 -3.106383e-01     1.292834e-01
#> 710                                  0.000000e+00     0.000000e+00
#> 711                                  0.000000e+00     0.000000e+00
#> 712                                 -2.172702e-01     1.425208e-01
#> 713                                  0.000000e+00     0.000000e+00
#> 714                                 -1.074935e-01     1.026670e-01
#> 715                                 -1.090861e-01     1.344090e-02
#> 716                                 -2.422515e-01     1.480694e-02
#> 717                                  0.000000e+00     0.000000e+00
#> 718                                 -1.506106e-01     1.284819e-01
#> 719                                  0.000000e+00     0.000000e+00
#> 720                                 -1.625715e-01     6.508353e-02
#> 721                                  0.000000e+00     0.000000e+00
#> 722                                  0.000000e+00     0.000000e+00
#> 723                                  0.000000e+00     0.000000e+00
#> 724                                 -7.820337e-02     2.044398e-02
#> 725                                  0.000000e+00     0.000000e+00
#> 726                                 -1.755321e-01     8.295481e-02
#> 727                                  0.000000e+00     0.000000e+00
#> 728                                 -1.675410e-01     5.102761e-02
#> 729                                 -2.334623e-01     1.350660e-01
#> 730                                  0.000000e+00     0.000000e+00
#> 731                                 -3.200124e-01     1.333618e-01
#> 732                                 -2.062720e-01     1.199926e-01
#> 733                                 -2.335969e-01     6.356103e-02
#> 734                                 -5.460693e-02     1.150826e-01
#> 735                                  0.000000e+00     0.000000e+00
#> 736                                  0.000000e+00     0.000000e+00
#> 737                                 -2.902553e-01     5.642464e-02
#> 738                                 -1.774410e-06     1.312587e-01
#> 739                                 -8.611379e-07     1.046124e-01
#> 740                                 -1.885116e-01     9.042468e-02
#> 741                                 -2.646369e-01     2.398299e-01
#> 742                                 -2.570984e-01     1.658623e-01
#> 743                                  0.000000e+00     0.000000e+00
#> 744                                  0.000000e+00     0.000000e+00
#> 745                                  0.000000e+00     0.000000e+00
#> 746                                  0.000000e+00     0.000000e+00
#> 747                                  0.000000e+00     0.000000e+00
#> 748                                  0.000000e+00     0.000000e+00
#> 749                                 -3.057688e-01     2.341553e-02
#> 750                                 -7.772262e-02     5.856540e-02
#> 751                                  0.000000e+00     0.000000e+00
#> 752                                  7.859664e-10     3.363347e-02
#> 753                                 -4.305689e-07     1.319726e-01
#> 754                                 -3.196398e-01     1.659396e-01
#> 755                                 -2.928983e-01     1.321479e-01
#> 756                                  0.000000e+00     0.000000e+00
#> 757                                  0.000000e+00     0.000000e+00
#> 758                                 -4.369096e-02     1.057977e-02
#> 759                                 -1.120849e-01     1.272676e-01
#> 760                                  0.000000e+00     0.000000e+00
#> 761                                 -1.354236e-01     5.877903e-02
#> 762                                 -2.826346e-01     3.352216e-02
#> 763                                  0.000000e+00     0.000000e+00
#> 764                                 -2.763201e-01     4.060798e-02
#> 765                                  0.000000e+00     0.000000e+00
#> 766                                 -8.984003e-02     4.624428e-02
#> 767                                  0.000000e+00     0.000000e+00
#> 768                                  1.076422e-07     1.404169e-01
#> 769                                 -1.653265e-01     3.316279e-02
#> 770                                  0.000000e+00     0.000000e+00
#> 771                                  0.000000e+00     0.000000e+00
#> 772                                 -1.108388e-01     4.091676e-02
#> 773                                  0.000000e+00     0.000000e+00
#> 774                                  0.000000e+00     0.000000e+00
#> 775                                 -3.179014e-01     4.960158e-02
#> 776                                 -1.361155e-01     2.013160e-02
#> 777                                  0.000000e+00     0.000000e+00
#> 778                                  0.000000e+00     0.000000e+00
#> 779                                 -1.375987e-01     6.472476e-02
#> 780                                 -1.652079e-01     2.430003e-02
#> 781                                 -1.312295e-01     6.665476e-02
#> 782                                 -2.425016e-01     1.105110e-01
#> 783                                 -3.074928e-01     3.034590e-02
#> 784                                  0.000000e+00     0.000000e+00
#> 785                                  0.000000e+00     0.000000e+00
#> 786                                 -2.874262e-01     1.050687e-01
#> 787                                  0.000000e+00     0.000000e+00
#> 788                                  0.000000e+00     0.000000e+00
#> 789                                  0.000000e+00     0.000000e+00
#> 790                                  0.000000e+00     0.000000e+00
#> 791                                  0.000000e+00     0.000000e+00
#> 792                                  0.000000e+00     0.000000e+00
#> 793                                  0.000000e+00     0.000000e+00
#> 794                                  0.000000e+00     0.000000e+00
#> 795                                 -2.977076e-01     6.835282e-06
#> 796                                  0.000000e+00     0.000000e+00
#> 797                                 -9.909693e-02     8.804752e-02
#> 798                                 -1.795712e-01     1.313705e-01
#> 799                                 -2.312789e-01     8.128469e-02
#> 800                                  0.000000e+00     0.000000e+00
#> 801                                  0.000000e+00     0.000000e+00
#> 802                                 -1.824588e-01     8.487611e-03
#> 803                                  0.000000e+00     0.000000e+00
#> 804                                  0.000000e+00     0.000000e+00
#> 805                                 -2.822034e-01     5.022249e-02
#> 806                                 -6.498443e-02     9.541357e-03
#> 807                                  0.000000e+00     0.000000e+00
#> 808                                  0.000000e+00     0.000000e+00
#> 809                                 -2.162076e-01     3.753822e-02
#> 810                                 -8.611379e-07     1.179664e-01
#> 811                                 -2.971742e-01     7.264110e-02
#> 812                                  0.000000e+00     0.000000e+00
#> 813                                 -3.040566e-01     4.889768e-02
#> 814                                 -3.043390e-01     1.464404e-01
#> 815                                  0.000000e+00     0.000000e+00
#> 816                                 -3.207621e-01     6.071467e-02
#> 817                                 -2.789235e-01     4.722990e-02
#> 818                                  0.000000e+00     0.000000e+00
#> 819                                 -3.633416e-01     1.306165e-01
#> 820                                  0.000000e+00     0.000000e+00
#> 821                                 -2.825702e-01     1.554860e-01
#> 822                                 -1.898871e-01     1.399640e-01
#> 823                                 -1.352640e-01     6.687179e-02
#> 824                                  0.000000e+00     0.000000e+00
#> 825                                 -2.942715e-01     1.201427e-01
#> 826                                 -1.466481e-06     2.735053e-01
#> 827                                 -2.261628e-01     1.210183e-01
#> 828                                 -2.298189e-01     8.911040e-02
#> 829                                 -2.665875e-01     1.167545e-01
#> 830                                 -2.448326e-01     9.909681e-02
#> 831                                 -2.961708e-01     9.585396e-02
#> 832                                 -3.105393e-01     1.374458e-01
#> 833                                 -2.733352e-01     1.218908e-01
#> 834                                  0.000000e+00     0.000000e+00
#> 835                                  0.000000e+00     9.408603e-02
#> 836                                  0.000000e+00     0.000000e+00
#> 837                                  0.000000e+00     0.000000e+00
#> 838                                  0.000000e+00     0.000000e+00
#> 839                                 -2.787931e-01     1.203243e-01
#> 840                                 -3.056067e-01     1.707530e-01
#> 841                                  0.000000e+00     0.000000e+00
#> 842                                 -9.894071e-02     4.713311e-02
#> 843                                  2.152845e-07     1.244730e-01
#> 844                                  0.000000e+00     0.000000e+00
#> 845                                 -9.412300e-02     4.568419e-02
#> 846                                  0.000000e+00     0.000000e+00
#> 847                                 -2.465474e-01     7.470279e-02
#> 848                                  0.000000e+00     0.000000e+00
#> 849                                  0.000000e+00     0.000000e+00
#> 850                                  0.000000e+00     0.000000e+00
#> 851                                  0.000000e+00     0.000000e+00
#> 852                                 -2.701425e-01     1.482290e-02
#> 853                                 -2.583414e-06     1.372493e-01
#> 854                                  1.637825e-06     3.753955e-02
#> 855                                 -2.494524e-01     9.917933e-02
#> 856                                 -2.233176e-01     7.975388e-02
#> 857                                  0.000000e+00     0.000000e+00
#> 858                                 -1.511289e-01     5.634876e-02
#> 859                                 -2.661047e-01     1.024577e-01
#> 860                                 -1.684452e-01     6.447096e-02
#> 861                                 -3.123991e-01     2.075301e-01
#> 862                                 -8.611379e-07     1.769828e-01
#> 863                                  2.152845e-07     3.027777e-01
#> 864                                  0.000000e+00     0.000000e+00
#> 865                                 -1.377697e-01     2.933783e-02
#> 866                                 -1.570896e-01     4.336530e-02
#> 867                                  0.000000e+00     0.000000e+00
#> 868                                 -2.465477e-01     8.681865e-02
#> 869                                  0.000000e+00     0.000000e+00
#> 870                                  0.000000e+00     0.000000e+00
#> 871                                  0.000000e+00     0.000000e+00
#> 872                                  0.000000e+00     0.000000e+00
#> 873                                 -1.754373e-01     7.192134e-02
#> 874                                 -1.448262e-01     1.433288e-02
#> 875                                 -2.768143e-01     2.614374e-01
#> 876                                 -3.258472e-01     1.868798e-01
#> 877                                  0.000000e+00     0.000000e+00
#> 878                                 -2.871775e-01     8.944918e-02
#> 879                                  0.000000e+00     0.000000e+00
#> 880                                 -1.302855e-01     1.023659e-02
#> 881                                  0.000000e+00     0.000000e+00
#> 882                                 -3.116012e-01     1.952696e-01
#> 883                                  3.229267e-07     1.575760e-01
#> 884                                  0.000000e+00     0.000000e+00
#> 885                                  0.000000e+00     0.000000e+00
#> 886                                 -1.266167e-01     5.717258e-02
#> 887                                 -2.245617e-01     9.373368e-02
#> 888                                  0.000000e+00     0.000000e+00
#> 889                                 -3.095935e-01     9.756666e-02
#> 890                                 -1.451984e-01     4.295021e-02
#> 891                                  0.000000e+00     0.000000e+00
#> 892                                 -2.370796e-01     3.163244e-01
#> 893                                 -3.315575e-01     2.577643e-01
#> 894                                 -1.099607e-01     4.390577e-02
#> 895                                 -2.814969e-01     1.646680e-01
#> 896                                 -1.894552e-01     2.289313e-02
#> 897                                  0.000000e+00     0.000000e+00
#> 898                                  0.000000e+00     0.000000e+00
#> 899                                 -3.003627e-01     1.244677e-01
#> 900                                  0.000000e+00     0.000000e+00
#> 901                                  0.000000e+00     0.000000e+00
#> 902                                  0.000000e+00     0.000000e+00
#> 903                                 -2.940307e-01     6.538510e-02
#> 904                                 -1.443157e-01     3.133730e-02
#> 905                                  6.458534e-07     1.241551e-01
#> 906                                  0.000000e+00     0.000000e+00
#> 907                                  0.000000e+00     0.000000e+00
#> 908                                 -1.990134e-01     8.462309e-02
#> 909                                  0.000000e+00     0.000000e+00
#> 910                                  0.000000e+00     0.000000e+00
#> 911                                  0.000000e+00     0.000000e+00
#> 912                                  0.000000e+00     0.000000e+00
#> 913                                 -1.056115e-01    -8.611379e-07
#> 914                                 -1.698101e-01     6.713610e-03
#> 915                                 -2.208634e-01     9.183428e-02
#> 916                                 -3.148690e-01     1.648137e-01
#> 917                                 -2.087380e-01     4.174242e-02
#> 918                                  0.000000e+00     0.000000e+00
#> 919                                  0.000000e+00     0.000000e+00
#> 920                                 -2.177145e-01     1.494480e-01
#> 921                                 -2.858748e-01     2.081463e-01
#> 922                                  0.000000e+00     0.000000e+00
#> 923                                 -1.360667e-01     4.367765e-03
#> 924                                 -2.087769e-01     6.281309e-02
#> 925                                  0.000000e+00     0.000000e+00
#> 926                                 -2.844172e-01     9.192407e-02
#> 927                                  0.000000e+00     0.000000e+00
#> 928                                  0.000000e+00     0.000000e+00
#> 929                                 -3.345922e-07     2.594809e-01
#> 930                                 -2.859640e-01     7.703817e-02
#> 931                                 -2.791456e-01     2.918933e-01
#> 932                                 -2.469812e-01     1.742067e-02
#> 933                                 -2.991351e-01     8.809394e-02
#> 934                                 -7.649020e-07     1.328247e-01
#> 935                                 -3.005279e-01     1.983461e-01
#> 936                                 -2.717651e-01     3.336909e-06
#> 937                                 -1.255363e-01     4.926207e-02
#> 938                                 -7.673093e-02     4.701535e-02
#> 939                                 -2.686862e-01     5.505997e-02
#> 940                                  0.000000e+00     0.000000e+00
#> 941                                  0.000000e+00     0.000000e+00
#> 942                                 -2.138094e-01     2.846441e-01
#> 943                                 -8.395082e-02     2.964873e-02
#> 944                                 -7.438645e-02     1.901515e-01
#> 945                                  0.000000e+00     0.000000e+00
#> 946                                 -1.864028e-01     1.876844e-02
#> 947                                  0.000000e+00     0.000000e+00
#> 948                                  0.000000e+00     0.000000e+00
#> 949                                 -2.841496e-01     5.947810e-02
#> 950                                 -2.342793e-01     4.725077e-02
#> 951                                  0.000000e+00     9.316054e-02
#> 952                                  0.000000e+00     7.872640e-02
#> 953                                 -2.577165e-01     1.547822e-01
#> 954                                  0.000000e+00     0.000000e+00
#> 955                                 -3.063711e-01     9.233226e-03
#> 956                                  0.000000e+00     0.000000e+00
#> 957                                  0.000000e+00     0.000000e+00
#> 958                                 -2.813833e-01     5.803505e-02
#> 959                                  3.229267e-07     1.951225e-01
#> 960                                  0.000000e+00     0.000000e+00
#> 961                                  1.076422e-07     1.125794e-01
#> 962                                  0.000000e+00     0.000000e+00
#> 963                                  0.000000e+00     0.000000e+00
#> 964                                 -1.839466e-01     3.548992e-02
#> 965                                 -1.142187e-01     1.457840e-02
#> 966                                 -2.449605e-01     9.744879e-02
#> 967                                  0.000000e+00     0.000000e+00
#> 968                                  0.000000e+00     0.000000e+00
#> 969                                  0.000000e+00     0.000000e+00
#> 970                                 -1.384366e-01     6.731583e-02
#> 971                                 -2.575379e-01     9.026070e-02
#> 972                                 -2.403793e-01     6.508942e-02
#> 973                                 -1.111299e-01     5.111819e-02
#> 974                                 -2.452274e-01     1.403169e-02
#> 975                                 -2.703649e-01     2.400866e-02
#> 976                                  0.000000e+00     0.000000e+00
#> 977                                 -2.998708e-01     2.253776e-01
#> 978                                  0.000000e+00     0.000000e+00
#> 979                                 -1.317126e-01     1.187932e-02
#> 980                                 -6.039861e-02     2.328518e-02
#> 981                                 -1.285599e-01     4.215443e-02
#> 982                                  1.613827e-07     9.431754e-02
#> 983                                 -1.540211e-01     6.422522e-02
#> 984                                 -1.812782e-01     7.425750e-02
#> 985                                 -2.310807e-01     1.534684e-02
#> 986                                 -1.710918e-01     1.129093e-01
#> 987                                 -2.153413e-01     1.445218e-01
#> 988                                  0.000000e+00     0.000000e+00
#> 989                                 -2.592051e-01     6.678328e-02
#> 990                                 -2.457562e-01     7.815376e-02
#> 991                                 -2.765996e-01     2.048813e-01
#> 992                                 -1.893597e-01     6.265322e-02
#> 993                                  0.000000e+00     0.000000e+00
#> 994                                 -2.144170e-01     1.534453e-01
#> 995                                 -3.237283e-01     1.373124e-01
#> 996                                  1.076422e-07     1.468525e-01
#> 997                                  0.000000e+00     0.000000e+00
#> 998                                  3.767478e-07     2.088346e-01
#> 999                                  0.000000e+00     0.000000e+00
#> 1000                                 0.000000e+00     0.000000e+00
#>      Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                  0.000000e+00                  0.000000e+00
#> 2                                  6.781461e-06                 -3.033495e-01
#> 3                                  2.018292e-07                 -1.778386e-01
#> 4                                  6.875648e-06                 -2.466158e-01
#> 5                                 -6.458534e-07                 -4.288439e-02
#> 6                                  4.305689e-07                 -1.088746e-01
#> 7                                 -7.534956e-07                 -6.012100e-02
#> 8                                  1.668455e-06                 -2.012278e-01
#> 9                                  1.291707e-06                 -8.859761e-02
#> 10                                 8.073167e-08                 -9.168217e-02
#> 11                                 2.018292e-07                 -2.002912e-01
#> 12                                 6.458534e-07                 -2.402191e-01
#> 13                                 0.000000e+00                  0.000000e+00
#> 14                                 4.036584e-07                 -1.556360e-01
#> 15                                 1.883739e-07                 -1.169424e-01
#> 16                                 0.000000e+00                  0.000000e+00
#> 17                                 0.000000e+00                 -7.915649e-02
#> 18                                 0.000000e+00                  0.000000e+00
#> 19                                 4.171136e-07                 -1.761276e-01
#> 20                                 1.614633e-07                 -7.920141e-02
#> 21                                 1.883739e-07                 -1.831287e-01
#> 22                                 4.171136e-07                 -2.284336e-01
#> 23                                 0.000000e+00                  0.000000e+00
#> 24                                 0.000000e+00                  0.000000e+00
#> 25                                 1.668455e-06                 -1.847278e-01
#> 26                                 4.709348e-08                 -1.483675e-01
#> 27                                 0.000000e+00                  0.000000e+00
#> 28                                 6.875648e-06                 -3.410878e-01
#> 29                                 3.229267e-07                 -1.740487e-01
#> 30                                 5.045730e-09                 -2.244806e-01
#> 31                                 0.000000e+00                 -1.257795e-03
#> 32                                -2.583414e-06                 -2.019398e-01
#> 33                                 0.000000e+00                  0.000000e+00
#> 34                                 1.695365e-06                 -2.124517e-01
#> 35                                 0.000000e+00                  0.000000e+00
#> 36                                 3.767478e-07                 -1.650847e-01
#> 37                                 1.715548e-06                 -1.681689e-01
#> 38                                -7.534956e-07                 -8.119084e-02
#> 39                                -4.305689e-07                 -2.072217e-01
#> 40                                -8.611379e-07                 -2.578959e-02
#> 41                                 1.708820e-06                 -2.235976e-01
#> 42                                 4.036584e-08                 -1.558993e-01
#> 43                                -3.767478e-07                 -1.069850e-01
#> 44                                -8.073167e-08                 -6.256130e-02
#> 45                                 3.431096e-06                 -2.206139e-01
#> 46                                -1.076422e-07                 -2.942815e-02
#> 47                                 6.781461e-06                 -3.271491e-01
#> 48                                 3.417641e-06                 -3.588406e-01
#> 49                                 0.000000e+00                  0.000000e+00
#> 50                                 6.727639e-09                 -5.538894e-02
#> 51                                 0.000000e+00                  0.000000e+00
#> 52                                 0.000000e+00                 -1.079960e-01
#> 53                                 0.000000e+00                  0.000000e+00
#> 54                                 4.036584e-07                 -1.791923e-01
#> 55                                 8.073167e-08                 -7.182729e-02
#> 56                                 0.000000e+00                  0.000000e+00
#> 57                                 0.000000e+00                 -1.076969e-01
#> 58                                 3.431096e-06                 -2.642104e-01
#> 59                                 3.013983e-06                 -2.170277e-01
#> 60                                 1.708820e-06                 -3.378055e-01
#> 61                                 3.767478e-07                 -5.348901e-02
#> 62                                 1.883739e-07                 -7.427280e-02
#> 63                                 1.614633e-07                 -1.179886e-01
#> 64                                 0.000000e+00                  0.000000e+00
#> 65                                 0.000000e+00                  0.000000e+00
#> 66                                 0.000000e+00                  0.000000e+00
#> 67                                 1.076422e-07                 -7.147109e-02
#> 68                                 2.691056e-08                 -4.309622e-02
#> 69                                 0.000000e+00                  0.000000e+00
#> 70                                 8.476826e-07                 -9.874366e-02
#> 71                                 0.000000e+00                  0.000000e+00
#> 72                                 0.000000e+00                  0.000000e+00
#> 73                                -4.305689e-07                 -2.506617e-01
#> 74                                 0.000000e+00                  0.000000e+00
#> 75                                 0.000000e+00                  0.000000e+00
#> 76                                 0.000000e+00                  0.000000e+00
#> 77                                 0.000000e+00                  0.000000e+00
#> 78                                 1.883739e-07                 -1.530765e-01
#> 79                                 0.000000e+00                 -8.589433e-03
#> 80                                 1.614633e-07                 -1.245089e-01
#> 81                                 0.000000e+00                  0.000000e+00
#> 82                                 0.000000e+00                  0.000000e+00
#> 83                                 5.382112e-08                 -1.631232e-01
#> 84                                -3.767478e-07                 -9.016255e-02
#> 85                                 3.437824e-06                 -2.792126e-01
#> 86                                 0.000000e+00                  0.000000e+00
#> 87                                 0.000000e+00                  0.000000e+00
#> 88                                 0.000000e+00                  0.000000e+00
#> 89                                 1.614633e-07                 -7.549641e-02
#> 90                                 0.000000e+00                 -1.236513e-01
#> 91                                 3.417641e-06                 -2.986648e-01
#> 92                                 0.000000e+00                  0.000000e+00
#> 93                                 1.614633e-06                 -4.326396e-02
#> 94                                -7.534956e-07                 -8.230632e-02
#> 95                                 8.342273e-07                 -1.956394e-01
#> 96                                 0.000000e+00                  0.000000e+00
#> 97                                 3.417641e-06                 -6.518530e-02
#> 98                                 3.229267e-07                 -2.548818e-01
#> 99                                 4.036584e-08                 -6.770853e-02
#> 100                                0.000000e+00                  0.000000e+00
#> 101                                1.708820e-06                 -2.972276e-01
#> 102                               -7.534956e-07                 -9.459673e-02
#> 103                               -1.007140e-01                 -2.119990e-01
#> 104                               -8.073167e-07                 -3.973810e-02
#> 105                                0.000000e+00                  0.000000e+00
#> 106                                3.229267e-06                 -1.209401e-01
#> 107                               -7.534956e-07                 -6.747280e-02
#> 108                                6.835282e-06                 -3.713337e-01
#> 109                                6.835282e-06                 -2.255673e-01
#> 110                                3.229267e-07                 -2.737808e-02
#> 111                                0.000000e+00                  0.000000e+00
#> 112                                0.000000e+00                  0.000000e+00
#> 113                                0.000000e+00                  0.000000e+00
#> 114                                0.000000e+00                  0.000000e+00
#> 115                                9.418695e-08                 -1.342443e-01
#> 116                                4.171136e-07                 -2.186801e-01
#> 117                                0.000000e+00                  0.000000e+00
#> 118                                2.085568e-07                 -1.202946e-01
#> 119                                1.076422e-07                 -5.882080e-02
#> 120                                0.000000e+00                  0.000000e+00
#> 121                               -5.382112e-08                 -3.410936e-02
#> 122                                0.000000e+00                  0.000000e+00
#> 123                                0.000000e+00                  0.000000e+00
#> 124                                0.000000e+00                  0.000000e+00
#> 125                                0.000000e+00                  0.000000e+00
#> 126                                0.000000e+00                  0.000000e+00
#> 127                                0.000000e+00                  0.000000e+00
#> 128                                0.000000e+00                  0.000000e+00
#> 129                                2.152845e-07                 -6.594792e-02
#> 130                                8.342273e-07                 -1.508240e-01
#> 131                                1.708820e-06                 -3.293813e-01
#> 132                                0.000000e+00                  0.000000e+00
#> 133                                1.614633e-07                 -1.673445e-01
#> 134                                6.458534e-07                 -2.628379e-01
#> 135                                0.000000e+00                  0.000000e+00
#> 136                                1.076422e-07                 -1.475990e-01
#> 137                                0.000000e+00                  0.000000e+00
#> 138                                1.708820e-06                 -2.597891e-01
#> 139                                1.708820e-06                 -1.056943e-01
#> 140                                0.000000e+00                  0.000000e+00
#> 141                                1.291707e-06                 -2.664757e-01
#> 142                                0.000000e+00                 -8.952008e-02
#> 143                                0.000000e+00                 -1.268310e-03
#> 144                                8.476826e-07                 -1.427458e-01
#> 145                                1.009146e-07                 -1.656055e-01
#> 146                                6.882375e-06                 -3.597160e-01
#> 147                                1.614633e-07                 -1.774714e-01
#> 148                                0.000000e+00                  0.000000e+00
#> 149                                7.534956e-07                 -2.057873e-01
#> 150                                1.614633e-07                 -6.044586e-06
#> 151                                5.382112e-08                 -3.146820e-02
#> 152                               -1.614633e-06                 -3.817617e-02
#> 153                                0.000000e+00                  0.000000e+00
#> 154                                3.229267e-07                 -5.709208e-02
#> 155                                0.000000e+00                  0.000000e+00
#> 156                                2.152845e-07                 -1.515864e-01
#> 157                                0.000000e+00                  0.000000e+00
#> 158                                3.417641e-06                 -3.259501e-01
#> 159                                2.018292e-07                 -1.432096e-01
#> 160                               -3.570216e-02                 -1.087483e-01
#> 161                                0.000000e+00                 -2.370396e-02
#> 162                                0.000000e+00                  0.000000e+00
#> 163                                1.883739e-07                 -1.443636e-01
#> 164                                1.614633e-07                 -7.905510e-02
#> 165                               -1.076422e-07                 -9.484275e-02
#> 166                                0.000000e+00                  0.000000e+00
#> 167                               -2.152845e-07                 -8.392672e-02
#> 168                                0.000000e+00                  0.000000e+00
#> 169                                1.883739e-07                 -1.342494e-01
#> 170                                4.171136e-07                 -1.993718e-01
#> 171                               -1.076422e-07                 -7.723739e-02
#> 172                                0.000000e+00                  0.000000e+00
#> 173                               -3.229267e-07                 -8.700248e-02
#> 174                                1.076422e-07                 -4.835568e-02
#> 175                                1.883739e-07                 -1.605433e-01
#> 176                                7.534956e-07                 -9.298050e-02
#> 177                                7.534956e-07                  6.681033e-06
#> 178                                6.835282e-06                 -3.117840e-01
#> 179                                2.144435e-07                 -2.701087e-01
#> 180                               -3.229267e-07                 -1.094887e-01
#> 181                                3.390730e-06                 -2.892830e-01
#> 182                                3.417641e-06                 -2.410797e-01
#> 183                                1.614633e-07                 -1.293673e-01
#> 184                               -2.018292e-07                 -9.948670e-02
#> 185                               -8.342273e-07                 -5.296382e-02
#> 186                                8.544102e-07                 -2.028221e-01
#> 187                                0.000000e+00                 -7.419452e-02
#> 188                                3.390730e-06                 -1.534113e-01
#> 189                                0.000000e+00                  0.000000e+00
#> 190                               -1.454414e-02                 -1.467372e-01
#> 191                                0.000000e+00                  0.000000e+00
#> 192                                3.390730e-06                 -2.843500e-01
#> 193                                8.073167e-07                 -2.719114e-01
#> 194                                4.709348e-08                 -7.774495e-02
#> 195                               -3.767478e-07                 -8.893870e-02
#> 196                                0.000000e+00                  0.000000e+00
#> 197                                0.000000e+00                  0.000000e+00
#> 198                               -8.073167e-08                 -4.819164e-02
#> 199                                0.000000e+00                  0.000000e+00
#> 200                                8.544102e-07                 -2.229484e-01
#> 201                                0.000000e+00                  0.000000e+00
#> 202                                3.437824e-06                 -2.251037e-01
#> 203                                8.611379e-07                 -2.095341e-01
#> 204                                0.000000e+00                  0.000000e+00
#> 205                               -1.076422e-07                 -8.711033e-02
#> 206                                0.000000e+00                  0.000000e+00
#> 207                                0.000000e+00                  0.000000e+00
#> 208                                8.342273e-07                 -2.642865e-01
#> 209                                0.000000e+00                  0.000000e+00
#> 210                                8.476826e-07                 -1.379008e-01
#> 211                                1.668455e-06                 -2.662807e-01
#> 212                                0.000000e+00                  0.000000e+00
#> 213                                1.076422e-07                 -1.048244e-01
#> 214                                2.018292e-07                 -1.705507e-01
#> 215                               -6.104269e-02                 -1.869501e-01
#> 216                                0.000000e+00                  0.000000e+00
#> 217                                0.000000e+00                  0.000000e+00
#> 218                                0.000000e+00                  0.000000e+00
#> 219                                0.000000e+00                  0.000000e+00
#> 220                                0.000000e+00                  0.000000e+00
#> 221                                0.000000e+00                  0.000000e+00
#> 222                                0.000000e+00                  0.000000e+00
#> 223                                0.000000e+00                  0.000000e+00
#> 224                                8.342273e-07                 -6.998794e-02
#> 225                                0.000000e+00                 -1.416296e-01
#> 226                                2.691056e-08                 -8.889289e-02
#> 227                                5.382112e-08                 -1.069253e-01
#> 228                                0.000000e+00                  0.000000e+00
#> 229                                3.013983e-06                 -8.110416e-02
#> 230                                8.577740e-07                 -2.113083e-01
#> 231                                6.885739e-06                 -3.770670e-01
#> 232                               -1.076422e-07                 -5.712268e-02
#> 233                               -1.076422e-07                 -1.062536e-01
#> 234                                1.614633e-07                 -1.590773e-01
#> 235                                0.000000e+00                  0.000000e+00
#> 236                               -3.767478e-07                 -7.096916e-02
#> 237                                0.000000e+00                  0.000000e+00
#> 238                                0.000000e+00                  0.000000e+00
#> 239                                0.000000e+00                  0.000000e+00
#> 240                                0.000000e+00                  0.000000e+00
#> 241                                0.000000e+00                  0.000000e+00
#> 242                                0.000000e+00                  0.000000e+00
#> 243                                1.614633e-07                 -1.417982e-01
#> 244                                0.000000e+00                  0.000000e+00
#> 245                                0.000000e+00                  0.000000e+00
#> 246                                1.708820e-06                 -1.740731e-01
#> 247                                0.000000e+00                  0.000000e+00
#> 248                                0.000000e+00                 -1.942218e-02
#> 249                                6.781461e-06                 -3.381093e-01
#> 250                                3.767478e-07                 -1.574270e-01
#> 251                                1.695365e-06                 -1.394219e-01
#> 252                               -6.000529e-02                 -1.723248e-01
#> 253                                1.076422e-07                 -7.669939e-02
#> 254                                0.000000e+00                  0.000000e+00
#> 255                                0.000000e+00                  0.000000e+00
#> 256                                0.000000e+00                  0.000000e+00
#> 257                                8.073167e-07                 -2.490263e-01
#> 258                               -7.534956e-07                 -7.058340e-02
#> 259                                1.695365e-06                 -1.820046e-01
#> 260                                1.614633e-06                 -1.746694e-01
#> 261                                2.018292e-08                 -1.307056e-01
#> 262                                0.000000e+00                  0.000000e+00
#> 263                                4.238413e-07                 -3.213276e-01
#> 264                                1.668455e-06                 -3.145568e-01
#> 265                                6.882375e-06                 -3.126655e-01
#> 266                                0.000000e+00                  0.000000e+00
#> 267                                0.000000e+00                  0.000000e+00
#> 268                                1.715548e-06                 -2.531205e-01
#> 269                                1.722065e-06                 -2.834067e-01
#> 270                                4.036584e-07                 -1.521649e-01
#> 271                                1.668455e-06                 -2.041167e-01
#> 272                                0.000000e+00                  0.000000e+00
#> 273                                0.000000e+00                  0.000000e+00
#> 274                                0.000000e+00                  0.000000e+00
#> 275                                4.036584e-07                 -6.282974e-02
#> 276                                1.009146e-07                 -2.010889e-01
#> 277                                0.000000e+00                  0.000000e+00
#> 278                                1.708820e-06                 -1.802785e-01
#> 279                                0.000000e+00                  0.000000e+00
#> 280                                0.000000e+00                  0.000000e+00
#> 281                                0.000000e+00                  0.000000e+00
#> 282                                8.073167e-08                 -1.555664e-01
#> 283                                0.000000e+00                  0.000000e+00
#> 284                                0.000000e+00                 -9.059806e-02
#> 285                               -4.305689e-07                 -1.454901e-01
#> 286                                0.000000e+00                  0.000000e+00
#> 287                               -4.305689e-07                 -4.921775e-02
#> 288                                1.708820e-06                 -2.845607e-01
#> 289                                7.534956e-07                 -2.860076e-01
#> 290                                0.000000e+00                  0.000000e+00
#> 291                                0.000000e+00                  0.000000e+00
#> 292                                0.000000e+00                  0.000000e+00
#> 293                                0.000000e+00                 -2.498031e-01
#> 294                                0.000000e+00                  0.000000e+00
#> 295                                0.000000e+00                  0.000000e+00
#> 296                                0.000000e+00                  0.000000e+00
#> 297                                0.000000e+00                  0.000000e+00
#> 298                               -1.614633e-07                 -1.082468e-01
#> 299                                0.000000e+00                  0.000000e+00
#> 300                                1.076422e-07                 -4.717496e-02
#> 301                                0.000000e+00                  0.000000e+00
#> 302                                8.342273e-07                 -1.992970e-01
#> 303                                0.000000e+00                  0.000000e+00
#> 304                                4.171136e-07                 -1.649261e-01
#> 305                                0.000000e+00                  0.000000e+00
#> 306                               -1.614633e-07                 -3.847819e-02
#> 307                                5.382112e-08                 -9.834403e-02
#> 308                                0.000000e+00                  0.000000e+00
#> 309                                0.000000e+00                  0.000000e+00
#> 310                                1.614633e-06                 -2.324692e-01
#> 311                                0.000000e+00                  0.000000e+00
#> 312                                0.000000e+00                  0.000000e+00
#> 313                                0.000000e+00                  0.000000e+00
#> 314                                0.000000e+00                  0.000000e+00
#> 315                                0.000000e+00                 -2.428211e-01
#> 316                                0.000000e+00                  0.000000e+00
#> 317                                0.000000e+00                  0.000000e+00
#> 318                                8.073167e-07                 -8.817399e-02
#> 319                                2.152845e-07                  2.107489e-06
#> 320                                1.076422e-07                 -1.779502e-01
#> 321                                1.076422e-07                 -1.042512e-01
#> 322                                5.382112e-08                 -1.397424e-01
#> 323                               -8.664642e-02                 -1.879892e-01
#> 324                               -8.611379e-07                 -1.557032e-01
#> 325                               -1.614633e-07                 -5.860215e-02
#> 326                                0.000000e+00                  0.000000e+00
#> 327                                0.000000e+00                  0.000000e+00
#> 328                                8.476826e-07                 -2.014774e-01
#> 329                                1.708820e-06                 -1.295452e-01
#> 330                                0.000000e+00                  0.000000e+00
#> 331                               -8.073167e-07                 -8.024849e-02
#> 332                                0.000000e+00                 -1.537729e-01
#> 333                                1.506991e-06                 -2.192505e-01
#> 334                                6.458534e-07                 -1.816513e-02
#> 335                                4.171136e-07                 -2.026335e-01
#> 336                                7.534956e-07                 -2.789209e-01
#> 337                                3.437824e-06                 -3.127956e-01
#> 338                                0.000000e+00                 -1.027414e-01
#> 339                                0.000000e+00                  0.000000e+00
#> 340                                0.000000e+00                  0.000000e+00
#> 341                                1.076422e-07                 -1.180346e-01
#> 342                                8.611379e-07                 -2.938149e-02
#> 343                                3.390730e-06                 -6.698579e-02
#> 344                                1.076422e-07                 -1.686262e-01
#> 345                                0.000000e+00                  0.000000e+00
#> 346                                1.076422e-07                 -1.822686e-01
#> 347                                0.000000e+00                  0.000000e+00
#> 348                                3.229267e-07                 -2.704713e-01
#> 349                                7.534956e-07                 -3.400096e-02
#> 350                                4.036584e-07                 -2.120173e-01
#> 351                                0.000000e+00                 -5.625775e-02
#> 352                                6.027965e-06                 -2.437333e-01
#> 353                                0.000000e+00                 -3.131715e-01
#> 354                                8.073167e-07                 -1.605471e-01
#> 355                                6.781461e-06                 -3.550654e-01
#> 356                                0.000000e+00                  0.000000e+00
#> 357                               -2.310336e-02                 -1.259916e-01
#> 358                                0.000000e+00                  0.000000e+00
#> 359                                0.000000e+00                  0.000000e+00
#> 360                                8.476826e-07                 -2.133978e-01
#> 361                                3.767478e-07                 -1.068173e-01
#> 362                                0.000000e+00                  0.000000e+00
#> 363                                8.476826e-07                 -1.484804e-01
#> 364                                3.336909e-06                 -1.688799e-01
#> 365                                1.883739e-07                 -1.580840e-01
#> 366                                2.102387e-10                 -1.139640e-01
#> 367                                0.000000e+00                 -1.363817e-01
#> 368                                5.382112e-08                 -1.754812e-01
#> 369                                0.000000e+00                 -4.967104e-02
#> 370                                6.875648e-06                 -3.114503e-01
#> 371                               -7.534956e-07                 -4.467515e-02
#> 372                                4.238413e-07                 -1.845064e-01
#> 373                               -1.076422e-07                 -8.036855e-02
#> 374                                0.000000e+00                  0.000000e+00
#> 375                                0.000000e+00                  0.000000e+00
#> 376                                2.152779e-07                 -1.475753e-01
#> 377                               -3.584990e-02                 -1.343553e-01
#> 378                               -1.076422e-07                 -2.908797e-02
#> 379                                1.883739e-07                 -1.596472e-01
#> 380                                0.000000e+00                  0.000000e+00
#> 381                               -9.316055e-02                 -2.631137e-01
#> 382                                0.000000e+00                  0.000000e+00
#> 383                                4.171136e-07                 -1.136121e-01
#> 384                                0.000000e+00                  0.000000e+00
#> 385                                2.152845e-07                 -1.135896e-01
#> 386                                8.073167e-07                 -1.741319e-01
#> 387                                1.076422e-07                 -9.672936e-02
#> 388                                1.009146e-07                 -1.597827e-01
#> 389                                0.000000e+00                  0.000000e+00
#> 390                                1.668455e-06                 -3.007897e-01
#> 391                               -1.291707e-06                 -1.902631e-01
#> 392                               -3.013983e-06                 -6.307486e-02
#> 393                                8.476826e-07                 -1.885813e-01
#> 394                                3.767478e-07                 -2.546724e-01
#> 395                                0.000000e+00                  0.000000e+00
#> 396                                3.229267e-07                 -1.568602e-01
#> 397                                0.000000e+00                  0.000000e+00
#> 398                                6.307162e-09                 -5.699049e-02
#> 399                                0.000000e+00                  0.000000e+00
#> 400                                0.000000e+00                  0.000000e+00
#> 401                                5.382112e-08                 -1.082136e-01
#> 402                                0.000000e+00                  0.000000e+00
#> 403                                1.695365e-06                 -2.478384e-01
#> 404                                4.709348e-08                 -1.063318e-01
#> 405                                0.000000e+00                  0.000000e+00
#> 406                                8.602969e-07                 -3.092547e-01
#> 407                                0.000000e+00                 -6.771425e-02
#> 408                                0.000000e+00                  0.000000e+00
#> 409                                8.476826e-07                 -1.552371e-01
#> 410                                8.577740e-07                 -9.927170e-02
#> 411                               -7.534956e-07                 -6.285910e-02
#> 412                                0.000000e+00                 -7.544428e-02
#> 413                                0.000000e+00                  0.000000e+00
#> 414                                3.767478e-07                 -1.048010e-01
#> 415                                8.342273e-07                 -1.863863e-01
#> 416                                6.781461e-06                 -2.535602e-01
#> 417                                2.018292e-07                 -1.724896e-01
#> 418                                0.000000e+00                 -2.759899e-02
#> 419                                0.000000e+00                  0.000000e+00
#> 420                                8.073167e-07                 -3.842175e-02
#> 421                                0.000000e+00                  0.000000e+00
#> 422                                0.000000e+00                  0.000000e+00
#> 423                               -7.534956e-07                 -4.513948e-02
#> 424                                8.342273e-07                 -2.822678e-01
#> 425                                3.336909e-06                 -1.483729e-01
#> 426                                0.000000e+00                 -7.480793e-02
#> 427                               -1.506991e-06                 -5.600305e-02
#> 428                                4.238413e-07                 -1.944854e-01
#> 429                                1.883739e-07                 -1.272539e-01
#> 430                                3.229267e-07                 -2.580544e-01
#> 431                                1.614633e-06                 -1.833323e-01
#> 432                               -1.076422e-07                 -1.188523e-01
#> 433                                0.000000e+00                 -1.231078e-01
#> 434                               -2.152845e-07                 -4.623766e-02
#> 435                                4.171136e-07                 -1.734937e-01
#> 436                                0.000000e+00                  0.000000e+00
#> 437                                0.000000e+00                  0.000000e+00
#> 438                                1.883739e-07                 -1.458079e-01
#> 439                                0.000000e+00                  0.000000e+00
#> 440                               -3.767478e-07                 -6.243948e-02
#> 441                                0.000000e+00                  0.000000e+00
#> 442                                2.691056e-08                 -7.495453e-02
#> 443                                0.000000e+00                  0.000000e+00
#> 444                                4.171136e-07                 -1.905031e-01
#> 445                               -1.614633e-07                 -1.064901e-01
#> 446                                0.000000e+00                 -2.619607e-01
#> 447                                3.229267e-07                 -1.061961e-01
#> 448                                7.534956e-07                 -2.966649e-01
#> 449                                8.073167e-08                 -1.404573e-01
#> 450                                0.000000e+00                 -1.210454e-01
#> 451                                3.437824e-06                 -1.494794e-01
#> 452                                0.000000e+00                  0.000000e+00
#> 453                                0.000000e+00                  0.000000e+00
#> 454                               -1.722276e-06                 -3.170955e-01
#> 455                                3.336909e-06                 -1.544856e-01
#> 456                               -6.458534e-07                 -6.739283e-02
#> 457                                0.000000e+00                 -1.427807e-02
#> 458                                1.708820e-06                 -3.146702e-01
#> 459                                7.534956e-07                 -1.336499e-01
#> 460                                4.036584e-07                 -1.603584e-01
#> 461                                1.695365e-06                 -2.425426e-01
#> 462                                0.000000e+00                  0.000000e+00
#> 463                                1.614633e-06                 -3.344812e-01
#> 464                                1.883739e-07                 -9.915197e-02
#> 465                                6.862192e-06                 -3.214563e-01
#> 466                                0.000000e+00                  0.000000e+00
#> 467                                0.000000e+00                  0.000000e+00
#> 468                                1.883739e-07                 -1.772855e-01
#> 469                                0.000000e+00                  0.000000e+00
#> 470                                0.000000e+00                  0.000000e+00
#> 471                                1.718912e-06                 -3.596867e-01
#> 472                               -3.767478e-07                 -3.282086e-02
#> 473                               -4.305689e-07                 -7.184578e-03
#> 474                                0.000000e+00                  0.000000e+00
#> 475                                3.441188e-06                 -2.410861e-01
#> 476                                0.000000e+00                  0.000000e+00
#> 477                                0.000000e+00                  0.000000e+00
#> 478                                3.437824e-06                 -3.775686e-01
#> 479                                0.000000e+00                  0.000000e+00
#> 480                                0.000000e+00                  0.000000e+00
#> 481                                0.000000e+00                  0.000000e+00
#> 482                                0.000000e+00                  0.000000e+00
#> 483                                8.476826e-07                 -1.581700e-01
#> 484                                0.000000e+00                  0.000000e+00
#> 485                               -4.305689e-07                 -1.683858e-01
#> 486                                4.036584e-07                 -6.188370e-02
#> 487                                0.000000e+00                  0.000000e+00
#> 488                               -4.305689e-07                 -8.357473e-02
#> 489                                0.000000e+00                  0.000000e+00
#> 490                                0.000000e+00                  0.000000e+00
#> 491                                8.342273e-07                 -2.156177e-01
#> 492                               -4.305689e-07                 -3.868851e-02
#> 493                                8.073167e-07                 -1.633000e-01
#> 494                               -3.903900e-02                 -1.569855e-01
#> 495                               -4.305689e-07                 -1.958203e-01
#> 496                                5.382112e-08                 -2.213734e-06
#> 497                                3.437824e-06                 -3.454189e-01
#> 498                                4.238413e-07                 -2.352182e-01
#> 499                                6.458534e-07                 -1.111222e-01
#> 500                                0.000000e+00                  0.000000e+00
#> 501                                0.000000e+00                  0.000000e+00
#> 502                               -8.611379e-07                 -1.903510e-01
#> 503                                2.018292e-07                 -1.791157e-01
#> 504                                0.000000e+00                  0.000000e+00
#> 505                                6.875648e-06                 -3.063899e-01
#> 506                                1.009146e-07                 -9.745484e-02
#> 507                                8.342273e-07                 -1.556965e-01
#> 508                                6.882375e-06                 -3.248411e-01
#> 509                                0.000000e+00                  0.000000e+00
#> 510                                0.000000e+00                  0.000000e+00
#> 511                                1.076422e-07                 -1.432820e-01
#> 512                                0.000000e+00                  0.000000e+00
#> 513                                4.238413e-07                 -1.206819e-01
#> 514                                5.382112e-08                 -1.028924e-01
#> 515                                1.614633e-07                 -1.151935e-01
#> 516                                2.018292e-07                 -1.907178e-01
#> 517                                1.883739e-07                 -1.278932e-01
#> 518                                0.000000e+00                  0.000000e+00
#> 519                                3.767478e-07                 -2.226408e-01
#> 520                                1.715548e-06                 -1.817448e-01
#> 521                                1.695365e-06                 -3.371687e-01
#> 522                                0.000000e+00                  0.000000e+00
#> 523                                3.767478e-07                 -2.769745e-01
#> 524                                8.602969e-07                 -2.092012e-01
#> 525                                0.000000e+00                  0.000000e+00
#> 526                                1.708820e-06                 -2.012945e-01
#> 527                                0.000000e+00                  0.000000e+00
#> 528                                0.000000e+00                  0.000000e+00
#> 529                                2.691056e-08                 -8.671714e-02
#> 530                                0.000000e+00                  0.000000e+00
#> 531                                0.000000e+00                  0.000000e+00
#> 532                                0.000000e+00                  0.000000e+00
#> 533                                0.000000e+00                  0.000000e+00
#> 534                                4.036584e-07                 -2.387757e-01
#> 535                                0.000000e+00                  0.000000e+00
#> 536                                0.000000e+00                  0.000000e+00
#> 537                                5.382112e-08                 -1.176208e-01
#> 538                                0.000000e+00                  0.000000e+00
#> 539                                0.000000e+00                  0.000000e+00
#> 540                                2.018292e-07                 -1.645705e-01
#> 541                                1.708820e-06                 -2.783554e-01
#> 542                                4.238413e-07                 -2.811559e-01
#> 543                                0.000000e+00                  0.000000e+00
#> 544                                0.000000e+00                 -1.667411e-01
#> 545                                0.000000e+00                  0.000000e+00
#> 546                                8.544102e-07                 -2.440848e-01
#> 547                                0.000000e+00                  0.000000e+00
#> 548                                0.000000e+00                 -1.210756e-01
#> 549                                8.342273e-07                 -2.771138e-01
#> 550                                0.000000e+00                  0.000000e+00
#> 551                                1.883739e-07                 -1.585980e-01
#> 552                                0.000000e+00                  0.000000e+00
#> 553                               -1.506991e-06                 -5.708214e-02
#> 554                                0.000000e+00                  0.000000e+00
#> 555                               -3.767478e-07                 -4.975909e-02
#> 556                               -6.458534e-07                 -7.624641e-02
#> 557                               -2.152845e-07                 -3.323464e-02
#> 558                                0.000000e+00                  0.000000e+00
#> 559                                4.171136e-07                 -1.689212e-01
#> 560                                5.382112e-08                 -7.841121e-02
#> 561                                0.000000e+00                  0.000000e+00
#> 562                                8.342273e-07                 -2.880318e-01
#> 563                                8.476826e-07                 -8.273773e-02
#> 564                                4.171136e-07                 -1.867052e-01
#> 565                                0.000000e+00                  0.000000e+00
#> 566                                0.000000e+00                  0.000000e+00
#> 567                               -2.691056e-08                 -1.552927e-02
#> 568                                0.000000e+00                 -2.008439e-01
#> 569                               -4.305689e-07                 -1.208382e-01
#> 570                                8.342273e-07                 -2.125849e-01
#> 571                                5.382112e-08                 -9.384756e-02
#> 572                               -4.305689e-07                 -1.382965e-02
#> 573                                0.000000e+00                  0.000000e+00
#> 574                                1.883739e-07                 -1.567591e-01
#> 575                                1.009146e-07                 -1.101196e-01
#> 576                                1.883739e-07                 -1.304297e-01
#> 577                                5.382112e-08                 -1.302480e-01
#> 578                                8.073167e-08                 -1.351921e-01
#> 579                                4.036584e-07                 -2.467722e-01
#> 580                                0.000000e+00                  0.000000e+00
#> 581                                0.000000e+00                  0.000000e+00
#> 582                                0.000000e+00                  0.000000e+00
#> 583                                0.000000e+00                  0.000000e+00
#> 584                                0.000000e+00                  0.000000e+00
#> 585                               -2.583414e-06                 -1.395451e-01
#> 586                                0.000000e+00                  0.000000e+00
#> 587                                1.076422e-07                 -9.618228e-02
#> 588                                8.073167e-07                 -2.006714e-01
#> 589                                0.000000e+00                  0.000000e+00
#> 590                                0.000000e+00                  0.000000e+00
#> 591                                0.000000e+00                  0.000000e+00
#> 592                                1.708820e-06                 -7.376607e-02
#> 593                                3.767478e-07                 -7.381916e-02
#> 594                               -1.681910e-09                 -2.949532e-02
#> 595                               -1.076422e-07                 -2.251281e-02
#> 596                                1.695365e-06                 -3.228084e-01
#> 597                                1.291707e-06                 -6.593675e-02
#> 598                                0.000000e+00                  0.000000e+00
#> 599                                3.767478e-07                 -1.717128e-01
#> 600                                3.229267e-06                 -6.841510e-03
#> 601                                4.238413e-07                 -1.907751e-01
#> 602                                1.614633e-07                 -6.944581e-02
#> 603                                0.000000e+00                 -1.817792e-01
#> 604                               -1.076422e-07                 -7.141294e-02
#> 605                                0.000000e+00                  0.000000e+00
#> 606                                3.417641e-06                 -3.779528e-01
#> 607                                1.715548e-06                 -1.837188e-01
#> 608                                0.000000e+00                  0.000000e+00
#> 609                                3.390730e-06                 -1.939372e-01
#> 610                                6.862192e-06                 -3.449548e-01
#> 611                                3.431096e-06                 -2.895888e-01
#> 612                                0.000000e+00                  0.000000e+00
#> 613                                0.000000e+00                 -1.315538e-01
#> 614                                3.767478e-07                 -2.001968e-01
#> 615                                0.000000e+00                  0.000000e+00
#> 616                                0.000000e+00                  0.000000e+00
#> 617                                4.171136e-07                 -1.581566e-01
#> 618                                1.614633e-07                 -1.397669e-01
#> 619                                1.668455e-06                 -2.727419e-01
#> 620                               -4.305689e-07                 -1.266107e-02
#> 621                                0.000000e+00                  0.000000e+00
#> 622                                0.000000e+00                  0.000000e+00
#> 623                                0.000000e+00                  0.000000e+00
#> 624                                0.000000e+00                  0.000000e+00
#> 625                                4.036584e-07                 -1.701690e-01
#> 626                               -1.291707e-06                 -3.132792e-02
#> 627                                0.000000e+00                  0.000000e+00
#> 628                                3.767478e-07                 -1.400668e-01
#> 629                                7.534956e-07                 -7.041686e-02
#> 630                                0.000000e+00                  0.000000e+00
#> 631                                0.000000e+00                  0.000000e+00
#> 632                                0.000000e+00                  0.000000e+00
#> 633                                0.000000e+00                  0.000000e+00
#> 634                                8.476826e-07                 -1.958623e-01
#> 635                                2.152845e-07                 -2.172917e-01
#> 636                                4.171136e-07                 -2.049066e-01
#> 637                               -7.534956e-07                 -8.559308e-02
#> 638                                1.059603e-07                 -1.342707e-01
#> 639                                0.000000e+00                  0.000000e+00
#> 640                                4.288870e-07                 -1.959641e-01
#> 641                                8.342273e-07                 -2.248724e-01
#> 642                                0.000000e+00                  0.000000e+00
#> 643                                6.458534e-07                 -2.080689e-01
#> 644                                8.476826e-07                 -2.437684e-01
#> 645                                1.708820e-06                 -2.548352e-01
#> 646                                0.000000e+00                  0.000000e+00
#> 647                                1.614633e-07                 -7.704977e-02
#> 648                                3.767478e-07                 -1.201124e-01
#> 649                                3.336909e-06                 -3.759109e-01
#> 650                                1.506991e-06                 -2.674858e-01
#> 651                                2.018292e-07                 -1.277244e-01
#> 652                                1.883739e-07                 -1.024691e-05
#> 653                                0.000000e+00                 -7.607472e-02
#> 654                                6.835282e-06                 -2.859394e-01
#> 655                                8.073167e-07                 -1.780481e-01
#> 656                                0.000000e+00                  0.000000e+00
#> 657                                0.000000e+00                  0.000000e+00
#> 658                                1.883739e-07                 -1.259262e-01
#> 659                                8.611379e-07                  4.474029e-06
#> 660                                4.036584e-07                 -1.201545e-01
#> 661                                0.000000e+00                 -1.129431e-01
#> 662                               -6.458534e-07                 -2.422291e-02
#> 663                                8.073167e-08                 -1.621725e-01
#> 664                                0.000000e+00                  0.000000e+00
#> 665                                0.000000e+00                  0.000000e+00
#> 666                                3.013983e-06                 -2.531584e-01
#> 667                                1.883739e-07                 -1.391739e-01
#> 668                                0.000000e+00                  0.000000e+00
#> 669                                0.000000e+00                  0.000000e+00
#> 670                                3.767478e-07                 -1.229005e-01
#> 671                                0.000000e+00                  0.000000e+00
#> 672                                4.272051e-07                 -2.338556e-01
#> 673                               -7.534956e-07                 -3.784665e-02
#> 674                                0.000000e+00                  0.000000e+00
#> 675                                0.000000e+00                 -1.768137e-01
#> 676                               -3.767478e-07                 -7.011711e-02
#> 677                               -1.076422e-07                 -1.051524e-01
#> 678                                0.000000e+00                  0.000000e+00
#> 679                                1.883739e-07                 -1.651322e-01
#> 680                                0.000000e+00                 -3.194624e-02
#> 681                                1.345528e-08                 -7.809063e-02
#> 682                                3.437824e-06                 -2.396702e-01
#> 683                                0.000000e+00                 -1.173021e-02
#> 684                                4.036584e-07                 -9.648967e-02
#> 685                                1.883739e-07                 -1.285070e-01
#> 686                                0.000000e+00                  0.000000e+00
#> 687                                8.544102e-07                 -2.989289e-01
#> 688                                0.000000e+00                  0.000000e+00
#> 689                                8.342273e-07                 -6.571297e-02
#> 690                                0.000000e+00                  0.000000e+00
#> 691                                0.000000e+00                 -4.307948e-02
#> 692                                6.673818e-06                 -9.168007e-02
#> 693                                1.506991e-06                 -1.841982e-01
#> 694                                0.000000e+00                  0.000000e+00
#> 695                                8.073167e-07                 -1.701133e-01
#> 696                                0.000000e+00                  0.000000e+00
#> 697                                0.000000e+00                  0.000000e+00
#> 698                                3.229267e-07                 -2.404197e-01
#> 699                                1.614633e-07                 -9.333346e-02
#> 700                                1.695365e-06                 -1.057883e-01
#> 701                                0.000000e+00                  0.000000e+00
#> 702                                4.272051e-07                 -1.912208e-01
#> 703                                2.144435e-07                 -1.860865e-01
#> 704                                6.673818e-06                 -5.436651e-02
#> 705                                3.013983e-06                 -2.780929e-01
#> 706                                4.036584e-07                 -1.889196e-01
#> 707                               -1.291707e-06                 -7.004766e-02
#> 708                                8.476826e-07                 -1.640046e-01
#> 709                                4.272051e-07                 -2.345119e-01
#> 710                                0.000000e+00                  0.000000e+00
#> 711                                0.000000e+00                  0.000000e+00
#> 712                                1.883739e-07                 -1.679181e-01
#> 713                                0.000000e+00                  0.000000e+00
#> 714                                1.668455e-06                 -2.622022e-01
#> 715                                3.229267e-07                 -4.912701e-02
#> 716                                1.614633e-06                 -1.695194e-01
#> 717                                0.000000e+00                  0.000000e+00
#> 718                                8.476826e-07                 -1.369458e-01
#> 719                                0.000000e+00                  0.000000e+00
#> 720                                0.000000e+00                 -1.364592e-01
#> 721                                0.000000e+00                  0.000000e+00
#> 722                                0.000000e+00                  0.000000e+00
#> 723                                0.000000e+00                  0.000000e+00
#> 724                               -1.076422e-07                 -2.708458e-02
#> 725                                0.000000e+00                  0.000000e+00
#> 726                                1.009146e-07                 -1.304710e-01
#> 727                                0.000000e+00                  0.000000e+00
#> 728                               -1.076422e-07                 -6.193644e-02
#> 729                                1.715548e-06                 -1.751806e-01
#> 730                                0.000000e+00                  0.000000e+00
#> 731                               -2.983909e-02                 -2.580535e-01
#> 732                                8.073167e-08                 -1.422718e-01
#> 733                                4.036584e-07                 -8.878476e-02
#> 734                               -6.458534e-07                 -1.330994e-01
#> 735                                0.000000e+00                  0.000000e+00
#> 736                                0.000000e+00                  0.000000e+00
#> 737                                1.695365e-06                 -2.269952e-01
#> 738                               -2.806610e-02                 -1.419809e-01
#> 739                               -8.611379e-07                 -2.765973e-01
#> 740                                5.382112e-08                 -1.058228e-01
#> 741                                3.431096e-06                 -3.404965e-01
#> 742                                4.171136e-07                 -1.951323e-01
#> 743                                0.000000e+00                  0.000000e+00
#> 744                                0.000000e+00                  0.000000e+00
#> 745                                0.000000e+00                  0.000000e+00
#> 746                                0.000000e+00                  0.000000e+00
#> 747                                0.000000e+00                  0.000000e+00
#> 748                                0.000000e+00                  0.000000e+00
#> 749                                3.390730e-06                 -2.358231e-01
#> 750                               -1.614633e-07                 -6.622087e-02
#> 751                                0.000000e+00                  0.000000e+00
#> 752                               -6.107094e-03                 -5.006926e-02
#> 753                               -4.305689e-07                 -1.956316e-01
#> 754                                1.718912e-06                 -2.481804e-01
#> 755                                4.171136e-07                 -1.957431e-01
#> 756                                0.000000e+00                  0.000000e+00
#> 757                                0.000000e+00                  0.000000e+00
#> 758                               -2.999901e-03                 -1.476699e-02
#> 759                               -7.534956e-07                 -1.608811e-01
#> 760                                0.000000e+00                  0.000000e+00
#> 761                                5.382112e-08                 -7.360054e-02
#> 762                                1.695365e-06                 -1.667938e-01
#> 763                                0.000000e+00                  0.000000e+00
#> 764                                7.534956e-07                 -1.584741e-01
#> 765                                0.000000e+00                  0.000000e+00
#> 766                               -3.767478e-07                 -7.082935e-02
#> 767                                0.000000e+00                  0.000000e+00
#> 768                               -4.907569e-02                 -1.910994e-01
#> 769                                0.000000e+00                 -1.181871e-01
#> 770                                0.000000e+00                  0.000000e+00
#> 771                                0.000000e+00                  0.000000e+00
#> 772                                1.883739e-07                 -7.329557e-02
#> 773                                0.000000e+00                  0.000000e+00
#> 774                                0.000000e+00                  0.000000e+00
#> 775                                8.544102e-07                 -2.502183e-01
#> 776                                1.614633e-07                 -1.063940e-01
#> 777                                0.000000e+00                  0.000000e+00
#> 778                                0.000000e+00                  0.000000e+00
#> 779                               -1.076422e-07                 -9.413404e-02
#> 780                               -1.506991e-06                 -3.187082e-02
#> 781                               -1.076422e-07                 -8.886014e-02
#> 782                                8.476826e-07                 -1.569509e-01
#> 783                                7.534956e-07                 -1.424440e-01
#> 784                                0.000000e+00                  0.000000e+00
#> 785                                0.000000e+00                  0.000000e+00
#> 786                                4.036584e-07                 -1.847612e-01
#> 787                                0.000000e+00                  0.000000e+00
#> 788                                0.000000e+00                  0.000000e+00
#> 789                                0.000000e+00                  0.000000e+00
#> 790                                0.000000e+00                  0.000000e+00
#> 791                                0.000000e+00                  0.000000e+00
#> 792                                0.000000e+00                  0.000000e+00
#> 793                                0.000000e+00                  0.000000e+00
#> 794                                0.000000e+00                  0.000000e+00
#> 795                                6.835282e-06                 -2.383350e-01
#> 796                                0.000000e+00                  0.000000e+00
#> 797                               -6.458534e-07                 -1.547077e-01
#> 798                                1.668455e-06                 -3.523286e-01
#> 799                                4.036584e-07                 -1.663501e-01
#> 800                                0.000000e+00                  0.000000e+00
#> 801                                0.000000e+00                  0.000000e+00
#> 802                               -4.305689e-07                 -1.309645e-02
#> 803                                0.000000e+00                  0.000000e+00
#> 804                                0.000000e+00                  0.000000e+00
#> 805                               -3.547962e-02                 -1.567163e-01
#> 806                                8.611379e-07                 -3.612382e-02
#> 807                                0.000000e+00                  0.000000e+00
#> 808                                0.000000e+00                  0.000000e+00
#> 809                                2.152845e-07                 -1.626728e-01
#> 810                               -8.611379e-07                 -2.444411e-01
#> 811                                4.036584e-07                 -1.551291e-01
#> 812                                0.000000e+00                  0.000000e+00
#> 813                                8.073167e-07                 -1.875298e-01
#> 814                                8.342273e-07                 -2.730614e-01
#> 815                                0.000000e+00                  0.000000e+00
#> 816                                2.018292e-07                 -7.682806e-02
#> 817                                1.614633e-07                 -8.490148e-02
#> 818                                0.000000e+00                  0.000000e+00
#> 819                                8.594559e-07                 -2.244786e-01
#> 820                                0.000000e+00                  0.000000e+00
#> 821                                4.171136e-07                 -1.902907e-01
#> 822                                1.883739e-07                 -1.592325e-01
#> 823                               -1.076422e-07                 -9.451594e-02
#> 824                                0.000000e+00                  0.000000e+00
#> 825                                4.171136e-07                 -1.879969e-01
#> 826                                8.073167e-08                 -5.587316e-06
#> 827                                4.272051e-07                 -2.902551e-01
#> 828                                2.085568e-07                 -1.731960e-01
#> 829                                1.009146e-07                 -1.662771e-01
#> 830                                1.883739e-07                 -1.097480e-01
#> 831                                4.171136e-07                 -1.029924e-01
#> 832                                3.437824e-06                 -2.159432e-01
#> 833                                2.018292e-07                 -1.976451e-01
#> 834                                0.000000e+00                  0.000000e+00
#> 835                                0.000000e+00                 -1.743694e-01
#> 836                                0.000000e+00                  0.000000e+00
#> 837                                0.000000e+00                  0.000000e+00
#> 838                                0.000000e+00                  0.000000e+00
#> 839                                8.577740e-07                 -2.671920e-01
#> 840                                1.718912e-06                 -2.559105e-01
#> 841                                0.000000e+00                  0.000000e+00
#> 842                               -3.767478e-07                 -7.791449e-02
#> 843                                2.152845e-07                 -2.398093e-01
#> 844                                0.000000e+00                  0.000000e+00
#> 845                               -7.534956e-07                 -6.800015e-02
#> 846                                0.000000e+00                  0.000000e+00
#> 847                                1.614633e-07                 -1.385011e-01
#> 848                                0.000000e+00                  0.000000e+00
#> 849                                0.000000e+00                  0.000000e+00
#> 850                                0.000000e+00                  0.000000e+00
#> 851                                0.000000e+00                  0.000000e+00
#> 852                                1.506991e-06                 -7.642113e-02
#> 853                               -2.583414e-06                 -2.457530e-01
#> 854                               -4.305689e-07                 -1.264479e-01
#> 855                                4.238413e-07                 -1.509883e-01
#> 856                                2.018292e-07                 -9.502113e-02
#> 857                                0.000000e+00                  0.000000e+00
#> 858                                4.288870e-07                 -9.069430e-02
#> 859                                3.431096e-06                 -2.076261e-01
#> 860                                1.076422e-07                 -1.498070e-01
#> 861                                8.544102e-07                 -3.044923e-01
#> 862                               -8.611379e-07                 -2.540935e-01
#> 863                                2.152845e-07                  4.883440e-06
#> 864                                0.000000e+00                  0.000000e+00
#> 865                               -6.458534e-07                 -4.841899e-02
#> 866                               -3.229267e-07                 -8.088573e-02
#> 867                                0.000000e+00                  0.000000e+00
#> 868                                1.883739e-07                 -1.403625e-01
#> 869                                0.000000e+00                  0.000000e+00
#> 870                                0.000000e+00                  0.000000e+00
#> 871                                0.000000e+00                  0.000000e+00
#> 872                                0.000000e+00                  0.000000e+00
#> 873                                0.000000e+00                 -9.739017e-02
#> 874                                6.458534e-07                 -1.303890e-01
#> 875                                6.885739e-06                 -3.686028e-01
#> 876                                3.437824e-06                 -3.110762e-01
#> 877                                0.000000e+00                  0.000000e+00
#> 878                                1.708820e-06                 -1.701721e-01
#> 879                                0.000000e+00                  0.000000e+00
#> 880                               -4.305689e-07                 -7.196964e-02
#> 881                                0.000000e+00                  0.000000e+00
#> 882                                3.390730e-06                 -2.202425e-01
#> 883                                3.229267e-07                 -2.466125e-01
#> 884                                0.000000e+00                  0.000000e+00
#> 885                                0.000000e+00                  0.000000e+00
#> 886                               -3.229267e-07                 -9.553704e-02
#> 887                                2.085568e-07                 -1.029464e-01
#> 888                                0.000000e+00                  0.000000e+00
#> 889                                4.036584e-07                 -1.743974e-01
#> 890                               -9.854217e-03                 -2.066158e-01
#> 891                                0.000000e+00                  0.000000e+00
#> 892                                3.336909e-06                 -1.694084e-01
#> 893                                6.887421e-06                 -3.843371e-01
#> 894                                1.076422e-07                 -7.577540e-02
#> 895                                4.171136e-07                 -1.980138e-01
#> 896                                0.000000e+00                 -9.924985e-02
#> 897                                0.000000e+00                  0.000000e+00
#> 898                                0.000000e+00                  0.000000e+00
#> 899                                4.171136e-07                 -2.342078e-01
#> 900                                0.000000e+00                  0.000000e+00
#> 901                                0.000000e+00                  0.000000e+00
#> 902                                0.000000e+00                  0.000000e+00
#> 903                                3.767478e-07                 -9.231782e-02
#> 904                               -2.152845e-07                 -1.211883e-01
#> 905                                6.458534e-07                 -2.519737e-01
#> 906                                0.000000e+00                  0.000000e+00
#> 907                                0.000000e+00                  0.000000e+00
#> 908                                1.614633e-07                 -1.623612e-01
#> 909                                0.000000e+00                  0.000000e+00
#> 910                                0.000000e+00                  0.000000e+00
#> 911                                0.000000e+00                  0.000000e+00
#> 912                                0.000000e+00                  0.000000e+00
#> 913                               -8.611379e-07                 -5.954563e-02
#> 914                                8.476826e-07                 -1.132855e-01
#> 915                                1.614633e-07                 -1.164197e-01
#> 916                                3.437824e-06                 -2.986999e-01
#> 917                                3.229267e-07                 -1.433568e-01
#> 918                                0.000000e+00                  0.000000e+00
#> 919                                0.000000e+00                  0.000000e+00
#> 920                                4.036584e-07                 -1.979789e-01
#> 921                                6.875648e-06                 -2.729824e-01
#> 922                                0.000000e+00                  0.000000e+00
#> 923                               -8.611379e-07                 -2.020671e-02
#> 924                                3.767478e-07                 -1.995857e-01
#> 925                                0.000000e+00                  0.000000e+00
#> 926                                2.085568e-07                 -1.252075e-01
#> 927                                0.000000e+00                  0.000000e+00
#> 928                                0.000000e+00                  0.000000e+00
#> 929                                2.018292e-08                 -3.176306e-06
#> 930                                1.883739e-07                 -1.155236e-01
#> 931                                3.431096e-06                 -1.008998e-01
#> 932                                7.534956e-07                 -5.134482e-02
#> 933                                1.883739e-07                 -1.023343e-01
#> 934                                1.614633e-07                 -1.624148e-01
#> 935                                3.417641e-06                 -2.417591e-01
#> 936                                3.336909e-06                 -1.487765e-01
#> 937                               -7.534956e-07                 -6.633171e-02
#> 938                               -1.614633e-07                 -6.916405e-02
#> 939                                1.668455e-06                 -3.330689e-01
#> 940                                0.000000e+00                  0.000000e+00
#> 941                                0.000000e+00                  0.000000e+00
#> 942                               -2.134642e-02                 -7.660848e-02
#> 943                               -3.229267e-07                 -4.953785e-02
#> 944                               -6.458534e-07                 -2.199982e-01
#> 945                                0.000000e+00                  0.000000e+00
#> 946                                6.673818e-06                 -3.381666e-01
#> 947                                0.000000e+00                  0.000000e+00
#> 948                                0.000000e+00                  0.000000e+00
#> 949                                8.342273e-07                 -2.187273e-01
#> 950                                1.076422e-07                 -9.470018e-02
#> 951                                0.000000e+00                 -2.036091e-01
#> 952                                0.000000e+00                 -2.340558e-01
#> 953                                4.288870e-07                 -2.750104e-01
#> 954                                0.000000e+00                  0.000000e+00
#> 955                                3.390730e-06                 -1.968854e-01
#> 956                                0.000000e+00                  0.000000e+00
#> 957                                0.000000e+00                  0.000000e+00
#> 958                                1.614633e-07                 -1.242576e-01
#> 959                                3.229267e-07                 -2.245363e-01
#> 960                                0.000000e+00                  0.000000e+00
#> 961                                1.076422e-07                 -2.402526e-01
#> 962                                0.000000e+00                  0.000000e+00
#> 963                                0.000000e+00                  0.000000e+00
#> 964                               -2.152845e-07                 -1.235189e-01
#> 965                               -2.213591e-02                 -5.319602e-02
#> 966                                1.883739e-07                 -1.415896e-01
#> 967                                0.000000e+00                  0.000000e+00
#> 968                                0.000000e+00                  0.000000e+00
#> 969                                0.000000e+00                  0.000000e+00
#> 970                               -1.076422e-07                 -7.659266e-02
#> 971                                4.036584e-07                 -2.019770e-01
#> 972                                3.767478e-07                 -1.560075e-01
#> 973                               -7.534956e-07                 -7.096067e-02
#> 974                                1.614633e-06                 -1.948164e-01
#> 975                                7.534956e-07                 -6.417110e-02
#> 976                                0.000000e+00                  0.000000e+00
#> 977                                3.437824e-06                 -3.707003e-01
#> 978                                0.000000e+00                  0.000000e+00
#> 979                               -1.076422e-07                 -1.268234e-02
#> 980                               -1.076422e-07                 -3.591439e-02
#> 981                                4.036584e-08                 -5.690407e-02
#> 982                               -2.152845e-07                 -1.386036e-01
#> 983                                0.000000e+00                 -9.568014e-02
#> 984                                1.614633e-07                 -1.078228e-01
#> 985                                4.036584e-07                 -1.524197e-01
#> 986                                5.382112e-08                 -1.252353e-01
#> 987                                3.417641e-06                 -3.090506e-01
#> 988                                0.000000e+00                  0.000000e+00
#> 989                                1.668455e-06                 -3.188845e-01
#> 990                                4.036584e-07                 -1.102110e-01
#> 991                               -7.249649e-02                 -3.025592e-01
#> 992                                0.000000e+00                 -8.320666e-02
#> 993                                0.000000e+00                  0.000000e+00
#> 994                                3.390730e-06                 -3.347436e-01
#> 995                                1.708820e-06                 -2.501160e-01
#> 996                                1.076422e-07                 -2.191691e-01
#> 997                                0.000000e+00                  0.000000e+00
#> 998                                3.767478e-07                 -2.796770e-01
#> 999                                0.000000e+00                  0.000000e+00
#> 1000                               0.000000e+00                  0.000000e+00
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   7.222542e-03  4.849458e-03
#> 3           Salts.Added.during.Water.Treatment   4.545325e-07  3.651625e-07
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.140610e-01 -1.208059e-01
#> 5                             Ecosystem.Health   5.806788e-02  5.399063e-02
#> 6   Public.Awareness.of.Reservoir.Salinization  -8.118733e-04 -1.255480e-03
#> 7                Salinization.of.the.Reservoir  -9.939710e-02 -1.054552e-01
#>        0.975_CI           min 0.25_quantile      median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00     1.0000000  1.00000000  1.000000e+00
#> 2  1.000520e-02 -3.013983e-06     0.0000000  0.00000000  4.246822e-07
#> 3  5.483506e-07 -1.042382e-05     0.0000000  0.00000000  4.171136e-07
#> 4 -1.067240e-01 -3.633416e-01    -0.2329354 -0.08370376  0.000000e+00
#> 5  6.297407e-02 -2.175523e-06     0.0000000  0.03438556  9.471291e-02
#> 6 -3.946715e-04 -1.007140e-01     0.0000000  0.00000000  4.070222e-07
#> 7 -9.343433e-02 -3.843371e-01    -0.1726662 -0.07693892  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 3.174085e-01
#> 3 6.887421e-06
#> 4 1.708820e-06
#> 5 3.746917e-01
#> 6 6.887421e-06
#> 7 6.681033e-06
#> 
get_fcmconfr_inferences(ex_tfn_fcmconfr)
#> $individual_inferences
#> $individual_inferences$tfn_df
#>    adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1      adj_matrix_1                           1, 1, 1
#> 2      adj_matrix_2                           1, 1, 1
#> 3      adj_matrix_3                           1, 1, 1
#> 4      adj_matrix_4                           1, 1, 1
#> 5      adj_matrix_5                           1, 1, 1
#> 6      adj_matrix_6                           1, 1, 1
#> 7      adj_matrix_7                           1, 1, 1
#> 8      adj_matrix_8                           1, 1, 1
#> 9      adj_matrix_9                           1, 1, 1
#> 10    adj_matrix_10                           1, 1, 1
#> 11    adj_matrix_11                           1, 1, 1
#> 12    adj_matrix_12                           1, 1, 1
#> 13    adj_matrix_13                           1, 1, 1
#> 14    adj_matrix_14                           1, 1, 1
#> 15    adj_matrix_15                           1, 1, 1
#> 16    adj_matrix_16                           1, 1, 1
#> 17    adj_matrix_17                           1, 1, 1
#> 18    adj_matrix_18                           1, 1, 1
#> 19    adj_matrix_19                           1, 1, 1
#> 20    adj_matrix_20                           1, 1, 1
#> 21    adj_matrix_21                           1, 1, 1
#> 22    adj_matrix_22                           1, 1, 1
#> 23    adj_matrix_23                           1, 1, 1
#> 24    adj_matrix_24                           1, 1, 1
#> 25    adj_matrix_25                           1, 1, 1
#> 26    adj_matrix_26                           1, 1, 1
#> 27    adj_matrix_27                           1, 1, 1
#> 28    adj_matrix_28                           1, 1, 1
#> 29    adj_matrix_29                           1, 1, 1
#> 30    adj_matrix_30                           1, 1, 1
#>                      Public.Education.Programs
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16          0.04966368, 0.21848409, 0.32487741
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>             Salts.Added.during.Water.Treatment
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2  -7.287071e-06, -3.781633e-06, -2.716813e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21    3.767478e-07, 3.767478e-07, 3.767478e-07
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>    Salts.Added.by.Winter.Maintenance.Activities
#> 1    -2.649185e-01, -1.202008e-01, 1.139210e-06
#> 2            -0.3439474, -0.2785144, -0.1419764
#> 3    -2.785162e-01, -1.419780e-01, 2.126505e-06
#> 4    -3.031965e-01, -1.823903e-01, 1.890719e-06
#> 5            -0.3439469, -0.2912555, -0.1627199
#> 6     -4.509185e-07, 0.000000e+00, 4.509185e-07
#> 7                                       0, 0, 0
#> 8                                       0, 0, 0
#> 9   -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10        -0.34394686, -0.25041551, -0.09747171
#> 11           -0.3439440, -0.3031899, -0.1823828
#> 12           -0.3439472, -0.2677088, -0.1246366
#> 13   -2.504161e-01, -9.747187e-02, 2.606899e-06
#> 14        -0.34394690, -0.25041556, -0.09747073
#> 15           -0.3439467, -0.2785133, -0.1419752
#> 16                                      0, 0, 0
#> 17   -2.184904e-01, -4.966970e-02, 1.394166e-05
#> 18                                      0, 0, 0
#> 19   -2.785142e-01, -1.419758e-01, 1.654658e-06
#> 20    -9.886287e-07, 0.000000e+00, 9.886287e-07
#> 21   -2.504168e-01, -9.747226e-02, 4.176917e-06
#> 22           -0.3439486, -0.3031974, -0.1823913
#> 23                                      0, 0, 0
#> 24   -3.031964e-01, -1.823909e-01, 5.964684e-07
#> 25                                      0, 0, 0
#> 26                                      0, 0, 0
#> 27                                      0, 0, 0
#> 28           -0.3439469, -0.2912555, -0.1627198
#> 29                                      0, 0, 0
#> 30    -8.650037e-07, 0.000000e+00, 8.650037e-07
#>                             Ecosystem.Health
#> 1         0.06562469, 0.13535978, 0.17443415
#> 2         0.06670194, 0.12905046, 0.15766445
#> 3         0.08583128, 0.17279319, 0.21861527
#> 4         0.02984654, 0.06344861, 0.08392516
#> 5         0.05803894, 0.12066305, 0.15650258
#> 6  -1.823495e-05, 0.000000e+00, 1.823495e-05
#> 7  -2.339399e-05, 0.000000e+00, 2.339399e-05
#> 8  -3.734027e-06, 0.000000e+00, 3.734027e-06
#> 9         0.03467809, 0.07980185, 0.11209770
#> 10        0.06987573, 0.12237908, 0.13478990
#> 11 -0.0000315184, 0.0106128025, 0.0317934762
#> 12        0.08394626, 0.15173773, 0.17475462
#> 13        0.01053170, 0.02454208, 0.03500210
#> 14           0.1781593, 0.3264510, 0.3882986
#> 15        0.01385923, 0.06857068, 0.12021737
#> 16 -9.634720e-07, 6.403258e-02, 1.241829e-01
#> 17 -2.132187e-05, 1.232420e-02, 3.687688e-02
#> 18 -1.785633e-05, 0.000000e+00, 1.785633e-05
#> 19        0.03776046, 0.07470845, 0.09264320
#> 20 -1.313644e-05, 0.000000e+00, 1.313644e-05
#> 21     0.003418647, 0.017170139, 0.030870109
#> 22        0.01581755, 0.07796207, 0.13569403
#> 23        0.09639699, 0.16507281, 0.18061849
#> 24        0.06100563, 0.10751282, 0.11864309
#> 25 -8.614831e-06, 0.000000e+00, 8.614831e-06
#> 26                                   0, 0, 0
#> 27 -2.207469e-05, 0.000000e+00, 2.207469e-05
#> 28           0.1179967, 0.2151298, 0.2542002
#> 29 -2.906392e-05, 0.000000e+00, 2.906392e-05
#> 30 -1.548227e-05, 0.000000e+00, 1.548227e-05
#>     Public.Awareness.of.Reservoir.Salinization
#> 1     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 2     4.238413e-07, 4.238413e-07, 4.238413e-07
#> 3        1.70882e-06, 1.70882e-06, 1.70882e-06
#> 4                                      0, 0, 0
#> 5     4.171136e-07, 4.171136e-07, 4.171136e-07
#> 6                                      0, 0, 0
#> 7                                      0, 0, 0
#> 8                                      0, 0, 0
#> 9  -1.076422e-07, -1.076422e-07, -1.076422e-07
#> 10    2.085568e-07, 2.085568e-07, 2.085568e-07
#> 11    4.305689e-07, 4.305689e-07, 4.305689e-07
#> 12    2.119206e-07, 2.119206e-07, 2.119206e-07
#> 13 -1.009146e-07, -1.009146e-07, -1.009146e-07
#> 14    1.695365e-06, 1.695365e-06, 1.695365e-06
#> 15    1.614633e-07, 1.614633e-07, 1.614633e-07
#> 16                                     0, 0, 0
#> 17 -1.506991e-06, -1.506991e-06, -1.506991e-06
#> 18                                     0, 0, 0
#> 19                                     0, 0, 0
#> 20                                     0, 0, 0
#> 21  -2.060992e-02, -6.872083e-03, 1.392007e-05
#> 22       1.70882e-06, 1.70882e-06, 1.70882e-06
#> 23                                     0, 0, 0
#> 24    8.073167e-08, 8.073167e-08, 8.073167e-08
#> 25                                     0, 0, 0
#> 26                                     0, 0, 0
#> 27                                     0, 0, 0
#> 28    8.476826e-07, 8.476826e-07, 8.476826e-07
#> 29                                     0, 0, 0
#> 30                                     0, 0, 0
#>                 Salinization.of.the.Reservoir
#> 1       -0.32624208, -0.19827639, -0.04468532
#> 2       -0.22174705, -0.18532772, -0.09925181
#> 3       -0.37279803, -0.28119287, -0.09659356
#> 4       -0.14517113, -0.08721721, -0.02423273
#> 5       -0.22912750, -0.18199123, -0.09103424
#> 6      -2.16743e-06, 0.00000e+00, 2.16743e-06
#> 7   -6.586473e-06, 0.000000e+00, 6.586473e-06
#> 8   -8.743405e-07, 0.000000e+00, 8.743405e-07
#> 9  -2.504205e-01, -9.747409e-02, 4.872594e-06
#> 10      -0.20499898, -0.15158721, -0.06831878
#> 11 -1.318708e-01, -2.758877e-02, 2.662699e-05
#> 12         -0.2153682, -0.2153676, -0.1396386
#> 13 -7.988033e-02, -2.548262e-02, 6.068898e-06
#> 14      -0.20499585, -0.16105880, -0.07934998
#> 15      -0.22173773, -0.14442093, -0.05060377
#> 16 -3.032049e-01, -1.823915e-01, 1.338811e-05
#> 17      -0.08755650, -0.06623863, -0.03117925
#> 18  -8.926425e-07, 0.000000e+00, 8.926425e-07
#> 19      -0.13352584, -0.10219718, -0.04873998
#> 20  -5.044662e-06, 0.000000e+00, 5.044662e-06
#> 21 -7.426995e-02, -2.892287e-02, 9.173772e-06
#> 22      -0.23592075, -0.16873413, -0.07092534
#> 23         -0.3248824, -0.2184897, -0.0496664
#> 24         -0.1519497, -0.1382799, -0.0795642
#> 25     -1.50192e-06, 0.00000e+00, 1.50192e-06
#> 26  -2.008037e-05, 0.000000e+00, 2.008037e-05
#> 27  -2.783859e-06, 0.000000e+00, 2.783859e-06
#> 28         -0.4136693, -0.3389161, -0.1665670
#> 29           -1.138e-05, 0.000e+00, 1.138e-05
#> 30  -3.414352e-06, 0.000000e+00, 3.414352e-06
#> 
#> $individual_inferences$lower_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              4.966368e-02
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -7.287071e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -2.649185e-01     6.562469e-02
#> 2                                 -3.439474e-01     6.670194e-02
#> 3                                 -2.785162e-01     8.583128e-02
#> 4                                 -3.031965e-01     2.984654e-02
#> 5                                 -3.439469e-01     5.803894e-02
#> 6                                 -4.509185e-07    -1.823495e-05
#> 7                                  0.000000e+00    -2.339399e-05
#> 8                                  0.000000e+00    -3.734027e-06
#> 9                                 -1.076422e-07     3.467809e-02
#> 10                                -3.439469e-01     6.987573e-02
#> 11                                -3.439440e-01    -3.151840e-05
#> 12                                -3.439472e-01     8.394626e-02
#> 13                                -2.504161e-01     1.053170e-02
#> 14                                -3.439469e-01     1.781593e-01
#> 15                                -3.439467e-01     1.385923e-02
#> 16                                 0.000000e+00    -9.634720e-07
#> 17                                -2.184904e-01    -2.132187e-05
#> 18                                 0.000000e+00    -1.785633e-05
#> 19                                -2.785142e-01     3.776046e-02
#> 20                                -9.886287e-07    -1.313644e-05
#> 21                                -2.504168e-01     3.418647e-03
#> 22                                -3.439486e-01     1.581755e-02
#> 23                                 0.000000e+00     9.639699e-02
#> 24                                -3.031964e-01     6.100563e-02
#> 25                                 0.000000e+00    -8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00    -2.207469e-05
#> 28                                -3.439469e-01     1.179967e-01
#> 29                                 0.000000e+00    -2.906392e-05
#> 30                                -8.650037e-07    -1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -3.262421e-01
#> 2                                4.238413e-07                 -2.217470e-01
#> 3                                1.708820e-06                 -3.727980e-01
#> 4                                0.000000e+00                 -1.451711e-01
#> 5                                4.171136e-07                 -2.291275e-01
#> 6                                0.000000e+00                 -2.167430e-06
#> 7                                0.000000e+00                 -6.586473e-06
#> 8                                0.000000e+00                 -8.743405e-07
#> 9                               -1.076422e-07                 -2.504205e-01
#> 10                               2.085568e-07                 -2.049990e-01
#> 11                               4.305689e-07                 -1.318708e-01
#> 12                               2.119206e-07                 -2.153682e-01
#> 13                              -1.009146e-07                 -7.988033e-02
#> 14                               1.695365e-06                 -2.049958e-01
#> 15                               1.614633e-07                 -2.217377e-01
#> 16                               0.000000e+00                 -3.032049e-01
#> 17                              -1.506991e-06                 -8.755650e-02
#> 18                               0.000000e+00                 -8.926425e-07
#> 19                               0.000000e+00                 -1.335258e-01
#> 20                               0.000000e+00                 -5.044662e-06
#> 21                              -2.060992e-02                 -7.426995e-02
#> 22                               1.708820e-06                 -2.359207e-01
#> 23                               0.000000e+00                 -3.248824e-01
#> 24                               8.073167e-08                 -1.519497e-01
#> 25                               0.000000e+00                 -1.501920e-06
#> 26                               0.000000e+00                 -2.008037e-05
#> 27                               0.000000e+00                 -2.783859e-06
#> 28                               8.476826e-07                 -4.136693e-01
#> 29                               0.000000e+00                 -1.138000e-05
#> 30                               0.000000e+00                 -3.414352e-06
#> 
#> $individual_inferences$mode_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              2.184841e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -3.781633e-06
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -1.202008e-01       0.13535978
#> 2                                 -2.785144e-01       0.12905046
#> 3                                 -1.419780e-01       0.17279319
#> 4                                 -1.823903e-01       0.06344861
#> 5                                 -2.912555e-01       0.12066305
#> 6                                  0.000000e+00       0.00000000
#> 7                                  0.000000e+00       0.00000000
#> 8                                  0.000000e+00       0.00000000
#> 9                                 -1.076422e-07       0.07980185
#> 10                                -2.504155e-01       0.12237908
#> 11                                -3.031899e-01       0.01061280
#> 12                                -2.677088e-01       0.15173773
#> 13                                -9.747187e-02       0.02454208
#> 14                                -2.504156e-01       0.32645102
#> 15                                -2.785133e-01       0.06857068
#> 16                                 0.000000e+00       0.06403258
#> 17                                -4.966970e-02       0.01232420
#> 18                                 0.000000e+00       0.00000000
#> 19                                -1.419758e-01       0.07470845
#> 20                                 0.000000e+00       0.00000000
#> 21                                -9.747226e-02       0.01717014
#> 22                                -3.031974e-01       0.07796207
#> 23                                 0.000000e+00       0.16507281
#> 24                                -1.823909e-01       0.10751282
#> 25                                 0.000000e+00       0.00000000
#> 26                                 0.000000e+00       0.00000000
#> 27                                 0.000000e+00       0.00000000
#> 28                                -2.912555e-01       0.21512975
#> 29                                 0.000000e+00       0.00000000
#> 30                                 0.000000e+00       0.00000000
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                   -0.19827639
#> 2                                4.238413e-07                   -0.18532772
#> 3                                1.708820e-06                   -0.28119287
#> 4                                0.000000e+00                   -0.08721721
#> 5                                4.171136e-07                   -0.18199123
#> 6                                0.000000e+00                    0.00000000
#> 7                                0.000000e+00                    0.00000000
#> 8                                0.000000e+00                    0.00000000
#> 9                               -1.076422e-07                   -0.09747409
#> 10                               2.085568e-07                   -0.15158721
#> 11                               4.305689e-07                   -0.02758877
#> 12                               2.119206e-07                   -0.21536762
#> 13                              -1.009146e-07                   -0.02548262
#> 14                               1.695365e-06                   -0.16105880
#> 15                               1.614633e-07                   -0.14442093
#> 16                               0.000000e+00                   -0.18239155
#> 17                              -1.506991e-06                   -0.06623863
#> 18                               0.000000e+00                    0.00000000
#> 19                               0.000000e+00                   -0.10219718
#> 20                               0.000000e+00                    0.00000000
#> 21                              -6.872083e-03                   -0.02892287
#> 22                               1.708820e-06                   -0.16873413
#> 23                               0.000000e+00                   -0.21848965
#> 24                               8.073167e-08                   -0.13827989
#> 25                               0.000000e+00                    0.00000000
#> 26                               0.000000e+00                    0.00000000
#> 27                               0.000000e+00                    0.00000000
#> 28                               8.476826e-07                   -0.33891614
#> 29                               0.000000e+00                    0.00000000
#> 30                               0.000000e+00                    0.00000000
#> 
#> $individual_inferences$upper_values
#>    adj_matrix_index Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1      adj_matrix_1                                 1              4.171136e-07
#> 2      adj_matrix_2                                 1              4.238413e-07
#> 3      adj_matrix_3                                 1              1.708820e-06
#> 4      adj_matrix_4                                 1              0.000000e+00
#> 5      adj_matrix_5                                 1              4.171136e-07
#> 6      adj_matrix_6                                 1              0.000000e+00
#> 7      adj_matrix_7                                 1              0.000000e+00
#> 8      adj_matrix_8                                 1              0.000000e+00
#> 9      adj_matrix_9                                 1             -1.076422e-07
#> 10    adj_matrix_10                                 1              2.085568e-07
#> 11    adj_matrix_11                                 1              4.305689e-07
#> 12    adj_matrix_12                                 1              2.119206e-07
#> 13    adj_matrix_13                                 1             -1.009146e-07
#> 14    adj_matrix_14                                 1              1.695365e-06
#> 15    adj_matrix_15                                 1              1.614633e-07
#> 16    adj_matrix_16                                 1              3.248774e-01
#> 17    adj_matrix_17                                 1             -1.506991e-06
#> 18    adj_matrix_18                                 1              0.000000e+00
#> 19    adj_matrix_19                                 1              0.000000e+00
#> 20    adj_matrix_20                                 1              0.000000e+00
#> 21    adj_matrix_21                                 1              3.767478e-07
#> 22    adj_matrix_22                                 1              1.708820e-06
#> 23    adj_matrix_23                                 1              0.000000e+00
#> 24    adj_matrix_24                                 1              8.073167e-08
#> 25    adj_matrix_25                                 1              0.000000e+00
#> 26    adj_matrix_26                                 1              0.000000e+00
#> 27    adj_matrix_27                                 1              0.000000e+00
#> 28    adj_matrix_28                                 1              8.476826e-07
#> 29    adj_matrix_29                                 1              0.000000e+00
#> 30    adj_matrix_30                                 1              0.000000e+00
#>    Salts.Added.during.Water.Treatment
#> 1                        4.171136e-07
#> 2                       -2.716813e-07
#> 3                        1.708820e-06
#> 4                        0.000000e+00
#> 5                        4.171136e-07
#> 6                        0.000000e+00
#> 7                        0.000000e+00
#> 8                        0.000000e+00
#> 9                       -1.076422e-07
#> 10                       2.085568e-07
#> 11                       4.305689e-07
#> 12                       2.119206e-07
#> 13                      -1.009146e-07
#> 14                       1.695365e-06
#> 15                       1.614633e-07
#> 16                       0.000000e+00
#> 17                      -1.506991e-06
#> 18                       0.000000e+00
#> 19                       0.000000e+00
#> 20                       0.000000e+00
#> 21                       3.767478e-07
#> 22                       1.708820e-06
#> 23                       0.000000e+00
#> 24                       8.073167e-08
#> 25                       0.000000e+00
#> 26                       0.000000e+00
#> 27                       0.000000e+00
#> 28                       8.476826e-07
#> 29                       0.000000e+00
#> 30                       0.000000e+00
#>    Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                  1.139210e-06     1.744341e-01
#> 2                                 -1.419764e-01     1.576644e-01
#> 3                                  2.126505e-06     2.186153e-01
#> 4                                  1.890719e-06     8.392516e-02
#> 5                                 -1.627199e-01     1.565026e-01
#> 6                                  4.509185e-07     1.823495e-05
#> 7                                  0.000000e+00     2.339399e-05
#> 8                                  0.000000e+00     3.734027e-06
#> 9                                 -1.076422e-07     1.120977e-01
#> 10                                -9.747171e-02     1.347899e-01
#> 11                                -1.823828e-01     3.179348e-02
#> 12                                -1.246366e-01     1.747546e-01
#> 13                                 2.606899e-06     3.500210e-02
#> 14                                -9.747073e-02     3.882986e-01
#> 15                                -1.419752e-01     1.202174e-01
#> 16                                 0.000000e+00     1.241829e-01
#> 17                                 1.394166e-05     3.687688e-02
#> 18                                 0.000000e+00     1.785633e-05
#> 19                                 1.654658e-06     9.264320e-02
#> 20                                 9.886287e-07     1.313644e-05
#> 21                                 4.176917e-06     3.087011e-02
#> 22                                -1.823913e-01     1.356940e-01
#> 23                                 0.000000e+00     1.806185e-01
#> 24                                 5.964684e-07     1.186431e-01
#> 25                                 0.000000e+00     8.614831e-06
#> 26                                 0.000000e+00     0.000000e+00
#> 27                                 0.000000e+00     2.207469e-05
#> 28                                -1.627198e-01     2.542002e-01
#> 29                                 0.000000e+00     2.906392e-05
#> 30                                 8.650037e-07     1.548227e-05
#>    Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                4.171136e-07                 -4.468532e-02
#> 2                                4.238413e-07                 -9.925181e-02
#> 3                                1.708820e-06                 -9.659356e-02
#> 4                                0.000000e+00                 -2.423273e-02
#> 5                                4.171136e-07                 -9.103424e-02
#> 6                                0.000000e+00                  2.167430e-06
#> 7                                0.000000e+00                  6.586473e-06
#> 8                                0.000000e+00                  8.743405e-07
#> 9                               -1.076422e-07                  4.872594e-06
#> 10                               2.085568e-07                 -6.831878e-02
#> 11                               4.305689e-07                  2.662699e-05
#> 12                               2.119206e-07                 -1.396386e-01
#> 13                              -1.009146e-07                  6.068898e-06
#> 14                               1.695365e-06                 -7.934998e-02
#> 15                               1.614633e-07                 -5.060377e-02
#> 16                               0.000000e+00                  1.338811e-05
#> 17                              -1.506991e-06                 -3.117925e-02
#> 18                               0.000000e+00                  8.926425e-07
#> 19                               0.000000e+00                 -4.873998e-02
#> 20                               0.000000e+00                  5.044662e-06
#> 21                               1.392007e-05                  9.173772e-06
#> 22                               1.708820e-06                 -7.092534e-02
#> 23                               0.000000e+00                 -4.966640e-02
#> 24                               8.073167e-08                 -7.956420e-02
#> 25                               0.000000e+00                  1.501920e-06
#> 26                               0.000000e+00                  2.008037e-05
#> 27                               0.000000e+00                  2.783859e-06
#> 28                               8.476826e-07                 -1.665670e-01
#> 29                               0.000000e+00                  1.138000e-05
#> 30                               0.000000e+00                  3.414352e-06
#> 
#> 
#> $aggregate_inferences
#>                                                                                      node
#> Guidance.Docs.for.Salt.Management                       Guidance.Docs.for.Salt.Management
#> Public.Education.Programs                                       Public.Education.Programs
#> Salts.Added.during.Water.Treatment                     Salts.Added.during.Water.Treatment
#> Salts.Added.by.Winter.Maintenance.Activities Salts.Added.by.Winter.Maintenance.Activities
#> Ecosystem.Health                                                         Ecosystem.Health
#> Public.Awareness.of.Reservoir.Salinization     Public.Awareness.of.Reservoir.Salinization
#> Salinization.of.the.Reservoir                               Salinization.of.the.Reservoir
#>                                                      crisp        lower
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000000
#> Public.Education.Programs                     0.0083299458  0.001666766
#> Salts.Added.during.Water.Treatment           -0.0001387161 -0.000249858
#> Salts.Added.by.Winter.Maintenance.Activities -0.1314510965 -0.212402560
#> Ecosystem.Health                              0.0764263364  0.033610635
#> Public.Awareness.of.Reservoir.Salinization   -0.0010549501 -0.002374269
#> Salinization.of.the.Reservoir                -0.1187321006 -0.187328607
#>                                                       mode         upper
#> Guidance.Docs.for.Salt.Management             1.0000000000  1.000000e+00
#> Public.Education.Programs                     0.0083319182  1.499115e-02
#> Salts.Added.during.Water.Treatment           -0.0001387161 -2.757432e-05
#> Salts.Added.by.Winter.Maintenance.Activities -0.1359080809 -4.604265e-02
#> Ecosystem.Health                              0.0803366216  1.153318e-01
#> Public.Awareness.of.Reservoir.Salinization   -0.0007911801  5.982716e-07
#> Salinization.of.the.Reservoir                -0.1241399760 -4.472772e-02
#> 
#> $mc_inferences
#>        adj_matrix_index Guidance.Docs.for.Salt.Management
#> 1       mc_adj_matrix_1                                 1
#> 2       mc_adj_matrix_2                                 1
#> 3       mc_adj_matrix_3                                 1
#> 4       mc_adj_matrix_4                                 1
#> 5       mc_adj_matrix_5                                 1
#> 6       mc_adj_matrix_6                                 1
#> 7       mc_adj_matrix_7                                 1
#> 8       mc_adj_matrix_8                                 1
#> 9       mc_adj_matrix_9                                 1
#> 10     mc_adj_matrix_10                                 1
#> 11     mc_adj_matrix_11                                 1
#> 12     mc_adj_matrix_12                                 1
#> 13     mc_adj_matrix_13                                 1
#> 14     mc_adj_matrix_14                                 1
#> 15     mc_adj_matrix_15                                 1
#> 16     mc_adj_matrix_16                                 1
#> 17     mc_adj_matrix_17                                 1
#> 18     mc_adj_matrix_18                                 1
#> 19     mc_adj_matrix_19                                 1
#> 20     mc_adj_matrix_20                                 1
#> 21     mc_adj_matrix_21                                 1
#> 22     mc_adj_matrix_22                                 1
#> 23     mc_adj_matrix_23                                 1
#> 24     mc_adj_matrix_24                                 1
#> 25     mc_adj_matrix_25                                 1
#> 26     mc_adj_matrix_26                                 1
#> 27     mc_adj_matrix_27                                 1
#> 28     mc_adj_matrix_28                                 1
#> 29     mc_adj_matrix_29                                 1
#> 30     mc_adj_matrix_30                                 1
#> 31     mc_adj_matrix_31                                 1
#> 32     mc_adj_matrix_32                                 1
#> 33     mc_adj_matrix_33                                 1
#> 34     mc_adj_matrix_34                                 1
#> 35     mc_adj_matrix_35                                 1
#> 36     mc_adj_matrix_36                                 1
#> 37     mc_adj_matrix_37                                 1
#> 38     mc_adj_matrix_38                                 1
#> 39     mc_adj_matrix_39                                 1
#> 40     mc_adj_matrix_40                                 1
#> 41     mc_adj_matrix_41                                 1
#> 42     mc_adj_matrix_42                                 1
#> 43     mc_adj_matrix_43                                 1
#> 44     mc_adj_matrix_44                                 1
#> 45     mc_adj_matrix_45                                 1
#> 46     mc_adj_matrix_46                                 1
#> 47     mc_adj_matrix_47                                 1
#> 48     mc_adj_matrix_48                                 1
#> 49     mc_adj_matrix_49                                 1
#> 50     mc_adj_matrix_50                                 1
#> 51     mc_adj_matrix_51                                 1
#> 52     mc_adj_matrix_52                                 1
#> 53     mc_adj_matrix_53                                 1
#> 54     mc_adj_matrix_54                                 1
#> 55     mc_adj_matrix_55                                 1
#> 56     mc_adj_matrix_56                                 1
#> 57     mc_adj_matrix_57                                 1
#> 58     mc_adj_matrix_58                                 1
#> 59     mc_adj_matrix_59                                 1
#> 60     mc_adj_matrix_60                                 1
#> 61     mc_adj_matrix_61                                 1
#> 62     mc_adj_matrix_62                                 1
#> 63     mc_adj_matrix_63                                 1
#> 64     mc_adj_matrix_64                                 1
#> 65     mc_adj_matrix_65                                 1
#> 66     mc_adj_matrix_66                                 1
#> 67     mc_adj_matrix_67                                 1
#> 68     mc_adj_matrix_68                                 1
#> 69     mc_adj_matrix_69                                 1
#> 70     mc_adj_matrix_70                                 1
#> 71     mc_adj_matrix_71                                 1
#> 72     mc_adj_matrix_72                                 1
#> 73     mc_adj_matrix_73                                 1
#> 74     mc_adj_matrix_74                                 1
#> 75     mc_adj_matrix_75                                 1
#> 76     mc_adj_matrix_76                                 1
#> 77     mc_adj_matrix_77                                 1
#> 78     mc_adj_matrix_78                                 1
#> 79     mc_adj_matrix_79                                 1
#> 80     mc_adj_matrix_80                                 1
#> 81     mc_adj_matrix_81                                 1
#> 82     mc_adj_matrix_82                                 1
#> 83     mc_adj_matrix_83                                 1
#> 84     mc_adj_matrix_84                                 1
#> 85     mc_adj_matrix_85                                 1
#> 86     mc_adj_matrix_86                                 1
#> 87     mc_adj_matrix_87                                 1
#> 88     mc_adj_matrix_88                                 1
#> 89     mc_adj_matrix_89                                 1
#> 90     mc_adj_matrix_90                                 1
#> 91     mc_adj_matrix_91                                 1
#> 92     mc_adj_matrix_92                                 1
#> 93     mc_adj_matrix_93                                 1
#> 94     mc_adj_matrix_94                                 1
#> 95     mc_adj_matrix_95                                 1
#> 96     mc_adj_matrix_96                                 1
#> 97     mc_adj_matrix_97                                 1
#> 98     mc_adj_matrix_98                                 1
#> 99     mc_adj_matrix_99                                 1
#> 100   mc_adj_matrix_100                                 1
#> 101   mc_adj_matrix_101                                 1
#> 102   mc_adj_matrix_102                                 1
#> 103   mc_adj_matrix_103                                 1
#> 104   mc_adj_matrix_104                                 1
#> 105   mc_adj_matrix_105                                 1
#> 106   mc_adj_matrix_106                                 1
#> 107   mc_adj_matrix_107                                 1
#> 108   mc_adj_matrix_108                                 1
#> 109   mc_adj_matrix_109                                 1
#> 110   mc_adj_matrix_110                                 1
#> 111   mc_adj_matrix_111                                 1
#> 112   mc_adj_matrix_112                                 1
#> 113   mc_adj_matrix_113                                 1
#> 114   mc_adj_matrix_114                                 1
#> 115   mc_adj_matrix_115                                 1
#> 116   mc_adj_matrix_116                                 1
#> 117   mc_adj_matrix_117                                 1
#> 118   mc_adj_matrix_118                                 1
#> 119   mc_adj_matrix_119                                 1
#> 120   mc_adj_matrix_120                                 1
#> 121   mc_adj_matrix_121                                 1
#> 122   mc_adj_matrix_122                                 1
#> 123   mc_adj_matrix_123                                 1
#> 124   mc_adj_matrix_124                                 1
#> 125   mc_adj_matrix_125                                 1
#> 126   mc_adj_matrix_126                                 1
#> 127   mc_adj_matrix_127                                 1
#> 128   mc_adj_matrix_128                                 1
#> 129   mc_adj_matrix_129                                 1
#> 130   mc_adj_matrix_130                                 1
#> 131   mc_adj_matrix_131                                 1
#> 132   mc_adj_matrix_132                                 1
#> 133   mc_adj_matrix_133                                 1
#> 134   mc_adj_matrix_134                                 1
#> 135   mc_adj_matrix_135                                 1
#> 136   mc_adj_matrix_136                                 1
#> 137   mc_adj_matrix_137                                 1
#> 138   mc_adj_matrix_138                                 1
#> 139   mc_adj_matrix_139                                 1
#> 140   mc_adj_matrix_140                                 1
#> 141   mc_adj_matrix_141                                 1
#> 142   mc_adj_matrix_142                                 1
#> 143   mc_adj_matrix_143                                 1
#> 144   mc_adj_matrix_144                                 1
#> 145   mc_adj_matrix_145                                 1
#> 146   mc_adj_matrix_146                                 1
#> 147   mc_adj_matrix_147                                 1
#> 148   mc_adj_matrix_148                                 1
#> 149   mc_adj_matrix_149                                 1
#> 150   mc_adj_matrix_150                                 1
#> 151   mc_adj_matrix_151                                 1
#> 152   mc_adj_matrix_152                                 1
#> 153   mc_adj_matrix_153                                 1
#> 154   mc_adj_matrix_154                                 1
#> 155   mc_adj_matrix_155                                 1
#> 156   mc_adj_matrix_156                                 1
#> 157   mc_adj_matrix_157                                 1
#> 158   mc_adj_matrix_158                                 1
#> 159   mc_adj_matrix_159                                 1
#> 160   mc_adj_matrix_160                                 1
#> 161   mc_adj_matrix_161                                 1
#> 162   mc_adj_matrix_162                                 1
#> 163   mc_adj_matrix_163                                 1
#> 164   mc_adj_matrix_164                                 1
#> 165   mc_adj_matrix_165                                 1
#> 166   mc_adj_matrix_166                                 1
#> 167   mc_adj_matrix_167                                 1
#> 168   mc_adj_matrix_168                                 1
#> 169   mc_adj_matrix_169                                 1
#> 170   mc_adj_matrix_170                                 1
#> 171   mc_adj_matrix_171                                 1
#> 172   mc_adj_matrix_172                                 1
#> 173   mc_adj_matrix_173                                 1
#> 174   mc_adj_matrix_174                                 1
#> 175   mc_adj_matrix_175                                 1
#> 176   mc_adj_matrix_176                                 1
#> 177   mc_adj_matrix_177                                 1
#> 178   mc_adj_matrix_178                                 1
#> 179   mc_adj_matrix_179                                 1
#> 180   mc_adj_matrix_180                                 1
#> 181   mc_adj_matrix_181                                 1
#> 182   mc_adj_matrix_182                                 1
#> 183   mc_adj_matrix_183                                 1
#> 184   mc_adj_matrix_184                                 1
#> 185   mc_adj_matrix_185                                 1
#> 186   mc_adj_matrix_186                                 1
#> 187   mc_adj_matrix_187                                 1
#> 188   mc_adj_matrix_188                                 1
#> 189   mc_adj_matrix_189                                 1
#> 190   mc_adj_matrix_190                                 1
#> 191   mc_adj_matrix_191                                 1
#> 192   mc_adj_matrix_192                                 1
#> 193   mc_adj_matrix_193                                 1
#> 194   mc_adj_matrix_194                                 1
#> 195   mc_adj_matrix_195                                 1
#> 196   mc_adj_matrix_196                                 1
#> 197   mc_adj_matrix_197                                 1
#> 198   mc_adj_matrix_198                                 1
#> 199   mc_adj_matrix_199                                 1
#> 200   mc_adj_matrix_200                                 1
#> 201   mc_adj_matrix_201                                 1
#> 202   mc_adj_matrix_202                                 1
#> 203   mc_adj_matrix_203                                 1
#> 204   mc_adj_matrix_204                                 1
#> 205   mc_adj_matrix_205                                 1
#> 206   mc_adj_matrix_206                                 1
#> 207   mc_adj_matrix_207                                 1
#> 208   mc_adj_matrix_208                                 1
#> 209   mc_adj_matrix_209                                 1
#> 210   mc_adj_matrix_210                                 1
#> 211   mc_adj_matrix_211                                 1
#> 212   mc_adj_matrix_212                                 1
#> 213   mc_adj_matrix_213                                 1
#> 214   mc_adj_matrix_214                                 1
#> 215   mc_adj_matrix_215                                 1
#> 216   mc_adj_matrix_216                                 1
#> 217   mc_adj_matrix_217                                 1
#> 218   mc_adj_matrix_218                                 1
#> 219   mc_adj_matrix_219                                 1
#> 220   mc_adj_matrix_220                                 1
#> 221   mc_adj_matrix_221                                 1
#> 222   mc_adj_matrix_222                                 1
#> 223   mc_adj_matrix_223                                 1
#> 224   mc_adj_matrix_224                                 1
#> 225   mc_adj_matrix_225                                 1
#> 226   mc_adj_matrix_226                                 1
#> 227   mc_adj_matrix_227                                 1
#> 228   mc_adj_matrix_228                                 1
#> 229   mc_adj_matrix_229                                 1
#> 230   mc_adj_matrix_230                                 1
#> 231   mc_adj_matrix_231                                 1
#> 232   mc_adj_matrix_232                                 1
#> 233   mc_adj_matrix_233                                 1
#> 234   mc_adj_matrix_234                                 1
#> 235   mc_adj_matrix_235                                 1
#> 236   mc_adj_matrix_236                                 1
#> 237   mc_adj_matrix_237                                 1
#> 238   mc_adj_matrix_238                                 1
#> 239   mc_adj_matrix_239                                 1
#> 240   mc_adj_matrix_240                                 1
#> 241   mc_adj_matrix_241                                 1
#> 242   mc_adj_matrix_242                                 1
#> 243   mc_adj_matrix_243                                 1
#> 244   mc_adj_matrix_244                                 1
#> 245   mc_adj_matrix_245                                 1
#> 246   mc_adj_matrix_246                                 1
#> 247   mc_adj_matrix_247                                 1
#> 248   mc_adj_matrix_248                                 1
#> 249   mc_adj_matrix_249                                 1
#> 250   mc_adj_matrix_250                                 1
#> 251   mc_adj_matrix_251                                 1
#> 252   mc_adj_matrix_252                                 1
#> 253   mc_adj_matrix_253                                 1
#> 254   mc_adj_matrix_254                                 1
#> 255   mc_adj_matrix_255                                 1
#> 256   mc_adj_matrix_256                                 1
#> 257   mc_adj_matrix_257                                 1
#> 258   mc_adj_matrix_258                                 1
#> 259   mc_adj_matrix_259                                 1
#> 260   mc_adj_matrix_260                                 1
#> 261   mc_adj_matrix_261                                 1
#> 262   mc_adj_matrix_262                                 1
#> 263   mc_adj_matrix_263                                 1
#> 264   mc_adj_matrix_264                                 1
#> 265   mc_adj_matrix_265                                 1
#> 266   mc_adj_matrix_266                                 1
#> 267   mc_adj_matrix_267                                 1
#> 268   mc_adj_matrix_268                                 1
#> 269   mc_adj_matrix_269                                 1
#> 270   mc_adj_matrix_270                                 1
#> 271   mc_adj_matrix_271                                 1
#> 272   mc_adj_matrix_272                                 1
#> 273   mc_adj_matrix_273                                 1
#> 274   mc_adj_matrix_274                                 1
#> 275   mc_adj_matrix_275                                 1
#> 276   mc_adj_matrix_276                                 1
#> 277   mc_adj_matrix_277                                 1
#> 278   mc_adj_matrix_278                                 1
#> 279   mc_adj_matrix_279                                 1
#> 280   mc_adj_matrix_280                                 1
#> 281   mc_adj_matrix_281                                 1
#> 282   mc_adj_matrix_282                                 1
#> 283   mc_adj_matrix_283                                 1
#> 284   mc_adj_matrix_284                                 1
#> 285   mc_adj_matrix_285                                 1
#> 286   mc_adj_matrix_286                                 1
#> 287   mc_adj_matrix_287                                 1
#> 288   mc_adj_matrix_288                                 1
#> 289   mc_adj_matrix_289                                 1
#> 290   mc_adj_matrix_290                                 1
#> 291   mc_adj_matrix_291                                 1
#> 292   mc_adj_matrix_292                                 1
#> 293   mc_adj_matrix_293                                 1
#> 294   mc_adj_matrix_294                                 1
#> 295   mc_adj_matrix_295                                 1
#> 296   mc_adj_matrix_296                                 1
#> 297   mc_adj_matrix_297                                 1
#> 298   mc_adj_matrix_298                                 1
#> 299   mc_adj_matrix_299                                 1
#> 300   mc_adj_matrix_300                                 1
#> 301   mc_adj_matrix_301                                 1
#> 302   mc_adj_matrix_302                                 1
#> 303   mc_adj_matrix_303                                 1
#> 304   mc_adj_matrix_304                                 1
#> 305   mc_adj_matrix_305                                 1
#> 306   mc_adj_matrix_306                                 1
#> 307   mc_adj_matrix_307                                 1
#> 308   mc_adj_matrix_308                                 1
#> 309   mc_adj_matrix_309                                 1
#> 310   mc_adj_matrix_310                                 1
#> 311   mc_adj_matrix_311                                 1
#> 312   mc_adj_matrix_312                                 1
#> 313   mc_adj_matrix_313                                 1
#> 314   mc_adj_matrix_314                                 1
#> 315   mc_adj_matrix_315                                 1
#> 316   mc_adj_matrix_316                                 1
#> 317   mc_adj_matrix_317                                 1
#> 318   mc_adj_matrix_318                                 1
#> 319   mc_adj_matrix_319                                 1
#> 320   mc_adj_matrix_320                                 1
#> 321   mc_adj_matrix_321                                 1
#> 322   mc_adj_matrix_322                                 1
#> 323   mc_adj_matrix_323                                 1
#> 324   mc_adj_matrix_324                                 1
#> 325   mc_adj_matrix_325                                 1
#> 326   mc_adj_matrix_326                                 1
#> 327   mc_adj_matrix_327                                 1
#> 328   mc_adj_matrix_328                                 1
#> 329   mc_adj_matrix_329                                 1
#> 330   mc_adj_matrix_330                                 1
#> 331   mc_adj_matrix_331                                 1
#> 332   mc_adj_matrix_332                                 1
#> 333   mc_adj_matrix_333                                 1
#> 334   mc_adj_matrix_334                                 1
#> 335   mc_adj_matrix_335                                 1
#> 336   mc_adj_matrix_336                                 1
#> 337   mc_adj_matrix_337                                 1
#> 338   mc_adj_matrix_338                                 1
#> 339   mc_adj_matrix_339                                 1
#> 340   mc_adj_matrix_340                                 1
#> 341   mc_adj_matrix_341                                 1
#> 342   mc_adj_matrix_342                                 1
#> 343   mc_adj_matrix_343                                 1
#> 344   mc_adj_matrix_344                                 1
#> 345   mc_adj_matrix_345                                 1
#> 346   mc_adj_matrix_346                                 1
#> 347   mc_adj_matrix_347                                 1
#> 348   mc_adj_matrix_348                                 1
#> 349   mc_adj_matrix_349                                 1
#> 350   mc_adj_matrix_350                                 1
#> 351   mc_adj_matrix_351                                 1
#> 352   mc_adj_matrix_352                                 1
#> 353   mc_adj_matrix_353                                 1
#> 354   mc_adj_matrix_354                                 1
#> 355   mc_adj_matrix_355                                 1
#> 356   mc_adj_matrix_356                                 1
#> 357   mc_adj_matrix_357                                 1
#> 358   mc_adj_matrix_358                                 1
#> 359   mc_adj_matrix_359                                 1
#> 360   mc_adj_matrix_360                                 1
#> 361   mc_adj_matrix_361                                 1
#> 362   mc_adj_matrix_362                                 1
#> 363   mc_adj_matrix_363                                 1
#> 364   mc_adj_matrix_364                                 1
#> 365   mc_adj_matrix_365                                 1
#> 366   mc_adj_matrix_366                                 1
#> 367   mc_adj_matrix_367                                 1
#> 368   mc_adj_matrix_368                                 1
#> 369   mc_adj_matrix_369                                 1
#> 370   mc_adj_matrix_370                                 1
#> 371   mc_adj_matrix_371                                 1
#> 372   mc_adj_matrix_372                                 1
#> 373   mc_adj_matrix_373                                 1
#> 374   mc_adj_matrix_374                                 1
#> 375   mc_adj_matrix_375                                 1
#> 376   mc_adj_matrix_376                                 1
#> 377   mc_adj_matrix_377                                 1
#> 378   mc_adj_matrix_378                                 1
#> 379   mc_adj_matrix_379                                 1
#> 380   mc_adj_matrix_380                                 1
#> 381   mc_adj_matrix_381                                 1
#> 382   mc_adj_matrix_382                                 1
#> 383   mc_adj_matrix_383                                 1
#> 384   mc_adj_matrix_384                                 1
#> 385   mc_adj_matrix_385                                 1
#> 386   mc_adj_matrix_386                                 1
#> 387   mc_adj_matrix_387                                 1
#> 388   mc_adj_matrix_388                                 1
#> 389   mc_adj_matrix_389                                 1
#> 390   mc_adj_matrix_390                                 1
#> 391   mc_adj_matrix_391                                 1
#> 392   mc_adj_matrix_392                                 1
#> 393   mc_adj_matrix_393                                 1
#> 394   mc_adj_matrix_394                                 1
#> 395   mc_adj_matrix_395                                 1
#> 396   mc_adj_matrix_396                                 1
#> 397   mc_adj_matrix_397                                 1
#> 398   mc_adj_matrix_398                                 1
#> 399   mc_adj_matrix_399                                 1
#> 400   mc_adj_matrix_400                                 1
#> 401   mc_adj_matrix_401                                 1
#> 402   mc_adj_matrix_402                                 1
#> 403   mc_adj_matrix_403                                 1
#> 404   mc_adj_matrix_404                                 1
#> 405   mc_adj_matrix_405                                 1
#> 406   mc_adj_matrix_406                                 1
#> 407   mc_adj_matrix_407                                 1
#> 408   mc_adj_matrix_408                                 1
#> 409   mc_adj_matrix_409                                 1
#> 410   mc_adj_matrix_410                                 1
#> 411   mc_adj_matrix_411                                 1
#> 412   mc_adj_matrix_412                                 1
#> 413   mc_adj_matrix_413                                 1
#> 414   mc_adj_matrix_414                                 1
#> 415   mc_adj_matrix_415                                 1
#> 416   mc_adj_matrix_416                                 1
#> 417   mc_adj_matrix_417                                 1
#> 418   mc_adj_matrix_418                                 1
#> 419   mc_adj_matrix_419                                 1
#> 420   mc_adj_matrix_420                                 1
#> 421   mc_adj_matrix_421                                 1
#> 422   mc_adj_matrix_422                                 1
#> 423   mc_adj_matrix_423                                 1
#> 424   mc_adj_matrix_424                                 1
#> 425   mc_adj_matrix_425                                 1
#> 426   mc_adj_matrix_426                                 1
#> 427   mc_adj_matrix_427                                 1
#> 428   mc_adj_matrix_428                                 1
#> 429   mc_adj_matrix_429                                 1
#> 430   mc_adj_matrix_430                                 1
#> 431   mc_adj_matrix_431                                 1
#> 432   mc_adj_matrix_432                                 1
#> 433   mc_adj_matrix_433                                 1
#> 434   mc_adj_matrix_434                                 1
#> 435   mc_adj_matrix_435                                 1
#> 436   mc_adj_matrix_436                                 1
#> 437   mc_adj_matrix_437                                 1
#> 438   mc_adj_matrix_438                                 1
#> 439   mc_adj_matrix_439                                 1
#> 440   mc_adj_matrix_440                                 1
#> 441   mc_adj_matrix_441                                 1
#> 442   mc_adj_matrix_442                                 1
#> 443   mc_adj_matrix_443                                 1
#> 444   mc_adj_matrix_444                                 1
#> 445   mc_adj_matrix_445                                 1
#> 446   mc_adj_matrix_446                                 1
#> 447   mc_adj_matrix_447                                 1
#> 448   mc_adj_matrix_448                                 1
#> 449   mc_adj_matrix_449                                 1
#> 450   mc_adj_matrix_450                                 1
#> 451   mc_adj_matrix_451                                 1
#> 452   mc_adj_matrix_452                                 1
#> 453   mc_adj_matrix_453                                 1
#> 454   mc_adj_matrix_454                                 1
#> 455   mc_adj_matrix_455                                 1
#> 456   mc_adj_matrix_456                                 1
#> 457   mc_adj_matrix_457                                 1
#> 458   mc_adj_matrix_458                                 1
#> 459   mc_adj_matrix_459                                 1
#> 460   mc_adj_matrix_460                                 1
#> 461   mc_adj_matrix_461                                 1
#> 462   mc_adj_matrix_462                                 1
#> 463   mc_adj_matrix_463                                 1
#> 464   mc_adj_matrix_464                                 1
#> 465   mc_adj_matrix_465                                 1
#> 466   mc_adj_matrix_466                                 1
#> 467   mc_adj_matrix_467                                 1
#> 468   mc_adj_matrix_468                                 1
#> 469   mc_adj_matrix_469                                 1
#> 470   mc_adj_matrix_470                                 1
#> 471   mc_adj_matrix_471                                 1
#> 472   mc_adj_matrix_472                                 1
#> 473   mc_adj_matrix_473                                 1
#> 474   mc_adj_matrix_474                                 1
#> 475   mc_adj_matrix_475                                 1
#> 476   mc_adj_matrix_476                                 1
#> 477   mc_adj_matrix_477                                 1
#> 478   mc_adj_matrix_478                                 1
#> 479   mc_adj_matrix_479                                 1
#> 480   mc_adj_matrix_480                                 1
#> 481   mc_adj_matrix_481                                 1
#> 482   mc_adj_matrix_482                                 1
#> 483   mc_adj_matrix_483                                 1
#> 484   mc_adj_matrix_484                                 1
#> 485   mc_adj_matrix_485                                 1
#> 486   mc_adj_matrix_486                                 1
#> 487   mc_adj_matrix_487                                 1
#> 488   mc_adj_matrix_488                                 1
#> 489   mc_adj_matrix_489                                 1
#> 490   mc_adj_matrix_490                                 1
#> 491   mc_adj_matrix_491                                 1
#> 492   mc_adj_matrix_492                                 1
#> 493   mc_adj_matrix_493                                 1
#> 494   mc_adj_matrix_494                                 1
#> 495   mc_adj_matrix_495                                 1
#> 496   mc_adj_matrix_496                                 1
#> 497   mc_adj_matrix_497                                 1
#> 498   mc_adj_matrix_498                                 1
#> 499   mc_adj_matrix_499                                 1
#> 500   mc_adj_matrix_500                                 1
#> 501   mc_adj_matrix_501                                 1
#> 502   mc_adj_matrix_502                                 1
#> 503   mc_adj_matrix_503                                 1
#> 504   mc_adj_matrix_504                                 1
#> 505   mc_adj_matrix_505                                 1
#> 506   mc_adj_matrix_506                                 1
#> 507   mc_adj_matrix_507                                 1
#> 508   mc_adj_matrix_508                                 1
#> 509   mc_adj_matrix_509                                 1
#> 510   mc_adj_matrix_510                                 1
#> 511   mc_adj_matrix_511                                 1
#> 512   mc_adj_matrix_512                                 1
#> 513   mc_adj_matrix_513                                 1
#> 514   mc_adj_matrix_514                                 1
#> 515   mc_adj_matrix_515                                 1
#> 516   mc_adj_matrix_516                                 1
#> 517   mc_adj_matrix_517                                 1
#> 518   mc_adj_matrix_518                                 1
#> 519   mc_adj_matrix_519                                 1
#> 520   mc_adj_matrix_520                                 1
#> 521   mc_adj_matrix_521                                 1
#> 522   mc_adj_matrix_522                                 1
#> 523   mc_adj_matrix_523                                 1
#> 524   mc_adj_matrix_524                                 1
#> 525   mc_adj_matrix_525                                 1
#> 526   mc_adj_matrix_526                                 1
#> 527   mc_adj_matrix_527                                 1
#> 528   mc_adj_matrix_528                                 1
#> 529   mc_adj_matrix_529                                 1
#> 530   mc_adj_matrix_530                                 1
#> 531   mc_adj_matrix_531                                 1
#> 532   mc_adj_matrix_532                                 1
#> 533   mc_adj_matrix_533                                 1
#> 534   mc_adj_matrix_534                                 1
#> 535   mc_adj_matrix_535                                 1
#> 536   mc_adj_matrix_536                                 1
#> 537   mc_adj_matrix_537                                 1
#> 538   mc_adj_matrix_538                                 1
#> 539   mc_adj_matrix_539                                 1
#> 540   mc_adj_matrix_540                                 1
#> 541   mc_adj_matrix_541                                 1
#> 542   mc_adj_matrix_542                                 1
#> 543   mc_adj_matrix_543                                 1
#> 544   mc_adj_matrix_544                                 1
#> 545   mc_adj_matrix_545                                 1
#> 546   mc_adj_matrix_546                                 1
#> 547   mc_adj_matrix_547                                 1
#> 548   mc_adj_matrix_548                                 1
#> 549   mc_adj_matrix_549                                 1
#> 550   mc_adj_matrix_550                                 1
#> 551   mc_adj_matrix_551                                 1
#> 552   mc_adj_matrix_552                                 1
#> 553   mc_adj_matrix_553                                 1
#> 554   mc_adj_matrix_554                                 1
#> 555   mc_adj_matrix_555                                 1
#> 556   mc_adj_matrix_556                                 1
#> 557   mc_adj_matrix_557                                 1
#> 558   mc_adj_matrix_558                                 1
#> 559   mc_adj_matrix_559                                 1
#> 560   mc_adj_matrix_560                                 1
#> 561   mc_adj_matrix_561                                 1
#> 562   mc_adj_matrix_562                                 1
#> 563   mc_adj_matrix_563                                 1
#> 564   mc_adj_matrix_564                                 1
#> 565   mc_adj_matrix_565                                 1
#> 566   mc_adj_matrix_566                                 1
#> 567   mc_adj_matrix_567                                 1
#> 568   mc_adj_matrix_568                                 1
#> 569   mc_adj_matrix_569                                 1
#> 570   mc_adj_matrix_570                                 1
#> 571   mc_adj_matrix_571                                 1
#> 572   mc_adj_matrix_572                                 1
#> 573   mc_adj_matrix_573                                 1
#> 574   mc_adj_matrix_574                                 1
#> 575   mc_adj_matrix_575                                 1
#> 576   mc_adj_matrix_576                                 1
#> 577   mc_adj_matrix_577                                 1
#> 578   mc_adj_matrix_578                                 1
#> 579   mc_adj_matrix_579                                 1
#> 580   mc_adj_matrix_580                                 1
#> 581   mc_adj_matrix_581                                 1
#> 582   mc_adj_matrix_582                                 1
#> 583   mc_adj_matrix_583                                 1
#> 584   mc_adj_matrix_584                                 1
#> 585   mc_adj_matrix_585                                 1
#> 586   mc_adj_matrix_586                                 1
#> 587   mc_adj_matrix_587                                 1
#> 588   mc_adj_matrix_588                                 1
#> 589   mc_adj_matrix_589                                 1
#> 590   mc_adj_matrix_590                                 1
#> 591   mc_adj_matrix_591                                 1
#> 592   mc_adj_matrix_592                                 1
#> 593   mc_adj_matrix_593                                 1
#> 594   mc_adj_matrix_594                                 1
#> 595   mc_adj_matrix_595                                 1
#> 596   mc_adj_matrix_596                                 1
#> 597   mc_adj_matrix_597                                 1
#> 598   mc_adj_matrix_598                                 1
#> 599   mc_adj_matrix_599                                 1
#> 600   mc_adj_matrix_600                                 1
#> 601   mc_adj_matrix_601                                 1
#> 602   mc_adj_matrix_602                                 1
#> 603   mc_adj_matrix_603                                 1
#> 604   mc_adj_matrix_604                                 1
#> 605   mc_adj_matrix_605                                 1
#> 606   mc_adj_matrix_606                                 1
#> 607   mc_adj_matrix_607                                 1
#> 608   mc_adj_matrix_608                                 1
#> 609   mc_adj_matrix_609                                 1
#> 610   mc_adj_matrix_610                                 1
#> 611   mc_adj_matrix_611                                 1
#> 612   mc_adj_matrix_612                                 1
#> 613   mc_adj_matrix_613                                 1
#> 614   mc_adj_matrix_614                                 1
#> 615   mc_adj_matrix_615                                 1
#> 616   mc_adj_matrix_616                                 1
#> 617   mc_adj_matrix_617                                 1
#> 618   mc_adj_matrix_618                                 1
#> 619   mc_adj_matrix_619                                 1
#> 620   mc_adj_matrix_620                                 1
#> 621   mc_adj_matrix_621                                 1
#> 622   mc_adj_matrix_622                                 1
#> 623   mc_adj_matrix_623                                 1
#> 624   mc_adj_matrix_624                                 1
#> 625   mc_adj_matrix_625                                 1
#> 626   mc_adj_matrix_626                                 1
#> 627   mc_adj_matrix_627                                 1
#> 628   mc_adj_matrix_628                                 1
#> 629   mc_adj_matrix_629                                 1
#> 630   mc_adj_matrix_630                                 1
#> 631   mc_adj_matrix_631                                 1
#> 632   mc_adj_matrix_632                                 1
#> 633   mc_adj_matrix_633                                 1
#> 634   mc_adj_matrix_634                                 1
#> 635   mc_adj_matrix_635                                 1
#> 636   mc_adj_matrix_636                                 1
#> 637   mc_adj_matrix_637                                 1
#> 638   mc_adj_matrix_638                                 1
#> 639   mc_adj_matrix_639                                 1
#> 640   mc_adj_matrix_640                                 1
#> 641   mc_adj_matrix_641                                 1
#> 642   mc_adj_matrix_642                                 1
#> 643   mc_adj_matrix_643                                 1
#> 644   mc_adj_matrix_644                                 1
#> 645   mc_adj_matrix_645                                 1
#> 646   mc_adj_matrix_646                                 1
#> 647   mc_adj_matrix_647                                 1
#> 648   mc_adj_matrix_648                                 1
#> 649   mc_adj_matrix_649                                 1
#> 650   mc_adj_matrix_650                                 1
#> 651   mc_adj_matrix_651                                 1
#> 652   mc_adj_matrix_652                                 1
#> 653   mc_adj_matrix_653                                 1
#> 654   mc_adj_matrix_654                                 1
#> 655   mc_adj_matrix_655                                 1
#> 656   mc_adj_matrix_656                                 1
#> 657   mc_adj_matrix_657                                 1
#> 658   mc_adj_matrix_658                                 1
#> 659   mc_adj_matrix_659                                 1
#> 660   mc_adj_matrix_660                                 1
#> 661   mc_adj_matrix_661                                 1
#> 662   mc_adj_matrix_662                                 1
#> 663   mc_adj_matrix_663                                 1
#> 664   mc_adj_matrix_664                                 1
#> 665   mc_adj_matrix_665                                 1
#> 666   mc_adj_matrix_666                                 1
#> 667   mc_adj_matrix_667                                 1
#> 668   mc_adj_matrix_668                                 1
#> 669   mc_adj_matrix_669                                 1
#> 670   mc_adj_matrix_670                                 1
#> 671   mc_adj_matrix_671                                 1
#> 672   mc_adj_matrix_672                                 1
#> 673   mc_adj_matrix_673                                 1
#> 674   mc_adj_matrix_674                                 1
#> 675   mc_adj_matrix_675                                 1
#> 676   mc_adj_matrix_676                                 1
#> 677   mc_adj_matrix_677                                 1
#> 678   mc_adj_matrix_678                                 1
#> 679   mc_adj_matrix_679                                 1
#> 680   mc_adj_matrix_680                                 1
#> 681   mc_adj_matrix_681                                 1
#> 682   mc_adj_matrix_682                                 1
#> 683   mc_adj_matrix_683                                 1
#> 684   mc_adj_matrix_684                                 1
#> 685   mc_adj_matrix_685                                 1
#> 686   mc_adj_matrix_686                                 1
#> 687   mc_adj_matrix_687                                 1
#> 688   mc_adj_matrix_688                                 1
#> 689   mc_adj_matrix_689                                 1
#> 690   mc_adj_matrix_690                                 1
#> 691   mc_adj_matrix_691                                 1
#> 692   mc_adj_matrix_692                                 1
#> 693   mc_adj_matrix_693                                 1
#> 694   mc_adj_matrix_694                                 1
#> 695   mc_adj_matrix_695                                 1
#> 696   mc_adj_matrix_696                                 1
#> 697   mc_adj_matrix_697                                 1
#> 698   mc_adj_matrix_698                                 1
#> 699   mc_adj_matrix_699                                 1
#> 700   mc_adj_matrix_700                                 1
#> 701   mc_adj_matrix_701                                 1
#> 702   mc_adj_matrix_702                                 1
#> 703   mc_adj_matrix_703                                 1
#> 704   mc_adj_matrix_704                                 1
#> 705   mc_adj_matrix_705                                 1
#> 706   mc_adj_matrix_706                                 1
#> 707   mc_adj_matrix_707                                 1
#> 708   mc_adj_matrix_708                                 1
#> 709   mc_adj_matrix_709                                 1
#> 710   mc_adj_matrix_710                                 1
#> 711   mc_adj_matrix_711                                 1
#> 712   mc_adj_matrix_712                                 1
#> 713   mc_adj_matrix_713                                 1
#> 714   mc_adj_matrix_714                                 1
#> 715   mc_adj_matrix_715                                 1
#> 716   mc_adj_matrix_716                                 1
#> 717   mc_adj_matrix_717                                 1
#> 718   mc_adj_matrix_718                                 1
#> 719   mc_adj_matrix_719                                 1
#> 720   mc_adj_matrix_720                                 1
#> 721   mc_adj_matrix_721                                 1
#> 722   mc_adj_matrix_722                                 1
#> 723   mc_adj_matrix_723                                 1
#> 724   mc_adj_matrix_724                                 1
#> 725   mc_adj_matrix_725                                 1
#> 726   mc_adj_matrix_726                                 1
#> 727   mc_adj_matrix_727                                 1
#> 728   mc_adj_matrix_728                                 1
#> 729   mc_adj_matrix_729                                 1
#> 730   mc_adj_matrix_730                                 1
#> 731   mc_adj_matrix_731                                 1
#> 732   mc_adj_matrix_732                                 1
#> 733   mc_adj_matrix_733                                 1
#> 734   mc_adj_matrix_734                                 1
#> 735   mc_adj_matrix_735                                 1
#> 736   mc_adj_matrix_736                                 1
#> 737   mc_adj_matrix_737                                 1
#> 738   mc_adj_matrix_738                                 1
#> 739   mc_adj_matrix_739                                 1
#> 740   mc_adj_matrix_740                                 1
#> 741   mc_adj_matrix_741                                 1
#> 742   mc_adj_matrix_742                                 1
#> 743   mc_adj_matrix_743                                 1
#> 744   mc_adj_matrix_744                                 1
#> 745   mc_adj_matrix_745                                 1
#> 746   mc_adj_matrix_746                                 1
#> 747   mc_adj_matrix_747                                 1
#> 748   mc_adj_matrix_748                                 1
#> 749   mc_adj_matrix_749                                 1
#> 750   mc_adj_matrix_750                                 1
#> 751   mc_adj_matrix_751                                 1
#> 752   mc_adj_matrix_752                                 1
#> 753   mc_adj_matrix_753                                 1
#> 754   mc_adj_matrix_754                                 1
#> 755   mc_adj_matrix_755                                 1
#> 756   mc_adj_matrix_756                                 1
#> 757   mc_adj_matrix_757                                 1
#> 758   mc_adj_matrix_758                                 1
#> 759   mc_adj_matrix_759                                 1
#> 760   mc_adj_matrix_760                                 1
#> 761   mc_adj_matrix_761                                 1
#> 762   mc_adj_matrix_762                                 1
#> 763   mc_adj_matrix_763                                 1
#> 764   mc_adj_matrix_764                                 1
#> 765   mc_adj_matrix_765                                 1
#> 766   mc_adj_matrix_766                                 1
#> 767   mc_adj_matrix_767                                 1
#> 768   mc_adj_matrix_768                                 1
#> 769   mc_adj_matrix_769                                 1
#> 770   mc_adj_matrix_770                                 1
#> 771   mc_adj_matrix_771                                 1
#> 772   mc_adj_matrix_772                                 1
#> 773   mc_adj_matrix_773                                 1
#> 774   mc_adj_matrix_774                                 1
#> 775   mc_adj_matrix_775                                 1
#> 776   mc_adj_matrix_776                                 1
#> 777   mc_adj_matrix_777                                 1
#> 778   mc_adj_matrix_778                                 1
#> 779   mc_adj_matrix_779                                 1
#> 780   mc_adj_matrix_780                                 1
#> 781   mc_adj_matrix_781                                 1
#> 782   mc_adj_matrix_782                                 1
#> 783   mc_adj_matrix_783                                 1
#> 784   mc_adj_matrix_784                                 1
#> 785   mc_adj_matrix_785                                 1
#> 786   mc_adj_matrix_786                                 1
#> 787   mc_adj_matrix_787                                 1
#> 788   mc_adj_matrix_788                                 1
#> 789   mc_adj_matrix_789                                 1
#> 790   mc_adj_matrix_790                                 1
#> 791   mc_adj_matrix_791                                 1
#> 792   mc_adj_matrix_792                                 1
#> 793   mc_adj_matrix_793                                 1
#> 794   mc_adj_matrix_794                                 1
#> 795   mc_adj_matrix_795                                 1
#> 796   mc_adj_matrix_796                                 1
#> 797   mc_adj_matrix_797                                 1
#> 798   mc_adj_matrix_798                                 1
#> 799   mc_adj_matrix_799                                 1
#> 800   mc_adj_matrix_800                                 1
#> 801   mc_adj_matrix_801                                 1
#> 802   mc_adj_matrix_802                                 1
#> 803   mc_adj_matrix_803                                 1
#> 804   mc_adj_matrix_804                                 1
#> 805   mc_adj_matrix_805                                 1
#> 806   mc_adj_matrix_806                                 1
#> 807   mc_adj_matrix_807                                 1
#> 808   mc_adj_matrix_808                                 1
#> 809   mc_adj_matrix_809                                 1
#> 810   mc_adj_matrix_810                                 1
#> 811   mc_adj_matrix_811                                 1
#> 812   mc_adj_matrix_812                                 1
#> 813   mc_adj_matrix_813                                 1
#> 814   mc_adj_matrix_814                                 1
#> 815   mc_adj_matrix_815                                 1
#> 816   mc_adj_matrix_816                                 1
#> 817   mc_adj_matrix_817                                 1
#> 818   mc_adj_matrix_818                                 1
#> 819   mc_adj_matrix_819                                 1
#> 820   mc_adj_matrix_820                                 1
#> 821   mc_adj_matrix_821                                 1
#> 822   mc_adj_matrix_822                                 1
#> 823   mc_adj_matrix_823                                 1
#> 824   mc_adj_matrix_824                                 1
#> 825   mc_adj_matrix_825                                 1
#> 826   mc_adj_matrix_826                                 1
#> 827   mc_adj_matrix_827                                 1
#> 828   mc_adj_matrix_828                                 1
#> 829   mc_adj_matrix_829                                 1
#> 830   mc_adj_matrix_830                                 1
#> 831   mc_adj_matrix_831                                 1
#> 832   mc_adj_matrix_832                                 1
#> 833   mc_adj_matrix_833                                 1
#> 834   mc_adj_matrix_834                                 1
#> 835   mc_adj_matrix_835                                 1
#> 836   mc_adj_matrix_836                                 1
#> 837   mc_adj_matrix_837                                 1
#> 838   mc_adj_matrix_838                                 1
#> 839   mc_adj_matrix_839                                 1
#> 840   mc_adj_matrix_840                                 1
#> 841   mc_adj_matrix_841                                 1
#> 842   mc_adj_matrix_842                                 1
#> 843   mc_adj_matrix_843                                 1
#> 844   mc_adj_matrix_844                                 1
#> 845   mc_adj_matrix_845                                 1
#> 846   mc_adj_matrix_846                                 1
#> 847   mc_adj_matrix_847                                 1
#> 848   mc_adj_matrix_848                                 1
#> 849   mc_adj_matrix_849                                 1
#> 850   mc_adj_matrix_850                                 1
#> 851   mc_adj_matrix_851                                 1
#> 852   mc_adj_matrix_852                                 1
#> 853   mc_adj_matrix_853                                 1
#> 854   mc_adj_matrix_854                                 1
#> 855   mc_adj_matrix_855                                 1
#> 856   mc_adj_matrix_856                                 1
#> 857   mc_adj_matrix_857                                 1
#> 858   mc_adj_matrix_858                                 1
#> 859   mc_adj_matrix_859                                 1
#> 860   mc_adj_matrix_860                                 1
#> 861   mc_adj_matrix_861                                 1
#> 862   mc_adj_matrix_862                                 1
#> 863   mc_adj_matrix_863                                 1
#> 864   mc_adj_matrix_864                                 1
#> 865   mc_adj_matrix_865                                 1
#> 866   mc_adj_matrix_866                                 1
#> 867   mc_adj_matrix_867                                 1
#> 868   mc_adj_matrix_868                                 1
#> 869   mc_adj_matrix_869                                 1
#> 870   mc_adj_matrix_870                                 1
#> 871   mc_adj_matrix_871                                 1
#> 872   mc_adj_matrix_872                                 1
#> 873   mc_adj_matrix_873                                 1
#> 874   mc_adj_matrix_874                                 1
#> 875   mc_adj_matrix_875                                 1
#> 876   mc_adj_matrix_876                                 1
#> 877   mc_adj_matrix_877                                 1
#> 878   mc_adj_matrix_878                                 1
#> 879   mc_adj_matrix_879                                 1
#> 880   mc_adj_matrix_880                                 1
#> 881   mc_adj_matrix_881                                 1
#> 882   mc_adj_matrix_882                                 1
#> 883   mc_adj_matrix_883                                 1
#> 884   mc_adj_matrix_884                                 1
#> 885   mc_adj_matrix_885                                 1
#> 886   mc_adj_matrix_886                                 1
#> 887   mc_adj_matrix_887                                 1
#> 888   mc_adj_matrix_888                                 1
#> 889   mc_adj_matrix_889                                 1
#> 890   mc_adj_matrix_890                                 1
#> 891   mc_adj_matrix_891                                 1
#> 892   mc_adj_matrix_892                                 1
#> 893   mc_adj_matrix_893                                 1
#> 894   mc_adj_matrix_894                                 1
#> 895   mc_adj_matrix_895                                 1
#> 896   mc_adj_matrix_896                                 1
#> 897   mc_adj_matrix_897                                 1
#> 898   mc_adj_matrix_898                                 1
#> 899   mc_adj_matrix_899                                 1
#> 900   mc_adj_matrix_900                                 1
#> 901   mc_adj_matrix_901                                 1
#> 902   mc_adj_matrix_902                                 1
#> 903   mc_adj_matrix_903                                 1
#> 904   mc_adj_matrix_904                                 1
#> 905   mc_adj_matrix_905                                 1
#> 906   mc_adj_matrix_906                                 1
#> 907   mc_adj_matrix_907                                 1
#> 908   mc_adj_matrix_908                                 1
#> 909   mc_adj_matrix_909                                 1
#> 910   mc_adj_matrix_910                                 1
#> 911   mc_adj_matrix_911                                 1
#> 912   mc_adj_matrix_912                                 1
#> 913   mc_adj_matrix_913                                 1
#> 914   mc_adj_matrix_914                                 1
#> 915   mc_adj_matrix_915                                 1
#> 916   mc_adj_matrix_916                                 1
#> 917   mc_adj_matrix_917                                 1
#> 918   mc_adj_matrix_918                                 1
#> 919   mc_adj_matrix_919                                 1
#> 920   mc_adj_matrix_920                                 1
#> 921   mc_adj_matrix_921                                 1
#> 922   mc_adj_matrix_922                                 1
#> 923   mc_adj_matrix_923                                 1
#> 924   mc_adj_matrix_924                                 1
#> 925   mc_adj_matrix_925                                 1
#> 926   mc_adj_matrix_926                                 1
#> 927   mc_adj_matrix_927                                 1
#> 928   mc_adj_matrix_928                                 1
#> 929   mc_adj_matrix_929                                 1
#> 930   mc_adj_matrix_930                                 1
#> 931   mc_adj_matrix_931                                 1
#> 932   mc_adj_matrix_932                                 1
#> 933   mc_adj_matrix_933                                 1
#> 934   mc_adj_matrix_934                                 1
#> 935   mc_adj_matrix_935                                 1
#> 936   mc_adj_matrix_936                                 1
#> 937   mc_adj_matrix_937                                 1
#> 938   mc_adj_matrix_938                                 1
#> 939   mc_adj_matrix_939                                 1
#> 940   mc_adj_matrix_940                                 1
#> 941   mc_adj_matrix_941                                 1
#> 942   mc_adj_matrix_942                                 1
#> 943   mc_adj_matrix_943                                 1
#> 944   mc_adj_matrix_944                                 1
#> 945   mc_adj_matrix_945                                 1
#> 946   mc_adj_matrix_946                                 1
#> 947   mc_adj_matrix_947                                 1
#> 948   mc_adj_matrix_948                                 1
#> 949   mc_adj_matrix_949                                 1
#> 950   mc_adj_matrix_950                                 1
#> 951   mc_adj_matrix_951                                 1
#> 952   mc_adj_matrix_952                                 1
#> 953   mc_adj_matrix_953                                 1
#> 954   mc_adj_matrix_954                                 1
#> 955   mc_adj_matrix_955                                 1
#> 956   mc_adj_matrix_956                                 1
#> 957   mc_adj_matrix_957                                 1
#> 958   mc_adj_matrix_958                                 1
#> 959   mc_adj_matrix_959                                 1
#> 960   mc_adj_matrix_960                                 1
#> 961   mc_adj_matrix_961                                 1
#> 962   mc_adj_matrix_962                                 1
#> 963   mc_adj_matrix_963                                 1
#> 964   mc_adj_matrix_964                                 1
#> 965   mc_adj_matrix_965                                 1
#> 966   mc_adj_matrix_966                                 1
#> 967   mc_adj_matrix_967                                 1
#> 968   mc_adj_matrix_968                                 1
#> 969   mc_adj_matrix_969                                 1
#> 970   mc_adj_matrix_970                                 1
#> 971   mc_adj_matrix_971                                 1
#> 972   mc_adj_matrix_972                                 1
#> 973   mc_adj_matrix_973                                 1
#> 974   mc_adj_matrix_974                                 1
#> 975   mc_adj_matrix_975                                 1
#> 976   mc_adj_matrix_976                                 1
#> 977   mc_adj_matrix_977                                 1
#> 978   mc_adj_matrix_978                                 1
#> 979   mc_adj_matrix_979                                 1
#> 980   mc_adj_matrix_980                                 1
#> 981   mc_adj_matrix_981                                 1
#> 982   mc_adj_matrix_982                                 1
#> 983   mc_adj_matrix_983                                 1
#> 984   mc_adj_matrix_984                                 1
#> 985   mc_adj_matrix_985                                 1
#> 986   mc_adj_matrix_986                                 1
#> 987   mc_adj_matrix_987                                 1
#> 988   mc_adj_matrix_988                                 1
#> 989   mc_adj_matrix_989                                 1
#> 990   mc_adj_matrix_990                                 1
#> 991   mc_adj_matrix_991                                 1
#> 992   mc_adj_matrix_992                                 1
#> 993   mc_adj_matrix_993                                 1
#> 994   mc_adj_matrix_994                                 1
#> 995   mc_adj_matrix_995                                 1
#> 996   mc_adj_matrix_996                                 1
#> 997   mc_adj_matrix_997                                 1
#> 998   mc_adj_matrix_998                                 1
#> 999   mc_adj_matrix_999                                 1
#> 1000 mc_adj_matrix_1000                                 1
#>      Public.Education.Programs Salts.Added.during.Water.Treatment
#> 1                 0.000000e+00                       0.000000e+00
#> 2                 6.781461e-06                       6.781461e-06
#> 3                 2.018292e-07                       2.018292e-07
#> 4                 6.875648e-06                       6.875648e-06
#> 5                -6.458534e-07                      -6.458534e-07
#> 6                 4.305689e-07                       4.305689e-07
#> 7                -7.534956e-07                      -7.534956e-07
#> 8                 1.668455e-06                       1.668455e-06
#> 9                 1.291707e-06                       1.291707e-06
#> 10                8.073167e-08                       8.073167e-08
#> 11                2.018292e-07                       2.018292e-07
#> 12                6.458534e-07                       6.458534e-07
#> 13                0.000000e+00                       0.000000e+00
#> 14                4.036584e-07                       4.036584e-07
#> 15                1.883739e-07                       1.883739e-07
#> 16                0.000000e+00                       0.000000e+00
#> 17                0.000000e+00                       0.000000e+00
#> 18                0.000000e+00                       0.000000e+00
#> 19                4.171136e-07                       4.171136e-07
#> 20                1.614633e-07                       1.614633e-07
#> 21                1.883739e-07                       1.883739e-07
#> 22                4.171136e-07                       4.171136e-07
#> 23                0.000000e+00                       0.000000e+00
#> 24                0.000000e+00                       0.000000e+00
#> 25                1.668455e-06                       1.668455e-06
#> 26                4.709348e-08                       4.709348e-08
#> 27                0.000000e+00                       0.000000e+00
#> 28                6.875648e-06                       6.875648e-06
#> 29                3.229267e-07                       3.229267e-07
#> 30                5.045730e-09                       5.045730e-09
#> 31                0.000000e+00                       0.000000e+00
#> 32               -2.583414e-06                      -2.583414e-06
#> 33                0.000000e+00                       0.000000e+00
#> 34                1.695365e-06                       1.695365e-06
#> 35                0.000000e+00                       0.000000e+00
#> 36                3.767478e-07                       3.767478e-07
#> 37                1.715548e-06                       1.715548e-06
#> 38               -7.534956e-07                      -7.534956e-07
#> 39               -4.305689e-07                      -4.305689e-07
#> 40               -8.611379e-07                      -8.611379e-07
#> 41                1.708820e-06                       1.708820e-06
#> 42                4.036584e-08                       4.036584e-08
#> 43               -3.767478e-07                      -3.767478e-07
#> 44               -8.073167e-08                      -8.073167e-08
#> 45                3.431096e-06                       3.431096e-06
#> 46               -1.076422e-07                      -1.076422e-07
#> 47                6.781461e-06                       6.781461e-06
#> 48                3.417641e-06                       3.417641e-06
#> 49                0.000000e+00                       0.000000e+00
#> 50                6.727639e-09                       6.727639e-09
#> 51                0.000000e+00                       0.000000e+00
#> 52                0.000000e+00                       0.000000e+00
#> 53                0.000000e+00                       0.000000e+00
#> 54                4.036584e-07                       4.036584e-07
#> 55                8.073167e-08                       8.073167e-08
#> 56                0.000000e+00                       0.000000e+00
#> 57                0.000000e+00                       0.000000e+00
#> 58                3.431096e-06                       3.431096e-06
#> 59                3.013983e-06                       3.013983e-06
#> 60                3.056197e-01                       1.708820e-06
#> 61                3.767478e-07                       3.767478e-07
#> 62                1.883739e-07                       1.883739e-07
#> 63                1.614633e-07                       1.614633e-07
#> 64                0.000000e+00                       0.000000e+00
#> 65                0.000000e+00                       0.000000e+00
#> 66                0.000000e+00                       0.000000e+00
#> 67                2.082887e-01                       1.076422e-07
#> 68                2.691056e-08                       2.691056e-08
#> 69                0.000000e+00                       0.000000e+00
#> 70                8.476826e-07                       8.476826e-07
#> 71                0.000000e+00                       0.000000e+00
#> 72                0.000000e+00                       0.000000e+00
#> 73               -4.305689e-07                      -4.305689e-07
#> 74                0.000000e+00                       0.000000e+00
#> 75                0.000000e+00                       0.000000e+00
#> 76                0.000000e+00                       0.000000e+00
#> 77                0.000000e+00                       0.000000e+00
#> 78                1.883739e-07                       1.883739e-07
#> 79                0.000000e+00                       0.000000e+00
#> 80                1.614633e-07                       1.614633e-07
#> 81                0.000000e+00                       0.000000e+00
#> 82                0.000000e+00                       0.000000e+00
#> 83                5.382112e-08                       5.382112e-08
#> 84               -3.767478e-07                      -3.767478e-07
#> 85                3.437824e-06                       3.437824e-06
#> 86                0.000000e+00                       0.000000e+00
#> 87                0.000000e+00                       0.000000e+00
#> 88                0.000000e+00                       0.000000e+00
#> 89                1.614633e-07                       1.614633e-07
#> 90                0.000000e+00                       0.000000e+00
#> 91                3.417641e-06                       3.417641e-06
#> 92                0.000000e+00                       0.000000e+00
#> 93                1.614633e-06                       1.614633e-06
#> 94               -7.534956e-07                      -7.534956e-07
#> 95                8.342273e-07                       8.342273e-07
#> 96                0.000000e+00                       0.000000e+00
#> 97                3.417641e-06                       3.417641e-06
#> 98                3.229267e-07                       3.229267e-07
#> 99                4.036584e-08                       4.036584e-08
#> 100               0.000000e+00                       0.000000e+00
#> 101               1.708820e-06                       1.708820e-06
#> 102               2.359418e-01                      -7.534956e-07
#> 103               8.073167e-07                       8.073167e-07
#> 104              -8.073167e-07                      -8.073167e-07
#> 105               0.000000e+00                       0.000000e+00
#> 106               3.229267e-06                       3.229267e-06
#> 107              -7.534956e-07                      -7.534956e-07
#> 108               6.835282e-06                       6.835282e-06
#> 109               6.835282e-06                       6.835282e-06
#> 110               3.229267e-07                       3.229267e-07
#> 111               0.000000e+00                       0.000000e+00
#> 112               0.000000e+00                       0.000000e+00
#> 113               0.000000e+00                       0.000000e+00
#> 114               0.000000e+00                       0.000000e+00
#> 115               1.723865e-01                       9.418695e-08
#> 116               4.171136e-07                       4.171136e-07
#> 117               0.000000e+00                       0.000000e+00
#> 118               2.085568e-07                       2.085568e-07
#> 119               1.076422e-07                       1.076422e-07
#> 120               0.000000e+00                       0.000000e+00
#> 121              -5.382112e-08                      -5.382112e-08
#> 122               0.000000e+00                       0.000000e+00
#> 123               0.000000e+00                       0.000000e+00
#> 124               0.000000e+00                       0.000000e+00
#> 125               0.000000e+00                       0.000000e+00
#> 126               0.000000e+00                       0.000000e+00
#> 127               0.000000e+00                       0.000000e+00
#> 128               0.000000e+00                       0.000000e+00
#> 129               2.152845e-07                       2.152845e-07
#> 130               8.342273e-07                       8.342273e-07
#> 131               1.708820e-06                       1.708820e-06
#> 132               0.000000e+00                       0.000000e+00
#> 133               1.614633e-07                       1.614633e-07
#> 134               6.458534e-07                       6.458534e-07
#> 135               0.000000e+00                       0.000000e+00
#> 136               1.076422e-07                       1.076422e-07
#> 137               0.000000e+00                       0.000000e+00
#> 138               1.708820e-06                       1.708820e-06
#> 139               1.708820e-06                       1.708820e-06
#> 140               0.000000e+00                       0.000000e+00
#> 141               1.291707e-06                       1.291707e-06
#> 142               1.524199e-01                       0.000000e+00
#> 143               0.000000e+00                       0.000000e+00
#> 144               8.476826e-07                       8.476826e-07
#> 145               1.009146e-07                       1.009146e-07
#> 146               6.882375e-06                       6.882375e-06
#> 147               1.614633e-07                       1.614633e-07
#> 148               0.000000e+00                       0.000000e+00
#> 149               7.534956e-07                       7.534956e-07
#> 150               1.614633e-07                       1.614633e-07
#> 151               5.382112e-08                       5.382112e-08
#> 152              -1.614633e-06                      -1.614633e-06
#> 153               0.000000e+00                       0.000000e+00
#> 154               3.229267e-07                       3.229267e-07
#> 155               0.000000e+00                       0.000000e+00
#> 156               2.152845e-07                       2.152845e-07
#> 157               0.000000e+00                       0.000000e+00
#> 158               3.417641e-06                       3.417641e-06
#> 159               2.018292e-07                       2.018292e-07
#> 160               8.342273e-07                       8.342273e-07
#> 161               0.000000e+00                       0.000000e+00
#> 162               0.000000e+00                       0.000000e+00
#> 163               1.883739e-07                       1.883739e-07
#> 164               1.614633e-07                       1.614633e-07
#> 165              -1.076422e-07                      -1.076422e-07
#> 166               0.000000e+00                       0.000000e+00
#> 167              -2.152845e-07                      -2.152845e-07
#> 168               0.000000e+00                       0.000000e+00
#> 169               1.883739e-07                       1.883739e-07
#> 170               4.171136e-07                       4.171136e-07
#> 171              -1.076422e-07                       6.580417e-07
#> 172               0.000000e+00                       0.000000e+00
#> 173              -3.229267e-07                      -3.229267e-07
#> 174               1.076422e-07                       1.076422e-07
#> 175               1.883739e-07                       1.883739e-07
#> 176               7.534956e-07                       7.534956e-07
#> 177               7.534956e-07                       7.534956e-07
#> 178               6.835282e-06                       6.835282e-06
#> 179               2.144435e-07                       2.144435e-07
#> 180              -3.229267e-07                      -3.229267e-07
#> 181               3.390730e-06                       3.390730e-06
#> 182               3.417641e-06                       3.417641e-06
#> 183               1.614633e-07                       1.614633e-07
#> 184              -2.018292e-07                      -2.018292e-07
#> 185              -8.342273e-07                      -8.342273e-07
#> 186               8.544102e-07                       8.544102e-07
#> 187               0.000000e+00                       0.000000e+00
#> 188               3.390730e-06                       3.390730e-06
#> 189               0.000000e+00                       0.000000e+00
#> 190               1.883739e-07                       1.883739e-07
#> 191               0.000000e+00                       0.000000e+00
#> 192               3.390730e-06                       3.390730e-06
#> 193               8.073167e-07                       8.073167e-07
#> 194               4.709348e-08                       4.709348e-08
#> 195               2.948995e-01                      -3.767478e-07
#> 196               0.000000e+00                       0.000000e+00
#> 197               0.000000e+00                       0.000000e+00
#> 198              -8.073167e-08                      -8.073167e-08
#> 199               0.000000e+00                       0.000000e+00
#> 200               8.544102e-07                       8.544102e-07
#> 201               0.000000e+00                       0.000000e+00
#> 202               3.437824e-06                       3.437824e-06
#> 203               8.611379e-07                       8.611379e-07
#> 204               0.000000e+00                       0.000000e+00
#> 205              -1.076422e-07                      -1.076422e-07
#> 206               0.000000e+00                       0.000000e+00
#> 207               0.000000e+00                       0.000000e+00
#> 208               8.342273e-07                       8.342273e-07
#> 209               0.000000e+00                       0.000000e+00
#> 210               8.476826e-07                       8.476826e-07
#> 211               1.668455e-06                       1.668455e-06
#> 212               0.000000e+00                       0.000000e+00
#> 213               1.076422e-07                       1.076422e-07
#> 214               2.018292e-07                       2.018292e-07
#> 215               2.152845e-07                       2.152845e-07
#> 216               0.000000e+00                       0.000000e+00
#> 217               0.000000e+00                       0.000000e+00
#> 218               0.000000e+00                       0.000000e+00
#> 219               0.000000e+00                       0.000000e+00
#> 220               0.000000e+00                       0.000000e+00
#> 221               0.000000e+00                       0.000000e+00
#> 222               0.000000e+00                       0.000000e+00
#> 223               0.000000e+00                       0.000000e+00
#> 224               8.342273e-07                       8.342273e-07
#> 225               0.000000e+00                       0.000000e+00
#> 226               2.691056e-08                       2.691056e-08
#> 227               2.963653e-01                       5.382112e-08
#> 228               0.000000e+00                       0.000000e+00
#> 229               3.013983e-06                       3.013983e-06
#> 230               1.839579e-01                       8.577740e-07
#> 231               6.885739e-06                       6.885739e-06
#> 232               3.004644e-01                      -1.076422e-07
#> 233              -1.076422e-07                      -1.076422e-07
#> 234               1.614633e-07                       1.614633e-07
#> 235               0.000000e+00                       0.000000e+00
#> 236              -3.767478e-07                      -3.767478e-07
#> 237               0.000000e+00                       0.000000e+00
#> 238               0.000000e+00                       0.000000e+00
#> 239               0.000000e+00                       0.000000e+00
#> 240               0.000000e+00                       0.000000e+00
#> 241               0.000000e+00                       0.000000e+00
#> 242               0.000000e+00                       0.000000e+00
#> 243               1.614633e-07                       1.614633e-07
#> 244               0.000000e+00                       0.000000e+00
#> 245               0.000000e+00                       0.000000e+00
#> 246               1.708820e-06                       1.708820e-06
#> 247               0.000000e+00                       0.000000e+00
#> 248               0.000000e+00                       0.000000e+00
#> 249               6.781461e-06                       6.781461e-06
#> 250               3.767478e-07                       3.767478e-07
#> 251               1.695365e-06                       1.695365e-06
#> 252               8.342273e-07                       8.342273e-07
#> 253               1.076422e-07                       1.076422e-07
#> 254               0.000000e+00                       0.000000e+00
#> 255               0.000000e+00                       0.000000e+00
#> 256               0.000000e+00                       0.000000e+00
#> 257               8.073167e-07                       8.073167e-07
#> 258              -7.534956e-07                      -7.534956e-07
#> 259               1.695365e-06                       1.695365e-06
#> 260               1.614633e-06                       1.614633e-06
#> 261               2.018292e-08                       2.018292e-08
#> 262               0.000000e+00                       0.000000e+00
#> 263               4.238413e-07                       4.238413e-07
#> 264               1.668455e-06                       1.668455e-06
#> 265               6.882375e-06                       6.882375e-06
#> 266               0.000000e+00                       0.000000e+00
#> 267               0.000000e+00                       0.000000e+00
#> 268               1.715548e-06                       1.715548e-06
#> 269               2.678925e-01                       1.722065e-06
#> 270               4.036584e-07                       4.036584e-07
#> 271               1.668455e-06                      -8.984677e-06
#> 272               0.000000e+00                       0.000000e+00
#> 273               0.000000e+00                       0.000000e+00
#> 274               0.000000e+00                       0.000000e+00
#> 275               2.656960e-01                       4.036584e-07
#> 276               1.009146e-07                       1.009146e-07
#> 277               0.000000e+00                       0.000000e+00
#> 278               1.708820e-06                       1.708820e-06
#> 279               0.000000e+00                       0.000000e+00
#> 280               0.000000e+00                       0.000000e+00
#> 281               0.000000e+00                       0.000000e+00
#> 282               8.073167e-08                       8.073167e-08
#> 283               0.000000e+00                       0.000000e+00
#> 284               0.000000e+00                       0.000000e+00
#> 285              -4.305689e-07                      -4.305689e-07
#> 286               0.000000e+00                       0.000000e+00
#> 287              -4.305689e-07                      -4.305689e-07
#> 288               1.708820e-06                       1.708820e-06
#> 289               7.534956e-07                       7.534956e-07
#> 290               0.000000e+00                       0.000000e+00
#> 291               0.000000e+00                       0.000000e+00
#> 292               0.000000e+00                       0.000000e+00
#> 293               0.000000e+00                       0.000000e+00
#> 294               0.000000e+00                       0.000000e+00
#> 295               0.000000e+00                       0.000000e+00
#> 296               0.000000e+00                       0.000000e+00
#> 297               0.000000e+00                       0.000000e+00
#> 298              -1.614633e-07                      -1.614633e-07
#> 299               0.000000e+00                       0.000000e+00
#> 300               1.076422e-07                       1.076422e-07
#> 301               0.000000e+00                       0.000000e+00
#> 302               8.342273e-07                       8.342273e-07
#> 303               0.000000e+00                       0.000000e+00
#> 304               4.171136e-07                       4.171136e-07
#> 305               0.000000e+00                       0.000000e+00
#> 306              -1.614633e-07                      -1.614633e-07
#> 307               5.382112e-08                       5.382112e-08
#> 308               0.000000e+00                       0.000000e+00
#> 309               0.000000e+00                       0.000000e+00
#> 310               1.614633e-06                       1.614633e-06
#> 311               0.000000e+00                       0.000000e+00
#> 312               0.000000e+00                       0.000000e+00
#> 313               0.000000e+00                       0.000000e+00
#> 314               0.000000e+00                       0.000000e+00
#> 315               0.000000e+00                       0.000000e+00
#> 316               0.000000e+00                       0.000000e+00
#> 317               0.000000e+00                       0.000000e+00
#> 318               8.073167e-07                       8.073167e-07
#> 319               2.152845e-07                       2.152845e-07
#> 320               1.076422e-07                       1.076422e-07
#> 321               1.076422e-07                       1.076422e-07
#> 322               5.382112e-08                       5.382112e-08
#> 323               4.171136e-07                       4.171136e-07
#> 324              -8.611379e-07                      -8.611379e-07
#> 325              -1.614633e-07                      -1.614633e-07
#> 326               0.000000e+00                       0.000000e+00
#> 327               0.000000e+00                       0.000000e+00
#> 328               8.476826e-07                       8.476826e-07
#> 329               1.708820e-06                       1.708820e-06
#> 330               0.000000e+00                       0.000000e+00
#> 331              -8.073167e-07                      -8.073167e-07
#> 332               0.000000e+00                       0.000000e+00
#> 333               1.506991e-06                       1.506991e-06
#> 334               6.458534e-07                       6.458534e-07
#> 335               4.171136e-07                       4.171136e-07
#> 336               7.534956e-07                       7.534956e-07
#> 337               3.437824e-06                       3.437824e-06
#> 338               0.000000e+00                       0.000000e+00
#> 339               0.000000e+00                       0.000000e+00
#> 340               0.000000e+00                       0.000000e+00
#> 341               1.076422e-07                       1.076422e-07
#> 342               8.611379e-07                       8.611379e-07
#> 343               3.390730e-06                       3.390730e-06
#> 344               1.076422e-07                       1.076422e-07
#> 345               0.000000e+00                       0.000000e+00
#> 346               1.076422e-07                       1.076422e-07
#> 347               0.000000e+00                       0.000000e+00
#> 348               3.229267e-07                       3.229267e-07
#> 349               7.534956e-07                       7.534956e-07
#> 350               4.036584e-07                       4.036584e-07
#> 351               0.000000e+00                       0.000000e+00
#> 352               6.027965e-06                       6.027965e-06
#> 353               0.000000e+00                       0.000000e+00
#> 354               8.073167e-07                       8.073167e-07
#> 355               6.781461e-06                       6.781461e-06
#> 356               0.000000e+00                       0.000000e+00
#> 357               0.000000e+00                       0.000000e+00
#> 358               0.000000e+00                       0.000000e+00
#> 359               0.000000e+00                       0.000000e+00
#> 360               8.476826e-07                       8.476826e-07
#> 361               3.767478e-07                       3.767478e-07
#> 362               0.000000e+00                       0.000000e+00
#> 363               8.476826e-07                       8.476826e-07
#> 364               3.336909e-06                       3.336909e-06
#> 365               1.883739e-07                       1.883739e-07
#> 366               2.102387e-10                       2.102387e-10
#> 367               0.000000e+00                       0.000000e+00
#> 368               5.382112e-08                       5.382112e-08
#> 369               0.000000e+00                       0.000000e+00
#> 370               6.875648e-06                       6.875648e-06
#> 371              -7.534956e-07                      -7.534956e-07
#> 372               4.238413e-07                       4.238413e-07
#> 373              -1.076422e-07                      -1.076422e-07
#> 374               0.000000e+00                       0.000000e+00
#> 375               0.000000e+00                       0.000000e+00
#> 376               3.174085e-01                       2.152779e-07
#> 377               1.009146e-07                       1.009146e-07
#> 378              -1.076422e-07                      -1.076422e-07
#> 379               1.883739e-07                       1.883739e-07
#> 380               0.000000e+00                       0.000000e+00
#> 381               8.342273e-07                       8.342273e-07
#> 382               0.000000e+00                       0.000000e+00
#> 383               4.171136e-07                       4.171136e-07
#> 384               0.000000e+00                       0.000000e+00
#> 385               2.152845e-07                       2.152845e-07
#> 386               8.073167e-07                       8.073167e-07
#> 387               1.076422e-07                       1.076422e-07
#> 388               1.009146e-07                       1.009146e-07
#> 389               0.000000e+00                       0.000000e+00
#> 390               1.668455e-06                       1.668455e-06
#> 391              -1.291707e-06                      -1.291707e-06
#> 392              -3.013983e-06                      -3.013983e-06
#> 393               8.476826e-07                       8.476826e-07
#> 394               3.767478e-07                       3.767478e-07
#> 395               0.000000e+00                       0.000000e+00
#> 396               3.229267e-07                       3.229267e-07
#> 397               0.000000e+00                       0.000000e+00
#> 398               2.191649e-01                       6.307162e-09
#> 399               0.000000e+00                       0.000000e+00
#> 400               0.000000e+00                       0.000000e+00
#> 401               5.382112e-08                       5.382112e-08
#> 402               0.000000e+00                       0.000000e+00
#> 403               1.695365e-06                       1.695365e-06
#> 404               4.709348e-08                       4.709348e-08
#> 405               0.000000e+00                       0.000000e+00
#> 406               8.602969e-07                       8.602969e-07
#> 407               0.000000e+00                       0.000000e+00
#> 408               0.000000e+00                       0.000000e+00
#> 409               8.476826e-07                      -1.042382e-05
#> 410               1.705280e-01                       8.577740e-07
#> 411              -7.534956e-07                      -7.534956e-07
#> 412               0.000000e+00                       0.000000e+00
#> 413               0.000000e+00                       0.000000e+00
#> 414               3.767478e-07                       3.767478e-07
#> 415               8.342273e-07                       8.342273e-07
#> 416               6.781461e-06                       6.781461e-06
#> 417               2.018292e-07                       2.018292e-07
#> 418               0.000000e+00                       0.000000e+00
#> 419               0.000000e+00                       0.000000e+00
#> 420               8.073167e-07                       8.073167e-07
#> 421               0.000000e+00                       0.000000e+00
#> 422               0.000000e+00                       0.000000e+00
#> 423              -7.534956e-07                      -7.534956e-07
#> 424               8.342273e-07                       8.342273e-07
#> 425               3.336909e-06                       3.336909e-06
#> 426               0.000000e+00                       0.000000e+00
#> 427              -1.506991e-06                      -1.506991e-06
#> 428               4.238413e-07                       4.238413e-07
#> 429               1.883739e-07                       1.883739e-07
#> 430               3.229267e-07                       3.229267e-07
#> 431               1.614633e-06                       1.614633e-06
#> 432              -1.076422e-07                      -1.076422e-07
#> 433               0.000000e+00                       0.000000e+00
#> 434              -2.152845e-07                      -2.152845e-07
#> 435               4.171136e-07                       4.171136e-07
#> 436               0.000000e+00                       0.000000e+00
#> 437               0.000000e+00                       0.000000e+00
#> 438               1.883739e-07                       1.883739e-07
#> 439               0.000000e+00                       0.000000e+00
#> 440              -3.767478e-07                      -3.767478e-07
#> 441               0.000000e+00                       0.000000e+00
#> 442               2.691056e-08                       2.691056e-08
#> 443               0.000000e+00                       0.000000e+00
#> 444               4.171136e-07                       4.171136e-07
#> 445               1.297208e-01                      -1.614633e-07
#> 446               0.000000e+00                       0.000000e+00
#> 447               3.229267e-07                       3.229267e-07
#> 448               7.534956e-07                       7.534956e-07
#> 449               8.073167e-08                       8.073167e-08
#> 450               0.000000e+00                       0.000000e+00
#> 451               3.437824e-06                       3.437824e-06
#> 452               0.000000e+00                       0.000000e+00
#> 453               0.000000e+00                       0.000000e+00
#> 454              -1.722276e-06                      -1.722276e-06
#> 455               3.336909e-06                       3.336909e-06
#> 456              -6.458534e-07                      -6.458534e-07
#> 457               0.000000e+00                       0.000000e+00
#> 458               1.708820e-06                       1.708820e-06
#> 459               2.742175e-01                       7.534956e-07
#> 460               4.036584e-07                       4.036584e-07
#> 461               1.695365e-06                       1.695365e-06
#> 462               0.000000e+00                       0.000000e+00
#> 463               1.614633e-06                       1.614633e-06
#> 464               1.883739e-07                       1.883739e-07
#> 465               2.471377e-01                       6.862192e-06
#> 466               0.000000e+00                       0.000000e+00
#> 467               0.000000e+00                       0.000000e+00
#> 468               1.883739e-07                       1.883739e-07
#> 469               0.000000e+00                       0.000000e+00
#> 470               0.000000e+00                       0.000000e+00
#> 471               1.718912e-06                       1.718912e-06
#> 472              -3.767478e-07                      -3.767478e-07
#> 473              -4.305689e-07                      -4.305689e-07
#> 474               0.000000e+00                       0.000000e+00
#> 475               3.441188e-06                       3.441188e-06
#> 476               0.000000e+00                       0.000000e+00
#> 477               0.000000e+00                       0.000000e+00
#> 478               3.437824e-06                       3.437824e-06
#> 479               0.000000e+00                       0.000000e+00
#> 480               0.000000e+00                       0.000000e+00
#> 481               0.000000e+00                       0.000000e+00
#> 482               0.000000e+00                       0.000000e+00
#> 483               8.476826e-07                       8.476826e-07
#> 484               0.000000e+00                       0.000000e+00
#> 485              -4.305689e-07                      -4.305689e-07
#> 486               4.036584e-07                       4.036584e-07
#> 487               0.000000e+00                       0.000000e+00
#> 488              -4.305689e-07                      -4.305689e-07
#> 489               0.000000e+00                       0.000000e+00
#> 490               0.000000e+00                       0.000000e+00
#> 491               8.342273e-07                      -7.621268e-06
#> 492              -4.305689e-07                      -4.305689e-07
#> 493               8.073167e-07                       8.073167e-07
#> 494               3.229267e-07                       3.229267e-07
#> 495              -4.305689e-07                      -4.305689e-07
#> 496               5.382112e-08                       5.382112e-08
#> 497               3.437824e-06                       3.437824e-06
#> 498               4.238413e-07                       4.238413e-07
#> 499               6.458534e-07                       6.458534e-07
#> 500               0.000000e+00                       0.000000e+00
#> 501               0.000000e+00                       0.000000e+00
#> 502              -8.611379e-07                      -8.611379e-07
#> 503               2.018292e-07                       2.018292e-07
#> 504               0.000000e+00                       0.000000e+00
#> 505               6.875648e-06                       6.875648e-06
#> 506               1.009146e-07                       1.009146e-07
#> 507               8.342273e-07                       8.342273e-07
#> 508               6.882375e-06                       6.882375e-06
#> 509               0.000000e+00                       0.000000e+00
#> 510               0.000000e+00                       0.000000e+00
#> 511               1.076422e-07                       1.076422e-07
#> 512               0.000000e+00                       0.000000e+00
#> 513               4.238413e-07                       4.238413e-07
#> 514               5.382112e-08                       5.382112e-08
#> 515               1.614633e-07                       1.614633e-07
#> 516               2.018292e-07                       2.018292e-07
#> 517               1.883739e-07                       1.883739e-07
#> 518               0.000000e+00                       0.000000e+00
#> 519               3.767478e-07                       3.767478e-07
#> 520               1.715548e-06                       1.715548e-06
#> 521               1.695365e-06                       1.695365e-06
#> 522               0.000000e+00                       0.000000e+00
#> 523               3.767478e-07                       3.767478e-07
#> 524               8.602969e-07                       8.602969e-07
#> 525               0.000000e+00                       0.000000e+00
#> 526               1.708820e-06                       1.708820e-06
#> 527               0.000000e+00                       0.000000e+00
#> 528               0.000000e+00                       0.000000e+00
#> 529               2.691056e-08                       2.691056e-08
#> 530               0.000000e+00                       0.000000e+00
#> 531               0.000000e+00                       0.000000e+00
#> 532               0.000000e+00                       0.000000e+00
#> 533               0.000000e+00                       0.000000e+00
#> 534               4.036584e-07                       4.036584e-07
#> 535               0.000000e+00                       0.000000e+00
#> 536               0.000000e+00                       0.000000e+00
#> 537               5.382112e-08                       5.382112e-08
#> 538               0.000000e+00                       0.000000e+00
#> 539               0.000000e+00                       0.000000e+00
#> 540               2.018292e-07                       2.018292e-07
#> 541               1.708820e-06                      -5.515155e-06
#> 542               4.238413e-07                       4.238413e-07
#> 543               0.000000e+00                       0.000000e+00
#> 544               0.000000e+00                       0.000000e+00
#> 545               0.000000e+00                       0.000000e+00
#> 546               8.544102e-07                       8.544102e-07
#> 547               0.000000e+00                       0.000000e+00
#> 548               0.000000e+00                       0.000000e+00
#> 549               8.342273e-07                       8.342273e-07
#> 550               0.000000e+00                       0.000000e+00
#> 551               1.883739e-07                       1.883739e-07
#> 552               0.000000e+00                       0.000000e+00
#> 553              -1.506991e-06                      -1.506991e-06
#> 554               0.000000e+00                       0.000000e+00
#> 555              -3.767478e-07                      -3.767478e-07
#> 556              -6.458534e-07                      -6.458534e-07
#> 557              -2.152845e-07                      -2.152845e-07
#> 558               0.000000e+00                       0.000000e+00
#> 559               4.171136e-07                       4.171136e-07
#> 560               5.382112e-08                      -7.901926e-07
#> 561               0.000000e+00                       0.000000e+00
#> 562               8.342273e-07                       8.342273e-07
#> 563               8.476826e-07                       8.476826e-07
#> 564               4.171136e-07                       4.171136e-07
#> 565               0.000000e+00                       0.000000e+00
#> 566               0.000000e+00                       0.000000e+00
#> 567              -2.691056e-08                      -2.691056e-08
#> 568               0.000000e+00                       0.000000e+00
#> 569              -4.305689e-07                      -4.305689e-07
#> 570               8.342273e-07                       8.342273e-07
#> 571               5.382112e-08                       5.382112e-08
#> 572              -4.305689e-07                      -4.305689e-07
#> 573               0.000000e+00                       0.000000e+00
#> 574               1.883739e-07                       1.883739e-07
#> 575               1.009146e-07                       1.009146e-07
#> 576               1.883739e-07                       1.883739e-07
#> 577               1.150829e-01                       5.382112e-08
#> 578               8.073167e-08                       8.073167e-08
#> 579               4.036584e-07                       4.036584e-07
#> 580               0.000000e+00                       0.000000e+00
#> 581               0.000000e+00                       0.000000e+00
#> 582               0.000000e+00                       0.000000e+00
#> 583               0.000000e+00                       0.000000e+00
#> 584               0.000000e+00                       0.000000e+00
#> 585              -2.583414e-06                      -2.583414e-06
#> 586               0.000000e+00                       0.000000e+00
#> 587               1.076422e-07                       1.076422e-07
#> 588               8.073167e-07                       8.073167e-07
#> 589               0.000000e+00                       0.000000e+00
#> 590               0.000000e+00                       0.000000e+00
#> 591               0.000000e+00                       0.000000e+00
#> 592               1.708820e-06                      -7.431832e-06
#> 593               3.767478e-07                       3.767478e-07
#> 594              -1.681910e-09                      -1.681910e-09
#> 595              -1.076422e-07                      -1.076422e-07
#> 596               1.695365e-06                       1.695365e-06
#> 597               1.572797e-01                       1.291707e-06
#> 598               0.000000e+00                       0.000000e+00
#> 599               3.767478e-07                       3.767478e-07
#> 600               2.220428e-01                       3.229267e-06
#> 601               4.238413e-07                       4.238413e-07
#> 602               1.614633e-07                       1.614633e-07
#> 603               0.000000e+00                       0.000000e+00
#> 604              -1.076422e-07                      -1.076422e-07
#> 605               0.000000e+00                       0.000000e+00
#> 606               3.417641e-06                       3.417641e-06
#> 607               1.715548e-06                       1.715548e-06
#> 608               0.000000e+00                       0.000000e+00
#> 609               3.390730e-06                       3.390730e-06
#> 610               6.862192e-06                       6.862192e-06
#> 611               3.431096e-06                       3.431096e-06
#> 612               0.000000e+00                       0.000000e+00
#> 613               0.000000e+00                       0.000000e+00
#> 614               3.767478e-07                       3.767478e-07
#> 615               0.000000e+00                       0.000000e+00
#> 616               2.220439e-01                       0.000000e+00
#> 617               4.171136e-07                       4.171136e-07
#> 618               1.614633e-07                       1.614633e-07
#> 619               1.668455e-06                       1.668455e-06
#> 620              -4.305689e-07                      -4.305689e-07
#> 621               0.000000e+00                       0.000000e+00
#> 622               0.000000e+00                       0.000000e+00
#> 623               0.000000e+00                       0.000000e+00
#> 624               0.000000e+00                       0.000000e+00
#> 625               4.036584e-07                       4.036584e-07
#> 626              -1.291707e-06                      -1.291707e-06
#> 627               0.000000e+00                       0.000000e+00
#> 628               3.767478e-07                       3.767478e-07
#> 629               7.534956e-07                       7.534956e-07
#> 630               0.000000e+00                       0.000000e+00
#> 631               0.000000e+00                       0.000000e+00
#> 632               0.000000e+00                       0.000000e+00
#> 633               0.000000e+00                       0.000000e+00
#> 634               8.476826e-07                       8.476826e-07
#> 635               2.152845e-07                       2.152845e-07
#> 636               4.171136e-07                       4.171136e-07
#> 637              -7.534956e-07                      -7.534956e-07
#> 638               1.059603e-07                       1.059603e-07
#> 639               0.000000e+00                       0.000000e+00
#> 640               4.288870e-07                       4.288870e-07
#> 641               8.342273e-07                       8.342273e-07
#> 642               0.000000e+00                       0.000000e+00
#> 643               6.458534e-07                       6.458534e-07
#> 644               8.476826e-07                       8.476826e-07
#> 645               1.708820e-06                       1.708820e-06
#> 646               0.000000e+00                       0.000000e+00
#> 647               1.614633e-07                       1.614633e-07
#> 648               3.767478e-07                       3.767478e-07
#> 649               3.336909e-06                       3.336909e-06
#> 650               2.040854e-01                       1.506991e-06
#> 651               2.018292e-07                       2.018292e-07
#> 652               1.883739e-07                       1.883739e-07
#> 653               0.000000e+00                       0.000000e+00
#> 654               6.835282e-06                       6.835282e-06
#> 655               8.073167e-07                       8.073167e-07
#> 656               0.000000e+00                       0.000000e+00
#> 657               0.000000e+00                       0.000000e+00
#> 658               1.883739e-07                       1.883739e-07
#> 659               8.611379e-07                       8.611379e-07
#> 660               4.036584e-07                       4.036584e-07
#> 661               0.000000e+00                       0.000000e+00
#> 662              -6.458534e-07                      -6.458534e-07
#> 663               8.073167e-08                      -7.173507e-07
#> 664               0.000000e+00                       0.000000e+00
#> 665               0.000000e+00                       0.000000e+00
#> 666               3.013983e-06                       3.013983e-06
#> 667               1.883739e-07                       1.883739e-07
#> 668               0.000000e+00                       0.000000e+00
#> 669               0.000000e+00                       0.000000e+00
#> 670               3.767478e-07                       3.767478e-07
#> 671               0.000000e+00                       0.000000e+00
#> 672               4.272051e-07                       4.272051e-07
#> 673              -7.534956e-07                      -7.534956e-07
#> 674               0.000000e+00                       0.000000e+00
#> 675               0.000000e+00                       0.000000e+00
#> 676               1.555984e-01                      -3.767478e-07
#> 677              -1.076422e-07                      -1.076422e-07
#> 678               0.000000e+00                       0.000000e+00
#> 679               1.883739e-07                       1.883739e-07
#> 680               0.000000e+00                       0.000000e+00
#> 681               1.345528e-08                       1.345528e-08
#> 682               3.437824e-06                       3.437824e-06
#> 683               0.000000e+00                       0.000000e+00
#> 684               4.036584e-07                       4.036584e-07
#> 685               1.883739e-07                       1.883739e-07
#> 686               0.000000e+00                       0.000000e+00
#> 687               8.544102e-07                       8.544102e-07
#> 688               0.000000e+00                       0.000000e+00
#> 689               8.342273e-07                       8.342273e-07
#> 690               0.000000e+00                       0.000000e+00
#> 691               0.000000e+00                       0.000000e+00
#> 692               6.673818e-06                       6.673818e-06
#> 693               1.506991e-06                       1.506991e-06
#> 694               0.000000e+00                       0.000000e+00
#> 695               8.073167e-07                      -6.712044e-06
#> 696               0.000000e+00                       0.000000e+00
#> 697               1.688660e-01                       0.000000e+00
#> 698               3.229267e-07                       3.229267e-07
#> 699               1.614633e-07                       1.614633e-07
#> 700               1.695365e-06                       1.695365e-06
#> 701               0.000000e+00                       0.000000e+00
#> 702               4.272051e-07                       4.272051e-07
#> 703               2.388889e-01                       2.144435e-07
#> 704               6.673818e-06                       6.673818e-06
#> 705               3.013983e-06                       3.013983e-06
#> 706               4.036584e-07                       4.036584e-07
#> 707              -1.291707e-06                      -1.291707e-06
#> 708               8.476826e-07                       8.476826e-07
#> 709               4.272051e-07                       4.272051e-07
#> 710               0.000000e+00                       0.000000e+00
#> 711               0.000000e+00                       0.000000e+00
#> 712               1.883739e-07                       1.883739e-07
#> 713               0.000000e+00                       0.000000e+00
#> 714               1.668455e-06                       1.668455e-06
#> 715               3.229267e-07                       3.229267e-07
#> 716               1.614633e-06                       1.614633e-06
#> 717               0.000000e+00                       0.000000e+00
#> 718               8.476826e-07                       8.476826e-07
#> 719               0.000000e+00                       0.000000e+00
#> 720               0.000000e+00                       0.000000e+00
#> 721               0.000000e+00                       0.000000e+00
#> 722               0.000000e+00                       0.000000e+00
#> 723               0.000000e+00                       0.000000e+00
#> 724              -1.076422e-07                      -1.076422e-07
#> 725               0.000000e+00                       0.000000e+00
#> 726               1.009146e-07                       1.009146e-07
#> 727               0.000000e+00                       0.000000e+00
#> 728              -1.076422e-07                      -1.076422e-07
#> 729               1.715548e-06                       1.715548e-06
#> 730               0.000000e+00                       0.000000e+00
#> 731               8.476826e-07                       8.476826e-07
#> 732               8.073167e-08                       8.073167e-08
#> 733               4.036584e-07                       4.036584e-07
#> 734              -6.458534e-07                      -6.458534e-07
#> 735               0.000000e+00                       0.000000e+00
#> 736               0.000000e+00                       0.000000e+00
#> 737               1.695365e-06                       1.695365e-06
#> 738               3.767478e-07                       3.767478e-07
#> 739              -8.611379e-07                      -8.611379e-07
#> 740               5.382112e-08                       5.382112e-08
#> 741               3.431096e-06                       3.431096e-06
#> 742               4.171136e-07                       4.171136e-07
#> 743               0.000000e+00                       0.000000e+00
#> 744               0.000000e+00                       0.000000e+00
#> 745               0.000000e+00                       0.000000e+00
#> 746               0.000000e+00                       0.000000e+00
#> 747               0.000000e+00                       0.000000e+00
#> 748               0.000000e+00                       0.000000e+00
#> 749               3.390730e-06                       3.390730e-06
#> 750              -1.614633e-07                      -1.614633e-07
#> 751               0.000000e+00                       0.000000e+00
#> 752              -5.255973e-11                      -5.255973e-11
#> 753              -4.305689e-07                      -4.305689e-07
#> 754               1.718912e-06                       1.718912e-06
#> 755               4.171136e-07                       4.171136e-07
#> 756               0.000000e+00                       0.000000e+00
#> 757               0.000000e+00                       0.000000e+00
#> 758               2.419042e-01                      -3.767478e-07
#> 759              -7.534956e-07                      -7.534956e-07
#> 760               0.000000e+00                       0.000000e+00
#> 761               5.382112e-08                       5.382112e-08
#> 762               1.695365e-06                       1.695365e-06
#> 763               0.000000e+00                       0.000000e+00
#> 764               7.534956e-07                       7.534956e-07
#> 765               0.000000e+00                       0.000000e+00
#> 766              -3.767478e-07                      -3.767478e-07
#> 767               0.000000e+00                       0.000000e+00
#> 768               1.076422e-07                       1.076422e-07
#> 769               0.000000e+00                       0.000000e+00
#> 770               0.000000e+00                       0.000000e+00
#> 771               0.000000e+00                       0.000000e+00
#> 772               1.883739e-07                       1.883739e-07
#> 773               0.000000e+00                       0.000000e+00
#> 774               0.000000e+00                       0.000000e+00
#> 775               8.544102e-07                       8.544102e-07
#> 776               1.614633e-07                       1.614633e-07
#> 777               0.000000e+00                       0.000000e+00
#> 778               0.000000e+00                       0.000000e+00
#> 779              -1.076422e-07                      -1.076422e-07
#> 780              -1.506991e-06                      -1.506991e-06
#> 781              -1.076422e-07                      -1.076422e-07
#> 782               8.476826e-07                       8.476826e-07
#> 783               7.534956e-07                       7.534956e-07
#> 784               0.000000e+00                       0.000000e+00
#> 785               0.000000e+00                       0.000000e+00
#> 786               4.036584e-07                       4.036584e-07
#> 787               0.000000e+00                       0.000000e+00
#> 788               0.000000e+00                       0.000000e+00
#> 789               0.000000e+00                       0.000000e+00
#> 790               0.000000e+00                       0.000000e+00
#> 791               0.000000e+00                       0.000000e+00
#> 792               0.000000e+00                       0.000000e+00
#> 793               0.000000e+00                       0.000000e+00
#> 794               0.000000e+00                       0.000000e+00
#> 795               6.835282e-06                       6.835282e-06
#> 796               0.000000e+00                       0.000000e+00
#> 797              -6.458534e-07                      -6.458534e-07
#> 798               1.668455e-06                       1.668455e-06
#> 799               4.036584e-07                       4.036584e-07
#> 800               0.000000e+00                       0.000000e+00
#> 801               0.000000e+00                       0.000000e+00
#> 802              -4.305689e-07                      -4.305689e-07
#> 803               0.000000e+00                       0.000000e+00
#> 804               0.000000e+00                       0.000000e+00
#> 805               1.695365e-06                       1.695365e-06
#> 806               8.611379e-07                       8.611379e-07
#> 807               0.000000e+00                       0.000000e+00
#> 808               0.000000e+00                       0.000000e+00
#> 809               2.152845e-07                       2.152845e-07
#> 810              -8.611379e-07                      -8.611379e-07
#> 811               4.036584e-07                       4.036584e-07
#> 812               0.000000e+00                       0.000000e+00
#> 813               8.073167e-07                       8.073167e-07
#> 814               8.342273e-07                       8.342273e-07
#> 815               0.000000e+00                       0.000000e+00
#> 816               2.018292e-07                       2.018292e-07
#> 817               1.614633e-07                      -2.247048e-06
#> 818               0.000000e+00                       0.000000e+00
#> 819               2.454281e-01                       8.594559e-07
#> 820               0.000000e+00                       0.000000e+00
#> 821               4.171136e-07                       4.171136e-07
#> 822               1.883739e-07                      -7.474887e-07
#> 823              -1.076422e-07                      -1.076422e-07
#> 824               0.000000e+00                       0.000000e+00
#> 825               4.171136e-07                       4.171136e-07
#> 826               8.073167e-08                       8.073167e-08
#> 827               4.272051e-07                       4.272051e-07
#> 828               2.085568e-07                       2.085568e-07
#> 829               1.009146e-07                       1.009146e-07
#> 830               1.883739e-07                       1.883739e-07
#> 831               4.171136e-07                       4.171136e-07
#> 832               3.437824e-06                       3.437824e-06
#> 833               2.018292e-07                       2.018292e-07
#> 834               0.000000e+00                       0.000000e+00
#> 835               0.000000e+00                       0.000000e+00
#> 836               0.000000e+00                       0.000000e+00
#> 837               0.000000e+00                       0.000000e+00
#> 838               0.000000e+00                       0.000000e+00
#> 839               8.577740e-07                       8.577740e-07
#> 840               1.718912e-06                       1.718912e-06
#> 841               0.000000e+00                       0.000000e+00
#> 842              -3.767478e-07                      -3.767478e-07
#> 843               2.152845e-07                       2.152845e-07
#> 844               0.000000e+00                       0.000000e+00
#> 845              -7.534956e-07                       2.730048e-06
#> 846               0.000000e+00                       0.000000e+00
#> 847               1.614633e-07                       1.614633e-07
#> 848               0.000000e+00                       0.000000e+00
#> 849               0.000000e+00                       0.000000e+00
#> 850               0.000000e+00                       0.000000e+00
#> 851               0.000000e+00                       0.000000e+00
#> 852               1.506991e-06                       1.506991e-06
#> 853              -2.583414e-06                      -2.583414e-06
#> 854              -4.305689e-07                      -4.305689e-07
#> 855               4.238413e-07                       4.238413e-07
#> 856               2.018292e-07                       2.018292e-07
#> 857               0.000000e+00                       0.000000e+00
#> 858               4.288870e-07                       4.288870e-07
#> 859               3.431096e-06                       3.431096e-06
#> 860               1.076422e-07                       1.076422e-07
#> 861               8.544102e-07                       8.544102e-07
#> 862              -8.611379e-07                      -8.611379e-07
#> 863               2.152845e-07                       2.152845e-07
#> 864               0.000000e+00                       0.000000e+00
#> 865              -6.458534e-07                      -6.458534e-07
#> 866              -3.229267e-07                      -3.229267e-07
#> 867               0.000000e+00                       0.000000e+00
#> 868               1.883739e-07                       1.883739e-07
#> 869               0.000000e+00                       0.000000e+00
#> 870               0.000000e+00                       0.000000e+00
#> 871               0.000000e+00                       0.000000e+00
#> 872               0.000000e+00                       0.000000e+00
#> 873               0.000000e+00                       0.000000e+00
#> 874               6.458534e-07                       6.458534e-07
#> 875               6.885739e-06                       6.885739e-06
#> 876               2.079852e-01                       3.437824e-06
#> 877               0.000000e+00                       0.000000e+00
#> 878               1.708820e-06                       1.708820e-06
#> 879               0.000000e+00                       0.000000e+00
#> 880              -4.305689e-07                      -4.305689e-07
#> 881               0.000000e+00                       0.000000e+00
#> 882               3.390730e-06                       3.390730e-06
#> 883               3.229267e-07                       3.229267e-07
#> 884               0.000000e+00                       0.000000e+00
#> 885               0.000000e+00                       0.000000e+00
#> 886              -3.229267e-07                      -3.229267e-07
#> 887               2.569979e-01                       2.085568e-07
#> 888               0.000000e+00                       0.000000e+00
#> 889               4.036584e-07                       4.036584e-07
#> 890               2.061354e-01                       3.431096e-06
#> 891               0.000000e+00                       0.000000e+00
#> 892               3.336909e-06                       3.336909e-06
#> 893               6.887421e-06                       6.887421e-06
#> 894               1.076422e-07                       1.076422e-07
#> 895               4.171136e-07                       4.171136e-07
#> 896               0.000000e+00                       0.000000e+00
#> 897               0.000000e+00                       0.000000e+00
#> 898               0.000000e+00                       0.000000e+00
#> 899               4.171136e-07                       4.171136e-07
#> 900               0.000000e+00                       0.000000e+00
#> 901               0.000000e+00                       0.000000e+00
#> 902               0.000000e+00                       0.000000e+00
#> 903               3.767478e-07                       3.767478e-07
#> 904              -2.152845e-07                      -2.152845e-07
#> 905               6.458534e-07                       6.458534e-07
#> 906               0.000000e+00                       0.000000e+00
#> 907               0.000000e+00                       0.000000e+00
#> 908               1.614633e-07                       1.614633e-07
#> 909               0.000000e+00                       0.000000e+00
#> 910               0.000000e+00                       0.000000e+00
#> 911               0.000000e+00                       0.000000e+00
#> 912               0.000000e+00                       0.000000e+00
#> 913              -8.611379e-07                      -8.611379e-07
#> 914               2.507755e-01                       8.476826e-07
#> 915               1.614633e-07                       1.614633e-07
#> 916               3.437824e-06                       3.437824e-06
#> 917               3.229267e-07                       3.229267e-07
#> 918               0.000000e+00                       0.000000e+00
#> 919               0.000000e+00                       0.000000e+00
#> 920               4.036584e-07                       4.036584e-07
#> 921               6.875648e-06                       6.875648e-06
#> 922               0.000000e+00                       0.000000e+00
#> 923              -8.611379e-07                      -8.611379e-07
#> 924               2.988297e-01                       3.767478e-07
#> 925               0.000000e+00                       0.000000e+00
#> 926               2.085568e-07                       2.085568e-07
#> 927               0.000000e+00                       0.000000e+00
#> 928               0.000000e+00                       0.000000e+00
#> 929               2.018292e-08                       2.018292e-08
#> 930               1.883739e-07                       1.883739e-07
#> 931               3.431096e-06                       3.431096e-06
#> 932               7.534956e-07                       7.534956e-07
#> 933               1.883739e-07                      -1.182783e-06
#> 934               1.614633e-07                       1.614633e-07
#> 935               3.417641e-06                       3.417641e-06
#> 936               3.336909e-06                       3.336909e-06
#> 937              -7.534956e-07                      -7.534956e-07
#> 938              -1.614633e-07                      -1.614633e-07
#> 939               1.668455e-06                       1.668455e-06
#> 940               0.000000e+00                       0.000000e+00
#> 941               0.000000e+00                       0.000000e+00
#> 942               1.695365e-06                       1.695365e-06
#> 943              -3.229267e-07                      -3.229267e-07
#> 944              -6.458534e-07                      -6.458534e-07
#> 945               0.000000e+00                       0.000000e+00
#> 946               6.673818e-06                       6.673818e-06
#> 947               0.000000e+00                       0.000000e+00
#> 948               0.000000e+00                       0.000000e+00
#> 949               8.342273e-07                       8.342273e-07
#> 950               1.076422e-07                       1.076422e-07
#> 951               0.000000e+00                       0.000000e+00
#> 952               0.000000e+00                       0.000000e+00
#> 953               4.288870e-07                       4.288870e-07
#> 954               0.000000e+00                       0.000000e+00
#> 955               3.390730e-06                       3.390730e-06
#> 956               0.000000e+00                       0.000000e+00
#> 957               0.000000e+00                       0.000000e+00
#> 958               1.614633e-07                       1.614633e-07
#> 959               3.229267e-07                       3.229267e-07
#> 960               0.000000e+00                       0.000000e+00
#> 961               1.076422e-07                       1.076422e-07
#> 962               0.000000e+00                       0.000000e+00
#> 963               0.000000e+00                       0.000000e+00
#> 964              -2.152845e-07                      -2.152845e-07
#> 965               2.691056e-08                       2.691056e-08
#> 966               1.883739e-07                       1.883739e-07
#> 967               0.000000e+00                       0.000000e+00
#> 968               0.000000e+00                       0.000000e+00
#> 969               0.000000e+00                       0.000000e+00
#> 970              -1.076422e-07                      -1.076422e-07
#> 971               4.036584e-07                       4.036584e-07
#> 972               3.767478e-07                       3.767478e-07
#> 973              -7.534956e-07                      -7.534956e-07
#> 974               1.614633e-06                       1.614633e-06
#> 975               7.534956e-07                       7.534956e-07
#> 976               0.000000e+00                       0.000000e+00
#> 977               3.437824e-06                       3.437824e-06
#> 978               0.000000e+00                       0.000000e+00
#> 979              -1.076422e-07                      -1.076422e-07
#> 980              -1.076422e-07                      -1.076422e-07
#> 981               4.036584e-08                       4.036584e-08
#> 982              -2.152845e-07                      -2.152845e-07
#> 983               0.000000e+00                       0.000000e+00
#> 984               1.614633e-07                       1.614633e-07
#> 985               4.036584e-07                       4.036584e-07
#> 986               5.382112e-08                       5.382112e-08
#> 987               3.417641e-06                       3.417641e-06
#> 988               0.000000e+00                       0.000000e+00
#> 989               1.668455e-06                       1.668455e-06
#> 990               4.036584e-07                       4.036584e-07
#> 991               8.577740e-07                       8.577740e-07
#> 992               0.000000e+00                       0.000000e+00
#> 993               0.000000e+00                       0.000000e+00
#> 994               3.390730e-06                       3.390730e-06
#> 995               1.708820e-06                       1.708820e-06
#> 996               1.076422e-07                       1.076422e-07
#> 997               0.000000e+00                       0.000000e+00
#> 998               3.767478e-07                       3.767478e-07
#> 999               0.000000e+00                       0.000000e+00
#> 1000              0.000000e+00                       0.000000e+00
#>      Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                    0.000000e+00     0.000000e+00
#> 2                                   -2.915443e-01     6.781461e-06
#> 3                                   -2.232996e-01     1.548583e-01
#> 4                                   -2.086234e-01     3.599561e-01
#> 5                                   -2.689095e-01     1.912593e-02
#> 6                                   -1.252055e-01     4.305689e-07
#> 7                                   -1.002180e-01     4.381413e-02
#> 8                                   -3.066199e-01     4.180752e-02
#> 9                                   -2.191940e-01     8.297809e-03
#> 10                                  -2.324337e-01     8.041809e-02
#> 11                                  -2.390800e-01     1.342381e-01
#> 12                                  -1.288349e-01     7.172790e-02
#> 13                                   0.000000e+00     0.000000e+00
#> 14                                  -1.920253e-01     1.206155e-01
#> 15                                  -2.053598e-01     9.972196e-02
#> 16                                   0.000000e+00     0.000000e+00
#> 17                                  -1.787365e-01     5.942094e-02
#> 18                                   0.000000e+00     0.000000e+00
#> 19                                  -2.774305e-01     1.184153e-01
#> 20                                  -2.809581e-01     7.646841e-02
#> 21                                  -2.773143e-01     8.429904e-02
#> 22                                  -2.962557e-01     1.056118e-01
#> 23                                   0.000000e+00     0.000000e+00
#> 24                                   0.000000e+00     0.000000e+00
#> 25                                  -2.972504e-01     2.670287e-01
#> 26                                  -1.079816e-01     1.150536e-01
#> 27                                   0.000000e+00     0.000000e+00
#> 28                                  -3.127203e-01     1.501876e-01
#> 29                                  -3.103767e-01     4.341699e-02
#> 30                                  -2.718028e-01     1.803437e-01
#> 31                                  -3.535411e-03     9.424716e-04
#> 32                                  -2.583414e-06     4.169540e-02
#> 33                                   0.000000e+00     0.000000e+00
#> 34                                  -3.150432e-01     5.458509e-02
#> 35                                   0.000000e+00     0.000000e+00
#> 36                                  -2.177439e-01     1.191531e-01
#> 37                                  -2.506570e-01     1.115566e-01
#> 38                                  -2.426048e-01     6.156684e-02
#> 39                                  -4.305689e-07     6.064889e-02
#> 40                                  -1.707409e-01     6.875083e-03
#> 41                                  -2.944879e-01     6.751955e-02
#> 42                                  -2.613760e-01     9.446986e-02
#> 43                                  -1.204159e-01     8.369783e-02
#> 44                                  -6.694068e-02     5.213466e-02
#> 45                                  -3.065014e-01     6.899909e-02
#> 46                                  -1.076422e-07     2.161525e-02
#> 47                                  -2.345692e-01     6.781461e-06
#> 48                                  -2.722139e-01     6.259665e-02
#> 49                                   0.000000e+00     0.000000e+00
#> 50                                  -6.319539e-02     4.618786e-02
#> 51                                   0.000000e+00     0.000000e+00
#> 52                                  -1.622193e-01     5.455664e-02
#> 53                                   0.000000e+00     0.000000e+00
#> 54                                  -3.315572e-01     8.686094e-02
#> 55                                  -1.631900e-01     3.363168e-02
#> 56                                   0.000000e+00     0.000000e+00
#> 57                                  -2.202048e-01     9.145685e-02
#> 58                                  -2.695116e-01     2.144903e-01
#> 59                                  -1.382673e-01     1.379370e-02
#> 60                                   1.708820e-06     1.579995e-01
#> 61                                  -2.519775e-01     4.854614e-02
#> 62                                  -1.750089e-01     5.812795e-02
#> 63                                  -2.834803e-01     6.473440e-02
#> 64                                   0.000000e+00     0.000000e+00
#> 65                                   0.000000e+00     0.000000e+00
#> 66                                   0.000000e+00     0.000000e+00
#> 67                                  -1.766678e-01     4.754297e-02
#> 68                                  -5.745576e-02     3.239796e-02
#> 69                                   0.000000e+00     0.000000e+00
#> 70                                  -1.471530e-01     8.440284e-02
#> 71                                   0.000000e+00     0.000000e+00
#> 72                                   0.000000e+00     0.000000e+00
#> 73                                  -5.380221e-02     9.987323e-02
#> 74                                   0.000000e+00     0.000000e+00
#> 75                                   0.000000e+00     0.000000e+00
#> 76                                   0.000000e+00     2.356253e-01
#> 77                                   0.000000e+00     0.000000e+00
#> 78                                  -1.973459e-01     1.038861e-01
#> 79                                  -2.188083e-02     6.134252e-03
#> 80                                  -2.655366e-01     7.657230e-02
#> 81                                   0.000000e+00     0.000000e+00
#> 82                                   0.000000e+00     0.000000e+00
#> 83                                  -4.723690e-07     8.506106e-02
#> 84                                  -1.251840e-01     7.261305e-02
#> 85                                  -2.510167e-01     2.215632e-01
#> 86                                   0.000000e+00     0.000000e+00
#> 87                                   0.000000e+00     0.000000e+00
#> 88                                   0.000000e+00     0.000000e+00
#> 89                                  -3.133963e-01     5.378646e-02
#> 90                                   0.000000e+00     9.794078e-02
#> 91                                  -2.395634e-01     1.350337e-01
#> 92                                   0.000000e+00     0.000000e+00
#> 93                                  -3.138263e-01     1.554171e-02
#> 94                                  -9.367481e-02     4.533846e-02
#> 95                                  -4.358611e-06     1.283919e-01
#> 96                                   0.000000e+00     0.000000e+00
#> 97                                  -2.403934e-01     4.947740e-02
#> 98                                  -9.578088e-02     1.735517e-01
#> 99                                  -8.311886e-02     4.148756e-02
#> 100                                  0.000000e+00     0.000000e+00
#> 101                                 -2.678314e-01     1.816655e-01
#> 102                                 -1.390147e-01     2.738358e-02
#> 103                                 -5.943683e-02     1.527174e-01
#> 104                                 -4.986185e-02     2.314105e-02
#> 105                                  0.000000e+00     0.000000e+00
#> 106                                 -2.638583e-01     2.656416e-01
#> 107                                 -1.262399e-01     5.352228e-02
#> 108                                 -2.865557e-01     6.569328e-02
#> 109                                 -1.366860e-01     1.627381e-01
#> 110                                 -5.407255e-02     2.419252e-02
#> 111                                  0.000000e+00     0.000000e+00
#> 112                                  0.000000e+00     0.000000e+00
#> 113                                  0.000000e+00     0.000000e+00
#> 114                                  0.000000e+00     0.000000e+00
#> 115                                 -2.344038e-01     8.606968e-02
#> 116                                 -3.016036e-01     1.485505e-01
#> 117                                  0.000000e+00     0.000000e+00
#> 118                                 -2.362163e-01     1.005577e-01
#> 119                                 -1.295153e-01     4.503779e-02
#> 120                                  0.000000e+00     0.000000e+00
#> 121                                 -5.795717e-02     2.193620e-02
#> 122                                  0.000000e+00     0.000000e+00
#> 123                                  0.000000e+00     0.000000e+00
#> 124                                  0.000000e+00     0.000000e+00
#> 125                                  0.000000e+00     0.000000e+00
#> 126                                  0.000000e+00     0.000000e+00
#> 127                                  0.000000e+00     0.000000e+00
#> 128                                  0.000000e+00     0.000000e+00
#> 129                                 -3.259139e-01     2.296564e-02
#> 130                                 -2.267218e-01     8.579434e-02
#> 131                                 -2.362260e-01     1.982227e-01
#> 132                                  0.000000e+00     0.000000e+00
#> 133                                 -1.840790e-01     8.206446e-02
#> 134                                  6.458534e-07     2.049370e-01
#> 135                                  0.000000e+00     0.000000e+00
#> 136                                 -1.909029e-01     4.875732e-02
#> 137                                  0.000000e+00     0.000000e+00
#> 138                                 -2.495737e-01     1.678369e-01
#> 139                                 -2.622201e-01     6.919141e-02
#> 140                                  0.000000e+00     0.000000e+00
#> 141                                 -9.630322e-02     4.096219e-02
#> 142                                 -1.499823e-01     8.138241e-02
#> 143                                 -4.063065e-02     4.641078e-04
#> 144                                 -2.047595e-01     8.818830e-02
#> 145                                 -2.248667e-01     1.210075e-01
#> 146                                 -3.048286e-01     2.452473e-01
#> 147                                 -1.447196e-01     1.342166e-01
#> 148                                  0.000000e+00     0.000000e+00
#> 149                                 -2.439366e-01     6.305416e-02
#> 150                                 -8.900973e-07     3.312482e-01
#> 151                                 -5.102346e-02     2.238532e-02
#> 152                                 -1.580608e-01     3.528924e-02
#> 153                                  0.000000e+00     0.000000e+00
#> 154                                 -1.002295e-01     3.229267e-07
#> 155                                  0.000000e+00     0.000000e+00
#> 156                                 -1.816310e-01     3.001455e-02
#> 157                                  0.000000e+00     0.000000e+00
#> 158                                 -2.423214e-01     1.664040e-01
#> 159                                 -2.038469e-01     9.065473e-02
#> 160                                 -1.698530e-01     4.897294e-02
#> 161                                 -3.983066e-02     9.734055e-03
#> 162                                  0.000000e+00     0.000000e+00
#> 163                                 -2.645238e-01     9.887072e-02
#> 164                                 -3.085152e-01     5.805149e-02
#> 165                                 -1.490199e-01     5.736058e-02
#> 166                                  0.000000e+00     0.000000e+00
#> 167                                 -1.193485e-01     2.958982e-02
#> 168                                  0.000000e+00     0.000000e+00
#> 169                                 -2.423199e-01     9.597528e-02
#> 170                                 -2.298613e-01     1.730032e-01
#> 171                                 -1.076422e-07     5.155680e-02
#> 172                                  0.000000e+00     0.000000e+00
#> 173                                 -1.226429e-01     4.410057e-02
#> 174                                 -3.127293e-01     4.302094e-02
#> 175                                 -2.590558e-01     1.347542e-01
#> 176                                 -1.368473e-01     2.915321e-02
#> 177                                  7.534956e-07     2.999382e-01
#> 178                                 -1.557906e-01     1.889477e-01
#> 179                                 -1.154301e-01     1.399787e-01
#> 180                                 -1.691796e-01     7.047433e-02
#> 181                                 -7.930233e-06     1.744149e-01
#> 182                                 -3.065938e-01     3.184882e-02
#> 183                                 -2.517393e-01     7.867977e-02
#> 184                                 -1.540205e-01     6.299633e-02
#> 185                                 -1.306184e-01     1.585093e-02
#> 186                                 -2.698827e-01     1.636841e-01
#> 187                                  0.000000e+00     5.635141e-02
#> 188                                 -2.914246e-01     2.135429e-02
#> 189                                  0.000000e+00     0.000000e+00
#> 190                                 -3.115526e-01     9.463884e-02
#> 191                                  0.000000e+00     0.000000e+00
#> 192                                 -8.569488e-02     2.225485e-01
#> 193                                 -1.473021e-01     1.658710e-01
#> 194                                 -1.617137e-01     7.298477e-02
#> 195                                 -3.767478e-07     4.837017e-02
#> 196                                  0.000000e+00     0.000000e+00
#> 197                                  0.000000e+00     0.000000e+00
#> 198                                 -5.400086e-02     4.666529e-02
#> 199                                  0.000000e+00     0.000000e+00
#> 200                                 -2.959374e-01     1.721454e-01
#> 201                                  0.000000e+00     0.000000e+00
#> 202                                 -2.958611e-01     1.044699e-01
#> 203                                  8.611379e-07     7.103867e-03
#> 204                                  0.000000e+00     0.000000e+00
#> 205                                 -1.683272e-01     5.167723e-02
#> 206                                  0.000000e+00     0.000000e+00
#> 207                                  0.000000e+00     0.000000e+00
#> 208                                 -2.907415e-01     8.391670e-02
#> 209                                  0.000000e+00     0.000000e+00
#> 210                                 -3.011037e-01     7.637851e-02
#> 211                                 -3.161139e-01     1.250138e-01
#> 212                                  0.000000e+00     0.000000e+00
#> 213                                 -1.814653e-01     5.106041e-02
#> 214                                 -3.092319e-01     1.217322e-01
#> 215                                 -1.902021e-01     3.488648e-02
#> 216                                  0.000000e+00     0.000000e+00
#> 217                                  0.000000e+00     0.000000e+00
#> 218                                  0.000000e+00     0.000000e+00
#> 219                                  0.000000e+00     0.000000e+00
#> 220                                  0.000000e+00     0.000000e+00
#> 221                                  0.000000e+00     0.000000e+00
#> 222                                  0.000000e+00     0.000000e+00
#> 223                                  0.000000e+00     0.000000e+00
#> 224                                 -9.343722e-02     5.182674e-02
#> 225                                 -1.505393e-01     9.402232e-02
#> 226                                 -1.279887e-01     2.772212e-02
#> 227                                  5.382112e-08     6.419018e-02
#> 228                                  0.000000e+00     0.000000e+00
#> 229                                 -1.727794e-01     7.440341e-03
#> 230                                 -3.232265e-01     1.385194e-01
#> 231                                 -2.677529e-01     2.307736e-01
#> 232                                 -6.439554e-02     2.805305e-02
#> 233                                 -1.318560e-01     7.436313e-02
#> 234                                 -2.066377e-01     9.044287e-02
#> 235                                  0.000000e+00     0.000000e+00
#> 236                                 -9.210533e-02     5.925035e-02
#> 237                                  0.000000e+00     0.000000e+00
#> 238                                  0.000000e+00     0.000000e+00
#> 239                                  0.000000e+00     0.000000e+00
#> 240                                  0.000000e+00     0.000000e+00
#> 241                                  0.000000e+00     0.000000e+00
#> 242                                  0.000000e+00     0.000000e+00
#> 243                                 -2.372808e-01     7.951448e-02
#> 244                                  0.000000e+00     0.000000e+00
#> 245                                  0.000000e+00     0.000000e+00
#> 246                                 -2.733184e-01     5.996313e-02
#> 247                                  0.000000e+00     0.000000e+00
#> 248                                 -3.362510e-02     1.474955e-02
#> 249                                 -2.318561e-01     6.781461e-06
#> 250                                 -3.039864e-01     1.123211e-01
#> 251                                 -2.509021e-01     2.805338e-01
#> 252                                 -1.430491e-01     1.315224e-01
#> 253                                 -2.818328e-01     4.543591e-02
#> 254                                  0.000000e+00     0.000000e+00
#> 255                                  0.000000e+00     0.000000e+00
#> 256                                  0.000000e+00     0.000000e+00
#> 257                                 -2.891742e-06     1.631873e-01
#> 258                                 -1.313409e-01     5.174490e-02
#> 259                                 -2.751887e-01     7.259886e-02
#> 260                                 -2.693127e-01     1.564818e-02
#> 261                                 -1.415520e-01     8.608374e-02
#> 262                                  0.000000e+00     0.000000e+00
#> 263                                 -6.156540e-06     2.505693e-01
#> 264                                 -2.470552e-01     1.128485e-01
#> 265                                 -3.177361e-01     2.266507e-01
#> 266                                  0.000000e+00     0.000000e+00
#> 267                                  0.000000e+00     0.000000e+00
#> 268                                 -3.193193e-01     1.776015e-01
#> 269                                 -3.037430e-01     1.466741e-01
#> 270                                 -2.807075e-01     7.790356e-02
#> 271                                 -2.982367e-01     2.777221e-02
#> 272                                  0.000000e+00     0.000000e+00
#> 273                                  0.000000e+00     0.000000e+00
#> 274                                  0.000000e+00     0.000000e+00
#> 275                                 -7.274591e-02     9.960991e-03
#> 276                                 -5.592255e-02     1.561889e-01
#> 277                                  0.000000e+00     0.000000e+00
#> 278                                 -2.655055e-01     4.513233e-02
#> 279                                  0.000000e+00     0.000000e+00
#> 280                                  0.000000e+00     0.000000e+00
#> 281                                  0.000000e+00     0.000000e+00
#> 282                                 -2.077294e-01     1.160267e-01
#> 283                                  0.000000e+00     0.000000e+00
#> 284                                 -1.557927e-01     6.661824e-02
#> 285                                 -4.305689e-07     2.929467e-02
#> 286                                  0.000000e+00     0.000000e+00
#> 287                                 -7.674859e-02     8.941143e-03
#> 288                                 -2.327632e-01     1.977636e-01
#> 289                                 -9.259548e-02     2.248030e-01
#> 290                                  0.000000e+00     0.000000e+00
#> 291                                  0.000000e+00     0.000000e+00
#> 292                                  0.000000e+00     0.000000e+00
#> 293                                 -7.147004e-02     1.868357e-01
#> 294                                  0.000000e+00     0.000000e+00
#> 295                                  0.000000e+00     0.000000e+00
#> 296                                  0.000000e+00     0.000000e+00
#> 297                                  0.000000e+00     0.000000e+00
#> 298                                 -1.198254e-01     8.278395e-02
#> 299                                  0.000000e+00     0.000000e+00
#> 300                                 -2.693865e-01     4.271895e-02
#> 301                                  0.000000e+00     0.000000e+00
#> 302                                 -2.374994e-01     1.650338e-01
#> 303                                  0.000000e+00     0.000000e+00
#> 304                                 -3.174057e-01     1.185440e-01
#> 305                                  0.000000e+00     0.000000e+00
#> 306                                 -5.213514e-02     3.231368e-02
#> 307                                 -1.671383e-01     4.110326e-02
#> 308                                  0.000000e+00     0.000000e+00
#> 309                                  0.000000e+00     0.000000e+00
#> 310                                 -8.254896e-06     9.009230e-02
#> 311                                  0.000000e+00     0.000000e+00
#> 312                                  0.000000e+00     0.000000e+00
#> 313                                  0.000000e+00     0.000000e+00
#> 314                                  0.000000e+00     0.000000e+00
#> 315                                  0.000000e+00     7.639860e-02
#> 316                                  0.000000e+00     0.000000e+00
#> 317                                  0.000000e+00     0.000000e+00
#> 318                                 -1.924993e-01     4.676641e-02
#> 319                                  2.152845e-07     2.332896e-01
#> 320                                  1.076422e-07     1.494438e-01
#> 321                                 -2.334518e-01     5.620532e-02
#> 322                                 -1.986355e-01     1.118816e-01
#> 323                                 -2.578397e-01     1.548481e-01
#> 324                                 -1.898761e-01     3.778262e-02
#> 325                                 -6.785918e-02     4.665349e-02
#> 326                                  0.000000e+00     0.000000e+00
#> 327                                  0.000000e+00     0.000000e+00
#> 328                                 -2.911471e-01     1.165686e-01
#> 329                                 -2.119608e-01     7.099088e-02
#> 330                                  0.000000e+00     0.000000e+00
#> 331                                 -9.951703e-02     5.217378e-02
#> 332                                  0.000000e+00     9.353463e-02
#> 333                                  1.506991e-06     3.538019e-02
#> 334                                 -1.760834e-01     1.373690e-02
#> 335                                 -2.691313e-01     1.460795e-01
#> 336                                 -1.060253e-02     1.567921e-01
#> 337                                 -3.013183e-01     2.296621e-01
#> 338                                 -1.456562e-01     7.991739e-02
#> 339                                  0.000000e+00     0.000000e+00
#> 340                                  0.000000e+00     0.000000e+00
#> 341                                 -1.655722e-01     5.286329e-02
#> 342                                 -2.167246e-01     8.611379e-07
#> 343                                 -1.909011e-01     4.461661e-02
#> 344                                  1.076422e-07     1.202567e-01
#> 345                                  0.000000e+00     0.000000e+00
#> 346                                  1.076422e-07     1.432230e-01
#> 347                                  0.000000e+00     0.000000e+00
#> 348                                 -1.705788e-01     7.772138e-02
#> 349                                 -2.583342e-01     2.381889e-02
#> 350                                 -3.032884e-01     8.358580e-02
#> 351                                 -7.044837e-02     9.084416e-03
#> 352                                 -5.511990e-02     1.922556e-02
#> 353                                 -1.012163e-01     9.589528e-02
#> 354                                 -2.989066e-01     5.772849e-02
#> 355                                 -2.880581e-01     1.203934e-02
#> 356                                  0.000000e+00     0.000000e+00
#> 357                                  0.000000e+00     3.362422e-01
#> 358                                  0.000000e+00     0.000000e+00
#> 359                                  0.000000e+00     0.000000e+00
#> 360                                 -1.776238e-01     1.079423e-01
#> 361                                 -2.905179e-01     5.842889e-02
#> 362                                  0.000000e+00     0.000000e+00
#> 363                                 -3.374549e-01     1.082361e-01
#> 364                                 -2.835699e-01     3.336909e-06
#> 365                                 -1.965358e-01     1.252126e-01
#> 366                                  2.102387e-10     8.027801e-02
#> 367                                  0.000000e+00     9.837096e-02
#> 368                                  5.382112e-08     1.488716e-01
#> 369                                  0.000000e+00     3.553618e-03
#> 370                                 -2.859117e-01     2.544921e-01
#> 371                                 -1.241090e-01     3.833030e-02
#> 372                                 -2.182626e-01     1.485557e-01
#> 373                                 -1.554825e-01     5.866223e-02
#> 374                                  0.000000e+00     0.000000e+00
#> 375                                  0.000000e+00     0.000000e+00
#> 376                                 -2.306941e-01     7.499136e-02
#> 377                                 -1.885123e-01     8.845093e-02
#> 378                                 -4.652713e-02     1.840641e-02
#> 379                                 -1.987371e-01     1.144725e-01
#> 380                                  0.000000e+00     0.000000e+00
#> 381                                 -2.800714e-01     1.094750e-01
#> 382                                  0.000000e+00     0.000000e+00
#> 383                                 -3.107301e-01     6.053816e-02
#> 384                                  0.000000e+00     0.000000e+00
#> 385                                 -1.599067e-01     1.805806e-02
#> 386                                 -2.345695e-01     2.763720e-02
#> 387                                 -5.903034e-07     5.188683e-02
#> 388                                 -1.865342e-01     1.187761e-01
#> 389                                  0.000000e+00     0.000000e+00
#> 390                                 -2.588639e-01     1.175696e-01
#> 391                                 -1.291707e-06     1.150047e-01
#> 392                                 -7.914941e-02     5.835232e-03
#> 393                                 -2.760355e-01     1.564682e-01
#> 394                                 -5.226528e-06     1.414161e-01
#> 395                                  0.000000e+00     0.000000e+00
#> 396                                 -1.904544e-01     1.198697e-01
#> 397                                  0.000000e+00     0.000000e+00
#> 398                                 -6.769011e-02     3.082474e-02
#> 399                                  0.000000e+00     0.000000e+00
#> 400                                  0.000000e+00     0.000000e+00
#> 401                                 -1.817755e-01     7.820366e-02
#> 402                                  0.000000e+00     0.000000e+00
#> 403                                 -2.673497e-01     2.016589e-01
#> 404                                 -1.917657e-01     9.847256e-02
#> 405                                  0.000000e+00     0.000000e+00
#> 406                                 -3.227524e-01     2.160656e-01
#> 407                                 -1.858944e-01     5.495433e-02
#> 408                                  0.000000e+00     0.000000e+00
#> 409                                 -2.928091e-01     1.106667e-01
#> 410                                 -1.038985e-01     7.358210e-02
#> 411                                 -1.170769e-01     4.388585e-02
#> 412                                 -1.151270e-01     0.000000e+00
#> 413                                  0.000000e+00     0.000000e+00
#> 414                                 -2.083430e-01     4.989769e-02
#> 415                                 -2.382012e-01     7.069684e-02
#> 416                                 -2.488311e-01     6.781461e-06
#> 417                                 -2.147262e-01     1.429033e-01
#> 418                                 -8.345671e-02     1.033130e-02
#> 419                                  0.000000e+00     0.000000e+00
#> 420                                 -5.789721e-02     3.597510e-02
#> 421                                  0.000000e+00     0.000000e+00
#> 422                                  0.000000e+00     0.000000e+00
#> 423                                 -1.550033e-01     3.777654e-02
#> 424                                 -2.890660e-01     9.826681e-02
#> 425                                 -2.587718e-01     2.527367e-01
#> 426                                 -2.030823e-01     6.336027e-02
#> 427                                 -1.065239e-01     1.480921e-02
#> 428                                 -2.828793e-01     1.004186e-01
#> 429                                 -2.183524e-01     6.693338e-02
#> 430                                 -1.123119e-01     1.635463e-01
#> 431                                 -2.639167e-01     1.570725e-02
#> 432                                 -1.272476e-01     7.532678e-02
#> 433                                  0.000000e+00     3.240881e-02
#> 434                                 -5.159229e-02     9.782040e-03
#> 435                                 -2.557463e-01     1.080730e-01
#> 436                                  0.000000e+00     0.000000e+00
#> 437                                  0.000000e+00     0.000000e+00
#> 438                                 -2.900102e-01     1.131423e-01
#> 439                                  0.000000e+00     0.000000e+00
#> 440                                 -1.414412e-01     4.348880e-02
#> 441                                  0.000000e+00     0.000000e+00
#> 442                                 -1.674044e-07     7.113966e-02
#> 443                                  0.000000e+00     0.000000e+00
#> 444                                 -2.427939e-01     1.000398e-01
#> 445                                 -1.445824e-01     8.724898e-02
#> 446                                  0.000000e+00     1.405776e-01
#> 447                                 -1.932173e-06     6.478072e-02
#> 448                                 -5.106077e-06     4.778443e-02
#> 449                                 -1.978312e-01     1.283638e-01
#> 450                                 -1.641663e-01     6.174913e-02
#> 451                                 -2.863501e-01     1.371752e-01
#> 452                                  0.000000e+00     0.000000e+00
#> 453                                  0.000000e+00     0.000000e+00
#> 454                                 -1.722276e-06     6.193757e-02
#> 455                                 -1.994837e-01     3.336909e-06
#> 456                                 -1.858895e-01     2.571327e-02
#> 457                                 -2.822314e-02     7.968572e-03
#> 458                                 -2.310391e-01     1.885972e-01
#> 459                                 -1.828496e-01     2.330159e-01
#> 460                                 -1.744469e-01     1.172973e-01
#> 461                                 -1.599199e-01     1.872418e-01
#> 462                                  0.000000e+00     0.000000e+00
#> 463                                 -1.219025e-01     1.222759e-01
#> 464                                 -1.873323e-01     2.777159e-02
#> 465                                 -2.947130e-01     6.862192e-06
#> 466                                  0.000000e+00     0.000000e+00
#> 467                                  0.000000e+00     0.000000e+00
#> 468                                 -2.563818e-01     1.194322e-01
#> 469                                  0.000000e+00     0.000000e+00
#> 470                                  0.000000e+00     0.000000e+00
#> 471                                 -2.152731e-01     2.590078e-01
#> 472                                 -4.830024e-02     1.843145e-02
#> 473                                 -9.350665e-03     2.304757e-03
#> 474                                  0.000000e+00     0.000000e+00
#> 475                                 -3.038488e-01     1.507699e-01
#> 476                                  0.000000e+00     0.000000e+00
#> 477                                  0.000000e+00     0.000000e+00
#> 478                                 -2.602158e-01     1.963757e-01
#> 479                                  0.000000e+00     0.000000e+00
#> 480                                  0.000000e+00     0.000000e+00
#> 481                                  0.000000e+00     0.000000e+00
#> 482                                  0.000000e+00     0.000000e+00
#> 483                                 -1.894405e-01     2.947008e-01
#> 484                                  0.000000e+00     0.000000e+00
#> 485                                 -4.305689e-07     7.170681e-02
#> 486                                 -2.936246e-01     5.509394e-02
#> 487                                  0.000000e+00     0.000000e+00
#> 488                                 -1.169262e-01     1.138620e-02
#> 489                                  0.000000e+00     0.000000e+00
#> 490                                  0.000000e+00     0.000000e+00
#> 491                                 -2.958314e-01     6.471051e-02
#> 492                                 -2.780809e-01     1.128943e-02
#> 493                                 -2.792562e-01     4.126878e-02
#> 494                                 -2.665335e-01     1.113678e-02
#> 495                                 -5.102323e-02     1.476818e-01
#> 496                                 -3.154805e-07     1.803405e-01
#> 497                                 -2.833197e-01     2.628828e-01
#> 498                                 -2.883549e-01     1.259782e-01
#> 499                                 -2.514630e-01     1.373225e-02
#> 500                                  0.000000e+00     0.000000e+00
#> 501                                  0.000000e+00     0.000000e+00
#> 502                                 -1.304326e-01     2.251823e-02
#> 503                                 -2.542715e-01     1.249004e-01
#> 504                                  0.000000e+00     0.000000e+00
#> 505                                 -2.469034e-01     1.604088e-01
#> 506                                 -2.116115e-01     8.745682e-02
#> 507                                 -2.220341e-01     4.710496e-02
#> 508                                 -2.701403e-01     2.386295e-01
#> 509                                  0.000000e+00     0.000000e+00
#> 510                                  0.000000e+00     0.000000e+00
#> 511                                 -1.979954e-01     4.645708e-02
#> 512                                  0.000000e+00     0.000000e+00
#> 513                                 -1.636702e-01     8.054777e-02
#> 514                                 -3.065909e-01     6.823796e-02
#> 515                                 -1.665411e-01     1.614633e-07
#> 516                                 -2.403014e-01     1.458517e-01
#> 517                                 -1.589334e-01     1.003654e-01
#> 518                                  0.000000e+00     0.000000e+00
#> 519                                 -2.969383e-01     6.333347e-02
#> 520                                 -2.403047e-01     1.197080e-01
#> 521                                 -2.203764e-01     1.897601e-01
#> 522                                  0.000000e+00     0.000000e+00
#> 523                                 -4.244438e-06     4.701881e-02
#> 524                                 -2.226142e-01     1.516459e-01
#> 525                                  0.000000e+00     0.000000e+00
#> 526                                 -2.850019e-01     7.066631e-02
#> 527                                  0.000000e+00     0.000000e+00
#> 528                                  0.000000e+00     0.000000e+00
#> 529                                 -1.870904e-07     6.178177e-02
#> 530                                  0.000000e+00     0.000000e+00
#> 531                                  0.000000e+00     0.000000e+00
#> 532                                  0.000000e+00     0.000000e+00
#> 533                                  0.000000e+00     0.000000e+00
#> 534                                 -2.746660e-06     1.375873e-01
#> 535                                  0.000000e+00     0.000000e+00
#> 536                                  0.000000e+00     0.000000e+00
#> 537                                 -1.669183e-01     8.255082e-02
#> 538                                  0.000000e+00     0.000000e+00
#> 539                                  0.000000e+00     0.000000e+00
#> 540                                 -2.742653e-01     1.126288e-01
#> 541                                 -2.867006e-01     1.651614e-01
#> 542                                 -9.645005e-02     2.382134e-01
#> 543                                  0.000000e+00     0.000000e+00
#> 544                                  0.000000e+00     1.273746e-01
#> 545                                  0.000000e+00     0.000000e+00
#> 546                                 -3.196378e-01     1.903798e-01
#> 547                                  0.000000e+00     0.000000e+00
#> 548                                 -1.103601e-02     7.546052e-02
#> 549                                 -2.260643e-01     1.259858e-01
#> 550                                  0.000000e+00     0.000000e+00
#> 551                                 -3.081361e-01     8.131353e-02
#> 552                                  0.000000e+00     0.000000e+00
#> 553                                 -7.342566e-02     2.320389e-02
#> 554                                  0.000000e+00     0.000000e+00
#> 555                                 -1.186726e-01     4.568419e-02
#> 556                                 -1.151274e-01     1.349375e-02
#> 557                                 -9.597455e-02     1.280892e-02
#> 558                                  0.000000e+00     0.000000e+00
#> 559                                 -2.927742e-01     1.114443e-01
#> 560                                 -2.354503e-01     9.715629e-03
#> 561                                  0.000000e+00     0.000000e+00
#> 562                                 -5.000333e-06     2.303343e-01
#> 563                                 -3.004894e-01     7.014826e-02
#> 564                                 -3.288895e-01     1.397877e-01
#> 565                                  0.000000e+00     0.000000e+00
#> 566                                  0.000000e+00     0.000000e+00
#> 567                                 -1.801214e-02     1.483562e-02
#> 568                                  0.000000e+00     8.868816e-02
#> 569                                 -4.305689e-07     3.298648e-02
#> 570                                 -2.754591e-01     3.571484e-02
#> 571                                 -1.817755e-01     8.492893e-02
#> 572                                 -2.427680e-01     1.168382e-02
#> 573                                  0.000000e+00     0.000000e+00
#> 574                                 -2.637713e-01     9.131365e-02
#> 575                                 -2.297019e-01     7.722749e-02
#> 576                                 -2.647205e-01     8.104319e-02
#> 577                                 -1.895815e-01     9.633532e-02
#> 578                                 -1.973459e-01     1.024884e-01
#> 579                                 -2.248202e-01     2.021509e-01
#> 580                                  0.000000e+00     0.000000e+00
#> 581                                  0.000000e+00     0.000000e+00
#> 582                                  0.000000e+00     0.000000e+00
#> 583                                  0.000000e+00     0.000000e+00
#> 584                                  0.000000e+00     0.000000e+00
#> 585                                 -2.583414e-06     6.704880e-02
#> 586                                  0.000000e+00     0.000000e+00
#> 587                                 -1.518954e-01     2.702430e-02
#> 588                                 -2.933322e-01     3.348714e-02
#> 589                                  0.000000e+00     0.000000e+00
#> 590                                  0.000000e+00     0.000000e+00
#> 591                                  0.000000e+00     0.000000e+00
#> 592                                 -2.682665e-01     6.351484e-02
#> 593                                 -1.420404e-01     4.133336e-02
#> 594                                 -4.777015e-02     2.155009e-02
#> 595                                 -2.778139e-02     5.518027e-03
#> 596                                 -2.422524e-01     1.487413e-01
#> 597                                  1.291707e-06     1.291707e-06
#> 598                                  0.000000e+00     0.000000e+00
#> 599                                 -3.005186e-01     6.782279e-02
#> 600                                 -7.175896e-02     1.023762e-03
#> 601                                 -2.917806e-01     1.360796e-01
#> 602                                 -2.318644e-01     6.633834e-02
#> 603                                  0.000000e+00     3.861923e-02
#> 604                                 -1.253788e-01     5.536786e-02
#> 605                                  0.000000e+00     0.000000e+00
#> 606                                 -2.063922e-01     1.305024e-01
#> 607                                 -2.721248e-01     1.030894e-01
#> 608                                  0.000000e+00     0.000000e+00
#> 609                                 -2.717011e-01     1.816595e-02
#> 610                                 -2.472024e-01     2.187341e-01
#> 611                                 -2.323596e-01     2.369477e-01
#> 612                                  0.000000e+00     0.000000e+00
#> 613                                  0.000000e+00     2.504287e-02
#> 614                                 -2.644104e-01     6.055029e-02
#> 615                                  0.000000e+00     0.000000e+00
#> 616                                  0.000000e+00     0.000000e+00
#> 617                                 -2.573895e-01     1.234103e-01
#> 618                                 -2.347787e-01     7.960607e-02
#> 619                                 -1.618264e-01     1.756236e-01
#> 620                                 -1.194909e-01     4.684486e-03
#> 621                                  0.000000e+00     0.000000e+00
#> 622                                  0.000000e+00     0.000000e+00
#> 623                                  0.000000e+00     0.000000e+00
#> 624                                  0.000000e+00     0.000000e+00
#> 625                                 -3.001704e-01     1.047311e-01
#> 626                                 -1.414571e-01     8.467227e-03
#> 627                                  0.000000e+00     0.000000e+00
#> 628                                 -2.820628e-01     6.046249e-02
#> 629                                 -1.459342e-01     3.325515e-02
#> 630                                  0.000000e+00     0.000000e+00
#> 631                                  0.000000e+00     0.000000e+00
#> 632                                  0.000000e+00     0.000000e+00
#> 633                                  0.000000e+00     0.000000e+00
#> 634                                 -2.811875e-01     1.135907e-01
#> 635                                 -1.530422e-01     6.728229e-02
#> 636                                 -2.811735e-01     1.368498e-01
#> 637                                 -9.005555e-02     2.476287e-02
#> 638                                 -1.107878e-06     2.989643e-01
#> 639                                  0.000000e+00     0.000000e+00
#> 640                                 -3.106957e-01     1.525668e-01
#> 641                                 -2.949900e-01     7.918950e-02
#> 642                                  0.000000e+00     0.000000e+00
#> 643                                 -1.310261e-01     2.464496e-02
#> 644                                 -3.256639e-01     1.065989e-01
#> 645                                 -3.238363e-01     5.454289e-02
#> 646                                  0.000000e+00     0.000000e+00
#> 647                                 -2.873407e-01     6.568923e-02
#> 648                                 -1.775795e-01     5.157004e-02
#> 649                                 -1.902025e-01     5.718654e-02
#> 650                                 -1.371581e-01     3.870586e-02
#> 651                                 -1.973465e-01     9.864025e-02
#> 652                                 -1.821498e-06     3.219866e-01
#> 653                                  0.000000e+00     6.928163e-02
#> 654                                 -1.968664e-01     2.800282e-01
#> 655                                 -3.196369e-01     4.511678e-02
#> 656                                  0.000000e+00     0.000000e+00
#> 657                                  0.000000e+00     0.000000e+00
#> 658                                 -2.292635e-01     1.056542e-01
#> 659                                  8.611379e-07    -2.175523e-06
#> 660                                 -3.174975e-01     7.520749e-02
#> 661                                 -1.700637e-01     8.396073e-02
#> 662                                 -1.228050e-01     1.802160e-02
#> 663                                 -1.798225e-01     1.146472e-01
#> 664                                  0.000000e+00     0.000000e+00
#> 665                                  0.000000e+00     0.000000e+00
#> 666                                 -1.618710e-02     3.746917e-01
#> 667                                 -2.233492e-01     9.799359e-02
#> 668                                  0.000000e+00     0.000000e+00
#> 669                                  0.000000e+00     0.000000e+00
#> 670                                 -2.659235e-01     5.020240e-02
#> 671                                  0.000000e+00     0.000000e+00
#> 672                                 -2.896780e-01     1.749481e-01
#> 673                                 -1.210138e-01     2.876591e-02
#> 674                                  0.000000e+00     0.000000e+00
#> 675                                  0.000000e+00     9.493512e-02
#> 676                                 -8.278157e-02     4.296154e-02
#> 677                                 -1.267749e-01     6.842532e-02
#> 678                                  0.000000e+00     0.000000e+00
#> 679                                 -2.311067e-01     1.277793e-01
#> 680                                 -2.624054e-01     8.081801e-03
#> 681                                 -9.336063e-02     5.926101e-02
#> 682                                 -3.227624e-01     1.221147e-01
#> 683                                 -2.766105e-01     5.787463e-03
#> 684                                 -1.266198e-01     6.583265e-02
#> 685                                 -2.972191e-01     9.353817e-02
#> 686                                  0.000000e+00     0.000000e+00
#> 687                                 -1.771910e-01     2.413563e-01
#> 688                                  0.000000e+00     0.000000e+00
#> 689                                 -1.474416e-01     4.334525e-02
#> 690                                  0.000000e+00     0.000000e+00
#> 691                                 -2.096172e-01     3.388464e-02
#> 692                                 -1.318633e-01     6.673818e-06
#> 693                                 -8.006513e-06     2.025243e-02
#> 694                                  0.000000e+00     0.000000e+00
#> 695                                 -2.596899e-01     4.693437e-02
#> 696                                  0.000000e+00     0.000000e+00
#> 697                                  0.000000e+00     0.000000e+00
#> 698                                 -2.189947e-01     1.020333e-01
#> 699                                 -1.226713e-01     1.115790e-02
#> 700                                 -2.860511e-01     8.677388e-02
#> 701                                  0.000000e+00     0.000000e+00
#> 702                                 -2.877664e-01     1.449581e-01
#> 703                                  2.144435e-07     9.430851e-02
#> 704                                 -2.773482e-01     6.986150e-03
#> 705                                 -7.437904e-06     2.331294e-02
#> 706                                 -3.041979e-01     1.305449e-01
#> 707                                 -1.314249e-01    -1.291707e-06
#> 708                                 -2.378843e-01     1.073052e-01
#> 709                                 -3.106383e-01     1.292834e-01
#> 710                                  0.000000e+00     0.000000e+00
#> 711                                  0.000000e+00     0.000000e+00
#> 712                                 -2.172702e-01     1.425208e-01
#> 713                                  0.000000e+00     0.000000e+00
#> 714                                 -1.074935e-01     1.026670e-01
#> 715                                 -1.090861e-01     1.344090e-02
#> 716                                 -2.422515e-01     1.480694e-02
#> 717                                  0.000000e+00     0.000000e+00
#> 718                                 -1.506106e-01     1.284819e-01
#> 719                                  0.000000e+00     0.000000e+00
#> 720                                 -1.625715e-01     6.508353e-02
#> 721                                  0.000000e+00     0.000000e+00
#> 722                                  0.000000e+00     0.000000e+00
#> 723                                  0.000000e+00     0.000000e+00
#> 724                                 -7.820337e-02     2.044398e-02
#> 725                                  0.000000e+00     0.000000e+00
#> 726                                 -1.755321e-01     8.295481e-02
#> 727                                  0.000000e+00     0.000000e+00
#> 728                                 -1.675410e-01     5.102761e-02
#> 729                                 -2.334623e-01     1.350660e-01
#> 730                                  0.000000e+00     0.000000e+00
#> 731                                 -3.200124e-01     1.333618e-01
#> 732                                 -2.062720e-01     1.199926e-01
#> 733                                 -2.335969e-01     6.356103e-02
#> 734                                 -5.460693e-02     1.150826e-01
#> 735                                  0.000000e+00     0.000000e+00
#> 736                                  0.000000e+00     0.000000e+00
#> 737                                 -2.902553e-01     5.642464e-02
#> 738                                 -1.774410e-06     1.312587e-01
#> 739                                 -8.611379e-07     1.046124e-01
#> 740                                 -1.885116e-01     9.042468e-02
#> 741                                 -2.646369e-01     2.398299e-01
#> 742                                 -2.570984e-01     1.658623e-01
#> 743                                  0.000000e+00     0.000000e+00
#> 744                                  0.000000e+00     0.000000e+00
#> 745                                  0.000000e+00     0.000000e+00
#> 746                                  0.000000e+00     0.000000e+00
#> 747                                  0.000000e+00     0.000000e+00
#> 748                                  0.000000e+00     0.000000e+00
#> 749                                 -3.057688e-01     2.341553e-02
#> 750                                 -7.772262e-02     5.856540e-02
#> 751                                  0.000000e+00     0.000000e+00
#> 752                                  7.859664e-10     3.363347e-02
#> 753                                 -4.305689e-07     1.319726e-01
#> 754                                 -3.196398e-01     1.659396e-01
#> 755                                 -2.928983e-01     1.321479e-01
#> 756                                  0.000000e+00     0.000000e+00
#> 757                                  0.000000e+00     0.000000e+00
#> 758                                 -4.369096e-02     1.057977e-02
#> 759                                 -1.120849e-01     1.272676e-01
#> 760                                  0.000000e+00     0.000000e+00
#> 761                                 -1.354236e-01     5.877903e-02
#> 762                                 -2.826346e-01     3.352216e-02
#> 763                                  0.000000e+00     0.000000e+00
#> 764                                 -2.763201e-01     4.060798e-02
#> 765                                  0.000000e+00     0.000000e+00
#> 766                                 -8.984003e-02     4.624428e-02
#> 767                                  0.000000e+00     0.000000e+00
#> 768                                  1.076422e-07     1.404169e-01
#> 769                                 -1.653265e-01     3.316279e-02
#> 770                                  0.000000e+00     0.000000e+00
#> 771                                  0.000000e+00     0.000000e+00
#> 772                                 -1.108388e-01     4.091676e-02
#> 773                                  0.000000e+00     0.000000e+00
#> 774                                  0.000000e+00     0.000000e+00
#> 775                                 -3.179014e-01     4.960158e-02
#> 776                                 -1.361155e-01     2.013160e-02
#> 777                                  0.000000e+00     0.000000e+00
#> 778                                  0.000000e+00     0.000000e+00
#> 779                                 -1.375987e-01     6.472476e-02
#> 780                                 -1.652079e-01     2.430003e-02
#> 781                                 -1.312295e-01     6.665476e-02
#> 782                                 -2.425016e-01     1.105110e-01
#> 783                                 -3.074928e-01     3.034590e-02
#> 784                                  0.000000e+00     0.000000e+00
#> 785                                  0.000000e+00     0.000000e+00
#> 786                                 -2.874262e-01     1.050687e-01
#> 787                                  0.000000e+00     0.000000e+00
#> 788                                  0.000000e+00     0.000000e+00
#> 789                                  0.000000e+00     0.000000e+00
#> 790                                  0.000000e+00     0.000000e+00
#> 791                                  0.000000e+00     0.000000e+00
#> 792                                  0.000000e+00     0.000000e+00
#> 793                                  0.000000e+00     0.000000e+00
#> 794                                  0.000000e+00     0.000000e+00
#> 795                                 -2.977076e-01     6.835282e-06
#> 796                                  0.000000e+00     0.000000e+00
#> 797                                 -9.909693e-02     8.804752e-02
#> 798                                 -1.795712e-01     1.313705e-01
#> 799                                 -2.312789e-01     8.128469e-02
#> 800                                  0.000000e+00     0.000000e+00
#> 801                                  0.000000e+00     0.000000e+00
#> 802                                 -1.824588e-01     8.487611e-03
#> 803                                  0.000000e+00     0.000000e+00
#> 804                                  0.000000e+00     0.000000e+00
#> 805                                 -2.822034e-01     5.022249e-02
#> 806                                 -6.498443e-02     9.541357e-03
#> 807                                  0.000000e+00     0.000000e+00
#> 808                                  0.000000e+00     0.000000e+00
#> 809                                 -2.162076e-01     3.753822e-02
#> 810                                 -8.611379e-07     1.179664e-01
#> 811                                 -2.971742e-01     7.264110e-02
#> 812                                  0.000000e+00     0.000000e+00
#> 813                                 -3.040566e-01     4.889768e-02
#> 814                                 -3.043390e-01     1.464404e-01
#> 815                                  0.000000e+00     0.000000e+00
#> 816                                 -3.207621e-01     6.071467e-02
#> 817                                 -2.789235e-01     4.722990e-02
#> 818                                  0.000000e+00     0.000000e+00
#> 819                                 -3.633416e-01     1.306165e-01
#> 820                                  0.000000e+00     0.000000e+00
#> 821                                 -2.825702e-01     1.554860e-01
#> 822                                 -1.898871e-01     1.399640e-01
#> 823                                 -1.352640e-01     6.687179e-02
#> 824                                  0.000000e+00     0.000000e+00
#> 825                                 -2.942715e-01     1.201427e-01
#> 826                                 -1.466481e-06     2.735053e-01
#> 827                                 -2.261628e-01     1.210183e-01
#> 828                                 -2.298189e-01     8.911040e-02
#> 829                                 -2.665875e-01     1.167545e-01
#> 830                                 -2.448326e-01     9.909681e-02
#> 831                                 -2.961708e-01     9.585396e-02
#> 832                                 -3.105393e-01     1.374458e-01
#> 833                                 -2.733352e-01     1.218908e-01
#> 834                                  0.000000e+00     0.000000e+00
#> 835                                  0.000000e+00     9.408603e-02
#> 836                                  0.000000e+00     0.000000e+00
#> 837                                  0.000000e+00     0.000000e+00
#> 838                                  0.000000e+00     0.000000e+00
#> 839                                 -2.787931e-01     1.203243e-01
#> 840                                 -3.056067e-01     1.707530e-01
#> 841                                  0.000000e+00     0.000000e+00
#> 842                                 -9.894071e-02     4.713311e-02
#> 843                                  2.152845e-07     1.244730e-01
#> 844                                  0.000000e+00     0.000000e+00
#> 845                                 -9.412300e-02     4.568419e-02
#> 846                                  0.000000e+00     0.000000e+00
#> 847                                 -2.465474e-01     7.470279e-02
#> 848                                  0.000000e+00     0.000000e+00
#> 849                                  0.000000e+00     0.000000e+00
#> 850                                  0.000000e+00     0.000000e+00
#> 851                                  0.000000e+00     0.000000e+00
#> 852                                 -2.701425e-01     1.482290e-02
#> 853                                 -2.583414e-06     1.372493e-01
#> 854                                  1.637825e-06     3.753955e-02
#> 855                                 -2.494524e-01     9.917933e-02
#> 856                                 -2.233176e-01     7.975388e-02
#> 857                                  0.000000e+00     0.000000e+00
#> 858                                 -1.511289e-01     5.634876e-02
#> 859                                 -2.661047e-01     1.024577e-01
#> 860                                 -1.684452e-01     6.447096e-02
#> 861                                 -3.123991e-01     2.075301e-01
#> 862                                 -8.611379e-07     1.769828e-01
#> 863                                  2.152845e-07     3.027777e-01
#> 864                                  0.000000e+00     0.000000e+00
#> 865                                 -1.377697e-01     2.933783e-02
#> 866                                 -1.570896e-01     4.336530e-02
#> 867                                  0.000000e+00     0.000000e+00
#> 868                                 -2.465477e-01     8.681865e-02
#> 869                                  0.000000e+00     0.000000e+00
#> 870                                  0.000000e+00     0.000000e+00
#> 871                                  0.000000e+00     0.000000e+00
#> 872                                  0.000000e+00     0.000000e+00
#> 873                                 -1.754373e-01     7.192134e-02
#> 874                                 -1.448262e-01     1.433288e-02
#> 875                                 -2.768143e-01     2.614374e-01
#> 876                                 -3.258472e-01     1.868798e-01
#> 877                                  0.000000e+00     0.000000e+00
#> 878                                 -2.871775e-01     8.944918e-02
#> 879                                  0.000000e+00     0.000000e+00
#> 880                                 -1.302855e-01     1.023659e-02
#> 881                                  0.000000e+00     0.000000e+00
#> 882                                 -3.116012e-01     1.952696e-01
#> 883                                  3.229267e-07     1.575760e-01
#> 884                                  0.000000e+00     0.000000e+00
#> 885                                  0.000000e+00     0.000000e+00
#> 886                                 -1.266167e-01     5.717258e-02
#> 887                                 -2.245617e-01     9.373368e-02
#> 888                                  0.000000e+00     0.000000e+00
#> 889                                 -3.095935e-01     9.756666e-02
#> 890                                 -1.451984e-01     4.295021e-02
#> 891                                  0.000000e+00     0.000000e+00
#> 892                                 -2.370796e-01     3.163244e-01
#> 893                                 -3.315575e-01     2.577643e-01
#> 894                                 -1.099607e-01     4.390577e-02
#> 895                                 -2.814969e-01     1.646680e-01
#> 896                                 -1.894552e-01     2.289313e-02
#> 897                                  0.000000e+00     0.000000e+00
#> 898                                  0.000000e+00     0.000000e+00
#> 899                                 -3.003627e-01     1.244677e-01
#> 900                                  0.000000e+00     0.000000e+00
#> 901                                  0.000000e+00     0.000000e+00
#> 902                                  0.000000e+00     0.000000e+00
#> 903                                 -2.940307e-01     6.538510e-02
#> 904                                 -1.443157e-01     3.133730e-02
#> 905                                  6.458534e-07     1.241551e-01
#> 906                                  0.000000e+00     0.000000e+00
#> 907                                  0.000000e+00     0.000000e+00
#> 908                                 -1.990134e-01     8.462309e-02
#> 909                                  0.000000e+00     0.000000e+00
#> 910                                  0.000000e+00     0.000000e+00
#> 911                                  0.000000e+00     0.000000e+00
#> 912                                  0.000000e+00     0.000000e+00
#> 913                                 -1.056115e-01    -8.611379e-07
#> 914                                 -1.698101e-01     6.713610e-03
#> 915                                 -2.208634e-01     9.183428e-02
#> 916                                 -3.148690e-01     1.648137e-01
#> 917                                 -2.087380e-01     4.174242e-02
#> 918                                  0.000000e+00     0.000000e+00
#> 919                                  0.000000e+00     0.000000e+00
#> 920                                 -2.177145e-01     1.494480e-01
#> 921                                 -2.858748e-01     2.081463e-01
#> 922                                  0.000000e+00     0.000000e+00
#> 923                                 -1.360667e-01     4.367765e-03
#> 924                                 -2.087769e-01     6.281309e-02
#> 925                                  0.000000e+00     0.000000e+00
#> 926                                 -2.844172e-01     9.192407e-02
#> 927                                  0.000000e+00     0.000000e+00
#> 928                                  0.000000e+00     0.000000e+00
#> 929                                 -3.345922e-07     2.594809e-01
#> 930                                 -2.859640e-01     7.703817e-02
#> 931                                 -2.791456e-01     2.918933e-01
#> 932                                 -2.469812e-01     1.742067e-02
#> 933                                 -2.991351e-01     8.809394e-02
#> 934                                 -7.649020e-07     1.328247e-01
#> 935                                 -3.005279e-01     1.983461e-01
#> 936                                 -2.717651e-01     3.336909e-06
#> 937                                 -1.255363e-01     4.926207e-02
#> 938                                 -7.673093e-02     4.701535e-02
#> 939                                 -2.686862e-01     5.505997e-02
#> 940                                  0.000000e+00     0.000000e+00
#> 941                                  0.000000e+00     0.000000e+00
#> 942                                 -2.138094e-01     2.846441e-01
#> 943                                 -8.395082e-02     2.964873e-02
#> 944                                 -7.438645e-02     1.901515e-01
#> 945                                  0.000000e+00     0.000000e+00
#> 946                                 -1.864028e-01     1.876844e-02
#> 947                                  0.000000e+00     0.000000e+00
#> 948                                  0.000000e+00     0.000000e+00
#> 949                                 -2.841496e-01     5.947810e-02
#> 950                                 -2.342793e-01     4.725077e-02
#> 951                                  0.000000e+00     9.316054e-02
#> 952                                  0.000000e+00     7.872640e-02
#> 953                                 -2.577165e-01     1.547822e-01
#> 954                                  0.000000e+00     0.000000e+00
#> 955                                 -3.063711e-01     9.233226e-03
#> 956                                  0.000000e+00     0.000000e+00
#> 957                                  0.000000e+00     0.000000e+00
#> 958                                 -2.813833e-01     5.803505e-02
#> 959                                  3.229267e-07     1.951225e-01
#> 960                                  0.000000e+00     0.000000e+00
#> 961                                  1.076422e-07     1.125794e-01
#> 962                                  0.000000e+00     0.000000e+00
#> 963                                  0.000000e+00     0.000000e+00
#> 964                                 -1.839466e-01     3.548992e-02
#> 965                                 -1.142187e-01     1.457840e-02
#> 966                                 -2.449605e-01     9.744879e-02
#> 967                                  0.000000e+00     0.000000e+00
#> 968                                  0.000000e+00     0.000000e+00
#> 969                                  0.000000e+00     0.000000e+00
#> 970                                 -1.384366e-01     6.731583e-02
#> 971                                 -2.575379e-01     9.026070e-02
#> 972                                 -2.403793e-01     6.508942e-02
#> 973                                 -1.111299e-01     5.111819e-02
#> 974                                 -2.452274e-01     1.403169e-02
#> 975                                 -2.703649e-01     2.400866e-02
#> 976                                  0.000000e+00     0.000000e+00
#> 977                                 -2.998708e-01     2.253776e-01
#> 978                                  0.000000e+00     0.000000e+00
#> 979                                 -1.317126e-01     1.187932e-02
#> 980                                 -6.039861e-02     2.328518e-02
#> 981                                 -1.285599e-01     4.215443e-02
#> 982                                  1.613827e-07     9.431754e-02
#> 983                                 -1.540211e-01     6.422522e-02
#> 984                                 -1.812782e-01     7.425750e-02
#> 985                                 -2.310807e-01     1.534684e-02
#> 986                                 -1.710918e-01     1.129093e-01
#> 987                                 -2.153413e-01     1.445218e-01
#> 988                                  0.000000e+00     0.000000e+00
#> 989                                 -2.592051e-01     6.678328e-02
#> 990                                 -2.457562e-01     7.815376e-02
#> 991                                 -2.765996e-01     2.048813e-01
#> 992                                 -1.893597e-01     6.265322e-02
#> 993                                  0.000000e+00     0.000000e+00
#> 994                                 -2.144170e-01     1.534453e-01
#> 995                                 -3.237283e-01     1.373124e-01
#> 996                                  1.076422e-07     1.468525e-01
#> 997                                  0.000000e+00     0.000000e+00
#> 998                                  3.767478e-07     2.088346e-01
#> 999                                  0.000000e+00     0.000000e+00
#> 1000                                 0.000000e+00     0.000000e+00
#>      Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                  0.000000e+00                  0.000000e+00
#> 2                                  6.781461e-06                 -3.033495e-01
#> 3                                  2.018292e-07                 -1.778386e-01
#> 4                                  6.875648e-06                 -2.466158e-01
#> 5                                 -6.458534e-07                 -4.288439e-02
#> 6                                  4.305689e-07                 -1.088746e-01
#> 7                                 -7.534956e-07                 -6.012100e-02
#> 8                                  1.668455e-06                 -2.012278e-01
#> 9                                  1.291707e-06                 -8.859761e-02
#> 10                                 8.073167e-08                 -9.168217e-02
#> 11                                 2.018292e-07                 -2.002912e-01
#> 12                                 6.458534e-07                 -2.402191e-01
#> 13                                 0.000000e+00                  0.000000e+00
#> 14                                 4.036584e-07                 -1.556360e-01
#> 15                                 1.883739e-07                 -1.169424e-01
#> 16                                 0.000000e+00                  0.000000e+00
#> 17                                 0.000000e+00                 -7.915649e-02
#> 18                                 0.000000e+00                  0.000000e+00
#> 19                                 4.171136e-07                 -1.761276e-01
#> 20                                 1.614633e-07                 -7.920141e-02
#> 21                                 1.883739e-07                 -1.831287e-01
#> 22                                 4.171136e-07                 -2.284336e-01
#> 23                                 0.000000e+00                  0.000000e+00
#> 24                                 0.000000e+00                  0.000000e+00
#> 25                                 1.668455e-06                 -1.847278e-01
#> 26                                 4.709348e-08                 -1.483675e-01
#> 27                                 0.000000e+00                  0.000000e+00
#> 28                                 6.875648e-06                 -3.410878e-01
#> 29                                 3.229267e-07                 -1.740487e-01
#> 30                                 5.045730e-09                 -2.244806e-01
#> 31                                 0.000000e+00                 -1.257795e-03
#> 32                                -2.583414e-06                 -2.019398e-01
#> 33                                 0.000000e+00                  0.000000e+00
#> 34                                 1.695365e-06                 -2.124517e-01
#> 35                                 0.000000e+00                  0.000000e+00
#> 36                                 3.767478e-07                 -1.650847e-01
#> 37                                 1.715548e-06                 -1.681689e-01
#> 38                                -7.534956e-07                 -8.119084e-02
#> 39                                -4.305689e-07                 -2.072217e-01
#> 40                                -8.611379e-07                 -2.578959e-02
#> 41                                 1.708820e-06                 -2.235976e-01
#> 42                                 4.036584e-08                 -1.558993e-01
#> 43                                -3.767478e-07                 -1.069850e-01
#> 44                                -8.073167e-08                 -6.256130e-02
#> 45                                 3.431096e-06                 -2.206139e-01
#> 46                                -1.076422e-07                 -2.942815e-02
#> 47                                 6.781461e-06                 -3.271491e-01
#> 48                                 3.417641e-06                 -3.588406e-01
#> 49                                 0.000000e+00                  0.000000e+00
#> 50                                 6.727639e-09                 -5.538894e-02
#> 51                                 0.000000e+00                  0.000000e+00
#> 52                                 0.000000e+00                 -1.079960e-01
#> 53                                 0.000000e+00                  0.000000e+00
#> 54                                 4.036584e-07                 -1.791923e-01
#> 55                                 8.073167e-08                 -7.182729e-02
#> 56                                 0.000000e+00                  0.000000e+00
#> 57                                 0.000000e+00                 -1.076969e-01
#> 58                                 3.431096e-06                 -2.642104e-01
#> 59                                 3.013983e-06                 -2.170277e-01
#> 60                                 1.708820e-06                 -3.378055e-01
#> 61                                 3.767478e-07                 -5.348901e-02
#> 62                                 1.883739e-07                 -7.427280e-02
#> 63                                 1.614633e-07                 -1.179886e-01
#> 64                                 0.000000e+00                  0.000000e+00
#> 65                                 0.000000e+00                  0.000000e+00
#> 66                                 0.000000e+00                  0.000000e+00
#> 67                                 1.076422e-07                 -7.147109e-02
#> 68                                 2.691056e-08                 -4.309622e-02
#> 69                                 0.000000e+00                  0.000000e+00
#> 70                                 8.476826e-07                 -9.874366e-02
#> 71                                 0.000000e+00                  0.000000e+00
#> 72                                 0.000000e+00                  0.000000e+00
#> 73                                -4.305689e-07                 -2.506617e-01
#> 74                                 0.000000e+00                  0.000000e+00
#> 75                                 0.000000e+00                  0.000000e+00
#> 76                                 0.000000e+00                  0.000000e+00
#> 77                                 0.000000e+00                  0.000000e+00
#> 78                                 1.883739e-07                 -1.530765e-01
#> 79                                 0.000000e+00                 -8.589433e-03
#> 80                                 1.614633e-07                 -1.245089e-01
#> 81                                 0.000000e+00                  0.000000e+00
#> 82                                 0.000000e+00                  0.000000e+00
#> 83                                 5.382112e-08                 -1.631232e-01
#> 84                                -3.767478e-07                 -9.016255e-02
#> 85                                 3.437824e-06                 -2.792126e-01
#> 86                                 0.000000e+00                  0.000000e+00
#> 87                                 0.000000e+00                  0.000000e+00
#> 88                                 0.000000e+00                  0.000000e+00
#> 89                                 1.614633e-07                 -7.549641e-02
#> 90                                 0.000000e+00                 -1.236513e-01
#> 91                                 3.417641e-06                 -2.986648e-01
#> 92                                 0.000000e+00                  0.000000e+00
#> 93                                 1.614633e-06                 -4.326396e-02
#> 94                                -7.534956e-07                 -8.230632e-02
#> 95                                 8.342273e-07                 -1.956394e-01
#> 96                                 0.000000e+00                  0.000000e+00
#> 97                                 3.417641e-06                 -6.518530e-02
#> 98                                 3.229267e-07                 -2.548818e-01
#> 99                                 4.036584e-08                 -6.770853e-02
#> 100                                0.000000e+00                  0.000000e+00
#> 101                                1.708820e-06                 -2.972276e-01
#> 102                               -7.534956e-07                 -9.459673e-02
#> 103                               -1.007140e-01                 -2.119990e-01
#> 104                               -8.073167e-07                 -3.973810e-02
#> 105                                0.000000e+00                  0.000000e+00
#> 106                                3.229267e-06                 -1.209401e-01
#> 107                               -7.534956e-07                 -6.747280e-02
#> 108                                6.835282e-06                 -3.713337e-01
#> 109                                6.835282e-06                 -2.255673e-01
#> 110                                3.229267e-07                 -2.737808e-02
#> 111                                0.000000e+00                  0.000000e+00
#> 112                                0.000000e+00                  0.000000e+00
#> 113                                0.000000e+00                  0.000000e+00
#> 114                                0.000000e+00                  0.000000e+00
#> 115                                9.418695e-08                 -1.342443e-01
#> 116                                4.171136e-07                 -2.186801e-01
#> 117                                0.000000e+00                  0.000000e+00
#> 118                                2.085568e-07                 -1.202946e-01
#> 119                                1.076422e-07                 -5.882080e-02
#> 120                                0.000000e+00                  0.000000e+00
#> 121                               -5.382112e-08                 -3.410936e-02
#> 122                                0.000000e+00                  0.000000e+00
#> 123                                0.000000e+00                  0.000000e+00
#> 124                                0.000000e+00                  0.000000e+00
#> 125                                0.000000e+00                  0.000000e+00
#> 126                                0.000000e+00                  0.000000e+00
#> 127                                0.000000e+00                  0.000000e+00
#> 128                                0.000000e+00                  0.000000e+00
#> 129                                2.152845e-07                 -6.594792e-02
#> 130                                8.342273e-07                 -1.508240e-01
#> 131                                1.708820e-06                 -3.293813e-01
#> 132                                0.000000e+00                  0.000000e+00
#> 133                                1.614633e-07                 -1.673445e-01
#> 134                                6.458534e-07                 -2.628379e-01
#> 135                                0.000000e+00                  0.000000e+00
#> 136                                1.076422e-07                 -1.475990e-01
#> 137                                0.000000e+00                  0.000000e+00
#> 138                                1.708820e-06                 -2.597891e-01
#> 139                                1.708820e-06                 -1.056943e-01
#> 140                                0.000000e+00                  0.000000e+00
#> 141                                1.291707e-06                 -2.664757e-01
#> 142                                0.000000e+00                 -8.952008e-02
#> 143                                0.000000e+00                 -1.268310e-03
#> 144                                8.476826e-07                 -1.427458e-01
#> 145                                1.009146e-07                 -1.656055e-01
#> 146                                6.882375e-06                 -3.597160e-01
#> 147                                1.614633e-07                 -1.774714e-01
#> 148                                0.000000e+00                  0.000000e+00
#> 149                                7.534956e-07                 -2.057873e-01
#> 150                                1.614633e-07                 -6.044586e-06
#> 151                                5.382112e-08                 -3.146820e-02
#> 152                               -1.614633e-06                 -3.817617e-02
#> 153                                0.000000e+00                  0.000000e+00
#> 154                                3.229267e-07                 -5.709208e-02
#> 155                                0.000000e+00                  0.000000e+00
#> 156                                2.152845e-07                 -1.515864e-01
#> 157                                0.000000e+00                  0.000000e+00
#> 158                                3.417641e-06                 -3.259501e-01
#> 159                                2.018292e-07                 -1.432096e-01
#> 160                               -3.570216e-02                 -1.087483e-01
#> 161                                0.000000e+00                 -2.370396e-02
#> 162                                0.000000e+00                  0.000000e+00
#> 163                                1.883739e-07                 -1.443636e-01
#> 164                                1.614633e-07                 -7.905510e-02
#> 165                               -1.076422e-07                 -9.484275e-02
#> 166                                0.000000e+00                  0.000000e+00
#> 167                               -2.152845e-07                 -8.392672e-02
#> 168                                0.000000e+00                  0.000000e+00
#> 169                                1.883739e-07                 -1.342494e-01
#> 170                                4.171136e-07                 -1.993718e-01
#> 171                               -1.076422e-07                 -7.723739e-02
#> 172                                0.000000e+00                  0.000000e+00
#> 173                               -3.229267e-07                 -8.700248e-02
#> 174                                1.076422e-07                 -4.835568e-02
#> 175                                1.883739e-07                 -1.605433e-01
#> 176                                7.534956e-07                 -9.298050e-02
#> 177                                7.534956e-07                  6.681033e-06
#> 178                                6.835282e-06                 -3.117840e-01
#> 179                                2.144435e-07                 -2.701087e-01
#> 180                               -3.229267e-07                 -1.094887e-01
#> 181                                3.390730e-06                 -2.892830e-01
#> 182                                3.417641e-06                 -2.410797e-01
#> 183                                1.614633e-07                 -1.293673e-01
#> 184                               -2.018292e-07                 -9.948670e-02
#> 185                               -8.342273e-07                 -5.296382e-02
#> 186                                8.544102e-07                 -2.028221e-01
#> 187                                0.000000e+00                 -7.419452e-02
#> 188                                3.390730e-06                 -1.534113e-01
#> 189                                0.000000e+00                  0.000000e+00
#> 190                               -1.454414e-02                 -1.467372e-01
#> 191                                0.000000e+00                  0.000000e+00
#> 192                                3.390730e-06                 -2.843500e-01
#> 193                                8.073167e-07                 -2.719114e-01
#> 194                                4.709348e-08                 -7.774495e-02
#> 195                               -3.767478e-07                 -8.893870e-02
#> 196                                0.000000e+00                  0.000000e+00
#> 197                                0.000000e+00                  0.000000e+00
#> 198                               -8.073167e-08                 -4.819164e-02
#> 199                                0.000000e+00                  0.000000e+00
#> 200                                8.544102e-07                 -2.229484e-01
#> 201                                0.000000e+00                  0.000000e+00
#> 202                                3.437824e-06                 -2.251037e-01
#> 203                                8.611379e-07                 -2.095341e-01
#> 204                                0.000000e+00                  0.000000e+00
#> 205                               -1.076422e-07                 -8.711033e-02
#> 206                                0.000000e+00                  0.000000e+00
#> 207                                0.000000e+00                  0.000000e+00
#> 208                                8.342273e-07                 -2.642865e-01
#> 209                                0.000000e+00                  0.000000e+00
#> 210                                8.476826e-07                 -1.379008e-01
#> 211                                1.668455e-06                 -2.662807e-01
#> 212                                0.000000e+00                  0.000000e+00
#> 213                                1.076422e-07                 -1.048244e-01
#> 214                                2.018292e-07                 -1.705507e-01
#> 215                               -6.104269e-02                 -1.869501e-01
#> 216                                0.000000e+00                  0.000000e+00
#> 217                                0.000000e+00                  0.000000e+00
#> 218                                0.000000e+00                  0.000000e+00
#> 219                                0.000000e+00                  0.000000e+00
#> 220                                0.000000e+00                  0.000000e+00
#> 221                                0.000000e+00                  0.000000e+00
#> 222                                0.000000e+00                  0.000000e+00
#> 223                                0.000000e+00                  0.000000e+00
#> 224                                8.342273e-07                 -6.998794e-02
#> 225                                0.000000e+00                 -1.416296e-01
#> 226                                2.691056e-08                 -8.889289e-02
#> 227                                5.382112e-08                 -1.069253e-01
#> 228                                0.000000e+00                  0.000000e+00
#> 229                                3.013983e-06                 -8.110416e-02
#> 230                                8.577740e-07                 -2.113083e-01
#> 231                                6.885739e-06                 -3.770670e-01
#> 232                               -1.076422e-07                 -5.712268e-02
#> 233                               -1.076422e-07                 -1.062536e-01
#> 234                                1.614633e-07                 -1.590773e-01
#> 235                                0.000000e+00                  0.000000e+00
#> 236                               -3.767478e-07                 -7.096916e-02
#> 237                                0.000000e+00                  0.000000e+00
#> 238                                0.000000e+00                  0.000000e+00
#> 239                                0.000000e+00                  0.000000e+00
#> 240                                0.000000e+00                  0.000000e+00
#> 241                                0.000000e+00                  0.000000e+00
#> 242                                0.000000e+00                  0.000000e+00
#> 243                                1.614633e-07                 -1.417982e-01
#> 244                                0.000000e+00                  0.000000e+00
#> 245                                0.000000e+00                  0.000000e+00
#> 246                                1.708820e-06                 -1.740731e-01
#> 247                                0.000000e+00                  0.000000e+00
#> 248                                0.000000e+00                 -1.942218e-02
#> 249                                6.781461e-06                 -3.381093e-01
#> 250                                3.767478e-07                 -1.574270e-01
#> 251                                1.695365e-06                 -1.394219e-01
#> 252                               -6.000529e-02                 -1.723248e-01
#> 253                                1.076422e-07                 -7.669939e-02
#> 254                                0.000000e+00                  0.000000e+00
#> 255                                0.000000e+00                  0.000000e+00
#> 256                                0.000000e+00                  0.000000e+00
#> 257                                8.073167e-07                 -2.490263e-01
#> 258                               -7.534956e-07                 -7.058340e-02
#> 259                                1.695365e-06                 -1.820046e-01
#> 260                                1.614633e-06                 -1.746694e-01
#> 261                                2.018292e-08                 -1.307056e-01
#> 262                                0.000000e+00                  0.000000e+00
#> 263                                4.238413e-07                 -3.213276e-01
#> 264                                1.668455e-06                 -3.145568e-01
#> 265                                6.882375e-06                 -3.126655e-01
#> 266                                0.000000e+00                  0.000000e+00
#> 267                                0.000000e+00                  0.000000e+00
#> 268                                1.715548e-06                 -2.531205e-01
#> 269                                1.722065e-06                 -2.834067e-01
#> 270                                4.036584e-07                 -1.521649e-01
#> 271                                1.668455e-06                 -2.041167e-01
#> 272                                0.000000e+00                  0.000000e+00
#> 273                                0.000000e+00                  0.000000e+00
#> 274                                0.000000e+00                  0.000000e+00
#> 275                                4.036584e-07                 -6.282974e-02
#> 276                                1.009146e-07                 -2.010889e-01
#> 277                                0.000000e+00                  0.000000e+00
#> 278                                1.708820e-06                 -1.802785e-01
#> 279                                0.000000e+00                  0.000000e+00
#> 280                                0.000000e+00                  0.000000e+00
#> 281                                0.000000e+00                  0.000000e+00
#> 282                                8.073167e-08                 -1.555664e-01
#> 283                                0.000000e+00                  0.000000e+00
#> 284                                0.000000e+00                 -9.059806e-02
#> 285                               -4.305689e-07                 -1.454901e-01
#> 286                                0.000000e+00                  0.000000e+00
#> 287                               -4.305689e-07                 -4.921775e-02
#> 288                                1.708820e-06                 -2.845607e-01
#> 289                                7.534956e-07                 -2.860076e-01
#> 290                                0.000000e+00                  0.000000e+00
#> 291                                0.000000e+00                  0.000000e+00
#> 292                                0.000000e+00                  0.000000e+00
#> 293                                0.000000e+00                 -2.498031e-01
#> 294                                0.000000e+00                  0.000000e+00
#> 295                                0.000000e+00                  0.000000e+00
#> 296                                0.000000e+00                  0.000000e+00
#> 297                                0.000000e+00                  0.000000e+00
#> 298                               -1.614633e-07                 -1.082468e-01
#> 299                                0.000000e+00                  0.000000e+00
#> 300                                1.076422e-07                 -4.717496e-02
#> 301                                0.000000e+00                  0.000000e+00
#> 302                                8.342273e-07                 -1.992970e-01
#> 303                                0.000000e+00                  0.000000e+00
#> 304                                4.171136e-07                 -1.649261e-01
#> 305                                0.000000e+00                  0.000000e+00
#> 306                               -1.614633e-07                 -3.847819e-02
#> 307                                5.382112e-08                 -9.834403e-02
#> 308                                0.000000e+00                  0.000000e+00
#> 309                                0.000000e+00                  0.000000e+00
#> 310                                1.614633e-06                 -2.324692e-01
#> 311                                0.000000e+00                  0.000000e+00
#> 312                                0.000000e+00                  0.000000e+00
#> 313                                0.000000e+00                  0.000000e+00
#> 314                                0.000000e+00                  0.000000e+00
#> 315                                0.000000e+00                 -2.428211e-01
#> 316                                0.000000e+00                  0.000000e+00
#> 317                                0.000000e+00                  0.000000e+00
#> 318                                8.073167e-07                 -8.817399e-02
#> 319                                2.152845e-07                  2.107489e-06
#> 320                                1.076422e-07                 -1.779502e-01
#> 321                                1.076422e-07                 -1.042512e-01
#> 322                                5.382112e-08                 -1.397424e-01
#> 323                               -8.664642e-02                 -1.879892e-01
#> 324                               -8.611379e-07                 -1.557032e-01
#> 325                               -1.614633e-07                 -5.860215e-02
#> 326                                0.000000e+00                  0.000000e+00
#> 327                                0.000000e+00                  0.000000e+00
#> 328                                8.476826e-07                 -2.014774e-01
#> 329                                1.708820e-06                 -1.295452e-01
#> 330                                0.000000e+00                  0.000000e+00
#> 331                               -8.073167e-07                 -8.024849e-02
#> 332                                0.000000e+00                 -1.537729e-01
#> 333                                1.506991e-06                 -2.192505e-01
#> 334                                6.458534e-07                 -1.816513e-02
#> 335                                4.171136e-07                 -2.026335e-01
#> 336                                7.534956e-07                 -2.789209e-01
#> 337                                3.437824e-06                 -3.127956e-01
#> 338                                0.000000e+00                 -1.027414e-01
#> 339                                0.000000e+00                  0.000000e+00
#> 340                                0.000000e+00                  0.000000e+00
#> 341                                1.076422e-07                 -1.180346e-01
#> 342                                8.611379e-07                 -2.938149e-02
#> 343                                3.390730e-06                 -6.698579e-02
#> 344                                1.076422e-07                 -1.686262e-01
#> 345                                0.000000e+00                  0.000000e+00
#> 346                                1.076422e-07                 -1.822686e-01
#> 347                                0.000000e+00                  0.000000e+00
#> 348                                3.229267e-07                 -2.704713e-01
#> 349                                7.534956e-07                 -3.400096e-02
#> 350                                4.036584e-07                 -2.120173e-01
#> 351                                0.000000e+00                 -5.625775e-02
#> 352                                6.027965e-06                 -2.437333e-01
#> 353                                0.000000e+00                 -3.131715e-01
#> 354                                8.073167e-07                 -1.605471e-01
#> 355                                6.781461e-06                 -3.550654e-01
#> 356                                0.000000e+00                  0.000000e+00
#> 357                               -2.310336e-02                 -1.259916e-01
#> 358                                0.000000e+00                  0.000000e+00
#> 359                                0.000000e+00                  0.000000e+00
#> 360                                8.476826e-07                 -2.133978e-01
#> 361                                3.767478e-07                 -1.068173e-01
#> 362                                0.000000e+00                  0.000000e+00
#> 363                                8.476826e-07                 -1.484804e-01
#> 364                                3.336909e-06                 -1.688799e-01
#> 365                                1.883739e-07                 -1.580840e-01
#> 366                                2.102387e-10                 -1.139640e-01
#> 367                                0.000000e+00                 -1.363817e-01
#> 368                                5.382112e-08                 -1.754812e-01
#> 369                                0.000000e+00                 -4.967104e-02
#> 370                                6.875648e-06                 -3.114503e-01
#> 371                               -7.534956e-07                 -4.467515e-02
#> 372                                4.238413e-07                 -1.845064e-01
#> 373                               -1.076422e-07                 -8.036855e-02
#> 374                                0.000000e+00                  0.000000e+00
#> 375                                0.000000e+00                  0.000000e+00
#> 376                                2.152779e-07                 -1.475753e-01
#> 377                               -3.584990e-02                 -1.343553e-01
#> 378                               -1.076422e-07                 -2.908797e-02
#> 379                                1.883739e-07                 -1.596472e-01
#> 380                                0.000000e+00                  0.000000e+00
#> 381                               -9.316055e-02                 -2.631137e-01
#> 382                                0.000000e+00                  0.000000e+00
#> 383                                4.171136e-07                 -1.136121e-01
#> 384                                0.000000e+00                  0.000000e+00
#> 385                                2.152845e-07                 -1.135896e-01
#> 386                                8.073167e-07                 -1.741319e-01
#> 387                                1.076422e-07                 -9.672936e-02
#> 388                                1.009146e-07                 -1.597827e-01
#> 389                                0.000000e+00                  0.000000e+00
#> 390                                1.668455e-06                 -3.007897e-01
#> 391                               -1.291707e-06                 -1.902631e-01
#> 392                               -3.013983e-06                 -6.307486e-02
#> 393                                8.476826e-07                 -1.885813e-01
#> 394                                3.767478e-07                 -2.546724e-01
#> 395                                0.000000e+00                  0.000000e+00
#> 396                                3.229267e-07                 -1.568602e-01
#> 397                                0.000000e+00                  0.000000e+00
#> 398                                6.307162e-09                 -5.699049e-02
#> 399                                0.000000e+00                  0.000000e+00
#> 400                                0.000000e+00                  0.000000e+00
#> 401                                5.382112e-08                 -1.082136e-01
#> 402                                0.000000e+00                  0.000000e+00
#> 403                                1.695365e-06                 -2.478384e-01
#> 404                                4.709348e-08                 -1.063318e-01
#> 405                                0.000000e+00                  0.000000e+00
#> 406                                8.602969e-07                 -3.092547e-01
#> 407                                0.000000e+00                 -6.771425e-02
#> 408                                0.000000e+00                  0.000000e+00
#> 409                                8.476826e-07                 -1.552371e-01
#> 410                                8.577740e-07                 -9.927170e-02
#> 411                               -7.534956e-07                 -6.285910e-02
#> 412                                0.000000e+00                 -7.544428e-02
#> 413                                0.000000e+00                  0.000000e+00
#> 414                                3.767478e-07                 -1.048010e-01
#> 415                                8.342273e-07                 -1.863863e-01
#> 416                                6.781461e-06                 -2.535602e-01
#> 417                                2.018292e-07                 -1.724896e-01
#> 418                                0.000000e+00                 -2.759899e-02
#> 419                                0.000000e+00                  0.000000e+00
#> 420                                8.073167e-07                 -3.842175e-02
#> 421                                0.000000e+00                  0.000000e+00
#> 422                                0.000000e+00                  0.000000e+00
#> 423                               -7.534956e-07                 -4.513948e-02
#> 424                                8.342273e-07                 -2.822678e-01
#> 425                                3.336909e-06                 -1.483729e-01
#> 426                                0.000000e+00                 -7.480793e-02
#> 427                               -1.506991e-06                 -5.600305e-02
#> 428                                4.238413e-07                 -1.944854e-01
#> 429                                1.883739e-07                 -1.272539e-01
#> 430                                3.229267e-07                 -2.580544e-01
#> 431                                1.614633e-06                 -1.833323e-01
#> 432                               -1.076422e-07                 -1.188523e-01
#> 433                                0.000000e+00                 -1.231078e-01
#> 434                               -2.152845e-07                 -4.623766e-02
#> 435                                4.171136e-07                 -1.734937e-01
#> 436                                0.000000e+00                  0.000000e+00
#> 437                                0.000000e+00                  0.000000e+00
#> 438                                1.883739e-07                 -1.458079e-01
#> 439                                0.000000e+00                  0.000000e+00
#> 440                               -3.767478e-07                 -6.243948e-02
#> 441                                0.000000e+00                  0.000000e+00
#> 442                                2.691056e-08                 -7.495453e-02
#> 443                                0.000000e+00                  0.000000e+00
#> 444                                4.171136e-07                 -1.905031e-01
#> 445                               -1.614633e-07                 -1.064901e-01
#> 446                                0.000000e+00                 -2.619607e-01
#> 447                                3.229267e-07                 -1.061961e-01
#> 448                                7.534956e-07                 -2.966649e-01
#> 449                                8.073167e-08                 -1.404573e-01
#> 450                                0.000000e+00                 -1.210454e-01
#> 451                                3.437824e-06                 -1.494794e-01
#> 452                                0.000000e+00                  0.000000e+00
#> 453                                0.000000e+00                  0.000000e+00
#> 454                               -1.722276e-06                 -3.170955e-01
#> 455                                3.336909e-06                 -1.544856e-01
#> 456                               -6.458534e-07                 -6.739283e-02
#> 457                                0.000000e+00                 -1.427807e-02
#> 458                                1.708820e-06                 -3.146702e-01
#> 459                                7.534956e-07                 -1.336499e-01
#> 460                                4.036584e-07                 -1.603584e-01
#> 461                                1.695365e-06                 -2.425426e-01
#> 462                                0.000000e+00                  0.000000e+00
#> 463                                1.614633e-06                 -3.344812e-01
#> 464                                1.883739e-07                 -9.915197e-02
#> 465                                6.862192e-06                 -3.214563e-01
#> 466                                0.000000e+00                  0.000000e+00
#> 467                                0.000000e+00                  0.000000e+00
#> 468                                1.883739e-07                 -1.772855e-01
#> 469                                0.000000e+00                  0.000000e+00
#> 470                                0.000000e+00                  0.000000e+00
#> 471                                1.718912e-06                 -3.596867e-01
#> 472                               -3.767478e-07                 -3.282086e-02
#> 473                               -4.305689e-07                 -7.184578e-03
#> 474                                0.000000e+00                  0.000000e+00
#> 475                                3.441188e-06                 -2.410861e-01
#> 476                                0.000000e+00                  0.000000e+00
#> 477                                0.000000e+00                  0.000000e+00
#> 478                                3.437824e-06                 -3.775686e-01
#> 479                                0.000000e+00                  0.000000e+00
#> 480                                0.000000e+00                  0.000000e+00
#> 481                                0.000000e+00                  0.000000e+00
#> 482                                0.000000e+00                  0.000000e+00
#> 483                                8.476826e-07                 -1.581700e-01
#> 484                                0.000000e+00                  0.000000e+00
#> 485                               -4.305689e-07                 -1.683858e-01
#> 486                                4.036584e-07                 -6.188370e-02
#> 487                                0.000000e+00                  0.000000e+00
#> 488                               -4.305689e-07                 -8.357473e-02
#> 489                                0.000000e+00                  0.000000e+00
#> 490                                0.000000e+00                  0.000000e+00
#> 491                                8.342273e-07                 -2.156177e-01
#> 492                               -4.305689e-07                 -3.868851e-02
#> 493                                8.073167e-07                 -1.633000e-01
#> 494                               -3.903900e-02                 -1.569855e-01
#> 495                               -4.305689e-07                 -1.958203e-01
#> 496                                5.382112e-08                 -2.213734e-06
#> 497                                3.437824e-06                 -3.454189e-01
#> 498                                4.238413e-07                 -2.352182e-01
#> 499                                6.458534e-07                 -1.111222e-01
#> 500                                0.000000e+00                  0.000000e+00
#> 501                                0.000000e+00                  0.000000e+00
#> 502                               -8.611379e-07                 -1.903510e-01
#> 503                                2.018292e-07                 -1.791157e-01
#> 504                                0.000000e+00                  0.000000e+00
#> 505                                6.875648e-06                 -3.063899e-01
#> 506                                1.009146e-07                 -9.745484e-02
#> 507                                8.342273e-07                 -1.556965e-01
#> 508                                6.882375e-06                 -3.248411e-01
#> 509                                0.000000e+00                  0.000000e+00
#> 510                                0.000000e+00                  0.000000e+00
#> 511                                1.076422e-07                 -1.432820e-01
#> 512                                0.000000e+00                  0.000000e+00
#> 513                                4.238413e-07                 -1.206819e-01
#> 514                                5.382112e-08                 -1.028924e-01
#> 515                                1.614633e-07                 -1.151935e-01
#> 516                                2.018292e-07                 -1.907178e-01
#> 517                                1.883739e-07                 -1.278932e-01
#> 518                                0.000000e+00                  0.000000e+00
#> 519                                3.767478e-07                 -2.226408e-01
#> 520                                1.715548e-06                 -1.817448e-01
#> 521                                1.695365e-06                 -3.371687e-01
#> 522                                0.000000e+00                  0.000000e+00
#> 523                                3.767478e-07                 -2.769745e-01
#> 524                                8.602969e-07                 -2.092012e-01
#> 525                                0.000000e+00                  0.000000e+00
#> 526                                1.708820e-06                 -2.012945e-01
#> 527                                0.000000e+00                  0.000000e+00
#> 528                                0.000000e+00                  0.000000e+00
#> 529                                2.691056e-08                 -8.671714e-02
#> 530                                0.000000e+00                  0.000000e+00
#> 531                                0.000000e+00                  0.000000e+00
#> 532                                0.000000e+00                  0.000000e+00
#> 533                                0.000000e+00                  0.000000e+00
#> 534                                4.036584e-07                 -2.387757e-01
#> 535                                0.000000e+00                  0.000000e+00
#> 536                                0.000000e+00                  0.000000e+00
#> 537                                5.382112e-08                 -1.176208e-01
#> 538                                0.000000e+00                  0.000000e+00
#> 539                                0.000000e+00                  0.000000e+00
#> 540                                2.018292e-07                 -1.645705e-01
#> 541                                1.708820e-06                 -2.783554e-01
#> 542                                4.238413e-07                 -2.811559e-01
#> 543                                0.000000e+00                  0.000000e+00
#> 544                                0.000000e+00                 -1.667411e-01
#> 545                                0.000000e+00                  0.000000e+00
#> 546                                8.544102e-07                 -2.440848e-01
#> 547                                0.000000e+00                  0.000000e+00
#> 548                                0.000000e+00                 -1.210756e-01
#> 549                                8.342273e-07                 -2.771138e-01
#> 550                                0.000000e+00                  0.000000e+00
#> 551                                1.883739e-07                 -1.585980e-01
#> 552                                0.000000e+00                  0.000000e+00
#> 553                               -1.506991e-06                 -5.708214e-02
#> 554                                0.000000e+00                  0.000000e+00
#> 555                               -3.767478e-07                 -4.975909e-02
#> 556                               -6.458534e-07                 -7.624641e-02
#> 557                               -2.152845e-07                 -3.323464e-02
#> 558                                0.000000e+00                  0.000000e+00
#> 559                                4.171136e-07                 -1.689212e-01
#> 560                                5.382112e-08                 -7.841121e-02
#> 561                                0.000000e+00                  0.000000e+00
#> 562                                8.342273e-07                 -2.880318e-01
#> 563                                8.476826e-07                 -8.273773e-02
#> 564                                4.171136e-07                 -1.867052e-01
#> 565                                0.000000e+00                  0.000000e+00
#> 566                                0.000000e+00                  0.000000e+00
#> 567                               -2.691056e-08                 -1.552927e-02
#> 568                                0.000000e+00                 -2.008439e-01
#> 569                               -4.305689e-07                 -1.208382e-01
#> 570                                8.342273e-07                 -2.125849e-01
#> 571                                5.382112e-08                 -9.384756e-02
#> 572                               -4.305689e-07                 -1.382965e-02
#> 573                                0.000000e+00                  0.000000e+00
#> 574                                1.883739e-07                 -1.567591e-01
#> 575                                1.009146e-07                 -1.101196e-01
#> 576                                1.883739e-07                 -1.304297e-01
#> 577                                5.382112e-08                 -1.302480e-01
#> 578                                8.073167e-08                 -1.351921e-01
#> 579                                4.036584e-07                 -2.467722e-01
#> 580                                0.000000e+00                  0.000000e+00
#> 581                                0.000000e+00                  0.000000e+00
#> 582                                0.000000e+00                  0.000000e+00
#> 583                                0.000000e+00                  0.000000e+00
#> 584                                0.000000e+00                  0.000000e+00
#> 585                               -2.583414e-06                 -1.395451e-01
#> 586                                0.000000e+00                  0.000000e+00
#> 587                                1.076422e-07                 -9.618228e-02
#> 588                                8.073167e-07                 -2.006714e-01
#> 589                                0.000000e+00                  0.000000e+00
#> 590                                0.000000e+00                  0.000000e+00
#> 591                                0.000000e+00                  0.000000e+00
#> 592                                1.708820e-06                 -7.376607e-02
#> 593                                3.767478e-07                 -7.381916e-02
#> 594                               -1.681910e-09                 -2.949532e-02
#> 595                               -1.076422e-07                 -2.251281e-02
#> 596                                1.695365e-06                 -3.228084e-01
#> 597                                1.291707e-06                 -6.593675e-02
#> 598                                0.000000e+00                  0.000000e+00
#> 599                                3.767478e-07                 -1.717128e-01
#> 600                                3.229267e-06                 -6.841510e-03
#> 601                                4.238413e-07                 -1.907751e-01
#> 602                                1.614633e-07                 -6.944581e-02
#> 603                                0.000000e+00                 -1.817792e-01
#> 604                               -1.076422e-07                 -7.141294e-02
#> 605                                0.000000e+00                  0.000000e+00
#> 606                                3.417641e-06                 -3.779528e-01
#> 607                                1.715548e-06                 -1.837188e-01
#> 608                                0.000000e+00                  0.000000e+00
#> 609                                3.390730e-06                 -1.939372e-01
#> 610                                6.862192e-06                 -3.449548e-01
#> 611                                3.431096e-06                 -2.895888e-01
#> 612                                0.000000e+00                  0.000000e+00
#> 613                                0.000000e+00                 -1.315538e-01
#> 614                                3.767478e-07                 -2.001968e-01
#> 615                                0.000000e+00                  0.000000e+00
#> 616                                0.000000e+00                  0.000000e+00
#> 617                                4.171136e-07                 -1.581566e-01
#> 618                                1.614633e-07                 -1.397669e-01
#> 619                                1.668455e-06                 -2.727419e-01
#> 620                               -4.305689e-07                 -1.266107e-02
#> 621                                0.000000e+00                  0.000000e+00
#> 622                                0.000000e+00                  0.000000e+00
#> 623                                0.000000e+00                  0.000000e+00
#> 624                                0.000000e+00                  0.000000e+00
#> 625                                4.036584e-07                 -1.701690e-01
#> 626                               -1.291707e-06                 -3.132792e-02
#> 627                                0.000000e+00                  0.000000e+00
#> 628                                3.767478e-07                 -1.400668e-01
#> 629                                7.534956e-07                 -7.041686e-02
#> 630                                0.000000e+00                  0.000000e+00
#> 631                                0.000000e+00                  0.000000e+00
#> 632                                0.000000e+00                  0.000000e+00
#> 633                                0.000000e+00                  0.000000e+00
#> 634                                8.476826e-07                 -1.958623e-01
#> 635                                2.152845e-07                 -2.172917e-01
#> 636                                4.171136e-07                 -2.049066e-01
#> 637                               -7.534956e-07                 -8.559308e-02
#> 638                                1.059603e-07                 -1.342707e-01
#> 639                                0.000000e+00                  0.000000e+00
#> 640                                4.288870e-07                 -1.959641e-01
#> 641                                8.342273e-07                 -2.248724e-01
#> 642                                0.000000e+00                  0.000000e+00
#> 643                                6.458534e-07                 -2.080689e-01
#> 644                                8.476826e-07                 -2.437684e-01
#> 645                                1.708820e-06                 -2.548352e-01
#> 646                                0.000000e+00                  0.000000e+00
#> 647                                1.614633e-07                 -7.704977e-02
#> 648                                3.767478e-07                 -1.201124e-01
#> 649                                3.336909e-06                 -3.759109e-01
#> 650                                1.506991e-06                 -2.674858e-01
#> 651                                2.018292e-07                 -1.277244e-01
#> 652                                1.883739e-07                 -1.024691e-05
#> 653                                0.000000e+00                 -7.607472e-02
#> 654                                6.835282e-06                 -2.859394e-01
#> 655                                8.073167e-07                 -1.780481e-01
#> 656                                0.000000e+00                  0.000000e+00
#> 657                                0.000000e+00                  0.000000e+00
#> 658                                1.883739e-07                 -1.259262e-01
#> 659                                8.611379e-07                  4.474029e-06
#> 660                                4.036584e-07                 -1.201545e-01
#> 661                                0.000000e+00                 -1.129431e-01
#> 662                               -6.458534e-07                 -2.422291e-02
#> 663                                8.073167e-08                 -1.621725e-01
#> 664                                0.000000e+00                  0.000000e+00
#> 665                                0.000000e+00                  0.000000e+00
#> 666                                3.013983e-06                 -2.531584e-01
#> 667                                1.883739e-07                 -1.391739e-01
#> 668                                0.000000e+00                  0.000000e+00
#> 669                                0.000000e+00                  0.000000e+00
#> 670                                3.767478e-07                 -1.229005e-01
#> 671                                0.000000e+00                  0.000000e+00
#> 672                                4.272051e-07                 -2.338556e-01
#> 673                               -7.534956e-07                 -3.784665e-02
#> 674                                0.000000e+00                  0.000000e+00
#> 675                                0.000000e+00                 -1.768137e-01
#> 676                               -3.767478e-07                 -7.011711e-02
#> 677                               -1.076422e-07                 -1.051524e-01
#> 678                                0.000000e+00                  0.000000e+00
#> 679                                1.883739e-07                 -1.651322e-01
#> 680                                0.000000e+00                 -3.194624e-02
#> 681                                1.345528e-08                 -7.809063e-02
#> 682                                3.437824e-06                 -2.396702e-01
#> 683                                0.000000e+00                 -1.173021e-02
#> 684                                4.036584e-07                 -9.648967e-02
#> 685                                1.883739e-07                 -1.285070e-01
#> 686                                0.000000e+00                  0.000000e+00
#> 687                                8.544102e-07                 -2.989289e-01
#> 688                                0.000000e+00                  0.000000e+00
#> 689                                8.342273e-07                 -6.571297e-02
#> 690                                0.000000e+00                  0.000000e+00
#> 691                                0.000000e+00                 -4.307948e-02
#> 692                                6.673818e-06                 -9.168007e-02
#> 693                                1.506991e-06                 -1.841982e-01
#> 694                                0.000000e+00                  0.000000e+00
#> 695                                8.073167e-07                 -1.701133e-01
#> 696                                0.000000e+00                  0.000000e+00
#> 697                                0.000000e+00                  0.000000e+00
#> 698                                3.229267e-07                 -2.404197e-01
#> 699                                1.614633e-07                 -9.333346e-02
#> 700                                1.695365e-06                 -1.057883e-01
#> 701                                0.000000e+00                  0.000000e+00
#> 702                                4.272051e-07                 -1.912208e-01
#> 703                                2.144435e-07                 -1.860865e-01
#> 704                                6.673818e-06                 -5.436651e-02
#> 705                                3.013983e-06                 -2.780929e-01
#> 706                                4.036584e-07                 -1.889196e-01
#> 707                               -1.291707e-06                 -7.004766e-02
#> 708                                8.476826e-07                 -1.640046e-01
#> 709                                4.272051e-07                 -2.345119e-01
#> 710                                0.000000e+00                  0.000000e+00
#> 711                                0.000000e+00                  0.000000e+00
#> 712                                1.883739e-07                 -1.679181e-01
#> 713                                0.000000e+00                  0.000000e+00
#> 714                                1.668455e-06                 -2.622022e-01
#> 715                                3.229267e-07                 -4.912701e-02
#> 716                                1.614633e-06                 -1.695194e-01
#> 717                                0.000000e+00                  0.000000e+00
#> 718                                8.476826e-07                 -1.369458e-01
#> 719                                0.000000e+00                  0.000000e+00
#> 720                                0.000000e+00                 -1.364592e-01
#> 721                                0.000000e+00                  0.000000e+00
#> 722                                0.000000e+00                  0.000000e+00
#> 723                                0.000000e+00                  0.000000e+00
#> 724                               -1.076422e-07                 -2.708458e-02
#> 725                                0.000000e+00                  0.000000e+00
#> 726                                1.009146e-07                 -1.304710e-01
#> 727                                0.000000e+00                  0.000000e+00
#> 728                               -1.076422e-07                 -6.193644e-02
#> 729                                1.715548e-06                 -1.751806e-01
#> 730                                0.000000e+00                  0.000000e+00
#> 731                               -2.983909e-02                 -2.580535e-01
#> 732                                8.073167e-08                 -1.422718e-01
#> 733                                4.036584e-07                 -8.878476e-02
#> 734                               -6.458534e-07                 -1.330994e-01
#> 735                                0.000000e+00                  0.000000e+00
#> 736                                0.000000e+00                  0.000000e+00
#> 737                                1.695365e-06                 -2.269952e-01
#> 738                               -2.806610e-02                 -1.419809e-01
#> 739                               -8.611379e-07                 -2.765973e-01
#> 740                                5.382112e-08                 -1.058228e-01
#> 741                                3.431096e-06                 -3.404965e-01
#> 742                                4.171136e-07                 -1.951323e-01
#> 743                                0.000000e+00                  0.000000e+00
#> 744                                0.000000e+00                  0.000000e+00
#> 745                                0.000000e+00                  0.000000e+00
#> 746                                0.000000e+00                  0.000000e+00
#> 747                                0.000000e+00                  0.000000e+00
#> 748                                0.000000e+00                  0.000000e+00
#> 749                                3.390730e-06                 -2.358231e-01
#> 750                               -1.614633e-07                 -6.622087e-02
#> 751                                0.000000e+00                  0.000000e+00
#> 752                               -6.107094e-03                 -5.006926e-02
#> 753                               -4.305689e-07                 -1.956316e-01
#> 754                                1.718912e-06                 -2.481804e-01
#> 755                                4.171136e-07                 -1.957431e-01
#> 756                                0.000000e+00                  0.000000e+00
#> 757                                0.000000e+00                  0.000000e+00
#> 758                               -2.999901e-03                 -1.476699e-02
#> 759                               -7.534956e-07                 -1.608811e-01
#> 760                                0.000000e+00                  0.000000e+00
#> 761                                5.382112e-08                 -7.360054e-02
#> 762                                1.695365e-06                 -1.667938e-01
#> 763                                0.000000e+00                  0.000000e+00
#> 764                                7.534956e-07                 -1.584741e-01
#> 765                                0.000000e+00                  0.000000e+00
#> 766                               -3.767478e-07                 -7.082935e-02
#> 767                                0.000000e+00                  0.000000e+00
#> 768                               -4.907569e-02                 -1.910994e-01
#> 769                                0.000000e+00                 -1.181871e-01
#> 770                                0.000000e+00                  0.000000e+00
#> 771                                0.000000e+00                  0.000000e+00
#> 772                                1.883739e-07                 -7.329557e-02
#> 773                                0.000000e+00                  0.000000e+00
#> 774                                0.000000e+00                  0.000000e+00
#> 775                                8.544102e-07                 -2.502183e-01
#> 776                                1.614633e-07                 -1.063940e-01
#> 777                                0.000000e+00                  0.000000e+00
#> 778                                0.000000e+00                  0.000000e+00
#> 779                               -1.076422e-07                 -9.413404e-02
#> 780                               -1.506991e-06                 -3.187082e-02
#> 781                               -1.076422e-07                 -8.886014e-02
#> 782                                8.476826e-07                 -1.569509e-01
#> 783                                7.534956e-07                 -1.424440e-01
#> 784                                0.000000e+00                  0.000000e+00
#> 785                                0.000000e+00                  0.000000e+00
#> 786                                4.036584e-07                 -1.847612e-01
#> 787                                0.000000e+00                  0.000000e+00
#> 788                                0.000000e+00                  0.000000e+00
#> 789                                0.000000e+00                  0.000000e+00
#> 790                                0.000000e+00                  0.000000e+00
#> 791                                0.000000e+00                  0.000000e+00
#> 792                                0.000000e+00                  0.000000e+00
#> 793                                0.000000e+00                  0.000000e+00
#> 794                                0.000000e+00                  0.000000e+00
#> 795                                6.835282e-06                 -2.383350e-01
#> 796                                0.000000e+00                  0.000000e+00
#> 797                               -6.458534e-07                 -1.547077e-01
#> 798                                1.668455e-06                 -3.523286e-01
#> 799                                4.036584e-07                 -1.663501e-01
#> 800                                0.000000e+00                  0.000000e+00
#> 801                                0.000000e+00                  0.000000e+00
#> 802                               -4.305689e-07                 -1.309645e-02
#> 803                                0.000000e+00                  0.000000e+00
#> 804                                0.000000e+00                  0.000000e+00
#> 805                               -3.547962e-02                 -1.567163e-01
#> 806                                8.611379e-07                 -3.612382e-02
#> 807                                0.000000e+00                  0.000000e+00
#> 808                                0.000000e+00                  0.000000e+00
#> 809                                2.152845e-07                 -1.626728e-01
#> 810                               -8.611379e-07                 -2.444411e-01
#> 811                                4.036584e-07                 -1.551291e-01
#> 812                                0.000000e+00                  0.000000e+00
#> 813                                8.073167e-07                 -1.875298e-01
#> 814                                8.342273e-07                 -2.730614e-01
#> 815                                0.000000e+00                  0.000000e+00
#> 816                                2.018292e-07                 -7.682806e-02
#> 817                                1.614633e-07                 -8.490148e-02
#> 818                                0.000000e+00                  0.000000e+00
#> 819                                8.594559e-07                 -2.244786e-01
#> 820                                0.000000e+00                  0.000000e+00
#> 821                                4.171136e-07                 -1.902907e-01
#> 822                                1.883739e-07                 -1.592325e-01
#> 823                               -1.076422e-07                 -9.451594e-02
#> 824                                0.000000e+00                  0.000000e+00
#> 825                                4.171136e-07                 -1.879969e-01
#> 826                                8.073167e-08                 -5.587316e-06
#> 827                                4.272051e-07                 -2.902551e-01
#> 828                                2.085568e-07                 -1.731960e-01
#> 829                                1.009146e-07                 -1.662771e-01
#> 830                                1.883739e-07                 -1.097480e-01
#> 831                                4.171136e-07                 -1.029924e-01
#> 832                                3.437824e-06                 -2.159432e-01
#> 833                                2.018292e-07                 -1.976451e-01
#> 834                                0.000000e+00                  0.000000e+00
#> 835                                0.000000e+00                 -1.743694e-01
#> 836                                0.000000e+00                  0.000000e+00
#> 837                                0.000000e+00                  0.000000e+00
#> 838                                0.000000e+00                  0.000000e+00
#> 839                                8.577740e-07                 -2.671920e-01
#> 840                                1.718912e-06                 -2.559105e-01
#> 841                                0.000000e+00                  0.000000e+00
#> 842                               -3.767478e-07                 -7.791449e-02
#> 843                                2.152845e-07                 -2.398093e-01
#> 844                                0.000000e+00                  0.000000e+00
#> 845                               -7.534956e-07                 -6.800015e-02
#> 846                                0.000000e+00                  0.000000e+00
#> 847                                1.614633e-07                 -1.385011e-01
#> 848                                0.000000e+00                  0.000000e+00
#> 849                                0.000000e+00                  0.000000e+00
#> 850                                0.000000e+00                  0.000000e+00
#> 851                                0.000000e+00                  0.000000e+00
#> 852                                1.506991e-06                 -7.642113e-02
#> 853                               -2.583414e-06                 -2.457530e-01
#> 854                               -4.305689e-07                 -1.264479e-01
#> 855                                4.238413e-07                 -1.509883e-01
#> 856                                2.018292e-07                 -9.502113e-02
#> 857                                0.000000e+00                  0.000000e+00
#> 858                                4.288870e-07                 -9.069430e-02
#> 859                                3.431096e-06                 -2.076261e-01
#> 860                                1.076422e-07                 -1.498070e-01
#> 861                                8.544102e-07                 -3.044923e-01
#> 862                               -8.611379e-07                 -2.540935e-01
#> 863                                2.152845e-07                  4.883440e-06
#> 864                                0.000000e+00                  0.000000e+00
#> 865                               -6.458534e-07                 -4.841899e-02
#> 866                               -3.229267e-07                 -8.088573e-02
#> 867                                0.000000e+00                  0.000000e+00
#> 868                                1.883739e-07                 -1.403625e-01
#> 869                                0.000000e+00                  0.000000e+00
#> 870                                0.000000e+00                  0.000000e+00
#> 871                                0.000000e+00                  0.000000e+00
#> 872                                0.000000e+00                  0.000000e+00
#> 873                                0.000000e+00                 -9.739017e-02
#> 874                                6.458534e-07                 -1.303890e-01
#> 875                                6.885739e-06                 -3.686028e-01
#> 876                                3.437824e-06                 -3.110762e-01
#> 877                                0.000000e+00                  0.000000e+00
#> 878                                1.708820e-06                 -1.701721e-01
#> 879                                0.000000e+00                  0.000000e+00
#> 880                               -4.305689e-07                 -7.196964e-02
#> 881                                0.000000e+00                  0.000000e+00
#> 882                                3.390730e-06                 -2.202425e-01
#> 883                                3.229267e-07                 -2.466125e-01
#> 884                                0.000000e+00                  0.000000e+00
#> 885                                0.000000e+00                  0.000000e+00
#> 886                               -3.229267e-07                 -9.553704e-02
#> 887                                2.085568e-07                 -1.029464e-01
#> 888                                0.000000e+00                  0.000000e+00
#> 889                                4.036584e-07                 -1.743974e-01
#> 890                               -9.854217e-03                 -2.066158e-01
#> 891                                0.000000e+00                  0.000000e+00
#> 892                                3.336909e-06                 -1.694084e-01
#> 893                                6.887421e-06                 -3.843371e-01
#> 894                                1.076422e-07                 -7.577540e-02
#> 895                                4.171136e-07                 -1.980138e-01
#> 896                                0.000000e+00                 -9.924985e-02
#> 897                                0.000000e+00                  0.000000e+00
#> 898                                0.000000e+00                  0.000000e+00
#> 899                                4.171136e-07                 -2.342078e-01
#> 900                                0.000000e+00                  0.000000e+00
#> 901                                0.000000e+00                  0.000000e+00
#> 902                                0.000000e+00                  0.000000e+00
#> 903                                3.767478e-07                 -9.231782e-02
#> 904                               -2.152845e-07                 -1.211883e-01
#> 905                                6.458534e-07                 -2.519737e-01
#> 906                                0.000000e+00                  0.000000e+00
#> 907                                0.000000e+00                  0.000000e+00
#> 908                                1.614633e-07                 -1.623612e-01
#> 909                                0.000000e+00                  0.000000e+00
#> 910                                0.000000e+00                  0.000000e+00
#> 911                                0.000000e+00                  0.000000e+00
#> 912                                0.000000e+00                  0.000000e+00
#> 913                               -8.611379e-07                 -5.954563e-02
#> 914                                8.476826e-07                 -1.132855e-01
#> 915                                1.614633e-07                 -1.164197e-01
#> 916                                3.437824e-06                 -2.986999e-01
#> 917                                3.229267e-07                 -1.433568e-01
#> 918                                0.000000e+00                  0.000000e+00
#> 919                                0.000000e+00                  0.000000e+00
#> 920                                4.036584e-07                 -1.979789e-01
#> 921                                6.875648e-06                 -2.729824e-01
#> 922                                0.000000e+00                  0.000000e+00
#> 923                               -8.611379e-07                 -2.020671e-02
#> 924                                3.767478e-07                 -1.995857e-01
#> 925                                0.000000e+00                  0.000000e+00
#> 926                                2.085568e-07                 -1.252075e-01
#> 927                                0.000000e+00                  0.000000e+00
#> 928                                0.000000e+00                  0.000000e+00
#> 929                                2.018292e-08                 -3.176306e-06
#> 930                                1.883739e-07                 -1.155236e-01
#> 931                                3.431096e-06                 -1.008998e-01
#> 932                                7.534956e-07                 -5.134482e-02
#> 933                                1.883739e-07                 -1.023343e-01
#> 934                                1.614633e-07                 -1.624148e-01
#> 935                                3.417641e-06                 -2.417591e-01
#> 936                                3.336909e-06                 -1.487765e-01
#> 937                               -7.534956e-07                 -6.633171e-02
#> 938                               -1.614633e-07                 -6.916405e-02
#> 939                                1.668455e-06                 -3.330689e-01
#> 940                                0.000000e+00                  0.000000e+00
#> 941                                0.000000e+00                  0.000000e+00
#> 942                               -2.134642e-02                 -7.660848e-02
#> 943                               -3.229267e-07                 -4.953785e-02
#> 944                               -6.458534e-07                 -2.199982e-01
#> 945                                0.000000e+00                  0.000000e+00
#> 946                                6.673818e-06                 -3.381666e-01
#> 947                                0.000000e+00                  0.000000e+00
#> 948                                0.000000e+00                  0.000000e+00
#> 949                                8.342273e-07                 -2.187273e-01
#> 950                                1.076422e-07                 -9.470018e-02
#> 951                                0.000000e+00                 -2.036091e-01
#> 952                                0.000000e+00                 -2.340558e-01
#> 953                                4.288870e-07                 -2.750104e-01
#> 954                                0.000000e+00                  0.000000e+00
#> 955                                3.390730e-06                 -1.968854e-01
#> 956                                0.000000e+00                  0.000000e+00
#> 957                                0.000000e+00                  0.000000e+00
#> 958                                1.614633e-07                 -1.242576e-01
#> 959                                3.229267e-07                 -2.245363e-01
#> 960                                0.000000e+00                  0.000000e+00
#> 961                                1.076422e-07                 -2.402526e-01
#> 962                                0.000000e+00                  0.000000e+00
#> 963                                0.000000e+00                  0.000000e+00
#> 964                               -2.152845e-07                 -1.235189e-01
#> 965                               -2.213591e-02                 -5.319602e-02
#> 966                                1.883739e-07                 -1.415896e-01
#> 967                                0.000000e+00                  0.000000e+00
#> 968                                0.000000e+00                  0.000000e+00
#> 969                                0.000000e+00                  0.000000e+00
#> 970                               -1.076422e-07                 -7.659266e-02
#> 971                                4.036584e-07                 -2.019770e-01
#> 972                                3.767478e-07                 -1.560075e-01
#> 973                               -7.534956e-07                 -7.096067e-02
#> 974                                1.614633e-06                 -1.948164e-01
#> 975                                7.534956e-07                 -6.417110e-02
#> 976                                0.000000e+00                  0.000000e+00
#> 977                                3.437824e-06                 -3.707003e-01
#> 978                                0.000000e+00                  0.000000e+00
#> 979                               -1.076422e-07                 -1.268234e-02
#> 980                               -1.076422e-07                 -3.591439e-02
#> 981                                4.036584e-08                 -5.690407e-02
#> 982                               -2.152845e-07                 -1.386036e-01
#> 983                                0.000000e+00                 -9.568014e-02
#> 984                                1.614633e-07                 -1.078228e-01
#> 985                                4.036584e-07                 -1.524197e-01
#> 986                                5.382112e-08                 -1.252353e-01
#> 987                                3.417641e-06                 -3.090506e-01
#> 988                                0.000000e+00                  0.000000e+00
#> 989                                1.668455e-06                 -3.188845e-01
#> 990                                4.036584e-07                 -1.102110e-01
#> 991                               -7.249649e-02                 -3.025592e-01
#> 992                                0.000000e+00                 -8.320666e-02
#> 993                                0.000000e+00                  0.000000e+00
#> 994                                3.390730e-06                 -3.347436e-01
#> 995                                1.708820e-06                 -2.501160e-01
#> 996                                1.076422e-07                 -2.191691e-01
#> 997                                0.000000e+00                  0.000000e+00
#> 998                                3.767478e-07                 -2.796770e-01
#> 999                                0.000000e+00                  0.000000e+00
#> 1000                               0.000000e+00                  0.000000e+00
#> 
#> $mc_CIs_and_quantiles
#>                                           node expected_value      0.025_CI
#> 1            Guidance.Docs.for.Salt.Management   1.000000e+00  1.000000e+00
#> 2                    Public.Education.Programs   7.222542e-03  4.849458e-03
#> 3           Salts.Added.during.Water.Treatment   4.545325e-07  3.651625e-07
#> 4 Salts.Added.by.Winter.Maintenance.Activities  -1.140610e-01 -1.208059e-01
#> 5                             Ecosystem.Health   5.806788e-02  5.399063e-02
#> 6   Public.Awareness.of.Reservoir.Salinization  -8.118733e-04 -1.255480e-03
#> 7                Salinization.of.the.Reservoir  -9.939710e-02 -1.054552e-01
#>        0.975_CI           min 0.25_quantile      median 0.75_quantile
#> 1  1.000000e+00  1.000000e+00     1.0000000  1.00000000  1.000000e+00
#> 2  1.000520e-02 -3.013983e-06     0.0000000  0.00000000  4.246822e-07
#> 3  5.483506e-07 -1.042382e-05     0.0000000  0.00000000  4.171136e-07
#> 4 -1.067240e-01 -3.633416e-01    -0.2329354 -0.08370376  0.000000e+00
#> 5  6.297407e-02 -2.175523e-06     0.0000000  0.03438556  9.471291e-02
#> 6 -3.946715e-04 -1.007140e-01     0.0000000  0.00000000  4.070222e-07
#> 7 -9.343433e-02 -3.843371e-01    -0.1726662 -0.07693892  0.000000e+00
#>            max
#> 1 1.000000e+00
#> 2 3.174085e-01
#> 3 6.887421e-06
#> 4 1.708820e-06
#> 5 3.746917e-01
#> 6 6.887421e-06
#> 7 6.681033e-06
#> 
```
