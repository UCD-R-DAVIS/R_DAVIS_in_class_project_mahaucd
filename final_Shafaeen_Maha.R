# Reading in necessary packages
library(dplyr)
library(ggplot2)
library(ggthemes)

# Problem 1 ----
# Reading in data
data = read.csv("https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv")

# Problem 2 - 7 ----
df = data %>% 
  filter(sport == "running" & 
           minutes_per_mile <= 10 &
           minutes_per_mile >= 5) %>% 
  mutate(time_period = case_when(year < 2024 ~ "Pre-2024",
                                 year == 2024 & month <= 6 ~ "Jan to June 2024",
                                 year == 2024 & month > 6 ~ "July to Dec 2024"),
         Speed = total_distance_m / (total_elapsed_time_s / 60)) 
df %>% 
  ggplot(aes(x = steps_per_minute, y = Speed, color = time_period)) +
  geom_point() +
  geom_smooth(col = "black")+
  facet_wrap(~ time_period, ncol = 1) +
  ylab("Steps per Minute") + 
  xlab("Speed (M per Minute)") + theme_pander() +
  scale_color_brewer(palette = "Set2") + 
  labs(colour = "Time Period") 

# Problem 8 ----
# As Tyler gets tired, indicated by slower speeds, he also takes fewer steps per 
# minute, indicating that this relationship persists.  

df %>% mutate(Lap = rank(timestamp), .by = c(month, day, year)) %>% 
  filter(Lap <= 3) %>% 
  ggplot(aes(x = steps_per_minute, y = Speed, color = as.character(Lap))) +
  geom_point() +
  geom_smooth(col = "black")+
  facet_wrap(~ Lap, ncol = 1) +
  ylab("Steps per Minute") + 
  xlab("Speed (M per Minute)") + theme_pander() +
  scale_color_brewer(palette = "Set2") + 
  labs(colour = "Lap") 

# As Tyler gets tired, indicated by later laps, he seems to be taking fewer steps
# per minute at slower speeds than in earlier laps.  However the relationship
# does not appear to break down as the trends appear to be similar to before.
