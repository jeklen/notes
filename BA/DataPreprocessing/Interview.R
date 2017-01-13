library(plyr)

setwd("D:/BA/DataPreprocessing")
dataset <- read.csv("20161229.csv")
StuGPA <- dataset[,'GPA']
StuENG <- dataset[,'English']

sort(StuGPA+StuENG)
GPAENG <- StuGPA+StuENG
hist(GPAENG,breaks=6)

dataset = data.frame(dataset, GPA_ENG = GPAENG)
dataset = data.frame(dataset, Range=cut(GPAENG,c(66,64,62,60,58,56,54)))
count(dataset,var='Range')
# dataset = subset(dataset, select=-c(6)) #用来删除列

ScoreLookup <- aggregate(GPA_ENG ~ Range, data = dataset, mean)
ScoreLookup
ScoreLookup <- data.frame(ScoreLookup, LetterGPA = c('C','B-','B','B+','A-','A'),
                          stringsAsFactors = FALSE)

NumericGrades <- function(x) {
  ScoreLookup[ScoreLookup$LetterGPA ==x,'GPA_ENG']*3/7
}
NumericGrades('A') #根据分数表填入数值分数。
#由于面试分数占30%，剩下的占70%，因此GPA_ENG分数转变成面试分数需要乘以3/7

ItvGrades <- read.csv("InterviewGrades.csv",stringsAsFactors = FALSE)
sapply(ItvGrades$Grade01,NumericGrades)

ItvGrades <- data.frame (ItvGrades, NGrade01 = sapply(ItvGrades$Grade01,NumericGrades),
                         NGrade02 = sapply(ItvGrades$Grade02,NumericGrades),
                         NGrade03 = sapply(ItvGrades$Grade03,NumericGrades))
MeanInterview <- (ItvGrades$NGrade01+ItvGrades$NGrade02+ItvGrades$NGrade03)/3

To_Merge <- data.frame(Number=ItvGrades$NO, Interview = MeanInterview)
dataset = merge(dataset, To_Merge, by.x='Number', by.y='Number')

dataset = data.frame(dataset, Total = dataset$GPA_ENG + dataset$Interview)
dataset[order(-dataset$Total),]
