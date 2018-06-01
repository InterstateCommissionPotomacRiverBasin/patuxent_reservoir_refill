today_is <- input$date_input

#get initialization months
ini_start_month <- ceiling_date(today_is - years(1), "month")
ini_months <- seq(ini_start_month, length=12, by="months")
df_ini_months <- data.frame(ini_months)
df_ini_months$end_months <- ceiling_date(df_ini_months$ini_months, "month") - days(1)

#get simulation months
sim_months <- seq(today_is, length=13, by = "months")
df_sim_months <- data.frame(sim_months)
df_sim_months$end_months <- ceiling_date(df_sim_months$sim_months, "month") - days(1)