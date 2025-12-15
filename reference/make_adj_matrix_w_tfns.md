# Create Adj. Matrix w/ Edges Represented as TFNs

This constructs an adjacency matrix with edges represented by triangular
fuzzy numbers (TFNs) from an adjacency matrix of lower bounds, an
adjacency matrix of modes, and an adjacency matrix of upper bounds

## Usage

``` r
make_adj_matrix_w_tfns(
  lower = data.frame(),
  mode = data.frame(),
  upper = data.frame()
)
```

## Arguments

- lower:

  \[[`list()`](https://rdrr.io/r/base/list.html) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
  An n x n adjacency matrix that represents the lower limits of edges in
  an FCM

- mode:

  \[[`list()`](https://rdrr.io/r/base/list.html) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
  An n x n adjacency matrix that represents the modes (most likely
  values) of edges in an FCM

- upper:

  \[[`list()`](https://rdrr.io/r/base/list.html) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
  An n x n adjacency matrix that represents the upper limits of edges in
  an FCM

## Value

\[`adj_matrix_w_tfns`\]  
An adjacency matrix (of class 'tfn') with edges represented as TFNs

## Details

The input adjacency matrices must be square n x n matrices with the same
dimensions. The input can be either matrix, data.table, tibble, or
data.table type objects, but the output will always be a data.frame.
This is for output readability. data.table and tibble objects work
logically, but their outputs require additional steps to parse from the
user's perspective.

If the input matrices have named columns, those names will be carried
over in the triangular adjacency matrix. Otherwise, generic node IDs
will be used (C1, C2, ... Cn).

## See also

Other triangular-fuzzy-numbers:
[`create_tfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_tfn_fcm_from_conventional_fcm.md),
[`print.tfn()`](https://bhroston.github.io/fcmconfr/reference/print.tfn.md),
[`subtract_tfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_tfn.md),
[`tfn()`](https://bhroston.github.io/fcmconfr/reference/tfn.md)

## Examples

``` r
make_adj_matrix_w_tfns(
  lower = matrix(data = c(0, 0.2, 0, 0.5), nrow = 2, ncol = 2),
  mode = matrix(data = c(0, 0.3, 0, 0.6), nrow = 2, ncol = 2),
  upper = matrix(data = c(0, 0.4, 0, 0.7), nrow = 2, ncol = 2)
)
#>               V1            V2
#> V1       0, 0, 0       0, 0, 0
#> V2 0.2, 0.3, 0.4 0.5, 0.6, 0.7

lower_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
mode_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
upper_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.6, 0)
)
make_adj_matrix_w_tfns(lower_adj_matrix, mode_adj_matrix, upper_adj_matrix)
#>         A             B
#> A 0, 0, 0 0.4, 0.4, 0.6
#> B 0, 0, 0       0, 0, 0
```
