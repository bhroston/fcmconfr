
################################################################################
# plot.fcmconfr.R
#
# This function plots fcmconfr output objects
#
#   - plot.fcmconfr
#
################################################################################

#' Plot fcmconfr
#'
#' @description
#' This plots the output of fcmconfr() using ggplot. Set interactive = TRUE to
#' load plot in a Shiny app and toggle on/off results from different analyses.
#'
#' @details
#' Generates a generic plot visualizing \code{\link{fcmconfr}} results. Call the
#' function name directly (\code{\link{autoplot.fcmconfr}})) without parentheses
#' to see the exact code to generate the plots, then copy-and-paste and edit
#' as needed.
#'
#' @param x A direct output of the \code{\link{fcmconfr}} function
#' @param interactive TRUE/FALSE Launch plot in a Shiny app to toggle on/off
#' results from different analyses
#' @param filter_limit Only nodes with inferences above the filter_limit
#' across any analysis will be plotted. This removes nodes with mostly 0-valued
#' inferences indicating they were not impacted in the simulation.
#' @param xlim The x-axis plot limits. xlim = NA lets ggplot determine the
#' x-axis limits. xlim = c(lower_limit, upper_limit) for manual input limits.
#' See ?ggplot2::xlim for additional info.
#' @param coord_flip Swap x- and y-axes (i.e. rotate plot). See
#' ?ggplot2::coord_flip for additional info.
#' @param text_font_size The font size of axis labels. text_font_size = NA lets
#' ggplot determine the axis label font size.
#' @param mc_avg_and_CIs_color Color of the crossbar (lines) indicating the
#' avg inferences of empirical FCMs generated via Monte Carlo sampling and the
#' confidence intervals about those averages.
#' @param mc_inferences_color Color of the points representing inferences of
#' empirical FCMs generated via Monte Carlo sampling
#' @param mc_inferences_alpha Transparency of the points representing inferences
#' of empirical FCMs generated via Monte Carlo sampling. Range from 0 to 1
#' (0: Transparent to 1: Opaque).
#' @param mc_inferences_shape Point shapes of the points representing inferences
#' of empirical FCMs generated via Monte Carlo sampling. Accepts PCH point
#' values and character strings.
#' @param ind_inferences_color Color of the points representing inferences of
#' individual FCMs
#' @param ind_inferences_alpha Transparency of the points representing
#' inferences of individual FCMs. Range from 0 to 1 (0: Transparent to
#' 1: Opaque).
#' @param ind_inferences_shape Point shapes of the points representing
#' inferences of individual FCMs. Accepts PCH point values and character
#' strings. Ignored for IVFN FCMs.
#' @param agg_inferences_color Color of the points representing inferences of
#' the aggregate FCM
#' @param agg_inferences_alpha Transparency of the points representing
#' inferences of the aggregate FCM. Range from 0 to 1 (0: Transparent to
#' 1: Opaque).
#' @param agg_inferences_shape Point shapes of the points representing
#' inferences of the aggregate FCM. Accepts PCH point values and character
#' strings. Ignored for IVFN FCMs.
#' @param ind_ivfn_and_tfn_linewidth Linewidth of lines representing
#' inferences for analyses of individual IVFN- and TFN- FCMs.
#' @param agg_ivfn_and_tfn_linewidth Linewidth of lines representing inferences
#' for analyses of aggregate IVFN- and TFN- FCMs
#' @param ... Additional inputs
#'
#' @importFrom graphics plot
#' @importFrom cli format_warning
#'
#' @returns A plot of an fcmconfr object's results
#'
#' @export
#' @example man/examples/ex-plot_fcmconfr.R
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

  additional_inputs = list(...)
  if (length(additional_inputs) > 0) {
    warning(cli::format_warning(c(
      "!" = "Warning: Additional Inputs given as ... are ignored",
      "~~~~~ Ignoring additional inputs: {names(additional_inputs)}"
    )))
  }

  check_plot_fcmconfr_inputs(
    interactive,
    filter_limit, xlim, coord_flip, text_font_size,
    mc_avg_and_CIs_color,
    mc_inferences_color, mc_inferences_alpha, mc_inferences_shape,
    ind_inferences_color, ind_inferences_alpha, ind_inferences_shape,
    agg_inferences_color, agg_inferences_alpha, agg_inferences_shape,
    ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
  )

  if (!interactive) {
    suppressWarnings(print(
      autoplot(
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
        filter_limit, xlim, coord_flip, text_font_size,
        mc_avg_and_CIs_color,
        mc_inferences_color, mc_inferences_alpha, mc_inferences_shape,
        ind_inferences_color, ind_inferences_alpha, ind_inferences_shape,
        agg_inferences_color, agg_inferences_alpha, agg_inferences_shape,
        ind_ivfn_and_tfn_linewidth, agg_ivfn_and_tfn_linewidth
      )
    )
  }
}


