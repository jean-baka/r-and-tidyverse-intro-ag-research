# comparing boxplots made with base R and with ggplot2:

block_design_example <- read_csv("block_design_example.csv")

# boxplot with base R, with DryMatterIntake as quantitative variable and
# the Breed as grouping variable:
boxplot(DryMatterIntake ~ Breed, data = block_design_example)

# the same plot with ggplot2, more beautiful:
block_design_example %>% ggplot(mapping = aes(x = Breed, y = DryMatterIntake)) + geom_boxplot()
