# print.summary.fcmconfr

This prints a summary object of the fcmconfr output

## Usage

``` r
# S3 method for class 'summary.fcmconfr'
print(x, ...)
```

## Arguments

- x:

  \[`summary.fcmconfr`\]  
  A direct output from the
  [`summary.fcmconfr`](https://bhroston.github.io/fcmconfr/reference/summary.fcmconfr.md)
  function

- ...:

  additional inputs

## Value

A console printout (summary) of fcmconfr results

## Details

Show the objects listed in the fcmconfr output `$inference` and
`$params`, as well as `$bootstrap` if present in output. Additionally,
this prints descriptions/summaries of objects within each sub-list like
inference_opts, bootstrap_input_opts, etc.

## Examples

``` r
NULL
#> NULL
```
