# IVFN Subtraction (Interval Calculus)

This subtracts one Interval-Value Fuzzy Number (IVFN) from another via
interval calculus. An IVFN represented by the interval X:

\$\$X\\ =( x\_{1}, x\_{2}) \\ =\\ \[ x\_{1} ;x\_{2}\] =\\x\in \mathbb{R}
\\ \|\\ x\_{1} \\ \leq x\\ \leq x\_{2}\\\$\$

where \\x_1\\ and \\x_2\\ represent the lower and upper bounds,
respectively.

The IVFN X may have another IVFN Y subtracted from it via:

\$\$X\\ -\\ Y\\ =\\ \[ x\_{1} \\ -\\ y\_{2} ;\\ x\_{2} \\ -\\
y\_{1}\]\$\$

## Usage

``` r
subtract_ivfn(ivfn_1 = ivfn(), ivfn_2 = ivfn())
```

## Arguments

- ivfn_1:

  \[`ivfn`\]  
  An interval-value fuzzy number (ivfn) object

- ivfn_2:

  \[`ivfn`\]  
  An interval-value fuzzy number (ivfn) object

## Value

\[`ivfn`\]  
An IVFN object representing the subtraction of ivfn_2 from ivfn_1

## Details

It is not required for one IVFN to be "greater than" the other.

This difference may also be estimated by translating the IVFN's into
their corresponding distributions (e.g. ivfn(-1, 1) = runif(n, -1, 1)),
subtracting one distribution from the other, and estimating the minimum
and maximum values of the difference distribution.

## References

Moore R, Lodwick W (2003). “Interval Analysis and Fuzzy Set Theory.”
Fuzzy Sets and Systems, 135(1), 5–9. ISSN 01650114,
[doi:10.1016/S0165-0114(02)00246-4](https://doi.org/10.1016/S0165-0114(02)00246-4).

Dimuro GP (2011). “On Interval Fuzzy Numbers.” In 2011 Workshop-School
on Theoretical Computer Science, 3–8. ISBN 978-0-7695-4628-5
978-1-4673-0225-8,
[doi:10.1109/WEIT.2011.19](https://doi.org/10.1109/WEIT.2011.19).

Moore RE (1966). Interval Analysis, volume 4. prentice-Hall Englewood
Cliffs.

## See also

Other interval-valued-fuzzy-numbers:
[`c.ivfn()`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md),
[`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md),
[`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md),
[`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md),
[`print.ivfn()`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md)

## Examples

``` r
subtract_ivfn(ivfn(0.5, 0.8), ivfn(0.2, 0.5))
#> ivfn: [0, 0.6]
subtract_ivfn(ivfn(-0.5, 0.3), ivfn(0.4, 0.6))
#> ivfn: [-1.1, -0.1]
subtract_ivfn(ivfn(-1, 1), ivfn(-0.5, 0.5))
#> ivfn: [-1.5, 1.5]
```
