# c.ivfn

This forces the output of c() to the equivalent of list() only for
inputs of type ivfn

## Usage

``` r
# S3 method for class 'ivfn'
c(...)
```

## Arguments

- ...:

  a set of ivfn objects

## Value

\[[`list()`](https://rdrr.io/r/base/list.html)\]  
A list of ivfn objects

## Details

For ivfn objects, c() combines all of the lower and upper data into a
single ivfn object, but list() returns the expected output of a list of
distinct ivfn objects.

## See also

Other interval-valued-fuzzy-numbers:
[`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md),
[`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md),
[`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md),
[`print.ivfn()`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md),
[`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)

## Examples

``` r
c(ivfn(0, 1), ivfn(0.2, 0.5))
#> [[1]]
#> ivfn: [0, 1]
#> [[2]]
#> ivfn: [0.2, 0.5]
```
