# Loading in library
library(tidyverse)
# Problem 1 ----
# Reading in survey data
surveys = read_csv("data/portal_data_joined.csv")

# Problem 2 ----
# Filtering by weight and selecting first six values to display
surveys %>% filter(weight > 30 & weight < 60) %>% head(n = 6)

# Problem 3 ----
# Filtering to get rid of na weight values and grouping by sex and species
# to get max weight
biggest_critters = surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species, sex) %>% 
  summarise(weightMax = max(weight))
?arrange
# Arranging weights in increasing order
biggest_critters %>% arrange(weightMax)
# Arranging weights in decreasing order
biggest_critters %>% arrange(desc(weightMax))
  
#Problem 4 ----
?tally

# It seems that the Harrisi species, rodent taxa, and 13 plot id have the largest number of weight nas
# Filtering for values where weight is na, grouping by columns, totaling 
#observations, and ordering in decreasing value
surveys %>% filter(is.na(weight)) %>% group_by(species) %>% tally() %>% 
  arrange(desc(n))

surveys %>% filter(is.na(weight)) %>% group_by(taxa) %>% tally() %>% arrange(desc(n))

surveys %>% filter(is.na(weight)) %>% group_by(plot_id) %>% tally() %>% arrange(desc(n))

# Problem 5 ----
# Filtering to get rid of na weight values and grouping by sex and species
# to create average weight column
surveys_avg_weight = surveys %>% filter(!is.na(weight)) %>% group_by(species, sex) %>% 
  mutate(meanWeight = mean(weight)) %>% select(species, sex, `weight`, meanWeight)


# Problem 6 ----
# Creating column with boolean values for if weight is bigger than average
surveys_avg_weight = surveys_avg_weight %>% mutate(above_average = weight > meanWeight)
