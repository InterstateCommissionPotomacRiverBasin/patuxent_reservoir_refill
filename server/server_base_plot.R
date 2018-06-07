output$base_plot <- renderPlot({
  percentile.df <- percentile.rec()
  capacity <- input$capacity
  dead_storage <- input$dead_storage
  
  plot(
    1:12,
    percentile.df[1, 1:12],
    type = "l",
    xlim = range(1:12),
    ylim = range(0:11),
    xaxs = "i",
    yaxs = "i",
    xlab = "Month",
    ylab = "Storage (BG)",
    axes = FALSE,
    frame.plot = TRUE
  )
  polygon(c(1:12, 12:1),
          c(rep(0, 12), rep(dead_storage, 12)),
          col = "rosybrown",
          border = NA)
  polygon(c(1:12, 12:1),
          c(rep(dead_storage, 12), rep(capacity, 12)),
          col = "lightblue",
          border = NA)
  
  #polygon(c(1:12,12:1),c(rep(capacity,12),rep(11,12)),col="grey",border=NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[1, ], rev(percentile.df[2, ])),
          col = "indianred1",
          border = NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[2, ], rev(percentile.df[3, ])),
          col = "lightpink",
          border = NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[3, ], rev(percentile.df[4, ])),
          col = "rosybrown1",
          border = NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[4, ], rev(percentile.df[5, ])),
          col = "moccasin",
          border = NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[5, ], rev(percentile.df[6, ])),
          col = "lightgreen",
          border = NA)
  polygon(c(1:12, 12:1),
          c(percentile.df[6, ], rev(percentile.df[7, ])),
          col = "seagreen3",
          border = NA)
  
  #polygon(c(1:12,12:1),c(percentile.df[1,],rev(percentile.df[3,])),col="skyblue",border=NA)
  lines(
    1:12,
    (c(rep(capacity * 0.9, 12))),
    lty = 2,
    lwd = 1,
    cex = 1.2,
    col = "black"
  )
  #lines(1:12,(percentile.df[4,1:12]),lty=1,lwd=2,col="orange", type="b", pch=18, cex=2)
  
  lines(
    1:12,
    (percentile.df[4, 1:12]),
    lty = 1,
    lwd = 2,
    col = "yellow",
    type = "b",
    pch = 15,
    cex = 1.5
  )
  lines(
    1:12,
    (percentile.df[7, 1:12]),
    lty = 1,
    lwd = 2,
    col = "springgreen4",
    type = "b",
    pch = 23,
    cex = 1.5
  )
  lines(
    1:12,
    (percentile.df[1, 1:12]),
    lty = 1,
    lwd = 2,
    type = "b",
    pch = 19,
    cex = 1.2,
    col = "red"
  )
  
  
  legend(
    "bottomright",
    inset = .04,
    legend = c("95th", "50th", "5th"),
    col = c("green", "yellow", "red"),
    lty = 1:1,
    cex = 1.2
  )
  axis(1, at = 1:12, labels = month.abb[monthly.rec()$month])
  axis(2, labels = TRUE)
  #text(2.6, 0.5, "Emergency storage")
  text(2.5, 8.9, "90% full")
})

