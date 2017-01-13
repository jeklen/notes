library(dplyr) #for the function 'arrange'

setwd("D:/BA/Visualization")
Sales <- read.table('Salesdata.csv',header=T,sep=',',stringsAsFactors=FALSE)
Sales <- arrange(Sales,Order.Date)
# 以上对Sales根据Order.Date进行排序
# 下面准备另外一个数据框，目的是将原数据框中相同日期的销售进行汇总放在一行。
Sales_Merge <- data.frame(Order.Date=rep('NA',nrow(Sales)), Order.Qty = rep(0,nrow(Sales)))
# 对数据框进行初始化操作时，R自动将字符串变量转换成factor型变量，下面需要把factor型变量恢复成字符串变量。
Sales_Merge[,"Order.Date"]<- as.character(Sales_Merge[,"Order.Date"])

#下面对Sales_Merge进行初始化，第1行数据是Sales的第1行数据。
idx = 1; 
Sales_Merge[1,"Order.Qty"] = Sales[1,"Order.Qty"];
Sales_Merge[1,"Order.Date"] <- Sales[1,"Order.Date"];

#从Sales的第2行数据开始扫描到最后一行数据。
for (i in 2:nrow(Sales)) {
   if (Sales[i,"Order.Date"] == Sales[i-1,"Order.Date"]) {
        Sales_Merge[idx,"Order.Qty"] = Sales_Merge[idx,"Order.Qty"] + Sales[i,"Order.Qty"]   }
   # 如果本行的数据显示日期和上一行的日期是一样的，则把本行的Order.Qty加入上一行的Order.Qty。
   else { 
        idx <- idx +1; 
        Sales_Merge[idx,"Order.Qty"] = Sales[i,"Order.Qty"]; 
        Sales_Merge[idx,"Order.Date"] = Sales[i,"Order.Date"]}
   # 如果本行的数据显示日期和上一行的日期不一样，本行的数据作为新的一行加入Sales_Merge中。
}

Sales_Merge <- Sales_Merge[-(idx+1:nrow(Sales)),]
#去掉Sales_Merge中多余的行。
#后续的操作需要从字符串数据中提取日、月、年。
#可以使用strsplit函数
#strsplit('3/23/2002','/') 得到 3, 23, 2002

library(dplyr)
library(ggplot2)
setwd("D:/BA/Visualization")
Sales <- read.table('Salesdata.csv',header=T,sep=',',stringsAsFactors=FALSE)
#下面的语句是将相同日期的销量汇总并存到新的变量Sales_Merge 
Sales_Merge <- aggregate(Sales$Order.Qty, list(Sales$Order.Date), sum)
colnames(Sales_Merge) <- c("Order.Date","Order.Qty")

Sales_Merge$Order.Date <- as.Date(Sales_Merge$Order.Date,"%m/%d/%Y")
Sales_Merge <- arrange(Sales_Merge,Order.Date)

Sales2 <- data.frame(Sales_Merge, MonDay = format.Date(Sales_Merge$Order.Date,"%m-%d"))
Sales2 <- data.frame(Sales2,Year = as.factor(format.Date(Sales2$Order.Date,"%Y")))

g <- ggplot(Sales2, aes(x=MonDay, y=Order.Qty, group=Year,colour  = Year)) + geom_line() 
g + scale_colour_brewer(palette="Set2")
g + scale_colour_manual(values = c("#E69F00", "#56B4E9", "#009E73", 
                                   "#F0E442", "#0072B2", "#D55E00"))
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))

Sales3 <- data.frame(Sales2, Month = as.factor(format.Date(Sales2$Order.Date,"%m")))
Sales4 <- aggregate(Order.Qty ~ Month + Year, data = Sales3, sum)
g <- ggplot(Sales4, aes(x=Month, y=Order.Qty, group = Year, colour  = Year)) + geom_line() 
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))

idx <- which(Sales4[,"Year"] %in% c(2004,2005,2006))
Sales5 <- Sales4[idx,]
g <- ggplot(Sales5, aes(x=Month, y=Order.Qty, group = Year, colour  = Year)) + geom_line() 
g + scale_colour_manual(values = c("blue4", "brown4", "darkgoldenrod1", 
                                   "darkgreen", "deeppink2", "mediumturquoise"))
