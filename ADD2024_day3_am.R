# SAVING DATA
# we can save objects efficiently, to be reopened by R at a later stage.

# I can save several objects into one file:
save(dat, dat2, a, file = "mydata.Rdata")

# I quit R without saving the environment,
# and then, after reopening R, I load the objects
# I had saved:

load(file = "mydata.Rdata")
# the saved objects are now back into my working environment.

# save.image() saves the whole environment
# i.e. all the objects currently present in it
b <- sample(1:2, size=10, replace = T)
save.image("wholedata.Rdata") # b is in that.


# rm() deletes objects from your current environment
rm(a,b)
load("wholedata.Rdata")


# Apart from sample(), we can use random generation
# functions to generate random vectors.

# All these random generation functions will start
# with "r" (for "random") and contain a keyword
# corresponding to the well-known distribution
# used to sample from:
# runif() to sample from a uniform distribution,
# rnorm() to sample from a normal (Gaussian) distribution,
# rpois() to sample from a Poisson distribution,
# rbinom() to sample from a binomial distribution,
# etc;

# generating a random number uniformly between 0 and 100:
set.seed(475639) # initializes the internal
# random number generator of R in a specific state.
# This ensures reproducibility across computers
# and across time.

runif(n = 1, min = 0, max = 100) 
# and again:
runif(n = 1, min = 0, max = 100) 

# generate a longer vector:
runif(n = 1000, min = 0, max = 100) 

# one example with rnorm:
rnorm(n = 1000, mean = 4.0, sd = 2)

# a tighter sample around 10:
rnorm(n = 1000, mean = 10.0, sd = 1e-4)

# round() function to round numbers:
rnorm(n = 10, mean = 4.0, sd = 2) |> round(2)

# more with tidyverse: join()ing tibbles.

# we first reload the data
library(tidyverse)
library(readxl)
dat <- read_xlsx("livestock_data.xlsx", sheet = 1)
dat2 <- read_xlsx("livestock_data.xlsx", sheet = 2)

# before joining, it's good to check
# the characteristics of the tables we are going to join

# let's check whether we have duplicate qno values in any of the two sheets:
# there is a function unique() that removes duplicates from a vector:
unique(c(1,23,2,3,1,2,2,2,3,-1))

dat2$qno |> unique() |> length() # 527 unique values
nrow(dat2) # also 527

# shorthand: anyDuplicated() function
anyDuplicated(c(1,23,2,3,1,2,2,2,3,-1))
anyDuplicated(dat2$qno) # 0 means there is no duplicated value

# check also on dat:
anyDuplicated(dat$qno) # no duplicate here either.

# we now check the overlap between
# the households present in the first sheet
# and the ones in the second sheet:
intersect(dat$qno, dat2$qno) |> length()

# the difference:
setdiff(dat2$qno, dat$qno) |> length()
nrow(dat2) - nrow(dat) # same

# 81 households were initially surveyed (dat2)
# but not included in the later survey of farm
# performance.

# JOINING, FINALLY!

dat2 |> left_join(dat, by = "qno") |> View()
# in the above, all 527 rows from dat2
# appear in the resulting joined table

dat2 |> right_join(dat, by = "qno") |> View()
# here, only 446 rows have been preserved

# in we wanted to change the order in which columns appear (production values first, socioeconomics after):
dat |> left_join(dat2, by = "qno") -> full_data

# in order to combine tables containing same
# (subset of) variables, use bind_rows().
# The result is a longer, not necessarily wider, table.


# VISUALIZATIONS WITH ggplot2

# I will plot a scatterplot (points in a 2D plane)
# with stocking_rate as x values and
# TLUsold_ha as y values

full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) # produces an empty grid with the right dimensions

full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) + geom_point()
# how do we check that indeed 68 rows had a missing
# value in at least one of the two columns used
# for x and y coordinates?

full_data |> filter(is.na(stocking_rate) | is.na(TLUsold_ha)) |> nrow()

# customizing the plot by adding layers

# labs() enables to customize axis labels and title of the graph
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point() +
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot")


# changing the shape of points:
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1) + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot")



# If I am bothered with the outliers:
# zoom in on an area

# check the outliers:
full_data |> filter(stocking_rate > 75)
full_data |> filter(TLUsold_ha > 20)

# we remove these two outliers from
# the visualization using xlim() and ylim()
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1) + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot") +
  xlim(0,45) + ylim(0,15)

# we can add layers very easily, by just adding geom_* objects:

full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1) + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot") +
  xlim(0,45) + ylim(0,15) +
  geom_smooth() # loess method resulting in a non-straight line

# let's try and get a simpler linear fit:
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1) + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot") +
  xlim(0,45) + ylim(0,15) +
  geom_smooth(method = lm, se = TRUE)


# changing colours
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1, colour = "orangered1") + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot") +
  xlim(0,45) + ylim(0,15) +
  geom_smooth(method = lm, se = TRUE, colour = "navyblue", fill = "lightsteelblue1", alpha = 0.60)


# Use themes to change the overall aspect of the graph, for instance theme_light()
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1, colour = "orangered1") + # open circles
  labs(x = "stocking rate of TLUs",
       y = "TLU sold per hectare",
       title = "My first scatterplot") +
  xlim(0,45) + ylim(0,15) +
  geom_smooth(method = lm, se = TRUE, colour = "navyblue", fill = "lightsteelblue1", alpha = 0.60) +
  theme_light() + theme(panel.background = element_rect(fill = "cornsilk1"))

# let's use a categorical variable (sex)
# in order to have a richer representation

# let's recode sex as a factor:
full_data |> mutate(sex = factor(sex)) -> full_data

# we want to have different shapes for male households
# and female households
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha, shape = sex)) +
  geom_point(colour = "orangered1")

# we may want to have separate graphs altogether,
# one for males and one for females:
# we use facet_grid() to have plots side by side
full_data |> ggplot(mapping = aes(x = stocking_rate, y = TLUsold_ha)) +
  geom_point(shape = 1, colour = "orangered1") +
  facet_grid(. ~ sex)


# there is more to ggplot2 than just scatterplots!

# let's try a boxplot
# representing the distribution of stocking_rates per sex
full_data |> ggplot(mapping = aes(x = sex, y = stocking_rate)) +
  geom_boxplot() +
  ylim(0,20)


# let's do a histogram:
full_data |> ggplot(aes(x = stocking_rate)) + geom_histogram() + xlim(0,25)

# violin plot is similar to a boxplot:
full_data |> ggplot(mapping = aes(x = sex, y = stocking_rate)) +
  geom_violin() +
  ylim(0,20)
