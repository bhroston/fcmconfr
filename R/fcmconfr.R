
################################################################################
# fcmconfr.R
#
# This contains the primary fcmconfr() function and the get_fcmconfr_inferences()
# function.
#
#   - fcmconfr
#   - get_fcmconfr_inferences
#   - check_fcmconfr_inputs
#   - organize_fcmconfr_output
#   - summary.fcmconfr
#   - print.summary.fcmconfr
#   - print.fcmconfr
#
################################################################################

# rOpenSci Statistical Software Standards ----
#' @srrstats {EA4.2} Primary fcmconfr object features corresponding plot
#' and print functions
#' @noRd
NULL
# ----



#' fcmconfr
#'
#' @description
#' This is the primary function of the fcmconfr package. This function performs
#' the following three analyses on input fuzzy cognitive maps (FCMs).
#'
#' \enumerate{
#'    \item Dynamic Simulation: The dynamic behvaior of one or more input FCMs
#'    is evaluated in response to a perturbation. Two types of simulations can
#'    be performed, pulse and clamped.
#'    \itemize{
#'        \item Pulse: In pulse simulations one or more nodes are transiently
#'        perturbed (the scenario) and allowed to relax back to equilibrium
#'        over multiple iterations to understand the effect those nodes have
#'        on the network. Scenarios are established using the initial state
#'        vector (non-zero values perturb a node). All values in the clamping
#'        vector must be set to zero (Stylios, 1997).
#'        \item Clamped: In clamped simulations, one or more nodes of interest
#'        are continuously activated (the scenario) and the result is compared
#'        to baseline conditions. Scenarios are established using the clamping
#'        vector (non-zero values clamp a node) and the baseline is
#'        established by setting all nodes in the initial state vector to one
#'        (i.e., it represents the response of the network to a transient
#'        pulse event involving all nodes) (Ozesmi & Ozesmi, 2003).
#'    }
#'    The final response of each node of an FCM in a scenario-of-interest is
#'    known as an inference. Inferences can be calculated using the maximum
#'    (peak) or the final resting state (final) of a node. In pulse simulations
#'    inferences are the difference between either of these two measures and
#'    zero. In clamped simulations inferences are the difference between either
#'    of these measures in the scenario-of-interest and their equivalent values
#'    in the baseline simulation. Simulations can be run using different
#'    activation functions (Kosko, Modified-Kosko, or Rescale) and squashing
#'    functions (sigmoid, tanh)
#'
#'    Conventional FCM simulations use the traditional FCM simulation algorithm
#'    as established in Kosko (1986); Stylios (1997); Ozesmi & Ozesmi (2003),
#'    etc. (See Details for equations)
#'
#'    IVFN- and TFN-FCM simulations use the algorithm from Yesil et al. (2014)
#'    where average values of IVFN and TFN elements in state vectors are passed
#'    to the IVFN- or TFN-FCM adjacency matrix. (See Details for equations)
#'
#'    \item Model Aggregation: Generates a single "collective" adjacency matrix
#'    from a list of adjacency matrices. Aggregation is performed by calculating
#'    the mean/median edge weight for all edges included in a set of input FCMs
#'    (i.e. the mean/median of the edge weight connecting A->B across all maps,
#'    the mean/median of the edge weight connecting B->C across all maps, and
#'    so on) (Aminpour et al., 2020). The user specifies whether 0-valued edge
#'    weights (reflecting the absence of a connection between two nodes)
#'    shouldbe included when calculating the mean/median.
#'
#'    \emph{Aggregate analysis can be toggled off to reduce runtime.}
#'
#'    \item Monte Carlo Analysis: This method assesses uncertainty in dynamic
#'    simulations by generating a distribution of possible inferences. Edge
#'    weights are randomly sampled fro input FCMs to construct a set of \eqn{N}
#'    Monte Carlo FCMs. Each FCM undergoes dyamic simulation, producing \eqn{N}
#'    inferences per node. These inferences represent the range of possible
#'    values each node may assume, providing a way to quantify uncertainty.
#'
#'    Min, Max, Median, and 25th/75th quantiles are estimated for each node.
#'    Bootstrapping (optional) can also be performed to estimat 95% confidence
#'    bounds about the mean or median inference for each node.
#'
#'    \emph{Monte Carlo analysis can be toggled off to reduce runtime.}
#' }
#'
#' \code{fcmconfr} can accommodate three types of FCMs. Note that each FCM type
#' must be analyzed separately (i.e. they cannot be co-evaluated in a single
#' input set). The three supported types of FCMs include:
#'
#' \enumerate{
#'    \item Conventional FCMs, where edge weights are single-valued fuzzy
#'    numbers (Stylios, 1997).
#'    \item Interval-Valued Fuzzy Number (IVFN) FCMs, which are an extension
#'    of conventional FCMs. IVFN-FCMs represent edge weights as ranges
#'    \[min, max]\, where any value within the range is as likely as any other
#'    (i.e., the probability distribution for each edge is uniform)
#'    (Moore & Lodwick, 2003; Hajek & Prochazka, 2016); and
#'    \item Triangular Fuzzy Number (TFN) FCMs, which are an extension of
#'    IVFN-FCMs. TFN-FCMs also represent edge weights as ranges, but assume
#'    that one value within the range (the mode) is more likely than any other
#'    (i.e., the probability distribution for each edge is triangular)
#'    (Yesil et al., 2014).
#' }
#'
#' The fcmcofnr package includes \code{fcmconfr_gui}, an interactive GUI tool
#' that can be used to help select appropriate values for each argument in
#' \code{fcmconfr()}.
#'
#' @references Özesmi U, Özesmi S (2003). “A Participatory Approach to Ecosystem
#' Conservation: Fuzzy Cognitive Maps and Stakeholder Group Analysis in Uluabat
#' Lake, Turkey.” Environmental Management, 31(4), 518–531. ISSN 0364-152X,
#' 1432-1009, [doi:10.1007/s00267-002-2841-1](https://doi.org/10.1007/s00267-002-2841-1).
#'
#' @references Aminpour P, Gray SA, Jetter AJ, Introne JE, Singer A, Arlinghaus R (2020).
#' “Wisdom of Stakeholder Crowds in Complex Social–Ecological Systems.” Nature
#' Sustainability, 3(3), 191–199. ISSN 2398-9629, [doi:10.1038/s41893-019-0467-z](https://doi.org/10.1038/s41893-019-0467-z).
#'
#' @references Stylios CD, Georgopoulos VC, Groumpos PP (1997). “Introducing the
#' Theory of Fuzzy Cognitive Maps in Distributed Systems.” In Proceedings of
#' 12th IEEE International Symposium on Intelligent Control, 55–60.
#' [doi:10.1109/ISIC.1997.626413](https://doi.org/10.1109/ISIC.1997.626413).
#'
#' @references Moore R, Lodwick W (2003). “Interval Analysis and Fuzzy Set
#' Theory.” Fuzzy Sets and Systems, 135(1), 5–9. ISSN 01650114,
#' [doi:10.1016/S0165-0114(02)00246-4](https://doi.org/10.1016/S0165-0114(02)00246-4).
#'
#' @references Hajek P, Prochazka O (2016). “Interval-valued fuzzy cognitive
#' maps for supporting business decisions.” In 2016 IEEE International
#' Conference on Fuzzy Systems (FUZZ-IEEE), 531–536. ISBN 978-1-5090-0626-7,
#' [doi:10.1109/FUZZ-IEEE.2016.7737732](https://doi.org/10.1109/FUZZ-IEEE.2016.7737732),
#'
#' @references Yesil E, Dodurka MF, Urbas L (2014). “Triangular fuzzy number
#' representation of relations in Fuzzy Cognitive Maps.” In 2014 IEEE
#' International Conference on Fuzzy Systems (FUZZ-IEEE), 1021–1028. ISBN
#' 9781479920723, [doi:10.1109/FUZZ-IEEE.2014.6891653](https://doi.org/10.1109/FUZZ-IEEE.2014.6891653),
#'
#' @references Stylios CD, Groumpos PP (2004). “Modeling complex systems using
#' fuzzy cognitive maps.” IEEE Transactions on Systems, Man, and Cybernetics -
#' Part A: Systems and Humans, 34(1), 155–162. ISSN 1558-2426,
#' [doi:10.1109/TSMCA.2003.818878](https://doi.org/10.1109/TSMCA.2003.818878),
#'
#' @references Papageorgiou EI (2011). “A new methodology for Decisions in
#' Medical Informatics using fuzzy cognitive maps based on fuzzy rule-extraction
#' techniques.” Applied Soft Computing, 11(1), 500–513. ISSN 1568-4946,
#' [doi:10.1016/j.asoc.2009.12.010](https://doi.org/10.1016/j.asoc.2009.12.010),
#'
#' @references Dikopoulou Z (2021). “Fuzzy Cognitive Maps.” In Dikopoulou Z
#' (ed.), Modeling and Simulating Complex Business Perceptions : Using Graphical
#' Models and Fuzzy Cognitive Maps, 27–42. Springer International Publishing,
#' Cham. ISBN 9783030814960, [doi:10.1007/978-3-030-81496-0_3](https://doi.org/10.1007/978-3-030-81496-0_3),
#'
#' @details
#' FCM simulations are iterative applications of an activation function
#' (\eqn{f_{A}}) that describes how node values at a particular state
#' (\eqn{C^{(t)}}) are influenced by the edge weights defined in the
#' adjacency matrix (\eqn{w}) to calculate the node values at the following
#' state (\eqn{C^{(t+1)}}), and a squashing function (\eqn{f_{S}}) that
#' restricts node values within a particular range.
#'
#' In conventional FCM simulations the current state vector (\eqn{C^{(t)}}) is
#' used to calculate the next state vector (\eqn{C^{(t+1)}}).
#' \deqn{
#' C_{i}^{( t+1)} =f_{S}\left( f_{A}\left( w,\ C_{i}^{( t)}\right)\right)
#' }
#'
#' In IVFN- and TFN-FCM simulations, the current state vector has to be
#' translated into crisp values prior to calculating the next state vector.
#'
#' Formulas for crisp values:
#' \deqn{
#' \left(\overline{C}_{i}^{( t)}\right)_{IVFN} =\frac{\left( C_{i}^{( t)}\right)_{lower} +\left( C_{i}^{( t)}\right)_{upper}}{2}
#' }
#' \deqn{
#' \left(\overline{C}_{i}^{( t)}\right)_{TFN} =\frac{\left( C_{i}^{( t)}\right)_{lower} +\left( C_{1}^{( t)}\right)_{mode} +\left( C_{i}^{( t)}\right)_{upper}}{3}
#' }
#'
#' Formulas for next state vector:
#' \deqn{
#' \left( C_{i}^{( t+1)}\right)_{IVFN} =\left[\left( C_{i}^{( t+1)}\right)_{lower} ,\ \left( C_{i}^{( t+1)}\right)_{upper}\right] \ where\ \left\{\begin{array}{ c }
#' \left( C_{i}^{( t+1)}\right)_{lower} =f_{S}\left( f_{A}\left( w_{lower} ,\ \overline{C}_{i}^{( t)}\right)\right)\\
#' \left( C_{i}^{( t+1)}\right)_{upper} =f_{S}\left( f_{A}\left( w_{upper} ,\ \overline{C}_{i}^{( t)}\right)\right)
#' \end{array}\right.
#' }
#'
#' \deqn{
#' \left( C_{i}^{( t+1)}\right)_{TFN} =\left[\left( C_{i}^{( t+1)}\right)_{lower} ,\ \left( C_{i}^{( t+1)}\right)_{upper}\right] \ where\ \left\{\begin{array}{ c }
#' \left( C_{i}^{( t+1)}\right)_{lower} =f_{S}\left( f_{A}\left( w_{lower} ,\ \overline{C}_{i}^{( t)}\right)\right)\\
#' \left( C_{i}^{( t+1)}\right)_{mode} =f_{S}\left( f_{A}\left( w_{mode} ,\ \overline{C}_{i}^{( t)}\right)\right)\\
#' \left( C_{i}^{( t+1)}\right)_{upper} =f_{S}\left( f_{A}\left( w_{upper} ,\ \overline{C}_{i}^{( t)}\right)\right)
#' \end{array}\right.
#' }
#'
#' \code{fcmconfr} supports the Kosko, Modified-Kosko, and Rescale activation
#' functions as defined here:
#'
#' \itemize{
#'    \item Kosko (Kosko, 1986)
#'    \deqn{
#'    C_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'    j\ =\ i\\
#'    i\ \neq \ j
#'    \end{array}}^{M} w_{ji} C_{j}^{( t)}\right)
#'    }
#'    \item Modfied-Kosko (Stylio & Groumpos, 2004)
#'    \deqn{
#'    C_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'    j\ =\ i\\
#'    i\ \neq \ j
#'    \end{array}}^{M} w_{ji} C_{j}^{( t)} +C_{i}^{( t)}\right)
#'    }
#'    \item Rescale (Papageorgiou, 2011; Dikopoulou, 2021)
#'    \deqn{
#'    C_{i}^{( t+1)} =f\left(\sum _{ \begin{array}{l}
#'    j\ =\ i\\
#'    i\ \neq \ j
#'    \end{array}}^{M} w_{ji}\left( 2C_{j}^{( t)} -1\right) +\left( 2C_{i}^{( t)} -1\right)\right)
#'    }
#' }
#'
#' \code{fcmconfr} supports the sigmoid and hyperbolic tangent (tanh) squashing
#' functions.
#' \deqn{
#' f_{sigmoid}( x) =\frac{1}{1+e^{\lambda x}}
#' }
#' \deqn{
#' f_{tanh}( x) =\frac{e^{x} -e^{-x}}{e^{x} +e^{-x}}
#' }
#'
#' @param adj_matrices \[`list()`]\cr A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param agg_function Aggregate the adj. matrices into a single FCM by taking
#' either the mean or median of the edge weights for edges included in multiple maps
#' @param num_mc_fcms \[`integer(1)` - Positive] The number of inferences to
#' generate via Monte Carlo sampling. Omit this argument when analyzing a
#' single, conventional FCM.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param ci_centering_function \[`character(1)`]\cr Estimate confidence
#' intervals about the "mean" or "median" of inferences from Monte Carlo
#' simulations
#' @param confidence_interval \[`double(1)` - Positive (between 0 and 1)]\cr
#' Bootstrapped confidence level
#' @param num_ci_bootstraps \[`integer(1)` - Positive] Number of bootstrap draws
#' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel processing.
#' @param n_cores \[`integer(1)` - Positive]\cr The number of cores to use in
#' parallel processing. If no input given, all available cores will be used.
#' @param show_progress \[`logical(1)`]\cr If TRUE, show progress bars and print
#' runtime updates in the console when performing FCM simulations.
#' @param run_agg_calcs \[`logical(1)`]\cr If TRUE, run the code to generate and
#' simulate an aggregate FCM generated from the input adj_matrices.
#' @param run_mc_calcs \[`logical(1)`]\cr If TRUE, run the code to generate and
#' simulate monte carlo-generated FCM sampled from the input adj_matrices
#' @param run_ci_calcs TRUE/FALSE Run the code to estimate the 95 percent CI
#' bounds about the means of the inferences of the monte carlo adj matrices
#' @param include_zeroes_in_sampling \[`logical(1)`]\cr If TRUE, incorporate
#' zeroes as intentionally-defined edge weights or ignore them when aggregating
#' adjacency matrices and sampling for Monte Carlo FCMs.
#' @param include_sims_in_output \[`logical(1)`]\cr If TRUE, include simulations
#' and inferences in output. Set to FALSE to reduce output size.
#' @param silent \[`logical(1)`]\cr If TRUE, suppress warning and error
#' messages.
#'
#' @returns A list of outputs generated from the individual_fcms simulations,
#'          aggregate_fcm analysis, and monte_carlo_fcms analysis. Bootstrap
#'          estimates of inferences from monte carlo analysis are included, as
#'          well as function inputs.
#'
#'
#' @export
#'
#' @srrstats {BS2.12, BS2.13, BS2.14, BS2.15} Users may control verbosity of output, progress indicators, and messages
#'
#' @example man/examples/ex-fcmconfr.R
fcmconfr <- function(adj_matrices = list(),
                     # Aggregation and Monte Carlo Sampling
                     agg_function = c("mean", "median"),
                     num_mc_fcms = 1000L,
                     # Simulation
                     initial_state_vector = c(),
                     clamping_vector = c(),
                     activation = c("kosko", "modified-kosko", "rescale"),
                     squashing = c("sigmoid", "tanh"),
                     lambda = 1.0,
                     point_of_inference = c("peak", "final"),
                     max_iter = 100L,
                     min_error = 1e-5,
                     # Inference Estimation (bootstrap)
                     ci_centering_function = c("mean", "median"),
                     confidence_interval = 0.95,
                     num_ci_bootstraps = 1000L,
                     # Runtime Options
                     show_progress = TRUE,
                     parallel = FALSE,
                     n_cores = 1L,
                     # Additional Options
                     run_agg_calcs = TRUE,
                     run_mc_calcs = TRUE,
                     run_ci_calcs = TRUE,
                     include_zeroes_in_sampling = FALSE,
                     include_sims_in_output = TRUE,
                     silent = FALSE) {

  # Perform input checks ----
  check_fcmconfr_input(silent, check = "logical", var_name = "silent")
  silent <- as.logical(silent)
  if (silent) {
    sink(file = file(nullfile(), open = "wt"), type = "message")
  }

  checks <- check_fcmconfr_function_inputs(
    adj_matrices,
    # Aggregation and Monte Carlo Sampling
    agg_function, num_mc_fcms,
    # Simulation
    initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error,
    # Inference Estimation (bootstrap)
    ci_centering_function, confidence_interval, num_ci_bootstraps,
    # Runtime Options
    show_progress, parallel, n_cores, run_agg_calcs,
    # Additional Options
    run_mc_calcs, run_ci_calcs, include_zeroes_in_sampling, include_sims_in_output
  )
  adj_matrices <- checks$adj_matrices
  fcm_class <- checks$fcm_class
  concept_names <- checks$concept_names
  # Aggregation and Monte Carlo Sampling
  agg_function <- checks$agg_function
  num_mc_fcms <- checks$ num_mc_fcms
  # Simulation
  initial_state_vector <- checks$initial_state_vector
  clamping_vector <- checks$clamping_vector
  activation <- checks$activation
  squashing <- checks$squashing
  lambda <- checks$lambda
  point_of_inference <- checks$point_of_inference
  max_iter <- checks$max_iter
  min_error <- checks$min_error
  # Inference Estimation (bootstrap)
  ci_centering_function <- checks$ci_centering_function
  confidence_interval <- checks$confidence_interval
  num_ci_bootstraps <- checks$num_ci_bootstraps
  # Runtime Options
  show_progress <- checks$show_progress
  parallel <- checks$parallel
  n_cores <- checks$n_cores
  # Additional Options
  run_agg_calcs <- checks$run_agg_calcs
  run_mc_calcs <- checks$run_mc_calcs
  run_ci_calcs <- checks$run_ci_calcs
  include_zeroes_in_sampling <- checks$include_zeroes_in_sampling
  include_sims_in_output <- checks$include_sims_in_output
  # ----

  concepts <- unlist(unique(lapply(adj_matrices, function(adj_matrix) colnames(adj_matrix))))

  if (silent) {
    suppressMessages(requireNamespace("tidyr"))
  } else {
    requireNamespace("tidyr")
  }

  # Individual Adj. Matrices Simulations ----
  if (show_progress) print("Simulating Input FCMs", quote = FALSE)
  individual_adj_matrices_inferences <- infer_fcm_set(adj_matrices, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel, n_cores, show_progress, include_sims_in_output = TRUE, silent = silent, skip_checks = TRUE)

  if (fcm_class == "conventional") {
    # individual_adj_matrices_inferences_df <- do.call(rbind, lapply(individual_adj_matrices_inferences$inferences, function(inference) inference$inferences))
    individual_adj_matrices_inferences_df <- individual_adj_matrices_inferences$inferences
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    # individual_adj_matrices_inferences_df <- lapply(individual_adj_matrices_inferences$inferences, function(inference) inference$inferences)
    individual_adj_matrices_inferences_df <- individual_adj_matrices_inferences$inferences
  }
  names(individual_adj_matrices_inferences$simulations) <- paste0("adj_matrix_", seq_along(adj_matrices))
  # ----

  # Aggregation Analysis ----
  if (run_agg_calcs) {
    # Build aggregate adj_matrix
    aggregate_adj_matrix <- aggregate_fcms(adj_matrices, agg_function, include_zeroes_in_sampling, skip_checks = TRUE)
    # Infer aggregate adj_matrix
    aggregate_fcm_inference <- infer_fcm(aggregate_adj_matrix$adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks = TRUE)
    aggregate_fcm_inference$inferences <- data.frame(cbind("adj_matrix_index" = "aggregate", aggregate_fcm_inference$inferences))
    colnames(aggregate_fcm_inference$inferences) <- c("adj_matrix_index", concepts)
    attr(aggregate_fcm_inference$inferences, "index") <- "adj_matrix_index"
  }
  # ----

  # Monte Carlo Analysis ----
  if (run_mc_calcs) {
    # Build monte carlo models
    mc_adj_matrices <- build_monte_carlo_fcms(adj_matrices, num_mc_fcms, include_zeroes_in_sampling, show_progress, silent = silent, skip_checks = TRUE)
    mc_adj_matrices <- lapply(
      mc_adj_matrices,
      function(sampled_adj_matrix) {
        colnames(sampled_adj_matrix) <- concept_names
        rownames(sampled_adj_matrix) <- concept_names
        sampled_adj_matrix
      })
    names(mc_adj_matrices) <- paste0("mc_adj_matrix_", seq_along(mc_adj_matrices))
    mc_inferences <- infer_fcm_set(mc_adj_matrices, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel, n_cores, show_progress, include_sims_in_output, silent = silent, skip_checks = TRUE)

    if (run_ci_calcs) {
      CIs_of_expected_values_of_mc_simulation_inferences <- get_quantiles_and_bootstrapped_CIs_of_inferences(mc_inferences, ci_centering_function,  confidence_interval, num_ci_bootstraps, parallel, n_cores, show_progress, skip_checks = TRUE)
    }
  }
  # ----

  # Organize Output
  env_variables <- as.list(environment())
  fcmconfr_output <- organize_fcmconfr_output(env_variables)

  fcmconfr_output
}



#' Get inferences from an fcmconfr output
#'
#' @family utility
#'
#' @description
#' Given an fcmconfr output object, return the inferences of all or just a
#' specific analysis
#'
#' @param fcmconfr_result_obj \[`fcmconfr`]\cr A direct output from the
#' \code{\link{fcmconfr}} function
#' @param analysis \[`character()`]\cr The analysis for which inferences to
#' return (HELP?)
#'
#' @returns \[`list()` or `data.frame()`]\cr A dataframe (or list of dataframes)
#' of inferences from the selected analysis (analyses)
#'
#' @export
#' @example man/examples/ex-get_fcmconfr_inferences.R
get_fcmconfr_inferences <- function(fcmconfr_result_obj = list(),
                                    analysis = c("individual", "aggregate", "mc")) {

  # Check Inputs ---
  if (!identical(methods::is(fcmconfr_result_obj), "fcmconfr")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var fcmconfr_result_obj} must be an fcmconfr object - a direct output from the fcmconfr() function.",
      "+++++> Input {.var fcmconfr_result_obj} was type '{methods::is(fcmconfr_result_obj)[1]}'"
    )))
  }

  analysis_opt_verified <- vapply(analysis,
                                  function(x) check_fcmconfr_input(tolower(as.character(x)), check = "choice_selection", var_name = "analysis", choice_selection_opts = c("individual", "aggregate", "mc")),
                                  logical(1))
  analysis <- tolower(as.character(analysis))
  # ----

  fcm_class <- fcmconfr_result_obj$fcm_class

  if (fcm_class == "conventional") {
    individual_inferences <- fcmconfr_result_obj$inferences$individual_fcms$inferences
  } else if (fcm_class == "ivfn") {
    individual_inferences_df <- fcmconfr_result_obj$inferences$individual_fcms$inferences
    individual_inferences_df_no_index <- individual_inferences_df[colnames(individual_inferences_df) != attr(individual_inferences_df, "index")]
    lower_individual_inferences <- data.frame(apply(individual_inferences_df_no_index, c(1, 2), function(element) element[[1]]$lower))
    upper_individual_inferences <- data.frame(apply(individual_inferences_df_no_index, c(1, 2), function(element) element[[1]]$upper))
    individual_inferences <- list(
      ivfn_df = individual_inferences_df,
      lower_values = cbind("adj_matrix_index" = individual_inferences_df$adj_matrix_index, lower_individual_inferences),
      upper_values = cbind("adj_matrix_index" = individual_inferences_df$adj_matrix_index, upper_individual_inferences)
    )
    attr(lower_individual_inferences, "index") <- "adj_matrix_index"
    attr(upper_individual_inferences, "index") <- "adj_matrix_index"
  } else if (fcm_class == "tfn") {
    individual_inferences_df <- fcmconfr_result_obj$inferences$individual_fcms$inferences
    individual_inferences_df_no_index <- individual_inferences_df[colnames(individual_inferences_df) != attr(individual_inferences_df, "index")]
    lower_individual_inferences <- data.frame(apply(individual_inferences_df_no_index , c(1, 2), function(element) element[[1]]$lower))
    mode_individual_inferences <- data.frame(apply(individual_inferences_df_no_index , c(1, 2), function(element) element[[1]]$mode))
    upper_individual_inferences <- data.frame(apply(individual_inferences_df_no_index , c(1, 2), function(element) element[[1]]$upper))
    individual_inferences <- list(
      tfn_df = individual_inferences_df,
      lower_values = cbind("adj_matrix_index" = individual_inferences_df$adj_matrix_index, lower_individual_inferences),
      mode_values = cbind("adj_matrix_index" = individual_inferences_df$adj_matrix_index, mode_individual_inferences),
      upper_values = cbind("adj_matrix_index" = individual_inferences_df$adj_matrix_index, upper_individual_inferences)
    )
    attr(individual_inferences$lower_values, "index") <- "adj_matrix_index"
    attr(individual_inferences$mode_values, "index") <- "adj_matrix_index"
    attr(individual_inferences$upper_values, "index") <- "adj_matrix_index"
  }

  inferences_list <- list(
    individual_inferences = individual_inferences
  )

  if (fcmconfr_result_obj$params$additional_opts$run_agg_calcs) {
    if (fcm_class == "conventional") {
      aggregate_inferences <- fcmconfr_result_obj$inferences$aggregate_fcm$inferences
      aggregate_inferences <- tidyr::pivot_longer(aggregate_inferences, cols = seq_along(aggregate_inferences)[-1], names_to = "node")
      inferences_list$aggregate_inferences <- aggregate_inferences
    } else if (fcm_class == "ivfn") {
      aggregate_inferences_df <- fcmconfr_result_obj$inferences$aggregate_fcm$inferences
      aggregate_inferences_df_no_index <- aggregate_inferences_df[colnames(aggregate_inferences_df) != attr(aggregate_inferences_df, "index")]
      crisp_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$upper)/2)
      lower_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) element[[1]]$lower)
      upper_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) element[[1]]$upper)
      aggregate_inferences <- data.frame(
        node = colnames(aggregate_inferences_df_no_index),
        crisp = t(crisp_aggregate_inferences),
        lower = t(lower_aggregate_inferences),
        upper = t(upper_aggregate_inferences)
      )
      colnames(aggregate_inferences) <- c("node", "crisp", "lower", "upper")
      attr(aggregate_inferences, "index") <- "node"
      inferences_list$aggregate_inferences <- aggregate_inferences
    } else if (fcm_class == "tfn") {
      aggregate_inferences_df <- fcmconfr_result_obj$inferences$aggregate_fcm$inferences
      aggregate_inferences_df_no_index <- aggregate_inferences_df[colnames(aggregate_inferences_df) != attr(aggregate_inferences_df, "index")]
      crisp_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$mode + element[[1]]$upper)/3)
      lower_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) element[[1]]$lower)
      mode_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) element[[1]]$mode)
      upper_aggregate_inferences <- apply(aggregate_inferences_df_no_index, c(1, 2), function(element) element[[1]]$upper)
      aggregate_inferences <- data.frame(
        node = colnames(aggregate_inferences_df_no_index),
        crisp = t(crisp_aggregate_inferences),
        lower = t(lower_aggregate_inferences),
        mode = t(mode_aggregate_inferences),
        upper = t(upper_aggregate_inferences)
      )
      colnames(aggregate_inferences) <- c("node", "crisp", "lower", "mode", "upper")
      attr(aggregate_inferences, "index") <- "node"
      inferences_list$aggregate_inferences <- aggregate_inferences
    }
  }

  if (fcmconfr_result_obj$params$additional_opts$run_mc_calcs) {
    mc_inferences <- fcmconfr_result_obj$inferences$monte_carlo_fcms$inferences
    inferences_list$mc_inferences <- mc_inferences
  }

  if (fcmconfr_result_obj$params$additional_opts$run_ci_calcs) {
    mc_CIs_and_quantiles <- fcmconfr_result_obj$inferences$monte_carlo_fcms$confidence_intervals$CIs_and_quantiles_by_node
    inferences_list$mc_CIs_and_quantiles = mc_CIs_and_quantiles
  }

  output_list_categories <- sub("_.*", "", names(inferences_list))
  inferences_list <- inferences_list[output_list_categories %in% analysis]

  return(inferences_list)
}




#' Check fcmconfr Inputs
#'
#' @description
#' Confirm that all inputs will work with the \code{\link{fcmconfr}} function and return
#' appropriate error messages where necessary
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' This checks that all inputs for the \code{\link{fcmconfr}} function are of an appropriate
#' format, and also fills in missing inputs for initial_state_vector, clamping_vector,
#' and IDs when appropriate.
#'
#'
#' @param adj_matrices \[`list()`]\cr A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param agg_function Aggregate the adj. matrices into a single FCM by taking
#' either the mean or median of the edge weights for edges included in multiple maps
#' @param num_mc_fcms \[`integer(1)` - Positive] The number of inferences to
#' generate via Monte Carlo sampling. Omit this argument when analyzing a
#' single, conventional FCM.
#' @param initial_state_vector \[`vector("double")`]\cr A list of state values
#' (one per node) at the start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector \[`vector("double")`]\cr A list of values (one per
#' node) that indicates whether clamped simulations will be performed. In
#' clamped simulations the \code{clamping_vector} controls the scenario (nodes
#' assigned non-zero values will remain at those values for the entire
#' simulation). In pulse simulations all values in the \code{clamping_vector}
#' are set to 0.
#' @param activation \[`character(1)`]\cr The activation function used. Must be
#'  one of the following: 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing  \[`character(1)`]\cr The squashing function used. Must be
#' one of the following: 'tanh' or 'sigmoid'.
#' @param lambda \[`double(1)`] Positive\cr A numeric value that defines the
#' steepness of the squashing function's slope.
#' @param point_of_inference \[`character(1)`]\cr Definition of an inference.
#' The metric used to calculate  the response of each node to a scenario of
#' interest from a simulation timeseries. Must be one of the following: 'peak'
#' (the maximum value) or 'final' (the state at equilibrium).
#' @param max_iter \[`integer(1)` - Positive]\cr The maximum number of
#' iterations to run (increase if the minimum error value is not achieved).
#' @param min_error \[`double(1)` - Positive]\cr The error past which a
#' simulation has converged and no further iterations are necessary. \emph{Error
#' equals the sum of the absolute value of the current state vector minus the
#' previous state vector}.
#' @param ci_centering_function \[`character(1)`]\cr Estimate confidence
#' intervals about the "mean" or "median" of inferences from Monte Carlo
#' simulations
#' @param confidence_interval \[`double(1)` - Positive (between 0 and 1)]\cr
#' Bootstrapped confidence level
#' @param num_ci_bootstraps \[`integer(1)` - Positive] Number of bootstrap draws
#' @param parallel \[`logical(1)`]\cr If TRUE, utilize parallel processing.
#' @param n_cores \[`integer(1)` - Positive]\cr The number of cores to use in
#' parallel processing. If no input given, all available cores will be used.
#' @param show_progress \[`logical(1)`]\cr If TRUE, show progress bars and print
#' runtime updates in the console when performing FCM simulations.
#' @param run_agg_calcs \[`logical(1)`]\cr If TRUE, run the code to generate and
#' simulate an aggregate FCM generated from the input adj_matrices.
#' @param run_mc_calcs \[`logical(1)`]\cr If TRUE, run the code to generate and
#' simulate monte carlo-generated FCM sampled from the input adj_matrices
#' @param run_ci_calcs TRUE/FALSE Run the code to estimate the 95 percent CI
#' bounds about the means of the inferences of the monte carlo adj matrices
#' @param include_zeroes_in_sampling \[`logical(1)`]\cr If TRUE, incorporate
#' zeroes as intentionally-defined edge weights or ignore them when aggregating
#' adjacency matrices and sampling for Monte Carlo FCMs.
#' @param include_sims_in_output \[`logical(1)`]\cr If TRUE, include simulations
#' and inferences in output. Set to FALSE to reduce output size.
#' @param silent \[`logical(1)`]\cr If TRUE, suppress warning and error
#' messages.
#'
#' @returns \[`list()`]\cr A list of resolved inputs to pass to
#' \code{\link{fcmconfr}}
#'
#' @example man/examples/ex-check_fcmconfr_function_inputs.R
#' @keywords internal
#' @noRd
check_fcmconfr_function_inputs <- function(adj_matrices = list(),
                                           # Aggregation and Monte Carlo Sampling
                                           agg_function = c("mean", "median"),
                                           num_mc_fcms = 1000L,
                                           # Simulation
                                           initial_state_vector = c(),
                                           clamping_vector = c(),
                                           activation = c("kosko", "modified-kosko", "rescale"),
                                           squashing = c("sigmoid", "tanh"),
                                           lambda = 1.0,
                                           point_of_inference = c("peak", "final"),
                                           max_iter = 100L,
                                           min_error = 1e-5,
                                           # Inference Estimation (bootstrap)
                                           ci_centering_function = c("mean", "median"),
                                           confidence_interval = 0.95,
                                           num_ci_bootstraps = 1000L,
                                           # Runtime Options
                                           show_progress = TRUE,
                                           parallel = TRUE,
                                           n_cores = 1L,
                                           # Additional Options
                                           run_agg_calcs = TRUE,
                                           run_mc_calcs = TRUE,
                                           run_ci_calcs = TRUE,
                                           include_zeroes_in_sampling = FALSE,
                                           include_sims_in_output = TRUE) {

  # Perform General Input Checks ----
  # Have to check adj_matrix input before continuing with other checks
  check_fcmconfr_input(adj_matrices, check = "adj_matrix_list")
  if (!is.null(dim(adj_matrices))) {
    adj_matrices <- list(adj_matrices)
  }
  fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices[[1]])
  adj_matrices <- lapply(adj_matrices, function(x) assert_matrix(x, fcm_class, var_name_input = "adj_matrix"))
  concept_names <- unique(lapply(adj_matrices, colnames))[[1]]

  if (run_agg_calcs && identical(agg_function, c("mean", "median"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var agg_function} given",
      "~~~~~ Assuming {.var agg_function} is 'mean'"
    )))
    agg_function <- "mean"
  } else if (!run_agg_calcs) {
    agg_function <- "mean"
  }

  if (run_ci_calcs && identical(ci_centering_function, c("mean", "median"))) {
    warning(cli::format_warning(c(
      "!" = "Warning: No {.var ci_centering_function} given",
      "~~~~~ Assuming {.var ci_centering_function} is 'mean'"
    )))
    ci_centering_function <- "mean"
  } else if (!run_ci_calcs) {
    ci_centering_function <- "mean"
  }

  sim_input_checks <- check_simulation_inputs(adj_matrices[[1]], initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel, n_cores, show_progress, include_sims_in_output, skip_checks = FALSE)
  check_fcmconfr_input(agg_function, check = "choice_selection", var_name = "agg_function", choice_selection_opts = c("mean", "median"))
  check_fcmconfr_input(num_mc_fcms, check = "positive_integer", var_name = "num_ci_fcms")
  check_fcmconfr_input(ci_centering_function, check = "choice_selection", var_name = "ci_centering_function", choice_selection_opts = c("mean", "median"))
  check_fcmconfr_input(confidence_interval, check = "positive_number", var_name = "confidence_interval")
  check_fcmconfr_input(num_ci_bootstraps, check = "positive_integer", var_name = "num_ci_bootstraps")
  check_fcmconfr_input(run_agg_calcs, check = "logical", var_name = "run_agg_calcs")
  check_fcmconfr_input(run_mc_calcs, check = "logical", var_name = "run_mc_calcs")
  check_fcmconfr_input(run_ci_calcs, check = "logical", var_name = "run_ci_calcs")
  check_fcmconfr_input(include_zeroes_in_sampling, check = "logical", var_name = "include_zeroes_in_sampling")
  # ----


  # Confirm Agg, Monte Carlo and Bootstrap Function Calls are Viable ----
  if (fcm_class == "conventional" && length(adj_matrices) == 1 && (run_mc_calcs | run_agg_calcs)) {
    warning(cli::format_warning(c(
      "!" = "Warning: Cannot aggregate or generate monte carlo samples from a single (conventional) adj. matrix",
      "~~~~~ Skipping aggregate analysis; i.e. setting {.var run_agg_calcs} to FALSE",
      "~~~~~ Skipping monte carlo analysis; i.e. setting {.var run_mc_calcs} to FALSE"
    )))
    run_mc_calcs <- FALSE
    run_agg_calcs <- FALSE
  }
  else if ((fcm_class %in% c("ivfn", "tfn")) && length(adj_matrices) == 1 && (run_agg_calcs)) {
    warning(cli::format_warning(c(
      "!" = "Warning: Cannot generate aggregate fcm from a single adj. matrix",
      "~~~~~ Skipping aggregate analysis; i.e. setting {.var run_agg_calcs} to FALSE"
    )))
    run_agg_calcs = FALSE
  }

  if (!run_mc_calcs && run_ci_calcs) {
    warning(cli::format_warning(c(
      "!" = "Warning: Cannot estimate CIs of monte carlo inferences if monte carlo analysis is not being performed",
      "~~~~~ Skipping CI bound estimation; i.e. setting {.var run_ci_calcs} to FALSE"
    )))
    run_ci_calcs <- FALSE
  }
  # ----

  return(list(
    adj_matrices = adj_matrices,
    concept_names = concept_names,
    fcm_class = fcm_class,
    # Aggregation and Monte Carlo Sampling
    agg_function = tolower(as.character(agg_function)),
    num_mc_fcms = as.integer(num_mc_fcms),
    # Simulation
    initial_state_vector = sim_input_checks$initial_state_vector,
    clamping_vector = sim_input_checks$clamping_vector,
    activation = sim_input_checks$activation,
    squashing = sim_input_checks$squashing,
    lambda = sim_input_checks$lambda,
    point_of_inference = sim_input_checks$point_of_inference,
    max_iter = sim_input_checks$max_iter,
    min_error = sim_input_checks$min_error,
    # Inference Estimation (bootstrap)
    ci_centering_function = tolower(as.character(ci_centering_function)),
    confidence_interval = as.numeric(confidence_interval),
    num_ci_bootstraps = as.integer(num_ci_bootstraps),
    # Runtime Options
    show_progress = sim_input_checks$show_progress,
    parallel = sim_input_checks$parallel,
    n_cores = sim_input_checks$n_cores,
    # Additional Options
    run_agg_calcs = as.logical(run_agg_calcs),
    run_mc_calcs = as.logical(run_mc_calcs),
    run_ci_calcs = as.logical(run_ci_calcs),
    include_zeroes_in_sampling = as.logical(include_zeroes_in_sampling),
    include_sims_in_output = sim_input_checks$include_sims_in_output
  ))
}



#' Organize fcmconfr Output
#'
#' @description
#' This arranges fcmconfr inputs and outputs into a neatly-arranged list of lists,
#' and critically, neatly-arranged data structures to clean code written in
#' the \code{\link{fcmconfr}} function.
#'
#' @details
#' [INTENDED FOR DEVELOPER USE ONLY]
#'
#' @param ... additional inputs; typically environmental variables
#'
#' @returns An organzed list output of fcmconfr
#'
#' @srrstats {BS5.0, BS5.1, BS5.2, EA3.0} Users may access all inputs and
#' statistical parameters from fcmconfr output object
#' @srrstats {EA3.1} Standardised comparison of inputs, processes, models, or
#' outputs
#'
#' @keywords internal
#' @noRd
organize_fcmconfr_output <- function(...) {
  variables <- as.list(...)

  fcmconfr_output <- structure(
    .Data = list(
      fcm_class = variables$fcm_class,
      inferences = list(
        individual_fcms = list(
          inferences = variables$individual_adj_matrices_inferences_df,
          simulations = variables$individual_adj_matrices_inferences$simulations
        )
      ),
      params = list(
        fcm_class = variables$fcm_class,
        adj_matrices = variables$adj_matrices,
        simulation_opts = list(initial_state_vector = variables$initial_state_vector,
                               clamping_vector = variables$clamping_vector,
                               activation = variables$activation,
                               squashing = variables$squashing,
                               lambda = variables$lambda,
                               max_iter = variables$max_iter,
                               min_error = variables$min_error),
        additional_opts = list(run_ci_calcs = variables$run_ci_calcs,
                               run_agg_calcs = variables$run_agg_calcs,
                               run_mc_calcs = variables$run_mc_calcs)
      )
    ),
    class = "fcmconfr"
  )

  if (variables$run_agg_calcs) {
    fcmconfr_output$aggregate_adj_matrix <- variables$aggregate_adj_matrix$adj_matrix # Only return adj_matrix, not params since params included in separate object in list
    fcmconfr_output$inferences$aggregate_fcm <- variables$aggregate_fcm_inference
    fcmconfr_output$params$agg_function <- variables$agg_function
    fcmconfr_output$params$additional_opts <- list(
      include_zeroes_in_sampling = variables$include_zeroes_in_sampling,
      run_ci_calcs = variables$run_ci_calcs,
      run_agg_calcs = variables$run_agg_calcs,
      run_mc_calcs = variables$run_mc_calcs
    )
  }

  if (variables$run_mc_calcs) {
    fcmconfr_output$mc_adj_matrices = variables$mc_adj_matrices
    fcmconfr_output$inferences$monte_carlo_fcms = list(
      inferences = variables$mc_inferences$inferences,
      simulations = variables$mc_inferences$simulations
    )
    fcmconfr_output$params$agg_function = variables$agg_function
    fcmconfr_output$params$num_mc_fcms = variables$num_mc_fcms
    fcmconfr_output$params$runtime_opts = list(parallel = variables$parallel,
                                               n_cores = variables$n_cores,
                                               show_progress = variables$show_progress)
    fcmconfr_output$params$additional_opts = list(
      include_zeroes_in_sampling = variables$include_zeroes_in_sampling,
      include_sims_in_output = variables$include_sims_in_output,
      run_ci_calcs = variables$run_ci_calcs,
      run_agg_calcs = variables$run_agg_calcs,
      run_mc_calcs = variables$run_mc_calcs
    )
  }

  if (variables$run_mc_calcs & variables$run_ci_calcs) {
    fcmconfr_output$inferences$monte_carlo_fcms$confidence_intervals = list(
      # CI_estimation_function = variables$ci_centering_function, # removing since included in params
      CIs_and_quantiles_by_node = variables$CIs_of_expected_values_of_mc_simulation_inferences$CIs_and_quantiles_by_node,
      bootstrapped_expected_values = variables$CIs_of_expected_values_of_mc_simulation_inferences$bootstrap_expected_values
    )
    fcmconfr_output$params$confidence_intervals_bootstrap_opts = list(
      ci_centering_function = variables$ci_centering_function,
      confidence_interval = variables$confidence_interval,
      num_ci_bootstraps = variables$num_ci_bootstraps
    )
  }

  # options(warn = 0) # Set back to default

  fcmconfr_output
}



#' summary.fcmconfr
#'
#' @description
#' This creates a summary object of the fcmconfr output
#'
#' @details
#' Show the objects listed in the fcmconfr output \code{$inference} and \code{$params},
#' as well as \code{$bootstrap} if present in output. Additionally, this prints
#' descriptions/summaries of objects within each sub-list like inference_opts,
#' bootstrap_input_opts, etc.
#'
#' @param object \[`fcmconfr`]\cr A direct output from the \code{\link{fcmconfr}}
#' function
#' @param ... additional inputs
#'
#' @returns A summary object of fcmconfr results
#'
#' @export
#'
#' @srrstats {BS6.4} *Software may provide `summary` methods for return objects*
#'
#' @examples
#' NULL
summary.fcmconfr <- function(object, ...) {

  fcm_class <- object$fcm_class
  inferences <- get_fcmconfr_inferences(object)
  aggregate_adj_matrix <- object$aggregate_adj_matrix
  mc_adj_matrices <- object$mc_adj_matrices

  summary_obj <- structure(
    .Data = list(
      fcm_class = fcm_class,
      inferences = inferences
    ),
    class = "summary.fcmconfr"
  )


  if (!is.null(aggregate_adj_matrix)) {
    summary_obj$aggregate_adj_matrix <- aggregate_adj_matrix
  }

  return(summary_obj)
}



#' print.summary.fcmconfr
#'
#' @description
#' This prints a summary object of the fcmconfr output
#'
#' @details
#' Show the objects listed in the fcmconfr output \code{$inference} and \code{$params},
#' as well as \code{$bootstrap} if present in output. Additionally, this prints
#' descriptions/summaries of objects within each sub-list like inference_opts,
#' bootstrap_input_opts, etc.
#'
#' @param x \[`summary.fcmconfr`]\cr A direct output from the
#' \code{\link{summary.fcmconfr}} function
#' @param ... additional inputs
#'
#' @returns A console printout (summary) of fcmconfr results
#'
#' @export
#'
#' @srrstats {BS6.4} *Software may provide `summary` methods for return objects*
#'
#' @examples
#' NULL
print.summary.fcmconfr <- function(x, ...) {
  digits <- 3

  if (x$fcm_class == "conventional") {
    individual_inferences_summary_df <- t(apply(x$inferences$individual_inferences[, -1], 2, function(x) round(summary(x), digits)))
    summary_output <- list(
      "individual_inferences" = individual_inferences_summary_df
    )
    if (!is.null(x$aggregate_adj_matrix)) {
      aggregate_inferences_df <- data.frame("value" = round(x$inferences$aggregate_inferences$value, digits))
      rownames(aggregate_inferences_df) <-  x$inferences$aggregate_inferences$node
      summary_output$aggregate_inferences <- aggregate_inferences_df
    }
  } else if (x$fcm_class == "ivfn") {
    lower_summary <- data.frame(t(apply(
      x$inferences$individual_inferences$lower_values[, -1], 2, function(x) round(summary(x), digits))
    ))
    upper_summary <- data.frame(t(apply(
      x$inferences$individual_inferences$upper_values[, -1], 2, function(x) round(summary(x), digits))
    ))
    individuals_ivfn_df <- lower_summary
    for (i in seq_along(rownames(lower_summary))) {
      for (j in seq_along(colnames(lower_summary))) {
        individuals_ivfn_df[[j]][[i]] <- list(ivfn(
          # [[j]][[i]] instead of [[i]][[j]]
          # because this notation is
          # [[col]][[row]] for data.frames
          lower = lower_summary[i, j],
          upper = upper_summary[i, j]
        ))
      }
    }
    colnames(individuals_ivfn_df) <- c("Min.", "1st.Qu", "Median", "Mean", "3rd.Qu", "Max.")
    individuals_ivfn_df <- individuals_ivfn_df[, colnames(individuals_ivfn_df) %in% c("Median", "Mean")]
    summary_output <- list(
      "individual_inferences" = individuals_ivfn_df
    )
    if (!is.null(x$aggregate_adj_matrix)) {
      aggregate_inferences_df <- data.frame("value" = round(x$inferences$aggregate_inferences[, -1], digits))
      colnames(aggregate_inferences_df) <- c("crisp", "lower", "upper")
      summary_output$aggregate_inferences <- aggregate_inferences_df
    }
  } else if (x$fcm_class == "tfn") {
    lower_summary <- data.frame(t(apply(
      x$inferences$individual_inferences$lower_values[, -1], 2, function(x) round(summary(x), digits))
    ))
    mode_summary <- data.frame(t(apply(
      x$inferences$individual_inferences$mode_values[, -1], 2, function(x) round(summary(x), digits))
    ))
    upper_summary <- data.frame(t(apply(
      x$inferences$individual_inferences$upper_values[, -1], 2, function(x) round(summary(x), digits))
    ))
    individuals_tfn_df <- lower_summary
    for (i in seq_along(rownames(lower_summary))) {
      for (j in seq_along(colnames(lower_summary))) {
        individuals_tfn_df[[j]][[i]] <- list(tfn(
          # [[j]][[i]] instead of [[i]][[j]]
          # because this notation is
          # [[col]][[row]] for data.frames
          lower = lower_summary[i, j],
          mode = mode_summary[i, j],
          upper = upper_summary[i, j]
        ))
      }
    }
    colnames(individuals_tfn_df) <- c("Min.", "1st.Qu", "Median", "Mean", "3rd.Qu", "Max.")
    individuals_tfn_df <- individuals_tfn_df[, colnames(individuals_tfn_df) %in% c("Median", "Mean")]
    summary_output <- list(
      "individual_inferences" = individuals_tfn_df
    )
    if (!is.null(x$aggregate_adj_matrix)) {
      aggregate_inferences_df <- data.frame("value" = round(x$inferences$aggregate_inferences[, -1], digits))
      colnames(aggregate_inferences_df) <- c("crisp", "lower", "mode", "upper")
      summary_output$aggregate_inferences <- aggregate_inferences_df
    }
  }

  if (!is.null(x$inferences$mc_inferences)) {
    mc_inferences_summary_df <- t(apply(x$inferences$mc_inferences[, -1], 2, function(x) round(summary(x), digits)))
    summary_output$mc_inferences <- mc_inferences_summary_df
  }
  if (!is.null(x$inferences$mc_CIs_and_quantiles)) {
    column_names <- colnames(x$inferences$mc_CIs_and_quantiles)[-1]
    rounded_CIs_df <- data.frame(apply(x$inferences$mc_CIs_and_quantiles[, -1], c(1, 2), function(x) round(x, digits)))
    mc_CIs_and_quantiles_df <- data.frame(cbind(x$inferences$mc_CIs_and_quantiles$node, rounded_CIs_df))
    rownames(mc_CIs_and_quantiles_df) <- x$inferences$mc_CIs_and_quantiles$node
    mc_CIs_and_quantiles_df <- mc_CIs_and_quantiles_df[, -1]
    colnames(mc_CIs_and_quantiles_df) <- column_names
    summary_output$mc_CIs_and_quantiles <- mc_CIs_and_quantiles_df
  }

  if (x$fcm_class == "conventional") {
    n_individual_fcms <- nrow(x$inferences$individual_inferences)
  } else if (x$fcm_class == "ivfn") {
    n_individual_fcms <- nrow(x$inferences$individual_inferences$ivfn_df)
  } else if (x$fcm_class == "tfn") {
    n_individual_fcms <- nrow(x$inferences$individual_inferences$tfn_df)
  }

  summary_text_header <- paste0("Inferences via fcmconfr: ", n_individual_fcms, " individual adj. matrices (", x$fcm_class, ")")
  full_text <- utils::capture.output(
    cat("~~~~~ Summary ~~~~~\n\n"),
    print(summary_output),
    print(cli::boxx(summary_text_header))
  )

  return(
    cat(full_text, sep = "\n")
  )

}


#' print.fcmconfr
#'
#' @description
#' This improves the readability of the fcmconfr output
#'
#' @details
#' Show the objects listed in the fcmconfr output \code{$inference} and \code{$params},
#' as well as \code{$bootstrap} if present in output. Additionally, this prints
#' descriptions/summaries of objects within each sub-list like inference_opts,
#' bootstrap_input_opts, etc.
#'
#' @param x \[`fcmconfr`]\cr A direct output from the \code{\link{fcmconfr}}
#' function
#' @param ... additional inputs
#'
#' @returns A console printout of fcmconfr results
#'
#' @export
#'
#' @srrstats {BS6.0} Print method included for fcmconfr objects
#'
#' @examples
#' NULL
print.fcmconfr <- function(x, ...) {
  performed_aggregate <- x$params$additional_opts$run_agg_calcs
  performed_mc <- x$params$additional_opts$run_mc_calcs
  performed_bootstrap <- x$params$additional_opts$run_ci_calcs

  n_input_fcm <- length(x$params$adj_matrices)

  if (performed_aggregate & performed_mc & performed_bootstrap) {
    n_mc_sims <- x$params$num_mc_fcms

    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - aggregate_fcm: Inferences and data from the aggregate (", x$params$agg_function, ") of the ",  n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - monte_carlo_fcms: Inferences of data from the ", n_mc_sims, " fcms constructed from the ", n_input_fcm, " input fcm adj. matrices."),
        "\n$confidence_intervals\n",
        paste0(" - CIs_about_means_and_quantiles_by_node: ", round(x$params$confidence_intervals_bootstrap_opts$confidence_interval, 2), "% CI of means of inferences and quantiles by node\n"),
        paste0(" - bootstrapped_expected_values: ", x$params$confidence_intervals_bootstrap_opts$num_ci_bootstraps),
        "\n$aggregate_adj_matrix",
        "\n$mc_adj_matrices",
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  } else if (performed_aggregate & performed_mc & !performed_bootstrap) {
    n_mc_sims <- x$params$num_mc_fcms

    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - aggregate_fcm: Inferences and data from the aggregate (", x$params$agg_function, ") of the ",  n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - monte_carlo_fcms: Inferences of data from the ", n_mc_sims, " fcms constructed from the ", n_input_fcm, " input fcm adj. matrices."),
        "\n$aggregate_adj_matrix",
        "\n$mc_adj_matrices",
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  } else if (!performed_aggregate & performed_mc & performed_bootstrap) {
    n_mc_sims <- x$params$num_mc_fcms

    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - monte_carlo_fcms: Inferences of data from the ", n_mc_sims, " fcms constructed from the ", n_input_fcm, " input fcm adj. matrices."),
        "\n$bootstrap\n",
        paste0(" - CIs_about_means_and_quantiles_by_node: ", round(x$params$confidence_intervals_bootstrap_opts$confidence_interval, 2), "% CI of means of inferences and quantiles by node\n"),
        paste0(" - bootstrapped_expected_values: ", x$params$confidence_intervals_bootstrap_opts$num_ci_bootstraps),
        "\n$mc_adj_matrices",
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  } else if (!performed_aggregate & performed_mc & !performed_bootstrap) {
    n_mc_sims <- x$params$num_mc_fcms

    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - monte_carlo_fcms: Inferences of data from the ", n_mc_sims, " fcms constructed from the ", n_input_fcm, " input fcm adj. matrices."),
        "\n$mc_adj_matrices",
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  } else if (performed_aggregate & !performed_mc) {
    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices.\n"),
        paste0(" - aggregate_fcm: Inferences and data from the aggregate (", x$params$agg_function, ") of the ",  n_input_fcm, " input fcm adj. matrices.\n"),
        "\n$aggregate_adj_matrix",
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  } else if (!performed_aggregate & !performed_mc) {
    cat(paste0("fcmconfr: ", n_input_fcm, " individual adj. matrices (", x$params$fcm_class, ")"),
        "\n$inferences\n",
        paste0(" - individual_fcms: Inferences and data from the ", n_input_fcm, " input fcm adj. matrices."),
        "\n$params\n",
        " - simulation_opts:",
        paste0("act = ", x$params$simulation_opts$activation, "; squash = ", x$params$simulation_opts$squashing, "; lambda = ", round(x$params$simulation_opts$lambda, 3)),
        paste0("\n  - additional_opts: ", "Perform Aggregate Analysis = ", x$params$additional_opts$run_agg_calcs, "; Perform MC Analysis = ", x$params$additional_opts$run_mc_calcs)
    )
  }
}

