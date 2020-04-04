library(taskscheduleR)
test <- file.path("G:\\My Drive\\Projects\\COVID_INDIA\\daily_cron\\daily_india_data.R")


taskscheduler_create(taskname = "india_data_time_series", rscript = test,
                     schedule = "DAILY", starttime = "22.00", startdate = format(as.Date("2020-03-30"), "%m/%d/%Y"))
