#' shiny_server
#'
#' @description
#' Backend for the fcmconfr_gui shinyapp
#'
#' @param input the data streamed into the server from the ui
#' @param output the data streamed from to the ui from the server
#' @param session data surrounding the shiny instance itself
shiny_server <- function(input, output, session) {

  # Definitions Sidebar ----
  output$definitions <- shiny::renderUI(
    if (input$nav_panel == "Data") {
      shiny::fluidRow(
        shiny::HTML("<p><small><b>Initial State Vector:</b> A list of state values
        (one per node) at the start of an FCM simulation. In pulse simulations the
        initial_state_vector controls the scenario (i.e., a non-zero value is a
        transient perturbation). In clamped simulations all values in the
        initial_state_vector are set to 1.</small>
        <br><br>
        <small><b>Clamping Vector:</b> A list of values (one per node) that
        indicates whether clamped simulations will be performed. In clamped
        simulations the clamping_vector controls the scenario (nodes
        assigned non-zero values will remain at those values for the entire
        simulation). In pulse simulations all values in the clamping_vector
        are set to 0.</small></p>")
      )
    } else if (input$nav_panel == "Agg. and Monte Carlo Options") {
      shiny::fluidRow(
        shiny::HTML("<p><small><b>Include 0-Weighted Edges:</b> Only applicable
        when FCMs are aggregated. If TRUE, incorporate zeroes as
        intentionally-defined edge weights or ignore them when aggregating
        adjacency matrices and sampling for Monte Carlo FCMs.</small></p>
        <br>"),
        shiny::h4("Aggregation Options"),
        shiny::HTML("<p><small><b>Aggregation Analysis:</b> Aggregate input
        adjacency matrices into a single, collective adjacency matrix.</small></p>
        <br>
        <small><b>Aggregation Function:</b> Aggregate the adj. matrices into a
        single FCM by taking either the mean or median of the edge weights for
        edges included in multiple maps.
        </small></p>
        <br>"),
        shiny::h4("Monte Carlo Options"),
        shiny::HTML("<small><b>Monte Carlo Analysis:</b> Generate N simulations
        from N adjacency matrices created via Monte Carlo sampling of input
        adjacency matrices.</small></p>
        <small><b># Sample Maps to Generate:</b> The number of inferences to
        generate via Monte Carlo sampling. Omit this argument when analyzing a
        single, conventional FCM.</small></p>
        <small><b>Inference Bootstrap Analysis:</b> Estimate confidence bounds
        about Monte Carlo simulation outputs for each modeled concept
        </small></p>
        <small><b>Inference Estimation Function:</b> Estimate confidence
        intervals about the 'mean' or 'median' of inferences from Monte Carlo
        simulations.</small></p>
        <small><b>Inference Confidence Interval:</b> Bootstrapped confidence
        level</small></p>
        <small><b># Bootstraps:</b> Number of bootstrap draws </small></p>
        <br></>")
      )
    } else if (input$nav_panel == "Simulation Options") {
      shiny::fluidRow(
        shiny::fluidRow(
          shiny::HTML("<p><small><b>Activation Function</b> The activation
          function to be applied.</small></p>
          <small><b>Squashing Function:</b> The squashing (also known as
          transformation or threshold) function to apply </small></p>
          <small><b>Lambda:</b> A numeric value that defines the steepness of
          the slope of the squashing function when tanh or sigmoid are
          applied</small></p>
          <small><b>Point of Inference:</b> The point along the simulation
          time-series to be identified as the inference</small></p>
          <small><b>Max Iterations per Sim:</b> The maximum number of iterations
          to run if the minimum error value is not achieved</small></p>
          <small><b>Min. Acceptable Error:</b> The lowest error (sum of the
          absolute value of the current state vector minus the previous state
          vector) at which no more iterations are necessary and the simulation
          will stop</small></p>")
        )
      )
    } else if (input$nav_panel == "Runtime Options") {
      shiny::fluidRow(
        shiny::fluidRow(
          shiny::HTML("<p><small>These options only influence runtime
          performance and do NOT impact results.</small></p>")
        )
      )
    }
  )
  # ----

  # Data Nav Panel
  # Data Loading and Checks ====
  adj_matrices <- shiny::reactive({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = "none_selected")
    )

    adj_matrices_input <- as.list(.GlobalEnv)[names(as.list(.GlobalEnv)) == input$adj_matrices][[1]]
    if (!is.null(dim(adj_matrices_input))) {
      adj_matrices_input <- list(adj_matrices_input)
    }

    square_adj_matrix_checks <- lapply(
      adj_matrices_input,
      function(adj_matrix) {
        tryCatch({
          check_fcmconfr_input(adj_matrix,  check = "square_adj_matrix", var_name = "adj_matrices_input")
        }, error = function(e) {
          error_message <- gsub(".*m ", "<p>", e$message)
          error_message <- gsub("\033.*", "</p>", error_message)
          error_message <- gsub("+++++>", "", error_message, fixed = TRUE)
          error_message <- gsub("\n", "<br><br>", error_message)

          adj_matrices_input <- list(data.frame(0))

          shinyWidgets::show_alert(
            title = "Unable to load data",
            text = shiny::HTML(error_message),
            type = "error",
            html = TRUE
          )
        })
      }
    )

    if (any(unlist(Map(is.null, square_adj_matrix_checks))) || !(all(unlist(square_adj_matrix_checks)))) {
      adj_matrices_input <- list(data.frame(0))
    } else {
      tryCatch({
        try(check_fcmconfr_input(adj_matrices_input, check = "adj_matrix_list", var_name = "adj_matrices_input"))
      }, error = function(e) {
        error_message <- gsub(".*m ", "<p>", e$message)
        error_message <- gsub("\033.*", "</p>", error_message)
        error_message <- gsub("+++++>", "", error_message, fixed = TRUE)
        error_message <- gsub("\n", "<br><br>", error_message)

        adj_matrices_input <- list(data.frame(0))
        shinyWidgets::show_alert(
          title = "Unable to load data",
          text = shiny::HTML(error_message),
          type = "error",
          html = TRUE
        )
      })
    }

    return(adj_matrices_input)
  })

  concepts <- shiny::reactive({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )
    concepts <- unique(lapply(adj_matrices(), colnames))[[1]]
    concepts <- vapply(concepts, function(concept) gsub(":", ".", concept), character(1))
    return(concepts)
  })

  fcm_class <- shiny::reactive({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )
    fcm_class <- get_fcm_class_from_adj_matrix(adj_matrices()[[1]])
    return(fcm_class)
  })

  # ====

  # Initial State Vector ====
  output$initial_state_vector_numeric_inputs <- shiny::renderUI({
    shiny::fluidRow(
      lapply(
        concepts(),
        function(concept) {
          shiny::fluidRow(
            shiny::column(width = 3, shiny::numericInput(paste0('initial_state_', concept), label = '', value = 1, min = -1, max = 1, step = 1)),
            shiny::column(width = 9, align = "left", shiny::p(concept, style = "padding-top:25px;"))
          )
        }
      )
    )
  })

  initial_state_vector <- reactive({
    initial_state_vector_input_vars <- paste0("initial_state_", concepts())
    unlist(lapply(initial_state_vector_input_vars, function(i) input[[i]][[1]]))
  })

  output$initial_state_vector_table <- shiny::renderTable({
    data.frame(
      cbind(
        "Concept" = concepts(),
        "Value" = initial_state_vector()
      )
    )
  }, align = "l", spacing = "xs")

  output$initial_state_vector_input_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    shiny::fluidRow(
      shiny::column(
        width = 12, div(style = "height:20px")
      )
    )
    shiny::fluidRow(
      shiny::column(
        width = 6, align = "center",
        bslib::card(
          max_height = "450px", full_screen = TRUE,
          shiny::uiOutput("initial_state_vector_numeric_inputs")
        )
      ),
      shiny::column(
        width = 6, align = "center",
        bslib::card(
          max_height = "450px", full_screen = TRUE,
          shiny::tableOutput("initial_state_vector_table")
        ),
        bslib::card(
          shiny::actionButton("reset_initial_state_vector", "Reset", icon = shiny::icon("rotate-right"))
        )
      )
    )
  })

  shiny::observeEvent(input$reset_initial_state_vector, {
    lapply(paste0("initial_state_", concepts()), function(i) shiny::updateNumericInput(session, i, value = 1))
  })
  # ====

  # Clamping Vector ====
  output$clamping_vector_numeric_inputs <- shiny::renderUI({
    shiny::fluidPage(
      lapply(
        concepts(),
        function(concept) {
          shiny::fluidRow(
            shiny::column(width = 3, shiny::numericInput(paste0('clamping_', concept), label = '', value = 0, min = -1, max = 1, step = 1)),
            shiny::column(width = 9, align = "left", shiny::p(concept, style = "padding-top:25px;"))
          )
        }
      )
    )
  })

  clamping_vector <- reactive({
    clamping_vector_input_vars <- paste0("clamping_", concepts())
    unlist(lapply(clamping_vector_input_vars, function(i) input[[i]][[1]]))
  })

  output$clamping_vector_table <- shiny::renderTable({
    data.frame(
      cbind(
        "Concept" = concepts(),
        "Value" = clamping_vector()
      )
    )
  }, align = "l", spacing = "xs")

  output$clamping_vector_input_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    shiny::fluidRow(
      shiny::column(
        width = 12, div(style = "height:20px")
      )
    )
    shiny::fluidRow(
      shiny::column(
        width = 6, align = "center",
        bslib::card(
          max_height = "450px", full_screen = TRUE,
          shiny::uiOutput("clamping_vector_numeric_inputs")
        )
      ),
      shiny::column(
        width = 6, align = "center",
        bslib::card(
          max_height = "450px", full_screen = TRUE,
          shiny::tableOutput("clamping_vector_table")
        ),
        bslib::card(
          shiny::actionButton("reset_clamping_vector", "Reset", icon = shiny::icon("rotate-right"))
        )
      )
    )
  })

  shiny::observeEvent(input$reset_clamping_vector, {
    lapply(paste0("clamping_", concepts()), function(i) shiny::updateNumericInput(session, i, value = 0))
  })
  # ====

  # # Aggregation and Monte Carlo Panel
  # Aggregation Card ----
  can_perform_aggregation_analysis <- shiny::reactive({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if (length(adj_matrices()) == 1 & !identical(fcm_class(), "conventional")) {
      return(FALSE)
    } else if (length(adj_matrices()) == 1 & identical(fcm_class(), "conventional")) {
      return(FALSE)
    } else {
      return(TRUE)
    }
  })

  perform_aggregation_analysis <- shiny::reactive({
    if (is.null(input$perform_aggregation)) {
      FALSE
    } else {
      input$perform_aggregation
    }
  })

  output$aggregation_options_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if ((can_perform_aggregation_analysis() & perform_aggregation_analysis())) {
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::fluidRow(
            shiny::column(
              width = 6, align = "right",
              shiny::h5("Aggregation Function", style = "padding-top:35px;")
            ),
            shiny::column(
              width = 6, align = "left",
              shiny::radioButtons("aggregation_fun", "", choiceNames = c("Mean", "Median"), choiceValues = c("mean", "median"))
            )
          )
        )
      )
    } else if (!can_perform_aggregation_analysis()) {
      shiny::fluidRow(
        shiny::p("Aggregation analysis unavailable")
      )
    } else {
      NULL
    }
  })

  shiny::observe({
    if (!can_perform_aggregation_analysis()) {
      shiny::updateCheckboxInput(session, "perform_aggregation", value = FALSE)
    }
  })

  shiny::observeEvent(input$perform_aggregation, {
    if (!can_perform_aggregation_analysis()) {
      shiny::updateCheckboxInput(session, "perform_aggregation", value = FALSE)
    }
  })

  shiny::observeEvent(can_perform_aggregation_analysis(), {
    if (can_perform_aggregation_analysis()) {
      shiny::updateCheckboxInput(session, "perform_aggregation", value = TRUE)
    }
  })
  # ----

  # # Simulation Panel
  # Estimate Lambda Button ----
  output$lambda_selection <- shiny::renderUI({
    shiny::fluidRow(
      shiny::column(
        width = 5, align = "right",
        shiny::h5(paste0("Lambda (", "\U03BB", ")"), style = "padding: 28px;")
      ),
      shiny::column(
        width = 3, align = "left",
        shiny::numericInput("lambda", "", value = 1, min = 1e-10, max = 10, step = 0.05)
      ),
      shiny::column(
        width = 3, aligh = "right",
        shiny::fluidRow(
          shiny::column(width = 12, div(style = "height:23px"))
        ),
        shiny::actionButton("estimate_lambda_button", label = "Estimate Lambda", style = "padding: 8px; font-size:80%")
      )
    )
  })

  shiny::observeEvent(input$estimate_lambda_button, {
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    shiny::showModal(shiny::modalDialog(
      align = "center",
      shiny::HTML("<font size='6'>Calculating Lambda Estimate</font><br><br><font size='3'>Click Outside This Box To Close</font>"),
      footer = NULL, easyClose = TRUE)
    )

    lambda_estimates <- lapply(
      adj_matrices(), function(adj_matrix) estimate_fcm_lambda(adj_matrix, squashing = input$squashing)
    )

    lambda_estimate_value <- min(unlist(lambda_estimates))

    shiny::updateNumericInput(
      session, "lambda", value = round(lambda_estimate_value, 4)
    )

    shiny::removeModal(session)
  })
  # ----

  # Monte Carlo Card ----
  can_perform_monte_carlo_analysis <- shiny::reactive({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if (length(adj_matrices()) == 1 & fcm_class() == "conventional") {
      return(FALSE)
    } else {
      return(TRUE)
    }
  })

  perform_monte_carlo_analysis <- shiny::reactive({
    if (is.null(input$perform_monte_carlo)) {
      FALSE
    } else {
      input$perform_monte_carlo
    }
  })

  output$monte_carlo_options_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if ((can_perform_monte_carlo_analysis() & perform_monte_carlo_analysis())) {
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(
            width = 6, align = "right", style = "padding-top:28px;",
            shiny::h5("# Sample Maps To Generate")
          ),
          shiny::column(
            width = 6, align = "left",
            shiny::numericInput("num_mc_fcms", "", value = 1000, min = 1, step = 100)
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 6, align = "right",
            shiny::h5("Include MC Sims in Output?")
          ),
          shiny::column(
            width = 6, align = "left",
            shiny::checkboxInput("include_sims_in_output", "", value = TRUE)
          )
        )
      )
    } else if (!can_perform_monte_carlo_analysis()) {
      shiny::fluidRow(
        shiny::p("Monte Carlo analysis unavailable")
      )
    } else {
      NULL
    }
  })

  shiny::observe({
    if (!can_perform_monte_carlo_analysis()) {
      shiny::updateCheckboxInput(session, "perform_monte_carlo", value = FALSE)
    }
  })

  shiny::observeEvent(input$perform_monte_carlo, {
    if (!can_perform_monte_carlo_analysis()) {
      shiny::updateCheckboxInput(session, "perform_monte_carlo", value = FALSE)
    }
  })

  shiny::observeEvent(can_perform_monte_carlo_analysis(), {
    if (can_perform_monte_carlo_analysis()) {
      shiny::updateCheckboxInput(session, "perform_monte_carlo", value = TRUE)
    }
  })




  # # Inference Bootstrap Card ----
  can_perform_inference_bootstrap_analysis <- shiny::reactive({
    if (perform_monte_carlo_analysis()) {
      TRUE
    } else {
      FALSE
    }
  })

  perform_inference_bootstrap_analysis <- shiny::reactive({
    if (is.null(input$perform_inference_bootstrap)) {
      FALSE
    } else {
      input$perform_inference_bootstrap
    }
  })

  output$monte_carlo_inference_bootstrap_options_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if ((can_perform_inference_bootstrap_analysis() & perform_inference_bootstrap_analysis())) {
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(
            width = 6, align = "right",
            shiny::h5("Estimate Confidence Interval about the Mean or Median of MC Inferences?", style = "padding: 15px;")
          ),
          shiny::column(
            width = 6, align = "left",
            shiny::radioButtons("ci_centering_function", "", choiceNames = c("Mean", "Median"), choiceValues = c("mean", "median"))
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 6, align = "right",
            shiny::h5("Confidence Interval about the Mean/Median of Inferences", style = "padding: 20px;")
          ),
          shiny::column(
            width = 6, align = "left",
            shiny::numericInput("confidence_interval", "", value = 0.95, min = 1e-10, max = 1)
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 6, align = "right",
            shiny::h5("# Bootstraps", style = "padding: 25px;")
          ),
          shiny::column(
            width = 6, align = "left",
            shiny::numericInput("num_ci_bootstraps", "", value = 1000, min = 100, step = 100)
          )
        )
      )
    } else if (!can_perform_monte_carlo_analysis()) {
      shiny::fluidRow(
        shiny::p("Monte Carlo Inference Bootstrap analysis unavailable")
      )
    } else {
      NULL
    }
  })

  shiny::observe({
    if (!can_perform_inference_bootstrap_analysis()) {
      shiny::updateCheckboxInput(session, "perform_inference_bootstrap", value = FALSE)
    }
  })

  shiny::observeEvent(input$perform_inference_bootstrap, {
    if (!can_perform_inference_bootstrap_analysis()) {
      shiny::updateCheckboxInput(session, "perform_inference_bootstrap", value = FALSE)
    }
  })

  shiny::observeEvent(can_perform_inference_bootstrap_analysis(), {
    if (can_perform_inference_bootstrap_analysis()) {
      shiny::updateCheckboxInput(session, "perform_inference_bootstrap", value = TRUE)
    }
  })

  #----

  # Include 0's Option ----
  output$include_zero_edges_ui <- shiny::renderUI({
    shiny::validate(
      shiny::need(input$adj_matrices != "", message = FALSE)
    )

    if ((perform_monte_carlo_analysis() | perform_aggregation_analysis())) {
      bslib::card(
        shiny::fluidRow(
          shiny::column(
            width = 2, align = "center",
            shiny::checkboxInput("include_zeroes_in_sampling", "", value = TRUE)
          ),
          shiny::column(
            width = 10, align = "left",
            shiny::p("Include 0-weighted Edges in Aggregation and Monte Carlo Sampling?")
          )
        )
      )
    }
  })
  # ----

  # Activation and Squashing Functions Formulae ----
  output$activation_function_formulae <- shiny::renderUI({
    if (input$activation == "kosko") {
      formula <- "$$
        \\begin{gather}
          A_{i}^{( t+1)} =f\\left(\\sum _{ \\begin{array}{l}
          j\ =\\ i\\
          i\ \\neq \ j
          \\end{array}}^{M} w_{ji} A_{j}^{( t)}\\right)
        \\end{gather}
      $$"
    } else if (input$activation == "modified-kosko") {
      formula <- "$$
        \\begin{gather}
          A_{i}^{( t+1)} =f\\left(\\sum _{ \\begin{array}{l}
          j\\ =\\ i\\\
          i\\ \\neq \\ j
          \\end{array}}^{M} w_{ji} A_{j}^{( t)} +A_{i}^{( t)}\\right)
        \\end{gather}
      $$"
    } else if (input$activation == "rescale") {
      formula <- "$$
        \\begin{gather}
          A_{i}^{( t+1)} =f\\left(\\sum _{ \\begin{array}{l}
          j\\ =\\ i\\\
          i\\ \\neq \\ j
          \\end{array}}^{M} w_{ji}\\left( 2A_{j}^{( t)} -1\\right) +\\left( 2A_{i}^{( t)} -1\\right)\\right)
        \\end{gather}
      $$"
    }
    shiny::fluidRow(
      shiny::column(
        width = 12, align = "center",
        shiny::withMathJax(tags$p(formula))
      )
    )
  })

  # Warn users about using tanh with rescale activation
  output$tanh_warning_text <- shiny::renderUI({
    if (input$activation == "rescale" & input$squashing == "tanh") {
      shiny::fluidRow(
        shiny::column(
          width = 12, align = "center",
          shiny::p("WARNING: The Rescale activation function is designed to work with
                   the sigmoid squashing function only!"),
          shiny::p("Using tanh will produce illogical results.")
        )
      )
    } else if (input$activation == "modified-kosko" & input$squashing == "tanh") {
      shiny::fluidRow(
        shiny::column(
          width = 12, align = "center",
          shiny::p("WARNING: It is unconventional to pair Modified-Kosko with Tanh because simulation inference values
          tend to approach 0 as the number of iterations increases!"),
          shiny::p("Using tanh may produce inconsistent results.")
        )
      )
    } else {
      NULL
    }
  })

  output$squashing_function_formulae <- shiny::renderUI({
    if (input$squashing == "sigmoid") {
      formula <- "$$
        \\begin{gather}
          f( x) =\\frac{1}{1+e^{\\lambda x}}
        \\end{gather}
      $$"
    } else if (input$squashing == "tanh") {
      formula <- "$$
        \\begin{gather}
          f( x) =\\frac{e^{\\lambda x} -e^{-\\lambda x}}{e^{\\lambda x} +e^{-\\lambda x}}
        \\end{gather}
      $$"
    }
    shiny::fluidRow(
      shiny::column(
        width = 12, align = "center",
        shiny::withMathJax(tags$p(formula))
      )
    )
  })
  # ----

  # Num Cores in Parallel ----
  output$num_cores_in_paralell <- shiny::renderUI({
    if (input$parallel) {
      shiny::fluidRow(
        shiny::column(
          width = 5, align = "right",
          shiny::h5("# Cores to Use in Parallel", style = "padding: 35px;")
        ),
        shiny::column(
          width = 7, align = "left",
          shiny::numericInput("n_cores", "", value = parallel::detectCores() - 1, min = 2, max = parallel::detectCores() - 1, step = 1)
        )
      )
    } else {
      NULL
    }
  })
  # ----


  # fcmconfr Code Snippet ----
  fcmconfr_code_snippet_text <- shiny::eventReactive(input$get_code, {

    no_adj_matrices_selected <- identical(methods::is(try(adj_matrices())), "try-error")

    if (no_adj_matrices_selected) {
      code_snippet_text <- "Select an Object then Click *get_code* to load fcmconfr code snippet"
      return(code_snippet_text)
    }

    adj_matrices <- input$adj_matrices
    activation <- input$activation
    squashing <- input$squashing
    lambda <- input$lambda
    point_of_inference <- input$point_of_inference
    max_iter <- input$max_iter
    min_error <- input$min_error
    aggregation_fun <- input$aggregation_fun
    include_zeroes_in_sampling <- input$include_zeroes_in_sampling
    num_mc_fcms <- input$num_mc_fcms
    show_progress <- input$show_progress
    parallel <- input$parallel
    include_sims_in_output <- input$include_sims_in_output
    include_zeroes_in_sampling <- input$include_zeroes_in_sampling
    ci_centering_function <- input$ci_centering_function
    confidence_interval <- input$confidence_interval
    num_ci_bootstraps <- input$num_ci_bootstraps

    simulation_inputs <- c(
      "activation", "squashing",
      "lambda", "point_of_inference", "max_iter", "min_error"
    )

    aggregation_and_mc_inputs <- c(
      "aggregation_fun", "include_zeroes_in_sampling",
      "num_mc_fcms", "show_progress", "parallel",
      "include_sims_in_output", "include_zeroes_in_sampling"
    )

    bootstrap_inputs <- c(
      "ci_centering_function", "confidence_interval", "num_ci_bootstraps"
    )

    simulation_inputs_selected <- FALSE
    agg_and_mc_inputs_selected <- FALSE
    bootstrap_inputs_selected <- FALSE
    code_snippet_preamble <- ""

    if (all(simulation_inputs %in% names(input))) {
      simulation_inputs_selected <- TRUE
    } else {
      code_snippet_preamble <- paste(
        code_snippet_preamble,
        "No simulation inputs selected. Using default values.",
        sep = "\n"
      )
      activation <- "modified-kosko"
      squashing <- "sigmoid"
      lambda <- "1"
      point_of_inference <- "final"
      max_iter <- "100"
      min_error <- "1e-5"
    }

    if (all(aggregation_and_mc_inputs %in% names(input))) {
      agg_and_mc_inputs_selected <- TRUE
    } else {
      code_snippet_preamble <- paste(
        code_snippet_preamble,
        "No aggregation/monte carlo inputs selected. Using default values.",
        sep = "\n"
      )
      aggregation_fun <- "mean"
      include_zeroes_in_sampling <- "TRUE"
      num_mc_fcms <- "1000"
      show_progress <- "TRUE"
      include_sims_in_output <- "TRUE"
      include_zeroes_in_sampling <- "TRUE"
    }

    if (all(bootstrap_inputs %in% names(input))) {
      bootstrap_inputs_selected <- TRUE
    } else {
      code_snippet_preamble <- paste(
        code_snippet_preamble,
        "No bootstrap inputs selected. Using default values.",
        sep = "\n"
      )
      ci_centering_function <- "mean"
      confidence_interval <- "0.95"
      num_ci_bootstraps <- "1000"
    }

    if (code_snippet_preamble != "") {
      code_snippet_preamble <- paste(code_snippet_preamble, "\n\n")
    }

    if (input$perform_aggregation && length(adj_matrices()) == 1) {
      code_snippet_text <- "FCM aggregation requires multiple input FCMs"
      return(code_snippet_text)
    }

    if (input$parallel == "FALSE" || is.null(input$n_cores)) {
      n_cores <- "1"
    } else {
      n_cores <- input$n_cores
    }

    if (is.null(clamping_vector())) {
      clamping_vector <- shiny::reactive({
        rep(0, length(initial_state_vector()))
      })
    }

    perform_aggregation <- input$perform_aggregation
    perform_monte_carlo <- input$perform_monte_carlo
    perform_inference_bootstrap <- input$perform_inference_bootstrap

    if (perform_aggregation & !perform_monte_carlo & !perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Aggregation", "\n",
        "  agg_function = ", paste0("'", aggregation_fun, "'"), ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, ",\n",
        "  include_zeroes_in_sampling = ", include_zeroes_in_sampling, "\n",
        ")", sep = ""
      )
    } else if (perform_aggregation & perform_monte_carlo & !perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Aggregation and Monte Carlo Sampling", "\n",
        "  agg_function = ", paste0("'", aggregation_fun, "'"), ",\n",
        "  num_mc_fcms = ", num_mc_fcms, ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  parallel = ", parallel, ",\n",
        "  n_cores = ", n_cores, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, ",\n",
        "  include_zeroes_in_sampling = ", include_zeroes_in_sampling, ",\n",
        "  include_sims_in_output = ",  include_sims_in_output, "\n",
        ")", sep = ""
      )
    } else if (perform_aggregation & perform_monte_carlo & perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Aggregation and Monte Carlo Sampling", "\n",
        "  agg_function = ", paste0("'", aggregation_fun, "'"), ",\n",
        "  num_mc_fcms = ", num_mc_fcms, ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Inference Estimation (bootstrap)", "\n",
        "  ci_centering_function = ", paste0("'", ci_centering_function, "'"), ",\n",
        "  confidence_interval = ", confidence_interval, ",\n",
        "  num_ci_bootstraps = ", num_ci_bootstraps, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  parallel = ", parallel, ",\n",
        "  n_cores = ", n_cores, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, ",\n",
        "  include_zeroes_in_sampling = ", include_zeroes_in_sampling, ",\n",
        "  include_sims_in_output = ",  include_sims_in_output, "\n",
        ")", sep = ""
      )
    } else if (!perform_aggregation & perform_monte_carlo & !perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Monte Carlo Sampling", "\n",
        "  num_mc_fcms = ", num_mc_fcms, ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  parallel = ", parallel, ",\n",
        "  n_cores = ", n_cores, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, ",\n",
        "  include_zeroes_in_sampling = ", include_zeroes_in_sampling, ",\n",
        "  include_sims_in_output = ",  include_sims_in_output, "\n",
        ")", sep = ""
      )
    } else if (!perform_aggregation & perform_monte_carlo & perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Monte Carlo Sampling", "\n",
        "  num_mc_fcms = ", num_mc_fcms, ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Inference Estimation (bootstrap)", "\n",
        "  ci_centering_function = ", paste0("'", ci_centering_function, "'"), ",\n",
        "  confidence_interval = ", confidence_interval, ",\n",
        "  num_ci_bootstraps = ", x$num_ci_bootstraps, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  parallel = ", parallel, ",\n",
        "  n_cores = ", n_cores, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, ",\n",
        "  include_zeroes_in_sampling = ", include_zeroes_in_sampling, ",\n",
        "  include_sims_in_output = ",  include_sims_in_output, "\n",
        ")", sep = ""
      )
    } else if (!perform_aggregation & !perform_monte_carlo & !perform_inference_bootstrap) {
      code_snippet_text <- paste0(
        "fcmconfr_call <- fcmconfr(", "\n",
        "  adj_matrices = ", adj_matrices, ",\n",
        "  # Simulation", "\n",
        "  initial_state_vector = ", paste0("c(", paste0(initial_state_vector(), collapse = ", "), ")"), ",\n",
        "  clamping_vector = ", paste0("c(", paste0(clamping_vector(), collapse = ", "), ")"), ",\n",
        "  activation = ", paste0("'", activation, "'"), ",\n",
        "  squashing = ",  paste0("'", squashing, "'"), ",\n",
        "  lambda = ", lambda, ",\n",
        "  point_of_inference = ", paste0("'", point_of_inference, "'"), ",\n",
        "  max_iter = ", max_iter, ",\n",
        "  min_error = ", min_error, ",\n",
        "  # Runtime Options", "\n",
        "  show_progress = ", show_progress, ",\n",
        "  # Additional Options", "\n",
        "  run_agg_calcs = ", perform_aggregation, ",\n",
        "  run_mc_calcs = ", perform_monte_carlo, ",\n",
        "  run_ci_calcs = ", perform_inference_bootstrap, "\n",
        ")", sep = ""
      )
    }

    code_snippet_text <- paste(code_snippet_preamble, code_snippet_text, sep = "\n")

    return(code_snippet_text)

  })

  output$fcmconfr_code_snippet <- shiny::renderPrint({
    cat(fcmconfr_code_snippet_text())
  })

  # ----

  shiny::observeEvent(input$close_app, {
    shiny::stopApp()
  })
}


