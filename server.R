server <- function(input, output) {
  source("server/server_flow.R", local = TRUE)
  source("server/server_monthly.R", local = TRUE)
  source("server/server_ui_monthlabel.R", local = TRUE)
  source("server/server_fmgd.R", local = TRUE)
  source("server/server_percentile.R", local = TRUE)
  source("server/server_base_plot.R", local = TRUE)
  source("server/server_plotly.R", local = TRUE)
  source("server/server_plotly2.R", local = TRUE)
  # output$monthlabel1 <- renderUI({
  #   monthlabel1 <- (month.abb[monthly.rec()$month[1]])
  #   sliderInput('w1', monthlabel1, 10, 100, 34)
  # })
}

