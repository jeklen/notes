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
#����������ֵ�ʱ�����������ʾ����������ʱ��Ҫ�ڻ���������ͼֽ�ϼ���һЩmargin��
#margin = 0.1����һЩmargin��marginֵ���Ե������margin=0.2��ô��Ե�Ŀռ�͸��������ʾ���֡�
text(bodyfat_rpart)

#�����Ǿ�����������2�ֻ�����
library(rpart.plot) # for the function rpart.plot
library(rattle) # for the function fancyRpartPlot
rpart.plot(bodyfat_rpart)
fancyRpartPlot(bodyfat_rpart)
asRules(bodyfat_rpart)

#���¶Ծ��������м�֦��
opt <- which.min(bodyfat_rpart$cptable[,"xerror"])
#ͨ��cptable�۲��ĸ�����xerrorֵ��С��
bodyfat_rpart$cptable
opt
cp <- bodyfat_rpart$cptable[opt, "CP"]
#ѡ��xerror��С�������ҵ�������Ӧ��cpֵ��
bodyfat_prune <- prune(bodyfat_rpart, cp = cp)
#��������õ���cpֵ���м�֦��
print(bodyfat_prune)
#��֦֮��õ��ľ�������xerrorֵ��С�ľ�������

plot(bodyfat_prune)
text(bodyfat_prune, use.n=T)