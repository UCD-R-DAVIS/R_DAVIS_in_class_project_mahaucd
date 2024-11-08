# Loading packages
library(tidyverse)
library(ggthemes)

# Loading data and looking at structure
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv") 
str(gapminder)

# Problem 1 ----
# Grouping by continent and year, creating new column that is average life 
# expectancy, plotting line plot where x is year, y is mean life expectancy,
# and lines are colored by continent; setting theme
gapminder %>% group_by(continent, year) %>% summarise(meanLifeExp = mean(lifeExp)) %>% 
  ggplot(aes(x = year, y = meanLifeExp, color = continent)) +
  geom_line() + 
  geom_point() +
  ggtitle("Average Life Expectancy 1952-2007") +
  labs(x = "Year", y = "Average Life Expectancy (years)") + theme_bw()


# Problem 2 ----
# It is transforming the x values by taking the log of said values.  This is 
# done to ensure that values are more easily observable in the plot.
# Geom smooth adds the black line and is a way to point out a trend in the data.
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  theme_bw()
?scale_x_log10

# Problem 3 ----
# Filter for five countries, then plot boxplot, add jitter, and add labels
gapminder %>% filter(country == "Brazil" | country == "China" | country == "Niger" |
                       country == "El Salvador" | country == "United States") %>% 
  ggplot(aes(x = country, y = lifeExp)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "green") + 
  theme_bw() +
  labs(x = "Country", y = "Life Expectancy", title = "Life Expectancy of Five Countries")
  
