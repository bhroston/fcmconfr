#' @srrstats {G2.0, G2.0a, G2.1, G2.1a, G2.2, G2.3, G2.3a, G2.3b} Thorough input
#'  validation methods are applied
#'
#' @srrstats {G2.4, G2.4a, G2.4b, G2.4c} Data type assertions performed
#' @srrstats {G2.6, G2.7, G2.8, G2.9, G2.12} Additional input validations applied
#'  validation methods are applied
#' @srrstats {G2.11} Data.frame-like tabular objects handle non-standard classes
#'  appropriately
#' @srrstats {G2.13, G2.14, G2.14a, G2.15, G2.16} Throws errors on missing/infinite
#'  data. Inappropriate to assume values for invalid data in analysis
#' @srrstats {BS2.1, BS2.6} Proper checks for inputs and computational parameters
#' @srrstats {BS3.0} No assumptions are made regarding missing values as
#'  inputs with missing values are rejected with errors
#' @srrstats {EA2.6} Routines appropriately process vector data regardless of
#'  additional attributes
#' @srrstats {EA4.1} Input validation functions validate integer vs
#'  numeric inputs
#' @noRd
NULL


################################################################################
# utils-input_checks.R
#
# This contains internal input validation functions to ensure inputs pass
# mutation testing from autotest.
#
#   Internal
#   - check_fcmconfr_input
#   - check_adj_matrix_list
#   - check_square_adj_matrix
#   - check_numeric_vector
#   - check_choice_selection
#   - check_positive_number
#   - check_positive_integer
#   - check_logical
#   - assert_var_name
#   - assert_matrix
#   - check_access_to_parallel_processing_and_progress_display_functionalities
#
################################################################################

#' Check fcmconfr Input
#'
#' @description
#' This function checks whether an input (x) is an acceptable input for a
#' particular type of fcmoconfr input (e.g. a square adjacency matrix,
#' a numeric vector, a choice from a particular set of choices, a positive
#' number, a positive integer, or a logical value).
#'
#' @param x A character string, a [numeric]/[numercic vector], a [matrix]
#' or [data.frame]-like object, or a [logical] (TRUE/FALSE) value
#' @param check A character of the check to perform. Must be one of the
#' following:
#'  \itemize{
#'    \item{square_adj_matrix - checks that the input is a square adjacency matrix
#'    that can be passed throughout the suite of fcmconfr functions}
#'    \item{numeric_vector - checks that the input is a vector of
#'    numeric-type objects}
#'    \item{ivfn_vector - checks that the input is a vector of
#'    ivfn-type objects}
#'    \item{tfn_vector - checks that the input is a vector of
#'    tfn-type objects}
#'    \item{choice_selection - checks that the input is one of a given set
#'    of choices. Must include the additional 'choices' parameter (see example)}
#'    \item{positive_number - checks that the input is a positive numeric-type
#'    object (i.e. passes is.numeric(x))}
#'    \item{positive_integer - checks that the input is a positive integer; in
#'    that as.integer(x) returns the same as (x), but does not necessarily
#'    require that (x) is the 'integer'-type R object}
#'    \item{logical - checks that the input is a logical (TRUE/FALSE) value}
#'    \item{color - checks that the input is a color accepted by ggplot2}
#'    \item{shape - checks that the input is a shape accepted by ggplot2}
#'  }
#' @param var_name A [character] string of the variable name of (x)
#' @param choice_selection_opts ONLY used if check = 'choice_selection'. A
#' [vector of character strings]; choices to make sure the 'choice_selection'
#' check ensures a match.
#' @param zero_is_positive ONLY used if check = 'positive_number' or
#' 'positive_integer'. A [logical] (TRUE/FALSE) object that dictates
#' whether to count 0 as a positive number (TRUE) or not (FALSE)
#'
#' @returns TRUE if the input passes the selected check, or an error if not
#'
#' @keywords internal
#' @noRd
#'
#' @example /man/examples/ex-check_fcmconfr_input.R
check_fcmconfr_input <- function(x,
                                 check = c("adj_matrix_list", "square_adj_matrix", "numeric_vector", "ivfn_vector", "tfn_vector", "choice_selection", "positive_number", "positive_integer", "logical", "color", "shape"),
                                 var_name = character(),
                                 choice_selection_opts = c(),
                                 zero_is_positive = FALSE) {

  var_name <- assert_var_name(var_name)

  check_choices <-  c("adj_matrix_list", "square_adj_matrix", "numeric_vector", "ivfn_vector", "tfn_vector", "choice_selection", "positive_number", "positive_integer", "logical", "color", "shape")
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

  if (identical(check, "positive_number") || identical(check, "positive_integer")) {
    check_logical(zero_is_positive, var_name = "zero_is_positive")
  }

  if (check == "adj_matrix_list") {
    check_adj_matrix_list(x)
  } else if (check == "square_adj_matrix") {
    check_square_adj_matrix(x)
  } else if (check == "choice_selection") {
    check_choice_selection(x, choices = choice_selection_opts, var_name = var_name)
  } else if (check == "numeric_vector") {
    check_numeric_vector(x, var_name = var_name)
  } else if (check == "ivfn_vector") {
    check_ivfn_vector(x, var_name = var_name)
  } else if (check == "tfn_vector") {
    check_tfn_vector(x, var_name = var_name)
  } else if (check == "positive_number") {
    check_positive_number(x, var_name = var_name, zero_is_positive = zero_is_positive)
  } else if (check == "positive_integer") {
    check_positive_integer(x, var_name = var_name, zero_is_positive = zero_is_positive)
  } else if (check == "logical") {
    check_logical(x, var_name = var_name)
  } else if (check == "color") {
    check_color(x, var_name = var_name)
  } else if (check == "shape") {
    check_shape(x, var_name = var_name)
  }

  return(TRUE)
}



#' Check Adj. Matrix List
#'
#' @description
#' This function checks whether an input (x) is a list of acceptable
#' adjacency matrices (via check_square_adj_matrix) and that all are of the
#' same FCM class (i.e. Conventional, IVFN, or TFN)
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a [matrix] or [data.frame]-like object
#'
#' @returns TRUE if x is a list of square adjacency matrices that are all of
#' the same FCM class (either Conventional, IVFN, or TFN), FALSE if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_adj_matrix_list(sample_fcms$simple_fcms$conventional_fcms)
#' check_adj_matrix_list(sample_fcms$simple_fcms$ivfn_fcms)
#' check_adj_matrix_list(sample_fcms$simple_fcms$tfn_fcms)
check_adj_matrix_list <- function(x = list()) {

  if (!identical(methods::is(x)[1], "list")) {
    tryCatch({
      check_square_adj_matrix(x)
      return(TRUE)
    }, error = function(e) {
      stop(cli::format_error(c(
        "x" = "Error: The adj. matrix list must be a 'list' type object of multiple adjacency matrices.",
        "+++++> If input is a single adjacency matrix, it must be a square data.frame-like object.",
        "+++++> Input was of type: {methods::is(x)[1]}"
      )))
    })
  }

  if (any(is.na(x))) {
    stop(cli::format_error(c(
      "x" = "Error: The adj. matrix list must not contain any missing data",
      "+++++> Found NA in adj. matrix list"
    )))
  }

  for (i in seq_along(x)) {
    tryCatch({
      check_square_adj_matrix(x[[i]])
    }, error = function(e) {
      cli::cli_inform(c(
        "x" = "Error: Found the following error with element {i} of adj. matrix list"
      ))
      check_square_adj_matrix(x[[i]])
    })
  }

  fcm_classes <- lapply(x, get_fcm_class_from_adj_matrix)
  if (length(unique(fcm_classes)) != 1) {
    stop(cli::format_error(c(
      "x" = "Error: Adj. matrices must all represent FCMs of the same class (i.e. Conventional, IVFN, or TFN)",
      "+++++> Input adj. matrices represented FCMs of the following classes: {unlist(unique(fcm_classes))}"
    )))
  }

  unique_dims_of_adj_matrices <- unique(lapply(x, dim))
  if (length(unique_dims_of_adj_matrices) != 1) {
    stop(cli::format_error(c(
      "x" = "Error: All adj. matrices in list must have the same dimensions",
      "+++++> Input adj. matrices represented FCMs of the following dimensions: {unique_dims_of_adj_matrices}"
    )))
  }

  unique_colnames_of_adj_matrices <- unique(lapply(x, colnames))
  if (length(unique_colnames_of_adj_matrices) != 1) {
    stop(cli::format_error(c(
      "x" = "Error: All adj. matrices in list must have the same column names (i.e. concepts)",
      "+++++> Input adj. matrices had column names: {unique_column_names_of_adj_matrices}"
    )))
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
#' @examples
#' check_square_adj_matrix(matrix(1:9, nrow = 3))
check_square_adj_matrix = function(x = matrix()) {
  requireNamespace("Matrix")

  if (methods::is(x)[1] == "list" & length(x) > 1) {
    return(stop(cli::format_error(c(
      "x" = "Error: Adj. Matrix must be an individual adjacency matrix",
      "+++++> Input adj. matrix was a list of {length(x)} adj. matrices."
    ))))
  }

  if (all(is.na(x))) {
    stop(cli::format_error(c(
      "x" = "Error: Adj. Matrix input was NA"
    )))
  }

  class_options <-  c("matrix", "array", "data.frame", "dgCMatrix", "data.table", "tibble", "tbl_df", "sparseMatrix", "adj_matrix_w_ivfns", "adj_matrix_w_tfns")
  class_options_text <- paste0("'", cli::ansi_collapse(class_options, sep = "' '", sep2 = "' or '", last = "' or '"), "'")

  res <- checkmate::check_choice(methods::is(x)[1], choices = class_options)

  if (!isTRUE(res)) {
    x <- tryCatch({
      x_as_df <- x
      class(x_as_df) <- NULL
      if (!is.null(dim(x_as_df))) {
        x_as_df <- as.data.frame(x_as_df)
      } else {
        x_as_df <- as.data.frame(do.call(cbind, x_as_df))
      }
      x_as_df
    }, warning = function(w) {
      return(stop(cli::format_error(c(
        "x" = "Error: Adj. Matrix must be one of the following classes: ", "{class_options_text}",
        "+++++> Input adj. matrix had class: {methods::is(x)[1]}"
      ))))
    },  error = function(e) {
      return(stop(cli::format_error(c(
        "x" = "Error: Adj. Matrix must be one of the following classes: ", "{class_options_text}",
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

  check_no_invalid_data(x, "adj_matrix")

  return(TRUE)
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
#' @examples
#' check_numeric_vector(c(1, 1, 1))
#' check_numeric_vector(c(1, "1", 1))
#' check_numeric_vector(c("one", "two"))
check_numeric_vector = function(x, var_name = "") {
  # Skip test if no input given; an empty input will create an assumed
  # initial_state_vector/clamping_vector in the check function that called this
  if (identical(x, c())) {
    return(TRUE)
  }

  check_no_invalid_data(x, var_name)

  var_name <- assert_var_name(var_name)

  class_of_x <- methods::is(x)
  res <- checkmate::check_numeric(x)
  # non_numeric_input_can_be_numeric <- all(vapply(x, function(val) !grepl("\\D", val), logical(length(1))))
  # if  (non_numeric_input_can_be_numeric) {
  #   x <- suppressWarnings(as.numeric(x))
  # }

  if (!isTRUE(res)) {
    x <- tryCatch({
      x <- suppressWarnings(as.numeric(x))
    }, error = function(e) {
      stop(cli::format_error(c(
        "x" = "Error: {var_name} must be a numeric vector",
        "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
      )))
    })
  }

  res <- checkmate::check_numeric(x, any.missing = FALSE)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a numeric vector",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }

  return(TRUE)
}


#' Check IVFN Vector
#'
#' @description
#' This function checks whether an input (x) is a numeric [vector] object that
#' contains only IVFNs and can be passed throughout fcmconfr functions.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a [vector] of [ivfn] values
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object if x is an ivfn vector, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_ivfn_vector(c(ivfn(1, 1), ivfn(1, 1)), var_name = "state_vector")
check_ivfn_vector = function(x, var_name = "") {

  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  classes_in_x <- unique(lapply(x, function(x) methods::is(x)[1]))
  if (length(classes_in_x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: All elements in {var_name} must be of type 'ivfn'",
      "+++++++> Input {var_name} had classes: {classes_in_x}"
    )))
  }
  class_in_x <- classes_in_x[[1]]
  if (!identical(class_in_x, "ivfn")) {
    stop(cli::format_error(c(
      "x" = "Error: All elements in {var_name} must be of type 'ivfn'",
      "+++++++> Input {var_name} had classes: {classes_in_x}"
    )))
  }

  return(TRUE)
}


#' Check TFN Vector
#'
#' @description
#' This function checks whether an input (x) is a numeric [vector] object that
#' contains only TFNs and can be passed throughout fcmconfr functions.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a [vector] of [tfn] values
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object if x is an tfn vector, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_tfn_vector(c(tfn(1, 1, 1), tfn(1, 1 1)), var_name = "state_vector")
check_tfn_vector = function(x, var_name = "") {

  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  classes_in_x <- unique(lapply(x, function(x) methods::is(x)[1]))
  if (length(classes_in_x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: All elements in {var_name} must be of type 'tfn'",
      "+++++++> Input {var_name} had classes: {classes_in_x}"
    )))
  }
  class_in_x <- classes_in_x[[1]]
  if (!identical(class_in_x, "tfn")) {
    stop(cli::format_error(c(
      "x" = "Error: All elements in {var_name} must be of type 'tfn'",
      "+++++++> Input {var_name} had classes: {classes_in_x}"
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
#' @examples
#' squashing_opts <- c("sigmoid", "tanh")
#' check_choice_selection("sigmoid", squashing_opts, var_name = "squashing")
#' check_choice_selection(1, c(1, 2, 3))
check_choice_selection <- function(x, choices = c(), var_name = "") {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  choices_text <- paste0("'", cli::ansi_collapse(choices, sep = "' '", sep2 = "' or '", last = "' or '"), "'")

  if (length(x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be ONLY one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    )))
  }

  if (is.function(x)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a character string that matches one of the following: {choices_text}",
      "+++++++> Input {var_name} was a function object",
      "+++++++> Make sure to put '' around input"
    )))
  }

  x <- tolower(x)
  choices <- tolower(choices)

  res <- checkmate::check_choice(x, choices = choices)
  if (!isTRUE(res)) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    )))
  }
  return(TRUE)
}


#' Check Positive Number
#'
#' @description
#' This function checks whether an input (x) is a [numeric] object.
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a positive [numeric] [> 0]
#' @param var_name a [character] object for the name of the input variable to
#' be displayed in the error message
#' @param zero_is_positive a [logical] (TRUE/FALSE) object that dictates
#' whether to count 0 as a positive number (TRUE) or not (FALSE)
#'
#' @returns TRUE if the input object x is a positive number, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_positive_number(1, "lambda")
#' check_positive_number(1.5, "lambda")
check_positive_number <- function(x = numeric(), var_name = "", zero_is_positive = FALSE) {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  check_logical(zero_is_positive, var_name = "zero_is_positive")

  if (length(x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a single, positive numeric value",
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
  if (identical(as.numeric(x), numeric())) {
    return(TRUE) # For empty input
  } else if (x == 0 && !zero_is_positive) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {.var zero_is_positive} was FALSE, so 0 is not accepted as a positive value here"
    )))
  } else if (x < 0) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  return(TRUE)
}


#' Check Positive Integer
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a single, positive [integer] [> 0]
#' @param var_name a [character] object for the name of the input variable to
#' be displayed in the error message
#' @param zero_is_positive a [logical] (TRUE/FALSE) object that dictates
#' whether to count 0 as a positive number (TRUE) or not (FALSE)
#'
#' @returns TRUE if the input object x is a positive integer, or an error
#' message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_positive_integer(1, "max_iter")
#' check_positive_integer("1", "max_iter")
check_positive_integer <- function(x = 1L, var_name = "", zero_is_positive = FALSE) {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  check_logical(zero_is_positive, var_name = "zero_is_positive")

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
  if (identical(x, 0) && !zero_is_positive) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {.var zero_is_positive} was FALSE, so 0 is not accepted as a positive value here"
    )))
  }
  if (identical(as.integer(x), integer())) {
    return(TRUE) # If empty input
  } else if (x < 0) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    )))
  } else if (abs(as.integer(x) - x) > 1e-10) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }
  return(TRUE)
}


#' Check Logical
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
#' @examples
#' check_logical(TRUE, var_name = "include_zeroes_in_sampling")
check_logical <- function(x = TRUE, var_name = "") {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

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



#' Check Color
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x \[`character(1)`]\cr A character string for a single color
#' @param var_name \[`character()`]\cr The name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a character string representing a
#' color accepted by ggplot2, or an error message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_color("red")
check_color <- function(x = character(1), var_name = "") {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  if (length(x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a character string of a single color",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  x <- tryCatch({
    tolower(as.character(x))
  }, error = function(x) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a character string of a single color",
      "+++++++> Input {var_name} was: {x}"
    )))
  })

  if ("try-error" %in% methods::is(try(grDevices::col2rgb(x), silent = TRUE))) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a character string of a single color",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  return(TRUE)
}



#' Check Shape
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x \[`integer(1)` or `character(1)`]\cr An integer representing a PCH
#' point value (https://r-charts.com/base-r/pch-symbols/) or a character string
#' of a particular shape.
#' @param var_name \[`character()`]\cr The name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is an integer or character string
#' representing a shape accepted by ggplot2, or an error message if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_shape(1)
#' check_shape("square")
check_shape <- function(x, var_name = "") {
  var_name <- assert_var_name(var_name)

  check_no_invalid_data(x, var_name)

  if (length(x) > 1) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be a character string of a single color",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  x_is_positive_integer <- try(check_positive_integer(x, var_name, zero_is_positive = FALSE), silent = TRUE)
  if (isTRUE(x_is_positive_integer) && !(x %in% 0:25)) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be either a shape string or an integer between 1 and 25 (for pch point values)",
      "+++++++> Input {var_name} was: {x}"
    )))
  } else if (isTRUE(x_is_positive_integer) && (x %in% 0:25)) {
    return(TRUE)
  }

  x <- tryCatch({
    tolower(as.character(x))
  }, error = function(x) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be either a shape string or an integer between 1 and 25 (for pch point values)",
      "+++++++> Input {var_name} was: {x}"
    )))
  })
  if ("try-error" %in% methods::is(try(ggplot2::translate_shape_string(x), silent = TRUE))) {
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be either a shape string or an integer between 1 and 25 (for pch point values)",
      "+++++++> Input {var_name} was: {x}"
    )))
  }

  return(TRUE)
}



#' Check No Invalid Data
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x \[`numeric(1)` or `character(1)` or `logical(1)`]\cr Any input
#' @param var_name \[`character()`]\cr The name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is not a missing or infinite value
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' check_no_invalid_data(c(1, 1, 1))
#' check_no_invalid_data("A")
check_no_invalid_data <- function(x, var_name = "") {

  if (any(is.na(x))) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} contains/is NA/NaN",
      "+++++> {var_name} cannot contain/be a missing value"
    )))
  }

  if (!is.null(dim(x)) && (all(c("data.frame", "list") %in% methods::is(x)) || any(c("adj_matrix_w_ivfns", "adj_matrix_w_tfns") %in% methods::is(x)))) {
    infinite_elements <- apply(x, c(1, 2), function(element) {
      tryCatch({
        is.infinite(element)
      }, error = function(e) {
        FALSE
      })
    })
    if (any(infinite_elements)) {
      stop(cli::format_error(c(
        "x" = "Error: {var_name} contains Inf values",
        "+++++> {var_name} cannot contain a missing value"
      )))
    } else {
      return(TRUE)
    }
  } else if (is.null(dim(x)) && all(c("list", "vector") %in% methods::is(x))) {
    infinite_elements <- unlist(lapply(x, function(element) {
      tryCatch({
        is.infinite(element)
      }, error = function(e) {
        FALSE
      })
    }))
    if (any(infinite_elements)) {
      stop(cli::format_error(c(
        "x" = "Error: {var_name} contains Inf values",
        "+++++> {var_name} cannot contain a missing value"
      )))
    } else {
      return(TRUE)
    }
  } else if (is.null(dim(x)) && any(is.infinite(x))) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} contains/is Inf (or -Inf)",
      "+++++> {var_name} cannot be contain/be an infinite value"
    )))
  } else if (!is.null(dim(x)) && any(apply(x, c(1, 2), is.infinite))) {
    stop(cli::format_error(c(
      "x" = "Error: {var_name} contains/is Inf (or -Inf)",
      "+++++> {var_name} cannot be contain/be an infinite value"
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



#' Assert adj_matrix
#'
#' @description
#' This function forces adjacency matrices for convention FCMs to be returned
#' as data.frame objects
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param adj_matrix A single adjacency matrix or a list of
#' adjacency matrices (n x n) representing FCMs. Matrices can have conventional
#' edge weights, IVFN edge weights or TFN edge weights.
#' @param fcm_class The class of the FCM represented by the adjacency matrix. Must
#' be one of the following: 'conventional', 'ivfn', or 'tfn'
#' @param var_name_input a character object for the name of the input variable
#' to be displayed in the error message
#'
#' @returns the var_name input if acceptable, error messages if not
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' assert_matrix(sample_fcms$simple_fcms$conventional_fcms[[1]])
assert_matrix <- function(adj_matrix = data.frame(),
                          fcm_class = c("conventional", "ivfn", "tfn"),
                          var_name_input = "") {

  # if (fcm_class == "ivfn" || fcm_class == "tfn") {
  #   return(adj_matrix)
  # }

  input_adj_matrix <- adj_matrix

  res <- check_square_adj_matrix(adj_matrix)
  if (isTRUE(res)) {
    return(adj_matrix)
  }

  if (!is.null(dim(adj_matrix)) && fcm_class == "conventional") {
    output_adj_matrix <- data.frame(apply(input_adj_matrix, c(1, 2), function(element) element))
  } else if (!is.null(dim(input_adj_matrix)) && (fcm_class %in% c("ivfn", "tfn"))) {
    class(input_adj_matrix) <- NULL
    output_adj_matrix <- as.data.frame(input_adj_matrix)
  } else {
    output_adj_matrix <- as.data.frame(do.call(cbind, input_adj_matrix))
  }

  # if (fcm_class == "conventional" && !is.null(dim(adj_matrix))) {
  #   adj_matrix <- data.frame(apply(adj_matrix, c(1, 2), function(element) element))
  # } else if (fcm_class == "conventional" && is.null(dim(adj_matrix))) {
  #   class(adj_matrix) <- NULL
  #   adj_matrix <- data.frame(do.call(cbind, adj_matrix))
  # }

  if (!identical(methods::is(input_adj_matrix)[1], methods::is(output_adj_matrix)[1])) {
    warning(cli::format_warning(c(
      "!" = "Converting adjacency matrix to data.frame"
    )))
  }

  return(adj_matrix)
}


#'
#'
#' #' Check if the local machine can access internal parallel processing and progress display functionalities
#' #'
#' #' @family utility
#' #'
#' #' @description
#' #' Check whether the local machine has access to the necessary packages to
#' #' run code in parallel and/or using a progress bar. Specifically, checks for
#' #' the parallel and pbapply packages.
#' #'
#' #' @details
#' #' Confirms that a local machine can access the required packages for parallel
#' #' processing and/or displaying progress bars at runtime. Will revise inputs
#' #' if particular packages are unavailable and warn the user of such changes, but will
#' #' not halt a run.
#' #'
#' #' @param use_parallel A [logical] (TRUE/FALSE) object declaring whether the
#' #' user intends to use parallel processing (TRUE) or not (FALSE)
#' #' @param use_show_progress A [logical] (TRUE/FALSE) object declaring whether
#' #' the user intends to display progress bars (TRUE) or not (FALSE)
#' #' @param testing_use_parallel A [logical] (TRUE/FALSE) object declaring whether
#' #' the function should be run as a test that restricts access to packages
#' #' required for parallel processing (TRUE) to force use_parallel to FALSE or
#' #' not (FALSE)
#' #' @param testing_use_show_progress A [logical] (TRUE/FALSE) object declaring
#' #' whether the function should be run as a test that restricts access to
#' #' packages required for progress display (TRUE) to force use_show_progress
#' #' to FALSE or not (FALSE)
#' #'
#' #' @returns TRUE/FALSE Whether the machine has access to the dependencies to
#' #' access internal parallel processing functionalities
#' #'
#' #' @keywords internal
#' #' @noRd
#' #'
#' #' @example man/examples/ex-check_access_to_parallel_processing_and_progress_display_functionalities.R
#' check_access_to_parallel_processing_and_progress_display_functionalities <- function(use_parallel = TRUE,
#'                                                                                      use_show_progress = TRUE,
#'                                                                                      testing_use_parallel = FALSE,
#'                                                                                      testing_use_show_progress = FALSE) {
#'
#'   check_fcmconfr_input(use_parallel, "logical", var_name = "use_parallel")
#'   check_fcmconfr_input(use_show_progress, "logical", var_name = "use_show_progress")
#'   check_fcmconfr_input(testing_use_parallel, "logical", var_name = "testing_use_parallel")
#'   check_fcmconfr_input(testing_use_show_progress, "logical", var_name = "testing_use_show_progress")
#'
#'   local_machine_has_access_to_parallel <- requireNamespace("parallel")
#'   local_machine_has_access_to_pbapply <- requireNamespace("pbapply")
#'
#'   can_run_in_parallel_and_can_show_progress <- (local_machine_has_access_to_parallel && local_machine_has_access_to_pbapply)
#'   can_run_in_parallel_and_cannot_show_progress <- (local_machine_has_access_to_parallel)
#'   can_show_progress <- local_machine_has_access_to_pbapply
#'
#'   if ((use_parallel && use_show_progress) && (!can_run_in_parallel_and_can_show_progress || testing_use_parallel) && (can_show_progress && !testing_use_show_progress)) {
#'     warning(cli::format_warning(c(
#'       "!" = "Parallel processing with progress pisplay requires the 'parallel' package which is not currently installed.",
#'       "~~~~~> Running without parallel processing, but with progress display"
#'     )))
#'     use_parallel <- FALSE
#'     use_show_progress <- TRUE
#'   } else if ((use_parallel && use_show_progress) && (!can_run_in_parallel_and_can_show_progress || testing_use_parallel) && (!can_show_progress || testing_use_show_progress)) {
#'     warning(cli::format_warning(c(
#'       "!" = "Parallel processing with progress pisplay requires the 'parallel' packages which is not currently installed.",
#'       "~~~~~> Running without parallel processing or progress display"
#'     )))
#'     use_parallel <- FALSE
#'     use_show_progress <- FALSE
#'   } else if ((use_parallel && !use_show_progress) && (!local_machine_has_access_to_parallel || testing_use_parallel) && (can_show_progress && !testing_use_show_progress)) {
#'     warning(cli::format_warning(c(
#'       "!" = "Parallel processing requires the 'parallel' package which is not currently installed.",
#'       "~~~~~> Running without parallel processing, but with progress display"
#'     )))
#'     use_parallel <- FALSE
#'     use_show_progress <- TRUE
#'   } else if ((use_parallel && !use_show_progress) && (!local_machine_has_access_to_parallel || testing_use_parallel) && (!can_show_progress || testing_use_show_progress)) {
#'     warning(cli::format_warning(c(
#'       "!" = "Parallel processing with progress pisplay requires the 'parallel' packages which is not currently installed.",
#'       "~~~~~> Running without parallel processing or progress display"
#'     )))
#'     use_parallel <- FALSE
#'     use_show_progress <- FALSE
#'   } else if ((!use_parallel && use_show_progress) && (!can_show_progress || testing_use_show_progress)) {
#'     warning(cli::format_warning(c(
#'       "!" = "Progress display (even without parallel processing) requires the 'pbabpply' package which is not currently installed.",
#'       "~~~~~> Running without progress display"
#'     )))
#'     use_parallel <- FALSE
#'     use_show_progress <- FALSE
#'   }
#'
#'   return(
#'     list(
#'       parallel = as.logical(use_parallel),
#'       show_progress = as.logical(use_show_progress)
#'     )
#'   )
#' }

