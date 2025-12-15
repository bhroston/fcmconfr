# Interval-Valued Fuzzy Number (IVFN) - S3 Class

This constructs an interval-valued fuzzy number (ivfn) that represents a
continuous, uniform distribution of values within a given range

## Usage

``` r
ivfn(lower = double(), upper = double())
```

## Arguments

- lower:

  \[[`double()`](https://rdrr.io/r/base/double.html) - Unrestriced
  (positive or negative)\]  
  The lower bound of an IVFN

- upper:

  \[[`double()`](https://rdrr.io/r/base/double.html) - Unrestriced
  (positive or negative)\]  
  The upper bound of an IVFN

## Value

\[`ivfn`\]  
An interval-valued fuzzy number (IVFN)

## Details

The IVFN class does not perform any operations on its input, rather it
checks whether the input follows the defining criteria of IVFNs

For IVFNs, the lower bound must be less than or equal to the upper
bound. If the lower bound and upper bound are equal, the IVFN represents
a "crisp" numeric value.

\$\$ \mathbf{IVFN} :\\ \left\[ x^{L} ,\\ x^{U}\right\] \$\$ where
\\x^{L}\\ and \\x^{U}\\ are the lower and upper bounds of the IVFN.

## References

Moore R, Lodwick W (2003). “Interval Analysis and Fuzzy Set Theory.”
Fuzzy Sets and Systems, 135(1), 5–9. ISSN 01650114,
[doi:10.1016/S0165-0114(02)00246-4](https://doi.org/10.1016/S0165-0114(02)00246-4).

Dimuro GP (2011). “On Interval Fuzzy Numbers.” In 2011 Workshop-School
on Theoretical Computer Science, 3–8. ISBN 978-0-7695-4628-5
978-1-4673-0225-8,
[doi:10.1109/WEIT.2011.19](https://doi.org/10.1109/WEIT.2011.19).

## See also

Other interval-valued-fuzzy-numbers:
[`c.ivfn()`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md),
[`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md),
[`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md),
[`print.ivfn()`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md),
[`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)

## Examples

``` r
ivfn(lower = 0.0, upper = 1.0)
#> ivfn: [0, 1]
ivfn(-1.0, 1.0)
#> ivfn: [-1, 1]
```
