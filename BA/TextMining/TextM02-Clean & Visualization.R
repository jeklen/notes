library(tm)
library(ggplot2)
library(wordcloud)
library(SnowballC)

sourcedir <- 'D:/BA/TextMining/Corpus/txt' #将要用来进行文本挖掘的txt文件所在的目录
docs <- Corpus(DirSource(sourcedir))  #生成语料库。
summary(docs)

#下面的语句是将 /，@，和|这样的符号用空格替换掉。
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

docs <- tm_map(docs, content_transformer(tolower))  #所有字母转换成小写
docs <- tm_map(docs, removeNumbers) #移除数字
docs <- tm_map(docs, removePunctuation) #移除符号
docs <- tm_map(docs, removeWords, stopwords("english")) #移除英语停用词（没什么意义的词如and an）
docs <- tm_map(docs, removeWords, c("department", "email")) #移除自定义的停用词
docs <- tm_map(docs, stripWhitespace) #移除多余空格，连续几个空格变成1个。

#下面是将几个特定的研究单位的全称改成简称。
toString <- content_transformer(function(x, from, to) gsub(from, to, x))
docs <- tm_map(docs, toString, "harbin institute technology", "HIT")
docs <- tm_map(docs, toString, "shenzhen institutes advanced technology", "SIAT")
docs <- tm_map(docs, toString, "chinese academy sciences", "CAS")

#library(SnowballC)
docs <- tm_map(docs, stemDocument) #进行stemming操作。
#stemming是针对英语的一种处理，例如administration和administrative经过stemming处理之后
#被视为同样的词，就类似“番茄”和“西红柿”在中文中应该视为同样的词一样。
#stemming的更详细资料见 http://snowball.tartarus.org/algorithms/porter/stemmer.html

writeLines(as.character(docs[[1]])) #展示经过处理之后的第一篇文档。

dtm <- DocumentTermMatrix(docs) #建立Document Term Matrix，其中行是文本文件，列是词。
#矩阵的值是某词在某个文档出现的频数。
dim(dtm) #检视dtm的行列数，可见有46个文本文件，所有文件提取出2万多个词。
class(dtm)

tdm <- TermDocumentMatrix(docs) #dtm的倒置矩阵是tdm
dim(tdm)

freq <- colSums(as.matrix(dtm)) #colSums算出一个col总和，也就是一个词（对应一列）频数总和
length(freq) #总共有23100个词
ord <- order(freq) #词频从小到大进行排序
freq[head(ord)] #Least frequent terms 
freq[tail(ord)] #most frequent terms 最频繁的词

dtms <- removeSparseTerms(dtm, 0.15) #移除稀疏词
dim(dtms)
dtms_matrix <- as.matrix(dtms)
dtms_matrix
freq <- sort(colSums(as.matrix(dtms)), decreasing=TRUE)
freq

findFreqTerms(dtm, lowfreq=600) #找出频繁出现的词
findFreqTerms(dtm, lowfreq=200) 

findAssocs(dtm, "data", corlimit=0.6) #找到data这个词的关联词，设置的最低关联度为0.6。

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
head(freq, 14)

#library(ggplot2)
fqword <- subset(freq, freq>500) #提取出现频度达到500个的词
WordFreq <- data.frame( word = names(fqword), freq = fqword) #建立数据框以便画图。
g <- ggplot(WordFreq, aes(word,freq)) + geom_bar(stat="identity") #画柱状图。
g + theme(axis.text.x=element_text(angle=45, hjust=1)) #x轴的文字倾斜45度角。

#下面画词云。
#library(wordcloud)
wordcloud(names(freq), freq, min.freq=40)
wordcloud(names(freq), freq, max.words=100)
wordcloud(names(freq), freq, min.freq=100)
wordcloud(names(freq), freq, min.freq=100, colors=brewer.pal(6, "Dark2"))
wordcloud(names(freq), freq, min.freq=100, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))
