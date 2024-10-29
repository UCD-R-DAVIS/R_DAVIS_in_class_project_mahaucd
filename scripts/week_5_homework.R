# Loading library
library(tidyverse)
# Problem 1 ----
# Reading in data
surveys = read_csv("./data/portal_data_joined.csv")
# Getting help page for pivot_wider function
?pivot_wider
# Filtering for non-NA hindfoot length values, grouping by genus and plot_type,
# finding mean hindfoot length, widening resulting data by making plot_type 
# column names, filling in values with meanHindfoot variable, and arranging by 
# control column values
surveys_wide = surveys %>% filter(!is.na(hindfoot_length)) %>% 
  group_by(genus, plot_type) %>% 
  summarise(meanHindfoot = mean(hindfoot_length)) %>% 
  pivot_wider(names_from = "plot_type", values_from = "meanHindfoot") %>% 
  arrange(Control)


# Problem 2 ----
# Getting summary of weight column to determine quartiles values
summary(surveys$weight)
# Creating weight_cat column where weights less than or equal to first quartile
# are small, between the first and third quartiles are medium, and other are 
# large using case_when() function
surveys %>% mutate(weight_cat = case_when(weight <= 20 ~ "small",
                                          weight > 20 & weight < 48 ~ "medium",
                                          weight >= 48 ~ "large"
))

# Using nested ifelse statement to do the same as above using base r
surveys$weight_cat = ifelse(surveys$weight <= 20, "small", 
                            ifelse(surveys$weight >= 48, "large", "medium"))

# Both ways treat NAs similarly where existing NAs remain NA and values
# that meet the conditions are changed accordingly.

# Bonus ----
# Soft coding quartile values
ifelse(surveys$weight <= summary(surveys$weight)["1st Qu."], "small", 
       ifelse(surveys$weight >= summary(surveys$weight)["3rd Qu."][1], "large",
              "medium"))

