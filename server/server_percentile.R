percentile.rec <- reactive({
  fmgd.df <- fmgd.rec()
  #start_storage <- 8.2
  start_storage <- input$beginning_storage
  #capacity <- 10.6
  capacity <- input$capacity
  #min_rel <-16
  min_rel <-  input$min_wqrl 
  #dead_storage <- 0.43
  dead_storage <- input$dead_storage
  #withdrawal <- 15
  #withdrawal <- input$withdrawal_slider
  
  withdrawal <- mean(c(input$w1,input$w2,input$w3,
                     input$w4,input$w5,input$w6,
                     input$w7,input$w8,input$w9,
                     input$w10,input$w11,input$w12))
  print (withdrawal)
  #print (input$w12)
  
  storage.df <- start_storage + 
    (fmgd.df / 1000) -
    (withdrawal * 30 / 1000)-
    (min_rel * 0.64636/1000)
  storage.df <- replace(storage.df, storage.df > capacity, capacity)
  storage.df <- replace(storage.df, storage.df < dead_storage, dead_storage)
  
  quants <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)
  percentile.df <- apply(storage.df, 2, quantile, probs = quants, na.rm = TRUE)
  
  return(percentile.df)
})