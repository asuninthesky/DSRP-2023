##Setup
library("dplyr")
library("tidyr")
library("janitor")
dataset <- read.csv("Pokemon.csv")

##Clean Data
dataset <- clean_names(dataset, "snake")

#1
#In Lab 3 I found that steel type pokemon have the highest defensive stats while 
#normal types have the lowest. In this lab I am testing whether or not steel has 
#significantly larger defensive values compared to normal. I will also exclude 
#legendary pokemon as they tend to have inflated stats.
#Null Hypothesis: The average defensive stat for non-legendary normal types is 
#                 not greater than the average defensive stat for non-legendary  
#                 steel types. This is a one-tailed unpaired test.

defense <- dataset |> filter(legendary == "False") |> select(type_1, type_2, defense)
steel <- defense |> filter(type_1 == "Steel" | type_2 == "Steel")
normal <- defense |> filter(type_1 == "Normal" | type_2 == "Normal")

t.test(steel$defense, normal$defense, paired = F, alternative = "greater")
#p-value = 2.559e-12, null hypothesis is succesfully rejected

#2
arrange(summarize(dataset, .by = type_1, m_total = mean(total)), desc(m_total))
#For this section I want to determine if their is a relationship between pokemon
#type and average stats.
#Null Hypothesis: There is no significant difference between the average stats
#                 of pokemon with a primary type of dragon, steel, flying, 
#                 poison and bug.

#Cleaning
f_data <- dataset |> 
  filter(type_1 == c("Dragon", "Steel", "Flying", "Poison", "Bug")) |>
  select(type_1, total)

a_data <- aov(total ~ type_1, f_data)
summary(a_data)
TukeyHSD(a_data)#The results show that there is only a significant difference 
                #in total stats between dragon and bug type pokemon.

#3
#In this section I want to test for a relationship between a pokemon's primary 
#type and legendary pokemon. NOTE: data is very sparse so chi-square test may
#be inaccurate 
t <- table(dataset$type_1, dataset$legendary)
t
c <- chisq.test(t)
c$p.value
c$residuals
