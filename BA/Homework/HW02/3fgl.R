library(class) ## needed for KNN
setwd("D:/BA/Homework/HW02")
fgl <- read.csv("fgl.csv",header = TRUE,sep=",")
summary(fgl)

#Na、Mg、Al、Si、K、Ca、Ba、Fe
fgl[,"Na"] <- factor(fgl[,"Na"])
fgl[,"Mg"] <- factor(fgl[,"Mg"])
fgl[,"Al"] <- factor(fgl[,"Al"])
fgl[,"Si"] <- factor(fgl[,"Si"])
fgl[,"K"] <- factor(fgl[,"K"])
fgl[,"Ca"] <- factor(fgl[,"Ca"])
fgl[,"Ba"] <- factor(fgl[,"Ba"])
fgl[,"Fe"] <- factor(fgl[,"Fe"])
fgl[,"type"] <- factor(fgl[,"type"])


Predictors <- fgl[,c("Na","Mg","Al","Si","K","Ca","Ba","Fe")]

model <- train(
  Predictors, fgl[,"type"],
  method='knn',
  #上面先列出Predictors, 然后是结果变量，然后说明使用KNN方法。
  tuneGrid = data.frame(k=1:8),
  #KNN模型当中k的取值范围从1到8。
  metric='Accuracy',
  #评价指标是“准确率” Accuracy
  trControl=trainControl(
    method='repeatedcv', 
    number=5, 
    repeats=20) )
#trControl 是对训练过程进行控制的函数。此处的method='repeatedcv'意思是使用repeated cross validation
#方法（重复交叉验证）。number=5表示做5-fold cross validation，意思是把数据集割成5块，然后做5次
#训练和验证，每次都取其中一块数据（1/5的数据）当验证数据集，剩下的当训练数据集。repeat=20表示上面的
#过程重复20次，等总共要做100次训练-验证。最终计算评价指标（此处是Accuracy）的平均值。

model
plot(model)
confusionMatrix(model)
