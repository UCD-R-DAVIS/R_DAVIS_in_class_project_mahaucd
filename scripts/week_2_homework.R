# Intro ----
set.seed(15)
# creating vector hw2 of 50 random numbers from a uniform distribution between 
# the values of 4 and 50
hw2 <- runif(50, 4, 50)
# replacing values 4, 12, 22, 27 with NA in vector hw2
hw2 <- replace(hw2, c(4,12,22,27), NA)
hw2

## Problem 1 ----

# subsetting for non-NA values between 14 and 38
prob1 = hw2[!is.na(hw2) & hw2 >= 14 & hw2 <= 38]

## Problem 2 ----

# Multiplying all values by 3
times3 = prob1 * 3
# Adding 10 to all values
plus10 = times3 + 10

## Problem 3 ----
# Subsetting for 12 odd indices
plus10[c(1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23)]
