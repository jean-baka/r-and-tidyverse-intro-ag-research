#####
### DATA FRAMES
#####

# A data frame is a list of vectors. Each column represents a variable.
# Within a column, all elements have same type, which is the reason why columns in a data frame can be vectors.

# Creating a data frame can be done with the function data.frame():
# In that function call, each argument is a variable (i.e. a column).

data.frame(a = 1:5) -> tinydata

# we can ask the dimensions of a data frame with dim():
dim(tinydata) # 5 rows, 1 column

rep('albert', 4) # rep() function to replicate its argument
data.frame(serial_id = 1:100, name = rep(LETTERS[1:25],4)) -> data1

# we can extract elements from a data frame.
# A data frame is an object with two dimensions.
dim(data1)

data1[ , ]
data1[ 1 , 1 ] # before the comma: selecting rows, after the comma: selecting columns

data1[49,2] # row 49, column 2

# we can extract a slice from a data frame:
data1[30:35, ]

# we can extract a variable as a vector:
data1$name
data1$serial_id

str(data1)

# elements in a row are not necessarily of the same type:
data1[23,]


# Let's see more complex datasets that is already predefined in R:
mtcars
iris
dim(iris)
str(iris)

summary(iris) # summarizing the dataset

iris[ iris$Species == "versicolor" , ] # before the comma: selecting rows

#############
# using tidyverse (readr and readxl) to import data
#############

library(readr) # library we will use to read a csv file into a tibble
library(tidyverse)
# importing the data now:
read_csv("livestockTLU.csv") -> livedata

summary(livedata)

# tabulate values for a given variable:
table(livedata$gene_increase, useNA = "ifany")
table(livedata$cow_inmilk, useNA = "ifany")

# basic graphics without ggplot2
str(livedata)

head(select(livedata, -1)) # print the first 6 lines of the dataset after removing its first column

pairs(select(livedata, -1)) # very explorative but works only with numeric data

# plot only one scatterplot (without ggplot2):
plot(x = livedata$TLUsold_totalTLU, y = livedata$total_TLU_sold)

# plot the same with ggplot2:
ggplot(data = livedata, mapping = aes(x = TLUsold_totalTLU, y = total_TLU_sold, fill = gene_increase)) + geom_point(alpha = 0.5)
