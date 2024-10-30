library(tidyverse)

# Problem 1 ----
log = read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv")

# Problem 2 ----
str(log)
unique(log$sport)
log = log %>% filter(sport == "running") %>% 
  filter(minutes_per_mile < 10 & minutes_per_mile > 5) %>% 
  filter(total_elapsed_time_s >= 60) %>%
  mutate(pace = case_when(minutes_per_mile < 6 ~ "fast",
                          minutes_per_mile >= 6 & minutes_per_mile <= 8 ~ "medium",
                          minutes_per_mile > 8 ~ "slow"),
         form = case_when(year == 2024 ~ "new",
                          T ~ "old")) 
log %>% group_by(form, pace) %>% 
  summarise(meanStepsPerMinute = mean(steps_per_minute)) %>% 
  pivot_wider(names_from = pace, values_from = meanStepsPerMinute) %>% 
  select(form, slow, medium, fast)

log %>% filter(form == "new") %>%
  mutate(month2024 = case_when(month <= 6 ~ "first half of year",
                               T ~ "second half of year")) %>% 
  group_by(month2024) %>% 
  summarise(minSTM = min(steps_per_minute),
            medSTM = median(steps_per_minute),
            meanSTM = mean(steps_per_minute),
            maxSTM = max(steps_per_minute))

