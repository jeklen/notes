library(class) ## needed for KNN
setwd("D:/BA/KNN")
RidingMowers <- read.csv("RidingMowers.csv",header = TRUE)
RM <- cbind.data.frame ( scale(RidingMowers$Income),
             scale(RidingMowers$Lot_Size))
#上面的语句对Income和LotSize进行标准化，然后把2列重新组合成一个dataframe（使用cbind.data.frame语句）
#如果使用cbind语句，那么factor型数据会被强制转化成数值（level值），而不是factor型数据的值。
#可以试一下 cbind (RidingMowers$Ownership) 看有什么结果。
colnames(RM) <- c("Income","LotSize") #对2个列重命名。

#训练数据集有18个数据，我们打算对剩下6个数据进行分类。
set.seed(400)
#试一下set.seed(200)看有什么结果？设置随机数种子是为了重现结果。
trainidx <- sample(1:24,18)
mytrain <- RM[trainidx,] #mytrain是训练数据集的预测变量
mytest <- RM[-trainidx,] #mytest是验证数据集的预测变量
classification_of_train <- RidingMowers[trainidx,"Ownership"]
#classification_of_train是训练数据集的结果变量
classification_of_test <- RidingMowers[-trainidx,"Ownership"]
#classification_of_test是验证数据集的结果变量

nearest1 <- knn(train = mytrain, test = mytest, classification_of_train, k=3)
nearest2 <- knn(train = mytrain, test = mytest, classification_of_train, k=6)

data.frame(classification_of_test, nearest1, nearest2)
pcorrn1=sum(classification_of_test==nearest1)/6
pcorrn1
pcorrn2=sum(classification_of_test==nearest2)/6
pcorrn2
