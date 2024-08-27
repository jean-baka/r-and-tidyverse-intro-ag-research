library(readxl) # library containing functions to import from .xls and .xlsx files
read_xlsx("livestock_data.xlsx", sheet = 1) -> cattle_perf
read_xlsx("livestock_data.xlsx", sheet = 2) -> households

# we want to do a full join of both tables

households %>% full_join(cattle_perf, by = "qno") -> full
dim(full)
colnames(full)

# a right join will discard rows of households with qno values that do not appear in cattle_perf:
households %>% right_join(cattle_perf, by = "qno") -> right
dim(right)

# exercise: calculating columns
# we use the US-based mtcars dataset, which tabulates fuel economy of cars in miles per gallon (mpg):
# add a column calculated from mpg with the values of fuel consumption in L/100km

# 1 US (terrestrial) mile = 1.609344 km
# 1 US (liquid) gallon = 3.785411784 L

# hint: go first from miles per gallon to gallon per mile, and then to L per km.

# we established that (x) mpg is 100*3.8/(1.6*x) in litres per 100km
mtcars %>% as_tibble(rownames = "model") %>% mutate(`L/100km` = 100 * 3.785411784 / (1.609344 * mpg), kpL = 1.609344 * mpg / 3.785411784, .after = mpg)


