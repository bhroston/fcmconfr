#' srr_stats
#'
#' All of the following standards initially have `@srrstatsTODO` tags.
#' These may be moved at any time to any other locations in your code.
#' Once addressed, please modify the tag from `@srrstatsTODO` to `@srrstats`,
#' or `@srrstatsNA`, ensuring that references to every one of the following
#' standards remain somewhere within your code.
#' (These comments may be deleted at any time.)
#'
#' @srrstatsVerbose TRUE

# May need to be used in an extended  test

#' Bayesian standards

# Exploratory Data Analysis Standards
#'
#' @srrstatsTODO {EA3.0} *The algorithmic components of EDA Software should enable automated extraction and/or reporting of statistics as some sufficiently "meta" level (such as variable or model selection), for which previous or reference implementations require manual intervention.*
#' @srrstatsTODO {EA4.1} *EDA Software should implement parameters to enable explicit control of numeric precision*
#'

#' @noRd
NULL


#' NA_standards
#'
#' Any non-applicable standards can have their tags changed from `@srrstatsTODO`
#' to `@srrstatsNA`, and placed together in this block, along with explanations
#' for why each of these standards have been deemed not applicable.
#' (These comments may also be deleted at any time.)
#'
#' @srrstatsNA {G2.4d, G2.4e, G2.5} No use of factor type objects.
#' @srrstatsNA {G2.14b, G2.14c} Show error message for missing data.
#' @srrstatsNA {G3.1, G3.1a} Software does not use covariance calculations.
#' @srrstatsNA {G4.0} Software does not enables outputs to be written to local
#' files.
#' @srrstatsNA {G5.0} Tests require non-standard data sets.
#' @srrstatsNA {G5.4c} Outputs are not compared to values in published papers.
#' @srrstatsNA {BS1.0} No use of the term "hyperparameter".
#' @srrstatsNA {BS1.2, BS1.2a, BS1.2b, BS1.2c} No prior distributions used.
#' @srrstatsNA {BS1.3, BS1.3a, BS1.3b} Functionality not supported in this
#' package.
#' @srrstatsNA {BS1.4, BS1.5} No convergence checkers used.
#' @srrstatsNA {BS2.2, BS2.3, BS2.4, BS2.5} No distributional parameters used as
#' no prior sampling not used.
#' @srrstatsNA {BS2.7, BS2.9, BS2.10, BS2.11} No Markov Chains used.
#' @srrstatsNA {BS2.8} No subsequent runs used.
#' @srrstatsNA {BS3.1, BS3.2} Collinearity not relevant to package calculations.
#' @srrstatsNA {BS4.3, BS4.4, BS4.5, BS4.6, BS4.7} No convergence checkers used.
#' @srrstatsNA {BS5.3} No convergence statistics used.
#' @srrstatsNA {BS5.4, BS5.5} No convergence checkers used.
#' @srrstatsNA {BS4.1, BS6.2, BS6.3, BS6.5, BS7.0, BS7.1, BS7.2} Prior and
#' Posterior sampling not used.
#' @srrstatsNA {BS7.4, BS7.4a} No predicted/fitted values.
#' @srrstatsNA {EA5.1} Graphing functions do not override default typeface values
#' @srrstatsNA {EA2.4, EA2.5} Multi-tabular inputs not accepted by package
#' @srrstatsNA {EA5.3} No column-based summary statistics used.
#'
#'
#' @noRd
NULL




