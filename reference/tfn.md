# Triangular Fuzzy Number (TFN) - S3 Class

This constructs an triangular fuzzy number (tfn) that represents a
continuous, triangular distribution of values within a given range

## Usage

``` r
tfn(lower = double(), mode = double(), upper = double())
```

## Arguments

- lower:

  \[`double(1)` - Unrestriced (positive or negative)\]  
  The lower limit of a Triangular Number set (the lower value must be
  less than or equal to the upper value)

- mode:

  \[`double(1)` - Unrestriced (positive or negative)\]  
  The most likely value of a Triangular Number set

- upper:

  \[`double(1)` - Unrestriced (positive or negative)\]  
  The upper limit of a Triangular Number set (the upper value must be
  greater or equal to the lower value)

## Value

\[`tfn`\]  
A triangular fuzzy number (TFN)

## Details

The TFN class does not perform any operations on its input, rather it
checks whether the input follows the defining criteria of TFNs

For TFNs, the lower bound must be less than or equal to the mode which
must be less than or equal to the upper bound. If the lower bound, mode,
and upper bound are equal, the TFN represents a "crisp" numeric value.

\$\$ \mathbf{TFN} :\\ \left\[ x^{L} ,\\ x^{M} ,\\ x^{U}\right\] \$\$
where \\x^{L}\\, \\x^{M}\\, and \\x^{U}\\ are the lower bound, mode, and
upper bound of the TFN.

## References

Chakraverty S, Sahoo DM, Mahato NR (2019). “Fuzzy Numbers.” In Concepts
of Soft Computing, 53–69. Springer Singapore, Singapore. ISBN
9789811374296,
[doi:10.1007/978-981-13-7430-2_3](https://doi.org/10.1007/978-981-13-7430-2_3).

Hanss M (ed.) (2005). Applied Fuzzy Arithmetic: An Introduction with
Engineering Applications, SpringerLink B\\ucher. Springer-Verlag Berlin
Heidelberg, Berlin, Heidelberg. ISBN 978-3-540-24201-7,
[doi:10.1007/b138914](https://doi.org/10.1007/b138914).

Trillas E, Eciolaza L (2015). “Fuzzy Logic.” In volume 320, chapter
Fuzzy Arithmetic, 141–158. Springer International Publishing, Cham. ISBN
978-3-319-14202-9,
[doi:10.1007/978-3-319-14203-6_6](https://doi.org/10.1007/978-3-319-14203-6_6)

## See also

Other triangular-fuzzy-numbers:
[`create_tfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_tfn_fcm_from_conventional_fcm.md),
[`make_adj_matrix_w_tfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_tfns.md),
[`print.tfn()`](https://bhroston.github.io/fcmconfr/reference/print.tfn.md),
[`subtract_tfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_tfn.md)

## Examples

``` r
tfn(lower = -1.0, mode = 0.0, upper = 1.0)
#> tfn: [-1, 0, 1]
tfn(0, 0.5, 0.8)
#> tfn: [0, 0.5, 0.8]
tfn(-0.3, 0.1, 0.4)
#> tfn: [-0.3, 0.1, 0.4]
```
