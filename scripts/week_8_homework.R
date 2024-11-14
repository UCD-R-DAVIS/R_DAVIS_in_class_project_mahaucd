# Loading packages
library(tidyverse)
library(lubridate)
library(ggplot2)

# Reading in data and looking at structure
mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
str(mloa)

# data format according to README: yyyy mm dd hh in UTC

# filter out na values as per README, and create new date column with appropriate
# separators in UTC timezone as per README
mloa = mloa %>% filter(rel_humid != -99 & temp_C_2m != -999.9 & windSpeed_m_s != -999.9) %>% 
  mutate(datetime = ymd_hm(paste(year,"-", month, "-", day, " ", hour24, ":", min), tz = "UTC"))

# Create new column where date time is now in Pacific/Honolulu time
mloa$datetimeLocal = with_tz(mloa$datetime, tz = "Pacific/Honolulu")

# Group by month and hour and calculate average temperature;
# make a scatter plot where x is month, y is average temp, and 
# points are colored by hour
mloa %>% group_by(month(datetimeLocal, label = T), hour(datetimeLocal)) %>% 
  summarise(avgTemp = mean(temp_C_2m)) %>% rename(Month = 1, Hour = 2) %>% 
  ggplot(aes(x = Month, y = avgTemp, color = Hour)) +
  geom_point() + 
  ylab("Mean Hourly Temperature 2 Meters Above Ground (Celsius)") +
  theme_bw() +
  scale_color_continuous()
