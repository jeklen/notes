setwd("D:/BA/Homework/HW03")
library("neuralnet")

mydata <- read.csv("NN.csv")

set.seed(1)
ind <- sample(2, nrow(mydata), replace=TRUE, prob=c(0.7, 0.3))
trainset <- mydata[ind==1,]
testset <- mydata[ind==2,]

## build the neural network (NN)
creditnet <- neuralnet(y ~ x.1 + x.2, trainset, hidden = 3, lifesign = 'minimal', 
                       linear.output = FALSE, threshold = 0.01)
#模型：输入层有LTI和age，输出层是default10yr，隐藏层有4个节点，lifesign可选择的参数
#有'minimal'、'full'和'none' 表示运行过程中信息输出的丰富程度。
#linear.output表示是否对输出层进行默认的使用logistic函数进行非线性处理。
#如果选择TRUE则直接输出隐藏层的加权和。如果选择FALSE还要对加权和做logistic函数处理。
#threshold 表示错误对权重的偏导数到达什么时候停止。这里选择0.1，默认是0.01。
## plot the NN
plot(creditnet, rep = "best")
## test the resulting output
temp_test <- subset(testset, select = c("x.1", "x.2"))

creditnet.results <- compute(creditnet, temp_test)
results <- data.frame(actual = testset$y, prediction = creditnet.results$net.result)
#results[100:115, ]
results$prediction <- round(results$prediction)
#results[100:115, ]
table(results)


## the second
set.seed(1)
ind <- sample(2, nrow(mydata), replace=TRUE, prob=c(0.7, 0.3))
trainset <- mydata[ind==1,]
testset <- mydata[ind==2,]

## build the neural network (NN)
creditnet <- neuralnet(y ~ x.1 + x.2, trainset, hidden = 2, lifesign = 'minimal', 
                       linear.output = FALSE, threshold = 0.01)
#模型：输入层有LTI和age，输出层是default10yr，隐藏层有4个节点，lifesign可选择的参数
#有'minimal'、'full'和'none' 表示运行过程中信息输出的丰富程度。
#linear.output表示是否对输出层进行默认的使用logistic函数进行非线性处理。
#如果选择TRUE则直接输出隐藏层的加权和。如果选择FALSE还要对加权和做logistic函数处理。
#threshold 表示错误对权重的偏导数到达什么时候停止。这里选择0.1，默认是0.01。
## plot the NN
plot(creditnet, rep = "best")
## test the resulting output
temp_test <- subset(testset, select = c("x.1", "x.2"))

creditnet.results <- compute(creditnet, temp_test)
results <- data.frame(actual = testset$y, prediction = creditnet.results$net.result)
#results[100:115, ]
results$prediction <- round(results$prediction)
#results[100:115, ]
table(results)

