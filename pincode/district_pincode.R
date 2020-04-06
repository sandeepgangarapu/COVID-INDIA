setwd("G:\\My Drive\\Projects\\COVID_INDIA\\pincode")


df <- read.csv("new_pincode.csv") %>% rename(State = StateName)


# Telangana Districts

df$District[df$District=='Ananthapur'] <- Bhadradri Kothagudem
df$District[df$District=='Ananthapur'] <- Medchal Malkajgiri
df$District[df$District=='Ananthapur'] <- Warangal Urban
df$District[df$District=='Ananthapur'] <- Vikarabad
df$District[df$District=='Ananthapur'] <- Nirmal
df$District[df$District=='Ananthapur'] <- Sangareddy
df$District[df$District=='Ananthapur'] <- Peddapalli



df$District[df$District=='Ananthapur'] <- 'Anantapur'
df$District[df$District=='Kasargod'] <- 'Kasaragod'
df$District[df$District=='Gurgaon'] <- 'Gurugram'
df$District[df$District=='Kanchipuram'] <- 'Kancheepuram'
df$District[df$District=='Bangalore'] <- 'Bengaluru'
df$District[df$District=='Nellore'] <- 'S.P.S. Nellore'
df$District[df$District=='Gulbarga'] <- 'Kalaburagi'
df$District[df$District=='Ananthapur'] <- Ahmadnagar
df$District[df$District=='Khordh'] <- 'Khordha'
df$District[df$District=='Jhujhunu'] <- 'Jhunjhunu'
df$District[df$District=='Ananthapur'] <- Shahid Bhagat Singh Nagar
df$District[df$District=='Ropar'] <- 'S.A.S. Nagar'
df$District[df$District=='Ahmedabad'] <- 'Ahmadabad'
df$District[df$District=='Karim Nagar'] <- 'Karimnagar'
df$District[df$District=='Chikkaballapur'] <- 'Chikkaballapura'
df$District[df$District=='Gandhi Nagar'] <- 'Gandhinagar'
df$District[df$District=='Mysore'] <- 'Mysuru'
df$District[df$District=='Ananthapur'] <- Palwal
df$District[df$District=='Ananthapur'] <- Tiruppur
df$District[df$District=='K.V.Rangareddy'] <- 'Ranga Reddy'
df$District[df$District=='Bandipur'] <- 'Bandipore'
df$District[df$District=='Bilaspur(CGH)'] <- 'Bilaspur'
df$District[df$District=='Bagpat'] <- 'Baghpat'
df$District[df$District=='Rajauri'] <- 'Rajouri'
df$District[df$District=='North And Middle Andaman'] <- 'North and Middle Andaman'
df$District[df$District=='Gondia'] <- 'Gondiya'
df$District[df$District=='Tumkur'] <- 'Tumakuru'
df$District[df$District=='Ananthapur'] <- Shamli
df$District[df$District=='Davangere'] <- 'Davanagere'
df$District[df$District=='Ananthapur'] <- Chengalpattu
df$District[df$District=='Medinipur'] <- 'Medinipur East'
df$District[df$District=='Ananthapur'] <- Kalimpong
df$District[df$District=='Budgam'] <- 'Badgam'
df$District[df$District=='Ananthapur'] <- Baramula
df$District[df$District=='Ananthapur'] <- Buldana
df$District[df$District=='Ananthapur'] <- Gir Somnath
df$District[df$District=='Bellary'] <- 'Ballari'
df$District[df$District=='Villupuram'] <- 'Viluppuram'
df$District[df$District=='Kanyakumari'] <- 'Kanniyakumari'
df$District[df$District=='Tuticorin'] <- 'Thoothukkudi'
df$District[df$District=='Pondicherry'] <- 'Puducherry'
df$District[df$District=='Cuddapah'] <- 'Y.S.R.'
df$District[df$District=='Kamrup'] <- 'Kamrup Metropolitan'
df$District[df$District=='Ananthapur'] <- Tirupathur
df$District[df$District=='Tiruvarur'] <- 'Thiruvarur'
df$District[df$District=='Dholpur'] <- 'Dhaulpur'
df$District[df$District=='Ananthapur'] <- Ranipet
df$District[df$District=='Tiruvallur'] <- 'Thiruvallur'
df$District[df$District=='Hazaribag'] <- 'Hazaribagh'
df$District[df$District=='Bagalkot'] <- 'Bagalkote'
df$District[df$District=='Ananthapur'] <- Hapur
df$District[df$District=='Ananthapur'] <- Nuh
df$District[df$District=='Ananthapur'] <- South Salmara Mancachar
df$District[df$District=='Ananthapur'] <- Kashmir
df$District[df$District=='Belgaum'] <- 'Belagavi'
df$District[df$District=='Marigaon'] <- 'Morigaon'
df$District[df$District=='Bangalore Rural'] <- 'Bengaluru Rural'
df$District[df$District=='Ananthapur'] <- Kallakurichi
df$District[df$District=='Hathras'] <- 'Hatras'
df$District[df$District=='Udaipur'] <- 'Chota Udaipur'
df$District[df$District=='Nilgiris'] <- 'The Nilgiris'
df$District[df$District=='Raebareli'] <- 'Rae Bareli'
df$District[df$District=='Barabanki'] <- 'Bara Banki'

df$District[df$District=='Ananthapur'] <- Morbi
df$District[df$District=='Ananthapur'] <- Bhuj

# 
write.csv(df, "pincode_cleaned.csv", row.names = FALSE)
