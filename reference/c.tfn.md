# c.tfn

This forces the output of c() to the equivalent of list() only for
inputs of type tfn

## Usage

``` r
# S3 method for class 'tfn'
c(...)
```

## Arguments

- ...:

  a set of tfn objects

## Value

a list of tfn objects

## Details

For tfn objects, c() combines all of the lower, mode, and upper data
into a single tfn object, but list() returns the expected output of a
list of distinct tfn objects.

## Examples

``` r
c(tfn(0, 0.5, 1), tfn(0.2, 0.4, 0.5))
#> [[1]]
#> tfn: [0, 0.5, 1]
#> [[2]]
#> tfn: [0.2, 0.4, 0.5]
```
