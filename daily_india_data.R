library(jsonlite)
library(dplyr)
library(tidyr)
library(lubridate)
library(aws.s3)
library(rvest)


setwd("G:\\My Drive\\Projects\\COVID_INDIA")
source("amazon_creds.R")

covid_data <- fromJSON("https://api.covid19india.org/raw_data.json")[[1]]
state_code_data <-read.csv("state_code_data.csv") %>% rename(State = state)

pincode_data <- read.csv("./pincode/pincode_cleaned.csv", stringsAsFactors = TRUE) %>% drop_na() 
write.csv(pincode_data %>% select(District) %>% unique(), "district1.csv")
write.csv(covid_data %>% select(detecteddistrict) %>% unique(), "district2.csv")

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

df <- df %>%
  mutate(Confirmed = as.numeric(Confirmed), Recovered=as.numeric(Recovered), Deceased=as.numeric(Deceased)) %>% drop_na()
df[df$State=="Telengana","State"] <- "Telangana"
state_data_mohw <- df %>% 
  merge(state_code_data, by.x=c("State"), by.y=c("State")) %>%
  mutate(Confirmed = as.numeric(Confirmed), Recovered=as.numeric(Recovered), Deceased=as.numeric(Deceased)) %>% 
  mutate(Hospitalized = as.numeric(Confirmed)-(as.numeric(Recovered)+as.numeric(Deceased))) %>%
  select(-State) %>%
  mutate(State=code) %>%
  select(-c(code, Confirmed))

write.csv(state_data_mohw,  paste("./log/state_mohw", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(state_data_mohw, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "state_mohw")

Confirmed <- sum(df$Confirmed)
Recovered <- sum(df$Recovered)
Deceased <- sum(df$Deceased)
Hospitalized = as.numeric(Confirmed)-(as.numeric(Recovered)+as.numeric(Deceased))
country_data_mohw <- data.frame(Hospitalized, Recovered, Deceased)
write.csv(country_data_mohw,  paste("./log/country_mohw", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(country_data_mohw, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "country_mohw")

# ----------------------------------------------------------------------------------------





df <- covid_data %>% group_by(detecteddistrict, detectedstate, currentstatus) %>% summarise(cnt = n()) %>% ungroup()
df <- df[2:dim(df)[1],]
df <- df %>%  pivot_wider(names_from = currentstatus, values_from = cnt, values_fill=list(cnt = 0)) %>%
  rename(District = detecteddistrict, State = detectedstate) %>% select(State, District, Hospitalized,Deceased, Recovered)%>%
  mutate(Date = as.Date(Sys.Date())) 

# COUNTRY LEVEL COVID DATA

country_level_data <- df %>% select(-c(District, Date, State)) %>% summarise_all(funs(sum))

write.csv(country_level_data,  paste("./log/country", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(country_level_data, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "country")

# STATE LEVEL COVID DATA


state_level_data <- df %>% select(-c(District, Date)) %>% group_by(State) %>% summarise_all(funs(sum)) %>% ungroup() %>%
  merge(state_code_data, by.x=c("State"), by.y=c("State"))  %>% mutate(State=code) %>% select(-c(code))

write.csv(state_level_data,  paste("./log/state", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(state_level_data, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "state")



# PINCODE LEVEL COVID DATA

final_data <- merge(pincode_data, df, by.x=c("District"), by.y=c("District")) %>% rename(State=State.x)


final_data <- merge(final_data, state_code_data, by.x=c("State"), by.y=c("State")) %>% 
select(Pincode, code, District, Hospitalized, Deceased, Recovered) %>% 
  rename(State = code) 


# # ----------------------------------------------------------------------------------------
# # Pincode debug
# 
# pin_sub <- unique(pincode_data$Districtname)
# covid_sub <- unique(df$district)
# final_sub <- unique(final_data$District)
# 
# 
# diff1 <- setdiff(covid_sub, final_sub)
# diff2 <- setdiff(pin_sub, final_sub)
# 
# 
# dist.name<-adist(diff1,diff2, partial = TRUE, ignore.case = TRUE)
# 
# # We now take the pairs with the minimum distance
# min.name<-apply(dist.name, 1, min)
# 
# match.s1.s2<-NULL  
# for(i in 1:nrow(dist.name))
# {
#   s2.i<-match(min.name[i],dist.name[i,])
#   s1.i<-i
#   match.s1.s2<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=diff2[s2.i,], s1name=diff1[s1.i,], adist=min.name[i]),match.s1.s2)
# }
# # and we then can have a look at the results
# View(match.s1.s2)


# ----------------------------------------------------------------------------------------

write.csv(final_data, paste("./log/district", today_date,"_", hour(Sys.time()), ".csv",sep=""), row.names = FALSE)

s3write_using(final_data, FUN = mywrite,
              bucket = "coronadailyupdates",
              object = "district")

