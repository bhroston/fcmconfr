
################################################################################
# fcmconfr.R
#
# This contains the primary fcmconfr() function and the get_inferences()
# function.
#
#   - fcmconfr
#   - get_inferences
#
################################################################################

# rOpenSci Statistical Software Standards ----
#' @srrstats {G1.0} *Statistical Software should list at least one primary reference from published academic literature.*
#' @srrstats {G1.3} *All statistical terminology should be clarified and unambiguously defined.*
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
#'    [min, max], where any value within the range is as likely as any other
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
#' @references \insertRef{ozesmiParticipatoryApproachEcosystem2003}{fcmconfr}
#' @references \insertRef{aminpourWisdomStakeholderCrowds2020}{fcmconfr}
#' @references \insertRef{styliosIntroducingTheoryFuzzy1997}{fcmconfr}
#' @references \insertRef{mooreIntervalAnalysisFuzzy2003}{fcmconfr}
#' @references \insertRef{hajek_interval-valued_2016}{fcmconfr}
#' @references \insertRef{yesil_triangular_2014}{fcmconfr}
#' @references \insertRef{stylios_modeling_2004}{fcmconfr}
#' @references \insertRef{papageorgiou_new_2011}{fcmconfr}
#' @references \insertRef{dikopoulou_fuzzy_2021}{fcmconfr}
#'
#' @details
#'
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
#' @param adj_matrices A single adjacency matrix or a list of adjacency matrices
#' (n x n) representing FCMs. Matrices can have conventional edge weights, IVFN
#' edge weights or TFN edge weights
#' @param agg_function Choice of aggregation method (mean, median) for
#' producing a single "collective" FCM from a group of individual FCMs. Omit
#' this argument when analyzing a single, conventional FCM.
#' @param num_mc_fcms Number of inferences to generate via Monte Carlo sampling.
#' Omit this argument when analyzing a single, conventional FCM.
#' @param initial_state_vector A list of state values (one per node) at the
#' start of an FCM simulation. In pulse simulations the
#' \code{initial_state_vector}  controls the scenario (i.e., a non-zero value
#' is a transient perturbation). In clamped simulations all values in the
#' \code{initial_state_vector} are set to 1.
#' @param clamping_vector A list of values (one per node) that indicates
#' whether clamped simulations will be performed. In clamped simulations the
#' \code{clamping_vector} controls the scenario (nodes assigned non-zero values
#' will remain at those values for the entire simulation). In pulse simulations
#' all values in the \code{clamping_vector} are set to 0.
#' @param activation The activation function used. Must be one of the following:
#' 'kosko', 'modified-kosko', or 'rescale'.
#' @param squashing The squashing function used. Must be one of the following:
#' 'tanh', or 'sigmoid'.
#' @param lambda A numeric value that defines the steepness of the squashing
#' function
#' @param point_of_inference Definition of an inference. The metric used to
#' calculate  the response of each node to a scenario of interest from
#' simulation timeseries. Must be one of the following: 'peak' (the maximum
#' value) or 'final' (the state at equilibrium).
#' @param max_iter The maximum number of iterations to run (increase if the
#' minimum error value is not achieved)
#' @param min_error The error past which a simulation has converged and no
#' further iterations are necessary. \emph{Error equals the sum of the
#' absolute value of the current state vector minus the previous state vector}.
#' @param ci_centering_function Estimate confidence intervals about the "mean" or "median" of
#' inferences from Monte Carlo simulations
#' @param confidence_interval Bootstrapped confidence level
#' @param num_ci_bootstraps Number of bootstrap draws
#' @param show_progress TRUE/FALSE Show progress bar when running FCM
#' simulations.
#' @param parallel TRUE/FALSE Whether to utilize parallel processing
#' @param n_cores Number of cores to use in parallel processing. If no input given,
#' all available cores will be used.
#' @param run_agg_calcs TRUE/FALSE Generate an aggregate FCM and perform dynamic
#' simulations using the aggregate
#' @param run_mc_calcs TRUE/FALSE Perform Monte Carlo sampling to estimate
#' uncertainty in simulation inferences.
#' @param run_ci_calcs TRUE/FALSE Estimate bootstrapped confidence bounds about
#' the central tendency of Monte Carlo inferences.
#' @param include_zeroes_in_sampling TRUE/FALSE Incorporate zero-weighted edges
#' during FCM aggregation and Monte Carlo sampling.
#' @param include_sims_in_output TRUE/FALSE Include Monte Carlo FCMs in addition
#' to Monte Carlo simulations (and inferences) in fcmconfr output. Switch to
#' FALSE to reduce output size.
#'
#' @importFrom Rdpack reprompt
#'
#' @returns A list of outputs generated from the individual_fcms simulations,
#'          aggregate_fcm analysis, and monte_carlo_fcms analysis. Bootstrap
#'          estimates of inferences from monte carlo analysis are included, as
#'          well as function inputs.
#'
#' @export
#' @example man/examples/ex-fcmconfr.R
fcmconfr <- function(adj_matrices = list(matrix()),
                     # Aggregation and Monte Carlo Sampling
                     agg_function = c("mean", "median"),
                     num_mc_fcms = 1000,
                     # Simulation
                     initial_state_vector = c(),
                     clamping_vector = c(),
                     activation = c("kosko", "modified-kosko", "rescale"),
                     squashing = c("sigmoid", "tanh"),
                     lambda = 1,
                     point_of_inference = c("peak", "final"),
                     max_iter = 100,
                     min_error = 1e-5,
                     # Inference Estimation (bootstrap)
                     ci_centering_function = c("mean", "median"),
                     confidence_interval = 0.95,
                     num_ci_bootstraps = 5000,
                     # Runtime Options
                     show_progress = TRUE,
                     parallel = FALSE,
                     n_cores = integer(),
                     # Additional Options
                     run_agg_calcs = TRUE,
                     run_mc_calcs = TRUE,
                     run_ci_calcs = TRUE,
                     include_zeroes_in_sampling = FALSE,
                     include_sims_in_output = TRUE) {

  # Perform input checks ----
  checks <- check_fcmconfr_inputs(
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
  fcm_class <- checks$fcm_class
  adj_matrices <- checks$adj_matrices
  concepts <- checks$concept_names
  agg_function <- checks$agg_function
  initial_state_vector <- checks$initial_state_vector
  clamping_vector <- checks$clamping_vector
  activation <- checks$activation
  squashing <- checks$squashing
  point_of_inference <- checks$point_of_inference
  ci_centering_function <- checks$ci_centering_function
  show_progress <- checks$show_progress
  parallel <- checks$parallel
  run_agg_calcs <- checks$run_agg_calcs
  run_mc_calcs <- checks$run_mc_calcs
  run_ci_calcs <- checks$run_ci_calcs
  # ----

  # Individual Adj. Matrices Simulations ----
  print("Simulating Input FCMs", quote = FALSE)
  individual_adj_matrices_inferences <- infer_fcm_set(adj_matrices, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, parallel, n_cores, show_progress, include_sims_in_output = TRUE, skip_checks = TRUE)

  if (fcm_class == "conventional") {
    # individual_adj_matrices_inferences_df <- do.call(rbind, lapply(individual_adj_matrices_inferences$inferences, function(inference) inference$inferences))
    individual_adj_matrices_inferences_df <- cbind(input = paste0("adj_matrix_", seq_along(adj_matrices)), individual_adj_matrices_inferences$inferences)
    rownames(individual_adj_matrices_inferences_df) <- NULL
  } else if (fcm_class %in% c("ivfn", "tfn")) {
    # individual_adj_matrices_inferences_df <- lapply(individual_adj_matrices_inferences$inferences, function(inference) inference$inferences)
    individual_adj_matrices_inferences_df <- individual_adj_matrices_inferences$inferences
    rownames(individual_adj_matrices_inferences_df) <- paste0("adj_matrix_", seq_along(adj_matrices))
  }
  names(individual_adj_matrices_inferences$simulations) <- paste0("adj_matrix_", seq_along(adj_matrices))
  # ----

  # Aggregation Analysis ----
  if (run_agg_calcs) {
    # Build aggregate adj_matrix
    aggregate_adj_matrix <- aggregate_fcms(adj_matrices, agg_function, include_zeroes_in_sampling)
    # Infer aggregate adj_matrix
    aggregate_fcm_inference <- infer_fcm(aggregate_adj_matrix$adj_matrix, initial_state_vector, clamping_vector, activation, squashing, lambda, point_of_inference, max_iter, min_error, skip_checks = TRUE)
  }

  # Monte Carlo Analysis
  if (run_mc_calcs) {
    # Build monte carlo models
    mc_adj_matrices <- build_monte_carlo_fcms(adj_matrices, num_mc_fcms, include_zeroes_in_sampling, show_progress, skip_checks = TRUE)
    mc_adj_matrices <- lapply(
      mc_adj_matrices,
      function(sampled_adj_matrix) {
        colnames(sampled_adj_matrix) <- concepts
        rownames(sampled_adj_matrix) <- concepts
        sampled_adj_matrix
      })

    mc_inferences <- infer_fcm_set(
      adj_matrices = mc_adj_matrices,
      initial_state_vector = initial_state_vector,
      clamping_vector = clamping_vector,
      activation = activation,
      squashing = squashing,
      lambda = lambda,
      point_of_inference = point_of_inference,
      max_iter = max_iter,
      min_error = min_error,
      parallel = parallel,
      show_progress = show_progress,
      n_cores = n_cores,
      include_sims_in_output = include_sims_in_output
    )

    if (run_ci_calcs) {
      CIs_of_expected_values_of_mc_simulation_inferences <- get_mc_simulations_inference_CIs_w_bootstrap(mc_inferences$inference, ci_centering_function, confidence_interval, num_ci_bootstraps, parallel, n_cores, show_progress, skip_checks = TRUE)
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
#' @param fcmconfr_obj An fcmconfr output object
#' @param analysis The
#'
#' @returns A dataframe (or list of dataframes) of inferences from the selected
#' analysis (analyses)
#'
#' @importFrom methods is
#' @importFrom cli format_error
#'
#' @export
#' @example man/examples/ex-get_inferences.R
get_inferences <- function(fcmconfr_obj = list(),
                           analysis = c("individual", "aggregate", "mc")) {

  # Check fcmconfr_obj
  if (!identical(methods::is(fcmconfr_obj), "fcmconfr")) {
    stop(cli::format_error(c(
      "x" = "Error: {.var fcmconfr_obj} must be an fcmconfr object",
      "+++++> Input {.var fcmconfr_obj} was type '{methods::is(fcmconfr_obj)}'"
    )))
  }

  # Check analysis input
  if (!(all(analysis %in% c("individual", "aggregate", "mc")))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var analysis} must be within the set of c('individual', 'aggregate', 'mc')",
      "+++++> Input {.var analysis} was {analysis}"
    )))
  }

  fcm_class <- fcmconfr_obj$fcm_class

  if (fcm_class == "conventional") {
    individual_inferences_df <- fcmconfr_obj$inferences$individual_fcms$inferences
    individual_inferences_matrix_names <- individual_inferences_df$input
    individual_inferences <- data.frame(t(individual_inferences_df[, 2:ncol(individual_inferences_df)]))
    colnames(individual_inferences) <- individual_inferences_matrix_names
  } else if (fcm_class == "ivfn") {
    individual_inferences_df <- data.frame(t(do.call(rbind, fcmconfr_obj$inferences$individual_fcms$inferences)))
    lower_individual_inferences <- data.frame(apply(individual_inferences_df, c(1, 2), function(element) element[[1]]$lower))
    upper_individual_inferences <- data.frame(apply(individual_inferences_df, c(1, 2), function(element) element[[1]]$upper))
    individual_inferences <- list(
      ivfn_df = individual_inferences_df,
      lower_values = lower_individual_inferences,
      upper_values = upper_individual_inferences
    )
  } else if (fcm_class == "tfn") {
    individual_inferences_df <- data.frame(t(do.call(rbind, fcmconfr_obj$inferences$individual_fcms$inferences)))
    lower_individual_inferences <- data.frame(apply(individual_inferences_df, c(1, 2), function(element) element[[1]]$lower))
    mode_individual_inferences <- data.frame(apply(individual_inferences_df, c(1, 2), function(element) element[[1]]$mode))
    upper_individual_inferences <- data.frame(apply(individual_inferences_df, c(1, 2), function(element) element[[1]]$upper))
    individual_inferences <- list(
      tfn_df = individual_inferences_df,
      lower_values = lower_individual_inferences,
      mode_values = mode_individual_inferences,
      upper_values = upper_individual_inferences
    )
  }

  inferences_list <- list(
    individual_inferences = individual_inferences
  )

  if (fcmconfr_obj$params$additional_opts$run_agg_calcs) {
    if (fcm_class == "conventional") {
      aggregate_inferences_transposed <- data.frame(t(fcmconfr_obj$inferences$aggregate_fcm$inferences))
      inferences_list$aggregate_inferences <- aggregate_inferences_transposed
    } else if (fcm_class == "ivfn") {
      aggregate_inferences_df <- data.frame(t(fcmconfr_obj$inferences$aggregate_fcm$inferences))
      crisp_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$upper)/2)
      lower_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) element[[1]]$lower)
      upper_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) element[[1]]$upper)
      aggregate_inferences <- data.frame(
        crisp = crisp_aggregate_inferences,
        lower = lower_aggregate_inferences,
        upper = upper_aggregate_inferences
      )
      colnames(aggregate_inferences) <- c("crisp", "lower", "upper")
      inferences_list$aggregate_inferences <- aggregate_inferences
    } else if (fcm_class == "tfn") {
      aggregate_inferences_df <- data.frame(t(fcmconfr_obj$inferences$aggregate_fcm$inferences))
      crisp_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) (element[[1]]$lower + element[[1]]$mode + element[[1]]$upper)/3)
      lower_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) element[[1]]$lower)
      mode_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) element[[1]]$mode)
      upper_aggregate_inferences <- apply(aggregate_inferences_df, c(1, 2), function(element) element[[1]]$upper)
      aggregate_inferences <- data.frame(
        crisp = crisp_aggregate_inferences,
        lower = lower_aggregate_inferences,
        mode = mode_aggregate_inferences,
        upper = upper_aggregate_inferences
      )
      colnames(aggregate_inferences) <- c("crisp", "lower", "mode", "upper")
      inferences_list$aggregate_inferences <- aggregate_inferences
    }
  }

  if (fcmconfr_obj$params$additional_opts$run_mc_calcs) {
    mc_inferences_transposed <- t(fcmconfr_obj$inferences$monte_carlo_fcms$inferences)
    colnames(mc_inferences_transposed) <- paste0("mc_", seq_along(colnames(mc_inferences_transposed)))
    inferences_list$mc_inferences <- mc_inferences_transposed
  }

  if (fcmconfr_obj$params$additional_opts$run_ci_calcs) {
    mc_CIs_and_quantiles <- fcmconfr_obj$inferences$monte_carlo_fcms$confidence_intervals$CIs_and_quantiles_by_node
    inferences_list$mc_CIs_and_quantiles = mc_CIs_and_quantiles
  }

  output_list_categories <- sub("_.*", "", names(inferences_list))
  inferences_list <- inferences_list[output_list_categories %in% analysis]

  inferences_list
}
