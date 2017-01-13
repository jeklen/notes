library(cluster) #needed for hierachical clustering
### *** European Protein Consumption, in grams/person-day *** ###
## read in the data
setwd("D:/BA/Clustering")
food <- read.csv("protein.csv")
## we use the program agnes in the package cluster
## argument diss=FALSE indicates that we use the dissimilarity
## matrix that is being calculated from raw data.
## argument metric="euclidian" indicates that we use Euclidian
## distance
## no standardization is used as the default
## the default is "average" linkage
## Using data on all nine variables (features)
## Euclidean distance and average linkage
foodagg=agnes(food,diss=FALSE,metric="euclidian")
plot(foodagg) ## dendrogram