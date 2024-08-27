###############
### VECTORS ###
###############

1 # is already a vector
# we introduce a new function is.vector() whose purpose is to test whether the given object is a vector
is.vector(1)
is.vector("john")
# vectors are meant to contain several elements:
1,5,8,9 # syntax error
# to create a vector from multiple elements, use c() for "combine"
c(1,5,8,9)
?c # to call the help on the function c()
# above is a function call whereby 4 objects have been passed to c()
1:50 # sequence of integers
2046:2099
# besides c() and the colon, we can use seq to create sequences of numeric values into a vector
seq(2046,2099) # same as 2046:2099
seq(5,1) # decreasing sequence
?seq
# all arguments to seq() have *predefined values*
seq()

seq(to=4) # specifying only some of the arguments
seq(from=4) # TODO: check why not 4 3 2 1
seq(from=4, to=1)
seq(from = 0, to = 1) # two integers in the resulting sequence
seq(from = 0, to = 1, length.out = 10) # specifying the length of the output vector
seq(from = 0, to = 1, by = 0.1) # specifying the increment
# BEWARE! argument names are predefined in the function definition
seq(from = 0, to = 1, step = 0.1) # specifying the increment
seq(from = 0, to = 1, increment = 0.1) # specifying the increment

# recap: we know of three ways to create numeric vectors:
# using c() to combine any number of arbitrary elements (not necessarily numeric values, actually)
# using the colon (:) to create a sequence of consecutive integers
# using seq() to create a sequence of regularly-spaced numeric values

####
# elements in a vector all have same type
####

c(3, TRUE, 3.5)
# automatic casting of logicals into numerics:
# TRUE -> 1 and FALSE -> 0
c(3, FALSE, 3.5)
TRUE + TRUE
c("jb", TRUE, 4)
# automatic casting to strings (the "broadest" type)

# casting rules: logical -> double -> character

# besides automatic casting, we have as.xxxxx() functions to perform casting
as.numeric(FALSE)
as.character(4.00)
as.character(4.02)

as.logical(3) # everything except 0 translates into TRUE
as.logical(0)

######
## variable assignment
######

348:399 -> my_sequence # no spaces in variable names
my_sequence <- 348:399 # exact same as above
348:399 <- my_sequence # ERROR
4 <- my_sequence # ERROR: cannot assign to 4
1ae <- 5 # ERROR: a variable name must not start with a digit
ae <- 5

# The destination of an assignment operator (arrow) is always the name of the variable.

###########
# working with vectors
###########

# I can ask the length() of a vector, as the number of elements it contains:

length(my_sequence)
# the answer itself is a vector of length 1:
length(length(my_sequence))
length(52)
length(c(3,-6))

# extracting elements from a vector with square brackets
my_sequence[4]
# one can also extract slices:
my_sequence[4:6]

# extract the first, the third and the fifth elements:
my_sequence[1:5] # wrong: gives first five elements
my_sequence(1,3,5) # wrong: attempt at executing a function call
my_sequence[1,3,5] # wrong: my_sequence doesn't have 3 dimensions
my_sequence[1:3:5] # syntax error: construct with two colons is undefined
c(1,3,5) # this is the vector I want to use to address my_sequence
my_sequence[c(1,3,5)] # what we wanted

# also good:
c(my_sequence[1], my_sequence[3], my_sequence[5])

#extract one out of every two elements: the 1st, 3rd, 5th, 7th, etc
my_sequence[ seq(from = 1, to = 52, by = 2)]

# more generic: give the upper boundary as a calculated value
my_sequence[ seq(from = 1, to = length(my_sequence), by = 2)]


my_sequence # is unaffected by the previous lines

#if you want to modify it:
my_sequence <- my_sequence[ seq(from = 1, to = length(my_sequence), by = 2)]



# beware of out-of-bounds indices
length(my_sequence)
my_sequence[30] # returns the NA object

# vectors are assignable "in place":
my_sequence[3] <- 1000
my_sequence
my_sequence[35] <- 6.6
my_sequence

# the NA object means "unassigned" or "unavailable" datapoint

######################
# vectorized functions
######################

# by default, all operations in R are meant to work on vectors, in an element-wise fashion

sqrt(4) # square root
sqrt(5,9) # sqrt() accepts only one argument

# but that one argument can very well be a vector containing many elements:
sqrt(my_sequence)

# if necessary, vectors are recycled:
my_sequence + 2

my_sequence + c(-2,2)
sin(my_sequence)

##########################
# some useful descriptive stats functions:
##########################
mean(my_sequence) # NA
?mean
mean(my_sequence, na.rm = TRUE) # the mean of the non-NA values
median(my_sequence) # NA
median(my_sequence, na.rm = TRUE)

summary(my_sequence) # predefined and versatile function


#######
#### random number generation
#########

# generating a vector of 100 values randomly chosen between 10 and 15:
runif(n = 100, min = 10, max = 15) # "r" for "random number generation", "unif" for "uniform probability law"

# generating a vector of 100 values randomly chosen according to a normal law with location parameter 10 and standard deviation 1.5:
rnorm(n = 100, mean = 10, sd = 1.5) # "r" for "random number generation", "norm" for "normal probability law", aka Gaussian law


####################
##### introducing DATA FRAMES
######################

# We know a vector cannot contain objects of different types.
# A *data frame* is a table where columns can be of a different nature from each other.
# Each column in a data frame is a vector.

mydata <- data.frame(rowid = 1:12,
                     months = month.name,
                     random_numbers = rnorm(12))

str(mydata) # very versatile function giving the internal structure of an object
View(mydata)
is.data.frame(mydata) # TRUE
is.data.frame(my_sequence) # FALSE
typeof(mydata) # a data.frame object is internally a list of columns

# possible to create a data frame without naming its columns,
# in which case automatic names are given
mydata_unnamed_cols <- data.frame(1:12, month.name, rnorm(12))

# it is an error to generate a data frame based on variables (columns) of different lengths:
data.frame(1:12, month.name, rnorm(13))
# conversions

c(1,3,"Mo")


# force connversion:
as.numeric("Mo")
as.numeric(c("Mo", "4.0", "4e+3"))
