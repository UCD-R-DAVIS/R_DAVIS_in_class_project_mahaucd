# Loading packages
library(tidyverse)
library(ggthemes)

# Loading data and looking at structure
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv") 
str(gapminder)

# Filtering for years and continent, selecting columns of interest, pivoting to
# make 2002 and 2007 columns, finding difference in population
gapminder = gapminder %>% 
  filter(year >= 2002 & year <= 2007 & continent != "Oceania") %>% 
  select(country, year, pop, continent) %>% 
  pivot_wider(names_from = 'year', values_from = "pop") %>% 
  mutate(dif = `2007` - `2002`)

# Setting y axis as difference, ordereing countries by value, and coloring
# facets by continent; changing theme, fixing label rotations, adding titles,
# and choosing colors for each facet
gapminder %>% ggplot(aes(y = dif, x = reorder(country, dif), fill = continent)) +
  geom_col() +
  facet_wrap(~continent, scales = "free") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position = "none") +
  labs(x = "Country", y = "Change in Population Between 2002 and 2007") +
  scale_fill_manual(values=c("#440154FF","#2A788EFF","#22A884FF","#FDE725FF"))

?scale_x_reverse
