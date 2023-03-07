library(shiny)
library(tidyverse)
library(ggplot2)

weather_data <- read_delim("UAH-lower-troposphere-long.csv")

weather_data_2<- weather_data %>% 
  mutate(time = (year+(month/12)))

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
          by month."
        ),
        radioButtons("marker", "Choose marker option:",
                     c("EXPR", "Option_2", "Option_3")),
        uiOutput("Region")
      ),
      mainPanel(
        plotOutput("temp_scatterplot"),
        textOutput("observation")
      )
    )
  ),
  tabPanel(
    "Tables",
    sidebarLayout(
      sidebarPanel(
        p("The data table to the right shows the average temp across all regions
          over different years"),
        uiOutput("Time")
      ),
      mainPanel(
        textOutput("Temp_range"),
        tableOutput("Temp_by_year")
      )
    )
  )
)

server <- function(input, output) {
  output$temp_random <- renderTable({weather_data_2 %>% sample_n(5)})
  output$Region <- renderUI ({
    checkboxGroupInput("region",
                       "Select the region to display:",
                       choices = (unique(weather_data_2$region )))
    })
  output$temp_scatterplot <- renderPlot({
    subset <- weather_data_2 %>% 
      filter(region %in% input$region)
    marker <- switch(input$marker,
                     "EXPR" = 19,
                     "Option_2" = 6,
                     "Option_3" = 12)
    ggplot(data = subset, aes(x = time, y = temp, color = region)) + 
      geom_point(shape = marker) 
    })
  output$observation <- renderText({
    text_data <- weather_data_2 %>% 
      filter(region %in% input$region)
    paste0("There are ", 
          count(text_data), " obeservations.")
  })
  output$Time <- renderUI ({
      checkboxGroupInput("year",
                         "Select the year(s) you wish to observe",
                         choices = (unique(weather_data_2$year)))
  })
  output$Temp_by_year <- renderTable({
      table_data <- weather_data_2 %>% 
        group_by(year) %>%
        mutate(ave_temp = mean(temp)) %>%
        distinct(ave_temp) %>% 
        filter(year %in% input$year) 
        
        
  })
  output$Temp_range <- renderText({
    text_data <- weather_data_2 %>% 
      group_by(year) %>%
      mutate(ave_temp = mean(temp)) %>%
      distinct(ave_temp) %>% 
      filter(year %in% input$year) 
    if(length(input$year) > 1) {
      min_year <- min(input$year)
      max_year <- max(input$year)
      ave_temp_min_year <- text_data %>% filter(year == min_year) %>% pull(ave_temp)
      ave_temp_max_year <- text_data %>% filter(year == max_year) %>% pull(ave_temp)
      diff_temp <- ave_temp_max_year - ave_temp_min_year
      paste0("The change in average temperature from ", 
             min_year, " to ", max_year, 
             " is ", round(diff_temp, 2), " degrees Celsius.")
    } else {
      "Please select at least two years to calculate the change in average temperature."
    }
  })
}

shinyApp(ui = ui, server = server)

