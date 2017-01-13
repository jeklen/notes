setwd("D:/BA/Homework/HW03")

library(fpp)
data(euretail)
head(euretail)

plot(euretail, ylab="Retain Index", xlab="Year", main="Quarterly Retail Trade Index in The Euro Area", cex = 0.5)

fit <- decompose(euretail, type="multiplicative")
plot(fit)

fit <- decompose(euretail, type="additive")
plot(fit)

#Holt-Winters Smoothing Methods
#aust <- window(austourists,start=2005)
fit2 <- hw(euretail,seasonal="multiplicative")

plot(fit2,ylab="Quarterly Retail Trade Index in The Euro Area",
     plot.conf=FALSE, type="o", fcol="white", xlab="Year")
#lines(fitted(fit1), col="red", lty=2)
lines(fitted(fit2), col="green", lty=2)
#lines(fit1$mean, type="o", col="red")
lines(fit2$mean, type="o", col="green")
legend("topleft",lty=1, pch=1, col=1:3, cex = 0.5,
       c("data","Holt Winters' Additive","Holt Winters' Multiplicative"))

