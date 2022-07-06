# functions to get descriptive stats:
mean(normvec) 
sd(normvec) # standard deviation
median(normvec)
summary(normvec) -> summ # returns a named vector
is.vector(summ)
str(summ)
str(normvec)
head(normvec) # the first six values
head(normvec, n = 10)
tail(normvec, n = 10) # the last 10 elements

# name vector elements
head(normvec) -> v6
names(v6) # names are not set
c("a", "lolo", "toto", "nana", "noah", "noël") -> names(v6)
# handling named vectors
v6
v6[3]
v6['nana'] # use a name to mean an index position

# vectorized operations
sqrt(c(1,4))
1:2 + c(100,5)
sqrt(c(1,4,25,100))

# first steps with tidyverse
library(tidyverse) # loading the tidyverse collection of packages in my environment

# importing data from a csv file
read_csv("livestockTLU.csv") -> TLUtable

# using the pipe operator %>% 
# piping is providing as the first argument in the RHS function call the value of the LHS
spec(TLUtable) # without any pipe
TLUtable %>% spec()
v2 %>% c(v2, c(1,2,3)) %>% length() 

# counting the different values in a column
TLUtable %>% count(hgh_prd_cattle)

# getting the mean of TLU_sold per ha:
TLUtable %>% summarise(meanTLUsold = mean(TLUsold_ha, na.rm=T))
