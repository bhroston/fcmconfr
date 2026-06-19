# Build Monte Carlo FCMs

This function generates N fcm adjacency matrices whose edge weights are
sampled from edge values (that may be numeric, IVFNs, or TFNs) and
stores them as a list of adjacency matrices.

The show_progress and parallel inputs change the functions called, but
do NOT change the output! These are allowed to be toggled on/off to
improve user control at runtime.

## Usage

``` r
build_monte_carlo_fcms(
  adj_matrices = list(),
  n_samples = 1000L,
  include_zeroes_in_sampling = TRUE,
  show_progress = TRUE,
  silent = FALSE,
  skip_checks = FALSE
)
```

## Arguments

- adj_matrices:

  \[[`list()`](https://rdrr.io/r/base/list.html)\]  
  A single adjacency matrix or a list of adjacency matrices (n x n)
  representing FCMs. Matrices can have conventional edge weights, IVFN
  edge weights or TFN edge weights.

- n_samples:

  \[[`integer()`](https://rdrr.io/r/base/integer.html) - Positive\]  
  The number of samples to draw with the selected sampling method. Also,
  the number of sampled models to generate.

- include_zeroes_in_sampling:

  \[`logical(1)`\]  
  If TRUE, incorporate zero-weighted edges during Monte Carlo sampling.

- show_progress:

  \[`logical(1)`\]  
  If TRUE, show progress bars and print runtime updates in the console
  when performing FCM simulations.

- silent:

  \[`logical(1)`\]  
  If TRUE, suppress warning and error messages.

- skip_checks:

  \[`logical(1)`\]  
  FOR DEVELOPER USE ONLY. If TRUE, skip call to
  `check_simulation_inputs` (internal function)

## Value

\[[`list()`](https://rdrr.io/r/base/list.html)\]  
A list of empirical (Conventional) FCM adj. matrices generated via monte
carlo methods

## Details

For Conventional FCMs, edge weights are sampled from edge weights
explicitly defined in the input FCMs.

For IVFN and TFN FCMs, edge weights are sampled from the combined
distributions representative of the IVFN/TFN edge weights. For example,
if an edge is given the following weights across two maps: \[0.4,
0.8)\]\\ and \[0.5, 0.7\]\\ the samples will be drawn from the combined
distribution: sample(N, c(runif(N, 0.4, 0.8), runif(N, 0.5, 0.7)),
replace = TRUE).

## Examples

``` r

# Conventional FCMs
conventional_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$conventional_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)

# IVFN FCMs
ivfn_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$ivfn_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)

# TFN FCMs
tfn_mc_fcms <- build_monte_carlo_fcms(
  adj_matrices = sample_fcms$simple_fcms$tfn_fcms[1:10],
  n_samples = 1000,
  include_zeroes_in_sampling = TRUE,
  show_progress = FALSE,
  silent = FALSE,
  skip_checks = FALSE
)

```
