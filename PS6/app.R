library(shiny)
library(tidyverse)
library(ggplot2)

overdose_data<- read_delim("overdose-by-demographic.csv")

ui <- fluidPage(
  titlePanel("About"),
  sidebarLayout(
    sidebarPanel(
      p("Here you can analyze the drug overdose rates by demographics such as 
      Sex, and race as well as a breakdown of overdoses by drug
      The dataset comes from the CDC, containing the rates of overdoses by 
      year from 1999 to 2021
      Here is a table of overall rates of overdose regardless of drug from
        1999 to 2021, broken down by sex")
    ),
    mainPanel(
      tableOutput("Overdose_Total")
    )
  )
)
server <- function(input, output) {
  output$Overdose_Total <- renderTable({overdose_data %>% slice(6:9)}) 
}

shinyApp(ui = ui, server = server)
