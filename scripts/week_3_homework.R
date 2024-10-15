# Problem 1 ----
# Reading in csv file and assigning to surveys variable
surveys = read.csv("./data/portal_data_joined.csv")

# Problem 2 ----
# Selecting first 5000 values and three columns of interest
surveys_base = surveys[1:5000, c("species_id", "weight", "plot_type")]

# Problem 3 ----
# Converting two variables to factors
surveys_base$species_id = factor(surveys_base$species_id)
surveys_base$plot_type = factor(surveys_base$plot_type)

# Problem 4 ----
# Selecting only rows where weight is not NA
surveys_base = surveys_base[!is.na(surveys_base$weight),]

# Problem 5 ----
# Calling for summary of each variable
summary(surveys_base)
str(surveys_base)
plot(surveys_base$species_id)

# There are 36 unique species_id and 2 unique plot types,
# while weight is a continuous variable.  A factor is different from a character
# because it specifies distinct levels that can be re-ordered as deemed fit. 
# Characters on the other hand do not have a level component and simply treat 
# values as individual strings.  Factors may be preferred over characters 
# because they can help us organize values into levels or groups which will make 
# tasks like graphing and modelling easier.  Additionally, new values will not be 
# added if they do not belong to a level, which makes identifying errors easier.
# Using factors makes more sense when working with categorical data.  For example,
# when working with species_id in the surveys data, we want to make sure that we 
# are the treating the variable as one with 36 distinct groups.  Because this 
# variable was converted to a factor, the graph we plot is automatically creating
# 36 categories. 

# Challenge Problem ----
# Subsetting for values whose weight exceeds 150
challenge_base = surveys_base[surveys_base$weight > 150,]
challenge_base

