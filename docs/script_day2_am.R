library(tidyverse)
?read_xlsx
# fill in the following function call to import the 2nd sheet, saying that '66' is a coding for missing data
readxl::read_xlsx("livestock_data.xlsx", sheet = 2, na = c("", "66")) %>% filter(qno == "KIA13249")
readxl::read_xlsx("livestock_data.xlsx", sheet = 2, na = c("", "66")) -> households

#
# filter() to select some rows based on logical criteria
#

# Let's count the number of rows with age 50
households %>% filter(age == 50) %>% count() # dplyr function count() returns a tibble
households %>% filter(age == 50) %>% nrow() # base R nrow() returns a vector

# if we want to further work with the tibble restricted to observations where age == 50, we'd save that sub-tibble into a new variable:
households %>% filter(age == 50) -> hh_aged_50

View(hh_aged_50)
households %>% filter(age == 50, primary_activity == "Civil servant") -> cs_aged_50


#
# select() to filter variables (dropping some of them)
#
cs_aged_50 %>% select(education,hh_experience)
# I can use indices for the columns:
cs_aged_50 %>% select(3:6) # keep columns from 3rd to 6th
# I can specify the columns I want to drop, using the negative sign:
cs_aged_50 %>% select(-3)
cs_aged_50 %>% select(education,hh_experience)
# select() can be used with helpers that will analyse column names:
cs_aged_50 %>% select(starts_with("off_farm"))
cs_aged_50 %>% select(- starts_with("off_farm"))
# I can use indices for the columns:
cs_aged_50 %>% select(3:ncol(cs_aged_50)) # keep columns from 3rd to last

# select() can be used with helpers that will analyse column names:
cs_aged_50 %>% select(contains("_")) # select all columns whose names contains at least one underscore character ("_")

cs_aged_50 %>% select(-starts_with("off_farm")) %>% select(contains("_")) 

# these two select() can actually be combined in one single call, using the logical AND (&) operator:
cs_aged_50 %>% select(-starts_with("off_farm") & contains("_"))

# select() always returns a tibble, even with no data:
households %>% filter(age > 120)

# if you want to extract a *vector* of the datapoints in a given column, you use pull():
cs_aged_50 %>% select(anydairy)
cs_aged_50 %>% pull(anydairy) # equivalent to:
cs_aged_50$anydairy # "base R" equivalent

##
# calculating new columns
##

# we use mutate() to calculate a new column based on values in existing columns:
hh_aged_50 %>% mutate(female = round(adults * fem_totadult), .after = adults) %>% View()

# we can even chain the new column specifications to compute newer columns based on new columns:
hh_aged_50 %>% mutate(female = round(adults * fem_totadult), .after = adults, men = adults - female) %>% View()

# transmute() drops existing columns by default:
hh_aged_50 %>% transmute(qno = qno, female = round(adults * fem_totadult), men = adults - female) %>% View()

# let's say we want to transform the ages greater than 70 into NAs (e.g. to fix data collection errors):
households %>% mutate(age = replace(age, age > 70, NA)) -> no_age_greater_70
no_age_greater_70 %>% filter(qno=="KIA12587") # was 82 y.o.

# let's go graphics with ggplot2

# scatterplot:
households %>% ggplot(mapping = aes(x = education, y = fem_totadult)) + geom_point()

# quickly checking that indeed we had 10 observations with an NA either in education or in fem_totadult:
# the '|' operator is the logical OR
households %>% filter(is.na(education) | is.na(fem_totadult)) %>% nrow()

# histogram
no_age_greater_70 %>% ggplot(mapping = aes(x = age)) + geom_histogram()

# checking the 48 "non-finite values"
no_age_greater_70 %>% count(age) %>% View()

no_age_greater_70 %>% ggplot(mapping = aes(x = age)) + geom_histogram(binwidth = 5)


# BACK TO MANIPULATING DATA

# factors
str(households)

# factors express qualitative data:
c(1,2,1,2,1,2,2,2,2) # numeric vector
factor(c(1,2,1,2,1,2,2,2,2)) # a factor


# we may want to transform a column in our dataset into a factor
# the %<>% operator from the magrittr package pipes the LHS into the chain of transformations on the RHS, and then stores back the final result into the LHS 
library(magrittr)
households %<>% mutate(sex = factor(sex))

#
# grouping variables
#
# getting the median education value without groups:
households %>% summarise(med_educ = median(education, na.rm = T), offfarm_mean = mean(off_farm_percent, na.rm = T))

# same with groups:
households %>% group_by(sex) %>% summarise(med_educ = median(education, na.rm = T), offfarm_mean = mean(off_farm_percent, na.rm = T))

# we can group along a character variable:
households %>% group_by(primary_activity) %>% summarise(med_educ = median(education, na.rm = T), offfarm_mean = mean(off_farm_percent, na.rm = T))

# adding counts for each group with count = n()
households %>% group_by(primary_activity) %>% summarise(count = n(), med_educ = median(education, na.rm = T), offfarm_mean = mean(off_farm_percent, na.rm = T))


# we can group according to several variables:
households %>% group_by(sex, any_agric) %>% summarise(count = n(), med_educ = median(education, na.rm = T), offfarm_mean = mean(off_farm_percent, na.rm = T))


# recoding the levels of a factor with recode()
households %<>% mutate(sex = recode(sex, `0` = "female", `1` = "male"))

#
# JOINING TABLES
#

# importing the first sheet of livestock_data.xlsx into a tibble called "livestockTLU":
readxl::read_xlsx("livestock_data.xlsx", sheet = 1) -> livestockTLU


# left join between livestock TLU and households:
livestockTLU %>% left_join(households, by = "qno") %>% View()



# left join between livestock TLU and households:
livestockTLU %>% full_join(households, by = "qno") %>% View()


# when the join column doesn't have same name in the left and right tables:
livestockTLU %>% rename(TLU_ID = qno) -> livestock_with_IDs

livestock_with_IDs %>% select(TLU_ID,total_TLU_sold) %>% left_join(households, by = c("TLU_ID" = "qno")) %>% View()

# I can drop some columns before joining:


# side dish: one can rearrange the order of observations with arrange():
# e.g. arrange by descending education values

households %<>% arrange(desc(education))
