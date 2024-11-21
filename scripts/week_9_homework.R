# Loading packages
library(tidyverse)
library(purrr)
# Reading in data
surveys <- read.csv("data/portal_data_joined.csv")
# Looking at structure of data
str(surveys)

# Problem 1 ----
# Creating for loop that take a unique taxa, filters the data based on said taxa
# selects max character length for distinct species for said taxa, and 
# prints it out
for(i in unique(surveys$taxa)){
  s = surveys[surveys$taxa == i,]
  l = s %>% select(taxa, species) %>% filter(taxa == i) %>% 
  select(species) %>% distinct() %>% mutate(charLen = nchar(species)) %>% 
  filter(charLen == max(charLen)) %>% select(species)
  print(paste("Longest species names for taxa", i, "are", l, sep = " "))
}


# Problem 2 ----
# Reading in data
mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
# Selecting columns and finding max value for all columns using map_dbl
mloa %>% select(windDir, windSpeed_m_s, baro_hPa, temp_C_2m, temp_C_10m, 
                temp_C_towertop, rel_humid, precip_intens_mm_hr) %>% 
  map_dbl(max)

# Problem 3 ----
# Creating function that takes celsius argument and returns converted 
# Fahrenheit value
C_to_F = function(c) {
  f = (1.8 * c) + 32
  return(f)
}

# Selecting three celsius columns, using map_df to get dataframe where
# all three columns are converted to fahrenheit, renaming all column names
# to replace C with F, attaching new columns back to original dataframe
mloa %>% select(temp_C_2m, temp_C_10m, temp_C_towertop) %>% map_df(C_to_F) %>% 
  rename_with(~ gsub("C", "F", .x, fixed = TRUE)) %>% cbind(mloa)

# Challenge ----
# Create new column called GenusSpecies using lapply function where for
# each entry, species and genus are being pasted together
surveys$GenusSpecies = lapply(1:dim(surveys)[1], function(x) {
  paste(surveys$genus[x], surveys$species[x], sep = " ")})