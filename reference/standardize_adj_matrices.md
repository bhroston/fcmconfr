# Standardize a List of Adjacency Matrices

Given a list of adj. matrices of different sizes, transforms the inputs
into adj. matrices of the same size with 0-values added where edges are
undefined or not included in maps.

Solves the problem where Map 1 has nodes A and B but Map 2 has nodes B
and C and the user needs to analyse them both together.

## Usage

``` r
standardize_adj_matrices(adj_matrices = list())
```

## Arguments

- adj_matrices:

  \[[`list()`](https://rdrr.io/r/base/list.html)\]  
  A single adjacency matrix or a list of adjacency matrices (n x n)
  representing FCMs. Matrices can have conventional edge weights, IVFN
  edge weights or TFN edge weights.

## Value

\[[`list()`](https://rdrr.io/r/base/list.html)\]  
A list of adjacency matrices constructed from the input adj. matrices,
that contain the same concepts (and dimensions). Rows/Columns of added
concepts are all 0's.

## Examples

``` r
# Standardize Conventional FCMs
adj_matrix_1 <- data.frame(
  "A" = c(0, 0),
  "B" = c(1, 0)
)
adj_matrix_2 <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.25, 0, 1),
  "C" = c(0, 0.7, 0)
)
adj_matrix_3 <- data.frame(
  "B" = c(0, 0),
  "D" = c(0.75, 0)
)
adj_matrix_4 <- data.frame(
  "A" = c(0, 0, 0.3, 0),
  "B" = c(0.5, 0, 0, 0.6),
  "E" = c(0, 0, 0, 0),
  "F" = c(1, 0, 1, 0)
)
adj_matrices_w_different_concepts <- list(
  adj_matrix_1, adj_matrix_2, adj_matrix_3, adj_matrix_4
)
standardize_adj_matrices(adj_matrices_w_different_concepts)
#> [[1]]
#>   A B C D E F
#> 1 0 1 0 0 0 0
#> 2 0 0 0 0 0 0
#> 3 0 0 0 0 0 0
#> 4 0 0 0 0 0 0
#> 5 0 0 0 0 0 0
#> 6 0 0 0 0 0 0
#> 
#> [[2]]
#>   A    B   C D E F
#> 1 0 0.25 0.0 0 0 0
#> 2 0 0.00 0.7 0 0 0
#> 3 0 1.00 0.0 0 0 0
#> 4 0 0.00 0.0 0 0 0
#> 5 0 0.00 0.0 0 0 0
#> 6 0 0.00 0.0 0 0 0
#> 
#> [[3]]
#>   A B C    D E F
#> 1 0 0 0 0.00 0 0
#> 2 0 0 0 0.75 0 0
#> 3 0 0 0 0.00 0 0
#> 4 0 0 0 0.00 0 0
#> 5 0 0 0 0.00 0 0
#> 6 0 0 0 0.00 0 0
#> 
#> [[4]]
#>     A   B C D E F
#> 1 0.0 0.5 0 0 0 1
#> 2 0.0 0.0 0 0 0 0
#> 3 0.0 0.0 0 0 0 0
#> 4 0.0 0.0 0 0 0 0
#> 5 0.3 0.0 0 0 0 1
#> 6 0.0 0.6 0 0 0 0
#> 

# Standardize IVFN FCMs
adj_matrix_1_lower <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.8, 0)
)
adj_matrix_1_upper <- data.frame(
  "A" = c(0, 0),
  "B" = c(1, 0)
)
ivfn_adj_matrix_1 <- make_adj_matrix_w_ivfns(
  adj_matrix_1_lower, adj_matrix_1_upper
)

adj_matrix_2_lower <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.1, 0, 0.8),
  "C" = c(0, 0.6, 0)
)
adj_matrix_2_upper <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.3, 0, 1),
  "C" = c(0, 0.8, 0)
)
ivfn_adj_matrix_2 <- make_adj_matrix_w_ivfns(
  adj_matrix_2_lower, adj_matrix_2_upper
)

adj_matrices_w_different_concepts <- list(
  ivfn_adj_matrix_1, ivfn_adj_matrix_2
)
standardize_adj_matrices(adj_matrices_w_different_concepts)
#> [[1]]
#>      A        B    C
#> 1 0, 0 0.8, 1.0 0, 0
#> 2 0, 0     0, 0 0, 0
#> 3 0, 0     0, 0 0, 0
#> 
#> [[2]]
#>      A        B        C
#> 1 0, 0 0.1, 0.3     0, 0
#> 2 0, 0     0, 0 0.6, 0.8
#> 3 0, 0 0.8, 1.0     0, 0
#> 


# Standardize TFN FCMs
adj_matrix_1_lower <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.8, 0)
)
adj_matrix_1_mode <- data.frame(
  "A" = c(0, 0),
  "B" = c(0.9, 0)
)
adj_matrix_1_upper <- data.frame(
  "A" = c(0, 0),
  "B" = c(1, 0)
)
tfn_adj_matrix_1 <- make_adj_matrix_w_tfns(
  adj_matrix_1_lower, adj_matrix_1_mode, adj_matrix_1_upper
)

adj_matrix_2_lower <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.1, 0, 0.8),
  "C" = c(0, 0.6, 0)
)
adj_matrix_2_mode <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.2, 0, 0.9),
  "C" = c(0, 0.7, 0)
)
adj_matrix_2_upper <- data.frame(
  "A" = c(0, 0, 0),
  "B" = c(0.3, 0, 1),
  "C" = c(0, 0.8, 0)
)
tfn_adj_matrix_2 <- make_adj_matrix_w_tfns(
  adj_matrix_2_lower, adj_matrix_2_mode, adj_matrix_2_upper
)

adj_matrices_w_different_concepts <- list(
  ivfn_adj_matrix_1, ivfn_adj_matrix_2
)
standardize_adj_matrices(adj_matrices_w_different_concepts)
#> [[1]]
#>      A        B    C
#> 1 0, 0 0.8, 1.0 0, 0
#> 2 0, 0     0, 0 0, 0
#> 3 0, 0     0, 0 0, 0
#> 
#> [[2]]
#>      A        B        C
#> 1 0, 0 0.1, 0.3     0, 0
#> 2 0, 0     0, 0 0.6, 0.8
#> 3 0, 0 0.8, 1.0     0, 0
#> 
```
