fmgd.rec <- reactive({
  
  monthly.df <- monthly.rec()
  #########################################################################################source("inflow.R")
  
  
  
  test.df <- monthly.df %>%
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
  
  f_mgd1.df <- data.frame(mapply(`*`, arima.df, monthly.df$st.dev.log.flow))
  f_mgd.df <- exp(data.frame(mapply(`+`, f_mgd1.df, monthly.df$mean.log.flow)))
  
  return(f_mgd.df)
})