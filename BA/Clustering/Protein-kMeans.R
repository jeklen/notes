library(stats) #needed for kmeans
setwd("D:/BA/Clustering")
### *** European Protein Consumption, in grams/person-day *** ###
## read in the data
food <- read.csv("protein.csv")
## first, clustering on just Red and White meat (p=2) and k=3
## clusters
set.seed(1) ## to fix the random starting clusters
grpMeat <- kmeans(food[,c("RedMeat","WhiteMeat")], centers=3,
                  nstart=10)
# nstart: if centers is a number, how many random sets should be chosen?
grpMeat
## list of cluster assignments
o=order(grpMeat$cluster)
data.frame(food$Country[o],grpMeat$cluster[o])

## plotting cluster assignments on Red and White meat scatter plot
plot(food$RedMeat, food$WhiteMeat, type="n", xlab="Red Meat",
     ylab="White Meat")
text(x=food$RedMeat, y=food$WhiteMeat, labels=food$Country,
     col=grpMeat$cluster+1)

## same analysis, but now with clustering on all
## protein groups
## change the number of clusters to 7
set.seed(1)
grpProtein <- kmeans(food[,-1], centers=7, nstart=10)
o=order(grpProtein$cluster)
data.frame(food$Country[o],grpProtein$cluster[o])

## plotting cluster assignments on Red and White meat scatter plot
plot(food$RedMeat, food$WhiteMeat, type="n", xlim=c(3,19), xlab="Red Meat",
     ylab="White Meat")
text(x=food$RedMeat, y=food$WhiteMeat, labels=food$Country,
     col=grpProtein$cluster+1)
