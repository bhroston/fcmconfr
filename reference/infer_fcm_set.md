# Infer Multiple FCMs in a List

This function simulates a set of FCMs (Conventional, IVFN, and/or TFN)
(whose edge weights were sampled using monte carlo methods) by
iteratively calling the infer_fcm function for each adj. matrix in the
set.

## Usage

``` r
infer_fcm_set(
  adj_matrices = list(matrix()),
  initial_state_vector = c(),
  clamping_vector = c(),
  activation = c("kosko", "modified-kosko", "rescale"),
  squashing = c("sigmoid", "tanh"),
  lambda = 1,
  point_of_inference = c("peak", "final"),
  max_iter = 100L,
  min_error = 1e-05,
  parallel = TRUE,
  n_cores = 1L,
  show_progress = TRUE,
  include_sims_in_output = FALSE,
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

- initial_state_vector:

  \[`vector("double")`\]  
  A list of state values (one per node) at the start of an FCM
  simulation. In pulse simulations the `initial_state_vector` controls
  the scenario (i.e., a non-zero value is a transient perturbation). In
  clamped simulations all values in the `initial_state_vector` are set
  to 1.

- clamping_vector:

  \[`vector("double")`\]  
  A list of values (one per node) that indicates whether clamped
  simulations will be performed. In clamped simulations the
  `clamping_vector` controls the scenario (nodes assigned non-zero
  values will remain at those values for the entire simulation). In
  pulse simulations all values in the `clamping_vector` are set to 0.

- activation:

  \[`character(1)`\]  
  The activation function used. Must be one of the following: 'kosko',
  'modified-kosko', or 'rescale'.

- squashing:

  \[`character(1)`\]  
  The squashing function used. Must be one of the following: 'tanh' or
  'sigmoid'.

- lambda:

  \[`double(1)`\] Positive  
  A numeric value that defines the steepness of the squashing function's
  slope.

- point_of_inference:

  \[`character(1)`\]  
  Definition of an inference. The metric used to calculate the response
  of each node to a scenario of interest from a simulation timeseries.
  Must be one of the following: 'peak' (the maximum value) or 'final'
  (the state at equilibrium).

- max_iter:

  \[`integer(1)` - Positive\]  
  The maximum number of iterations to run (increase if the minimum error
  value is not achieved).

- min_error:

  \[`double(1)` - Positive\]  
  The error past which a simulation has converged and no further
  iterations are necessary. *Error equals the sum of the absolute value
  of the current state vector minus the previous state vector*.

- parallel:

  \[`logical(1)`\]  
  If TRUE, utilize parallel processing.

- n_cores:

  \[`integer(1)` - Positive\]  
  The number of cores to use in parallel processing. If no input given,
  all available cores will be used. Should be a positive integer.

- show_progress:

  \[`logical(1)`\]  
  If TRUE, show progress bars and print runtime updates in the console
  when performing FCM simulations.

- include_sims_in_output:

  \[`logical(1)`\]  
  If TRUE, include simulations and inferences in output. Set to FALSE to
  reduce output size.

- silent:

  \[`logical(1)`\]  
  If TRUE, suppress warning and error messages.

- skip_checks:

  \[`logical(1)`\]  
  FOR DEVELOPER USE ONLY. If TRUE, skip call to
  `check_simulation_inputs` (internal function)

## Value

\[`inference_of_fcm_set`\]  
A list/data.frame of the inferences (and simulations if included) for
each FCM in the set

## Details

The show_progress and parallel inputs change how the function is run,
but do NOT change the output! These are allowed to be toggled on/off to
improve user control at runtime.

## Examples

``` r
# Set of Conventional FCMs
conventional_fcm_set_inferences <- infer_fcm_set(
  adj_matrices = sample_fcms$simple_fcms$conventional_fcms[1:5],
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = "modified-kosko",
  squashing = "sigmoid",
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-5,
  parallel = FALSE,
  n_cores = 1L,
  show_progress = FALSE,
  include_sims_in_output = TRUE,
  silent = FALSE,
  skip_checks = FALSE
)

# Set of IVFN FCMs
ivfn_fcm_set_inferences <- infer_fcm_set(
  adj_matrices = sample_fcms$simple_fcms$ivfn_fcms[1:5],
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = "modified-kosko",
  squashing = "sigmoid",
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-5,
  parallel = FALSE,
  n_cores = 1L,
  show_progress = FALSE,
  include_sims_in_output = TRUE,
  silent = FALSE,
  skip_checks = FALSE
)

# Set of TFN FCMs
tfn_fcm_set_inferences <- infer_fcm_set(
  adj_matrices = sample_fcms$simple_fcms$tfn_fcms[1:5],
  initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
  clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
  activation = "modified-kosko",
  squashing = "sigmoid",
  lambda = 1.0,
  point_of_inference = "final",
  max_iter = 100L,
  min_error = 1e-5,
  parallel = FALSE,
  n_cores = 1L,
  show_progress = FALSE,
  include_sims_in_output = TRUE,
  silent = FALSE,
  skip_checks = FALSE
)
```
