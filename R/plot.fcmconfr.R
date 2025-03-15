
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
#' This plots the output of fcmconfr() using ggplot. Set interactive = TRUE to
#' load plot in a Shiny app and toggle on/off results from different analyses.
#'
#' @details
#' Generates a generic plot visualizing \code{\link{fcmconfr}} results.
#'
#' @param x A direct output of the \code{\link{fcmconfr}} function
#' @param interactive \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
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
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
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
#' @srrstats {EA5.0, EA5.0a, EA5.0b} Emphasis on accessibility in graphical outputs
#' @srrstats {EA5.5} All visualizations include units no all axes.
#'
#' @example man/examples/ex-plot.fcmconfr.R
plot.fcmconfr <- function(x,
                          interactive = FALSE,
                          # Plot Format Parameters
                          filter_limit = 1e-3,
                          xlim = NA, # c(lower_limit, upper_limit)
                          coord_flip = FALSE,
                          text_font_size = NA, # NA: let ggplot determine
                          # Plot Aesthetic Parameters
                          mc_avg_and_CIs_color = "blue",
                          mc_inferences_color = "blue",
                          mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                          mc_inferences_shape = 3, # R PCH point shape values
                          ind_inferences_color = "black",
                          ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                          ind_inferences_shape = 16, # R PCH point shape values
                          agg_inferences_color = "red",
                          agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                          agg_inferences_shape = 17, # R PCH point shape values
                          ind_ivfn_and_tfn_linewidth = 0.1,
                          agg_ivfn_and_tfn_linewidth = 0.6,
                          ...) {

  requireNamespace(c("graphics", "shiny", "shinyWidgets", "bslib"))

  additional_inputs = list(...)
  if (length(additional_inputs) > 0) {
    warning(cli::format_warning(c(
      "!" = "Warning: Additional Inputs given as ... are ignored",
      "~~~~~ Ignoring additional inputs: {names(additional_inputs)}"
    )))
  }

  # Input Checks ----
  checks <- check_plot_fcmconfr_inputs(
    interactive,
    filter_limit, xlim, coord_flip, text_font_size,
    mc_avg_and_CIs_color,
    mc_inferences_color, mc_inferences_alpha, mc_inferences_shape,
    ind_inferences_color, ind_inferences_alpha, ind_inferences_shape,
    agg_inferences_color, agg_inferences_alpha, agg_inferences_shape,
    ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
  )
  interactive = checks$interactive
  filter_limit = checks$filter_limit
  xlim = checks$xlim
  coord_flip = checks$coord_flip
  text_font_size = checks$text_font_size
  mc_avg_and_CIs_color = checks$mc_avg_and_CIs_color
  mc_inferences_color = checks$mc_inferences_color
  mc_inferences_alpha = checks$mc_inferences_alpha
  mc_inferences_shape = checks$mc_inferences_shape
  ind_inferences_color = checks$ind_inferences_color
  ind_inferences_alpha = checks$ind_inferences_alpha
  ind_inferences_shape = checks$ind_inferences_shape
  agg_inferences_color = checks$agg_inferences_color
  agg_inferences_alpha = checks$agg_inferences_alpha
  agg_inferences_shape = checks$agg_inferences_shape
  ind_ivfn_and_tfn_linewidth = checks$ind_ivfn_and_tfn_linewidth
  agg_ivfn_and_tfn_linewidth = checks$agg_ivfn_and_tfn_linewidth
  # ----

  if (!interactive) {
    suppressWarnings(print(
      autoplot.fcmconfr(
        x,
        interactive,
        filter_limit, xlim, coord_flip, text_font_size,
        mc_avg_and_CIs_color,
        mc_inferences_color, mc_inferences_alpha, mc_inferences_shape,
        ind_inferences_color, ind_inferences_alpha, ind_inferences_shape,
        agg_inferences_color, agg_inferences_alpha, agg_inferences_shape,
        ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
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
#' @param interactive \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
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
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
#' @param ind_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr  Linewidth of
#' lines representing inferences for analyses of individual IVFN- and TFN- FCMs.
#' @param agg_ivfn_and_tfn_linewidth \[`double(1)` - Positive]\cr Linewidth of
#' lines representing inferences for analyses of aggregate IVFN- and TFN- FCMs
#'
#' @examples
#' NULL
#' @keywords internal
#' @noRd
check_plot_fcmconfr_inputs <- function(interactive = FALSE,
                                       # Plot Format Parameters
                                       filter_limit = 1e-3,
                                       xlim = NA, # c(lower_limit, upper_limit)
                                       coord_flip = FALSE,
                                       text_font_size = NA, # NA: let ggplot determine
                                       # Plot Aesthetic Parameters
                                       mc_avg_and_CIs_color = "blue",
                                       mc_inferences_color = "blue",
                                       mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                                       mc_inferences_shape = 3, # R PCH point shape values
                                       ind_inferences_color = "black",
                                       ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                                       ind_inferences_shape = 16, # R PCH point shape values
                                       agg_inferences_color = "red",
                                       agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                                       agg_inferences_shape = 17, # R PCH point shape values
                                       ind_ivfn_and_tfn_linewidth = 0.1,
                                       agg_ivfn_and_tfn_linewidth = 0.6) {

  check_fcmconfr_input(interactive, check = "logical", var_name = "interactive")
  check_fcmconfr_input(filter_limit, check = "positive_number", var_name = "filter_limit")
  # xlim checked below
  check_fcmconfr_input(coord_flip, check = "logical", var_name = "coord_flip")
  if (!is.na(text_font_size)) check_fcmconfr_input(text_font_size, check = "positive_number", var_name = "text_font_size")
  check_fcmconfr_input(mc_avg_and_CIs_color, check = "color", var_name = "mc_avg_and_CIs_color")
  check_fcmconfr_input(mc_inferences_color, check = "color", var_name = "mc_inferences_color")
  check_fcmconfr_input(mc_inferences_alpha, check = "positive_number", var_name = "mc_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(mc_inferences_shape, check = "shape", var_name = "mc_inferences_shape")
  check_fcmconfr_input(ind_inferences_color, check = "color", var_name = "ind_inferences_color")
  check_fcmconfr_input(ind_inferences_alpha, check = "positive_number", var_name = "ind_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(ind_inferences_shape, check = "shape", var_name = "ind_inferences_shape")
  check_fcmconfr_input(agg_inferences_color, check = "color", var_name = "agg_inferences_color")
  check_fcmconfr_input(agg_inferences_alpha, check = "positive_number", var_name = "agg_inferences_alpha", zero_is_positive = TRUE)
  check_fcmconfr_input(agg_inferences_shape, check = "shape", var_name = "agg_inferences_shape")
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
    interactive = as.logical(interactive),
    filter_limit = as.double(filter_limit),
    xlim = xlim,
    coord_flip = as.logical(coord_flip),
    text_font_size = as.numeric(text_font_size),
    mc_avg_and_CIs_color = tolower(as.character(mc_avg_and_CIs_color)),
    mc_inferences_color = tolower(as.character(mc_inferences_color)),
    mc_inferences_alpha = as.double(mc_inferences_alpha),
    mc_inferences_shape = ifelse(is.character(mc_inferences_shape), tolower(as.character(mc_inferences_shape)), as.integer(mc_inferences_shape)),
    ind_inferences_color = tolower(as.character(ind_inferences_color)),
    ind_inferences_alpha = as.double(ind_inferences_alpha),
    ind_inferences_shape = ifelse(is.character(ind_inferences_shape), tolower(as.character(ind_inferences_shape)), as.integer(ind_inferences_shape)),
    agg_inferences_color = tolower(as.character(agg_inferences_color)),
    agg_inferences_alpha = as.double(agg_inferences_alpha),
    agg_inferences_shape = ifelse(is.character(agg_inferences_shape), tolower(as.character(agg_inferences_shape)), as.integer(agg_inferences_shape)),
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
#' This function produces slightly different outputs for \code{\link{fcmconfr}}
#' outputs generated from conventional, ivfn, and tfn FCMs
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
get_plot_data <- function(fcmconfr_object, filter_limit = 10e-3) {
  # nodes_to_plot <- get_concepts_to_plot(fcmconfr_object, filter_limit)

  # if (length(nodes_to_plot$name) == 0) {
  #   stop(cli::format_error(c(
  #     "x" = "Error: No inferences are greater than the {.var filter limit}, so no plot cannot be drawn.",
  #     "+++++> Reduce {.var filter limit}"
  #   )))
  #   stop("No inferences are greater than the filter limit, so no plot cannot be drawn.")
  # }

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
    aggregate_inferences <- fcmconfr_inferences$aggregate_inferences
    aggregate_inferences_longer <- aggregate_inferences
    aggregate_inferences_longer$analysis_source <- "Agg FCM Inferences"
  }
  # ----

  # Elongate mc_inferences ----
  if (!is.null(fcmconfr_inferences$mc_inferences)) {
    mc_inferences <- fcmconfr_inferences$mc_inferences
    mc_inferences_no_index <- mc_inferences[, colnames(mc_inferences) != "adj_matrix_index"]
    mean_mc_inferences <- data.frame(t(apply(mc_inferences_no_index, 2, mean)))
    mc_inferences_longer <- tidyr::pivot_longer(mc_inferences, cols = seq_along(mc_inferences)[-1],  names_to = "node", values_to = "value")
    mc_mean_inferences_longer <- tidyr::pivot_longer(mean_mc_inferences, cols = seq_along(mean_mc_inferences), names_to = "node", values_to = "value")
    mc_inferences_longer$analysis_source <- "MC FCM Inferences"
    mc_mean_inferences_longer$analysis_source <- "MC FCM Avg Inferences"
  }
  # ----

  # Elongate CIs ----
  if (!is.null(fcmconfr_inferences$mc_CIs_and_quantiles)) {
    mc_inference_CIs <- fcmconfr_inferences$mc_CIs_and_quantiles
    mc_inference_CIs_longer <- mc_inference_CIs
    mc_inference_CIs_longer$analysis_source <- "CIs of MC FCM Avg Inferences"
  }
  # ----

  # Calculate y-axis range ----
  max_inference <- max(c(individual_inferences_longer$upper, aggregate_inferences_longer$upper, mc_inferences_longer$value))
  max_y_axis <- (ceiling(max_inference*1000))/1000
  min_inference <- max(c(individual_inferences_longer$lower, aggregate_inferences_longer$lower, mc_inferences_longer$value))
  min_y_axis <- (ceiling(min_inference*1000))/1000
  # ----

  return(structure(
    .Data = list(
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

  # if (fcmconfr_object$params$additional_opts$run_agg_calcs) {
  #   aggregate_inferences <- fcmconfr_inferences$aggregate_inferences
  #   if (fcmconfr_object$fcm_class == "conventional") {
  #     aggregate_inferences <- data.frame(
  #       aggregate_inferences[,nodes_to_plot$index]
  #     )
  #   } else {
  #     aggregate_inferences <- data.frame(
  #       aggregate_inferences[nodes_to_plot$index ,]
  #     )
  #   }
  # } else {
  #   aggregate_inferences <- NA
  # }

  # if (fcmconfr_object$params$additional_opts$run_mc_calcs) {
  #   mc_inference_values <- fcmconfr_inferences$mc_inferences
  #
  #   mc_inference_values <- data.frame(
  #     mc_inference_values[nodes_to_plot$index, ]
  #   )
  #
  #   mean_mc_inferences <- data.frame(apply(mc_inference_values[, -1], 2, mean, simplify = FALSE))
  #   mean_mc_inferences <- data.frame(
  #     mean_mc_inferences[, nodes_to_plot$index]
  #   )
  #
  #   mc_inferences <- list(
  #     inferences = mc_inference_values,
  #     averages = mean_mc_inferences
  #   )
  # } else {
  #   mc_inferences <- list(
  #     inferences = data.frame(adj_matrix_index = NA, empty = NA),
  #     averages = data.frame(blank = NA, empty = NA)
  #   )
  # }
  # if (fcmconfr_object$params$additional_opts$run_ci_calcs) {
  #   mc_inference_CIs <- as.data.frame(fcmconfr_object$inferences$monte_carlo_fcms$confidence_intervals$CIs_and_quantiles_by_node)
  #   mc_inference_CIs <- data.frame(
  #     mc_inference_CIs[nodes_to_plot$index, ]
  #   )
  #   mc_inference_CIs <- mc_inference_CIs[, c(1, which(sapply(colnames(mc_inference_CIs), function(string) grepl("_CI", string))))]
  #   colnames(mc_inference_CIs) <- c("node", "lower_CI", "upper_CI")
  #
  # } else {
  #   mc_inference_CIs <- data.frame(
  #     name = 'blank',
  #     lower_CI = 0,
  #     upper_CI = 0
  #   )
  # }

  # if (fcmconfr_object$fcm_class == "conventional") {
  #   fcm_class_subtitle <- "Conventional FCMs"
  #   individual_inferences_longer <- tidyr::pivot_longer(individual_inferences, cols = 2:ncol(individual_inferences), values_to = "value", names_to = "node")
  #   individual_inferences_longer$adj_matrix_index <- NULL
  #   if (is.na(aggregate_inferences)) {
  #     aggregate_inferences <- data.frame("index" = NA, "node" = NA)
  #   }
  #   aggregate_inferences_longer <- tidyr::pivot_longer(aggregate_inferences, cols = 2:ncol(aggregate_inferences), values_to = "value", names_to = "node")
  #   mc_inferences_longer <- tidyr::pivot_longer(mc_inferences$inferences, cols = 2:ncol(mc_inferences$inferences), values_to = "value", names_to = "node")
  #   mc_inferences_longer$adj_matrix_index <- NULL
  #   mc_avg_inferences_longer <- tidyr::pivot_longer(mc_inferences$averages, cols = 1:ncol(mc_inferences$averages), values_to = "value", names_to = "node")

    # # Need to write a better filter for this
    # if (any(abs(individual_inferences_longer$value) > 1) | any(abs(aggregate_inferences_longer$value[!is.na(aggregate_inferences_longer$value)]) > 1) | any(abs(mc_inferences_longer$value[!is.na(mc_inferences_longer$value)]) > 1)) {
    #   warning("Some inferences have a magnitude greater than 1 which suggests that
    #           the simulations did not converge, and will likely output unclear and/or
    #           illogical results.. Either increase the max. number of iterations
    #           (max_iter) or decrease lambda for improved results.")
    # }

    # max_y <- max(max(individual_inferences_longer$value), max(mc_inferences_longer$value), max(aggregate_inferences_longer$value))
    # max_y <- (ceiling(max_y*1000))/1000
    # min_y <- min(min(individual_inferences_longer$value), min(mc_inferences_longer$value), min(aggregate_inferences_longer$value))
    # min_y <- (floor(min_y*1000))/1000
    #
    # individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
    # aggregate_inferences_longer$analysis_source <- "Agg FCM Inferences"
    # mc_inferences_longer$analysis_source <- "MC FCM Inferences"
    # mc_avg_inferences_longer$analysis_source <- "MC FCM Avg Inferences"
    # mc_inference_CIs$analysis_source <- "CIs of MC FCM Avg Inferences"

  # } else if (fcmconfr_object$fcm_class == "ivfn") {
  #   fcm_class_subtitle <- "IVFN FCM"
  #
  #   lower_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$lower_values, cols = 2:ncol(individual_inferences$lower_values), values_to = "lower", names_to = "node")
  #   upper_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$upper_values, cols = 2:ncol(individual_inferences$upper_values), values_to = "upper", names_to = "node")
  #   individual_inferences_longer <- merge(lower_individual_inferences_longer, upper_individual_inferences_longer)
  #   individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
  #   individual_inferences_longer$adj_matrix_index <- NULL
  #
  #   if (is.na(aggregate_inferences)) {
  #     aggregate_inferences <- data.frame("node" = individual_inferences_longer$node[1], "lower" = 0, "upper" = 0, "crisp" = 0)
  #   }
  #   aggregate_inferences_longer <- aggregate_inferences
  #
  #   mc_inferences_longer <- tidyr::pivot_longer(mc_inferences$inferences, cols = 2:ncol(mc_inferences$inferences), values_to = "value", names_to = "node")
  #   mc_inferences_longer$adj_matrix_index <- NULL
  #   mc_avg_inferences_longer <- tidyr::pivot_longer(mc_inferences$averages, cols = 1:ncol(mc_inferences$averages), values_to = "value", names_to = "node")
  #
  #   max_y <- max(max(individual_inferences_longer$upper), max(mc_inferences_longer$value), max(aggregate_inferences_longer$upper))
  #   max_y <- (ceiling(max_y*1000))/1000
  #   min_y <- min(min(individual_inferences_longer$lower), min(mc_inferences_longer$value), min(aggregate_inferences_longer$lower))
  #   min_y <- (floor(min_y*1000))/1000
  #
  #   aggregate_inferences_longer$analysis_source <- "Agg FCM Inferences"
  #   mc_inferences_longer$analysis_source <- "MC FCM Inferences"
  #   mc_avg_inferences_longer$analysis_source <- "MC FCM Avg Inferences"
  #   mc_inference_CIs$analysis_source <- "CIs of MC FCM Avg Inferences"
  # } else if (fcmconfr_object$fcm_class == "tfn") {
  #   fcm_class_subtitle <- "TFN FCM"
  #
  #   lower_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$lower_values, cols = 2:ncol(individual_inferences$lower_values), values_to = "lower", names_to = "node")
  #   mode_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$mode_values, cols = 2:ncol(individual_inferences$mode_values), values_to = "mode", names_to = "node")
  #   upper_individual_inferences_longer <- tidyr::pivot_longer(individual_inferences$upper_values, cols = 2:ncol(individual_inferences$upper_values), values_to = "upper", names_to = "node")
  #   individual_inferences_longer <- Reduce(function(x, y) merge(x, y, all=TRUE), list(lower_individual_inferences_longer, mode_individual_inferences_longer, upper_individual_inferences_longer))
  #   #individual_inferences_longer <- merge(lower_individual_inferences_longer, mode_individual_inferences_longer, upper_individual_inferences_longer, all = TRUE)
  #   individual_inferences_longer$analysis_source <- "Ind FCM Inferences"
  #   individual_inferences_longer$adj_matrix_index <- NULL
  #
  #   aggregate_inferences_longer <- aggregate_inferences
  #
  #   mc_inferences_longer <- tidyr::pivot_longer(mc_inferences$inferences, cols = 2:ncol(mc_inferences$inferences), values_to = "value", names_to = "node")
  #   mc_inferences_longer$adj_matrix_index <- NULL
  #   mc_avg_inferences_longer <- tidyr::pivot_longer(mc_inferences$averages, cols = 1:ncol(mc_inferences$averages), values_to = "value", names_to = "node")
  #
  #   max_y <- max(max(individual_inferences_longer$upper), max(mc_inferences_longer$value), max(aggregate_inferences_longer$upper), na.rm = TRUE)
  #   max_y <- (ceiling(max_y*1000))/1000
  #   min_y <- min(min(individual_inferences_longer$lower), min(mc_inferences_longer$value), min(aggregate_inferences_longer$lower), na.rm = TRUE)
  #   min_y <- (floor(min_y*1000))/1000
  #
  #   aggregate_inferences_longer$analysis_source <- "Agg FCM Inferences"
  #   mc_inferences_longer$analysis_source <- "MC FCM Inferences"
  #   mc_avg_inferences_longer$analysis_source <- "MC FCM Avg Inferences"
  #   mc_inference_CIs$analysis_source <- "CIs of MC FCM Avg Inferences"
  # }
}


#' Get Concepts in fcmconfr Object to Include in Plot
#'
#' @description
#' This determines which concepts should be included in fcmconfr output plot by
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
filter_concepts_to_plot <- function(fcmconfr_plot_data, filter_limit = 1e-10) {

  concepts <- unique(fcmconfr_plot_data$individual_inferences$node)

  individual_inferences_values <- fcmconfr_plot_data$individual_inferences[colnames(fcmconfr_plot_data$individual_inferences) != c("adj_matrix_index", "analysis_source")]
  aggregate_inferences_values <- fcmconfr_plot_data$aggregate_inferences[colnames(fcmconfr_plot_data$aggregate_inferences) != c("analysis_source")]
  mc_inferences_values <- fcmconfr_plot_data$mc_inferences[colnames(fcmconfr_plot_data$mc_inferences) != c("adj_matrix_index", "analysis_source")]
  mc_mean_inferences_values <- fcmconfr_plot_data$mc_mean_inferences[colnames(fcmconfr_plot_data$mc_mean_inferences) != "analysis_source"]
  mc_inference_CIs_values <- fcmconfr_plot_data$mc_inference_CIs[colnames(fcmconfr_plot_data$mc_inference_CIs) != "analysis_source"]

  longer_individual_inferences_values <- tidyr::pivot_longer(individual_inferences_values, cols = seq_along(individual_inferences_values)[-1])
  max_individual_inferences <- vapply(concepts, function(concept) max(longer_individual_inferences_values$value[longer_individual_inferences_values$node == concept]), FUN.VALUE = numeric(1))
  # min_individual_inferences <- vapply(concepts, function(concept) min(longer_individual_inferences_values$value[longer_individual_inferences_values$node == concept]), FUN.VALUE = numeric(1))

  longer_aggregate_inferences_values <- tidyr::pivot_longer(aggregate_inferences_values, cols = seq_along(aggregate_inferences_values)[-1])
  max_aggregate_inferences <- vapply(concepts, function(concept) max(longer_aggregate_inferences_values$value[longer_aggregate_inferences_values$node == concept]), FUN.VALUE = numeric(1))
  # min_aggregate_inferences <- vapply(concepts, function(concept) min(longer_aggregate_inferences_values$value[longer_aggregate_inferences_values$node == concept]), FUN.VALUE = numeric(1))

  max_mc_inferences <- vapply(concepts, function(concept) max(mc_inferences_values$value[mc_inferences_values$node == concept]), FUN.VALUE = numeric(1))
  # min_mc_inferences <- vapply(concepts, function(concept) min(mc_inferences_values$value[mc_inferences_values$node == concept]), FUN.VALUE = numeric(1))

  max_inferences_df <- rbind(max_individual_inferences, max_aggregate_inferences, max_mc_inferences)
  # min_inferences_df <- rbind(min_individual_inferences, min_aggregate_inferences, min_mc_inferences)

  surpasses_filter_limit <- apply(max_inferences_df, 2, function(x) any(x >= filter_limit))

  nodes_to_plot <- concepts[surpasses_filter_limit]
  fcmconfr_plot_data$nodes_to_plot <- nodes_to_plot
  # nodes_to_plot_indexes <- which(surpasses_filter_limit)

  fcmconfr_plot_data$individual_inferences <- fcmconfr_plot_data$individual_inferences[fcmconfr_plot_data$individual_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$aggregate_inferences <- fcmconfr_plot_data$aggregate_inferences[fcmconfr_plot_data$aggregate_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_inferences <- fcmconfr_plot_data$mc_inferences[fcmconfr_plot_data$mc_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_mean_inferences <- fcmconfr_plot_data$mc_mean_inferences[fcmconfr_plot_data$mc_mean_inferences$node %in% nodes_to_plot, ]
  fcmconfr_plot_data$mc_inference_CIs <- fcmconfr_plot_data$mc_inference_CIs[fcmconfr_plot_data$mc_inference_CIs$node %in% nodes_to_plot, ]

  return(structure(
    .Data = fcmconfr_plot_data,
    class = "filtered_fcmconfr_plot_data"
  ))

  # if (identical(fcmconfr_object$fcm_class, "conventional")) {
  #   fcmconfr_inferences = list(
  #     individual = fcmconfr_object$inferences$individual_fcms$inferences,
  #     agg = fcmconfr_object$inferences$aggregate_fcm$inferences,
  #     mc = fcmconfr_object$inferences$monte_carlo_fcms$inferences
  #   )
  # } else if (identical(fcmconfr_object$fcm_class, "ivfn")) {
  #   fcmconfr_inferences <- get_fcmconfr_inferences(fcmconfr_object)
  #   individual_inferences <- fcmconfr_inferences$individual_inferences
  #   agg_inferences_df <- fcmconfr_inferences$aggregate_inferences
  #   lower_agg_inference_values <- agg_inferences_df$lower
  #   names(lower_agg_inference_values) <- agg_inferences_df$concept
  #   upper_agg_inference_values <- agg_inferences_df$upper
  #   names(upper_agg_inference_values) <- agg_inferences_df$concept
  #   aggregate_inferences <- list(
  #     lower_inference_values = lower_agg_inference_values,
  #     upper_inference_values = upper_agg_inference_values
  #   )
  #   fcmconfr_inferences = list(
  #     lower_individual = individual_inferences$lower_values[, -1],
  #     upper_individual = individual_inferences$upper_values[, -1],
  #     lower_agg = aggregate_inferences$lower_inference_values,
  #     upper_agg = aggregate_inferences$upper_inference_values,
  #     mc = fcmconfr_inferences$mc_inferences
  #   )
  # } else if (identical(fcmconfr_object$fcm_class, "tfn")) {
  #   fcmconfr_inferences <- get_fcmconfr_inferences(fcmconfr_object)
  #   individual_inferences <- fcmconfr_inferences$individual_inferences
  #   agg_inferences_df <- fcmconfr_inferences$aggregate_inferences
  #   lower_agg_inference_values <- agg_inferences_df$lower
  #   names(lower_agg_inference_values) <- agg_inferences_df$concept
  #   mode_agg_inference_values <- agg_inferences_df$mode
  #   names(mode_agg_inference_values) <- agg_inferences_df$concept
  #   upper_agg_inference_values <- agg_inferences_df$upper
  #   names(upper_agg_inference_values) <- agg_inferences_df$concept
  #   aggregate_inferences <- list(
  #     lower_inference_values = lower_agg_inference_values,
  #     mode_inference_values = mode_agg_inference_values,
  #     upper_inference_values = upper_agg_inference_values
  #   )
  #   fcmconfr_inferences = list(
  #     lower_individual = individual_inferences$lower_values[, -1],
  #     mode_individual = individual_inferences$mode_values[, -1],
  #     upper_individual = individual_inferences$upper_values[, -1],
  #     lower_agg = aggregate_inferences$lower_values,
  #     mode_agg = aggregate_inferences$mode_values,
  #     upper_agg = aggregate_inferences$upper_values,
  #     mc = fcmconfr_inferences$mc_inferences
  #   )
  # }
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
#' @param interactive \[`logical(1)`]\cr If TRUE, launch plot in a Shiny app to
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
#' @param agg_inferences_alpha \[`double(1)` - Positive (between 0 and 1)]\cr
#' Transparency of the points representing inferences of the aggregate FCM.
#' Range from 0 to 1 (0: Transparent to 1: Opaque).
#' @param agg_inferences_shape \[`integer(1)` or `character(1)`]\cr Point shapes
#' of the points representing inferences of the aggregate FCM. Accepts PCH point
#' values and character strings. Ignored for IVFN FCMs.
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
                              interactive = FALSE,
                              # Plot Format Parameters
                              filter_limit = 1e-3,
                              xlim = NA, # c(lower_limit, upper_limit)
                              coord_flip = FALSE,
                              text_font_size = NA, # NA: let ggplot determine
                              # Plot Aesthetic Parameters
                              mc_avg_and_CIs_color = "blue",
                              mc_inferences_color = "blue",
                              mc_inferences_alpha = 0.3, # 0:transparent to 1:opaque
                              mc_inferences_shape = 3, # R PCH point shape values
                              ind_inferences_color = "black",
                              ind_inferences_alpha = 1, # 0:transparent to 1:opaque
                              ind_inferences_shape = 16, # R PCH point shape values
                              agg_inferences_color = "red",
                              agg_inferences_alpha = 1, # 0:transparent to 1:opaque
                              agg_inferences_shape = 17, # R PCH point shape values
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
  plot_data <- get_plot_data(object, filter_limit)
  plot_data <- filter_concepts_to_plot(plot_data, filter_limit)
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
  if (inputs_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_bs) {
    ggplot_main <- ggplot_main +
      ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_inference_CIs),
        # lower_CI col. index = 3
        # upper_CI col. index = 4
        aes(y = .data$node, xmin = plot_data$mc_inference_CIs[, 3], x = plot_data$mc_inference_CIs[, 3], xmax = plot_data$mc_inference_CIs[, 3], linewidth = .data$analysis_source),
        width = 0.7, color = mc_avg_and_CIs_color,
        na.rm = TRUE, key_glyph = ggplot2::draw_key_vline
      ) +
      ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_inference_CIs),
        # lower_CI col. index = 3
        # upper_CI col. index = 4
        aes(y = .data$node, xmin = plot_data$mc_inference_CIs[, 4], x = plot_data$mc_inference_CIs[, 4], xmax = plot_data$mc_inference_CIs[, 4], linewidth = .data$analysis_source),
        width = 0.7, color = mc_avg_and_CIs_color,
        na.rm = TRUE, key_glyph = ggplot2::draw_key_vline
      )
  }
  # ----

  # MC FCM Inferences ----
  if (inputs_agg_and_mc_no_bs | inputs_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_no_bs) {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$mc_inferences),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        position = ggplot2::position_dodge2(width = 0.25),
        # shape = 3,
        na.rm = FALSE
      ) +
      ggplot2::geom_crossbar(
        data = ggplot2::remove_missing(plot_data$mc_mean_inferences),
        aes(y = .data$node, xmin = .data$value, x = .data$value, xmax = .data$value),
        width = 0.9, linewidth = 0.1, color = mc_avg_and_CIs_color, na.rm = FALSE, key_glyph = ggplot2::draw_key_vline
      )
  }
  # ----

  # Individual FCM Inferences ----
  if (object$fcm_class == "conventional") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$individual_inferences),
        position = ggplot2::position_dodge2(width = 0.1),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        size = 2, na.rm = TRUE
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
        position = ggplot2::position_dodge2(width = 0.5), fatten = 0.6, linewidth = ind_ivfn_and_tfn_linewidth
      )
  }
  # ----

  # Aggregate FCM Inferences ----
  if (has_agg_calcs && object$fcm_class == "conventional") {
    ggplot_main <- ggplot_main +
      ggplot2::geom_point(
        data = ggplot2::remove_missing(plot_data$aggregate_inferences),
        aes(y = .data$node, x = .data$value, color = .data$analysis_source, alpha = .data$analysis_source, shape = .data$analysis_source),
        size = 2,
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
        fatten = 2, linewidth = agg_ivfn_and_tfn_linewidth
      )
  }
  # ----

  # Setup Legend Scales ----
  scale_color_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_color")
  scale_alpha_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_alpha")
  scale_shape_manual_values_str <- paste0("c('Ind FCM Inferences' = ind_inferences_shape")
  scale_shape_manual_override_str <- paste0("c(ind_inferences_shape")
  scale_linewidth_maual_values_str <- paste0("c('Ind FCM Inferences' = ind_ivfn_and_tfn_linewidth")
  scale_breaks_values_str <- paste0("c('Ind FCM Inferences'")
  if (!inputs_only & !(inputs_no_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_no_bs)) {
    scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_color")
    scale_alpha_manual_values_str <- paste0(scale_alpha_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_alpha")
    scale_shape_manual_values_str <- paste0(scale_shape_manual_values_str, ", 'Agg FCM Inferences' = agg_inferences_shape")
    scale_shape_manual_override_str <- paste0(scale_shape_manual_override_str, ", agg_inferences_shape")
    scale_linewidth_maual_values_str <- paste0(scale_linewidth_maual_values_str, ", 'Agg FCM Inferences' = ind_ivfn_and_tfn_linewidth")
    scale_breaks_values_str <- paste0(scale_breaks_values_str, ", 'Agg FCM Inferences'")
  }
  if (inputs_agg_and_mc_no_bs | inputs_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_bs | inputs_no_agg_and_mc_w_no_bs) {
    scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_color")
    scale_alpha_manual_values_str <- paste0(scale_alpha_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_alpha")
    scale_shape_manual_values_str <- paste0(scale_shape_manual_values_str, ", 'MC FCM Inferences' = mc_inferences_shape")
    scale_shape_manual_override_str <- paste0(scale_shape_manual_override_str, ", mc_inferences_shape")
    scale_linewidth_maual_values_str <- paste0(scale_linewidth_maual_values_str, ", 'MC FCM Inferences' = NA")
    scale_breaks_values_str <- paste0(scale_breaks_values_str, ", 'MC FCM Inferences'")
  }
  scale_color_manual_values_str <- paste0(scale_color_manual_values_str, ")")
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
          values = c('CIs of MC FCM Avg Inferences' = 0.1),
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
              alpha = ", scale_alpha_manual_values_str, ",
              shape = ", scale_shape_manual_override_str, ",
              linewidth = ", scale_linewidth_maual_values_str, "
          ), order = 1)
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
          values = c('CIs of MC FCM Avg Inferences' = 0.1),
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
              alpha = ", scale_alpha_manual_values_str, ",
              shape = ", scale_shape_manual_override_str, ",
              linewidth = ", scale_linewidth_maual_values_str, "
          ), order = 1)
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
          values = c('CIs of MC FCM Avg Inferences' = 0.1),
          guide = ggplot2::guide_legend(order = 2)
        )"
    )
  }

  scales_expr <- parse(text = scales_str)
  ggplot_main <- eval(scales_expr)

  if (!all(is.na(xlim))) {
    ggplot_main <- ggplot_main +
      ggplot2::xlim(xlim[1], xlim[2])
  }

  # ----

  if (!coord_flip) {
    fcmconfr_plot <- ggplot_main + fcmconfr_default_theme()
  } else {
    fcmconfr_plot <- ggplot_main + fcmconfr_default_theme() + ggplot2::coord_flip()
  }

  if (!is.na(text_font_size)) {
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
      legend.title = ggplot2::element_blank(),
      legend.justification = "center",
      legend.spacing = ggplot2::unit(0.001, 'cm')
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

