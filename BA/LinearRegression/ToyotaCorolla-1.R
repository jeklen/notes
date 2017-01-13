setwd("D:/BA/LinearRegression")
ToyotaData <- read.csv("TOyotaCorolla.csv",header = TRUE)

nrow(ToyotaData) #nroow函数返回ToyotaData的行数
ncol(ToyotaData) #ncol函数返回ToyotaData的列数
FuelTypeColN=which( colnames(ToyotaData)=="Fuel_Type") 
#我们打算在Fuel_Type后面插入2列，分别是Diesel和Petrol，所以首先算出Fuel_Type这列的列数。

Diesel=rep(0,times=nrow(ToyotaData)) #生成一个0向量Diesel，0的个数为ToyotaData的行数。
#这个向量名在后面的cbind操作中会变成列名。
#如果不想把列名定义为变量名，那么可以使用
#R1=data.frame(Diesel=rep(0,times=nrow(ToyotaData)))
#然后在cbind操作的时候把Diesel换成R1就可以了。
Petrol=rep(0,times=nrow(ToyotaData))

Toyota=cbind(ToyotaData[,1:FuelTypeColN],Diesel,Petrol,ToyotaData[,(FuelTypeColN+1):ncol(ToyotaData)])
DieselIdx <- which(Toyota["Fuel_Type"]=="Diesel") #找出Fuel_Type取值为Diesel的行索引。
Toyota[DieselIdx,"Diesel"]=1 #对虚拟变量Diesel赋值为1。
PetrolIdx <- which(Toyota["Fuel_Type"]=="Petrol") #找出Fuel_Type取值为Petrol的行索引。
Toyota[PetrolIdx,"Petrol"]=1 #对虚拟变量Petrol赋值为1。

ToyotaModel <- Toyota[,c("Price","Age_08_04","KM","Diesel","Petrol","HP","Met_Color",
                         "Automatic","cc","Doors","Quarterly_Tax","Weight")]
summary(ToyotaModel) #可以看到有大概有7组数据里面包含NA，应该去掉。
ToyotaModel <-na.omit(ToyotaModel)
fit <- lm(Price ~ Age_08_04 + KM + Diesel + Petrol + HP + Met_Color + Automatic + cc +
            Doors + Quarterly_Tax + Weight, data = ToyotaModel)
summary(fit) #cc变量得到奇怪结果，可能是cc变量被设置为factor型变量而不是数值型变量。
#打开csv文件发现cc变量的数值含有逗号，因此被理解成字符串，自动被设置为factor型变量。
sapply(ToyotaModel, class) #检查所有列的变量类型。
ToyotaModel[1:6,"cc"]
Numeric_cc<-as.numeric(ToyotaModel[,"cc"])
Numeric_cc[1:6]
#上面的处理方法是错误的，因为把factor值转换成数值型的时候数值发生了改变。
Numeric_cc<-as.character(ToyotaModel[,"cc"]) #必须先把factor型变量转换成字符型变量
Numeric_cc<-sub(',','',Numeric_cc) #然后去掉里面的逗号
Numeric_cc<-as.numeric(Numeric_cc) #接着再转换成数值型
ToyotaModel[,"cc"]<-Numeric_cc #最后把数值赋给cc列。

fit <- lm(Price ~ Age_08_04 + KM + Diesel + Petrol + HP + Met_Color + Automatic + cc +
            Doors + Quarterly_Tax + Weight, data = ToyotaModel)
summary(fit) #这部分是对所有数据进行回归分析。接下来我们需要把数据割成2部分，分别是训练数据集和验证数据集。

#下面展示为什么读出来的数值是factor变量而不是数值变量： 
ToyotaData <- read.csv("TOyotaCorolla.csv",header = TRUE)
is.factor(ToyotaData[,"cc"])
ToyotaData <- read.csv("TOyotaCorolla.csv",header = TRUE, stringsAsFactors=FALSE)
is.factor(ToyotaData[,"cc"])
is.character(ToyotaData[,"cc"])
is.numeric(ToyotaData[,"cc"]) #读出来的cc列数据仍然不是数值型，还需要去掉逗号再转换成数值型。

set.seed(1000) #在这里设置种子值只是为了重复得到相同的结果，便于检验。
#在实际随机抽样中，应该把上面的语句去掉。
ToyotaRowNum=nrow(ToyotaModel)
SampleIndex <- sample(1:ToyotaRowNum,round(ToyotaRowNum*0.6),replace = FALSE)
ToyotaSample <- ToyotaModel[SampleIndex,]
fit_training <- lm(Price ~ Age_08_04 + KM + Diesel + Petrol + HP + Met_Color + Automatic + cc +
            Doors + Quarterly_Tax + Weight, data = ToyotaSample)
summary(fit_training)
sum(fit_training$residuals^2) #计算Residual Sum of Squares (RSS)
anova(fit_training) #与ANOVA结果对比是一样的。
sqrt(sum(fit_training$residuals^2)/nrow(ToyotaSample)) #计算RMS Error
sum(fit_training$residuals)/nrow(ToyotaSample) #计算Average Error

ToyotaValidation <- ToyotaModel[-SampleIndex,]
validation_result = predict(fit_training,newdata=ToyotaValidation)
validation_result[1:10]
Vresiduals = validation_result-ToyotaValidation[,"Price"]
sum(Vresiduals^2)
sqrt(sum(Vresiduals^2)/length(Vresiduals)) #计算RMS Error
sum(Vresiduals)/length(Vresiduals) #计算Average Error
boxplot(Vresiduals)
    
mytable <- rbind (
  c(sum(fit_training$residuals^2), sqrt(sum(fit_training$residuals^2)/nrow(ToyotaSample)),
    sum(fit_training$residuals)/nrow(ToyotaSample)),
  c(sum(Vresiduals^2),sqrt(sum(Vresiduals^2)/length(Vresiduals)),sum(Vresiduals)/length(Vresiduals))
  )

colnames(mytable) <- c("RSS","RMS Error","Avg.Error")
rownames(mytable) <- c("Training","Validation")
mytable #mytable是一个列表，展示训练数据集和验证数据集的相关统计量。

require(xtable) 
myLaTextable <- xtable(mytable, digit=2) #转换成LaTex表格
print(myLaTextable,floating=FALSE)

require(gridExtra)
grid.table(mytable)
pdf("ExcelTable.pdf", height=11, width=8.5)
mt2 <- round(mytable,2)
grid.table(mt2) #用Excel表格风格打印到PDF文件。
dev.off()
