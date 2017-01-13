library(car) ## needed to recode variables
set.seed(1)
setwd("D:/BA/Logit")
delay <- read.csv("Flightdelays.csv",header = TRUE)

## define hours of departure
delay$sched=factor(floor(delay$schedtime/100))
table(delay$sched)
table(delay$carrier)
table(delay$dest)
table(delay$origin)
table(delay$weather)
table(delay$dayweek)
table(delay$daymonth)
table(delay$delay)
delay$delay=recode(delay$delay,"'delayed'=1;else=0")
table(delay$dayweek)
## omit unused variables
delay=delay[,c(-1,-3,-5,-6,-7,-11,-12)]
delay[1:3,]
n=length(delay$delay)
n1=floor(n*(0.6))
n2=n-n1
train=sample(1:n,n1)
## estimation of the logistic regression model
## explanatory variables: carrier, destination, origin, weather,
## day of week (weekday/weekend), scheduled hour of departure
## create design matrix; indicators for categorical variables
## (factors)
Xdel <- model.matrix(delay~.,data=delay)[,-1]
Xdel[1:3,]
xtrain <- Xdel[train,]
xnew <- Xdel[-train,]
ytrain <- delay$delay[train]
ynew <- delay$delay[-train]
m1=glm(delay~.,family=binomial,data=data.frame(delay=ytrain,xtrain))
summary(m1)
## prediction: predicted default probabilities for cases in test set
ptest <- predict(m1,newdata=data.frame(xnew),type="response")
data.frame(ynew,ptest)[1:10,]
## first column in list represents the case number of the test
## element  
plot(ynew~ptest)
## coding as 1 if probability 0.5 or larger
gg1=floor(ptest+0.5) ## floor function; see help command
ttt=table(ynew,gg1)
ttt
error=(ttt[1,2]+ttt[2,1])/n2
error
