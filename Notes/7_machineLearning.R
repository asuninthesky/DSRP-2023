### Unsupervised Learning ###
##Principal Components Analysis
head(iris)

library(dplyr)

##remove any non-numeric variables
iris_num <- select(iris, -Species)


##do PCA
pcas <- prcomp(iris_num, scale. = T)
summary(pcas)

pca_vals <- as.data.frame(pcas$x) #get x-value of pcas
head(pca_vals)
pca_vals$Species <- iris$Species
ggplot(pca_vals, aes(PC1, PC2, color = Species)) + geom_point() + 
  theme_minimal()

