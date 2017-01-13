setwd("D:/BA/LinearRegression")
ToyotaData <- read.csv("TOyotaCorolla.csv",header = TRUE)

#如果Fuel_Type型变量是Factor型变量，则线性回归的时候R自动给这种变量创建虚拟变量。
ToyotaModel <- ToyotaData[,c("Price","Age_08_04","KM","Fuel_Type","HP","Met_Color",
                         "Automatic","cc","Doors","Quarterly_Tax","Weight")]
ToyotaModel <-na.omit(ToyotaModel)
Numeric_cc<-as.character(ToyotaModel[,"cc"]) #必须先把factor型变量转换成字符型变量
Numeric_cc<-sub(',','',Numeric_cc) #然后去掉里面的逗号
Numeric_cc<-as.numeric(Numeric_cc) #接着再转换成数值型
ToyotaModel[,"cc"]<-Numeric_cc #最后把数值赋给cc列。
summary(ToyotaModel[,"Fuel_Type"]) #在Fuel_Type列由于存在NA值，导致把列中的NA视为一个factor。
#把包含NA的行删掉之后，Fuel_Type中与NA相对应的factor level并没有消失。所以可以看到count值为0的空level。
ToyotaModel[,"Fuel_Type"] <- droplevels(ToyotaModel[,"Fuel_Type"]) #把该Level删掉。
summary(ToyotaModel[,"Fuel_Type"])
fit <- lm(Price ~ ., data = ToyotaModel)
summary(fit)

ToyotaData <- read.csv("TOyotaCorolla.csv",header = TRUE,stringsAsFactors=FALSE)
#如果把stringsAsFactors设置成FALSE，那么cc列得到的是字符型变量，Fuel_Type得到的也是字符型变量。
#下面的操作中，仍然需要把cc列转换成数值型变量，而且需要把Fuel_Type列转换成Factor型变量。

ToyotaModel <- ToyotaData[,c("Price","Age_08_04","KM","Fuel_Type","HP","Met_Color",
                             "Automatic","cc","Doors","Quarterly_Tax","Weight")]
ToyotaModel <-na.omit(ToyotaModel)
Numeric_cc<-ToyotaModel[,"cc"]  #把cc列提取出来，这里无需转换成字符型变量
Numeric_cc<-sub(',','',Numeric_cc) #然后去掉里面的逗号
Numeric_cc<-as.numeric(Numeric_cc) #接着再转换成数值型
ToyotaModel[,"cc"]<-Numeric_cc #最后把数值赋给cc列。
is.factor(ToyotaModel[,"Fuel_Type"])
ToyotaModel[,"Fuel_Type"]=as.factor(ToyotaModel[,"Fuel_Type"])
fit <- lm(Price ~ ., data = ToyotaModel)
summary(fit)

library(ggplot2)
ToyotaCount = c(1:nrow(ToyotaModel))
ggplot(ToyotaModel) + geom_point( aes(x=ToyotaCount, y = sort(Price)) ,size=2,colour="black")+
  geom_point( aes(x=ToyotaCount, y = sort(fit$fitted)),size=2,colour="red") + xlab("") + ylab("") +
  annotate("text", x=1000, y=10000, size=10, label="Price")+
  annotate("text", x=1100, y=14000, size=10, colour="red",label="Fitted Price")

ggplot(ToyotaModel) + geom_point( aes(x=ToyotaCount, y = sort(Price), colour="Price")) +
  geom_point( aes(x=ToyotaCount, y = sort(fit$fitted), colour="Fitted Price") ) +  xlab("") + ylab("") +
  scale_colour_manual("", breaks = c("Price", "Fitted Price"),
                      values = c("black", "red"))

#下面展示的是forward selection, backward elemination和both directions方式选择预测因子。
library(MASS)
min_model = lm (Price ~ 1, data = ToyotaModel)
biggest <- formula(lm(Price ~ ., data = ToyotaModel))
stepf <- stepAIC(min_model, direction="forward",scope=biggest) #forward selection
stepf$anova # display results

max_model = lm (Price ~ ., data = ToyotaModel)
stepb <- stepAIC(max_model, direction="backward") #backward elemination
stepb$anova # display results

stept <- stepAIC(lm (Price ~ Age_08_04 + KM + Fuel_Type + cc, data = ToyotaModel), 
                 direction="both",scope=biggest) #both directions
stept$anova # display results

stept <- stepAIC(lm (Price ~ Age_08_04 + KM + Fuel_Type + cc, data = ToyotaModel), 
                 direction="both",scope=biggest,k=4) #both directions
#k值是对预测因子个数的惩罚度，k越大对预测因子个数惩罚越大。
#k值默认为2，这里把它提高到4，结果是预测因子个数变少。
stept$anova # display results
summary(stept)

# All Subsets Regression
library(leaps)
sapply(ToyotaModel, class)
leaps<-regsubsets(Price~.,data=ToyotaModel,nbest=6)
# view results 
summary(leaps)
# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(leaps,scale="adjr2") #Adjusted R-Square
plot(leaps,scale="Cp") #Colin Lingwood Mallows' Cp
