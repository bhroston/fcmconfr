# TFN Subtraction (Interval Calculus)

This subtracts one Triangular Fuzzy Number (TFN) from another via
interval calculus. A TFN represented by the fuzzy set (triangular
distribution):

\$\$X\\ =( x\_{1} ,x\_{2} ,x\_{3}) \\ =\\ \left\\\begin{matrix} 0 &
for\\ & x\< x\_{1}\\ \frac{2( x\\ -\\ x\_{1})}{( x\_{3} -x\_{1})( x\_{2}
-x\_{1})} & for\\ & x\_{1} \leq x\< x\_{3} \\ \\ \frac{2}{x\_{3}
-x\_{1}} & for & x\\ =\\ x\_{2}\\ \frac{2( x\_{3} -x)}{( x\_{3}
-x\_{1})( x\_{3} -x\_{2})} & for\\ & x\_{2} \< x\leq x\_{3}\\ 0 & for &
x \>x\_{3} \end{matrix}\right.\$\$

where \\x_1\\ and \\x_3\\ are the lower and upper bounds, respectively,
and \\x_2\\ is the mode.

The TFN X may have another TFN Y subtracted from it via:

\$\$X\\ -\\ Y\\ =\\ ( x\_{1} -y\_{3} ,\\ x\_{2} -y\_{2} ,\\ x\_{3}
-y\_{1})\$\$

## Usage

``` r
subtract_tfn(tfn_1 = tfn(), tfn_2 = tfn())
```

## Arguments

- tfn_1:

  \[`tfn`\]  
  A triangular fuzzy number (tfn) object

- tfn_2:

  \[`tfn`\]  
  A triangular fuzzy number (tfn) object

## Value

\[`tfn`\]  
An TFN object representing the subtraction of tfn_2 from tfn_1

## Details

It is not required for one IVFN to be "greater than" the other.

This difference may also be estimated by translating the TFN's into
their corresponding distributions (e.g. tfn(-1, 0, 1) =
EnvStats::rtri(n, min = -1, max = 1, mode = 0)), subtracting one
distribution from the other, and estimating the minimum, mode, and
maximum values of the difference distribution.

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
[`tfn()`](https://bhroston.github.io/fcmconfr/reference/tfn.md)

## Examples

``` r
subtract_tfn(tfn(lower = 0.5, mode = 0.6, upper = 0.8), tfn(lower = 0.2, mode = 0.3, upper = 0.5))
#> tfn: [0, 0.3, 0.6]
subtract_tfn(tfn(-0.5, -0.2, 0.3), tfn(0.4, 0.5, 0.6))
#> tfn: [-1.1, -0.7, -0.1]
subtract_tfn(tfn(-1, 0, 1), tfn(-0.5, 0, 0.5))
#> tfn: [-1.5, 0, 1.5]
```
