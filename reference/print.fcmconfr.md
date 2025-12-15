# print.fcmconfr

This improves the readability of the fcmconfr output

## Usage

``` r
# S3 method for class 'fcmconfr'
print(x, ...)
```

## Arguments

- x:

  \[`fcmconfr`\]  
  A direct output from the
  [`fcmconfr`](https://bhroston.github.io/fcmconfr/reference/fcmconfr.md)
  function

- ...:

  additional inputs

## Value

A console printout of fcmconfr results

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
