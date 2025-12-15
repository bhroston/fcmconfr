# Defuzz (IVFN or TFN)

Convert a fuzzy number to a crisp value. For IVFNs, return the average
of the upper and lower bounds. For TFNs, return the average of the lower
bound, the mode, and the upper bound.

## Usage

``` r
defuzz_ivfn_or_tfn(fuzzy_number)
```

## Arguments

- fuzzy_number:

  \[`ivfn` or `tfn`\] An IVFN or TFN object

## Value

\[`numeric(1)`\]  
A crisp number representative of the input fuzzy number.

## Details

Defuzz-ing an IVFN to a crisp number: \$\$ \left\[ x^{L} ,\\
x^{U}\right\] \\ \mapsto \\ \frac{x^{L} +x^{U}}{2} \$\$ where \\x^{L},
and x^{U}\\ are the lower and upper bounds of the IVFN.

Defuzz-ing a TFN to a crisp number: \$\$ \left\[ x^{L} ,\\ x^{M} ,\\
x^{U}\right\] \\ \mapsto \\ \frac{x^{L} +x^{M} +x^{U}}{3} \$\$

where \\x^{L}, x^{M}, and x^{U}\\ are the lower bound, mode, and upper
bound of the TFN.

## Examples

``` r
defuzz_ivfn_or_tfn(ivfn(-1, 1))
#> [1] 0
defuzz_ivfn_or_tfn(tfn(-1, 0, 1))
#> [1] 0
```
