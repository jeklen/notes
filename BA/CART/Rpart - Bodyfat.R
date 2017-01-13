library(TH.data)
library(rpart)
library(rpart.plot) # for the function rpart.plot
library(rattle) # for the function fancyRpartPlot

data("bodyfat", package="TH.data")
dim(bodyfat)
bodyfat[1:5,]

set.seed(1234)
ind <- sample(2, nrow(bodyfat), replace=TRUE, prob=c(0.7, 0.3))
bodyfat.train <- bodyfat[ind==1,]
bodyfat.test <- bodyfat[ind==2,]
# train a decision tree
myFormula <- DEXfat ~ age + waistcirc + hipcirc + elbowbreadth + kneebreadth
bodyfat_rpart <- rpart(myFormula, data = bodyfat.train,
                 control = rpart.control(minsplit = 10))
#minsplit: the minimum number of observations that must exist in a node in order for a split to be attempted.
attributes(bodyfat_rpart)

?rpart.object
print(bodyfat_rpart$cptable)
#a matrix of information on the optimal prunings based on a complexity parameter.
print(bodyfat_rpart)
plot(bodyfat_rpart)
text(bodyfat_rpart, use.n=T)

plot(bodyfat_rpart,margin=0.1)
#下面加上文字的时候可能文字显示不出来，这时候要在画决策树的图纸上加上一些margin。
#margin = 0.1加上一些margin，margin值可以调，如果margin=0.2那么边缘的空间就更多便于显示文字。
text(bodyfat_rpart)

#下面是决策树的另外2种画法。
library(rpart.plot) # for the function rpart.plot
library(rattle) # for the function fancyRpartPlot
rpart.plot(bodyfat_rpart)
fancyRpartPlot(bodyfat_rpart)
asRules(bodyfat_rpart)

#以下对决策树进行剪枝。
opt <- which.min(bodyfat_rpart$cptable[,"xerror"])
#通过cptable观察哪个树的xerror值最小。
bodyfat_rpart$cptable
opt
cp <- bodyfat_rpart$cptable[opt, "CP"]
#选择xerror最小的树，找到它所对应的cp值。
bodyfat_prune <- prune(bodyfat_rpart, cp = cp)
#根据上面得到的cp值进行剪枝。
print(bodyfat_prune)
#剪枝之后得到的决策树是xerror值最小的决策树。

plot(bodyfat_prune)
text(bodyfat_prune, use.n=T)
