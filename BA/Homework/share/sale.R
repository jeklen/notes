library(ISLR)
library(class)
str(Caravan)
table(Caravan$Purchase)/sum(as.numeric(table(Caravan$Purchase)))

standardized.X=scale(Caravan[,-86])
mean(standardized.X[,sample(1:85,1)])
var(standardized.X[,sample(1:85,1)])
mean(standardized.X[,sample(1:85,1)])
var(standardized.X[,sample(1:85,1)])
mean(standardized.X[,sample(1:85,1)])
var(standardized.X[,sample(1:85,1)])

#前1000观测作为测试集，其他当训练集
test <- 1:1000
train.X <- standardized.X[-test,]
test.X <- standardized.X[test,]
train.Y <- Caravan$Purchase[-test]
test.Y <- Caravan$Purchase[test]
knn.pred <- knn(train.X,test.X,train.Y,k=)
mean(test.Y!=knn.pred)
mean(test.Y!="No")

table(knn.pred,test.Y)

knn.pred <- knn(train.X,test.X,train.Y,k=3)
table(knn.pred,test.Y)[2,2]/rowSums(table(knn.pred,test.Y))[2]
knn.pred <- knn(train.X,test.X,train.Y,k=5)
table(knn.pred,test.Y)[2,2]/rowSums(table(knn.pred,test.Y))[2]

glm.fit <- glm(Purchase~.,data=Caravan,family = binomial,subset = -test)
glm.probs <- predict(glm.fit,Caravan[test,],type = "response")
glm.pred <- ifelse(glm.probs >0.5,"Yes","No")
table(glm.pred,test.Y)

glm.pred <- ifelse(glm.probs >0.25,"Yes","No")
table(glm.pred,test.Y)


#加载数据集BloodBrain，用到向量logBBB和数据框bbbDescr
library(caret)
data(BloodBrain)
class(logBBB)
dim(bbbDescr)
#取约80%的观测作训练集。
inTrain <- createDataPartition(logBBB, p = .8)[[1]]
trainX <- bbbDescr[inTrain,] 
trainY <- logBBB[inTrain]
testX <- bbbDescr[-inTrain,]
testY <- logBBB[-inTrain]
#构建KNN回归模型
fit <- knnreg(trainX, trainY, k = 3) 
fit
#KNN回归模型预测测试集
pred <- predict(fit, testX)
#计算回归模型的MSE
mean((pred-testY)^2)

#将训练集、测试集和预测值结果集中比较
df <-data.frame(class=c(rep("trainY",length(trainY)),rep("testY",length(testY)),rep("predY",length(pred))),Yval=c(trainY,testY,pred))
ggplot(data=df,mapping = aes(x=Yval,fill=class))+geom_dotplot(alpha=0.8)

#比较测试集的预测值和实际值
df2 <- data.frame(testY,pred)
ggplot(data=df2,mapping = aes(x=testY,y=pred))+geom_point(color="steelblue",size=3)+geom_abline(slope = 1,size=1.5,linetype=2)
