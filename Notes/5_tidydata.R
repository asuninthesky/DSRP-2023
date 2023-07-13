#install.packages("janitor")
#install.packages("tidyr")

library(tidyr)
library(janitor)
library(dplyr)

starwars
StarWarsWomen <- select(filter(arrange(starwars, birth_year), sex == "female"), name, species)
StarWarsWomen

slice_max(starwars, height, n = 2, by = species, with_ties=F)


##Tidy Data##
table4a
##pivot longer
pivot_longer(table4a, 
             cols = c(`1999`, `2000`),
             names_to = "year",
             values_to = "cases")w
##pivot wider
table2
pivot_wider(table2,
            names_from = type,
            values_from = count)
##separate
table3
separate(table3, 
         rate,
         into = c("cases", "population"),
         sep = "/")

##unite
table5
unite(table5,
      "year",
      c("century", "year"),
      sep = ".")
