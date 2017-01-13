library(fpp)
setwd("D:/BA/TimeSeries")

#时间序列画图
data(melsyd)
plot(melsyd[,"Economy.Class"], 
     main="Economy class passengers: Melbourne-Sydney",
     xlab="Year",ylab="Thousands")
data(a10)
plot(a10, ylab="$ million", xlab="Year", main="Antidiabetic drug sales")

#使用图形展示季节性 Seasonal plot
seasonplot(a10,ylab="$ million", xlab="Year", 
           main="Seasonal plot: antidiabetic drug sales",
           year.labels=TRUE, year.labels.left=TRUE, col=1:20, pch=19)
#Seasonal subseries plots
monthplot(a10,ylab="$ million",xlab="Month",xaxt="n",
          main="Seasonal deviation plot: antidiabetic drug sales")
#xaxt：x轴坐标先不要画（="n"）
axis(side=1,at=1:12,labels=month.abb)
#side：标注在坐标轴下方，at：标注点是1到12，labels：标注的标签是月份缩写。

#下面展示时间序列的自相关Autocorrelation。
data(ausbeer)
beer2 <- window(ausbeer, start=1992, end=2006-.1)
# end = 2006-.1确保事件序列取值到2005最后一个quarter，可以尝试end=2006-0.26和end=2006-0.51看有什么结果
beer2
lag.plot(beer2, lags=9, do.lines=FALSE)
#do.lines=FALSE不要把点按时间次序连起来，如果取值为TRUE则连起来。
Acf(beer2)
#Acf: autocorrelation function or ACF.The plot is also known as a correlogram.

# Decomposition 分解时间序列
fit <- decompose(ausbeer, type="multiplicative")
plot(fit)

fit <- decompose(ausbeer, type="additive")
plot(fit)
names(fit)
fit$trend
fit$seasonal
fit$random

#使用stl函数（Seasonal Decomposition of Time Series by Loess）分解时间序列
fit <- stl(elecequip, t.window=15, s.window="periodic", robust=TRUE)
#这里的t.window表示trend window，s.window表示seasonal window.
#表示trend和seasonal effect变化的速度有多快，取值越小则变化越快。
#s.window可以取值periodic或者给定一个数值比如4表示每隔4个时间段
plot(fit)

#Forecasting with decomposition 使用分解后的时间序列做预测。
fcast <- forecast(fit, method="naive")
plot(fcast, ylab="New orders index")

#Simple Exponential Smoothing
oildata <- window(oil,start=1996,end=2007)
plot(oildata, ylab="Oil (millions of tonnes)",xlab="Year",
     main="Oil production in Saudi Arabia from 1996 to 2007")

fit1 <- ses(oildata, alpha=0.2, initial="simple", h=3)
#ses函数是用于Exponential smoothing forecasts
#alpha=0.2, h=3 表示对未来3期进行预测。
#初始值l0可以针对alpha值进行优化，如果是这样则initial="optimal"
#初始值也可以通过最初几个值进行简单计算得到，如果是这样则initial="simple"
fit2 <- ses(oildata, alpha=0.6, initial="simple", h=3)
fit3 <- ses(oildata, h=3)
#这里没有给出alpha值，所以会自动计算得到最佳的alpha值使得预测结果的SSE最小。
plot(fit1, plot.conf=FALSE, ylab="Oil (millions of tonnes)",
     xlab="Year", main="", fcol="white", type="o")
lines(fitted(fit1), col="blue", type="o")
lines(fitted(fit2), col="red", type="o")
lines(fitted(fit3), col="green", type="o")
lines(fit1$mean, col="blue", type="o")
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft",lty=1, col=c(1,"blue","red","green"), 
       c("data", expression(alpha == 0.2), expression(alpha == 0.6),
         expression(alpha == 0.89)),pch=1)
fit3$model
#怎么知道fit3对应的最佳alpha值是0.89呢？看它得到的最终model就知道了。

#Holt-Winters Smoothing Methods
#可以用来做很多预测
aust <- window(austourists,start=2005)
fit1 <- hw(aust,seasonal="additive")
fit2 <- hw(aust,seasonal="multiplicative")

plot(fit2,ylab="International visitor night in Australia (millions)",
     plot.conf=FALSE, type="o", fcol="white", xlab="Year")
lines(fitted(fit1), col="red", lty=2)
lines(fitted(fit2), col="green", lty=2)
lines(fit1$mean, type="o", col="red")
lines(fit2$mean, type="o", col="green")
legend("topleft",lty=1, pch=1, col=1:3, 
       c("data","Holt Winters' Additive","Holt Winters' Multiplicative"))

states <- cbind(fit1$model$states[,1:3],fit2$model$states[,1:3])
colnames(states) <- c("level","slope","seasonal","level","slope","seasonal")
plot(states, xlab="Year")
fit1$model$state[,1:3]
fitted(fit1)
fit1$mean

#Unit Root Test 单根检验判断时间序列是否为平稳时间序列。
data(usconsumption)
USConsump <- usconsumption[,1]
adf.test(USConsump, alternative = "stationary")
#Dickey-Fuller Test
#很小的p值代表时间序列是平稳的，较大的p值（比如5%）说明时间序列是非平稳的。
kpss.test(USConsump)
#KPSS Test
#很小的p值代表时间序列是平稳的，较大的p值（比如5%）说明时间序列是非平稳的。

#自动选择ARIMA模型中的参数
fit <- auto.arima(USConsump,seasonal=FALSE)
fit
par(mfrow=c(1,2))
Acf(USConsump,main="")
Pacf(USConsump,main="")
