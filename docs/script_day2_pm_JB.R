read_csv("Lungcancer.csv") -> lgc
table(lgc$Sex, lgc$Lungcancer) -> contingency_base

# getting "the same" contingency table with tidyverse: 
lgc %>% group_by(Sex) %>% count(Lungcancer, name = "counts") %>% pivot_wider(names_from = Lungcancer, values_from = counts) -> contingency_tibble

# tests with the "base R" contingency table:
chisq.test(contingency_base) # X-squared 0.31436, pval 0.575
fisher.test(contingency_base) # pval 0.4539


# tests with the contingency tibble:
# we have to remove column one that is the Sex column (~row names)
str(contingency_tibble)
chisq.test(as.matrix(contingency_tibble[-1]))
fisher.test(as.matrix(contingency_tibble %>% ungroup() %>% select(-1)))




# additional stuff: count the number of NAs in a whole dataset, irrespective of columns where those sit.
# strategy: we sum the number of NAs per column, and then sum them all in a row.
households %>% summarise(across(.fns = ~sum(is.na(.)))) %>% transmute(grand_total_NAs = sum(c_across()))

######
###### on to more ggplot now
######

#let's go back to our first scatterplot:

households %>% ggplot(mapping = aes(x = education, y = fem_totadult)) + geom_point() -> base_plot

# evaluating this base plot actually... plots it!
base_plot

# we can add layers as we evaluate:
# for instance, we can add a title and modify the labels:
base_plot + labs(title = "My first scatterplot", x = "years of education", y = "ratio of female members in household") -> with_title

with_title

# we can also color points according to some other variable in the dataset. This aesthetic can either be set in the call to ggplot or to geom_point ("mapping" parameter)
households %>% ggplot(mapping = aes(x = education, y = fem_totadult, fill = any_agric)) + geom_point() + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household") 

# interesting: we see the legend, but it seems the fill parameter is not used with these default points. Let's use colour instead of fill:
households %>% ggplot(mapping = aes(x = education, y = fem_totadult, colour = any_agric)) + geom_point() + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household")

# observations:
# (1) the colour has been implemented as a gradient with default blue colours
# (2) there seem to be very few datapoints with any_agric == 0. Let's check:
households %>% count(any_agric)

# ok, we see there are ~10 times fewer observations with any_agric = 0, but the strange things is that these 42 observations seem to overlap on actually just 5 points. Let us artificially jitter the points so that we add a bit of random noise to their x position, in order to see the points separate.

households %>% ggplot(mapping = aes(x = education, y = fem_totadult, colour = any_agric)) + geom_jitter() + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household")

# actually, we see that some of the "black" points (any_agric==0) were hidden by "blue" points (any_agric == 1)
# in order to prevent this hiding, we can pick two well-contrasted colours and also use the alpha parameter to get some level of transparency.

# To pick colours, we add a parameter to explain that the colour aesthetic should still be a gradient, but with different low and high values:
households %>% ggplot(mapping = aes(x = education, y = fem_totadult, colour = any_agric)) + geom_jitter() + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household") + scale_colour_gradient(low = "red", high = "green")

# and if we want to add some transparency:
?geom_jitter

households %>% ggplot(mapping = aes(x = education, y = fem_totadult, colour = any_agric)) + geom_jitter(alpha = 0.5) + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household") + scale_color_gradient(low = "red", high = "green")

# we can also increase the amount of jittering, moving the points with gaussian noise of a reduced spread around their true positions:

households %>% ggplot(mapping = aes(x = education, y = fem_totadult, colour = any_agric)) + geom_jitter(alpha = 0.2, width = 0.2, height = 0.2) + labs(title = "Scatterplot with colours", x = "years of education", y = "ratio of female members in household") + scale_color_gradient(low = "red", high = "green")
