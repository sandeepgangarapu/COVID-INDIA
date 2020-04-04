


# library(jsonlite)
# library(dplyr)
# library(tidyr)
# setwd("G:\\My Drive\\Projects\\COVID_INDIA\\pincode")
#
# pin <- read.csv("pincode_data.csv") %>% drop_na()
# #pin$Districtname <- str_replace(pin$Districtname, " ", "")
# #pin$Districtname <- tolower(pin$Districtname)
#
# state <-read.csv("state.csv")
# setwd("G:\\My Drive\\Projects\\COVID_INDIA")
#
# today_date <- as.Date(Sys.Date(), "%y%m%d/")
#
# ind_data <- fromJSON("https://api.covid19india.org/raw_data.json")[[1]]
#
# df <- ind_data %>% group_by(detecteddistrict, detectedstate, currentstatus) %>% summarise(cnt = n()) %>% ungroup()
# df <- df[2:dim(df)[1],]
# df <- df %>%  pivot_wider(names_from = currentstatus, values_from = cnt, values_fill=list(cnt = 0)) %>%
#   rename(district = detecteddistrict, state = detectedstate) %>% select(state, district, Hospitalized,Deceased, Recovered)%>%
#   mutate(Date = as.Date(Sys.Date()))
#
#
# state_level_data <- df %>% select(-c(district, Date)) %>% group_by(state) %>% summarise_all(funs(sum)) %>% ungroup() %>%
#   merge( state, by.x=c("state"), by.y=c("state"))  %>% mutate(State=code) %>% select(-code)
#
# write.csv(state_level_data, paste("state", today_date, ".csv", sep=""), row.names = FALSE)
#
# #df$district <- str_replace(df$district, " ", "")
# #df$district <- tolower(df$district)
#
#
# final_data <- merge(pin, df, by.x=c("Districtname"), by.y=c("district"))
# final_data <- merge(final_data, state, by.x=c("state"), by.y=c("state")) %>%
# select(pincode, code, Districtname, Hospitalized, Deceased, Recovered) %>%
#   rename(Pincode = pincode, State = code, District = Districtname, Deaths = Deceased)
#
# state_data <- final_data%>% group_by(State, District) %>%
#   summarise(S_Hospitalized = first(Hospitalized),
#          S_Deaths = first(Deaths),
#          S_Recovered = first(Recovered)) %>% group_by(State) %>%
#   summarise(S_Hospitalized = sum(S_Hospitalized),
#             S_Deaths = sum(S_Deaths),
#             S_Recovered = sum(S_Recovered))
#
# final_data <- merge(final_data, state_data, by.x=c("State"), by.y=c("State"))
#
# final_data$C_Hospitalized <- sum(state_data$S_Hospitalized)
# final_data$C_Deaths <- sum(state_data$S_Deaths)
# final_data$C_Recovered <- sum(state_data$S_Recovered)
#
# write.csv(final_data, paste("district", today_date, ".csv",sep=""), row.names = FALSE)
#
