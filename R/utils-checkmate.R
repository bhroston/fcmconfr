
################################################################################
# utils-input_validation.R
#
# This contains internal input validation functions to ensure inputs pass
# mutation testing from autotest.
#
#   - check_square_adj_matrix
#   - check_numeric_vector
#   - check_choice_selection
#   - check_positive_number
#   - check_positive_integer
#   - assert_var_name
#
################################################################################

# rOpenSci Statistical Software Standards ----
#' @srrstats {G1.4} *Software should use [`roxygen2`](https://roxygen2.r-lib.org/) to document all functions.*
#' @srrstats {G1.4a} *All internal (non-exported) functions should also be documented in standard [`roxygen2`](https://roxygen2.r-lib.org/) format, along with a final `@noRd` tag to suppress automatic generation of `.Rd` files.*
#' @srrstats {G2.0} *Implement assertions on lengths of inputs, particularly through asserting that inputs expected to be single- or multi-valued are indeed so.*
#' @srrstats {G2.0a} *Provide explicit secondary documentation of any expectations on lengths of inputs*
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
#' @srrstats {G2.2} *Appropriately prohibit or restrict submission of multivariate input to parameters expected to be univariate.*
#' @srrstats {G2.3} *For univariate character input:*
#' @srrstats {G2.3a} *Use `match.arg()` or equivalent where applicable to only permit expected values.*
#' @srrstats {G2.3b} *Either: use `tolower()` or equivalent to ensure input of character parameters is not case dependent; or explicitly document that parameters are strictly case-sensitive.*
#' @srrstats {G2.4} *Provide appropriate mechanisms to convert between different data types, potentially including:*
#' @srrstats {G2.4a} *explicit conversion to `integer` via `as.integer()`*
#' @srrstats {G2.4b} *explicit conversion to continuous via `as.numeric()`*
#' @srrstats {G2.4c} *explicit conversion to character via `as.character()` (and not `paste` or `paste0`)*
#' @srrstats {G2.6} *Software which accepts one-dimensional input should ensure values are appropriately pre-processed regardless of class structures.*
#' @srrstats {G2.7} *Software should accept as input as many of the above standard tabular forms as possible, including extension to domain-specific forms.*
#' @srrstats {G2.9} *Software should issue diagnostic messages for type conversion in which information is lost (such as conversion of variables from factor to character; standardisation of variable names; or removal of meta-data such as those associated with [`sf`-format](https://r-spatial.github.io/sf/) data) or added (such as insertion of variable or column names where none were provided).*
#' @srrstats {G2.12} *Software should ensure that `data.frame`-like tabular objects which have list columns should ensure that those columns are appropriately pre-processed either through being removed, converted to equivalent vector columns where appropriate, or some other appropriate treatment such as an informative error. This behaviour should be tested.*

#' @srrstats {BS1.2c} *Function-level documentation, preferably with code included in examples*
NULL
# ----

#' Check Square Adj. Matrix
#'
#' @description
#' This function checks whether an input (x) is a square adjacency matrix
#' [data.frame]-like object that can be passed throughout fcmconfr functions.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a [matrix] or [data.frame]-like object
#'
#' @returns The input object if x is a square matrix, or an error message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_square_matrix.R
check_square_adj_matrix = function(x = matrix()) {
  produced_warning <- FALSE

  if (methods::is(x)[1] == "list" & length(x) > 1) {
    return(stop(cli::format_error(c(
      "x" = "Error: Adj. Matrix must be an individual adjacency matrix",
      "+++++> Input adj. matrix was a list of {length(x)} adj. matrices."
    ))))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    # return(stop(cli::format_error(c(
    #   "^ fcmconfr found Error(s) and/or Warning(s) ^"
    # ))))
  }

  if ("sparseMatrix" %in% methods::is(x)) {
    warning(cli::format_warning(c(
      "!" = "Warning: Converting sparseMatrix input to matrix"
    )))
    x <- as.matrix(x)
    produced_warning <- TRUE
  }

  class_options <-  c("matrix", "array", "data.frame", "data.table", "tibble", "tbl_df", "sparseMatrix", "ivfn", "tfn")
  class_options_text <- paste0("'", cli::ansi_collapse(class_options, sep = "' '", sep2 = "' or '", last = "' or '"), "'")

  res <- checkmate::check_choice(methods::is(x)[1], choices = class_options)
  if (!isTRUE(res)) {
    x <- tryCatch({
      x_as_df <- x
      class(x_as_df) <- NULL
      x_as_df <- as.data.frame(x_as_df)
      warning(cli::format_warning(c(
        "!" = "Warning: Converting adj. matrix to data.frame"
      )))
      return(x_as_df)
    }, error = function(e) {
      return(stop(cli::format_error(c(
        "x" = "Error: Adj. Matrix must one of the following classes: ", "{class_options_text}",
        "+++++> Input adj. matrix had class: {methods::is(x)[1]}"
      ))))
      # Have to use a different stopping algorithm here to work nicely with
      # autotest
      # return(stop(cli::format_error(c(
      #   "^ fcmconfr found Error(s) and/or Warning(s) ^"
      # ))))
    })
  }

  if (nrow(x) != ncol(x)) {
    return(stop(cli::format_error(c(
      "x" = "Error: Adj. Matrix must be square (i.e. have dimension n x n)",
      "+++++> Input has dimensions {dim(x)}"
    ))))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    # return(stop(cli::format_error(c(
    #   "^ fcmconfr found Error(s) and/or Warning(s) ^"
    # ))))
  }

  if (produced_warning) {
    return("warning")
  } else {
    return(TRUE)
  }
}



#' Check Numeric Vector
#'
#' @description
#' This function checks whether an input (x) is a numeric [vector] object that
#' can be passed throughout fcmconfr functions.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a [vector] of [numeric] values
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object if x is a numeric vector, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_numeric_vector.R
check_numeric_vector = function(x, var_name = "") {
  # Skip test if no input given; an empty input will create an assumed
  # initial_state_vector/clamping_vector
  if (identical(x, c())) {
    return(TRUE)
  }

  var_name <- assert_var_name(var_name)

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  non_numeric_input_can_be_numeric <- all(vapply(x, function(val) !grepl("\\D", val), logical(length(1))))
  if  (non_numeric_input_can_be_numeric) {
    x <- suppressWarnings(as.numeric(x))
  }

  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a numeric vector",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }

  return(TRUE)
}


#' Check Choice Selection
#'
#' @description
#' This function checks whether an input (x) is a [character] string that
#' matches one entry in a given set of choices.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a matrix
#' @param choices a character vector of options for x
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is an item in the choices vector, or an
#' error message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_choice_selection.R
check_choice_selection <- function(x, choices = c(), var_name = "") {
  var_name <- assert_var_name(var_name)

  choices_text <- paste0("'", cli::ansi_collapse(choices, sep = "' '", sep2 = "' or '", last = "' or '"), "'")

  if (length(x) > 1) {
    cli::cli_inform(c(
      "x" = "Error: '{var_name}' must be ONLY one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }

  x <- tolower(x)
  choices <- tolower(choices)

  res <- checkmate::check_choice(x, choices = choices)
  if (!isTRUE(res)) {
    cli::cli_inform(c(
      "x" = "Error: '{var_name}' must be one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  return(TRUE)
}


#' Check Numeric
#'
#' @description
#' This function checks whether an input (x) is a [numeric] object.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a positive [numeric] [> 0]
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a positive number, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_positive_number.R
check_positive_number <- function(x = numeric(), var_name = "") {
  var_name <- assert_var_name(var_name)

  if (length(x) > 1) {
    cli::cli_inform(c(
      "x" = "Error: '{var_name}' must be a single, positive integer value",
      "+++++++> Input {var_name} was: {x}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  if (x <= 0) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }

  return(TRUE)
}


#' Check Integer
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a single, positive [integer] [> 0]
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a positive integer, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_positive_integer.R
check_positive_integer <- function(x = 1L, var_name = "") {
  var_name <- assert_var_name(var_name)

  if (length(x) > 1) {
    cli::format_error(c(
      "x" = "Error: '{var_name}' must be a single, positive integer value",
      "+++++++> Input {var_name} was: {x}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  if (x <= 0) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  if (abs(as.integer(x) - x) > 1e-10) {
    cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} was: {x}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  return(TRUE)
}


#' Assert var_name
#'
#' @description
#' This function checks whether an input (var_name) can be asserted as an
#' acceptable [character] string and if so, asserts var_name is a [character]
#' string using as.character().
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param var_name_input a character object for the name of the input variable
#' to be displayed in the error message
#'
#' @returns the var_name input if acceptable, error messages if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' assert_var_name("one")
#' assert_var_name(1234)
assert_var_name <- function(var_name_input = "") {
  if (length(var_name_input) > 1 | isTRUE(is.na(var_name_input))) {
    cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    ))
    # Have to use a different stopping algorithm here to work nicely with
    # autotest
    return(stop(cli::format_error(c(
      "^ Found the above {.emph Error(s)} and/or {.emph Warning(s)} ^"
    )), call. = FALSE))
  }
  if (methods::is(var_name_input)[1] != "character") {
    var_name_input <- as.character(var_name_input)
  }
  return(var_name_input)
}


