output$plotly2 <- renderPlotly({

# define ------------------------------------------------------------------
  percentile.df <- percentile.rec()
  capacity <- input$capacity
  dead_storage <- input$dead_storage
  full_90pct <- capacity * 0.9
# preprocess --------------------------------------------------------------
  percentile.df <- data.frame(percentile.df)
  names(percentile.df) <- month.abb[monthly.rec()$month]#lubridate::month(c(4:12, 1:3), label = TRUE)
  percentile.df <- percentile.df %>% 
    mutate(percentile = rownames(.),
           percentile = paste0("pct_", str_extract(percentile, '[0-9]+'))) %>% 
    gather(Month, Storage, -percentile) %>% 
    mutate(Month = factor(Month, levels = month.abb[monthly.rec()$month]))
 
  
  rect.df <- percentile.df %>% 
    spread(percentile, Storage)
  rect.xmax <- percentile.df %>% 
    select(Month) %>% 
    distinct() %>% 
    nrow() + 1
  percentile.df <- left_join(percentile.df, rect.df, by = c("Month"))

# plot --------------------------------------------------------------------
  p <- ggplot(percentile.df, aes(Month, Storage, group = percentile)) +
    geom_ribbon(aes(ymin = dead_storage, ymax = capacity), fill = "lightblue") +
    geom_ribbon(aes(ymin = 0, ymax = dead_storage), fill = "rosybrown") +
    geom_ribbon(aes(ymin = pct_5, ymax = pct_10), fill = "indianred1") +
    geom_ribbon(aes(ymin = pct_10, ymax = pct_25), fill = "lightpink") +
    geom_ribbon(aes(ymin = pct_25, ymax = pct_50), fill = "rosybrown1") +
    geom_ribbon(aes(ymin = pct_50, ymax = pct_75), fill = "moccasin") +
    geom_ribbon(aes(ymin = pct_75, ymax = pct_90), fill = "lightgreen") +
    geom_ribbon(aes(ymin = pct_90, ymax = pct_95), fill = "seagreen3") +
    geom_line(aes(y = pct_5), color = "red", size = 0.5)  +
    geom_line(aes(y = pct_50), color = "yellow", size = 0.5)  +
    geom_line(aes(y = pct_95), color = "springgreen4", size = 0.5) +
    geom_point(aes(y = pct_5), color = "red",  shape = 19, size = 2)  +
    geom_point(aes(y = pct_50), color = "yellow", shape = 15, size = 2)  +
    geom_point(aes(y = pct_95), color = "springgreen4",
               fill = "springgreen4", shape = 23, size = 2) +
    geom_hline(aes(yintercept = full_90pct), linetype = "dashed", size = 1) +
    geom_text(aes(x = 2, y = capacity * 0.9 + 0.3, label = "90% Full")) +
    scale_x_discrete(expand = c(0, 0.1)) +
    scale_y_continuous(limits = c(0, capacity), expand = c(0, 0)) +
    xlab("Month") +
    ylab("Storage  (BG)") +
    theme_classic()

  final.plot <- suppressMessages(ggplotly())
  final.plot$elementId <- NULL
  return(final.plot)
  
})

