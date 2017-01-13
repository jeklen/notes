include(stats) #needed for kmeans
setwd("D:/BA/Clustering")
Utilities <- read.csv("Utilities.csv")
set.seed(1) ## to fix the random starting clusters
grpUtilities <- kmeans(Utilities[,c("Sales","Fuel_Cost")], centers=3,
                  nstart=10)
grpUtilities
o=order(grpUtilities$cluster)
data.frame(Utilities$Company[o],grpUtilities$cluster[o])

## plotting cluster assignments on scatter plot
plot(Utilities$Sales, Utilities$Fuel_Cost, type="n", xlab="Sales",
     ylab="Fuel_Cost")
text(x=Utilities$Sales, y=Utilities$Fuel_Cost, labels=Utilities$Company,
     col=grpUtilities$cluster+1)

## same analysis, but now with clustering on all
## protein groups
## change the number of clusters to 5
set.seed(1)
grpUtilities <- kmeans(Utilities[,-1], centers=5,   nstart=10)
o=order(grpUtilities$cluster)
data.frame(Utilities$Company[o],grpUtilities$cluster[o])

## plotting cluster assignments on scatter plot
plot(Utilities$Sales, Utilities$Fuel_Cost, type="n", xlab="Sales",
     ylab="Fuel_Cost")
text(x=Utilities$Sales, y=Utilities$Fuel_Cost, labels=Utilities$Company,
     col=grpUtilities$cluster+1)

