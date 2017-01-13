library(MASS) #for Boston Housing Data
library(plyr) #for functions 'aggregate', 'arrange'
library(dplyr) #for group_by
data(Boston) #load Boston Housing Data
head(Boston) #check head of Boston Housing

sapply(Boston,class) #data type of each coloumn

BostonSub <- Boston[,c('ptratio','black','lstat','medv')]
cor(BostonSub) #correlation matrix

aggregate(medv ~ chas, data=Boston, length) #count houses 'near'/'far away from' the Charles River
aggregate(medv ~ chas, data=Boston, mean) # mean MEDV

summary(Boston$rm)
AA <- cut(Boston$rm,c(3,4,5,6,7,8,9))
Boston <- cbind(Boston,data.frame(rmRange=AA))

aggregate(medv ~ chas + rmRange, data=Boston, mean)
arrange(aggregate(medv ~ chas + rmRange, data=Boston, mean),chas,rmRange) #sorting the result

MyGroups <- group_by(.data=Boston, chas)
summarise(MyGroups, AvgMedv = mean(medv))
MyGroups <- group_by(.data=Boston, rmRange, chas)
summarise(MyGroups, AvgMedv = mean(medv))
arrange(summarise(MyGroups, AvgMedv = mean(medv)),chas)

Boston %>% group_by(rmRange,chas) %>% summarise(AvgMedv = mean(medv)) %>% arrange(chas,rmRange)
Boston %>% group_by(rmRange,chas) %>% filter(rmRange %in% c('(3,4]','(5,6]','(7,8]')) %>%
  summarise(AvgMedv = mean(medv)) %>% arrange(chas,rmRange)
