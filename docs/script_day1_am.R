5
3+5 # this is my first addition in R
5.6 + 3.3 # numeric values
-5 + 3
# logical tests
5.3 > 2
true # R is case-sensitive
TRUE
4 < 2 # FALSE
"true" # this is a string, that we can use as an object
'true' # you can use single or double quotes
"TRUE" # is NOT the logical (boolean) value

## THREE BASIC TYPES IN R
typeof(5) # this is my first explicit function call
mode(5) # slightly different, but same story: numeric value
typeof(3.4)

typeof(TRUE) # logical
typeof("TRUE") # character (a.k.a string)

# ASKING FOR HELP
?typeof
typeof # NOT a function call
typeof() # error
typeof(3,'three') # arguments are separated with commas; here, this function call with two arguments fails because only one argument was needed

# strings versus variables
variableA # an unquoted string is (expected to be) a variable name
"variableA" # a character vector of length 1 (string)

# VARIABLE ASSIGNMENT
5.3 -> variableA # storing the value 5.3 into the variable with name variableA

ls() # lists the contents of my environment
variableA

# I can copy a variable into another one:
variableA -> b

# typing is dynamic and can change over the lifetime of a variable:
'hello' -> variableA

# then I can delete this variable:
rm(variableA) # "rm" for "remove"

# INTRODUCING VECTORS
# there is no object in R that be simpler than a vector
is.vector(5) # TRUE

# one way to make vectors is to use the c() function and give it the vector elements as arguments
c(2, 5, 7, 1, 2, 5)
?c
c(2, 5, 7, 1, 2, 5) -> v1
# the length() of a vector is its number of elements
length(v1)
is.vector(v1)
# c is versatile and can concatenate any vectors
c(v1,v1,v1,v1) -> v2
length(v2)

c(v2,v2)

# VECTORS AND TYPES
c(1, "toto") -> mixed_vec # NO SPACES in variable names
mixed_vec
typeof(mixed_vec) # vector of type character
# A vector CANNOT contain elements of different types.
# Automatic casting takes place with conversions the following way:
# logical ---> numeric ---> character

# automatic casting from logical to numeric:
c(FALSE, 5) # FALSE cast to 0
c(TRUE, 5) # TRUE cast to 1
FALSE + 4 + 3

c(FALSE, "hello")

# Other functions to generate numeric vectors

?seq
seq(1,7)
seq(from = 1, to = 7) # exactly same as above
seq(form = 1, to = 7)
seq(7,1)
seq(1,7,2)
# arguments need not be named in a function call
# but when they are many, it's good practice to name them
# naming arguments waives the necessity to order them according to the function definition
seq(by = 2, from = 10, to = 100)

# default values for some or all arguments can be specified in the function definition, and hence displayed on its manpage. They come after the equal signs in the Usage lines.

# generate a vector of 12 numbers evenly spaced between 1 (first value) and 0 (last value), using the length.out argument of the function seq():
seq(from = 1, to = 0, length.out = 12) -> unit

#extracting elements from a vector:
unit[3] - unit[2]
unit[8] - unit[7]
# == tests equality
2 == (4-2) # TRUE
2 = (4-2) # error!
(unit[6] - unit[4]) == 2 * (unit[3] - unit[2])


# other operators for assignment
4.6 -> a
a <- 4.6 # same
a = 5.2 # same, and it is the syntax in most programming languages

# slicing a vector
unit[20] # produces an NA

unit[c(3,7)] # extracts the elements at positions 3 and 7

# we can modify elements in place: vectors are mutable
17 -> v1[3]
70 -> v1[20]
v1 # NAs have been created

# creating vectors with random values
# 10 random values following a uniform distribution between 0 and 1:
?runif
runif(min = 0, max = 1, n = 10)
runif(min = 0, max = 1, n = 1000000) -> thous_unif
hist(thous_unif) # my first graphics in R!!!!

# generating points according to a normal distribution (Gaussian law)
rnorm(n = 1000000, mean = 2, sd = 0.2) -> normvec
hist(normvec, breaks = 100)
