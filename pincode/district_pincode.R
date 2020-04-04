setwd("G:\\My Drive\\Projects\\COVID_INDIA\\pincode")

df <- read.csv("pincode_data.csv")
df$dist_pin3 <- substr(df$pincode,0,3) 
df$dist_pin4 <- substr(df$pincode,0,5)

df <- df %>% select(statename, Districtname) %>% unique() %>% group_by(Districtname) %>% mutate(cnt = n())
