monthly.rec <- reactive({
  monthly.df<- flow.rec() %>%
    mutate(begin_month = floor_date(datetime, "month")) %>%
    mutate(end_month = ceiling_date(begin_month + days (1), "month") - days (1)) %>%
    group_by(begin_month, end_month)  %>%
    summarize(monthly_flow = mean(adj_flow, na.rm=TRUE))
  
  monthly.df[12,2] = ceiling_date(input$today_is, "day")
  
  monthly.df<- monthly.df%>%
    #summarize(monthly_flow = sum(adj_flow, na.rm=TRUE)) 
    #summarize(monthly_flow = mean(adj_flow, na.rm=TRUE)) %>%
    mutate(monthly_flow = monthly_flow * day(end_month))  %>%
    mutate(log_m_flow = log(monthly_flow)) %>%
    mutate(month = month(end_month))
  
  final.df <- merge(monthly.df, std.df, by = "month", sort = FALSE) %>%
    mutate(std_flow = (log_m_flow - mean.log.flow) / st.dev.log.flow)
  # print (final.df)
  # print (month.abb[final.df$month[1]])
  
  return(final.df)
})

monthlylabel.rec <- reactive({
  monthly.df<- flow.rec() %>%
    mutate(begin_month = floor_date(datetime, "month")) %>%
    mutate(end_month = ceiling_date(begin_month + days (1), "month") - days (1)) %>%
    group_by(begin_month, end_month)  %>%
    summarize(monthly_flow = mean(adj_flow, na.rm=TRUE))
  
  monthly.df[12,2] = ceiling_date(input$today_is, "day")
  
  monthly.df<- monthly.df%>%
    #summarize(monthly_flow = sum(adj_flow, na.rm=TRUE)) 
    #summarize(monthly_flow = mean(adj_flow, na.rm=TRUE)) %>%
    mutate(monthly_flow = monthly_flow * day(end_month))  %>%
    mutate(log_m_flow = log(monthly_flow)) %>%
    mutate(month = month(end_month))
  
  final.df <- merge(monthly.df, std.df, by = "month", sort = FALSE) %>%
    mutate(std_flow = (log_m_flow - mean.log.flow) / st.dev.log.flow)
  #print (final.df)
  monthlabel.df  <- month.abb[final.df()$month]
  print (monthlabel.df)
  return(monthlabel.df)
})