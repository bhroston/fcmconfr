# Print a Triangular Fuzzy Number (TFN)

This improves the readability of the output

This prints a tfn object

## Usage

``` r
# S3 method for class 'tfn'
print(x, ...)
```

## Arguments

- x:

  a tfn object

- ...:

  additional inputs

## Value

A console printout of a TFN object

## See also

Other triangular-fuzzy-numbers:
[`create_tfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_tfn_fcm_from_conventional_fcm.md),
[`make_adj_matrix_w_tfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_tfns.md),
[`subtract_tfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_tfn.md),
[`tfn()`](https://bhroston.github.io/fcmconfr/reference/tfn.md)

## Examples

``` r
tfn(-1, 0, 1)
#> tfn: [-1, 0, 1]
```
