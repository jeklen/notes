library(dplyr) #for the function 'arrange'

setwd("D:/BA/Visualization")
Sales <- read.table('Salesdata.csv',header=T,sep=',',stringsAsFactors=FALSE)
Sales <- arrange(Sales,Order.Date)
# ���϶�Sales����Order.Date��������
# ����׼������һ�����ݿ�Ŀ���ǽ�ԭ���ݿ�����ͬ���ڵ����۽��л��ܷ���һ�С�
Sales_Merge <- data.frame(Order.Date=rep('NA',nrow(Sales)), Order.Qty = rep(0,nrow(Sales)))
# �����ݿ���г�ʼ������ʱ��R�Զ����ַ�������ת����factor�ͱ�����������Ҫ��factor�ͱ����ָ����ַ���������
Sales_Merge[,"Order.Date"]<- as.character(Sales_Merge[,"Order.Date"])

#�����Sales_Merge���г�ʼ������1��������Sales�ĵ�1�����ݡ�
idx = 1; 
Sales_Merge[1,"Order.Qty"] = Sales[1,"Order.Qty"];
Sales_Merge[1,"Order.Date"] <- Sales[1,"Order.Date"];

#��Sales�ĵ�2�����ݿ�ʼɨ�赽���һ�����ݡ�
for (i in 2:nrow(Sales)) {
   if (Sales[i,"Order.Date"] == Sales[i-1,"Order.Date"]) {
        Sales_Merge[idx,"Order.Qty"] = Sales_Merge[idx,"Order.Qty"] + Sales[i,"Order.Qty"]   }
   # ������е�������ʾ���ں���һ�е�������һ���ģ���ѱ��е�Order.Qty������һ�е�Order.Qty��
   else { 
        idx <- idx +1; 
        Sales_Merge[idx,"Order.Qty"] = Sales[i,"Order.Qty"]; 
        Sales_Merge[idx,"Order.Date"] = Sales[i,"Order.Date"]}
   # ������е�������ʾ���ں���һ�е����ڲ�һ�������е�������Ϊ�µ�һ�м���Sales_Merge�С�
}

Sales_Merge <- Sales_Merge[-(idx+1:nrow(Sales)),]
#ȥ��Sales_Merge�ж�����С�
#�����Ĳ�����Ҫ���ַ�����������ȡ�ա��¡��ꡣ
#����ʹ��strsplit����
#strsplit('3/23/2002','/') �õ� 3, 23, 2002

library(dplyr)
library(ggplot2)
setwd("D:/BA/Visualization")
Sales <- read.table('Salesdata.csv',header=T,sep=',',stringsAsFactors=FALSE)
#���������ǽ���ͬ���ڵ��������ܲ��浽�µı���Sales_Merge 
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