#' shiny_ui
#'
#' @description
#' ui for plot.fcmconfr
#'
shiny_iplot_ui <- function() {
  bslib::page_sidebar(
    title = "FCMConfR Plot (Interactive)",
    sidebar = bslib::sidebar(
      width = "300px",
      shiny::uiOutput("inferences_to_plot"),
      shiny::uiOutput("plot_font_size_numeric_input"),
      shiny::uiOutput("plot_x_lims"),
      shiny::uiOutput("concepts_to_plot")
    ),
    shiny::fluidPage(
      shiny::plotOutput("fcmconfr_plot_output", height = "600px")
    )
  )
}
