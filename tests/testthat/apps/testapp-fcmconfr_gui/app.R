
ui <- source(system.file(file.path('shiny', 'fcmconfr_gui', 'ui.R'), package = 'fcmconfr'), local = TRUE)$value
server <- source(system.file(file.path('shiny', 'fcmconfr_gui', 'server.R'), package = 'fcmconfr'), local = TRUE)$value
shiny::shinyApp(ui, server)
