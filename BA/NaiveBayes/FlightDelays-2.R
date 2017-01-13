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
#WeatherӦ��������ͱ�����factor���ͣ���
FlightDelays[,"DAY_WEEK"] <- factor(FlightDelays[,"DAY_WEEK"])
#DAY_WEEKӦ��������ͱ�����factor���ͣ���

SchDepHour <- floor(FlightDelays[,"CRS_DEP_TIME"]/100)
SchDepHour <- factor(SchDepHour)
#SchDepHourӦ��������ͱ�����factor���ͣ���
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
#���г�Predictors,Ȼ���ǽ���������˴���Flight.Status��
  method='nb',
# method = 'nb' ָ����ʹ��Naive Bayes
  metric='Accuracy',
  #����ָ���ǡ�׼ȷ�ʡ� Accuracy
  trControl=trainControl(
    method='repeatedcv',  number=10,  repeats=2) )
#trControl �Ƕ�ѵ�����̽��п��Ƶĺ������˴���method='repeatedcv'��˼��ʹ��repeated cross validation
#�������ظ�������֤����number=10��ʾ��10-fold cross validation����˼�ǰ����ݼ����10�飬Ȼ����10��
#ѵ������֤��ÿ�ζ�ȡ����һ�����ݣ�1/10�����ݣ�����֤���ݼ���ʣ�µĵ�ѵ�����ݼ���repeat=2��ʾ�����
#�����ظ�2�Σ����ܹ�Ҫ��20��ѵ��-��֤�����ռ�������ָ�꣨�˴���Accuracy����ƽ��ֵ��

model
confusionMatrix(model)

data <- data.frame(predict(model$finalModel,Predictors)$posterior)
head(data)
myTable <- data.frame(cutoff=NULL,Loss=NULL)

for (i in seq(0.1,0.6,0.01)) {
#���Խ�ֵ(cutoff value)�Բ���0.01��0.1ȡ��0.6
  mypred <- data.frame(pred =ifelse(data[,'delayed']>i,'delayed','ontime'))
#����ж�Ϊdelayed�ĸ��ʴ��ڽ�ֵ����Ϊ�ü�¼�ĺ����delayed��
  myLoss <- sum(mypred[,'pred']!=FlightDelays[,"Flight.Status"] & FlightDelays[,"Flight.Status"]=='delayed')*3+
    sum(mypred[,'pred']!=FlightDelays[,"Flight.Status"] & FlightDelays[,"Flight.Status"]=='ontime')
#�����delayed����Ϊontime���ɱ���3�����������ontime����Ϊdelayed���ɱ�ֻ��1��
  myTable <- rbind(myTable,data.frame(cutoff=i,Loss=myLoss))
#��ÿ�����ԵĽ�ֵ�Լ��ý�ֵ����Ӧ����ʧ�ϲ��������һ�����ݿ�
}
View(myTable)

qplot(cutoff,Loss,data=myTable,geom ="line")
idx <- which.min(myTable[,"Loss"])
myTable[idx,]
#�ӽ��������ѵĽ�ֵӦ����0.26��
optcutoff <- myTable[idx,"cutoff"]
mypred <- data.frame(pred =ifelse(data[,'delayed']>optcutoff,'delayed','ontime'),
                     obs = FlightDelays[,"Flight.Status"])
table(mypred)
#������cutoff����0.26����µĻ����������濴cutoff����0.5����µĻ�������
mypred <- data.frame(pred =ifelse(data[,'delayed']>0.5,'delayed','ontime'),
                     obs = FlightDelays[,"Flight.Status"])
table(mypred)