#Function: ChiMerge
#Author: Zach Zhizhong ZHOU, zhouzhzh@sjtu.edu.cn
#Date: Oct/03/2016

InitializeV <- function (VC)
#Function InitializeV, VC: the first column saves value, the second class.
{
  SortedValue <- sort(unique(VC[,1]))
  IntervalPoints <- rep(0,(length(SortedValue)+1)) #Initialize Interval Points
  IntervalPoints[1] <- min(SortedValue) 
  #The first interval point is the minimum of values.
  IntervalPoints[length(SortedValue)+1] <- max(SortedValue)
  #The last interval point is the maximum of values.
  for (k in 2:length(SortedValue))
  {
    IntervalPoints[k]=(SortedValue[k-1]+SortedValue[k])/2    
    #The midpoint of two values is used as the cutpoint.    
  }
  return(IntervalPoints)
}

ShowVC <- function (VC, IntervalPoints) {
  InterV <- cut(VC[,1],IntervalPoints,include.lowest=TRUE);
  print(table(InterV, VC[,2]));
}

ChiSquareValue <- function(TableV) {
  R = rep(0,2); #Initialization of R
  R[1]=sum(TableV[1,]);   R[2]=sum(TableV[2,]);
  TotalN = R[1]+R[2];
  nC = ncol(TableV); #number of classes
  ExpVTable = matrix(0,nrow=2,ncol=nC) #Initialization of Expected A_ij
  for (i in c(1:2))
    for (j in c(1:nC)) {
      tmpV=sum(TableV[,j])*R[i]/TotalN; #C_j = TableV[,j]
      ExpVTable[i,j]=if(tmpV>0) tmpV else 0.1;
    }
  return(sum((ExpVTable-TableV)^2/ExpVTable))
}

Shrink <- function (VC, IntervalPoints,verbose=FALSE) {
  InterV <- cut(VC[,1],IntervalPoints,include.lowest=TRUE)
  #Assign intervals as a factor to each value.
  InterVTable <- table(InterV, VC[,2])
  #Creat a table to show in each interval, how many items in each class.
  nT <- nrow(InterVTable)
  ChiSquareV <- rep(0,nT-1)
  for (i in c(1:(nT-1))) {
    ChiSquareV[i] <- ChiSquareValue(InterVTable[i:(i+1),])
    #Calculate Chi Square value for each pair of intervals. 
  }
  if (verbose) cat("Chi Square Values: ",ChiSquareV,"\n");
  # ChiSquareV
  to_drop = which.min(ChiSquareV);
  return(IntervalPoints[-(to_drop+1)]) 
  #drop the cut point where the two intervals should merge.
}

ChiMerge <- function(VC, NIntervals,verbose=FALSE) 
#Function ChiMerge, VC: the first column saves value, the second class.
#VC means Value, Class
#NIntervals: Number of Intervals
{
   IntervalPoints <- InitializeV(VC);
   if (verbose) ShowVC(VC, IntervalPoints);
   while(length(IntervalPoints)>(NIntervals+1)) {
     IntervalPoints <- Shrink(VC, IntervalPoints,verbose);
     if (verbose) ShowVC(VC, IntervalPoints);
   }
   return(IntervalPoints)
}

data(iris)
myVC <- data.frame( income=c(2,5,10,10,20,60),
                    type=c('low','low','mid','mid','mid','high'))
CutPoints <- ChiMerge(myVC,3,verbose=TRUE)
ShowVC (myVC,CutPoints)

irisData <- data.frame(iris$Sepal.Length,iris$Species)
CutPoints <- ChiMerge(irisData,3,verbose=TRUE)
ShowVC (irisData,CutPoints)
qchisq(.95, df=2) #degree of freedom: (column -1)*(row-1) = (3-1)*(2-1) =2
#row # is 2 because we only compare two groups.
#colunm # is 3 because there are three classes in iris database.

library(discretization)
disc=chiM(iris,alpha=0.05)
disc$cutp #cut points
