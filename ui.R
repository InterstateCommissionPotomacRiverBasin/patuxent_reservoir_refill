jsc <- '
$(document).ready(function () {
  $(".sidebar-menu").children("li").on("click", function() {
    $("#mult, #single").toggle();
  });
});
'

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
    # menuSubItem(
    #   icon = NULL,
    #   numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0, min = 0)
    # ),
    # menuSubItem(
    #   icon = NULL,
    #   numericInput('capacity', 'Capacity (BG)', 10.12, min = 0)
    # ),
    # menuSubItem(
    #   icon = NULL,
    #   numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16, min = 0)
    # ),
    # menuSubItem(
    #   icon = NULL,
    #   numericInput('dead_storage', 'Dead Storage (BG)', 0.5, min = 0)
    # ),
    
    menuSubItem(
      icon = NULL,
      sliderInput("withdrawal_slider", "Average withdrawals (MGD)", 10, 100, 34)
    )
    
    # menuItem("Single Analysis", 
    #          tabName = "widgets", 
    #          icon = icon("th")),
    #sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34),
    #submitButton("Submit", width = "290"),
    # menuItem(
    #   "Multiple Incident Analysis",
    #   tabName = "dashboard",
    #   icon = icon("th")),      
    # div(id = "mult", splitLayout(cellWidths = c("44%", "31%", "25%"),
    #                              dateInput("datefrom", "Date From:", format = "mm/dd/yyyy", Sys.Date()-5),
    #                              textInput("datefrom_hour", "Hour",
    #                                        value = "12:00"),
    #                              textInput("datefrom_noon","AM/PM", value = "AM")),      
    #     splitLayout(cellWidths = c("44%", "31%", "25%"),
    #                 dateInput("dateto", "Date To:", format = "mm/dd/yyyy"),
    #                 textInput("dateto_hour", "Hour",
    #                           value = "11:59"),
    #                 textInput("dateto_noon","AM/PM", value = "PM"))),
    # menuItem("Monthly Withdrawals", 
    #           tabName = "controls", 
    #           icon = icon("th")),
    # div(id = "mult", 
    #     style="display: none;", 
    #     sliderInput("withdrawal_slider", "Month 1", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 2", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 3", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 4", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 5", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 6", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 7", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 8", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 9", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 10", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 11", 10, 100, 34),
    #     sliderInput("withdrawal_slider", "Month 12", 10, 100, 34))
    #submitButton("Submit", width = "290")
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
                #title = "Controls",
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
                #)
                numericInput('w1', 'Month 1', 3.0, min = 0),
                numericInput('w2', 'Month 2', 3.0, min = 0),
                numericInput('w3', 'Month 3', 3.0, min = 0)
                #   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
              ),  
              box(
                width = 3,
                #title = "Controls",
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
                #)
                numericInput('w4', 'Month 4', 3.0, min = 0),
                numericInput('w5', 'Month 5', 3.0, min = 0),
                numericInput('w6', 'Month 6', 3.0, min = 0)
                #   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
                 ),
              box(
                width = 3,
                #title = "Controls",
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
                #)
                numericInput('w7', 'Month 7', 3.0, min = 0),
                numericInput('w8', 'Month 8', 3.0, min = 0),
                numericInput('w9', 'Month 9', 3.0, min = 0)
                #   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
                ),
              box(
                width = 3,
                #title = "",
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
                #)
                numericInput('w10', 'Month 10', 3.0, min = 0),
                numericInput('w11', 'Month 11', 3.0, min = 0),
                numericInput('w12', 'Month 12', 3.0, min = 0)
                #   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
              ) 
            )
            ),
    
    tabItem(tabName = "widgets",
            h2("Based on historic data"),
            fluidRow(
              #box(plotOutput("base_plot", height = 500), width = 9),
              box(plotlyOutput("plotly2", height = 500) %>% withSpinner(type = 6), width = 12)
            )),
    
    tabItem(tabName = "controls",
            h2("Reservoir parameters"),
            fluidRow(
              box(
                  width = 9,
                  #title = "Controls",
                  numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0, min = 0),
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
