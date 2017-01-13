library(party)
str(iris)
#Compactly Display the Structure of an Arbitrary R Object
ind <- sample(2, nrow(iris), replace=TRUE, prob=c(0.7, 0.3))
#Assign 1 or 2 to ind randomly with Prob(1)=0.7 and Prob(2)=0.3
#调1，挑2放入这个里面
trainData <- iris[ind==1,]
testData <- iris[ind==2,]
#其实就是挑出数据
myFormula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
iris_ctree <- ctree(myFormula, data=trainData)
# check the prediction
table(predict(iris_ctree), trainData$Species)

print(iris_ctree)
plot(iris_ctree)
plot(iris_ctree, type="simple")

# predict on test data
testPred <- predict(iris_ctree, newdata = testData)
table(testPred, testData$Species)