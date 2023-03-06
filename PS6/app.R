library(shiny)
library(tidyverse)
library(ggplot2)


weather_data <- read_delim("UAH-lower-troposphere-long.csv")

if(interactive()) {
ui <- navbarPage(
  "Temperature Data Analysis",
  tabPanel(
    "About",
    sidebarLayout(
      sidebarPanel(
        p("With this app you can analyze temperature data recorded 
        from satellites. The dataset comes from the UAH, 
        containing temperature data by year from 1978 to 2023. 
        Here is a quick look of some of the data")
      ),
      mainPanel(
        tableOutput("temp_random")
      )
    )
  ),
  tabPanel(
    "Plots",
    sidebarLayout(
      sidebarPanel(
        p("With this graph you can analyze the temperature by different regions.
          Select the region you wish to observe. The scatterplot shows the data
          by month."),
        uiOutput("Region"),
        radioButtons("marker", "Choose marker option:",
                     c("EXPR", "Option_2", "Option_3"))
      ),
      mainPanel(
        plotOutput("temp_scatterplot"),
        textOutput("observation")
    )
  )
),
  tabPanel(
    "Tables"
  )
)

server <- function(input, output) {
  output$temp_random <- renderTable({weather_data %>% sample_n(5)})
  output$Region <- renderUI ({
  checkboxGroupInput("region",
                      "Select the region to display:",
                      choices = (unique(weather_data$region )))
})
output$temp_scatterplot <- renderPlot({
  subset <- weather_data %>% 
    filter(region %in% input$region)
  marker <- switch(input$marker,
                   "EXPR" = 19,
                   "Option_2" = 6,
                   "Option_3" = 12)
    ggplot(data = subset, aes(x = year, y = temp, color = subset$region)) + 
      geom_point(shape = marker) 
      })
output$observation <- renderText({
  text_data <- weather_data %>% 
    filter(region == region %in% input$region) %>% 
    count(region)
  paste0("There are ", text_data$n, " observations.")
})
  }

shinyApp(ui = ui, server = server)
}