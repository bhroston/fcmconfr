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
#' @srrstatsTODO {G5.7} **Algorithm performance tests** *to test that implementation performs as expected as properties of data change. For instance, a test may show that parameters approach correct estimates within tolerance as data size increases, or that convergence times decrease for higher convergence thresholds.*

#' Bayesian standards
#' @srrstatsTODO {BS7.3} *Bayesian software should include tests which demonstrate and confirm the scaling of algorithmic efficiency with sizes of input data.*

# Exploratory Data Analysis Standards
#'
#' @srrstatsTODO {EA3.0} *The algorithmic components of EDA Software should enable automated extraction and/or reporting of statistics as some sufficiently "meta" level (such as variable or model selection), for which previous or reference implementations require manual intervention.*
#' @srrstatsTODO {EA3.1} *EDA software should enable standardised comparison of inputs, processes, models, or outputs which previous or reference implementations otherwise only enable in some comparably unstandardised form.*
#' @srrstatsTODO {EA4.0} *EDA Software should ensure all return results have types which are consistent with input types.*
#' @srrstatsTODO {EA4.1} *EDA Software should implement parameters to enable explicit control of numeric precision*
#'
#' @srrstatsTODO {EA5.2} *Screen-based output should never rely on default print formatting of `numeric` types, rather should also use some version of `round(., digits)`, `formatC`, `sprintf`, or similar functions for numeric formatting according the parameter described in* **EA4.1**.
#' @srrstatsTODO {EA5.3} *Column-based summary statistics should always indicate the `storage.mode`, `class`, or equivalent defining attribute of each column.*
#' @srrstatsTODO {EA5.4} *All visualisations should ensure values are rounded sensibly (for example, via `pretty()` function).*
#' @srrstatsTODO {EA5.6} *Any packages which internally bundle libraries used for dynamic visualization and which are also bundled in other, pre-existing R packages, should explain the necessity and advantage of re-bundling that library.*

#' @noRd
NULL


#' NA_standards
#'
#' Any non-applicable standards can have their tags changed from `@srrstatsTODO`
#' to `@srrstatsNA`, and placed together in this block, along with explanations
#' for why each of these standards have been deemed not applicable.
#' (These comments may also be deleted at any time.)
#'
#' @srrstatsNA {G2.4d} No use of factor type objects.
#' @srrstatsNA {G2.4e} No use of factor type objects.
#' @srrstatsNA {G2.5} No use of factor type objects.
#' @srrstatsNA {G2.14b} Show error message for missing data.
#' @srrstatsNA {G2.14c} Show error message for missing data.
#' @srrstatsNA {G3.1} Software does not use covariance calculations.
#' @srrstatsNA {G3.1a} Software does not use covariance calculations.
#' @srrstatsNA {G4.0} Software which enables outputs to be written to local files.
#' @srrstatsNA {G5.0} Tests require non-standard data sets.
#' @srrstatsNA {G5.4c} Outputs are not compared to values in published papers.
#' @srrstatsNA {G5.10} No extended tests used.
#' @srrstatsNA {G5.11} No extended tests used.
#' @srrstatsNA {G5.11a} No extended tests used.
#' @srrstatsNA {G5.12} No extended tests used.
#' @srrstatsNA {BS1.0} No use of the term "hyperparameter".
#' @srrstatsNA {BS1.2, BS1.2a, BS1.2b, BS1.2c} No prior distributions used.
#' @srrstatsNA {BS1.3, BS1.3a, BS1.3b} Functionality not supported in this package.
#' @srrstatsNA {BS1.4} No convergence checkers used.
#' @srrstatsNA {BS1.5} No convergence checkers used.
#' @srrstatsNA {BS2.2, BS2.3, BS2.4, BS2.5} No distributional parameters used as
#' no prior sampling not used.
#' @srrstatsNA {BS2.7} No Markov Chains used.
#' @srrstatsNA {BS2.8} No subsequent runs used.
#' @srrstatsNA {BS2.9} No Markov Chains used.
#' @srrstatsNA {BS2.10} No Markov Chains used.
#' @srrstatsNA {BS2.11} No Markov Chains used.
#' @srrstatsNA {BS3.1} Collinearity not relevant to package calculations.
#' @srrstatsNA {BS3.2} Collinearity not relevant to package calculations.
#' @srrstatsNA {BS4.3} No convergence checkers used.
#' @srrstatsNA {BS4.4} No convergence checkers used.
#' @srrstatsNA {BS4.5} No convergence checkers used.
#' @srrstatsNA {BS4.6} No convergence checkers used.
#' @srrstatsNA {BS4.7} No convergence checkers used.
#' @srrstatsNA {BS5.3} No convergence statistics used.
#' @srrstatsNA {BS5.4} No convergence checkers used.
#' @srrstatsNA {BS5.5} No convergence checkers used.
#' @srrstatsNA {BS6.2} Prior and Posterior sampling not used.
#' @srrstatsNA {BS6.3} Prior and Posterior sampling not used.
#' @srrstatsNA {BS6.5} Prior and Posterior sampling not used.
#' @srrstatsNA {BS7.0} Prior and Posterior sampling not used.
#' @srrstatsNA {BS7.1} Prior and Posterior sampling not used.
#' @srrstatsNA {BS7.2} Prior and Posterior sampling not used.
#' @srrstatsNA {BS4.1} Prior and Posterior sampling not used.
#' @srrstatsNA {BS7.4, BS7.4a} No predicted/fitted values.
#' @srrstatsNA {EA5.1} Graphing functions do not override default typeface values
#' @srrstatsNA {EA2.4, EA2.5} Multi-tabular inputs not accepted by package
#'
#'
#' @noRd
NULL




