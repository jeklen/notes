library(class)
library(e1071) ## needed for Naive Bayes
setwd("d:/BA/NaiveBayes")
FlightDelays <- read.csv("FlightDelays.csv",header = TRUE)

TimeCharacterLength <-nchar(as.character(FlightDelays[,"DEP_TIME"]))
#将DEP_TIME记录的数值转化成字符串并计算字符串长度。
summary(TimeCharacterLength)
#检查字符串长度是否在3-4之间，如果不是则需要查看记录是否出错
TimeCharacterLength <-nchar(as.character(FlightDelays[,"CRS_DEP_TIME"]))
#将CRS_DEP_TIME记录的数值转化成字符串并计算字符串长度。
summary(TimeCharacterLength)
#检查字符串长度是否在3-4之间，如果不是则需要查看记录是否出错

#下面我们将要把DEP_TIME和CRS_DEP_TIME中的数值型变量转换成日期型变量以便计算DEP_TIME（实际起飞时间）
#与CRS_DEP_TIME（计划起飞时间）之间的时间差。
DepTime <- as.character(FlightDelays[,"DEP_TIME"])
DepTime <- paste(substr(DepTime, start=1, stop = nchar(DepTime)-2),
                 substr(DepTime, start=nchar(DepTime)-1, stop = nchar(DepTime)), sep=":")
#在时和分之间插入":"
#示例：x <- "300"; 然后再试 x <- "1100"
# paste(substr(x, start=1, stop = nchar(x)-2),substr(x, start=nchar(x)-1, stop = nchar(x)), sep=":")
DepTime <- strptime(DepTime,"%H:%M")
#将字符串格式转换成时间格式
#例子：strptime("6:25","%H:%M")

#以下对计划起飞时间采用另外一种方法进行处理：
SchDepTime <- as.character(FlightDelays[,"CRS_DEP_TIME"])
Idx <- which(nchar(SchDepTime)<4)
#Idx 存储SchDepTime中字符串长度小于4的索引
SchDepTime[Idx] = paste("0",SchDepTime[Idx],sep="")
#SchDepTime中字符串长度小于4的在前面填上数字0，例如615转换成0615，意思是早上6点15分。
SchDepTime <- strptime(SchDepTime,"%H%M")
#将字符串格式转换成时间格式

#下面要计算实际起飞时间与计划起飞时间之间的时间差
#示例：y1 <-strptime("0621","%H%M")
# y2 <-strptime("0521","%H%M")
# as.numeric(difftime(y1,y2,units="min"))
DepTimeDiff <- as.numeric(difftime(DepTime,SchDepTime,units="min"))
plot(DepTimeDiff)
#可以看出有2个异常值。实际起飞时间比计划起飞时间提前超过500分钟，这是不可能的。
Idx <- which(DepTimeDiff < -60)
DepTimeDiff[Idx]
FlightDelays[Idx,c("CRS_DEP_TIME","DEP_TIME")]
#上面是列出异常值的实际和计划起飞时间。可以发现实际起飞时间是计划起飞时间的后一天。
#而字符串转换成日期时，把时间视为同一天的时间。因此计算时发生错误。
#1天有1440分钟，因为实际起飞时间少算了1天，只需要把1440分钟加上则可。
DepTimeDiff[Idx] <- DepTimeDiff[Idx]+1440
plot(DepTimeDiff)
summary(DepTimeDiff)
DepTDiffCtg <- cut(DepTimeDiff,c(-30,0,30,60,90,120,800))
#将起飞时间差按照30分钟的步长划分成几个区间。

FlightDelays <- cbind(FlightDelays,DepTDiffCtg)
Idx <- which(DepTimeDiff > 15)
FlightDelays[Idx,c("Flight.Status","DepTDiffCtg")]
# 起飞时间延误15分钟应视为飞机延误
# 但是数据集显示有的记录并没有被视为延误。
Idx <- which(DepTimeDiff > 15 & FlightDelays[,"Flight.Status"]=="ontime")
FlightDelays[Idx,c("Flight.Status","DepTDiffCtg")]
DepTimeDiff[Idx]
