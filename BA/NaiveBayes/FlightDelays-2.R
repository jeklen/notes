library(e1071) ## needed for Naive Bayes
library(lattice) ## needed for package caret
library(ggplot2) ## needed for package caret
library(caret) ## needed for tuning Naive Bayes models
library(combinat) ## needed for package klaR
library(MASS) ## needed for package klaR
library(klaR) ## needed for tuning Naive Bayes models
setwd("D:/BA/NaiveBayes")
FlightDelays <- read.csv("FlightDelays.csv",header = TRUE)
names(FlightDelays)

FlightDelays[,"Weather"] <- factor(FlightDelays[,"Weather"])
#Weather应该是类别型变量（factor类型）。
FlightDelays[,"DAY_WEEK"] <- factor(FlightDelays[,"DAY_WEEK"])
#DAY_WEEK应该是类别型变量（factor类型）。

SchDepHour <- floor(FlightDelays[,"CRS_DEP_TIME"]/100)
SchDepHour <- factor(SchDepHour)
#SchDepHour应该是类别型变量（factor类型）。
FlightDelays <- cbind(FlightDelays,SchDepHour)

summary(FlightDelays)
sapply(FlightDelays,class)

Predictors <- FlightDelays[,c("ORIGIN","DEST","CARRIER","Weather",
                              "DAY_WEEK","SchDepHour")]
classifier<-naiveBayes(Predictors, FlightDelays[,"Flight.Status"]) 
table(predict(classifier, Predictors), FlightDelays[,"Flight.Status"])

model <- train(
  Predictors,
  FlightDelays[,"Flight.Status"], 
#先列出Predictors,然后是结果变量，此处是Flight.Status。
  method='nb',
# method = 'nb' 指的是使用Naive Bayes
  metric='Accuracy',
  #评价指标是“准确率” Accuracy
  trControl=trainControl(
    method='repeatedcv',  number=10,  repeats=2) )
#trControl 是对训练过程进行控制的函数。此处的method='repeatedcv'意思是使用repeated cross validation
#方法（重复交叉验证）。number=10表示做10-fold cross validation，意思是把数据集割成10块，然后做10次
#训练和验证，每次都取其中一块数据（1/10的数据）当验证数据集，剩下的当训练数据集。repeat=2表示上面的
#过程重复2次，等总共要做20次训练-验证。最终计算评价指标（此处是Accuracy）的平均值。

model
confusionMatrix(model)

data <- data.frame(predict(model$finalModel,Predictors)$posterior)
head(data)
myTable <- data.frame(cutoff=NULL,Loss=NULL)

for (i in seq(0.1,0.6,0.01)) {
#尝试截值(cutoff value)以步长0.01从0.1取到0.6
  mypred <- data.frame(pred =ifelse(data[,'delayed']>i,'delayed','ontime'))
#如果判断为delayed的概率大于截值则认为该记录的航班会delayed。
  myLoss <- sum(mypred[,'pred']!=FlightDelays[,"Flight.Status"] & FlightDelays[,"Flight.Status"]=='delayed')*3+
    sum(mypred[,'pred']!=FlightDelays[,"Flight.Status"] & FlightDelays[,"Flight.Status"]=='ontime')
#如果把delayed错判为ontime，成本是3。但是如果把ontime错判为delayed，成本只有1。
  myTable <- rbind(myTable,data.frame(cutoff=i,Loss=myLoss))
#把每步尝试的截值以及该截值所对应的损失合并起来组成一个数据框。
}
View(myTable)

qplot(cutoff,Loss,data=myTable,geom ="line")
idx <- which.min(myTable[,"Loss"])
myTable[idx,]
#从结果看，最佳的截值应该是0.26。
optcutoff <- myTable[idx,"cutoff"]
mypred <- data.frame(pred =ifelse(data[,'delayed']>optcutoff,'delayed','ontime'),
                     obs = FlightDelays[,"Flight.Status"])
table(mypred)
#上面是cutoff等于0.26情况下的混淆矩阵，下面看cutoff等于0.5情况下的混淆矩阵。
mypred <- data.frame(pred =ifelse(data[,'delayed']>0.5,'delayed','ontime'),
                     obs = FlightDelays[,"Flight.Status"])
table(mypred)
