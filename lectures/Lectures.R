# Lecture 2 ----

# getwd()
# setwd()
# dir.create("./lectures")

num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
combined_logical <- c(num_logical, char_logical)






# Lecture 3 ----
treatment <- factor(c("high", "low", "low", "medium", "high"))
treatment = factor(treatment, levels = c("low", "medium", "high"))
levels(treatment) = c("L", "M", "H")
treatment

library(tidyverse)
t_surveys = read_csv("data/portal_data_joined.csv")
class(t_surveys)
t_surveys




# Lecture 4 ----

#learning dplyr and tidyr: select, filter, and pipes
#only do this once ever:
# install.packages(
#We've learned bracket subsetting
#It can be hard to read and prone to error
#dplyr is great for data table manipulation!
#tidyr helps you switch between data formats

#Packages in R are collections of additional functions
#tidyverse is an "umbrella package" that
#includes several packages we'll use this quarter:
#tidyr, dplyr, ggplot2, tibble, etc.

#benefits of tidyverse
#1. Predictable results (base R functionality can vary by data type) 
#2. Good for new learners, because syntax is consistent. 
#3. Avoids hidden arguments and default settings of base R functions

#To load the package type:
library(dplyr)
#now let's work with a survey dataset
surveys <- read_csv("data/portal_data_joined.csv")

str(surveys)

#select columns
month_day_year <- select(surveys, month, day, year)

#filtering by equals
year_1981 <- filter(surveys, year == 1981)
sum(year_1981$year != 1981, na.rm = T)

#filtering by range
the80s = surveys[surveys$year %in% 1981:1983]
the80stidy = filter(surveys, year %in% 1981:1983)
#5033 results

#review: why should you NEVER do:
the80srecycle = filter(surveys, year == c(1981:1983)) # errrrrorrrrrrr
#1685 results

#This recycles the vector 
#(index-matching, not bucket-matching)
#If you ever really need to do that for some reason,
#comment it ~very~ clearly and explain why you're 
#recycling!

#filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length > 40 & !is.na(weight))

#multi-step process
small_animals <- filter(surveys, weight < 5)
#this is slightly dangerous because you have to remember 
#to select from small_animals, not surveys in the next step
small_animal_ids <- select(small_animals, record_id, plot_id, species_id)
                           
#same process, using nested functions
small_animal_ids <- select(filter(surveys, weight < 5), record_id, plot_id, species_id)
  
#same process, using a pipe
#Cmd Shift M
#or |>
#note our select function no longer explicitly calls the tibble
#as its first element
small_animal_ids <- filter(surveys, weight < 5) %>% 
  select(record_id, plot_id, species_id)

#same as
small_animal_ids <- surveys %>% filter(., weight < 5) %>% 
  select(record_id, plot_id, species_id)
  
#how to do line breaks with pipes
surveys %>% filter(month == 1) 

#good:
surveys %>% 
  filter(month==1)

#not good:
surveys 
%>% filter(month==1)
#what happened here?

#line break rules: after open parenthesis, pipe,
#commas, 
#or anything that shows the line is not complete yet

#check out cute_rodent_photos!
#will be updated throughout the quarter
#as a bonus for checking out these videos
#and visiting the code demos on my repository

#one final review of an important concept we learned last week
#applied to the tidyverse

mini <- surveys[190:209,]
table(mini$species_id)
#how many rows have a species ID that's either DM or NL?
nrow(mini)


mini %>% filter(species_id %in% c("DM", "NL"))


# Adding a new column
# mutate: adds a new column
surveys <- surveys %>%
  mutate(weight_kg = weight/1000)

# Add other columns
surveys <- surveys %>%
  mutate(weight_kg = weight/1000, weight_kg2 = weight_kg * 2)


# Filter out the NA's
ave_weight = surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(mean_weight = mean(weight))
  
ave_weight = ave_weight %>% filter(complete.cases())  

# Group_by and summarize 
# A lot of data manipulation requires us to split the data into groups, apply 
# some analysis to each group, and then combine the results
# group_by and summarize functions are often used together to do this
# group_by works for columns with categorical variables 
# we can calculate mean by certain groups
surveys %>%
  group_by(sex) %>%
  mutate(mean_weight = mean(weight, na.rm = TRUE)) 


# multiple groups
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))


# remove na's


# sort/arrange order a certain way


surveys %>% mutate(hindfoot_half = hindfoot_length / 2)

# Challenge
#What was the weight of the heaviest animal measured in each year? 
# Return a table with three columns: year, weight of the heaviest animal in grams, 
# and weight in kilograms, arranged (arrange()) in descending order, from heaviest to lightest. 
# (This table should have 26 rows, one for each year)


#Try out a new function, count(). Group the data by sex and pipe the grouped data into the count() function. How could you get the same result using group_by() and summarize()? Hint: see ?n.

# Lecture 5 ----


# Conditional statements 
## ifelse: run a test, if true do this, if false do this other thing
## case_when: basically multiple ifelse statements
# can be helpful to write "psuedo-code" first which basically is writing out what steps you want to take & then do the actual coding
# great way to classify and reclassify data

## Load library and data
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

## ifelse() 
# from base R
# ifelse(test, what to do if yes/true, what to do if no/false)
## if yes or no are too short, their elements are recycled
## missing values in test give missing values in the result
## ifelse() strips attributes: this is important when working with Dates and factors
surveys$hindfoot_cat = ifelse(surveys$hindfoot_length < mean(surveys$hindfoot_length,na.rm = T),
                              yes ="small", no = "big")
                              


## case_when()
# GREAT helpfile with examples!
# from tidyverse so have to use within mutate()
# useful if you have multiple tests
## each case evaluated sequentially & first match determines corresponding value in the output vector
## if no cases match then values go into the "else" category

# case_when() equivalent of what we wrote in the ifelse function
surveys %>%
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 29.29 ~ "big", 
    TRUE ~ "small"
  )) %>%
  select(hindfoot_length, hindfoot_cat) %>%
  head()

# but there is one BIG difference - what is it?? (hint: NAs)
table(hindfoot_cat)
surveys %>%
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 31.5 ~ "big", 
    hindfoot_length > 29 ~ "medium",
    is.na(hindfoot_length) ~ NA_character_,
    TRUE ~ "small"
  )) %>%
  select(hindfoot_length, hindfoot_cat) %>%
  head()


# if no "else" category specified, then the output will be NA


# lots of other ways to specify cases in case_when and ifelse
surveys %>%
  mutate(favorites = case_when(
    year < 1990 & hindfoot_length > 29.29 ~ "number1", 
    species_id %in% c("NL", "DM", "PF", "PE") ~ "number2",
    month == 4 ~ "number3",
    TRUE ~ "other"
  )) %>%
  group_by(favorites) %>%
  tally()
?tally



tail = read_csv("data/tail_length.csv")
surveys = read_csv("data/portal_data_joined.csv")

dim(tail)
dim(surveys)
head(tail)

surveys_inner = inner_join(x = surveys, y = tail)
surveys_left = left_join(x = surveys, y = tail)
surveys_right = left_join(x = surveys, y = tail)
surveys_left_right_equivalent = left_join(x = tail, y = surveys)
surveys_full = full_join(x = surveys, y = tail)

tail

dim(surveys_inner)
head(surveys_inner)

all(surveys$record_id %in% tail$record_id)
all(tail$record_id %in% surveys$record_id)

# Lecture 6 ----
# ggplot2
## Grammar of Graphics plotting package (included in tidyverse package - you can see this when you call library(tidyverse)!)
## easy to use functions to produce pretty plots
## ?ggplot2 will take you to the package helpfile where there is a link to the website: https://ggplot2.tidyverse.org - this is where you'll find the cheatsheet with visuals of what the package can do!

## ggplot basics
## every plot can be made from these three components: data, the coordinate system (ie what gets mapped), and the geoms (how to graphical represent the data)
## Syntax: ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPING>))

## tips and tricks
## think about the type of data and how many data  variables you are working with -- is it continuous, categorical, a combo of both? is it just one variable or three? this will help you settle on what type of geom you want to plot
## order matters! ggplot works by layering each geom on top of the other
## also aesthetics like color & size of text matters! make your plots accessible 


## example
library(tidyverse)
## load in data
surveys <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) # remove all NA's

## Let's look at two continuous variables: weight & hindfoot length
## Specific geom settings
ggplot(surveys, aes(x = weight, y = hindfoot_length, color = genus)) +
  geom_point() + 
  geom_smooth()

## Universal geom settings








## Visualize weight categories and the range of hindfoot lengths in each group
## Bonus from hw: 
sum_weight <- summary(surveys$weight)
surveys_wt_cat <- surveys %>% 
  mutate(weight_cat = case_when(
    weight <= sum_weight[[2]] ~ "small", 
    weight > sum_weight[[2]] & weight < sum_weight[[5]] ~ "medium",
    weight >= sum_weight[[5]] ~ "large"
  )) 

table(surveys_wt_cat$weight_cat)


## We have one categorical variable and one continuous variable - what type of plot is best?




## What if I want to switch order of weight_cat? factor!
# Lecture 8 ----
library(lubridate)
seq(mdy("01-01-2020"), mdy("10-01-2020"), 1)
mdy("01-01-2020") - months(2)
decimal_date(mdy("10-01-2020"))
date_decimal(decimal_date(mdy("10-01-2020")))


library(gapminder)
d <- gapminder::gapminder

plotCountry = function(data, Country) {
  g = data %>% filter(country == Country) %>% 
  ggplot(aes(x = year, y = pop)) +
  geom_point() +
  theme_solarized() +
  xlab("Population") + ylab("Year") + 
  ggtitle(("Population Over Time"))
  return(g)
}

plotCountry(d, "Afghanistan")

# Lecture 9 ----
