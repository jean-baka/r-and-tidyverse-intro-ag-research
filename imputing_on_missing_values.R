# This is to answer a question Soumaya asked regarding the ways and means
# to replace missing values with some computed values, for instance the
# median or the mean of the variable in question.

# BEWARE! Replacing missing values by some numerical values is not always
# the best move. If you replace missing datapoints with "artificial" data,
# you must keep in mind that you are using non-experimental data.

# we first write a function that takes as input a vector as input, together with a fixed numerical value, and replaces all NAs in that vector with that value:

replace_with_value <- function(x, val) { ifelse(is.na(x), val, x) }
vec = c(3,4,NA,5,NA,6,7,10)
replace_with_value(x = vec, val = 99)


replace_with_median <- function(x) { ifelse(is.na(x), median(x, na.rm = T), x) }

replace_with_median(vec)

# with across(), we apply the transformation specified by the replace_with_median() function to all numeric columns of the cattle_perf tibble:
cattle_perf %>% mutate(across(.cols = where(is.numeric), .fns = replace_with_median)) -> filled_dataset
View(filled_dataset)

# calculate "manually" the median values for each column:
cattle_perf %>% summarise(across(.cols = where(is.numeric), .fns = median, na.rm = T))

# double-check which were the median values used to fill the NA gaps:
cattle_perf %>% mutate(across(.cols = where(is.numeric), .fns = replace_with_median)) 

# calculate "manually" the median values for each column AFTER the transformation:
cattle_perf %>% mutate(across(.cols = where(is.numeric), .fns = replace_with_median)) %>% summarise(across(.cols = where(is.numeric), .fns = median, na.rm = T))

# We verify that the columnwise median values were not affected by our imputation.
