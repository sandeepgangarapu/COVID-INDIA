library(taskscheduleR)
test <- file.path("G:\\My Drive\\Projects\\COVID_INDIA\\daily_india_data.R")


taskscheduler_create(taskname = "india_data", rscript = test,
                     schedule = "HOURLY", starttime = "00:12", startdate = format(as.Date("2020-03-25"), "%m/%d/%Y"))
