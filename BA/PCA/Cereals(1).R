setwd("D:/BA/PCA")
Cereals <- read.csv("Cereals.csv", header=TRUE, sep=",")
Cereals_pca <-prcomp(Cereals[,c("calories","rating")],scale = TRUE)
#主成分分析，scale=TRUE意味着首先对变量进行标准化之后再做主成分分析。
#此处只对2个变量，即calories和rating进行主成分分析。
print(Cereals_pca)
#显示calories和rating在2个主成分中的权重值。
summary(Cereals_pca)
#从结果看，第一个主成分捕捉到84.47%的总方差，加上第二个主成分则捕捉到100%的总方差。
Cereals_pca <-prcomp(na.omit(Cereals[,4:16]),scale = FALSE)
#对Cereals表中的第4个变量到第16个变量进行主成分分析。数据没有进行标准化。
#na.omit函数的使用意味着进行主成分分析时自动删掉有缺失数据的记录。
print(Cereals_pca)
#显示这些变量在各个主成分中的权重值。
summary(Cereals_pca)
#从结果看，2个主成分即可捕捉到92.62%的总方差。
Cereals_pca <-prcomp(na.omit(Cereals[,4:16]),scale = TRUE)
#同样对第4个变量到第16个变量进行主成分分析。但数据进行了标准化。
print(Cereals_pca)
summary(Cereals_pca)
#从结果看，要用7个主成分才能捕捉到90%以上的的总方差。（7个变量捕捉到93.026%的总方差）
(Cereals$calories-mean(Cereals$calories))/sd(Cereals$calories)
scale(Cereals$calories)
#上面显示手算的标准化处理之后的结果与使用scale函数处理的结果相同。
#所以scale函数是对数据进行标准化处理的一个很好用的函数。