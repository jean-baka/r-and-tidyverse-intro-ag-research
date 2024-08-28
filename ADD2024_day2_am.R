# Setting my current working directory:
setwd("Trainings/R/R_ILRI_Addis_Aug2024/")

####
#### QUESTION: HOW TO EXPORT TO FILES?
####

# loading the core tidyverse libraries:
library(tidyverse)
library(readxl)
read_xlsx("livestock_data.xlsx") -> dat
View(dat)

# build a statistical summary for a variable:
summary(dat$TLUsold_ha) -> descriptive_stats

# but what exactly is this object?
str(descriptive_stats) # it is a named vector of type numeric
typeof(descriptive_stats)
names(descriptive_stats)

# export data to a file:
is.data.frame(descriptive_stats) # not a data frame,
# descriptive_stats is a simple vector:

# we are going to make a basic data frame from
# the values and the names in descriptive_stats:

# tibble is the tidyverse equivalent (actually, an enrichment)
# of the data.frame type of data container.
# Here, we use the information (names and values)
# contained in the vector called descriptive_stats
# to create a tibble:
data.frame(statistic = names(descriptive_stats), value = as.vector(descriptive_stats)) # -> stats_as_tibble

# better to create a tibble:
tibble(statistic = names(descriptive_stats), value = as.vector(descriptive_stats)) -> stats_as_tibble

write_csv(x = stats_as_tibble, file = "descr.csv")

# if you really want to export to Excel format:
library(writexl)
write_xlsx(x = stats_as_tibble, path = "descr.xlsx")

# A bit of basic maths:

# squaring values:
5 ^ 2 # 5 to the power 2
5 * 5 # same
5 ^ 9

# getting square roots:
?sqrt
sqrt(25)
sqrt(67.65)

# we can use scientific notation:
# "e" stands for "multiplied by 10 raised to the power"
1e2 # 100
1 * 10^2 # same

5.6e3 # 5600
sqrt(1.67e-6)

# as any other function in R, it can be used in a vectorized
# (a.k.a element-wise) fashion

sqrt(4,67) # error: only one argument expected
sqrt(4)
sqrt(67)
sqrt(c(4,67)) # yields c(sqrt(4), sqrt(67))

# standard deviation
sd(5) # undefined value for the stdev of a single number
sd(5,6.7,9) # wrong
sd(c(5,6.7,9)) # correct 

# we can ask for the standard deviation of any
# numerical vector:
sd(dat$stocking_rate, na.rm = TRUE)
?sd
sd(dat$stocking_rate, na.rm = FALSE) # default behaviour


#####
### WORKING WITH TIDYVERSE ####
#####

# the pipe operator
typeof(c(1,2))
# first function call to be executed is actually c().
# The output of c(1,2) is sent as an input of typeof()

## we can represent the above using a pipe operator:
## |>
## or
## %>%
## It is produced with Ctrl + Shift + "M"


c(1,2) |> typeof() # strictly equivalent to:
typeof(c(1,2))

mean(5) # same as:
5 |> mean()
5 |> c() |> mean() # exact same, with an unnecessary call to c()

# I can ask for the mean of a vector containing more than 1 element:
c(3,4,7.8,1) |> mean()

c(3,4,7.8,NA,1) |> mean() # NA
mean(na.rm = T) # doesn't work: argument x is missing
c(3,4,7.8,NA,1) |> mean(na.rm = T) # x is sent by the pipe

# On the same vector, get the names() of the summary()
# using two pipe operators
c(3,4,7.8,NA,1) |> summary() |> names()
# the above is equivalent to:
names(summary(c(3,4,7.8,NA,1)))

# MORE ADVANCED: square brackets ARE operators, i.e. functions.
a <- c(3,4,7.8,NA,1)
a[3] # same-same as:
`[`(a,3)
`[`(a,2:3)

# For instance, if I want to get the Median value only:
`[`(summary(c(3,4,7.8,NA,1)), 3)


c(3,4,7.8,NA,1) |>  summary() %>% `[`(3) # for some reason,
# this doesn't work with |> 
# OR:
c(3,4,7.8,NA,1) %>% summary() %>% `[`("Median")

# using TIDYVERSE and dplyr package to work on data:
library(tidyverse)
mtcars
dim(mtcars) # 32 rows, 11 columns
mtcars |> filter(mpg > 20) |> dim() # 14 rows, 11 columns

# let's make sure we no longer have observations (== rows)
# with an mpg value less than or equal to 20:
mtcars |> filter(mpg > 20) |> filter(mpg <= 20) # 0-row dataframe

# exercise: tell me how many households from the livestock_dataset
# have a tlu value less than or equal to 1.1,
# using a call to filter().
dat |> filter(tlu <= 1.1) |> nrow() # 260
