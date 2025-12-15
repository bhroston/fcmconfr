# Create Adj. Matrix w/ Edges Represented as IVFNs

This constructs an adjacency matrix with edges represented by
interval-valued fuzzy numbers (IVFNs) from an adjacency matrix of lower
bounds and an adjacency matrix of upper bounds

## Usage

``` r
make_adj_matrix_w_ivfns(lower = data.frame(), upper = data.frame())
```

## Arguments

- lower:

  \[[`list()`](https://rdrr.io/r/base/list.html) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
  An n x n adjacency matrix that represents the lower limits of edges in
  an FCM

- upper:

  \[[`list()`](https://rdrr.io/r/base/list.html) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)\]  
  An n x n adjacency matrix that represents the upper limits of edges in
  an FCM

## Value

\[`adj_matrix_w_ivfns`\]  
An adjacency matrix (of class 'ivfn') with edges represented as IVFNs

## Details

The input adjacency matrices must be square n x n matrices with the same
dimensions. The input can be either matrix, data.table, tibble, or
data.table type objects, but the output will always be a data.frame.
This is for output readability. data.table and tibble objects work
logically, but their outputs require additional steps to parse from the
user's perspective.

If the input matrices have named columns, those names will be carried
over in the IVFN-FCM adjacency matrix. Otherwise, generic node IDs will
be used (C1, C2, ... Cn).

## See also

Other interval-valued-fuzzy-numbers:
[`c.ivfn()`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md),
[`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md),
[`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md),
[`print.ivfn()`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md),
[`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)

## Examples

``` r
lower_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.4, 0)
)
upper_adj_matrix <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.6, 0)
)
make_adj_matrix_w_ivfns(lower = lower_adj_matrix, upper = upper_adj_matrix)
#>      A        B
#> A 0, 0 0.4, 0.6
#> B 0, 0     0, 0
```
