setwd("D:/BA/Homework/HW03")
library(survival)
library(OIsurv)

#head(hmohiv)
#hmohiv$SurvObj <- with(hmohiv, Surv(time, status == 1))

hmohiv <- read.csv("Hmohiv.csv")
attach(hmohiv)
my.surv<-Surv(time, status)
#这里是right censored数据，所以type='right'。
#delta取值为1代表事件发生（例如死亡），取值为0则代表右截值。
my.fit<-survfit(my.surv~1)   #Kaplan-Meier
summary(my.fit)
plot(my.fit)

#比较type=1和type=2这两个组的存活函数
my.fit1<-survfit(Surv(time,status)~drug)
plot(my.fit1)

#检验两个存活函数是否有区别
survdiff(Surv(time, status) ~ drug) # 在5%水平上并没有显著区别。

#第三小问

my.surv <- Surv(time, status)
coxph.fit <- coxph(my.surv ~ age + as.factor(drug), method="breslow") 
coxph.fit
detach(hmohiv)
