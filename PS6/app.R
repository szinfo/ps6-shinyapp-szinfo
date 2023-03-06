library(shiny)
library(tidyverse)
library(ggplot2)

overdose_data<- read_delim("Overdose-demographic-data.csv")

ui <- navbarPage("Drug Overdose Data Analysis",
                 tabPanel("About",
                          sidebarLayout(
                            sidebarPanel(
                              p("Here you can analyze the drug overdose rates 
                              per 100,000 by demographics such as sex, and 
                              ethincity as well as a breakdown of overdoses by 
                              drug. The dataset comes from the CDC, containing 
                              the rates of overdoses by year from 1999 to 2021. 
                              Here is a quick look of overdose rates overall 
                              then broken down by sex")
                            ), mainPanel(
                              tableOutput("Overdose_Total")
                            ))),
  tabPanel("Plots",
           ),
  tabPanel("Tables",
           ),
)


server <- function(input, output) {
  output$Overdose_Total <- renderTable({overdose_data %>%  slice(1:3) })
}

shinyApp(ui = ui, server = server)
