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