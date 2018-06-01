flow.rec <- eventReactive(input$today_is, {
  website <- "https://nwis.waterdata.usgs.gov/usa/nwis/uv/"
  parameter <- "00060"
  site_number <- "01591000"
  ini_start_month <- ceiling_date(input$today_is - years(1), "month")
  start_date <- as.character(ini_start_month)
  end_date <- as.character(input$today_is)
  #link <-"https://nwis.waterdata.usgs.gov/usa/nwis/uv/?cb_00060=on&format=rdb&site_no=01591000&period=&begin_date=2007-04-01&end_date=2008-03-25"
  link <- paste(website, 
                "?cb_",
                parameter,
                "=on&format=rdb&site_no=",
                site_number,
                "&period=&begin_date=",
                start_date,
                "&end_date=",
                end_date,
                sep="")
  print("Downloading flow data")
  pull.df <- read.csv(url(link), skip = 31, sep = "\t")
  colnames(pull.df) <- c("agency","site_number", "datetime",
                         "tz_cd", "discharge", "status_cd")
  
  final.df <- pull.df %>% 
    dplyr::mutate (discharge = as.numeric(as.character(discharge))) %>%
    mutate(datetime = as.POSIXct(as.character(datetime), tz = "EST")) %>%
    #mutate(datetime = strptime(as.character(datetime), "%Y-%m-%d %H:%M:%S")) %>%
    mutate(datetime = floor_date(datetime, "day")) %>%
    group_by(datetime) %>% 
    summarize(discharge_daily = mean(discharge))  %>% 
    mutate(adj_flow = discharge_daily * adj_coef)
  
  return(final.df)
})