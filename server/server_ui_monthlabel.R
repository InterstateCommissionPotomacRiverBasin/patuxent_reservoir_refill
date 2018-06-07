output$w1output <- renderUI({
    monthlabel1 <- (month.abb[monthly.rec()$month[1]])
    sliderInput('w1', monthlabel1, 10, 100, input$withdrawal_slider)
})

output$w2output <- renderUI({
  monthlabel2 <- (month.abb[monthly.rec()$month[2]])
  sliderInput('w2', monthlabel2, 10, 100, input$withdrawal_slider)
})

output$w3output <- renderUI({
  monthlabel3 <- (month.abb[monthly.rec()$month[3]])
  sliderInput('w3', monthlabel3, 10, 100, input$withdrawal_slider)
})

output$w4output <- renderUI({
  monthlabel4 <- (month.abb[monthly.rec()$month[4]])
  sliderInput('w4', monthlabel4, 10, 100, input$withdrawal_slider)
})

output$w5output <- renderUI({
  monthlabel5 <- (month.abb[monthly.rec()$month[5]])
  sliderInput('w5', monthlabel5, 10, 100, input$withdrawal_slider)
})

output$w6output <- renderUI({
  monthlabel6 <- (month.abb[monthly.rec()$month[6]])
  sliderInput('w6', monthlabel6, 10, 100, input$withdrawal_slider)
})

output$w7output <- renderUI({
  monthlabel7 <- (month.abb[monthly.rec()$month[7]])
  sliderInput('w7', monthlabel7, 10, 100, input$withdrawal_slider)
})

output$w8output <- renderUI({
  monthlabel8 <- (month.abb[monthly.rec()$month[8]])
  sliderInput('w8', monthlabel8, 10, 100, input$withdrawal_slider)
})

output$w9output <- renderUI({
  monthlabel9 <- (month.abb[monthly.rec()$month[9]])
  sliderInput('w9', monthlabel9, 10, 100, input$withdrawal_slider)
})

output$w10output <- renderUI({
  monthlabel10 <- (month.abb[monthly.rec()$month[10]])
  sliderInput('w10', monthlabel10, 10, 100, input$withdrawal_slider)
})

output$w11output <- renderUI({
  monthlabel11 <- (month.abb[monthly.rec()$month[11]])
  sliderInput('w11', monthlabel11, 10, 100, input$withdrawal_slider)
})

output$w12output <- renderUI({
  monthlabel12 <- (month.abb[monthly.rec()$month[12]])
  sliderInput('w12', monthlabel12, 10, 100, input$withdrawal_slider)
})
# output$updatedslider<- renderUI({
#   #monthlabel3 <- (month.abb[monthly.rec()$month[3]])
#   sliderInput("withdrawal_slider", "*Monthly withdrawals  MGD)*", 10, 100, ave_withdrawal)
# })

