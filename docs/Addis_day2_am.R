library(readr) # to read from csv files
library(tidyr)
library(dplyr)
read_csv(file = "livestockTLU.csv",show_col_types = F) -> livedata

# which type of object do we have?
typeof(livedata) # says "list" because a data frame (or a tibble) is encoded internally as a list of vectors (variables, eke columns)

class(livedata)
# we get that livedata is at the same time a data.frame object and a tibble (tbl_df) object
is_tibble(livedata)

# get the dimensions of the tibble
dim(livedata)

# we can get individual dimensions:
nrow(livedata)
ncol(livedata)

str(livedata) # gives us more information on the structure of the object

glimpse(livedata)
head(livedata) # by default the first 6 rows are produced

# better display than the one for base data frames:
head(as.data.frame(livedata))

#########
#### INTRODUCING TIDYVERSE's PIPE
#########

# piping means passing some object from the left hand side of an operator to the function mentioned on the right hand side
# Ctrl + Shift + M is the standard keyboard shortcut to produce the pipe (%>%)
livedata %>% dim()

# we can further chain piping operators:
livedata %>% as.data.frame() %>% head(10) # same as head(as.data.frame(livedata))

##########
#### selecting rows and columns with dplyr
##########

# columns are variables, rows correspond to observations (sometimes also called individuals or cases)

livedata %>% colnames() # getting the column names as a character vector

# selecting columns is done with select()
livedata %>% select(1:3) # selecting the first three columns

livedata %>% select(stocking_rate) # selecting just one column using its name. Output is a tibble.

livedata %>% pull(stocking_rate) # same as livedata$stocking_rate: extracts a column *as a vector*

livedata %>% select(c("total_TLU_sold","TLUsold_ha","TLUsold_totalTLU"))

livedata %>% select(c(total_TLU_sold, TLUsold_ha, TLUsold_totalTLU))
# no need to quote column names with tidyverse

# I can use a *selection helper* function to extract the columns whose name contains "TLU":
livedata %>% select(contains("TLU"))
livedata %>% colnames() -> names
# we have to specify "ignore.case = F" in the function call to contains() in order to be case-sensitive:
livedata %>% select(contains("TLU", ignore.case = F))

# we can select columns based on the beginning of their name:
livedata %>% select(starts_with("TLU", ignore.case = F))

# if we want to select all columns of type double (numeric):
livedata %>% select(where(is.numeric))

# we can exclude columns instead of including columns:
livedata %>% select(-(1:6)) # select all columns except the first six

# alternatively, use the exclamation mark to negate:
livedata %>% select(!contains("TLU"))

# select a range of consecutive columns, using names:
livedata %>% select(hgh_prd_cattle:stocking_rate)


# now working on rows (cases or observations)

# the filter function filters rows based on a predicate
is.na(c(3,"nana", NA, FALSE))

livedata %>% nrow() # we start with 446 rows

# keeping only the rows where TLUsold_totalTLU is not NA
livedata %>% filter(!is.na(TLUsold_totalTLU))

# since the objects carried through the pipes remain tibbles, I can chain pipes with operations on tibbles:
livedata %>% filter(!is.na(TLUsold_totalTLU)) %>% filter(total_TLU_sold >= 2.5)

# instead of the above, we can use the logical AND operator (&) inside the filter condition:
livedata %>% filter(!is.na(TLUsold_totalTLU) & total_TLU_sold >= 2.5)

# the logical OR is '|':
# filter rows that satisfy **at least one** of the conditions:
# + TLUsold_totalTLU is not NA
# + total_TLU_sold >= 2.5
livedata %>% filter(!is.na(TLUsold_totalTLU) | total_TLU_sold >= 2.5) -> temp
View(temp)

# we can slice the dataset by row positions:
livedata %>% slice(20:30)

# do we have duplicate observations?
livedata %>% nrow()
livedata %>% distinct() %>% nrow() # NO, we don't

# dummy example:
tibble(names = rep(letters, 2), constant = 1) -> double_alphabet
double_alphabet %>% nrow()
double_alphabet %>% distinct() %>% nrow()

# selecting a random 15% of your initial dataset:
double_alphabet %>% slice_sample(prop = 0.15)
# or select a random 10 rows:
double_alphabet %>% slice_sample(n = 10)
double_alphabet %>% slice_sample(n = 70, replace = T) # with replace = T, we can ask for a *larger* dataset than the initial one.

# last thing on rows: rearranging cases (observations)
double_alphabet %>% arrange(names)
# we can arrange by decreasing values:
double_alphabet %>% arrange(desc(names))

# there is a natural (alphabetical) order on strings in R:
"albert" < "boy" # TRUE
"buoyant" < "boy" # FALSE

#####
### adding a given column
####
double_alphabet$num_random <- runif(n = 52, min = 5, max = 100)


######
##### summarize (collapse rows) #####
########

# dplyr functions "want" to return tibbles as often as possible
# pay attention to the difference between the first two and the last:
mean(double_alphabet$num_random) # result is a vector of length 1
double_alphabet %>% pull(num_random) %>% mean() # same here

double_alphabet %>% summarise(mean_num = mean(num_random)) # result is a tibble
double_alphabet %>% summarise(mean_num = mean(num_random), max = max(num_random), N = n())

######
##### grouping based on variables #####
########

# we want to group observations based on the value of one or several variables, for instance to make distinct summaries

double_alphabet %>% group_by(names) %>% summarise(min = min(num_random), median = median(num_random), mean_num = mean(num_random), max = max(num_random), N = n()) # summaries are calculated within groups

# we can group by two variables at once:
double_alphabet %>% group_by(names, num_random) # doesn't make any sense because the number of groups EQUALS in this case the number of observations

# when we summarise, we "peel off" *one* grouping level:
double_alphabet %>% group_by(names, num_random) %>% summarise(min = min(num_random), standard_dev = sd(num_random), mean_num = mean(num_random), max = max(num_random), N = n())

sd(c(0,5)) # OK
sd(5)

double_alphabet %>% group_by(names) %>% summarise(min = min(num_random), standard_dev = sd(num_random), mean_num = mean(num_random), max = max(num_random), N = n())

#######
##### calculating new variables with mutate() or transmute()
##########

# we are going to add a new column containing the rounded values of num_random

double_alphabet %>% mutate(rounded = round(num_random))

# by default, transmute drops all the initial columns:
double_alphabet %>% transmute(rounded = round(num_random))

# cleaning up one's environment with rm()
rm(temp, livedata, names, double_alphabet)

#######
#### back to importing data with readxl
########
library(readxl) # library containing functions to import from .xls and .xlsx files
read_xlsx("livestock_data.xlsx", sheet = 1) -> cattle_perf
read_xlsx("livestock_data.xlsx", sheet = 2) -> households

# get the number of different qno values for each dataset (are there multiple rows corresponding to the same qno value?)

cattle_perf %>% distinct() %>% nrow()
# the above answers the question "are there duplicate rows in the dataset?", NOT the question "are there at least two rows with the same qno value?"

# we can select() the different qnos and apply distinct() on that table:
cattle_perf %>% select(qno) %>% distinct() %>% nrow()
# all rows have a different qno value in cattle_perf

#other way to see the same thing:
cattle_perf %>% pull(qno) %>% anyDuplicated() # 0: each qno value was unique

cattle_perf %>% group_by(qno)
# 446 groups for 446 observations => each observation (row) has a unique qno value

households %>% group_by(qno)
# 527 groups for 527 observations => each observation (row) has a unique qno value