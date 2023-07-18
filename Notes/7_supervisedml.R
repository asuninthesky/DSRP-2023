install.packages("tidymodels")
install.packages("ranger")
install.packages("xgboost")
install.packages("reshape2")


library(dplyr)
## Step 1 Collect Data
head(iris)

# Step 2 Clean and Process Data

#removing NAs
noNAs <- na.omit(starwars)
noNAs <- filter(starwars, !is.na(mass))

#alternatively replace with mean
replaceWithMean <- mutate(starwars, mass = ifelse(is.na(mass), mean(mass), mass))

#Encoding categories as factors or integers
#if categorical is a character, make it a factor
intSpecies <- mutate(starwars, species = as.integer(as.factor(species)))
intSpecies
irisAllNumeric <- mutate(iris, Species = as.integer(Species))
## Step 3 Visualize Data
library(reshape2)
library(ggplot2)

irisCors <- irisAllNumeric |> cor() |> melt() |> as.data.frame()
irisCors

ggplot(irisCors, aes(x = Var1, y = Var2, fill = value)) + geom_tile() +
  scale_fill_gradient2()
#from heat map we can see that petal length and sepal length seem to be correlated
ggplot(irisAllNumeric, aes(x = Petal.Length, y = Sepal.Length)) + geom_point()


#Step 4 Perform  Feature Selection
#Choose which variables you want to classify or predict 
#Choose which variables you want to use as features in your model
#For iris data:
#Classify on Species(Classification) & Predict on Sepal.Length(Regression)

#Step 5 Separate data into train/test datasets
#at least 2x amount of data for training than testing 
#choose 70-85% data to train on
library(rsample)

#Put 75% of data into training set
#Set a seed for reproducability
set.seed(71723)

#Regression
#Create a split
reg_split <- initial_split(irisAllNumeric, prop = .75)
#Use split to seperate into to datastructures
reg_train <- training(reg_split)
reg_test <- testing(reg_split)

## Classification dataset splits (use iris)
class_split <- initial_split(iris, prop = .75)
class_train <- training(class_split)
class_test <- testing(class_split)
class_test

#Step 6 Choose suitable model: https://parsnip.tidymodels.org/articles/Examples.html 

##LINEAR REGRESSION 
library(parsnip)
#Step 7: Train Model
lm_fit <- linear_reg() |> 
  set_engine("lm") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ Petal.Length + Petal.Width + Species + Sepal.Width, data = reg_train)
##    Dependent ~ Independent

lm_fit$fit # Interpret: Sepal.Length =2.3125+0.7967*Petal.Length-0.4067*Petal.Width-0.3312*Species0.5501*Sepal.Width  

summary(lm_fit$fit)

##LOGISTIC REGRESSION
#Logical regression only works on binary (2 groups)
#1. Filter data into only 2 groups
#2. Make catagorical variable a factor
#3. Make training/testing splits

#for example purposes only, don't filter test data 
binary_test_data <- filter(class_test, Species %in% c("setosa", "versicolor"))
binary_train_data <- filter(class_train, Species %in% c("setosa", "versicolor"))

log_fit <- logistic_reg()|>
  set_engine("glm") |>
  set_mode("classification") |>
  fit(Species ~ Petal.Width + Petal.Length +., data = binary_train_data)

log_fit$fit
summary(log_fit$fit)

##Boosted Decision Tree
#regression
boost_reg_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

boost_reg_fit$fit

#classification
boost_class_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

boost_class_fit$fit
boost_class_fit$fit$evaluation_log


##Random Forest
#regression
forest_reg_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

forest_reg_fit$fit

#classification
forest_class_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

forest_class_fit$fit


##Step 8 Evaluate Model Performance on Test Set
#Calculate errors for regression
library(yardstick)
reg_results <- reg_test
reg_results$lm_pred <- predict(lm_fit, reg_test)$.pred
reg_results$boost_pred <- predict(boost_reg_fit, reg_test)$.pred
reg_results$forest_pred <- predict(forest_reg_fit, reg_test)$.pred
reg_results

mae(reg_results, Sepal.Length, lm_pred)
mae(reg_results, Sepal.Length, boost_pred)
mae(reg_results, Sepal.Length, forest_pred)

rmse(reg_results, Sepal.Length, lm_pred)
rmse(reg_results, Sepal.Length, boost_pred)
rmse(reg_results, Sepal.Length, forest_pred)

#Calculate accuracy for classification models
install.packages("Metrics")
library(Metrics)

class_results <- class_test

class_results$log_pred <- predict(log_fit, class_test)$.pred_class
class_results$boost_pred <- predict(boost_class_fit, class_test)$.pred_class
class_results$forest_pred <- predict(forest_class_fit, class_test)$.pred_class
class_results

