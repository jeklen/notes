library(stats) #needed for kmeans
setwd("D:/BA/Homework/HW03")
## read in the data
city <- read.csv("RealEstate.csv")

cityagg=agnes(city,diss=FALSE,metric="euclidian")
plot(cityagg) ## dendrogram


library(party)

myFormula <- City ~ AvgPrice + GDP_PC + AvgMSalary + AvgMNetIncome + CPI
#city_ctree <- ctree(myFormula, data = city)

library(TH.data)
library(rpart)
library(rpart.plot) # for the function rpart.plot
library(rattle) # for the function fancyRpartPlot


# train a decision tree
bodyfat_rpart <- rpart(myFormula, data = city,
                       control = rpart.control(minsplit = 2))
plot(bodyfat_rpart)
text(bodyfat_rpart, use.n=T)
