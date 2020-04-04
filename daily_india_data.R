library(jsonlite)
library(dplyr)
library(tidyr)
library(lubridate)
library(aws.s3)
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAIIH4JE5NMIPROCHA",
           "AWS_SECRET_ACCESS_KEY" = "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",
           "AWS_DEFAULT_REGION" = "ap-south-1")

setwd("G:\\My Drive\\Projects\\COVID_INDIA")

covid_data <- fromJSON("https://api.covid19india.org/raw_data.json")[[1]]
pincode_data <- read.csv("pincode_data.csv") %>% drop_na() 
state_code_data <-read.csv("state_code_data.csv")

mywrite <- function(x, file) {
  write.csv(x, file, row.names=FALSE)
}
today_date <- as.Date(Sys.Date(), "%y%m%d/")


# ----------------------------------------------------------------------------------------
# HTML Scraping of MOHFW website
# ----------------------------------------------------------------------------------------
mohw_url <- "https://www.mohfw.gov.in/"
html <- read_html(mohw_url) 
tbl_path = "//table[@class='table table-striped']"
tbl = html_nodes(html, xpath = tbl_path)[[1]]
df <- html_table(tbl)
df <- df[,c(2:5)]
colnames(df) <- c("State", "Confirmed", "Recovered", "Deceased")
state_data_mohw <- df %>% mutate(Hospitalized = Confirmed-(Recovered+Deceased)) %>%
  merge(state_code_data, by.x=c("State"), by.y=c("state")) %>%
  select(-State) %>%
  mutate(State=code) %>%
  select(-c(code, Confirmed))

write.csv(state_data_mohw,  paste("./log/state_mohw", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(state_data_mohw, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "state_mohw")

Confirmed <- max(df$Confirmed)
Recovered <- max(df$Recovered)
Deceased <- max(df$Deceased)
Hospitalized = Confirmed-(Recovered+Deceased)
country_data_mohw <- data.frame(Hospitalized, Recovered, Deceased)
write.csv(country_data_mohw,  paste("./log/country_mohw", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(country_data_mohw, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "country_mohw")

# ----------------------------------------------------------------------------------------





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

