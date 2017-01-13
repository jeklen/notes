library(arules) ## needed for Association Rules Mining

setwd("D:/BA/AR")
Titanic <- read.csv("Titanic.csv",header = TRUE)

rules <- apriori(Titanic)
inspect(rules)

# 下面找出后项为“Survived”的规则。
rules <- apriori(Titanic, parameter = list(minlen=2, supp=0.005, conf=0.8),
                 appearance = list(rhs=c("Survived=No", "Survived=Yes"), default="lhs"),
                 control = list(verbose=F))
# minlen - an integer value for the minimal number of items per item set (default: 1)
# supp - a numeric value for the minimal support of an item set (default: 0.1)
# conf - a numeric value for the minimal confidence of rules/association hyperedges (default: 0.8)
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)

# 找到冗余规则
#subset.matrixA <- is.subset(rules.sorted, rules.sorted)
#subset.matrix <- subset.matrixA
#subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
#redundant <- colSums(subset.matrix, na.rm=T) >= 1
#which(redundant)
# 移除冗余规则
#rules.pruned <- rules.sorted[!redundant]
#inspect(rules.pruned)
#以上移除冗余规则的算法并没有成功把所有冗余规则移除，下面是新的算法。

redundant <-{}
for (i in 1:(length(rules.sorted)-1)) {
  for (j in (i+1):length(rules.sorted)) {    
    if (is.subset(rules.sorted[i],rules.sorted[j])) { redundant <- append(redundant,j) }
    if (is.subset(rules.sorted[j],rules.sorted[i])) { redundant <- append(redundant,i) }
  }
}
redundant
redundant <- unique(redundant)
rules.pruned <- rules.sorted[-redundant]
inspect(rules.pruned)