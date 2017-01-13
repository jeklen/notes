setwd("D:/BA/Homework/HW03")
library(arules) ## needed for Association Rules Mining

cosmetics <- read.csv("Cosmetics.csv",header = TRUE)
data = cosmetics[, -1]
head(data)

rules <- apriori(data, parameter = list(maxlen=20, supp=0.1, conf=0.5),
                 appearance = list(lhs=c("Nail.Polish=yes"), default="rhs"),
                 control = list(verbose=F))
inspect(rules)

rules <- apriori(data, parameter = list(maxlen=20, supp=0.1, conf=0.5),
                 appearance = list(lhs=c("Mascara=yes"), default="rhs"),
                 control = list(verbose=F))
inspect(rules)


