##SETUP
#install.packages("dplyr")
#install.packages("ggplot2")
library(dplyr)
library(ggplot2)
dataset <- read.csv("Pokemon.csv")


#1 Filtering data
filter(dataset, Type.1 == "Grass" | Type.2 == "Grass") #filters for only grass type pokemon

#2 Using select()
select(dataset, Total, Legendary) #isolates Total Stats and Legendary columns

#3 Add two new columns
#The first displays the ratio of attack to special attack which is useful when deciding to learn SPA or ATK moves
#The second displays the ratio of ATK + SPA to DEF + SPD which is useful to tell 
#whether a pokemon is more defense or attack oriented 
mutate(dataset, ATKtoSPA = Attack/Sp..Atk, Total_Attack_to_Total_Defense = (Attack + Sp..Atk)/(Defense + Sp..Def))

#4 Using summarize()
#Find the average of each stats for legendary and non-legendary pokemon
summarize(dataset, mean_stats = mean(Total), mean_HP = mean(HP), 
       mean_ATK = mean(Attack), mean_DEF = mean(Defense),
       mean_SPA = mean(Sp..Atk), mean_SPD = mean(Sp..Def), mean_SPE = mean(Speed),
       .by = Legendary)

#5 reorder a datatable using arrange()
arrange(select(dataset, Name, Total), desc(Total))#Order the pokemon from greatest total stats to least

#6 Create a visualization 
#using step 1's dataset
datanew <- filter(dataset, Type.1 == "Grass" | Type.2 == "Grass")
ggplot(data = datanew, aes(x = Generation)) + geom_bar() + labs(title = "Number of Grass Pokemon in Each Generation")
