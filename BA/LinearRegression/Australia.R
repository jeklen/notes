setwd("D:/BA/LinearRegression")
#设置工作目录
year <- rep(2008:2010, each=4)
quarter <- rep(1:4, 3)
cpi <- c(162.2, 164.6, 166.5, 166.0,
         166.2, 167.0, 168.6, 169.5,
         171.0, 172.1, 173.3, 174.0)
plot(cpi, xaxt="n", ylab="CPI", xlab="")
# xaxt = "n" 表示不画x轴的ticks（数值标记），xlab和ylab是x轴和
# y轴的名称，更多参数使用?par调出帮助文件。
axis(1, labels=paste(year,quarter,sep="Q"), at=1:12, las=3)
# 画x轴的标签第一个参数1表示画x轴标记，如果是2则表示画y轴。
# labels=paste(year,quarter,sep="Q") 生成标签字符串
cor(year,cpi)
cor(quarter,cpi)
fit <- lm(cpi ~ year + quarter)
# lm函数进行线性回归。cpi ~ year + quarter是回归模型。
fit
names(fit)
fit$coefficients
fit$residuals
fit$fitted.values # predicted values
fit$model
anova(fit) # anova table
vcov(fit) # covariance matrix for model parameters
confint(fit, level=0.95) # Confidence Intervals (CIs) for model parameters 
summary(fit)
# diagnostic plots 
plot(fit)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fit)
dev.off()
#更多的模型诊断见http://www.statmethods.net/stats/rdiagnostics.html
fit2 <- lm(cpi ~ year)
anova(fit, fit2) #使用F检验比较2个模型是否不同。结果显示两个模型显著不同。第一个模型RSS较少也就较好。
anova(fit, fit2, test="Chisq") 
#使用ChiSquare检验比较2个模型是否不同。结果显示两个模型显著不同。第一个模型RSS较少也就较好。
#以下进行预测
data2011 <- data.frame(year=2011, quarter=1:4)
data2011
cpi2011 <- predict(fit, newdata=data2011)
cpi2011
style <- c(rep(1,12), rep(2,4)) #定义2011年预测值的点的Style和颜色。
plot(c(cpi, cpi2011), xaxt="n", ylab="CPI", xlab="", pch=style, col=style)
axis(1, at=1:16, las=3,
     labels=c(paste(year,quarter,sep="Q"), "2011Q1", "2011Q2", "2011Q3", "2011Q4"))
