# Print an Interval-Valued Fuzzy Number (IVFN) - S3 Class

This prints an ivfn object

## Usage

``` r
# S3 method for class 'ivfn'
print(x, ...)
```

## Arguments

- x:

  \[`ivfn`\]  
  a ivfn object

- ...:

  additional inputs

## Value

\[`NULL`\]  
A console printout of an IVFN object

## See also

Other interval-valued-fuzzy-numbers:
[`c.ivfn()`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md),
[`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md),
[`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md),
[`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md),
[`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)

## Examples

``` r
print(ivfn(-1, 1))
#> ivfn: [-1, 1]
```
