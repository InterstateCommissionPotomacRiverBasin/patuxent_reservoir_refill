#Shiny user interface ###############################################
ui <- dashboardPage(
  dashboardHeader(title = "Reservoir Refill Scenarios"),
  dashboardSidebar(sidebarMenu(
    menuItem("Arima", tabName = "graph0", icon = icon("bar-chart-o")),
    menuItem(
      "Historic",
      tabName = "widgets",
      icon = icon("bar-chart-o"),
      badgeLabel = "new",
      badgeColor = "green"
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
      numericInput('capacity', 'Capacity (BG)', 10.12, min = 0)
    ),
    menuSubItem(
      icon = NULL,
      numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16, min = 0)
    ),
    menuSubItem(
      icon = NULL,
      numericInput('dead_storage', 'Dead Storage (BG)', 0.5, min = 0)
    ),
    menuSubItem(
      icon = NULL,
      sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
    )
  )),
  dashboardBody(tabItems(
    tabItem(tabName = "graph0",
            # Boxes need to be put in a row (or column)
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9),
              box(plotlyOutput("plotly1", height = 500) %>% withSpinner(type = 4), width = 12)
              # box(
              #   width = 3,
              #   title = "Controls",
              #   dateInput(
              #     'today_is',
              #     'Date',
              #     value = "2016-08-01",
              #     min = "2000-06-01",
              #     max = "2018-05-22",
              #     format = "yyyy-mm-dd",
              #     startview = "month",
              #     weekstart = 0,
              #     language = "en",
              #     width = NULL
              #   ),
              #   numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0, min = 0),
              #   numericInput('capacity', 'Capacity (BG)', 10.12, min = 0),
              #   numericInput('dead_storage', 'Dead Storage (BG)', 0.5, min = 0),
              #   numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16, min = 0),
              #   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
              # )
            )),
    
    tabItem(tabName = "widgets",
            h2("historic data"),
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9),
              box(plotlyOutput("plotly2", height = 500) %>% withSpinner(type = 6), width = 9)
            ))
  ))
)
