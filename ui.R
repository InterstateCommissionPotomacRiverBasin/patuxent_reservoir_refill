library(shiny)
library(shinydashboard)
library(lubridate)
library(tidyverse)
library(data.table)
library(ggplot2)


#Shiny user interface ###############################################

ui <- dashboardPage(
  dashboardHeader(title = "Reservoir Refill Scenarios"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Arima", tabName = "graph0", icon = icon("bar-chart-o")),
      menuItem("Historic", tabName = "widgets", 
               icon = icon("bar-chart-o"), 
               badgeLabel = "new",
               badgeColor = "green"
               )
    )
  ),
  dashboardBody(
    tabItems(
        tabItem(tabName = "graph0",
                
    
          # Boxes need to be put in a row (or column)
          fluidRow(
            box(plotOutput("plot1", height = 500), width = 9),
            
            
            
            box(width = 3,
                title = "Controls",
                dateInput('date_input', 'Date', value = "2016-08-01", min = "2000-06-01", max = "2018-05-22",
                          format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                          language = "en", width = NULL),
                numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0),
                numericInput('capacity', 'Capacity (BG)', 10.12),
                numericInput('dead_storage', 'Dead Storage (BG)', 0.5),
                numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16),
                sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
            )
          )
        ),
        
        tabItem(tabName = "widgets",
                h2("historic data"),
                fluidRow(
                  box(plotOutput("plot2", height = 500), width = 9)
                )
        )
    )
  )
)



#shinyApp(ui, server)