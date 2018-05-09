library(shiny)
library(shinydashboard)
library(lubridate)
library(tidyverse)
library(data.table)
library(ggplot2)


#Shiny user interface ###############################################

ui <- dashboardPage(
  dashboardHeader(title = "Reservoir Refill Scenarios"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 500), width = 9),
      
      
      
      box(width = 3,
          title = "Controls",
          dateInput('date_input', 'Date', value = "2017-07-01", min = "2000-06-01", max = "2018-05-30",
                    format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                    language = "en", width = NULL),
          numericInput('beginning_storage', 'Beginning Storage (BG)', 3.0),
          numericInput('capacity', 'Capacity (BG)', 10.12),
          numericInput('dead_storage', 'Dead Storage (BG)', 0.5),
          numericInput('min_wqrl', 'Minimum WQ Release (MGD)', 16),
          sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, 34)
      )
    )
  )
)

#Shiny server #######################################################

server <- function(input, output) {
  flow.df <- eventReactive(input$date_input, {
    website <- "https://nwis.waterdata.usgs.gov/usa/nwis/uv/"
    parameter <- "00060"
    site_number <- "01591000"
    ini_start_month <- ceiling_date(input$date_input - years(1), "month")
    start_date <- as.character(ini_start_month)
    end_date <- as.character(input$date_input)
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
    X <- read.csv(url(link), skip = 31, sep = "\t")
    colnames(X) <- c("agency","site_number", "datetime", "tz_cd", "discharge", "status_cd")
    return(X)
  })
  output$plot1 <- renderPlot({
    
    
    adj_coef <- as.numeric(2.422)
    #today_is <- as.Date("2008-3-25", "%Y-%m-%d")  #input variable (to be)
    
    today_is <- input$date_input
    
    #get initialization months
    ini_start_month <- ceiling_date(today_is - years(1), "month")
    ini_months <- seq(ini_start_month, length=12, by="months")
    df_ini_months <- data.frame(ini_months)
    df_ini_months$end_months <- ceiling_date(df_ini_months$ini_months, "month") - days(1)
    
    #get simulation months
    sim_months <- seq(today_is, length=13, by="months")
    df_sim_months <- data.frame(sim_months)
    df_sim_months$end_months <- ceiling_date(df_sim_months$sim_months, "month") - days(1)
    
    #########################################################################################
    # website <- "https://nwis.waterdata.usgs.gov/usa/nwis/uv/"
    # parameter <- "00060"
    # site_number <- "01591000"
    # start_date <- as.character(ini_start_month)
    # end_date <- as.character(today_is)
    # #link <-"https://nwis.waterdata.usgs.gov/usa/nwis/uv/?cb_00060=on&format=rdb&site_no=01591000&period=&begin_date=2007-04-01&end_date=2008-03-25"
    # link <- paste(website, 
    #               "?cb_",
    #               parameter,
    #               "=on&format=rdb&site_no=",
    #               site_number,
    #               "&period=&begin_date=",
    #               start_date,
    #               "&end_date=",
    #               end_date,
    #               sep="")
    # print("Downloading flow data")
    # X <- read.csv(url(link), skip = 31, sep = "\t")
    # colnames(X) <- c("agency","site_number", "datetime", "tz_cd", "discharge", "status_cd")
    #data.df <- X  %>% 
    # dplyr::mutate (datetime = as.POSIXct(datetime, format = "%Y-%m-%dT%H:%M"))
    #########################################################################################
    std.df <- read.csv("data/standard_data.csv", header = TRUE, sep = ',')
    
    
    #########################################################################################
    
    data.df <- flow.df() %>%
      dplyr::mutate (discharge = as.numeric(as.character(discharge))) %>%
      mutate(datetime = as.POSIXct(as.character(datetime), tz = "EST")) %>%
      #mutate(datetime = strptime(as.character(datetime), "%Y-%m-%d %H:%M:%S")) %>%
      mutate(datetime = floor_date(datetime, "day")) %>%
      group_by(datetime) %>% 
      summarize(discharge_daily = mean(discharge))  %>% 
      mutate(adj_flow = discharge_daily * adj_coef)
    
    #########################################################################################
    monthly_data.df <- data.df %>%
      mutate(begin_month = floor_date(datetime, "month")) %>%
      mutate(end_month = ceiling_date(begin_month + days (1), "month") - days (1)) %>%
      group_by(begin_month, end_month)  %>%
      summarize(monthly_flow = mean(adj_flow, na.rm=TRUE))
    
    monthly_data.df[12,2] = ceiling_date(today_is, "day")
    
    monthly_data.df <- monthly_data.df %>%
      #summarize(monthly_flow = sum(adj_flow, na.rm=TRUE)) 
      #summarize(monthly_flow = mean(adj_flow, na.rm=TRUE)) %>%
      mutate(monthly_flow = monthly_flow * day(end_month))  %>%
      mutate(log_m_flow = log(monthly_flow)) %>%
      mutate(month = month(end_month))
    
    monthly_data.df <- merge(monthly_data.df, std.df, by = "month", sort = FALSE) %>%
      mutate(std_flow = (log_m_flow - mean.log.flow) / st.dev.log.flow)
    #########################################################################################source("inflow.R")
    
    
    
    test.df <- monthly_data.df %>%
      mutate(error = 0) %>%
      mutate(f1 = 0)
    #########################################################################################
    
    phi1 <- c(1.12258)
    phi2 <- -0.17850
    phi3 <- 0.0360
    theta <- 0.62765
    
    
    for(i in seq(nrow(test.df))) {
      if (i == 1) {
        test.df$error[i] <- test.df$std_flow[i]
        test.df$f1[i] <- (test.df$std_flow[i] * phi1) + (phi2 * 0) + (phi3 * 0) - (theta * test.df$error[i])
      } else if (i == 2) {
        test.df$error[i] <- test.df$std_flow[i] - test.df$f1[i-1]
        test.df$f1[i] <- (phi1 * test.df$std_flow[i]) + (phi2 * test.df$std_flow[i-1]) + (phi3 * 0) - (theta * test.df$error[i])
      } else {
        test.df$error[i] <- test.df$std_flow[i] - test.df$f1[i-1]
        test.df$f1[i] <- (phi1 * test.df$std_flow[i]) + (phi2 * test.df$std_flow[i-1]) + (phi3 * test.df$std_flow[i-2]) - (theta * test.df$error[i])
      }
    }
    
    arima.df <- setNames(data.frame(matrix(ncol = 12, nrow = 1000)), seq(12))
    #random.df <- data.frame(rnorm(10,mean=0.00303,sd=0.76220))
    random.df <- setNames(data.frame(replicate(12, rnorm(1000,mean=0.00303,sd=0.76220))), seq(12))
    
    for(j in as.numeric(names(arima.df))){
      for(i in seq(nrow(arima.df))) {
        if (j == 1) {
          arima.df[[j]][i] <- (phi1 * test.df$std_flow[12]) + 
            (phi2 * test.df$std_flow[11]) + 
            (phi3 * test.df$std_flow[10]) - 
            (theta * test.df$error[12]) +
            random.df[[j]][i]
        } else if (j == 2) {
          arima.df[[j]][i] <- (phi1 * random.df[[j-1]][i]) + 
            (phi2 * test.df$std_flow[12]) + 
            (phi3 * test.df$std_flow[11]) - 
            (theta * random.df[[j-1]][i]) +
            random.df[[j]][i]
        } else if (j==3) {
          arima.df[[j]][i] <- (phi1 * random.df[[j-1]][i]) + 
            (phi2 * random.df[[j-2]][i]) + 
            (phi3 * test.df$std_flow[12]) - 
            (theta * random.df[[j-1]][i]) +
            random.df[[j]][i]
        } else {
          arima.df[[j]][i] <- (phi1 * random.df[[j-1]][i]) + 
            (phi2 * random.df[[j-2]][i]) + 
            (phi3 * random.df[[j-3]][i]) - 
            (theta * random.df[[j-1]][i]) +
            random.df[[j]][i]
        }
      }
    }
    
    f_mgd1.df <- data.frame(mapply(`*`, arima.df, monthly_data.df$st.dev.log.flow))
    f_mgd.df <- exp(data.frame(mapply(`+`, f_mgd1.df, monthly_data.df$mean.log.flow)))
    
    #########################################################################################
    
    #start_storage <- 8.2
    start_storage <- input$beginning_storage
    #capacity <- 10.6
    capacity <- input$capacity
    #min_rel <-16
    min_rel <-  input$min_wqrl 
    #dead_storage <- 0.43
    dead_storage <- input$dead_storage
    #withdrawal <- 15
    withdrawal <- input$withdrawal_slider
    
    storage.df <- start_storage + 
      (f_mgd.df / 1000) -
      (withdrawal * 30 / 1000)-
      (min_rel*0.64636/1000)
    storage.df <- replace(storage.df, storage.df > capacity, capacity)
    storage.df <- replace(storage.df, storage.df < dead_storage, dead_storage)
    
    
    quants <- c(0.05,0.1,0.25,0.5,0.75,0.9)
    percentile.df <- apply(storage.df, 2 , quantile , probs = quants , na.rm = TRUE )
    
    plot(1:12,percentile.df[1,1:12],type="l",xlim=range(1:12),ylim=range(0:11),xaxs="i",yaxs="i",xlab="Month",ylab="Storage (BG)",axes=FALSE,frame.plot=TRUE)
    polygon(c(1:12,12:1),c(rep(0,12),rep(dead_storage,12)),col="rosybrown",border=NA)
    polygon(c(1:12,12:1),c(rep(dead_storage,12),rep(capacity,12)),col="lightblue",border=NA)
    #polygon(c(1:12,12:1),c(rep(capacity,12),rep(11,12)),col="grey",border=NA)
    #polygon(c(1:12,12:1),c(percentile.df[1,],rev(percentile.df[6,])),col="skyblue")
    #polygon(c(1:12,12:1),c(percentile.df[1,],rev(percentile.df[3,])),col="skyblue",border=NA)
    lines(1:12,(c(rep(capacity*0.9,12))),lty=2,lwd=1, cex=1.2, col="black")
    #lines(1:12,(percentile.df[4,1:12]),lty=1,lwd=2,col="orange", type="b", pch=18, cex=2)
    lines(1:12,(percentile.df[4,1:12]),lty=1,lwd=2,col="yellow", type="b", pch=15, cex=1.5)
    lines(1:12,(percentile.df[6,1:12]),lty=1,lwd=2,col="green", type="b", pch=23, cex=1.5)
    lines(1:12,(percentile.df[2,1:12]),lty=1,lwd=2, type="b", pch=19, cex=1.2, col="red")
    legend("bottomright", inset=.04, legend=c("90th", "50th", "10th" ), col=c("green", "yellow", "red"), lty=1:1, cex=1.2)
    axis(1, at=1:12, labels=month.abb[monthly_data.df$month])
    axis(2, labels=TRUE)
    #text(2.6, 0.5, "Emergency storage")
    text(2.5, 8.9, "90% full")
    
    
  })
}

shinyApp(ui, server)