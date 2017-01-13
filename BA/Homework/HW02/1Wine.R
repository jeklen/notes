setwd("D:/BA/Homework/HW02")
Wine <- read.csv("Wine.csv", header=TRUE, sep=",")

Wine_pca <-prcomp(na.omit(Wine[,2:14]),scale = FALSE)
#对Wine表中的第2个变量到第14个变量进行主成分分析。数据没有进行标准化。
#na.omit函数的使用意味着进行主成分分析时自动删掉有缺失数据的记录。
print(Wine_pca)
#显示这些变量在各个主成分中的权重值。
summary(Wine_pca)
#从结果看，1个主成分即可捕捉到99.81%的总方差。
Wine_pca <-prcomp(na.omit(Wine[,2:14]),scale = TRUE)
#同样对第2个变量到第14个变量进行主成分分析。但数据进行了标准化。
print(Wine_pca)
summary(Wine_pca)
#从结果看，要用8个主成分才能捕捉到90%以上的的总方差。（8个变量捕捉到0.92018%的总方差）