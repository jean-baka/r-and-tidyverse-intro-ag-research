library(tidyverse)
library(readxl)

# FILTERing is on rows.

# importing the second sheet of a multisheet Excel file:
dat2 <- read_xlsx("livestock_data.xlsx", sheet = 2)

# filter the rows corresponding to households with > 10yr
# experience (in hh_experience variable)

dat2 |> filter(hh_experience > 10) # 303 obs.

# one can combine logical filters:
# the logical AND operation is "&",
# the logical OR operation is "|"

# If I want households with > 10yr experience AND
# anydairy equal to 1:
dat2 |> filter(hh_experience > 10 & anydairy == 1) # 231 observations

###
# Working with columns (variables)
###
# select() to select columns
dat2 |> select(education,hh_experience)

# selection can be done according to numerical indices:
dat2 |> select(1:3,6) # selecting first three plus the sixth column

# we can select using the helper where(), to select
# based on a predicate (i.e. the result of a function
# saying "TRUE" or "FALSE" on the columns)
is.numeric("hello") # FALSE
is.character("hello") # TRUE
# so: we can select the columns of type character
dat2 |> select(where(is.character))

# You can select negatively:
dat2 |> select(!where(is.character)) # select all columns NOT being of type character

dat2 |> select(-qno) # select every column except qno

dat2 |> select(starts_with("off")) # select all the columns whose name starts with "off"

dat2 |> select(contains("farm")) # all the columns containing "farm" somewhere in their name

dat2 |> select(!contains("_")) # select all the columns except those whose name contains "_"

# mutate() to create new variables
# based on the existing content of the dataset, or not:
dat2 |> mutate(dummy5 = 5) -> toto

# add a column being the sum of other two cols:
dat2 |> mutate(sum_F_and_D = fem_totadult + depend_ratio) |> View()

# we can control the place where the new column appears:
dat2 |> mutate(sum_F_and_D = fem_totadult + depend_ratio, .after = depend_ratio) |> View()

# about the sample() function
#
# The sample() function is used to sample values
# from a vector, with or without replacement.

set.seed(1982) # necessary if you want reproducibility
sample(1:1000, size = 20) # pick 20 integers between 1 and 1000, without replacement
sample(1:10, size = 20) # error: not enough elements to pick from
sample(1:10, size = 20, replace = TRUE) -> series


# about the ifelse() function
# ifelse takes three arguments:
# - a logical test (returning TRUE or FALSE)
# - an expression that will be returned when the test returns TRUE
# - an expression that will be returned when the test returns FALSE
ifelse(5>3, "yes", "no")
ifelse(5<3, "yes", "no")

# ifelse can be used on vectors:
ifelse(series>3, "yes", "no")
# this could not be done with the builtin if... else construct:
if (5>3) "yes" else "no" # with just one value, it's ok
if (series>3) "yes" else "no" # not ok: condition has length 20

# we actually have to write:
ifelse(series>3, "yes", "no")

# now, we use ifelse() in a mutate() call:

# EXERCISE: Write, immediately on the right of hh_experience,
# a new variable called hh_experience_threshold
# that contains the value 1 if the experience is >= 10 years,
# and 0 otherwise.
dat2 |> mutate(hh_experience_threshold = ifelse(hh_experience >= 10, 1, 0), .after = hh_experience) -> dat2

# summarize() function
mtcars |> as_tibble() |> summarize(avg = mean(mpg))
mean(mtcars$mpg) # checking the value
# we can do multiple summaries at once:
mtcars |> as_tibble() |> summarize(avg = mean(mpg), max_cyl = max(cyl), stdev_displacement = sd(disp, na.rm = T))

# grouping data to summarize meaningfully:
mtcars |> as_tibble() |> group_by(gear)
# grouping in itself doesn't do much to the data,
# it only prepares future summaries to work in a groupwise
# fashion. Grouping DOES NOT change the order of rows.

mtcars |> as_tibble() |> group_by(gear) |> summarize(n = n(), avg = mean(mpg), max_cyl = max(cyl), stdev_displacement = sd(disp, na.rm = T))


# grouping and summarizing in dat2
dat2 |> group_by(depend_ratio) # 50 groups!
dat2 |> pull(depend_ratio) |> unique() |> length()

# it is not usually appropriate to group on a numerical value,
# especially a continuous one
dat2 |> group_by(sex) |> summarize(mean_age = mean(age, na.rm = 1))

# using mutate to create a variable with imputation of NA
# values

# off_farm_activity contains some NA values:
dat2 |> pull(off_farm_act) |> is.na() |> sum() # 43

# we want to replace these values with the median of all
# other values in the column.
median(dat2$off_farm_act, na.rm = T)

dat2 |> mutate(off_farm_act_imputed = ifelse(is.na(off_farm_act), median(off_farm_act, na.rm = T), off_farm_act), .after = off_farm_act) # |> filter(is.na(off_farm_act)) |> View()
