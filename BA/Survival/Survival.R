library(survival)
library(OIsurv)

data(tongue)
attach(tongue)
my.surv<-Surv(time, delta)
#这里是right censored数据，所以type='right'。
#delta取值为1代表事件发生（例如死亡），取值为0则代表右截值。
my.fit<-survfit(my.surv~1)   #Kaplan-Meier
summary(my.fit)
plot(my.fit)
#比较type=1和type=2这两个组的存活函数
my.fit1<-survfit(Surv(time,delta)~type)
plot(my.fit1)

#计算风险函数
H.hat<--log(my.fit$surv)
H.hat<-c(H.hat, tail(H.hat,1))

print(my.fit, print.rmean=TRUE)

#检验两个存活函数是否有区别
survdiff(Surv(time, delta) ~ type) # 在5%水平上并没有显著区别。
detach(tongue)

data(burn) 
attach(burn) 
my.surv <- Surv(T1, D1)
coxph.fit <- coxph(my.surv ~ Z1 + as.factor(Z11), method="breslow") 
coxph.fit
detach(burn)
