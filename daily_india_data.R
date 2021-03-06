library(jsonlite)
library(dplyr)
library(tidyr)
library(lubridate)
library(aws.s3)
source("amazon_creds.R")

setwd("G:\\My Drive\\Projects\\COVID_INDIA")

covid_data <- fromJSON("https://api.covid19india.org/raw_data.json")[[1]]
pincode_data <- read.csv("pincode_data.csv") %>% drop_na() 
state_code_data <-read.csv("state_code_data.csv")

mywrite <- function(x, file) {
  write.csv(x, file, row.names=FALSE)
}
today_date <- as.Date(Sys.Date(), "%y%m%d/")


df <- covid_data %>% group_by(detecteddistrict, detectedstate, currentstatus) %>% summarise(cnt = n()) %>% ungroup()
df <- df[2:dim(df)[1],]
df <- df %>%  pivot_wider(names_from = currentstatus, values_from = cnt, values_fill=list(cnt = 0)) %>%
  rename(district = detecteddistrict, state = detectedstate) %>% select(state, district, Hospitalized,Deceased, Recovered)%>%
  mutate(Date = as.Date(Sys.Date())) 

# STATE LEVEL COVID DATA


state_level_data <- df %>% select(-c(district, Date)) %>% group_by(state) %>% summarise_all(funs(sum)) %>% ungroup() %>%
  merge(state_code_data, by.x=c("state"), by.y=c("state"))  %>% mutate(State=code) %>% select(-c(code, state))

write.csv(state_level_data,  paste("./log/state", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(state_level_data, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "state")

# PINCODE LEVEL COVID DATA

final_data <- merge(pincode_data, df, by.x=c("Districtname"), by.y=c("district")) 
final_data <- merge(final_data, state_code_data, by.x=c("state"), by.y=c("state")) %>% 
select(pincode, code, Districtname, Hospitalized, Deceased, Recovered) %>% 
  rename(Pincode = pincode, State = code, District = Districtname) 

write.csv(final_data, paste("./log/district", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(final_data, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "district")

