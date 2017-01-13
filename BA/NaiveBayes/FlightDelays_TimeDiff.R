library(class)
library(e1071) ## needed for Naive Bayes
setwd("d:/BA/NaiveBayes")
FlightDelays <- read.csv("FlightDelays.csv",header = TRUE)

TimeCharacterLength <-nchar(as.character(FlightDelays[,"DEP_TIME"]))
#��DEP_TIME��¼����ֵת�����ַ����������ַ������ȡ�
summary(TimeCharacterLength)
#����ַ��������Ƿ���3-4֮�䣬�����������Ҫ�鿴��¼�Ƿ����
TimeCharacterLength <-nchar(as.character(FlightDelays[,"CRS_DEP_TIME"]))
#��CRS_DEP_TIME��¼����ֵת�����ַ����������ַ������ȡ�
summary(TimeCharacterLength)
#����ַ��������Ƿ���3-4֮�䣬�����������Ҫ�鿴��¼�Ƿ����

#�������ǽ�Ҫ��DEP_TIME��CRS_DEP_TIME�е���ֵ�ͱ���ת���������ͱ����Ա����DEP_TIME��ʵ�����ʱ�䣩
#��CRS_DEP_TIME���ƻ����ʱ�䣩֮���ʱ��
DepTime <- as.character(FlightDelays[,"DEP_TIME"])
DepTime <- paste(substr(DepTime, start=1, stop = nchar(DepTime)-2),
                 substr(DepTime, start=nchar(DepTime)-1, stop = nchar(DepTime)), sep=":")
#��ʱ�ͷ�֮�����":"
#ʾ����x <- "300"; Ȼ������ x <- "1100"
# paste(substr(x, start=1, stop = nchar(x)-2),substr(x, start=nchar(x)-1, stop = nchar(x)), sep=":")
DepTime <- strptime(DepTime,"%H:%M")
#���ַ�����ʽת����ʱ���ʽ
#���ӣ�strptime("6:25","%H:%M")

#���¶Լƻ����ʱ���������һ�ַ������д�����
SchDepTime <- as.character(FlightDelays[,"CRS_DEP_TIME"])
Idx <- which(nchar(SchDepTime)<4)
#Idx �洢SchDepTime���ַ�������С��4������
SchDepTime[Idx] = paste("0",SchDepTime[Idx],sep="")
#SchDepTime���ַ�������С��4����ǰ����������0������615ת����0615����˼������6��15�֡�
SchDepTime <- strptime(SchDepTime,"%H%M")
#���ַ�����ʽת����ʱ���ʽ

#����Ҫ����ʵ�����ʱ����ƻ����ʱ��֮���ʱ���
#ʾ����y1 <-strptime("0621","%H%M")
# y2 <-strptime("0521","%H%M")
# as.numeric(difftime(y1,y2,units="min"))
DepTimeDiff <- as.numeric(difftime(DepTime,SchDepTime,units="min"))
plot(DepTimeDiff)
#���Կ�����2���쳣ֵ��ʵ�����ʱ��ȼƻ����ʱ����ǰ����500���ӣ����ǲ����ܵġ�
Idx <- which(DepTimeDiff < -60)
DepTimeDiff[Idx]
FlightDelays[Idx,c("CRS_DEP_TIME","DEP_TIME")]
#�������г��쳣ֵ��ʵ�ʺͼƻ����ʱ�䡣���Է���ʵ�����ʱ���Ǽƻ����ʱ��ĺ�һ�졣
#���ַ���ת��������ʱ����ʱ����Ϊͬһ���ʱ�䡣��˼���ʱ��������
#1����1440���ӣ���Ϊʵ�����ʱ��������1�죬ֻ��Ҫ��1440���Ӽ�����ɡ�
DepTimeDiff[Idx] <- DepTimeDiff[Idx]+1440
plot(DepTimeDiff)
summary(DepTimeDiff)
DepTDiffCtg <- cut(DepTimeDiff,c(-30,0,30,60,90,120,800))
#�����ʱ����30���ӵĲ������ֳɼ������䡣

FlightDelays <- cbind(FlightDelays,DepTDiffCtg)
Idx <- which(DepTimeDiff > 15)
FlightDelays[Idx,c("Flight.Status","DepTDiffCtg")]
# ���ʱ������15����Ӧ��Ϊ�ɻ�����
# �������ݼ���ʾ�еļ�¼��û�б���Ϊ����
Idx <- which(DepTimeDiff > 15 & FlightDelays[,"Flight.Status"]=="ontime")
FlightDelays[Idx,c("Flight.Status","DepTDiffCtg")]
DepTimeDiff[Idx]