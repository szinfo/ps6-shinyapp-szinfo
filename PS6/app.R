
library(shiny)
library(tidyverse)
library(ggplot2)

# Read the data
overdose_data <- read_csv("Overdose-demographic-data..csv")

# Define the UI
ui <- navbarPage(
  "Drug Overdose Data Analysis",
  tabPanel(
    "About",
    sidebarLayout(
      sidebarPanel(
        p("With this app you can analyze the drug overdose
                            rates per 100,000 people by demographics such as 
                            sex  and ethincity, as well as a breakdown of 
                            overdoses by drug. The dataset comes from the CDC, 
                            containing the rates of overdoses by year from 1999 
                            to 2021. Here is a quick look of overdose rates 
                            overall then broken down by sex (Per 100,000 males
                            and per 100,000 females)")
      ),
      mainPanel(
        tableOutput("Overdose_Total")
      )
    )
  ),
  tabPanel(
    "Plots",
    sidebarLayout(
      sidebarPanel(
        p("With this graph you can analyze the overdose rates by drug,
                 while examining the breakdown between overall rates then by 
                 sex"),
        selectInput(
          "Drug",
          "Select a drug:",
          choices = c("Any Opioid", "Prescription Opioids2", "Synthetic Opioids other than Methadone (primarily fentanyl)3", "Heroin4", "Stimulants5a", "Cocaine5", "Psychostimulants With Abuse Potential (primarily methamphetamine)6")
        ),
        selectInput(
          "demo",
          "Select a demographic:",
          choices = c("Overall","Female","Male", "White (Non-Hispanic)", "Black (Non-Hispanic)", "Asian* (Non-Hispanic)", "Native Hawaiian or Other Pacific Islander* (Non-Hispanic)", "Hispanic", "American Indian or Alaska Native (Non-Hispanic)")
        )
      ),
      mainPanel(
        plotOutput("Overdose_scatterplot")
      )
    )
  ),
  tabPanel(
    "Tables"
  )
)

# Define the server
server <- function(input, output) {
  
  # Subset the data based on the user input
  filtered_data <- reactive({
    overdose_data %>%
      filter(Drug == input$drug) %>%
      select(Year, input$demo) %>%
      rename_with(~"Overdose_rate", input$demo) %>%
      drop_na()
  })
  
  # Create the scatterplot
  output$Overdose_scatterplot <- renderPlot({
    ggplot(filtered_data(), aes(x = Year, y = Overdose_rate)) +
      geom_point() +
      labs(title = paste("Overdose rates for", input$drug, "by", input$demo),
           x = "Year", y = "Overdose rate per 100,000 people")
  })
}

# Run the app
shinyApp(ui = ui, server = server)