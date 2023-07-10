dataset <- read.csv('Pokemon.csv')
library(ggplot2)
head(dataset)
#numerical distribution
ggplot(data = dataset, aes(x = Total)) + geom_histogram() + 
  labs(title = "Distribution of Pokemon Stats", x = "Sum of All Stats") 
#numeric vs categorical
ggplot(data = dataset, aes(x = Type.1, y = Defense)) + geom_bar(stat = "summary", fun = "mean") + 
  labs(title = "Average Defense Compared to Primary Typing", x = "Primary Type", y = "Average Defense Stat")
#numeric vs numeric
ggplot(data = dataset, aes(x = Attack/Total, y = Defense/Total, color = Legendary)) + geom_point() + 
  geom_smooth(se=F) + scale_color_manual(values = c("darkgrey", "red")) + 
  labs(title = "Attack value/Total stats vs Defense value/Total stats")

