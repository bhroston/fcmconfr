
################################################################################
# IVFNs_and_TFNs.R
#
# These functions manage and interact with IVFN and TFN objects
#
#   Exported (All)
#   - defuzz_ivfn_or_tfn
#   Interval-Valued Fuzzy Numbers (IVFNs)
#   - make_adj_matrix_w_ivfns
#   - ivfn
#   - create_ivfn_fcm_from_conventional_fcm
#   - subtract_ivfn
#   - print.ivfn
#   - c.ivfn
#   Triangular Fuzzy Numbers (TFNs)
#   - make_adj_matrix_w_tfns
#   - tfn
#   - create_tfn_fcm_from_conventional_fcm
#   - subtract_tfn
#   - print.tfn
#   - c.tfn
#   - rtriangular_dist
#   - plot.rtriangular_dist
#
################################################################################

#' Defuzz (IVFN or TFN)
#'
#' @description
#' Convert a fuzzy number to a crisp value. For IVFNs, return the average of the
#' upper and lower bounds. For TFNs, return the average of the lower bound, the
#' mode, and the upper bound.
#'
#' @details
#' Defuzz-ing an IVFN to a crisp number:
#' \deqn{
#' \left[ x^{L} ,\ x^{U}\right] \ \mapsto \ \frac{x^{L} +x^{U}}{2}
#' }
#' where \eqn{x^{L}, and x^{U}} are the lower and upper bounds of the IVFN.
#'
#' Defuzz-ing a TFN to a crisp number:
#' \deqn{
#' \left[ x^{L} ,\ x^{M} ,\ x^{U}\right] \ \mapsto \ \frac{x^{L} +x^{M} +x^{U}}{3}
#' }
#'
#' where \eqn{x^{L}, x^{M}, and x^{U}} are the lower bound, mode, and upper bound
#' of the TFN.
#'
#' @param fuzzy_number \[`ivfn` or `tfn`] An IVFN or TFN object
#'
#' @returns \[`numeric(1)`]\cr A crisp number representative of the input fuzzy
#' number.
#'
#' @export
#' @examples
#' defuzz_ivfn_or_tfn(ivfn(-1, 1))
#' defuzz_ivfn_or_tfn(tfn(-1, 0, 1))
defuzz_ivfn_or_tfn <- function(fuzzy_number) {
  fuzzy_class <- methods::is(fuzzy_number)[1]
  if (fuzzy_class == "numeric" | fuzzy_class == "integer") {
    crisp_value <- fuzzy_number
  } else if (fuzzy_class == "ivfn") {
    crisp_value <- (fuzzy_number$lower + fuzzy_number$upper)/2
  } else if (fuzzy_class == "tfn") {
    crisp_value <- (fuzzy_number$lower + fuzzy_number$mode + fuzzy_number$upper)/3
  } else {
    stop(cli::format_warning(c(
      "x" = "Error: Cannot defuzz input. Must be either an ivfn or tfn",
      "+++++++> Input {.var fuzzy_number} was of type: {methods::is(fuzzy_number)[1]}"
    )))
  }

  return(crisp_value)
}


# INTERVAL-VALUED FUZZY NUMBERS ----
#' Create Adj. Matrix w/ Edges Represented as IVFNs
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This constructs an adjacency matrix with edges represented by interval-value
#' fuzzy numbers (IVFNs) from an adjacency matrix of lower bounds and an
#' adjacency matrix of upper bounds
#'
#' @details
#' The input adjacency matrices must square n x n matrices with the same dimensions.
#' The input can be either matrix, data.table, tibble, or data.table type objects,
#' but the output will always be a data.frame. This is for output readability.
#' data.table and tibble objects work logically, but their outputs require
#' additional steps to parse from the user's perspective.
#'
#' If the input matrices have named columns, those names will be carried over
#' in the grey adjacency matrix. Otherwise, generic node IDs will be used
#' (C1, C2, ... Cn).
#'
#' @param lower \[`list()` or `data.frame()`]\cr An n x n adjacency matrix that
#' represents the lower limits of edges in an FCM
#' @param upper \[`list()` or `data.frame()`]\cr An n x n adjacency matrix that
#' represents the upper limits of edges in an FCM
#'
#' @returns \[`adj_matrix_w_ivfns`]\cr An adjacency matrix (of class 'ivfn')
#' with edges represented as IVFNs
#'
#' @export
#' @example  man/examples/ex-make_adj_matrix_w_ivfns.R
make_adj_matrix_w_ivfns <- function(lower = data.frame(), upper = data.frame()) {

  check_fcmconfr_input(lower, check = "square_adj_matrix", var_name = "lower")
  check_fcmconfr_input(upper, check = "square_adj_matrix", var_name = "upper")

  lower <- as.data.frame(assert_matrix(lower, fcm_class = "conventional", var_name_input = "lower"))
  upper <- as.data.frame(assert_matrix(upper, fcm_class = "conventional", var_name_input = "upper"))

  check_fcmconfr_input(list(lower, upper), check = "adj_matrix_list", var_name = "lower/upper adj. matrices")

  size <- unique(dim(lower))

  if (identical(colnames(lower), colnames(upper)) & !identical(colnames(lower), NULL)) {
    IDs <- colnames(lower)
  } else {
    IDs <- paste0("C", 1:nrow(lower))
    colnames(lower) <- IDs
    colnames(upper) <- IDs
  }

  if ((!all(lower <= upper))) {
    offense_locs <- unique(rbind(which(!lower <= upper, arr.ind = TRUE)))
    offenses_df <- data.frame(
      row = offense_locs[, 1],
      col = offense_locs[, 2],
      lower = apply(offense_locs, 1, function(locs) lower[locs[1], locs[2]]),
      upper = apply(offense_locs, 1, function(locs) upper[locs[1], locs[2]])
    )
    rownames(offenses_df) <- NULL
    print(offenses_df)
    stop(cli::format_error(c(
      "x" = "Error: Failed to create adj. matrix from input",
      "+++++>  All lower values must be less than or equal to upper values.",
      "+++++>  Check violations printed above."
    )))
  }

  adj_matrix_w_ivfns <- as.data.frame(matrix(data = list(0), nrow = size, ncol = size))
  colnames(adj_matrix_w_ivfns) <- IDs
  rownames(adj_matrix_w_ivfns) <- IDs

  for (i in 1:length(IDs)) {
    for (j in 1:length(IDs)) {
      adj_matrix_w_ivfns[[j]][[i]] <- ivfn(
        # [[j]][[i]] instead of [[i]][[j]]
        # because this notation is
        # [[col]][[row]] for data.frames
        lower = lower[i, j],
        upper = upper[i, j]
      )
    }
  }

  class(adj_matrix_w_ivfns) <- c("adj_matrix_w_ivfns", methods::is(adj_matrix_w_ivfns))

  return(adj_matrix_w_ivfns)
}



#' Interval-Valued Fuzzy Number (IVFN) - S3 Class
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This constructs an interval-valued fuzzy number (ivfn) that represents a
#' continuous, uniform distribution of values within a given range
#'
#' @details
#' The IVFN class does not perform any operations on its input, rather
#' it checks whether the input follows the defining criteria of IVFNs
#'
#' For IVFNs, the lower bound must be less than or equal to the upper bound.
#' If the lower bound and upper bound are equal, the IVFN represents a "crisp"
#' numeric value.
#'
#' \deqn{
#' \mathbf{IVFN} :\ \left[ x^{L} ,\ x^{U}\right]
#' }
#' where \eqn{x^{L}} and \eqn{x^{U}} are the lower and upper bounds of the IVFN.
#'
#' @param lower \[`double()` - Unrestriced (positive or negative)]\cr The lower
#' bound of an IVFN
#' @param upper \[`double()` - Unrestriced (positive or negative)]\cr The upper
#' bound of an IVFN
#'
#' @returns \[`ivfn`]\cr An interval-valued fuzzy number (IVFN)
#'
#' @references \insertRef{mooreIntervalAnalysisFuzzy2003}{fcmconfr}
#' @references \insertRef{dimuroIntervalFuzzyNumbers2011}{fcmconfr}
#'
#' @export
#' @examples
#' ivfn(lower = 0.0, upper = 1.0)
#' ivfn(-1.0, 1.0)
ivfn <- function(lower = double(), upper = double()) {
  lower <- unlist(lower)
  upper <- unlist(upper)

  check_fcmconfr_input(lower, check = "numeric_vector", var_name = "lower")
  check_fcmconfr_input(upper, check = "numeric_vector", var_name = "upper")

  lower <- as.numeric(lower)
  upper <- as.numeric(upper)

  if (identical(lower, double()) && identical(upper, double())) {
    lower <- 0
    upper <- 0
  }

  if (identical(lower, double()) || identical(upper, double())) {
    stop(cli::format_error(c(
      "x" = "Error: IVFN must have defined lower and upper inputs"
    )))
  }

  if (lower > upper) {
    stop(cli::format_error(c(
      "x" = "Error: {.var lower} must be less than or equal to {.var upper}",
      "+++++> Input {.var lower} was: {lower}",
      "+++++> Input {.var upper} was: {upper}"
    )))
  }

  return(structure(
    .Data = data.frame(lower = lower, upper = upper),
    class = "ivfn"
  ))
}



#' Create TFN-FCM from Conventional FCM
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This creates an IVFN-FCM from a Conventional FCM by adding error to the
#' Conventional FCM edge weights.
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single, conventional
#' adjacency matrix (n x n) representing FCMs.
#' @param error \[`double(1)`]\cr  The +/- error defining the lower and upper
#' bounds of the IVFN edge weights created from the numeric edge weights
#'
#' @returns \[`adj_matrix_w_ivfns`]\cr An adjacency matrix (of class 'ivfn')
#' with edges represented as IVFNs
#'
#' @export
#' @examples
#' create_ivfn_fcm_from_conventional_fcm(
#'   sample_fcms$simple_fcms$conventional_fcms[[1]],
#'   error = 0.2
#' )
create_ivfn_fcm_from_conventional_fcm <- function(conventional_adj_matrix = data.frame(),
                                                  error =0.2) {
  only_positive_values <- ifelse(all(conventional_adj_matrix >= 0), TRUE, FALSE)
  adj_matrix_w_ivfns <- as.data.frame(apply(
    conventional_adj_matrix, c(1, 2),
    function(element) {
      if (element == 0) {
        return(ivfn(0, 0))
      }

      try_lower <- element - error
      if (only_positive_values & try_lower < 0) {
        use_lower <- 0
      } else if (!only_positive_values & try_lower < -1) {
        use_lower <- -1
      } else if (try_lower < 0 & element > 0) {
        use_lower <- 0
      } else {
        use_lower <- try_lower
      }

      try_upper <- element + error
      if (try_upper > 1) {
        use_upper <- 1
      } else if (try_upper > 0 & element < 0) {
        use_upper <- 0
      } else {
        use_upper <- try_upper
      }

      ivfn(use_lower, use_upper)
    }
  ))

  return(
    adj_matrix_w_ivfns
  )
}


#' IVFN Subtraction (Interval Calculus)
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This subtracts one Interval-Value Fuzzy Number (IVFN) from another via
#' interval calculus. An IVFN represented by the interval X:
#'
#' \deqn{X\  =( x_{1}, x_{3}) \ =\ [ x_{1} ;x_{2}] =\{x\in \mathbb{R} \ |\ x_{1} \ \leq x\ \leq x_{2}\}}{ascii}
#'
#' where \eqn{x_1}{ascii} and \eqn{x_2}{ascii} represent the lower and upper
#' bounds, respectively.
#'
#' The IVFN X may have another IVFN Y subtracted from it via:
#'
#' \deqn{X\ -\ Y\ =\ [ x_{1} \ -\ y_{2} ;\ x_{2} \ -\ y_{1}]}{ascii}
#'
#' @details
#' It is not required for one IVFN to be "greater than" the other.
#'
#' This difference may also be estimated by translating the IVFN's into
#' their corresponding distributions (e.g. ivfn(-1, 1) = runif(n, -1, 1)),
#' subtracting one distribution from the other, and estimating the minimum
#' and maximum values of the difference distribution.
#'
#' @references \insertRef{mooreIntervalAnalysisFuzzy2003}{fcmconfr}
#' @references \insertRef{dimuroIntervalFuzzyNumbers2011}{fcmconfr}
#' @references \insertRef{mooreIntervalAnalysis1966}{fcmconfr}
#'
#' @param ivfn_1 \[`ivfn`]\cr  An interval-value fuzzy number (ivfn) object
#' @param ivfn_2 \[`ivfn`]\cr  An interval-value fuzzy number (ivfn) object
#'
#' @returns \[`ivfn`]\cr An IVFN object representing the subtraction of
#' ivfn_2 from ivfn_1
#'
#' @importFrom Rdpack reprompt
#' @importFrom methods is
#'
#' @export
#' @examples
#' subtract_ivfn(ivfn(0.5, 0.8), ivfn(0.2, 0.5))
#' subtract_ivfn(ivfn(-0.5, 0.3), ivfn(0.4, 0.6))
#' subtract_ivfn(ivfn(-1, 1), ivfn(-0.5, 0.5))
subtract_ivfn <- function(ivfn_1 = ivfn(), ivfn_2 = ivfn()) {

  check_fcmconfr_input(c(ivfn_1), check = "ivfn_vector", var_name = "ivfn_1")
  check_fcmconfr_input(c(ivfn_2), check = "ivfn_vector", var_name = "ivfn_2")

  new_lower <- ivfn_1$lower - ivfn_2$upper

  # Moore & Lodwick (2003)
  new_upper <- ivfn_1$upper - ivfn_2$lower

  # Hajek & Prochazka (2016)
  #new_upper <- max(ivfn_1$lower - ivfn_2$lower, ivfn_1$upper - ivfn_2$upper)

  # The two methods to calculate the upper value for the difference are
  # both referenced throughout the literature. However, after testing, Moore
  # & Lodwick (2003) was found to produce more reliable results.

  return(ivfn(new_lower, new_upper))
}



#' Print an Interval-Valued Fuzzy Number (IVFN) - S3 Class
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This prints an ivfn object
#'
#' @param x \[`ivfn`]\cr a ivfn object
#' @param ... additional inputs
#'
#' @returns \[`NULL`]\cr A console printout of an IVFN object
#'
#' @export
#' @examples
#' print(ivfn(-1, 1))
print.ivfn <- function(x, ...) {
  return(
    cat(class(x), ": [", x$lower, ", ", x$upper, "]", sep = "")
  )
}


#' c.ivfn
#'
#' @family interval-valued-fuzzy-numbers
#'
#' @description
#' This forces the output of c() to the equivalent of list() only for inputs of
#' type ivfn
#'
#' @details
#' For ivfn objects, c() combines all of the lower and upper data into
#' a single ivfn object, but list() returns the expected output of a
#' list of distinct ivfn objects.
#'
#' @param ... a set of ivfn objects
#'
#' @returns \[`list()`]\cr A list of ivfn objects
#'
#' @export
#' @examples
#' c(ivfn(0, 1), ivfn(0.2, 0.5))
c.ivfn <- function(...) {
  return(list(...))
}


# ----
# TRIANGULAR FUZZY NUMBERS (TFNs) ----

#' Create Adj. Matrix w/ Edges Represented as TFNs
#'
#' @family triangular-fuzzy-numbers
#'
#' @description
#' This constructs an adjacency matrix with edges represented by triangular
#' fuzzy numbers (TFNs) from an adjacency matrix of lower bounds, an adjacency
#' matrix of modes, and an adjacency matrix of upper bounds
#'
#' @details
#' The input adjacency matrices must square n x n matrices with the same dimensions.
#' The input can be either matrix, data.table, tibble, or data.table type objects,
#' but the output will always be a data.frame. This is for output readability.
#' data.table and tibble objects work logically, but their outputs require
#' additional steps to parse from the user's perspective.
#'
#' If the input matrices have named columns, those names will be carried over
#' in the triangular adjacency matrix. Otherwise, generic node IDs will be used
#' (C1, C2, ... Cn).
#'
#' @param lower \[`list()` or `data.frame()`]\cr An n x n adjacency matrix that
#' represents the lower limits of edges in an FCM
#' @param mode \[`list()` or `data.frame()`]\cr An n x n adjacency matrix that
#' represents the modes (most likely values) of edges in an FCM
#' @param upper \[`list()` or `data.frame()`]\cr An n x n adjacency matrix that
#' represents the upper limits of edges in an FCM
#'
#' @returns \[`adj_matrix_w_tfns`]\cr An adjacency matrix (of class 'tfn') with
#' edges represented as TFNs
#'
#' @export
#' @example  man/examples/ex-make_adj_matrix_w_tfns.R
make_adj_matrix_w_tfns <- function(lower = data.frame(),
                                   mode = data.frame(),
                                   upper = data.frame()) {

  check_fcmconfr_input(lower, check = "square_adj_matrix", var_name = "lower")
  check_fcmconfr_input(mode, check = "square_adj_matrix", var_name = "mode")
  check_fcmconfr_input(upper, check = "square_adj_matrix", var_name = "upper")

  lower <- as.data.frame(assert_matrix(lower, fcm_class = "conventional", var_name_input = "lower"))
  mode <- as.data.frame(assert_matrix(mode, fcm_class = "conventional", var_name_input = "mode"))
  upper <- as.data.frame(assert_matrix(upper, fcm_class = "conventional", var_name_input = "upper"))

  check_fcmconfr_input(list(lower, mode, upper), check = "adj_matrix_list", var_name = "lower/upper adj. matrices")

  size <- unique(dim(lower))

  all_input_matrices_have_same_colnames <- length(unique(list(colnames(lower), colnames(mode), colnames(upper)))) == 1
  if (all_input_matrices_have_same_colnames & !identical(colnames(lower), NULL)) {
    IDs <- colnames(lower)
  } else {
    IDs <- paste0("C", 1:nrow(lower))
  }

  if ((!all(lower <= mode) || !all(mode <= upper))) {
    offense_locs <- unique(rbind(which(!lower <= mode, arr.ind = TRUE), which(!mode <= upper, arr.ind = TRUE)))
    offenses_df <- data.frame(
      row = offense_locs[, 1],
      col = offense_locs[, 2],
      lower = apply(offense_locs, 1, function(locs) lower[locs[1], locs[2]]),
      mode = apply(offense_locs, 1, function(locs) mode[locs[1], locs[2]]),
      upper = apply(offense_locs, 1,function(locs) upper[locs[1], locs[2]])
    )
    rownames(offenses_df) <- NULL
    print(offenses_df)
    stop(cli::format_error(c(
      "x" = "Error: Failed to create adj. matrix from input",
      "+++++>  All lower values must be less than or equal to mode values which in turn, \n  must be less than or equal to upper values.",
      "+++++>  Check offenses printed above."
    )))
  }

  adj_matrix_w_tfns <- as.data.frame(matrix(data = list(0), nrow = size, ncol = size))
  colnames(adj_matrix_w_tfns) <- IDs
  rownames(adj_matrix_w_tfns) <- IDs

  for (i in 1:length(IDs)) {
    for (j in 1:length(IDs)) {
      adj_matrix_w_tfns[[j]][[i]] <- tfn(
        # [[j]][[i]] instead of [[i]][[j]]
        # because this notation is
        # [[col]][[row]] for data.frames
        lower = lower[i, j],
        mode = mode[i, j],
        upper = upper[i, j]
      )
    }
  }

  class(adj_matrix_w_tfns) <- c("adj_matrix_w_tfns", methods::is(adj_matrix_w_tfns))

  return(adj_matrix_w_tfns)
}



#' Triangular Fuzzy Number (TFN) - S3 Class
#'
#' @family triangular-fuzzy-numbers
#'
#' @description
#' This constructs an triangular fuzzy number (ivfn) that represents a
#' continuous, triangular distribution of values within a given range
#'
#' @details
#' The TFN class does not perform any operations on its input, rather
#' it checks whether the input follows the defining criteria of TFNs
#'
#' For TFNs, the lower bound must be less than or equal to the mode which must
#' be less than or equal to the upper bound.
#' If the lower bound, mode, and upper bound are equal, the TFN represents a
#' "crisp" numeric value.
#'
#' \deqn{
#' \mathbf{TFN} :\ \left[ x^{L} ,\ x^{M} ,\ x^{U}\right]
#' }
#' where \eqn{x^{L}}, \eqn{x^{M}}, and \eqn{x^{U}} are the lower bound, mode,
#' and upper bound of the TFN.
#'
#' @param lower \[`double(1)` - Unrestriced (positive or negative)]\cr The lower
#' limit of a Triangular Number set (the lower value must be less than or equal
#' to the upper value)
#' @param mode \[`double(1)` - Unrestriced (positive or negative)]\cr The most
#' likely value of a Triangular Number set
#' @param upper  \[`double(1)` - Unrestriced (positive or negative)]\cr The
#' upper limit of a Triangular Number set (the upper value must be greater or
#' equal to the lower value)
#'
#' @returns \[`tfn`]\cr A triangular fuzzy number (TFN)
#'
#' @references \insertRef{chakravertyFuzzyNumbers2019}{fcmconfr}
#' @references \insertRef{hanssAppliedFuzzyArithmetic2005}{fcmconfr}
#' @references \insertRef{trillasFuzzyArithmetic2015}{fcmconfr}
#'
#' @export
#' @examples
#' tfn(lower = -1.0, mode = 0.0, upper = 1.0)
#' tfn(0, 0.5, 0.8)
#' tfn(-0.3, 0.1, 0.4)
tfn <- function(lower = double(), mode = double(), upper = double()) {
  lower <- unlist(lower)
  mode <- unlist(mode)
  upper <- unlist(upper)

  check_fcmconfr_input(lower, check = "numeric_vector", var_name = "lower")
  check_fcmconfr_input(mode, check = "numeric_vector", var_name = "mode")
  check_fcmconfr_input(upper, check = "numeric_vector", var_name = "upper")

  lower <- as.numeric(lower)
  mode <- as.numeric(mode)
  upper <- as.numeric(upper)

  if (identical(lower, double()) && identical(mode, double()) && identical(upper, double())) {
    lower <- 0
    mode <- 0
    upper <- 0
  }

  if (identical(lower, double()) || identical(mode, double()) || identical(upper, double())) {
    stop(cli::format_error(c(
      "x" = "Error: TFN must have defined lower, mode, and upper inputs"
    )))
  }

  if (lower > upper || lower > mode) {
    stop(cli::format_error(c(
      "x" = "Error: {.var lower} must be less than or equal to {.var mode}, which in turn must be less than or equal to {.var upper}",
      "+++++> Input {.var lower} was: {lower}",
      "+++++> Input {.var mode} was: {mode}",
      "+++++> Input {.var upper} was: {upper}"
    )))
  }

  if (mode > upper) {
    stop(cli::format_error(c(
      "x" = "Error: {.var lower} must be less than or equal to {.var mode}, which in turn must be less than or equal to {.var upper}",
      "+++++> Input {.var lower} was: {lower}",
      "+++++> Input {.var mode} was: {mode}",
      "+++++> Input {.var upper} was: {upper}"
    )))
  }

  return(structure(
    .Data = data.frame(lower = lower, mode = mode, upper = upper),
    class = "tfn"
  ))
}



#' Create TFN-FCM from Conventional FCM
#'
#' @family triangular-fuzzy-numbers
#'
#' @description
#' This creates an TFN-FCM from a Conventional FCM by adding error to the
#' Conventional FCM edge weights. The Conventional FCM edge weights are used
#' as the mode values for the TFN edge weights.
#'
#' @param adj_matrix \[`list() or data.frame()`]\cr A single, conventional
#' adjacency matrix (n x n) representing FCMs.
#' @param error \[`double(1)`]\cr  The +/- error defining the lower and upper
#' bounds of the TFN edge weights created from the numeric edge weights.
#'
#' @returns \[`adj_matrix_w_tfns`]\cr An adjacency matrix (of class 'tfn')
#' with edges represented as TFNs
#'
#' @export
#' @examples
#' create_tfn_fcm_from_conventional_fcm(
#'   sample_fcms$simple_fcms$conventional_fcms[[1]],
#'   error = 0.2
#' )
create_tfn_fcm_from_conventional_fcm <- function(conventional_adj_matrix = data.frame(),
                                                 error = 0.2) {
  only_positive_values <- ifelse(all(conventional_adj_matrix >= 0), TRUE, FALSE)
  adj_matrix_w_tfns <- as.data.frame(apply(
    conventional_adj_matrix, c(1, 2),
    function(element) {
      if (element == 0) {
        return(tfn(0, 0, 0))
      }

      try_lower <- element - error
      if (only_positive_values & try_lower < 0) {
        use_lower <- 0
      } else if (!only_positive_values & try_lower < -1) {
        use_lower <- -1
      } else if (try_lower < 0 & element > 0) {
        use_lower <- 0
      } else {
        use_lower <- try_lower
      }

      try_upper <- element + error
      if (try_upper > 1) {
        use_upper <- 1
      } else if (try_upper > 0 & element < 0) {
        use_upper <- 0
      } else {
        use_upper <- try_upper
      }

      tfn(use_lower, element, use_upper)
    }
  ))

  return(
    adj_matrix_w_tfns
  )
}




#' TFN Subtraction (Interval Calculus)
#'
#' @family triangular-fuzzy-numbers
#'
#' @description
#' This subtracts one Triangular Fuzzy Number (TFN) from another via
#' interval calculus. A TFN represented by the fuzzy set (triangular distribution):
#'
#' \deqn{X\  =( x_{1} ,x_{2} ,x_{3}) \ =\ \left\{\begin{matrix}
#' 0 & for\  & x< x_{1}\\
#' \frac{2( x\ -\ x_{1})}{( x_{3} -x_{1})( x_{2} -x_{1})} & for\  & x_{1} \leq x< x_{3} \ \\
#' \frac{2}{x_{3} -x_{1}} & for & x\ =\ x_{2}\\
#' \frac{2( x_{3} -x)}{( x_{3} -x_{1})( x_{3} -x_{2})} & for\  & x_{2} < x\leq x_{3}\\
#' 0 & for & x >x_{3}
#' \end{matrix}\right.}{ascii}
#'
#' where \eqn{x_1}{ascii} and \eqn{x_3}{ascii} are the lower and upper bounds, respectively,
#' and \eqn{x_2}{ascii} is the mode.
#'
#' The TFN X may have another TFN Y subtracted from it via:
#'
#' \deqn{X\ -\ Y\ =\ ( x_{1} -y_{3} ,\ x_{2} -y_{2} ,\ x_{3} -y_{1})}{ascii}
#'
#' @details
#' It is not required for one IVFN to be "greater than" the other.
#'
#' This difference may also be estimated by translating the TFN's into
#' their corresponding distributions
#' (e.g. tfn(-1, 0, 1) = EnvStats::rtri(n, min = -1, max = 1, mode = 0)),
#' subtracting one distribution from the other, and estimating the minimum,
#' mode, and maximum values of the difference distribution.
#'
#' @references \insertRef{chakravertyFuzzyNumbers2019}{fcmconfr}
#' @references \insertRef{hanssAppliedFuzzyArithmetic2005}{fcmconfr}
#' @references \insertRef{trillasFuzzyArithmetic2015}{fcmconfr}
#'
#' @param tfn_1 \[`tfn`]\cr A triangular fuzzy number (tfn) object
#' @param tfn_2 \[`tfn`]\cr A triangular fuzzy number (tfn) object
#'
#' @returns \[`tfn`]\cr An TFN object representing the subtraction of tfn_2
#' from tfn_1
#'
#' @export
#' @examples
#' subtract_tfn(tfn(lower = 0.5, mode = 0.6, upper = 0.8), tfn(lower = 0.2, mode = 0.3, upper = 0.5))
#' subtract_tfn(tfn(-0.5, -0.2, 0.3), tfn(0.4, 0.5, 0.6))
#' subtract_tfn(tfn(-1, 0, 1), tfn(-0.5, 0, 0.5))
subtract_tfn <- function(tfn_1 = tfn(), tfn_2 = tfn()) {

  check_fcmconfr_input(c(tfn_1), check = "tfn_vector", var_name = "tfn_1")
  check_fcmconfr_input(c(tfn_2), check = "tfn_vector", var_name = "tfn_2")

  new_lower <- tfn_1$lower - tfn_2$upper
  new_mode <- tfn_1$mode - tfn_2$mode
  new_upper <- tfn_1$upper - tfn_2$lower

  return(tfn(new_lower, new_mode, new_upper))
}



#' Print a Triangular Fuzzy Number (TFN)
#'
#' @family triangular-fuzzy-numbers
#'
#' @description
#' This improves the readability of the output
#'
#' @description
#' This prints a tfn object
#'
#' @param x a tfn object
#' @param ... additional inputs
#'
#' @returns A console printout of a TFN object
#'
#' @export
#' @examples
#' tfn(-1, 0, 1)
print.tfn <- function(x, ...) {
  return(
    cat(class(x), ": [", x$lower, ", ", x$mode, ", ", x$upper, "]", sep = "")
  )
}


#' c.tfn
#'
#' @family triangular-fuzzy-numbers@family triangular-fuzzy-numbers
#'
#' @description
#' This forces the output of c() to the equivalent of list() only for inputs of
#' type tfn
#'
#' @details
#' For tfn objects, c() combines all of the lower and upper data into
#' a single tfn object, but list() returns the expected output of a
#' list of distinct tfn objects.
#'
#' @param ... a set of tfn objects
#'
#' @returns a list of tfn objects
#'
#' @export
#' @examples
#' c(tfn(0, 0.5, 1), tfn(0.2, 0.4, 0.5))
c.tfn <- function(...) {
  return(list(...))
}



#' The Triangular Distribution
#'
#' @description
#' This function generates a triangular distribution on the interval from lower
#' to upper bounds with a a given mode,
#'
#' @param n \[`integer(1)` - Positive]\cr The number of samples to draw from the triangular
#' distribution
#' @param lower \[`double(1)` - Unrestriced (positive or negative)]\cr The lower
#' limit or minimum of the sample space
#' @param mode \[`double(1)` - Unrestriced (positive or negative)]\cr  The peak
#' of the sample space
#' @param upper \[`double(1)` - Unrestriced (positive or negative)]\cr The upper
#' limit or maximum of the sample space
#'
#' @returns \[`rtriangular_dist`]\cr a vector of values representing a
#' triangular distribution
#'
#' @export
#' @example  man/examples/ex-rtriangular_dist.R
rtriangular_dist <- function(n = integer(), lower = double(), mode = double(), upper = double()) {
  check_fcmconfr_input(n, check = "positive_integer", var_name = "n")
  check_fcmconfr_input(c(lower), check = "numeric_vector", var_name = "lower")
  check_fcmconfr_input(c(mode), check = "numeric_vector", var_name = "mode")
  check_fcmconfr_input(c(upper), check = "numeric_vector", var_name = "upper")

  n <- as.integer(n)
  lower <- as.numeric(lower)
  mode <- as.numeric(mode)
  upper <- as.numeric(upper)

  # Confirm lower <= mode <= upper
  tfn(lower, mode, upper)

  if (identical(mode, double())) {
    mode <- (lower + upper)/2
  }

  if (lower == upper) {
    midpoint_domain <- 0
  } else {
    midpoint_domain <- (mode - lower)/(upper - lower)
  }

  inv_cdf <- vector(mode = "numeric", length = n)
  for (i in 1:n) {
    x <- i/n
    if (x <= midpoint_domain) {
      inv_cdf[i] <- lower + sqrt((mode - lower)*(upper - lower)*x)
    } else if (x > midpoint_domain) {
      inv_cdf[i] <- upper - sqrt((upper - lower)*(upper - mode)*(1 - x))
    }
  }
  values_distribution <- inv_cdf

  return(structure(
    .Data = values_distribution,
    .label = paste0("rtriangular_dist(", n, ", ", lower, ", ", mode, ", ", upper, ")"),
    class = "rtriangular_dist"
  ))
}


#' plot.rtriangular_dist
#'
#' @description
#' Plot rtriangular_dist distribution similar to how runif is plotted with the base plot function
#'
#' @param x \[`rtriangular_dis`]\cr An rtriangular_dist object
#' @param ... additional inputs (leave empty)
#'
#' @returns A plot of the triangular distribution generated by rtriangular_dist
#' (in the vain of plot(runif))
#'
#' @export
#' @examples
#' plot(rtriangular_dist(n = 1000L, lower = -1.0, mode = 0.0, upper = 1.0))
plot.rtriangular_dist <- function(x, ...) {
  index <- sample(1:length(x), length(x), replace = FALSE)
  return(
    plot(x = index, y = x, xlab = "Index", ylab = attr(x, ".label"))
  )
}
