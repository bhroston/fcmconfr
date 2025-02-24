
################################################################################
# utils-input_checks.R
#
# This contains internal input validation functions to ensure inputs pass
# mutation testing from autotest.
#
#   - check_fcmconfr_input
#   - check_square_adj_matrix
#   - check_numeric_vector
#   - check_choice_selection
#   - check_positive_number
#   - check_positive_integer
#   - check_logical
#   - assert_var_name
#   - check_access_to_parallel_processing_and_progress_display_functionalities
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


#' Check fcmconfr Input
#'
#' @description
#' This function checks whether an input (x) is an acceptable input for a
#' particular type of fcmoconfr input (e.g. a square adjacency matrix,
#' a numeric vector, a choice from a particular set of choices, a positive
#' number, a positive integer, or a logical value).
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x A character string, a [numeric]/[numercic vector], a [matrix]
#' or [data.frame]-like object, or a [logical] (TRUE/FALSE) value
#' @param check A character of the check to perform. Must be one of the
#' following:
#'  \itemize{
#'    \item{square_adj_matrix - checks that the input is a square adjacency matrix
#'    that can be passed throughout the suite of fcmconfr functions}
#'    \item{numeric_vector - checks that the input is a vector (length > 1) of
#'    numeric-type objects}
#'    \item{choice_selection - checks that the input is one of a given set
#'    of choices. Must include the additional 'choices' parameter (see example)}
#'    \item{positive_number - checks that the input is a positive numeric-type
#'    object (i.e. passes is.numeric(x))}
#'    \item{positive_integer - checks that the input is a positive integer; in
#'    that as.integer(x) returns the same as (x), but does not necessarily
#'    require that (x) is the 'integer'-type R object}
#'    \item{logical - checks that the input is a logical (TRUE/FALSE) value}
#'  }
#' @param var_name A [character] string of the variable name of (x)
#' @param choice_selection_opts ONLY used if check = 'choice_selection'. A
#' vector of character strings; choices to make sure the 'choice_selection'
#' check ensures a match.
#'
#' @returns TRUE if the input passes the selected check, or an error if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_fcmconfr_input.R
check_fcmconfr_input <- function(x,
                                 check = c("square_adj_matrix", "numeric_vector", "choice_selection", "positive_number", "positive_integer", "logical"),
                                 var_name = character(),
                                 choice_selection_opts = c()) {

  var_name <- assert_var_name(var_name)

  check_choices <-  c("square_adj_matrix", "numeric_vector", "choice_selection", "positive_number", "positive_integer", "logical")
  check_choices_text <- paste0("'", cli::ansi_collapse(check_choices, sep = "' '", sep2 = "' or '", last = "' or '"), "'")

  if (length(check) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: '{check}' must be ONLY one of the following: {check_choices_text}",
      "+++++++> Input {.var check} was: {check}"
    )))
  }

  check <- tolower(check)

  res <- checkmate::check_choice(check, choices = check_choices)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: '{check}' must be one of the following: {check_choices_text}",
      "+++++++> Input {.var check} was: {check}"
    )))
  }

  if (identical(check, "choice_selection") && identical(choice_selection_opts, c())) {

    stop(cli::format_error(c(
      "x" = "Error: {.var choice_selection_opts} must be defined if check = 'choice_selection'"
    )))
  }

  if (check == "square_adj_matrix") {
    check_square_adj_matrix(x)
  } else if (check == "choice_selection") {
    check_choice_selection(x, choices = choice_selection_opts, var_name = var_name)
  } else if (check == "numeric_vector") {
    check_numeric_vector(x, var_name = var_name)
  } else if (check == "positive_number") {
    check_positive_number(x, var_name = var_name)
  } else if (check == "positive_integer") {
    check_positive_integer(x, var_name = var_name)
  } else if (check == "logical") {
    check_logical(x, var_name = var_name)
  }

  return(TRUE)
}


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
#' @returns TRUE if x is a square matrix, or an error message if not
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
    })
  }

  if (nrow(x) != ncol(x)) {
    return(stop(cli::format_error(c(
      "x" = "Error: Adj. Matrix must be square (i.e. have dimension n x n)",
      "+++++> Input has dimensions {dim(x)}"
    ))))
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
  # initial_state_vector/clamping_vector in the check function that called this
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
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a numeric vector",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
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
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be ONLY one of the following: {choices_text}",
      "+++++++> Input {.var var_name} was: '{x}'"
    )))
  }

  x <- tolower(x)
  choices <- tolower(choices)

  res <- checkmate::check_choice(x, choices = choices)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be one of the following: {choices_text}",
      "+++++++> Input {.var var_name} was: '{x}'"
    )))
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
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a single, positive integer value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  if (x <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    )))
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
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a single, positive integer value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  if (x <= 0) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }
  if (abs(as.integer(x) - x) > 1e-10) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} was: {x}"
    )))
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
#' @param x a single, [logical] TRUE/FALSE value
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a logical value, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_logical.R
check_logical <- function(x = TRUE, var_name = "") {
  var_name <- assert_var_name(var_name)

  if (length(x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a single, logical (TRUE/FALSE) value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  class_of_x <- methods::is(x)
  res <- checkmate::check_logical(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.logical(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_logical(x)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a logical (TRUE/FALSE) value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
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
  if (length(var_name_input) > 1 || isTRUE(is.na(var_name_input))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name_input} must be a single character object",
      "+++++++> Input {.var var_name_input} had length: {length(var_name_input)}"
    )))
  }
  if (methods::is(var_name_input)[1] != "character") {
    var_name_input <- as.character(var_name_input)
  }
  return(var_name_input)
}



#' Check if the local machine can access internal parallel processing and progress display functionalities
#'
#' @family utility
#'
#' @description
#' Check whether the local machine has access to the necessary packages to
#' run code in parallel and/or using a progress bar. Specifically, checks for
#' the parallel, doSNOW, foreach, and pbapply packages.
#'
#' @details
#' Confirms that a local machine can access the required packages for parallel
#' processing and/or displaying progress bars at runtime. Will revise inputs
#' if particular packages are unavailable and warn the user of such changes, but will
#' not halt a run.
#'
#' @param use_parallel A [logical] (TRUE/FALSE) object declaring whether the
#' user intends to use parallel processing (TRUE) or not (FALSE)
#' @param use_show_progress A [logical] (TRUE/FALSE) object declaring whether
#' the user intends to display progress bars (TRUE) or not (FALSE)
#' @param testing_use_parallel A [logical] (TRUE/FALSE) object declaring whether
#' the function should be run as a test that restricts access to packages
#' required for parallel processing (TRUE) to force use_parallel to FALSE or
#' not (FALSE)
#' @param testing_use_show_progress A [logical] (TRUE/FALSE) object declaring
#' whether the function should be run as a test that restricts access to
#' packages required for progress display (TRUE) to force use_show_progress
#' to FALSE or not (FALSE)
#'
#' @returns TRUE/FALSE Whether the machine has access to the dependencies to
#' access internal parallel processing functionalities
#'
#' @keywords internal
#' @noRd
#'
#' @example man/examples/ex-check_access_to_parallel_processing_and_progress_display_functionalities.R
check_access_to_parallel_processing_and_progress_display_functionalities <- function(use_parallel = TRUE,
                                                                                     use_show_progress = TRUE,
                                                                                     testing_use_parallel = FALSE,
                                                                                     testing_use_show_progress = FALSE) {

  check_fcmconfr_input(use_parallel, "logical", var_name = "use_parallel")
  check_fcmconfr_input(use_show_progress, "logical", var_name = "use_show_progress")
  check_fcmconfr_input(testing_use_parallel, "logical", var_name = "testing_use_parallel")
  check_fcmconfr_input(testing_use_show_progress, "logical", var_name = "testing_use_show_progress")

  local_machine_has_access_to_parallel <- requireNamespace("parallel")
  local_machine_has_access_to_doSNOW <- requireNamespace("doSNOW")
  local_machine_has_access_to_foreach <- requireNamespace("foreach")

  local_machine_has_access_to_pbapply <- requireNamespace("pbapply")

  can_run_in_parallel_and_can_show_progress <- (local_machine_has_access_to_parallel && local_machine_has_access_to_doSNOW && local_machine_has_access_to_foreach)
  can_run_in_parallel_and_cannot_show_progress <- (local_machine_has_access_to_parallel)
  can_show_progress <- local_machine_has_access_to_pbapply

  if ((use_parallel && use_show_progress) && (!can_run_in_parallel_and_can_show_progress || testing_use_parallel) && (can_show_progress && !testing_use_show_progress)) {
    warning(cli::format_warning(c(
      "!" = "Parallel processing with progress pisplay requires the 'parallel', 'doSNOW' and 'foreach' packages which are not currently installed.",
      "~~~~~> Running without parallel processing, but with progress display"
    )))
    use_parallel <- FALSE
    use_show_progress <- TRUE
  } else if ((use_parallel && use_show_progress) && (!can_run_in_parallel_and_can_show_progress || testing_use_parallel) && (!can_show_progress || testing_use_show_progress)) {
    warning(cli::format_warning(c(
      "!" = "Parallel processing with progress pisplay requires the 'parallel', 'doSNOW' and 'foreach' packages which are not currently installed.",
      "~~~~~> Running without parallel processing or progress display"
    )))
    use_parallel <- FALSE
    use_show_progress <- FALSE
  } else if ((use_parallel && !use_show_progress) && (!local_machine_has_access_to_parallel || testing_use_parallel) && (can_show_progress && !testing_use_show_progress)) {
    warning(cli::format_warning(c(
      "!" = "Parallel processing requires the 'parallel', 'doSNOW' and 'foreach' packages which are not currently installed.",
      "~~~~~> Running without parallel processing, but with progress display"
    )))
    use_parallel <- FALSE
    use_show_progress <- TRUE
  } else if ((use_parallel && !use_show_progress) && (!local_machine_has_access_to_parallel || testing_use_parallel) && (!can_show_progress || testing_use_show_progress)) {
    warning(cli::format_warning(c(
      "!" = "Parallel processing with progress pisplay requires the 'parallel', 'doSNOW' and 'foreach' packages which are not currently installed.",
      "~~~~~> Running without parallel processing or progress display"
    )))
    use_parallel <- FALSE
    use_show_progress <- FALSE
  } else if ((!use_parallel && use_show_progress) && (!can_show_progress || testing_use_show_progress)) {
    warning(cli::format_warning(c(
      "!" = "Progress display (even without parallel processing) requires the 'pbabpply package which is not currently installed.",
      "~~~~~> Running without progress display"
    )))
    use_parallel <- FALSE
    use_show_progress <- FALSE
  }

  return(
    list(
      use_parallel = use_parallel,
      use_show_progress = use_show_progress
    )
  )
}
