# Infer FCM

This compares the baseline simulation of an fcm with the input scenario
(scenario vector) to estimate how outputs change compared to the
structural or expected behavior of the system.

## Usage

``` r
infer_fcm(
  adj_matrix = data.frame(),
  initial_state_vector = c(),
  clamping_vector = c(),
  activation = c("kosko", "modified-kosko", "rescale"),
  squashing = c("sigmoid", "tanh"),
  lambda = 1,
  point_of_inference = c("peak", "final"),
  max_iter = 100L,
  min_error = 1e-05,
  skip_checks = FALSE
)
```

## Arguments

- adj_matrix:

  \[`list() or data.frame()`\]  
  A single adjacency matrix (n x n) representing FCMs. An adjacency
  matrix can have conventional edge weights, IVFN edge weights or TFN
  edge weights.

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

- skip_checks:

  \[`logical(1)`\]  
  FOR DEVELOPER USE ONLY. If TRUE, skip call to
  `check_simulation_inputs` (internal function)

## Value

\[`infer_conventional_fcm` or `infer_ivfn_or_tfn_fcm`\]  
A list of FCM inference results (including baseline and simulation
outputs)

## Details

This function performs two fcm simulations and compares the output
between the two. The first simulation considers the baseline activity
where no nodes are "clamped" and the system behaves without any outside
inputs. The second simulation considers a scenario where one or multiple
nodes are "clamped" so that the system is reactive to additional inputs.
The function returns the difference in simulation results between the
scenario and baseline activity to understand how system manipulations
compare to structural expectations of the system.

This function produces the same output as mental modeler for the
following inputs:

- initial_state_vector = c(1, 1, ..., 1)

- activation = "kosko"

- squashing = either "sigmoid" or "tanh"

- lambda = 1

## Examples

``` r
# # Inference w/ Conventional FCMs
conventional_inference <- infer_fcm(sample_fcms$simple_fcms$conventional_fcms[[4]],
                                    initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                                    clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                                    activation = "modified-kosko",
                                    squashing = "sigmoid",
                                    lambda = 1.0,
                                    point_of_inference = "final",
                                    max_iter = 100L,
                                    min_error = 1e-5,
                                    skip_checks = FALSE)


# # Inference w/ Interval-Valued Fuzzy Numbers (IVFNs)
ivfn_inference <- infer_fcm(sample_fcms$simple_fcms$ivfn_fcms[[4]],
                            initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                            clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                            activation = "kosko",
                            squashing = "tanh",
                            lambda = 1.0,
                            point_of_inference = "final",
                            max_iter = 100L,
                            min_error = 1e-5,
                            skip_checks = FALSE)
#

# # Inference w/ Triangular Fuzzy Numbers (TFNs)
tfn_inference <- infer_fcm(sample_fcms$simple_fcms$tfn_fcms[[4]],
                           initial_state_vector = c(1, 1, 1, 1, 1, 1, 1),
                           clamping_vector = c(1, 0, 0, 0, 0, 0, 0),
                           activation = "rescale",
                           squashing = "sigmoid",
                           lambda = 1.0,
                           point_of_inference = "final",
                           max_iter = 100L,
                           min_error = 1e-5,
                           skip_checks = FALSE)
```
