library(dplyr) #for the function 'arrange','group_by','summarise'
library(ggplot2)
setwd("D:/BA/Visualization")
Sales <- read.table('Salesdata.csv',header=T,sep=',',stringsAsFactors=FALSE)
#下面的语句是将相同日期的销量汇总并存到新的变量Sales_Merge 
Sales_Merge <- aggregate(Order.Qty ~ Order.Date, data = Sales, sum)
#Sales_Merge <- aggregate(Sales$Order.Qty, list(Sales$Order.Date), sum)
#colnames(Sales_Merge) <- c("Order.Date","Order.Qty")

Sales_Merge$Order.Date <- as.Date(Sales_Merge$Order.Date,"%m/%d/%Y")
#将日期变量的格式改成 12/21/2011 这样的格式。
Sales_Merge <- arrange(Sales_Merge,Order.Date)
#根据订货日期对Sales_Merge进行排序。

Sales2 <- data.frame(Sales_Merge, MonDay = format.Date(Sales_Merge$Order.Date,"%m-%d"))
#Sales2 在 Sales_Merge 中加入新的一列MonDay，取值为订货时间的 月份-日子如06-23
Sales2 <- data.frame(Sales2,Year = as.factor(format.Date(Sales2$Order.Date,"%Y")))
#Sales2 继续加入新的一列Year，取值为订货时间的年份，而且把年份视为类别型变量。
#因为下面画图的时候要根据年份不同来画不同的线图，因此年份应该是类别型变量。

g <- ggplot(Sales2, aes(x=MonDay, y=Order.Qty, group=Year,colour  = Year)) + geom_line() 
#x轴是日期（月-日），y轴是订货量，根据年份进行分组，画线图。
g + scale_colour_brewer(palette="Set2")
#使用Set2调色板
g + scale_colour_manual(values = c("#E69F00", "#56B4E9", "#009E73", 
                                   "#F0E442", "#0072B2", "#D55E00")) 
#自定义颜色
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))

Sales3 <- data.frame(Sales2, Month = as.factor(format.Date(Sales2$Order.Date,"%m")))
#在Sales2当中插入新的一列为Month月份，准备对月份进行销售量汇总。
Sales4 <- aggregate(Order.Qty ~ Month + Year, data = Sales3, sum)
#根据年份和月份对销售量进行汇总。
g <- ggplot(Sales4, aes(x=Month, y=Order.Qty, group = Year, colour  = Year)) + geom_line() 
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))

idx <- which(Sales4[,"Year"] %in% c(2004,2005,2006))
#只看2004-2006年的数据。
Sales5 <- Sales4[idx,]
g <- ggplot(Sales5, aes(x=Month, y=Order.Qty, group = Year, colour  = Year)) + geom_line() 
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))
