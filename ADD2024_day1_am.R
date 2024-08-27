
######
# First interactions with R: arithmetic operations
######

3-5 # 3 minus 5
5^3 # 5 to the power 3
4 * 3 # 4 times 3 (spaces between tokens do not matter)

# Vectors as the most basic data container in R

# ':' ("colon" in English) creates sequences of integers
1:100
5:20

# c() as our first built-in FUNCTION to create arbitrary vectors
c(5, 3, 10) # an arbitrary vector containing 3 values

# arithmetic operators are actually FUNCTIONS as well:
`+`(3,5)

# we can of course work with non-integer values:
c(5.5, 3, 10.33)

# SAVING STUFF INTO OBJECTS (AKA "VARIABLES")
c(5.5, 3, 10.33) -> vector1 # variable assignment

# vectorized operations are the default:
vector1 + 5
vector1 * 2
vector1 * c(1,2)
# the above produces a WARNING, that is not an ERROR:
# the evaluation of what I typed did produce a result.
# A warning warns the user of something unexpected that
# came up along the way to producing a result.

# Adding (arithmetic operation) something to a vector
# is different from concatenating (glueing) a value,
# which is done with the c() function:
c(vector1, 5) # producing a vector of length 4
vector1 # calling a variable to see its contents

#####
# Data types in R
#####

typeof(3) # "double" is same as "numeric"
# it comes from "double-precision numeric value"
typeof(3.3)
typeof(vector1)

# Pieces of text, also called "strings", must be enclosed
# in quotes. Otherwise, they are interpreted as variable names (aka. variable identifiers).
vector1
vector2 # object not found

"vector1"
"Jean-Baka" -> myname # storing a string into a variable

typeof("vector1") # "character" is the R data type for strings
typeof(myname)

# logical type for the result of Boolean operations, i.e. logical tests:
5 > 3 # "strictly greater than" operator
5 >= 5 # "greater than or equal" operator
5 < 5 # "strictly less than" operator
typeof(TRUE)
# There is a shorthand for "TRUE": "T"
typeof(T)

# testing in R that two objects are identical is done
# through a function call to identical()
identical(TRUE, T)
identical(FALSE, F)

# SUMMARY: there are three basic data types in R:
# - type logical for TRUE and FALSE,
# - type character for strings (i.e. pieces of text),
# - type double for numerical values.

# All elements in a vector are constrained to have same type.
c(FALSE, 3, "hello")
# the above produces an automatic "casting" (i.e. conversion)
# the the broadest of the initial types (here: type character)

c(FALSE, 3, -2, TRUE)
# here the broadest type of the two initial types (logical and double)
# is the type "double": in the context of such a casting,
# FALSE is converted into 0
# and TRUE is converted into 1

c("male", "female", "male", "male", 0)

#####
# HOW TO CALL FOR HELP
#####

# When you want to get the help page for a function
# whose name you know:
?typeof
typeof(1,2) # calling typeof() with two arguments produces an error

# the above is not the same as calling typeof() on
# a single vector containing two elements:
typeof(c(1,2))

# The help page on c() tells us that this function
# can take many arguments:
?c

# some useful functions
# mean, median, min, max (descriptive statistics)
mean(vector1)
median(vector1)
min(vector1)
max(vector1)
range(vector1) # yields a vector of length 2 giving the min and the max
length(vector1) # yields the number of elements

# careful with your arguments!
mean(4,5)
mean(1,2,3)
# the above is mean(x=1), with other parameters ignored.
mean(c(1,2,3)) # correct


?mean
mean() # error: expecting at least one argument

# Naming arguments in a function call ensures proper matching with the expected formal parameters:
mean(1,2,3) # mean(x = 1)
mean(1, x=2, 3) # mean(x = 2)
mean(1, 2, x = 3) # mean(x = 3)

# if I don't name my arguments, their order is key:
mean(3,1,2)

# seq() as a function to create sequences
?seq
seq(from = 0.1, to = 1.7, by = 0.2) -> vector2

# increment can be negative:
seq(from = 10, to = 1) # implicit increment is -1
seq(from = 10, to = 1, by = -2)
# we can also create regular sequences by giving
# the length of the output INSTEAD OF the increment:
seq(from = 0, to = 1, length.out = 100) -> vector3
# I created 100 datapoints regularly spaced between 0 (included) and 1 (included).
length(vector3) # 100

######
# About the way numerical values are displayed
# and actually dealt with internally:
######

1/3 -> one_third # don't worry about the number of DISPLAYED decimals

one_third
0.3333333 # different value!
identical(one_third, 0.3333333) # FALSE: there are more decimal figures
# in the internal representation of the value stored in the one_third variable.
identical(one_third, 1/3) # TRUE



sd(vector1) # standard deviation
# let's calculate the standard deviation "manually"
sqrt(4)
sqrt(9)
sqrt(10)

mean(vector1) -> m
length(vector1) -> n
vector1 -> x
x - m # the vector of the three differences to the mean
(1:3)^2 # works as expected: element-wise squaring
(x - m)^2 # squared deviations to the mean
sum(1:3) # new function: get the sum of the
# elements in a vector
sum((x - m)^2) # numerator
sum((x - m)^2) / (n-1) # this is what goes under the root
sqrt(sum((x - m)^2) / (n-1)) # the final standard deviation
sd(x) # indeed, we verify we get the same value

####
# Be careful with the contaminating effect of NA values
####

c(3, sd(3), 0, 3.4) -> vec4
vec4
mean(vec4) # yields NA because there is at least one NA value in this vector.

# if we want the mean of only the non-NA values,
# we have to instruct R to remove the NA values
# before proceeding with the calculation of the mean:
mean(vec4, na.rm = TRUE)

# same with median()
median(vec4)
median(vec4, na.rm = TRUE)

# same with min()
min(vec4)
min(vec4, na.rm = T)


####
# SUBSETTING elements from a vector:
####

# first get the current length:
length(vector3) # 100

# new syntax with square brackets:
vector3[30] # producing the 30th element
vector3[c(91,5,72)] # producing, in this order,
# the 91st element, then the 5th, then the 72nd

# Warning! Very different would be:
vector3[91,5,72]
# that would be picking an element from a 3-dimensional matrix

####
# plotting a scatterplot with a call to seq()
# and a call to plot()
####
?plot # displaying the help for the function plot()
abscissa <- seq(from = 0, to = 1, length.out = 100)
# I create a sequence of 100 points between 0 and 1
ordinates <- cos(abscissa)

ordinates[1:10] # just checking the first 10 y-values
plot(x = abscissa, y = ordinates, main = "My first plot: cosine function")
