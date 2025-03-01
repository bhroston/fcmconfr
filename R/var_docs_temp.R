#'
#'
#' #' adj_matrices
#' #'
#' #' @param adj_matrices \[`list()`]\cr A single adjacency matrix or a list of
#' #' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' #' edge weights, IVFN edge weights or TFN edge weights.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' agg_function
#' #'
#' #' @param agg_function \[`character(1)`]\cr Choice of aggregation method (mean, median) for
#' #' producing a single "collective" FCM from a group of individual FCMs. Omit
#' #' this argument when analyzing a single FCM.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #     return(NULL)
#' #   }
#'
#'
#' #' num_mc_fcms
#' #'
#' #' @param num_mc_fcms \[`integer(1)`]\cr Number of inferences to generate via Monte Carlo sampling.
#' #' Omit this argument when analyzing a single, conventional FCM.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#'
#' #' initial_state_vector
#' #'
#' #' @param initial_state_vector \[`vector("numeric")`]\cr A list of state values
#' #' (one per node) at the start of an FCM simulation. In pulse simulations the
#' #' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' #' is a transient perturbation). In clamped simulations all values in the
#' #' \code{initial_state_vector} are set to 1.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' clamping_vector
#' #' @param clamping_vector \[`vector("numeric")`]\cr A list of values (one per node)
#' #' that indicates whether clamped simulations will be performed. In clamped
#' #' simulations the \code{clamping_vector} controls the scenario (nodes assigned
#' #'  non-zero values will remain at those values for the entire simulation).
#' #'  In pulse simulations all values in the \code{clamping_vector} are set to 0.
#' #'
#' #'  @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' activation
#' #' @param activation \[`character()`]\cr The activation function used. Must be
#' #'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' #'
#' #'  @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' squashing
#' #'
#' #' @param squashing \[`character()`]\cr The squashing function used. Must be
#' #' one of the following: 'tanh' or 'sigmoid'.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' lambda
#' #'
#' #' @param lambda \[`double(1)`]\cr A numeric value that defines the steepness
#' #' of the squashing function's slope. Should be a positive number.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' point_of_inference
#' #'
#' #' @param point_of_inference \[`character()`]\cr Definition of an inference.
#' #' The metric used to calculate  the response of each node to a scenario of
#' #' interest from a simulation timeseries. Must be one of the following: 'peak'
#' #' (the maximum value) or 'final' (the state at equilibrium).
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' max_iter
#' #'
#' #' @param max_iter \[`integer(1)`]\cr The maximum
#' #' number of iterations to run (increase if the minimum error value is not
#' #' achieved). Should be a positive integer.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' # return(NULL)
#' # }
#'
#' #' min_error
#' #'
#' #' @param min_error \[`double(1)`]\cr The error past
#' #' which a simulation has converged and no further iterations are necessary.
#' #' \emph{Error equals the sum of the absolute value of the current state vector
#' #' minus the previous state vector}. Should be a positive number.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' parallel
#' #'
#' #' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel
#' #' processing.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' n_cores
#' #'
#' #' @param n_cores \[`integer(1)`]\cr The number of
#' #' cores to use in parallel processing. If no input given, all available cores
#' #' will be used. Should be a positive integer.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' show_progress
#' #'
#' #' @param show_progress \[`logical(1)`]\cr If TRUE, show progress
#' #' bars and print runtime updates in the console when performing FCM simulations.
#' #'
#' #' @export
#' test_fun <- function(adj_matrices) {
#'   return(NULL)
#' }
#'
#'
#' #' include_sims_in_output
#' #'
#' #' @param include_sims_in_output \[`logical(1)`]\cr If TRUE, include Monte Carlo
#' #' FCMs in addition to Monte Carlo simulations and inferences in fcmconfr
#' #' output. Set to FALSE to reduce output size.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#' #' run_ci_calcs
#' #'
#' #' @param run_ci_calcs If TRUE, estimate bootstrapped confidence bounds about
#' #' the central tendency of Monte Carlo inferences.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #     return(NULL)
#' #   }
#'
#'
#'
#' #' include_zeroes_in_sampling
#' #'
#' #' @param include_zeroes_in_sampling If TRUE, incorporate zero-weighted edges
#' #' during FCM aggregation and Monte Carlo sampling.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#'
#' #' include_sims_in_output
#' #'
#' #' @param include_sims_in_output If TRUE, include simulations and inferences in
#' #' fcmconfr output. Set to FALSE to reduce output size.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#'
#'
#' #' silent
#' #'
#' #' @param silent \[`logical(1)`]\cr If TRUE, suppress warning
#' #' and error messages.
#' #'
#' #' @export
#' # test_fun <- function(adj_matrices) {
#' #   return(NULL)
#' # }
#'
#' #' skip_checks
#' #'
#' #' @param skip_checks \[`logical(1)`]\cr FOR DEVELOPER USE ONLY. If TRUE, skip
#' #' call to \code{\link{check_simulation_inputs}} (internal function)
#' #'
#' #' @export
#' test_fun <- function(adj_matrices) {
#'   return(NULL)
#' }
#'
#' #' @param concepts A list of names for each node (must have n items). If empty, will use
#' #' column names of adjacancy matrix (if given).
#'
#' #' @param fuzzy_set_matrix A matrix that contains fuzzy sets as elements
#'
#' #' @param object_class Values are represented either as ivfns or tfns. Options: 'ivfn' or 'tfn'
#'
#' #' @param N_samples The number of samples to draw from the corresponding distribution
#'
#' #' @param desired_class Transform the element into an 'ivfn' or 'tfn'
