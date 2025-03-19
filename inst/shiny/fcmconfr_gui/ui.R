#' shiny_ui
#'
#' @description
#' [ADD DETAILS HERE!!!]
#'
shiny_ui <- function() {
  bslib::page_sidebar(
    title = "fcmconfr GUI",
    sidebar = bslib::sidebar(
      title = "Definitions", position = "right", open = FALSE, width = "350px",
      shiny::uiOutput("definitions")
    ),
    bslib::navset_underline(
      id = "nav_panel",
      bslib::nav_panel(
        title = "Data", icon = shiny::icon("laptop-file"), # ----
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:20px"))
        ),
        shiny::fluidRow(
          shiny::selectInput("adj_matrices", "Adj. Matrix or List of Adj. Matrices", choices = c(names(as.list(.GlobalEnv)), ""), selected = "")
        ),
        shiny::uiOutput("rejected_adj_matrices_note"),
        bslib::navset_underline(
          bslib::nav_panel(
            title = "Initial State (Pulse) Vector", icon = shiny::icon("wave-square"),
            shiny::uiOutput("initial_state_vector_input_ui")
          ),
          bslib::nav_panel(
            title = "Clamping Vector", icon = shiny::icon("grip-lines"),
            shiny::uiOutput("clamping_vector_input_ui")
          )
        )
      ), # ----
      bslib::nav_panel(
        title = "Agg. and Monte Carlo Options", icon = shiny::icon("layer-group"), # ----
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:20px"))
        ),
        shiny::uiOutput("include_zero_edges_ui"),
        bslib::card(
          id = "aggregation_options",
          shiny::fluidRow(
            shiny::column(
              width = 8, align = "left",
              shiny::HTML('<p><i class="fas fa-user-group" role="presentation" aria-label="user-group icon"></i>       Aggregation Options</p>')
            ),
            shiny::column(
              width = 4, align = "right",
              shiny::checkboxInput("perform_aggregation", "Aggregation Analaysis", value = TRUE),
            )
          ),
          shiny::uiOutput("aggregation_options_ui")
        ),
        bslib::card(
          id = "monte_carlo_options",
          shiny::fluidRow(
            shiny::column(
              width = 8, align = "left",
              shiny::HTML('<p><i class="fa-solid fa-seedling"></i>       Monte Carlo Options</p>')
            ),
            shiny::column(
              width = 4, align = "right",
              shiny::checkboxInput("perform_monte_carlo", "Monte Carlo Analysis", value = TRUE)
            )
          ),
          shiny::uiOutput("monte_carlo_options_ui")
        ),
        bslib::card(
          id = "inference_bootstrap_options",
          shiny::fluidRow(
            shiny::column(
              width = 8, align = "left",
              shiny::HTML('<p><i class="fa-solid fa-seedling"></i>       Monte Carlo Inference Bootstrapping Options</p>')
            ),
            shiny::column(
              width = 4, align = "right",
              shiny::checkboxInput("perform_inference_bootstrap", "Inference Bootstrap Analysis", value = TRUE)
            )
          ),
          shiny::uiOutput("monte_carlo_inference_bootstrap_options_ui")
        )
      ), # ----
      bslib::nav_panel(
        title = "Simulation Options", icon = shiny::icon("calculator"), # ----
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:20px"))
        ),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5("Activation Function", style = "padding: 35px;")
          ),
          shiny::column(
            width = 7, align = "left",
            shinyWidgets::radioGroupButtons("activation", "", choiceValues = c("kosko", "modified-kosko", "rescale"), choiceNames = c("Kosko", "Modified-Kosko", "Rescale"))
          )
        ),
        shiny::uiOutput("activation_function_formulae"),
        shiny::uiOutput("tanh_warning_text"),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5("Squashing Function", style = "padding: 35px;")
          ),
          shiny::column(
            width = 7, align = "left",
            shinyWidgets::radioGroupButtons("squashing", "",choiceNames = c("Sigmoid", "Tanh"),  choiceValues = c("sigmoid", "tanh"), selected = "sigmoid")
          )
        ),
        shiny::uiOutput("squashing_function_formulae"),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5(paste0("Lambda (", "\U03BB", ")"), style = "padding: 28px;")
          ),
          shiny::column(
            width = 3, align = "left",
            shiny::numericInput("lambda", "", 1, min = 1, max = 10, step = 0.05)
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5("Point of Inference", style = "padding: 28px;")
          ),
          shiny::column(
            width = 3, align = "left",
            shinyWidgets::radioGroupButtons("point_of_inference", "", choiceNames = c("Peak", "Final"), choiceValues = c("peak", "final"), selected = "final")
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5(paste0("Max # of Iterations per Sim"), style = "padding: 28px;")
          ),
          shiny::column(
            width = 3, align = "left",
            shiny::numericInput("max_iter", "", 100, min = 1, step = 1)
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5(paste0("Min Acceptable Error per Step"), style = "padding: 28px;")
          ),
          shiny::column(
            width = 3, align = "left",
            shiny::numericInput("min_error", "", 1e-5, min = 0, max = 1)
          )
        )
      ), # ----
      bslib::nav_panel(
        title = "Runtime Options", icon = shiny::icon("clock"), # ----
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:20px"))
        ),shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5("Use Parallel Processing", style = "padding: 35px;")
          ),
          shiny::column(
            width = 7, align = "left",
            shinyWidgets::radioGroupButtons("parallel", "", choiceNames = c("Yes", "No"), choiceValues = c(TRUE, FALSE))
          )
        ),
        shiny::uiOutput("num_cores_in_paralell"),
        shiny::fluidRow(
          shiny::column(
            width = 5, align = "right",
            shiny::h5("Show Progress at Runtime", style = "padding: 35px;")
          ),
          shiny::column(
            width = 7, align = "left",
            shinyWidgets::radioGroupButtons("show_progress", "", choiceNames = c("Yes", "No"), choiceValues = c(TRUE, FALSE), selected = TRUE)
          )
        )
      ), # ----
      footer = shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:20px"))
        ),
        bslib::card(
          shiny::fluidRow(
            shiny::actionButton(
              "get_code", "Get Code!", icon = shiny::icon("code")
            ),
            shiny::verbatimTextOutput("fcmconfr_code_snippet")
          )
        ),
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:px"))
        ),
        shiny::fluidRow(
          shiny::column(width = 8),
          shiny::column(
            width = 4,
            bslib::card(
              shiny::actionButton(
                "close_app", "Close App", icon = shiny::icon("arrow-right-to-bracket")
              )
            )
          )
        )
      )
    )
  )
}
