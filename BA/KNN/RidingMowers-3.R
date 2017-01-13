library(caret)
setwd("D:/BA/KNN")
RidingMowers <- read.csv("RidingMowers.csv",header = TRUE)

Predictors <- RidingMowers[,c("Income","Lot_Size")]


myLoss <- function (data, lev = NULL, model = NULL) {
  out <- sum(data[,"pred"]!=data[,"obs"] & data[,"obs"]=='owner')*3
        +sum(data[,"pred"]!=data[,"obs"] & data[,"obs"]=='non-owner')
  names(out) <- "LOSS"
  -out
}

model <- train(
  Predictors, RidingMowers[,"Ownership"],
  method='knn',
#上面先列出Predictors, 然后是结果变量，然后说明使用KNN方法。
  tuneGrid = data.frame(k=1:17),
#KNN模型当中k的取值范围从1到17。
  metric='LOSS',
#评价指标是“准确率” Accuracy
  trControl=trainControl(summaryFunction = myLoss,
    method='repeatedcv', 
    number=4, 
    repeats=20) )
#trControl 是对训练过程进行控制的函数。此处的method='repeatedcv'意思是使用repeated cross validation
#方法（重复交叉验证）。number=4表示做4-fold cross validation，意思是把数据集割成4块，然后做4次
#训练和验证，每次都取其中一块数据（1/4的数据）当验证数据集，剩下的当训练数据集。repeat=30表示上面的
#过程重复20次，等总共要做80次训练-验证。最终计算评价指标（此处是Accuracy）的平均值。

model
plot(model)
confusionMatrix(model)

Predictors_Example <- data.frame(Income=80, Lot_Size=20)
predict(model$finalModel,Predictors_Example)
