# summary.fcmconfr

This creates a summary object of the fcmconfr output

## Usage

``` r
# S3 method for class 'fcmconfr'
summary(object, ...)
```

## Arguments

- object:

  \[`fcmconfr`\]  
  A direct output from the
  [`fcmconfr`](https://bhroston.github.io/fcmconfr/reference/fcmconfr.md)
  function

- ...:

  additional inputs

## Value

A summary object of fcmconfr results

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
