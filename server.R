server <- function(input, output) {
  source("server/server_flow.R", local = TRUE)
  source("server/server_monthly.R", local = TRUE)
  source("server/server_fmgd.R", local = TRUE)
  source("server/server_percentile.R", local = TRUE)
  source("server/server_base_plot.R", local = TRUE)
  source("server/server_plotly.R", local = TRUE)
  source("server/server_plotly2.R", local = TRUE)
}
