
#Shiny user interface ###############################################
ui <- dashboardPage(
  dashboardHeader(title = "Reservoir Refill Scenarios"),
  dashboardSidebar(sidebarMenu(
    menuItem("Instructions", tabName = "instructions", icon = icon("book")),
    menuItem("Arima", tabName = "graph0", icon = icon("bar-chart-o")),
    menuItem(
      "Historic",
      tabName = "widgets",
      icon = icon("bar-chart-o")
      ),
    menuItem(
      "Controls",
      tabName = "controls",
      icon = icon("gamepad")
    ),
    menuSubItem(
      icon = NULL,
      dateInput(
        'today_is',
        'Date',
        value = "2016-08-01",
        min = "2000-06-01",
        max = "2018-05-22",
        format = "yyyy-mm-dd",
        startview = "month",
        weekstart = 0,
        language = "en",
        width = NULL
      )
    ),
    menuSubItem(
     icon = NULL,
     numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0, min = 0)
     ),
    menuSubItem(
      icon = NULL,
      sliderInput("withdrawal_slider", "Average withdrawals (MGD)", 10, 100, 34)
    )
  )),
  dashboardBody(tabItems(
    tabItem(tabName = "graph0",
            h2("Based on ARIMA model"),
            # Boxes need to be put in a row (or column)
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9),
              box(plotlyOutput("plotly1", height = 500) %>% withSpinner(type = 4), width = 12)
            ),
            h2("Withdrawals"),
            fluidRow(
              box(
                width = 3,
                uiOutput("w1output"),
                uiOutput("w2output"),
                uiOutput("w3output")
                ),  
              box(
                width = 3,
                uiOutput("w4output"),
                uiOutput("w5output"),
                uiOutput("w6output")
                ),
              box(
                width = 3,
                uiOutput("w7output"),
                uiOutput("w8output"),
                uiOutput("w9output")
                ),
              box(
                width = 3,
                uiOutput("w10output"),
                uiOutput("w11output"),
                uiOutput("w12output")
                ) 
            )
            ),
    
    tabItem(tabName = "widgets",
            h2("Based on historic data"),
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9)
              #box(plotlyOutput("plotly2", height = 500) %>% withSpinner(type = 6), width = 12)
              box(plotOutput("plot1", height = 500), width = 9)
            )),
    
    tabItem(tabName = "controls",
            h2("Reservoir parameters"),
            fluidRow(
              box(
                  width = 9,
                  #title = "Controls",
                  #numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0, min = 0),
                  numericInput('capacity', 'Capacity (BG)', 10.12, min = 0),
                  numericInput('dead_storage', 'Dead Storage (BG)', 0.5, min = 0),
                  numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16, min = 0)
              )
            )),
    tabItem(tabName = "instructions",
            h2("Instructions"),
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9),
              #box(plotlyOutput("plotly2", height = 500) %>% withSpinner(type = 6), width = 9)
            ))
      
  )#,
  #tags$head(tags$script(jsc))
  )
)
