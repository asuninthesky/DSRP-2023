##load require libraries
library(dplyr)
library(ggplot2)
##Compare the mass of male and female starwars characters
swHumans <- starwars |> filter(species == "Human", mass > 0)
males <- swHumans |> filter(sex == "male")
females <- swHumans |> filter(sex == "female")

t.test(males$mass, females$mass, paired = F, alternative = "two.sided")
#p value is 0.06
#not significant, failed to reject null hypothesis


anova_results <- aov(Petal.Width ~ Species, iris)
summary(anova_results)
TukeyHSD(anova_results)


###Starwars
head(starwars)
unique(starwars$species)

##Which 5 species are the most common
top3species <- starwars |> summarize(.by = species, count = sum(!is.na(species))) |> slice_max(count, n = 3)
top3species

swt3spec <- starwars |> filter(species %in% top3species$species)

swt3spec


##Is there a significant difference in the mass of each top 3 species
anovastar <- aov(mass ~ species, swt3spec)
summary(anovastar)
TukeyHSD(anovastar)

##Is there a significant difference in the height of each top 3 species
anovastar2 <- aov(height ~ species, swt3spec)
summary(anovastar2)
TukeyHSD(anovastar2)

##chi squared
#make contigency table
t <- table(mpg$year, mpg$drv)

install.packages("corrplot")
library(corrplot)

c <- chisq.test(t)
c$p.value
c$residuals

corrplot(c$residuals, is.core = F)
