

#' Check Square Matrix
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a matrix
#'
#' @returns The input object if x is a square matrix, or an error message if not
#'
#' @keywords internal
#'
#' @export
#' @example /man/examples/ex-check_square_matrix.R
#'
#' @srrstats {G2.7} *Software should accept as input as many of the above standard tabular forms as possible, including extension to domain-specific forms.*
check_square_adj_matrix = function(x) {
  res <- checkmate::check_multi_class(
    x,
    classes = c("matrix", "array", "data.frame", "data.table", "tibble")
  )
  if (!isTRUE(res)) {
    return(cli::cli_bullets(c(
      "x" = "Error: Adj. Matrix must one of the following classes: matrix, array, data.frame, data.table, tibble",
      "+++++> Input adj. matrix had class: {methods::is(x)[1]}"
    )))
  }
  if (nrow(x) != ncol(x)) {
    return(cli::cli_bullets(c(
      "x" = "Error: Adj. Matrix must be square (i.e. have dimension n x n)",
      "+++++> Input has dimensions {dim(x)}"
    )))
  }
  return(TRUE)
}




#' Check Numeric Vector
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a matrix
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object if x is a numeric vector, or an error
#' message if not
#'
#' @keywords internal
#'
#' @export
#' @example /man/examples/ex-check_numeric_vector.R
#'
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
check_numeric_vector = function(x, var_name = "") {
  class_of_x <- methods::is(x)

  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }

  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    return(cli::cli_bullets(c(
      "x" = "Error: {var_name} must be a numeric vector",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  return(TRUE)
}


#' Check Numeric Vector
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a matrix
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object if x is a numeric vector, or an error
#' message if not
#'
#' @keywords internal
#'
#' @export
#' @example /man/examples/ex-check_numeric_vector.R
#'
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
check_numeric_vector = function(x, var_name = "") {
  class_of_x <- methods::is(x)

  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }

  res <- checkmate::check_numeric(x)
  if (grepl("character", res, fixed = TRUE)) {
    x <- suppressWarnings(as.numeric(x))
    x <- ifelse(is.na(x), "", x)
  }
  res <- checkmate::check_numeric(x)
  if (!isTRUE(res)) {
    return(cli::cli_bullets(c(
      "x" = "Error: {var_name} must be a numeric vector",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  return(TRUE)
}


#' Check Choices
#'
#' @description
#' Blank description
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
#'
#' @export
#' @example /man/examples/ex-check_choice_selection.R
#'
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
check_choice_selection <- function(x, choices = c(), var_name = "") {
  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }

  if (length(x) > 1) {
    return(cli::cli_inform(c(
      "x" = "Error: '{var_name}' must be ONLY one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    )))
  }

  x <- tolower(x)
  choices <- tolower(choices)

  res <- checkmate::check_choice(x, choices = choices)
  if (!isTRUE(res)) {
    choices_text <- paste0("'", cli::ansi_collapse(choices, sep = "' '", sep2 = "' or '", last = "' or '"), "'")
    stop(cli::format_error(c(
      "x" = "Error: '{var_name}' must be one of the following: {choices_text}",
      "+++++++> Input {var_name} was: '{x}'"
    )))
  }
  return(TRUE)
}


#' Check Numeric
#'
#' @description
#' Blank description
#'
#' @details
#' INTENDED FOR DEVELOPER USE ONLY
#'
#' @param x a positive [integer] [> 0]
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a positive number, or an error
#' message if not
#'
#' @keywords internal
#'
#' @export
#' @example /man/examples/ex-check_positive_number.R
#'
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
check_positive_number <- function(x = numeric(), var_name = "") {
  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }

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
    return(cli::cli_bullets(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  if (x <= 0) {
    return(cli::cli_bullets(c(
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
#' @param x a positive [integer] [> 0]
#' @param var_name a character object for the name of the input variable to
#' be displayed in the error message
#'
#' @returns TRUE if the input object x is a positive integer, or an error
#' message if not
#'
#' @keywords internal
#'
#' @export
#' @example /man/examples/ex-check_positive_integer.R
#'
#' @srrstats {G2.1} *Implement assertions on types of inputs (see the initial point on nomenclature above).*
#' @srrstats {G2.1a} *Provide explicit secondary documentation of expectations on data types of all vector inputs.*
check_positive_integer <- function(x = 1L, var_name = "") {
  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }

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
    return(cli::cli_bullets(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} vector had class: {class_of_x[1]}"
    )))
  }
  if (x <= 0) {
    return(cli::cli_bullets(c(
      "x" = "Error: {var_name} must be a positive value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }
  if (as.integer(x) - x > 1e-10) {
    return(cli::cli_inform(c(
      "x" = "Error: {var_name} must be a positive integer value",
      "+++++++> Input {var_name} was: {x}"
    )))
  }
  return(TRUE)
}


assert_var_name <- function(var_name_input = "") {
  if (length(var_name) > 1 | isTRUE(is.na(var_name))) {
    stop(cli::format_error(c(
      "x" = "Error: {.var var_name} must be a single character object",
      "+++++++> Input {.var var_name} had length: {length(var_name)}"
    )))
  }
  if (methods::is(var_name)[1] != "character") {
    var_name <- as.character(var_name)
  }
  return(var_name)
}


#if (class_of_x[1] == "character") {
# x <- suppressWarnings(as.numeric(x))
# if (any(is.na(x))) {
#   x <- "NA"
# }
# return(cli::cli_bullets(c(
#   "x" = "Warning: Vector contained numeric values as strings (ex. '1' instead of 1)",
#   "~~~~~> Changing vector to numeric values",
#   "{class_of_x}"
# )))
#}





