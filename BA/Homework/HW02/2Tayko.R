setwd("D:/BA/Homework/HW02")
Tayko <- read.csv("Tayko.csv", header=TRUE, sep=",")

Tayko_source_a = Tayko[Tayko$source_a==1,]
mean(Tayko_source_a$Spending)
#mean from source_a is 247.8985

Tayko_source_b = Tayko[Tayko$source_b==1,]
mean(Tayko_source_b$Spending)
#mean from source_b is 197.6111

plot(Tayko$Freq, Tayko$Spending, xlab = "Freq", ylab = "Spending", main = "Spending和Freq关系散点图")
plot(jitter(Tayko$Freq), Tayko$Spending, xlab = "Freq", ylab = "Spending", main = "Spending和Freq关系抖动散点图")
plot(Tayko$last_update_days_ago, Tayko$Spending, xlab = "last_update_days_ago", ylab = "Spending", main = "花费和几天前消费者记录被更新关系散点图")

fit <- lm(Spending~US+Freq+last_update_days_ago+Web.order+Gender.male+Address_is_res, data = Tayko)
summary(fit)
fit

library(MASS)
max_model <- lm(Spending~US+Freq+last_update_days_ago+Web.order+Gender.male+Address_is_res, data = Tayko)
stepb <- stepAIC(max_model, direction="backward") #backward elemination
stepb$anova # display results
