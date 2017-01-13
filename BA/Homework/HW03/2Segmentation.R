setwd("D:/BA/Homework/HW03")

library(party)
market <- read.csv("Segmentation.csv")

#其实就是挑出数据
#iris_ctree <- ctree(Class ~ ., data=market)
# check the prediction
#plot(iris_ctree)
#plot(iris_ctree, type="simple")

library(rpart)
library(rpart.plot) # for the function rpart.plot
library(rattle) # for the function fancyRpartPlot
market_rpart <- rpart(Class ~ . , data = market,
                      control = rpart.control(minsplit = 100))

#minsplit: the minimum number of observations that must exist in a node in order for a split to be attempted.

plot(market_rpart)
text(market_rpart, use.n=T)

plot(market_rpart,margin=0.1)
text(market_rpart)
