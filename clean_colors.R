library(nmisc)
library(dplyr)
library(readr)

color_data <- read_csv("colors_by_county.csv", col_names = F) %>% 
  rename(county_path = X1, color = X2) %>% 
  mutate(county_path = gsub("/Users/Nick/dev/us-of-color/photos/", "", county_path)) %>% 
  mutate(county_path = gsub("-", " ", county_path)) %>% 
  mutate(county_path = tolower(trimws(gsub("County|Parish|Census Area|City and Borough", "", county_path)))) %>% 
  separate(county_path, c("county", "state"), sep = "_") %>% 
  mutate(county = trimws(county)) 

fips_codes <- read.csv("US_FIPS_Codes.csv", skip = 1, stringsAsFactors = F) %>% 
  mutate(state = tolower(trimws(State)), county = tolower(trimws(County.Name))) %>% 
  mutate(state = trimws(state), county = trimws(county)) %>% 
  mutate(county = gsub("county|parish|census area|city|borough", "", county)) %>% 
  select(-State, -County.Name, -X)

merged <- color_data %>% 
  full_join(fips_codes, by = c("county", "state")) %>% 
  mutate(id = paste0(FIPS.State, FIPS.County)) %>% 
  na.omit()

write_csv(merged, "counties_with_colors.csv")


sum(color_data$color == "rgb(0,0,0)")
