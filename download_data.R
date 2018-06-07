today_is <- as.Date("2018-06-01", "%Y-%m-%d")  #input variable (to be)
website <- "https://nwis.waterdata.usgs.gov/usa/nwis/uv/"
 parameter <- "00060"
site_number <- "01591000"
ini_start_month <- ceiling_date(today_is - years(11), "month")
print(ini_start_month)
start_date <- as.character(ini_start_month)
print(start_date)
end_date <- as.character(today_is)
print(end_date)
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
pull.df <- read.csv(url(link), skip = 30, sep = "\t")
write.csv(pull.df,'data/pull_df.csv')