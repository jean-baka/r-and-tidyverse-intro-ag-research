library(readr)
block_design_example <- read_csv("Work/StatsPackages/R/ILRI-RTraining_2022/block_design_example.csv")
View(block_design_example)
str(block_design_example)
block_design_example$Breed <- as.factor(block_design_example$Breed)
block_design_example$Treatment <- as.factor(block_design_example$Treatment)
block_design_example$Block <- as.factor(block_design_example$Block)
str(block_design_example)
boxplot(DryMatterIntake~Breed,data=block_design_example)
t.test(DryMatterIntake~Breed,data=block_design_example)
mymodel <- lm(DryMatterIntake~Block+Breed*Treatment,data=block_design_example)
summary(mymodel)
anova(mymodel)
plot(mymodel)
str(mymodel)
hist(mymodel$residuals)
library(emmeans)
emmeans(mymodel, pairwise ~ Treatment,data=block_design_example)
block_design_example$logDM <- ln(block_design_example$DryMatterIntake)
block_design_example$logDM <- log(block_design_example$DryMatterIntake)
mymodel <- lm(logDM~Block+Breed*Treatment,data=block_design_example)















