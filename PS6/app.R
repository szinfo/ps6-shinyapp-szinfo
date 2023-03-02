library(shiny)
library(rsconnect)
ui <- fluidPage(
  titlePanel("About"), 
  mainPanel(
    textOutput("welcome")
  ),
  fluidPage(
    titlePanel("Plots")
  ),
  fluidPage(
    titlePanek("Tables")
  )
) 

server <- function(input, output) {
  output$hello <- renderText("welcome to my app")
}

shinyApp(ui = ui, server = server)
