setwd("D:/BA/Logit")
dpen <- read.csv("DeathPenalty.csv",header = TRUE)
dpen[1:4,]
#Agg��ʾ�������س̶ȣ�Խ������ֵԽ��VRace��ʾ���壬1��ʾ�ܺ����ǰ��ˣ�0��ʾ�ܺ����Ǻ��ˡ�
#Death��ʾ�ﷸ�Ƿ������̣�1�����������̣�0����δ�������̡�
m1=glm(Death~VRace+Agg,family=binomial,data=dpen)
#ʹ��Logit�ع飬GLM��ʾ�������Իع飬binomial��ʾ����ֲ���
m1
summary(m1)
## calculating logits
exp(m1$coef[2])
exp(m1$coef[3])
## plotting probability of getting death penalty as a function of
## aggravation separately for black (in black) and white (in red)
## victim
fitBlack=dim(501)
fitWhite=dim(501)
ag=dim(501)
for (i in 1:501) {
  ag[i]=(99+i)/100
  fitBlack[i]=exp(m1$coef[1]+ag[i]*m1$coef[3])/(1+exp(m1$coef[1]+ag[i]*m1$coef[3]))
  fitWhite[i]=exp(m1$coef[1]+m1$coef[2]+ag[i]*m1$coef[3])/(1+exp(m1$coef[1]+m1$coef[2]+ag[i]*m1$coef[3]))
}
plot(fitBlack~ag,type="l",col="black",ylab="Prob[Death]",
     xlab="Aggravation",ylim=c(0,1),
     main="red line for white victim; black line for black victim")
points(fitWhite~ag,type="l",col="red")