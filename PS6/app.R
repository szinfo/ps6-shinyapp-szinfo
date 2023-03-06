library(shiny)
library(tidyverse)
library(ggplot2)

overdose_data<- read_delim("Overdose-demographic-data.csv")
adjusted_data<- read_delim("Overdose-data-readjusted.csv")
years <- c("1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", 
           "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", 
           "2015", "2016","2017", "2018", "2019", "2020", "2021")
ui <- navbarPage("Drug Overdose Data Analysis",
                 tabPanel("About",
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
                                      ), mainPanel(
                                        tableOutput("Overdose_Total")
                                      ))),
  tabPanel("Plots",
           sidebarLayout(
             sidebarPanel(
               p("With this graph you can analyze the overdose rates by drug,
                 while examining the breakdown between overall rates then by 
                 sex"),
              uiOutput("Drugs")
             ),
             mainPanel(
               plotOutput("Overdose_scatterplot")
             )
           )
           ),
  tabPanel("Tables",
           )
)


server <- function(input, output) {
  output$Overdose_Total <- renderTable({overdose_data %>%  slice(1:3) })
  output$Drugs <- renderUI ({
    checkboxGroupInput("Drugs", "Drugs to choose from",
                       choices = c("Any Opioid1", "Perscription Opioid",
                                   "Synthetic Opioids", "Herion4", 
                                   "Stimulants5a", "Cocaine5", 
                                   "Psychostimulants With Abuse Potential 
                                   (primarily methamphetamine)6"))})
  output$Overdose_scatterplot <- renderPlot({
    ggplot(adjusted_data, aes(x = years))
  })
}
shinyApp(ui = ui, server = server)
