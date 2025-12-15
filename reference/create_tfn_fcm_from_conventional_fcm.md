# Create TFN-FCM from Conventional FCM

This creates a TFN-FCM from a Conventional FCM by adding error to the
Conventional FCM edge weights. The Conventional FCM edge weights are
used as the mode values for the TFN edge weights.

## Usage

``` r
create_tfn_fcm_from_conventional_fcm(
  conventional_adj_matrix = data.frame(),
  error = 0.2
)
```

## Arguments

- conventional_adj_matrix:

  \[`list() or data.frame()`\]  
  A single, conventional adjacency matrix (n x n) representing FCMs.

- error:

  \[`double(1)`\]  
  The +/- error defining the lower and upper bounds of the TFN edge
  weights created from the numeric edge weights.

## Value

\[`adj_matrix_w_tfns`\]  
An adjacency matrix (of class 'tfn') with edges represented as TFNs

## See also

Other triangular-fuzzy-numbers:
[`make_adj_matrix_w_tfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_tfns.md),
[`print.tfn()`](https://bhroston.github.io/fcmconfr/reference/print.tfn.md),
[`subtract_tfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_tfn.md),
[`tfn()`](https://bhroston.github.io/fcmconfr/reference/tfn.md)

## Examples

``` r
create_tfn_fcm_from_conventional_fcm(
  sample_fcms$simple_fcms$conventional_fcms[[1]],
  error = 0.2
)
#>   Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1                           0, 0, 0                   0, 0, 0
#> 2                     0.0, 0.1, 0.3                   0, 0, 0
#> 3                           0, 0, 0                   0, 0, 0
#> 4                           0, 0, 0                   0, 0, 0
#> 5                           0, 0, 0                   0, 0, 0
#> 6                           0, 0, 0                   0, 0, 0
#> 7                           0, 0, 0                   0, 0, 0
#>   Salts.Added.during.Water.Treatment
#> 1                            0, 0, 0
#> 2                            0, 0, 0
#> 3                            0, 0, 0
#> 4                            0, 0, 0
#> 5                            0, 0, 0
#> 6                            0, 0, 0
#> 7                            0, 0, 0
#>   Salts.Added.by.Winter.Maintenance.Activities    Ecosystem.Health
#> 1                          -0.45, -0.25, -0.05             0, 0, 0
#> 2                                      0, 0, 0             0, 0, 0
#> 3                                      0, 0, 0             0, 0, 0
#> 4                                      0, 0, 0             0, 0, 0
#> 5                                      0, 0, 0             0, 0, 0
#> 6                                      0, 0, 0             0, 0, 0
#> 7                                      0, 0, 0 -0.95, -0.75, -0.55
#>   Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                    0, 0, 0           -0.45, -0.25, -0.05
#> 2                                    0, 0, 0                       0, 0, 0
#> 3                                    0, 0, 0                       0, 0, 0
#> 4                                    0, 0, 0              0.55, 0.75, 0.95
#> 5                                    0, 0, 0                       0, 0, 0
#> 6                                    0, 0, 0                       0, 0, 0
#> 7                                    0, 0, 0                       0, 0, 0
```
