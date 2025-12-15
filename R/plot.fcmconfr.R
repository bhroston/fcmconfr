
################################################################################
# plot.fcmconfr.R
#
# This function plots fcmconfr output objects
#
#   Exported
#   - plot.fcmconfr
#
#   Internal
#   - check_plot_fcmconfr_inputs
#   - get_concepts_to_plot
#   - get_plot_data
#   - autoplot.fcmconfr
#   - fcmconfr_theme_custom
#   - fcmconfr_default_theme
#   - interactive_plot_fcmconfr
#
################################################################################

#' Plot fcmconfr
#'
#' @description
#' This plots the output of fcmconfr() using ggplot. Set shiny = TRUE to
#' load plot in a Shiny app and toggle on/off results from different analyses.
#'
#' @details
#' Generates a generic plot visualizing \code{\link{fcmconfr}} results.
#'
#' @param x A direct output of the \code{\link{fcmconfr}} function
#' @param include \[`character()`]\cr The concepts to include in the plot.
#' By default, include = 'all' which does not exclude any concepts. Set to a
#' vector of concept names to identify the only concepts to include in the plot.
#' @param shiny \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
#' toggle on/off results from different analyses.
#' @param filter_limit \[`double(1)`]\cr Only nodes with inferences above the
#' filter_limit across any analysis will be plotted. This removes nodes with
#' mostly 0-valued inferences indicating they were not impacted in the
#' simulation.
#' @param xlim \[`double(1)`]\cr The x-axis plot limits. xlim = NA lets ggplot
#' determine the x-axis limits. xlim = c(lower_limit, upper_limit) for manual
#' input limits. See ?ggplot2::xlim for additional info.
#' @param coord_flip \[`logical(1)`]\cr  Swap x- and y-axes (i.e. rotate plot).
#' See ?ggplot2::coord_flip for additional info.
#' @param text_font_size \[`double(1)`]\cr  The font size of axis labels.
#' text_font_size = NA lets ggplot determine the axis label font size.
#' @param mc_avg_and_CIs_color \[`character(1)`]\cr Color of the crossbar
#' (lines) indicating the avg inferences of empirical FCMs generated via Monte
#' Carlo sampling and the confidence intervals about those averages.
#' @param mc_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of empirical FCMs generated via Monte Carlo sampling.
#' @param mc_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of Monte Carlo FCMs. Must be greater than 0.
#' @param mc_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of empirical FCMs
#' generated via Monte Carlo sampling. Range from 0 to 1 (0: Transparent to
#' 1: Opaque).
#' @param mc_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of empirical FCMs generated via Monte
#' Carlo sampling. Accepts PCH point values and character strings.
#' @param ind_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of individual FCMs.
#' @param ind_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of individual FCMs. Range
#' from 0 to 1 (0: Transparent to 1: Opaque).
#' @param ind_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of individual FCMs. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param agg_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of the aggregate FCM
#' @param ind_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of individual FCMs. Must be greater than 0.
#' @param agg_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of aggregate FCM. Must be greater than 0.
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param mc_avg_and_CIs_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing the average (and confidence bounds the average) of the
#' Monte Carlo FCMs inferences
#' @param ind_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr  Linewidth of
#' lines representing inferences for analyses of individual IVFN- and TFN- FCMs.
#' @param agg_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing inferences for analyses of aggregate IVFN- and TFN- FCMs
#' @param ... Additional inputs
#'
#' @returns A plot of an fcmconfr object's results
#'
#' @export
#'
#' @srrstats {BS6.1} Plot method included for fcmconfr output
#' @srrstats {EA5.0, EA5.0a, EA5.0b} Emphasis on accessibility in graphical
#' outputs
#' @srrstats {EA5.5} All visualizations include units for all axes. (Except
#' where axis is unit-less)
#' @srrstats {EA5.4} All visualisations should ensure values are rounded
#' sensibly
#'
#' @example man/examples/ex-plot.fcmconfr.R
plot.fcmconfr <- function(x,
                          include = "all",
                          shiny = FALSE,
                          # Plot Format Parameters
                          filter_limit = 1e-3,
                          xlim = NA, # c(lower_limit, upper_limit)
                          coord_flip = FALSE,
                          text_font_size = NA, # NA: let ggplot determine
                          # Plot Aesthetic Parameters
                          mc_avg_and_CIs_color = "blue",
                          mc_inferences_color = "blue",
                          mc_inferences_size = 1,
                          mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                          mc_inferences_shape = 3, # R PCH point shape values
                          ind_inferences_color = "black",
                          ind_inferences_size = 1,
                          ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                          ind_inferences_shape = 16, # R PCH point shape values
                          agg_inferences_color = "red",
                          agg_inferences_size = 1,
                          agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                          agg_inferences_shape = 17, # R PCH point shape values
                          mc_avg_and_CIs_linewidth = 0.1,
                          ind_ivfn_and_tfn_linewidth = 0.1,
                          agg_ivfn_and_tfn_linewidth = 0.6,
                          ...) {

  requireNamespace(c("tidyr", "graphics", "shiny", "shinyWidgets", "bslib"))

  additional_inputs <- list(...)
  if (length(additional_inputs) > 0) {
    warning(cli::format_warning(c(
      "!" = "Warning: Additional Inputs given as ... are ignored",
      "~~~~~ Ignoring additional inputs: {names(additional_inputs)}"
    )))
  }

  # Input Checks ----
  checks <- check_plot_fcmconfr_inputs(
    shiny,
    filter_limit, xlim, coord_flip, text_font_size,
    mc_avg_and_CIs_color,
    mc_inferences_color, mc_inferences_size, mc_inferences_alpha, mc_inferences_shape,
    ind_inferences_color, ind_inferences_size, ind_inferences_alpha, ind_inferences_shape,
    agg_inferences_color, agg_inferences_size, agg_inferences_alpha, agg_inferences_shape,
    mc_avg_and_CIs_linewidth, ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
  )

  include <- as.character(include)
  included_concepts_valid <- include %in% colnames(x$params$adj_matrices[[1]])
  if (!identical(include, "all") && !all(included_concepts_valid)) {
    stop(cli::format_error(c(
      "x" = "Error: '{include}' must be a character vector of concepts in the fcmconfr output",
      "+++++++> fcmconfr output does not contain the following: {include[!included_concepts_valid]}"
    )))
  } else {
    checks$include <- include
  }

  shiny <- checks$shiny
  filter_limit <- checks$filter_limit
  xlim <- checks$xlim
  coord_flip <- checks$coord_flip
  text_font_size <- checks$text_font_size
  mc_avg_and_CIs_color <- checks$mc_avg_and_CIs_color
  mc_inferences_color <- checks$mc_inferences_color
  mc_inferences_size <- checks$mc_inferences_size
  mc_inferences_alpha <- checks$mc_inferences_alpha
  mc_inferences_shape <- checks$mc_inferences_shape
  ind_inferences_color <- checks$ind_inferences_color
  ind_inferences_size <- checks$ind_inferences_size
  ind_inferences_alpha <- checks$ind_inferences_alpha
  ind_inferences_shape <- checks$ind_inferences_shape
  agg_inferences_color <- checks$agg_inferences_color
  agg_inferences_size <- checks$agg_inferences_size
  agg_inferences_alpha <- checks$agg_inferences_alpha
  agg_inferences_shape <- checks$agg_inferences_shape
  mc_avg_and_CIs_linewidth <- checks$mc_avg_and_CIs_linewidth
  ind_ivfn_and_tfn_linewidth <- checks$ind_ivfn_and_tfn_linewidth
  agg_ivfn_and_tfn_linewidth <- checks$agg_ivfn_and_tfn_linewidth
  # ----

  if (!shiny) {
    suppressWarnings(print(
      autoplot.fcmconfr(
        x,
        include, shiny,
        filter_limit, xlim, coord_flip, text_font_size,
        mc_avg_and_CIs_color,
        mc_inferences_color, mc_inferences_size, mc_inferences_alpha, mc_inferences_shape,
        ind_inferences_color, ind_inferences_size, ind_inferences_alpha, ind_inferences_shape,
        agg_inferences_color, agg_inferences_size, agg_inferences_alpha, agg_inferences_shape,
        mc_avg_and_CIs_linewidth, ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
      )
    ))
  } else {
    suppressWarnings(
      interactive_plot_fcmconfr(
        x,
        checks
        # filter_limit, xlim, coord_flip, text_font_size,
        # mc_avg_and_CIs_color,
        # mc_inferences_color, mc_inferences_alpha, mc_inferences_shape,
        # ind_inferences_color, ind_inferences_alpha, ind_inferences_shape,
        # agg_inferences_color, agg_inferences_alpha, agg_inferences_shape,
        # ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
      )
    )
  }
}



#' Check plot.fcmconfr Inputs
#'
#' @description
#' This checks the inputs to plot.fcmconfr to and throws warnings/errors if
#' necessary
#'
#' @param shiny \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
#' toggle on/off results from different analyses.
#' @param filter_limit \[`double(1)`]\cr Only nodes with inferences above the
#' filter_limit across any analysis will be plotted. This removes nodes with
#' mostly 0-valued inferences indicating they were not impacted in the
#' simulation.
#' @param xlim \[`double(1)`]\cr The x-axis plot limits. xlim = NA lets ggplot
#' determine the x-axis limits. xlim = c(lower_limit, upper_limit) for manual
#' input limits. See ?ggplot2::xlim for additional info.
#' @param coord_flip \[`logical(1)`]\cr  Swap x- and y-axes (i.e. rotate plot).
#' See ?ggplot2::coord_flip for additional info.
#' @param text_font_size \[`double(1)`]\cr  The font size of axis labels.
#' text_font_size = NA lets ggplot determine the axis label font size.
#' @param mc_avg_and_CIs_color \[`character(1)`]\cr Color of the crossbar
#' (lines) indicating the avg inferences of empirical FCMs generated via Monte
#' Carlo sampling and the confidence intervals about those averages.
#' @param mc_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of empirical FCMs generated via Monte Carlo sampling.
#' @param mc_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of Monte Carlo FCMs. Must be greater than 0.
#' @param mc_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of empirical FCMs
#' generated via Monte Carlo sampling. Range from 0 to 1 (0: Transparent to
#' 1: Opaque).
#' @param mc_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of empirical FCMs generated via Monte
#' Carlo sampling. Accepts PCH point values and character strings.
#' @param ind_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of individual FCMs.
#' @param ind_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of individual FCMs. Must be greater than 0.
#' @param ind_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of individual FCMs. Range
#' from 0 to 1 (0: Transparent to 1: Opaque).
#' @param ind_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of individual FCMs. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param agg_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of the aggregate FCM
#' @param agg_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of aggregate FCM. Must be greater than 0.
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param mc_avg_and_CIs_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing the average (and confidence bounds the average) of the
#' Monte Carlo FCMs inferences
#' @param ind_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr  Linewidth of
#' lines representing inferences for analyses of individual IVFN- and TFN- FCMs.
#' @param agg_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing inferences for analyses of aggregate IVFN- and TFN- FCMs
#'
#' @examples
#' NULL
#' @keywords internal
#' @noRd
check_plot_fcmconfr_inputs <- function(shiny = FALSE,
                                       # Plot Format Parameters
                                       filter_limit = 1e-3,
                                       xlim = NA, # c(lower_limit, upper_limit)
                                       coord_flip = FALSE,
                                       text_font_size = NA, # NA: let ggplot determine
                                       # Plot Aesthetic Parameters
                                       mc_avg_and_CIs_color = "blue",
                                       mc_inferences_color = "blue",
                                       mc_inferences_size = 1,
                                       mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                                       mc_inferences_shape = 3, # R PCH point shape values
                                       ind_inferences_color = "black",
                                       ind_inferences_size = 1,
                                       ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                                       ind_inferences_shape = 16, # R PCH point shape values
                                       agg_inferences_color = "red",
                                       agg_inferences_size = 1,
                                       agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                                       agg_inferences_shape = 17, # R PCH point shape values
                                       mc_avg_and_CIs_linewidth = 0.1,
                                       ind_ivfn_and_tfn_linewidth = 0.1,
                                       agg_ivfn_and_tfn_linewidth = 0.6) {

  check_fcmconfr_input(shiny, check = "logical", var_name = "shiny")
  check_fcmconfr_input(filter_limit, check = "positive_number", var_name = "filter_limit")
  # xlim checked below
  check_fcmconfr_input(coord_flip, check = "logical", var_name = "coord_flip")
  if (!isTRUE(is.na(text_font_size)) && !isTRUE(is.null(text_font_size))) check_fcmconfr_input(text_font_size, check = "positive_number", var_name = "text_font_size")
  check_fcmconfr_input(mc_avg_and_CIs_color, check = "color", var_name = "mc_avg_and_CIs_color")
  check_fcmconfr_input(mc_inferences_color, check = "color", var_name = "mc_inferences_color")
  check_fcmconfr_input(mc_inferences_size, check = "positive_number", var_name = "mc_inferences_size", zero_is_positive = FALSE)
  check_fcmconfr_input(mc_inferences_alpha, check = "positive_number", var_name = "mc_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(mc_inferences_shape, check = "shape", var_name = "mc_inferences_shape")
  check_fcmconfr_input(ind_inferences_color, check = "color", var_name = "ind_inferences_color")
  check_fcmconfr_input(ind_inferences_size, check = "positive_number", var_name = "ind_inferences_size", zero_is_positive = FALSE)
  check_fcmconfr_input(ind_inferences_alpha, check = "positive_number", var_name = "ind_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(ind_inferences_shape, check = "shape", var_name = "ind_inferences_shape")
  check_fcmconfr_input(agg_inferences_color, check = "color", var_name = "agg_inferences_color")
  check_fcmconfr_input(agg_inferences_size, check = "positive_number", var_name = "agg_inferences_size", zero_is_positive = FALSE)
  check_fcmconfr_input(agg_inferences_alpha, check = "positive_number", var_name = "agg_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(agg_inferences_shape, check = "shape", var_name = "agg_inferences_shape")
  check_fcmconfr_input(mc_avg_and_CIs_linewidth, check = "positive_number", var_name = "mc_avg_and_CIs_linewidth")
  check_fcmconfr_input(ind_ivfn_and_tfn_linewidth, check = "positive_number", var_name = "ind_ivfn_and_tfn_linewidth")
  check_fcmconfr_input(agg_ivfn_and_tfn_linewidth, check = "positive_number", var_name = "agg_ivfn_and_tfn_linewidth")

  # Additional Checks
  # filter_limit ----
  if (filter_limit > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var filter_limit} must be less than the largest inference",
      "+++++> Note: The largest possible inference is 1",
      "+++++> Input {.var filter_limit} was: {filter_limit}"
    )))
  }
  # ----

  # xlim ----
  if (!all(is.na(xlim)) & length(xlim) != 2) {
    stop(cli::format_error(c(
      "x" = "Error: {.var xlim} must be a set of two values in the form of c(lower_x_limit, upper_x_limit)",
      "+++++> Input {.var xlim} was: {xlim}"
    )))
  }
  if (!all(is.na(xlim)) & !is.numeric(xlim)) {
    stop(cli::format_error(c(
      "x" = "Error: {.var xlim} must be a set of two values in the form of c(lower_x_limit, upper_x_limit)",
      "+++++> Input {.var xlim} was: {xlim}"
    )))
  }
  if (!all(is.na(xlim)) & (xlim[1] >= xlim[2])) {
    stop(cli::format_error(c(
      "x" = "Error: {.var xlim} must be a set of two values in the form of c(lower_x_limit, upper_x_limit)",
      "+++++> Input {.var xlim} was: {xlim}",
      "+++++> Note - The lower_x_limit was greater than or equal to the upper_x_limit"
    )))
  }
  # ----

  # mc_inferences_alpha ----
  if (mc_inferences_alpha < 0 | mc_inferences_alpha > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var mc_inferences_alpha} must be a positive numeric value between 0 and 1",
      "+++++> Input {.var mc_inferences_alpha} was: {mc_inferences_alpha}"
    )))
  }
  # ----

  # ind_inferences_alpha ----
  if (ind_inferences_alpha < 0 | ind_inferences_alpha > 1) {
    stop(cli::format_error(c(
      "x" = "Error: {.var ind_inferences_alpha} must be a positive numeric value between 0 and 1",
      "+++++> Input {.var ind_inferences_alpha} was: {ind_inferences_alpha}"
    )))
  }
  # ----

  return(list(
    shiny = as.logical(shiny),
    filter_limit = as.double(filter_limit),
    xlim = xlim,
    coord_flip = as.logical(coord_flip),
    text_font_size = as.numeric(text_font_size),
    mc_avg_and_CIs_color = tolower(as.character(mc_avg_and_CIs_color)),
    mc_inferences_color = tolower(as.character(mc_inferences_color)),
    mc_inferences_size = as.double(mc_inferences_size),
    mc_inferences_alpha = as.double(mc_inferences_alpha),
    mc_inferences_shape = ifelse(is.character(mc_inferences_shape), tolower(as.character(mc_inferences_shape)), as.integer(mc_inferences_shape)),
    ind_inferences_color = tolower(as.character(ind_inferences_color)),
    ind_inferences_size = as.double(ind_inferences_size),
    ind_inferences_alpha = as.double(ind_inferences_alpha),
    ind_inferences_shape = ifelse(is.character(ind_inferences_shape), tolower(as.character(ind_inferences_shape)), as.integer(ind_inferences_shape)),
    agg_inferences_color = tolower(as.character(agg_inferences_color)),
    agg_inferences_size = as.double(agg_inferences_size),
    agg_inferences_alpha = as.double(agg_inferences_alpha),
    agg_inferences_shape = ifelse(is.character(agg_inferences_shape), tolower(as.character(agg_inferences_shape)), as.integer(agg_inferences_shape)),
    mc_avg_and_CIs_linewidth = as.double(mc_avg_and_CIs_linewidth),
    ind_ivfn_and_tfn_linewidth = as.double(ind_ivfn_and_tfn_linewidth),
    agg_ivfn_and_tfn_linewidth = as.double(agg_ivfn_and_tfn_linewidth)
  ))
}



#' Get fcmconfr Object Plot Data
#'
#' @description
#' This function parses through an \code{\link{fcmconfr}} output to gather and
#' organize the analysis results into dataframes that are constructed to be
#' plugged directly into a ggplot2 pipeline
#'
#' @details
#' This function generates a list of outputs, but the contents vary based on whether
#' \code{\link{fcmconfr}} analyzed conventional, ivfn, or tfn FCMs.
#'
#' @param fcmconfr_object \[`fcmconfr`]\cr A direct output of the
#' \code{\link{fcmconfr}} function
#' @param filter_limit \[`double(1)`]\cr Only nodes with inferences above the
#' filter_limit across any analysis will be plotted. This removes nodes with
#' mostly 0-valued inferences indicating they were not impacted in the
#' simulation.
#'
#' @returns A list of fcmconfr output dataframes organized to streamline
#' functionality with ggplot
#'
#' @examples
#' NULL
#' @keywords internal
#' @noRd
get_plot_data <- function(fcmconfr_object) {

  fcm_class <- fcmconfr_object$fcm_class

  fcmconfr_inferences <- get_fcmconfr_inferences(fcmconfr_object)
  individual_inferences <- fcmconfr_inferences$individual_inferences

  # Elongate individual_inferences ----
  if (fcm_class == "conventional") {
    fcm_class_subtitle <- "Conventional FCMs"
    individual_inferences_longer <- tidyr::pivot_longer(individual_inferences, cols = seq_along(individual_inferences)[-1], names_to = "node", values_to = "value")
    individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
  } else if (fcm_class == "ivfn") {
    fcm_class_subtitle <- "IVFN FCMs"
    lower_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$lower_values, cols = seq_along(individual_inferences$ivfn_df)[-1], names_to = "node", values_to = "lower")
    upper_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$upper_values, cols = seq_along(individual_inferences$ivfn_df)[-1], names_to = "node", values_to = "upper")
    individual_inferences_longer <- merge(lower_individual_inferences_longer, upper_individual_inferences_longer)
    individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
  } else if (fcm_class == "tfn") {
    fcm_class_subtitle <- "TFN FCMs"
    lower_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$lower_values, cols = seq_along(individual_inferences$tfn_df)[-1], names_to = "node", values_to = "lower")
    mode_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$mode_values, cols = seq_along(individual_inferences$tfn_df)[-1], names_to = "node", values_to = "mode")
    upper_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$upper_values, cols = seq_along(individual_inferences$tfn_df)[-1], names_to = "node", values_to = "upper")
    individual_inferences_longer <- Reduce(function(x, y) merge(x, y, all=TRUE), list(lower_individual_inferences_longer, mode_individual_inferences_longer, upper_individual_inferences_longer))
    individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
  }
  # ----

  # Elongate aggregate_inferences ----
  if (!is.null(fcmconfr_inferences$aggregate_inferences)) {
    aggregate_inferences_longer <- fcmconfr_inferences$aggregate_inferences
    aggregate_inferences_longer$analysis_source <- "Agg FCM Inferences"
  } else {
    aggregate_inferences_longer <- data.frame(NA)
  }
  # ----

  # Elongate mc_inferences ----
  if (!is.null(fcmconfr_inferences$mc_inferences)) {
    mc_inferences <- fcmconfr_inferences$mc_inferences
    mc_inferences_no_index <- mc_inferences[, colnames(mc_inferences) != "adj_matrix_index"]
    mean_mc_inferences <- data.frame(t(apply(mc_inferences_no_index, 2, mean)))
    colnames(mean_mc_inferences) <- colnames(mc_inferences[colnames(mc_inferences) != "adj_matrix_index"])
    mc_inferences_longer <- tidyr::pivot_longer(mc_inferences, cols = seq_along(mc_inferences)[-1],  names_to = "node", values_to = "value")
    mc_mean_inferences_longer <- tidyr::pivot_longer(mean_mc_inferences, cols = seq_along(mean_mc_inferences), names_to = "node", values_to = "value")
    mc_inferences_longer$analysis_source <- "MC FCM Inferences"
    mc_mean_inferences_longer$analysis_source <- "MC FCMs Avg Inferences"
  } else {
    mc_inferences_longer <- data.frame(NA)
    mc_mean_inferences_longer <- data.frame(NA)
  }
  # ----

  # Elongate CIs ----
  if (!is.null(fcmconfr_inferences$mc_CIs_and_quantiles)) {
    mc_inference_CIs <- fcmconfr_inferences$mc_CIs_and_quantiles
    mc_inference_CIs_longer <- mc_inference_CIs
    mc_inference_CIs_longer$analysis_source <- "CIs of MC FCMs Avg Inferences"
  } else {
    mc_inference_CIs_longer <- data.frame(NA)
  }
  # ----

  # Calculate y-axis range ----
  max_inference <- max(c(individual_inferences_longer$upper, aggregate_inferences_longer$upper, mc_inferences_longer$value))
  max_y_axis <- (ceiling(max_inference*1000))/1000
  min_inference <- min(c(individual_inferences_longer$lower, aggregate_inferences_longer$lower, mc_inferences_longer$value))
  min_y_axis <- (ceiling(min_inference*1000))/1000
  # ----

  return(structure(
    .Data = list(
      fcm_class = fcmconfr_object$fcm_class,
      fcm_class_subtitle = fcm_class_subtitle,
      individual_inferences = individual_inferences_longer,
      aggregate_inferences = aggregate_inferences_longer,
      mc_inferences = mc_inferences_longer,
      mc_mean_inferences = mc_mean_inferences_longer,
      mc_inference_CIs = mc_inference_CIs_longer,
      max_y_axis = max_y_axis,
      min_y_axis = min_y_axis
    ),
    class = "fcmconfr_plot_data"
  ))
}


#' Get Concepts in fcmconfr Object to Include in Plot
#'
#' @description
#' This determines which concepts should be included in an fcmconfr output plot by
#' selecting concepts that either were NOT clamped (if applicable) or did not
#' reach a certain activation level throughout the simulation (i.e. whose
#' 0-value would take up space in the figure.)
#'
#' @details
#' This function removes:
#'     - Clamped Nodes because they would be held at 1 and would increase the
#'     x-axis, potentially diminishing the ability to view other data
#'     - Inactivated Nodes because they do not display on the plot and would
#'     add unnecessary whitespace to the plot.
#'
#' @param fcmconfr_object \[`fcmconfr`]\cr A direct output of the
#' \code{\link{fcmconfr}} function
#' @param include \[`character()`]\cr The concepts to include in the plot.
#' By default, include = 'all' which does not exclude any concepts. Set to a
#' vector of concept names to identify the only concepts to include in the plot.
#' @param filter_limit \[`double(1)`]\cr Only nodes with inferences above the
#' filter_limit across any analysis will be plotted. This removes nodes with
#' mostly 0-valued inferences indicating they were not impacted in the
#' simulation.
#'
#' @returns An array of concepts that should be included in the fcmconfr plot
#' output because they have simulation inferences greater than the filter_limit
#'
#' @examples
#' NULL
#' @keywords internal
#' @noRd
filter_concepts_to_plot <- function(fcmconfr_plot_data,
                                    include = "all",
                                    filter_limit = 1e-10) {

  concepts <- unique(fcmconfr_plot_data$individual_inferences$node)

  if (identical(include, "all")) {
    include <- concepts
  }

  individual_inferences_values <- fcmconfr_plot_data$individual_inferences[!(colnames(fcmconfr_plot_data$individual_inferences) %in% c("adj_matrix_index", "analysis_source"))]
  longer_individual_inferences_values <- tidyr::pivot_longer(individual_inferences_values, cols = seq_along(individual_inferences_values)[-1])
  max_individual_inferences <- vapply(concepts, function(concept) max(abs(longer_individual_inferences_values$value[longer_individual_inferences_values$node == concept])), FUN.VALUE = numeric(1))

  if (!all(is.na(fcmconfr_plot_data$aggregate_inferences))) {
    aggregate_inferences_values <- fcmconfr_plot_data$aggregate_inferences[colnames(fcmconfr_plot_data$aggregate_inferences) != c("analysis_source")]
    if (fcmconfr_plot_data$fcm_class == "conventional") {
      longer_aggregate_inferences_values <- aggregate_inferences_values
    } else {
      longer_aggregate_inferences_values <- tidyr::pivot_longer(aggregate_inferences_values, cols = 2:ncol(aggregate_inferences_values))
    }
    max_aggregate_inferences <- vapply(concepts, function(concept) max(abs(longer_aggregate_inferences_values$value[longer_aggregate_inferences_values$node == concept])), FUN.VALUE = numeric(1))
  } else {
    longer_aggregate_inferences_values <- data.frame(value = 0)
    max_aggregate_inferences <- rep(0, length(concepts))
    names(max_aggregate_inferences) <- concepts
  }

  if (!all(is.na(fcmconfr_plot_data$mc_inferences))) {
    mc_inferences_values <- fcmconfr_plot_data$mc_inferences[!(colnames(fcmconfr_plot_data$mc_inferences) %in% c("adj_matrix_index", "analysis_source"))]
    mc_mean_inferences_values <- fcmconfr_plot_data$mc_mean_inferences[colnames(fcmconfr_plot_data$mc_mean_inferences) != "analysis_source"]
  } else {
    mc_inferences_values <- data.frame(NA)
  }
  max_mc_inferences <- vapply(concepts, function(concept) max(mc_inferences_values$value[mc_inferences_values$node == concept]), FUN.VALUE = numeric(1))

  if (!all(is.na(fcmconfr_plot_data$mc_inference_CIs))) {
    mc_inference_CIs_values <- fcmconfr_plot_data$mc_inference_CIs[colnames(fcmconfr_plot_data$mc_inference_CIs) != "analysis_source"]
  }

  max_inferences_df <- rbind(max_individual_inferences, max_aggregate_inferences, max_mc_inferences)
  surpasses_filter_limit <- apply(max_inferences_df, 2, function(x) any(x >= filter_limit))

  nodes_to_plot <- concepts[surpasses_filter_limit]
  nodes_to_plot <- nodes_to_plot[nodes_to_plot %in% include]
  fcmconfr_plot_data$nodes_to_plot <- nodes_to_plot

  fcmconfr_plot_data$individual_inferences <- fcmconfr_plot_data$individual_inferences[fcmconfr_plot_data$individual_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$aggregate_inferences <- fcmconfr_plot_data$aggregate_inferences[fcmconfr_plot_data$aggregate_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_inferences <- fcmconfr_plot_data$mc_inferences[fcmconfr_plot_data$mc_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_mean_inferences <- fcmconfr_plot_data$mc_mean_inferences[fcmconfr_plot_data$mc_mean_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_inference_CIs <- fcmconfr_plot_data$mc_inference_CIs[fcmconfr_plot_data$mc_inference_CIs$node %in% nodes_to_plot, ]

  return(structure(
    .Data = fcmconfr_plot_data,
    class = "filtered_fcmconfr_plot_data"
  ))
}




#' Autoplot fcmconfr
#'
#' @description
#' Generates a generic plot visualizing \code{\link{fcmconfr}} results. Call the
#' function name directly (\code{\link{autoplot.fcmconfr}})) without parentheses
#' to see the exact code to generate the plots, then copy-and-paste and edit
#' as needed.
#'
#' @param object \[`fcmconfr`]\cr A direct output of the
#' \code{\link{fcmconfr}} function
#' @param shiny \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
#' toggle on/off results from different analyses.
#' @param filter_limit \[`double(1)`]\cr Only nodes with inferences above the
#' filter_limit across any analysis will be plotted. This removes nodes with
#' mostly 0-valued inferences indicating they were not impacted in the
#' simulation.
#' @param xlim \[`double(1)`]\cr The x-axis plot limits. xlim = NA lets ggplot
#' determine the x-axis limits. xlim = c(lower_limit, upper_limit) for manual
#' input limits. See ?ggplot2::xlim for additional info.
#' @param coord_flip \[`logical(1)`]\cr  Swap x- and y-axes (i.e. rotate plot).
#' See ?ggplot2::coord_flip for additional info.
#' @param text_font_size \[`double(1)`]\cr  The font size of axis labels.
#' text_font_size = NA lets ggplot determine the axis label font size.
#' @param mc_avg_and_CIs_color \[`character(1)`]\cr Color of the crossbar
#' (lines) indicating the avg inferences of empirical FCMs generated via Monte
#' Carlo sampling and the confidence intervals about those averages.
#' @param mc_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of empirical FCMs generated via Monte Carlo sampling.
#' @param mc_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of Monte Carlo FCMs. Must be greater than 0.
#' @param mc_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of empirical FCMs
#' generated via Monte Carlo sampling. Range from 0 to 1 (0: Transparent to
#' 1: Opaque).
#' @param mc_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of empirical FCMs generated via Monte
#' Carlo sampling. Accepts PCH point values and character strings.
#' @param ind_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of individual FCMs.
#' @param ind_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of individual FCMs. Must be greater than 0.
#' @param ind_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of individual FCMs. Range
#' from 0 to 1 (0: Transparent to 1: Opaque).
#' @param ind_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of individual FCMs. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param agg_inferences_color \[`character(1)`]\cr Color of the points
#' representing inferences of the aggregate FCM
#' @param agg_inferences_size \[`double(1)` - Positive]\cr Size of the points
#' for inferences of aggregate FCM. Must be greater than 0.
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param mc_avg_and_CIs_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing the average (and confidence bounds the average) of the
#' Monte Carlo FCMs inferences
#' @param ind_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr  Linewidth of
#' lines representing inferences for analyses of individual IVFN- and TFN- FCMs.
#' @param agg_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing inferences for analyses of aggregate IVFN- and TFN- FCMs
#'
#' @returns An autoplot plot of an fcmconfr object's results
#'
#' @importFrom ggplot2 ggplot aes .data
#'
#' @examples
#' NULL
#' @keywords internal
#' @noRd
autoplot.fcmconfr <- function(object,
                              include = "all",
                              shiny = FALSE,
                              # Plot Format Parameters
                              filter_limit = 1e-3,
                              xlim = NA, # c(lower_limit, upper_limit)
                              coord_flip = FALSE,
                              text_font_size = NA, # NA: let ggplot determine
                              # Plot Aesthetic Parameters
                              mc_avg_and_CIs_color = "blue",
                              mc_inferences_color = "blue",
                              mc_inferences_size = 1,
                              mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                              mc_inferences_shape = 3, # R PCH point shape values
                              ind_inferences_color = "black",
                              ind_inferences_size = 1,
                              ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                              ind_inferences_shape = 16, # R PCH point shape values
                              agg_inferences_color = "red",
                              agg_inferences_size = 1,
                              agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                              agg_inferences_shape = 17, # R PCH point shape values
                              mc_avg_and_CIs_linewidth = 0.1,
                              ind_ivfn_and_tfn_linewidth = 0.1,
                              agg_ivfn_and_tfn_linewidth = 0.6,
                              ...) {

  if (object$fcm_class == "ivfn") {
    ind_inferences_shape <- NA
    agg_inferences_shape <- NA
  }

  if (is.character(ind_inferences_shape)) {
    ind_inferences_shape <- ggplot2::translate_shape_string(ind_inferences_shape)
  }
  if (is.character(agg_inferences_shape)) {
    agg_inferences_shape <- ggplot2::translate_shape_string(agg_inferences_shape)
  }
  if (is.character(mc_inferences_shape)) {
    mc_inferences_shape <- ggplot2::translate_shape_string(mc_inferences_shape)
  }

  # Get Plotting Data ----
  plot_data <- get_plot_data(object)
  plot_data <- filter_concepts_to_plot(plot_data, include, filter_limit)
  nodes_to_plot <- plot_data$nodes_to_plot

  y_axis_buffer <- 0.1
  plot_data$max_y_axis <- plot_data$max_y_axis + y_axis_buffer
  plot_data$min_y_axis <- plot_data$min_y_axis - y_axis_buffer

  if (object$params$simulation_opts$squashing == "sigmoid" & all(object$params$simulation_opts$clamping == 0)) {
    zero_intercept <- 0.5
  } else {
    zero_intercept <- 0
  }

  has_agg_calcs <- object$params$additional_opts$run_agg_calcs
  has_mc_calcs <- object$params$additional_opts$run_mc_calcs
  has_ci_calcs <- object$params$additional_opts$run_ci_calcs

  inputs_only <- (!has_agg_calcs && !has_mc_calcs && !has_ci_calcs)
  inputs_and_agg <- (has_agg_calcs && !has_mc_calcs && !has_ci_calcs)
  inputs_agg_and_mc_no_bs <- (has_agg_calcs && has_mc_calcs && !has_ci_calcs)
  inputs_agg_and_mc_w_bs <- (has_agg_calcs && has_mc_calcs && has_ci_calcs)
  inputs_no_agg_and_mc_w_no_bs <- (!has_agg_calcs && has_mc_calcs && !has_ci_calcs)
  inputs_no_agg_and_mc_w_bs <- (!has_agg_calcs && has_mc_calcs && has_ci_calcs)
  # ----

  ggplot_main <- ggplot() +
    ggplot2::geom_vline(xintercept = zero_intercept, linetype = "dotted", size = 0.5)

  # MC Avg Ingerences CIs ----
  if (has_ci_calcs) {
    ggplot_main <- ggplot_main +
      ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_inference_CIs),
        # lower_CI col. index = 3
        # upper_CI col. index = 4
        aes(y = .data$node, xmin = plot_data$mc_inference_CIs[, 3], x = plot_data$mc_inference_CIs[, 3], xmax = plot_data$mc_inference_CIs[, 3], linewidth = .data$analysis_source),
        width = 0.7, color = mc_avg_and_CIs_color, linetype = "dashed",
        na.rm = TRUE, key_glyph = ggplot2::draw_key_vline
      ) +
      ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_inference_CIs),
        # lower_CI col. index = 3
        # upper_CI col. index = 4
        aes(y = .data$node, xmin = plot_data$mc_inference_CIs[, 4], x = plot_data$mc_inference_CIs[, 4], xmax = plot_data$mc_inference_CIs[, 4], linewidth = .data$analysis_source),
        width = 0.7, color = mc_avg_and_CIs_color, linetype = "dashed",
        na.rm = TRUE, key_glyph = ggplot2::draw_key_vline
      ) + ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_mean_inferences),
        aes(y = .data$node, xmin = .data$value, x = .data$value, xmax = .data$value, linewidth = .data$analysis_source),
        width = 0.7, color = mc_avg_and_CIs_color,
        na.rm = TRUE, key_glyph = ggplot2::draw_key_vline
      )
  }
  # ----

  # MC FCM Inferences ----
  if (has_mc_calcs) {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$mc_inferences),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        position = ggplot2::position_dodge2(width = 0.25), size = mc_inferences_size,
        # shape = 3,
        na.rm = FALSE
      ) # +
      # ggplot2::geom_crossbar(
      #   data = ggplot2::remove_missing(plot_data$mc_mean_inferences),
      #   aes(y = .data$node, xmin = .data$value, x = .data$value, xmax = .data$value),
      #   width = 0.9, linewidth = 0.1, color = mc_avg_and_CIs_color, na.rm = FALSE, key_glyph = ggplot2::draw_key_vline
      # )
  }
  # ----

  # Individual FCM Inferences ----
  if (object$fcm_class == "conventional") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$individual_inferences),
        position = ggplot2::position_dodge2(width = 0.1),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        size = ind_inferences_size, na.rm = TRUE
      )
  } else if (object$fcm_class == "ivfn") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_linerange(
        data = ggplot2::remove_missing(plot_data$individual_inferences),
        aes(y = .data$node, xmin = .data$lower, xmax = .data$upper, color = .data$analysis_source, alpha = .data$analysis_source),
        position = ggplot2::position_dodge2(width = 0.5), linewidth = ind_ivfn_and_tfn_linewidth
      )
  } else if (object$fcm_class == "tfn") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_pointrange(
        data = ggplot2::remove_missing(plot_data$individual_inferences),
        aes(y = .data$node, xmin = .data$lower, x = .data$mode, xmax = .data$upper, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        position = ggplot2::position_dodge2(width = 0.5), fatten = 1, linewidth = ind_ivfn_and_tfn_linewidth, size = ind_inferences_size
      )

      # ggplot2::ggplot() +
      # ggplot2::geom_pointrange(
      #   data = ggplot2::remove_missing(plot_data$individual_inferences),
      #   aes(y = .data$node, xmin = .data$lower, x = .data$mode, xmax = .data$upper),
      #   position = ggplot2::position_dodge2(width = 0.5), fatten = 1, linewidth = ind_ivfn_and_tfn_linewidth, color = "blue"
      # ) + ggplot2::theme_classic()
  }
  # ----

  # Aggregate FCM Inferences ----
  if (has_agg_calcs && object$fcm_class == "conventional") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$aggregate_inferences),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        size = agg_inferences_size,
      )
  } else if (has_agg_calcs && object$fcm_class == "ivfn") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_linerange(
        data = ggplot2::remove_missing(plot_data$aggregate_inferences),
        aes(y = .data$node, xmin = .data$lower, xmax = .data$upper, alpha = .data$analysis_source, color = .data$analysis_source),
        linewidth = agg_ivfn_and_tfn_linewidth
      )
  } else if (has_agg_calcs && object$fcm_class == "tfn") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_pointrange(
        data = ggplot2::remove_missing(plot_data$aggregate_inferences),
        aes(y = .data$node, xmin = .data$lower, x = .data$mode, xmax = .data$upper, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        fatten = 2, linewidth = agg_ivfn_and_tfn_linewidth, size = agg_inferences_size
      )
  }
  # ----

  # Setup Legend Scales ----
  scale_color_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_color")
  scale_size_manual_values_str <- paste0("c('Ind FCM Inferences' = agg_inferences_size/2")
  scale_alpha_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_alpha")
  scale_shape_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_shape")
  scale_shape_manual_override_str <- paste0("c(ind_inferences_shape")
  scale_linewidth_maual_values_str <- paste0("c('Ind FCM Inferences' = ind_ivfn_and_tfn_linewidth")
  scale_breaks_values_str <- paste0("c('Ind FCM Inferences'")
  if (!inputs_only & !(inputs_no_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_no_bs)) {
    scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_color")
    scale_size_manual_values_str <- paste0(scale_size_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_size/2")
    scale_alpha_manual_values_str <- paste0(scale_alpha_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_alpha")
    scale_shape_manual_values_str <- paste0(scale_shape_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_shape")
    scale_shape_manual_override_str <- paste0(scale_shape_manual_override_str, ", agg_inferences_shape")
    scale_linewidth_maual_values_str <- paste0(scale_linewidth_maual_values_str, ", 'Agg FCM Inferences' = ind_ivfn_and_tfn_linewidth")
    scale_breaks_values_str <- paste0(scale_breaks_values_str, ", 'Agg FCM Inferences'")
  }
  if (inputs_agg_and_mc_no_bs | inputs_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_no_bs) {
    scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_color")
    scale_size_manual_values_str <- paste0(scale_size_manual_values_str , ", 'MC FCM Inferences' = mc_inferences_size")
    scale_alpha_manual_values_str <- paste0(scale_alpha_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_alpha")
    scale_shape_manual_values_str <- paste0(scale_shape_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_shape")
    scale_shape_manual_override_str <- paste0(scale_shape_manual_override_str, ", mc_inferences_shape")
    scale_linewidth_maual_values_str <- paste0(scale_linewidth_maual_values_str, ", 'MC FCM Inferences' = NA")
    scale_breaks_values_str <- paste0(scale_breaks_values_str, ", 'MC FCM Inferences'")
  }
  scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ")")
  scale_size_manual_values_str <- paste0(scale_size_manual_values_str, ")")
  scale_alpha_manual_values_str <- paste0(scale_alpha_manual_values_str, ")")
  scale_shape_manual_values_str <- paste0(scale_shape_manual_values_str, ")")
  scale_shape_manual_override_str <- paste0(scale_shape_manual_override_str, ")")
  scale_linewidth_maual_values_str <- paste0(scale_linewidth_maual_values_str, ")")
  scale_breaks_values_str <- paste0(scale_breaks_values_str, ")")

  if (object$fcm_class == "conventional") {
    scales_str <- paste0(
      "ggplot_main +
        ggplot2::scale_color_manual(
          values = ", scale_color_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_size_manual(
          values = ", scale_size_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_alpha_manual(
          values = ", scale_alpha_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_shape_manual(
          values = ", scale_shape_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_linewidth_manual(
          values = c('CIs of MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth,
                     'MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth),
          guide = ggplot2::guide_legend(order = 2)
        )"
    )
  } else if (object$fcm_class == "ivfn") {
    scales_str <- paste0(
      "ggplot_main +
        ggplot2::scale_color_manual(
          values = ", scale_color_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(
            override.aes = list(
              size = ", scale_size_manual_values_str, ",
              alpha = ", scale_alpha_manual_values_str, ",
              shape = ", scale_shape_manual_override_str, ",
              linewidth = ", scale_linewidth_maual_values_str, "
          ), order = 1)
        ) +
        ggplot2::scale_size_manual(
          values = ", scale_size_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_alpha_manual(
          values = ", scale_alpha_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = 'none'
        ) +
        ggplot2::scale_shape_manual(
          values = ", scale_shape_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = 'none'
        ) +
        ggplot2::scale_linewidth_manual(
          values = c('CIs of MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth,
                     'MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth),
          guide = ggplot2::guide_legend(order = 2)
        )"
    )
  } else if (object$fcm_class == "tfn") {
    scales_str <- paste0(
      "ggplot_main +
        ggplot2::scale_color_manual(
          values = ", scale_color_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(
            override.aes = list(
              size = ", scale_size_manual_values_str, ",
              alpha = ", scale_alpha_manual_values_str, ",
              shape = ", scale_shape_manual_override_str, ",
              linewidth = ", scale_linewidth_maual_values_str, "
          ), order = 1)
        ) +
        ggplot2::scale_size_manual(
          values = ", scale_size_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          guide = ggplot2::guide_legend(order = 1)
        ) +
        ggplot2::scale_alpha_manual(
          values = ", scale_alpha_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          # guide = ggplot2::guide_legend(order = 1),
          guide = 'none'
        ) +
        ggplot2::scale_shape_manual(
          values = ", scale_shape_manual_values_str, ",
          breaks = ", scale_breaks_values_str, ",
          #guide = ggplot2::guide_legend(order = 1)
          guide = 'none'
        ) +
        ggplot2::scale_linewidth_manual(
          values = c('CIs of MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth,
                     'MC FCMs Avg Inferences' = mc_avg_and_CIs_linewidth),
          guide = ggplot2::guide_legend(order = 2)
        )"
    )
  }

  scales_expr <- parse(text = scales_str)
  ggplot_main <- eval(scales_expr)

  if (!all(is.na(xlim))) {
    ggplot_main <- ggplot_main +
      ggplot2::coord_cartesian(xlim = c(xlim[1], xlim[2]))
  }

  # ----

  if (!coord_flip) {
    fcmconfr_plot <- ggplot_main + fcmconfr_default_theme()
  } else {
    fcmconfr_plot <- ggplot_main + fcmconfr_default_theme() + ggplot2::coord_flip()
  }

  if (!isTRUE(is.na(text_font_size)) && !isTRUE(is.null(text_font_size))) {
    fcmconfr_plot <- fcmconfr_plot +
      ggplot2::theme(text = ggplot2::element_text(size = text_font_size))
  }

  fcmconfr_plot
}


#' Custom plot.fcmconfr Theme
#'
#' @description
#' Theme-ing for plot.fcmconfr to improve readability in
#' \code{\link{plot.fcmconfr}} function definition
#'
#' @param ... Additional Inputs
#'
#' @importFrom ggplot2 %+replace%
#'
#' @returns A custom ggplot2 theme for fcmconfr plot objects
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
fcmconfr_theme_custom <- function(...) {
  ggplot2::theme_classic(...) %+replace%
    ggplot2::theme(
      plot.margin = ggplot2::margin(t = 20, r = 40, b = 20, l = 20),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.direction = "vertical",
      legend.title = ggplot2::element_blank(),
      legend.justification = "center",
      # legend.spacing = ggplot2::unit(0.001, 'cm'),
      legend.key.spacing.y = ggplot2::unit(0.25, 'cm')
    )
}


#' Default plot.fcmconfr Theme
#'
#' @description
#' A formal call to the custom_theme defined by \code{\link{fcmconfr_theme_custom}}
#'
#' @returns A default ggplot2 theme for fcmconfr plot objects
#'
#' @keywords internal
#'
#' @export
#' @examples
#' NULL
fcmconfr_default_theme <- function() {
  fcmconfr_theme_custom()
}


#' (Interactive) Plot fcmconfr
#'
#' @description
#' Load plot of fcmconfr output in an interactive shiny window
#'
#' @param x A direct output of the \code{\link{fcmconfr}} function
#' @param ... Additional inputs:
#'  - filter_limit Remove concepts whose inferences do not exceed this value
#'  - coord_flip Swap x- and y-axes (i.e. rotate plot)
#'
#' @importFrom graphics plot
#'
#' @returns A shiny window displaying a plot of an fcmconfr object's results
#'
#' @keywords internal
#'
#' @importFrom bslib versions
#' @importFrom shiny shinyApp runApp
#'
#' @export
#' @examples
#' NULL
interactive_plot_fcmconfr <- function(x, ...) {
  # These bslib and shinyWidgets calls are only here to be acknowledged in
  # R CMD Check, they have no impact on the rest of the function and can be
  # ignored.
  bslib::versions()
  shinyWidgets::animations

  server <- source(system.file(file.path('shiny', 'plot.fcmconfr', 'server.R'), package = 'fcmconfr'), local = TRUE)$value
  ui <- source(system.file(file.path('shiny', 'plot.fcmconfr', 'ui.R'), package = 'fcmconfr'), local = TRUE)$value

  shiny_env <- new.env()
  assign("fcmconfr_output", x, shiny_env)
  assign("additional_inputs", as.list(...), shiny_env)
  environment(ui) <- shiny_env
  environment(server) <- shiny_env
  app <- shiny::shinyApp(
    ui = ui,
    server = server
  )

  shiny::runApp(app)
}

