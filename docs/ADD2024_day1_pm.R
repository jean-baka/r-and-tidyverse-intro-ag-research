# Review from the morning.

#### ABOUT TYPES #####

# We can declare objects of "integer" type.
a <- 3L
typeof(a) # "integer"
# Conversion from "integer" to "double" is straightforward
# when necessary.

# we can always test the type of an object:
is.integer(a) # TRUE
is.integer(3.3) # FALSE

is.double(a) # FALSE
is.numeric(a) # TRUE
is.double(3.3) # TRUE

# type "numeric" encompasses both "integer" and "double"

# you can always force a manual conversion:
as.integer(3.3) # forced conversion to an integer
as.double(3L) # forced conversion to a double


### ASSIGNMENT OPERATORS IN R
###

# The following three lines are strictly equivalent:
a <- 3.4
3.4 -> a
a = 3.4

# The following three lines are equally incorrect:
a -> 3.4
3.4 <- a
3.4 = a

# CAREFUL! The equality test is "=="
3 == 5

# "==" is naturally vectorized
1:3 == c(1,2,3)
seq(from = 1, to = 3, by = 1) == 1:3

# if I just want ONE overall equality test,
# I use identical()
identical(seq(from = 1, to = 3, by = 1), 1:3) # FALSE because
# seq() generates a vector of type "double" while 1:3 generates
# a vector of integers
identical(seq(from = 1, to = 3, by = 1), as.double(1:3)) # TRUE
identical(as.integer(seq(from = 1, to = 3, by = 1)), 1:3) # TRUE


# One can create a variable bearing same name as a function,
# though it's not advisable
head <- "toto"
head # refers to the variable just created
head(ordinates) # no problem
utils::head # specifically refers to the object "head"
# defined within the package "utils"

TRUE <- 6.2 # but we cannot assign a value to a reserved keyword of the language


### INTRODUCING DATA FRAMES #####

# Data frames are two-dimensional containers that can host
# elements of different types in different columns.
# Data frames are actually internally implemented as a list
# of column vectors.

?data.frame
data.frame(name = c("Jean-Baka", "Adil", "Rose"),
           age = c(41.99, 25, 33.2)) -> personal_data

# accessing columns of a data frame with
# the dollar operator:
personal_data$age
age # not found at toplevel:
# "age" is the name of a variable living
# WITHIN the personal_data dataframe.


#####
# the most versatile str() and summary() functions
#####

#str() gives the STRUCTURE of an R object
str(personal_data)

# summary() gives a descriptive summary:
summary(personal_data)

# nchar() is used to give the number of characters in
# a vector of type character
nchar(personal_data) # gives a result, but not what we wanted
nchar(personal_data$name) # number of characters in the names

### useful utility functions on multidimensional objects
###

dim(personal_data) # dimensions : num of rows and of columns
nrow(personal_data) # number of rows
ncol(personal_data)

names(personal_data) # the names of the variables in the df
# the above is MUTABLE: one can assign to it
names(personal_data) <- c("first name", "num. years")

# Careful now with spaces inside the variable names:
# such names have to be protected with backticks (``)

personal_data$`first name`

# picking an element from a data frame:
# the first index inside the square brackets is
# a row index, the second one a column index.
personal_data[2,1] # element on second row, first column
personal_data[1,3] # element on first row, third column
# nonexistent element yields NULL
personal_data[1,2] # element on first row, second column

# but what about selecting a whole row?
personal_data[ 2 , ] # whole second row

personal_data[ , 1 ] # whole first column



## BUILT-IN DATASETS
data(mtcars)
mtcars
rm(mtcars)
data("PlantGrowth")
PlantGrowth
View(PlantGrowth)
str(PlantGrowth)
summary(PlantGrowth)

# a factor is a vector storing qualitative data:
# the values are all among a finite set of "levels".
# each level is encoded with an integer value

as.numeric(PlantGrowth$group) # not something you need to know

# you can rename the levels:
levels(PlantGrowth$group)
# but be careful to rename in the correct order!
levels(PlantGrowth$group) <- c("ControlGroup", "Treatment1", "Treatment2")
str(PlantGrowth$group)
levels(PlantGrowth$group)

# Plot boxplots of weight distributions for each of the
# treatment groups
boxplot(weight ~ group, data = PlantGrowth)



# IMPORTING DATA FROM EXCEL SPREADSHEETS
install.packages("readxl") # installing a package (to be done once only)
library(readxl) # loading the library in my current environment
read_xlsx("livestock_data.xlsx")

# In preparation for tomorrow:
install.packages("tidyverse")
# Browse to https://www.tidyverse.org/ for more info!
