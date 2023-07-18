install.packages("caret")

library(tidymodels)
library(reshape2)
library(ggplot2)
library(janitor)
library(rsample)

#1 Collect Data
pk <- read.csv("Pokemon.csv")

#2 Clean Data
pk <- pk |> clean_names() |>
  select(-x)

pknum <- pk |> mutate(type_1 = as.integer(as.factor(type_1)), 
                type_2 = as.integer(as.factor(type_2)), 
                legendary = as.integer(as.factor(legendary))) |>
  select(-name)

#3 Visualize Data

#PCA
pkpca <- prcomp(pknum, scale. = T)
summary(pkpca)
pkpca_val <- as.data.frame(pkpca$x)
head(pkpca_val)
pkpca_val$legendary <- pk$legendary
ggplot(pkpca_val, aes(PC1, PC2, color = legendary)) + geom_point() + 
  theme_minimal()

#finding variation and percentage of variation
evecs <- (pkpca$rotation)^2
evecs <- evecs / sum(evecs)
evecs
#Correlation
pkcor <- pknum |> cor() |> melt() |> as.data.frame()
ggplot(pkcor, aes(x = Var1, y = Var2, fill = value)) + 
  geom_tile() +
  scale_fill_gradient2()

#4 Feature Selection
#I want to classify the boolean "legendary".
#From my visual I can see that I should cut out the generation, type_1 
#and type_2 variables.
pkdata <- pk |> select(-name, -type_1, -type_2, -generation) |>
  mutate(legendary = as.factor(legendary))

#5 Separate Into Train/Test
pksplit <- initial_split(pkdata, prop = 0.75)
pktrain <- training(pksplit)
pktest <- testing(pksplit)

#6 Choose a Suitable Model
#Since I'm working to classify a boolean variable I will use logical regression
#that only works to classify binary variables

#7 Train Model
pkfit <- logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification") |>
  fit(legendary ~ total + ., data = pktrain)

#8 Test Model
pkresults <- pktest
pkresults$pred <- predict(pkfit, pktest)$.pred_class
pkresults

library(caret)

confusionMatrix(pkresults$legendary, pkresults$pred, mode = "everything", positive = "False")
#F1 score for determining if a pokemon is not a legendary is 0.96
confusionMatrix(pkresults$legendary, pkresults$pred, mode = "everything", positive = "True")
#F1 score for determining if a pokemon is a legendary is 0.4

?confusionMatrix()
