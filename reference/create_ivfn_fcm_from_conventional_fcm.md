# Create IVFN-FCM from Conventional FCM

This creates an IVFN-FCM from a Conventional FCM by adding error to the
Conventional FCM edge weights.

## Usage

``` r
create_ivfn_fcm_from_conventional_fcm(
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
  The +/- error defining the lower and upper bounds of the IVFN edge
  weights created from the numeric edge weights

## Value

\[`adj_matrix_w_ivfns`\]  
An adjacency matrix (of class 'ivfn') with edges represented as IVFNs

## See also

Other interval-valued-fuzzy-numbers:
[`c.ivfn()`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md),
[`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md),
[`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md),
[`print.ivfn()`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md),
[`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)

## Examples

``` r
create_ivfn_fcm_from_conventional_fcm(
  sample_fcms$simple_fcms$conventional_fcms[[1]],
  error = 0.2
)
#>   Guidance.Docs.for.Salt.Management Public.Education.Programs
#> 1                              0, 0                      0, 0
#> 2                          0.0, 0.3                      0, 0
#> 3                              0, 0                      0, 0
#> 4                              0, 0                      0, 0
#> 5                              0, 0                      0, 0
#> 6                              0, 0                      0, 0
#> 7                              0, 0                      0, 0
#>   Salts.Added.during.Water.Treatment
#> 1                               0, 0
#> 2                               0, 0
#> 3                               0, 0
#> 4                               0, 0
#> 5                               0, 0
#> 6                               0, 0
#> 7                               0, 0
#>   Salts.Added.by.Winter.Maintenance.Activities Ecosystem.Health
#> 1                                 -0.45, -0.05             0, 0
#> 2                                         0, 0             0, 0
#> 3                                         0, 0             0, 0
#> 4                                         0, 0             0, 0
#> 5                                         0, 0             0, 0
#> 6                                         0, 0             0, 0
#> 7                                         0, 0     -0.95, -0.55
#>   Public.Awareness.of.Reservoir.Salinization Salinization.of.the.Reservoir
#> 1                                       0, 0                  -0.45, -0.05
#> 2                                       0, 0                          0, 0
#> 3                                       0, 0                          0, 0
#> 4                                       0, 0                    0.55, 0.95
#> 5                                       0, 0                          0, 0
#> 6                                       0, 0                          0, 0
#> 7                                       0, 0                          0, 0
```
