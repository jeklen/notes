library(tm)   #文本挖掘
library(wordcloud) #绘制词云
library(Rwordseg)  #中文分词
library(slam) #for function row_sums
library(lda)
library(topicmodels)

setwd('D:/BA/TextMining/Corpus/CNSample')
csv <- read.csv("TXTCorpus.csv",header=T, stringsAsFactors=F)
mystopwords<- unlist (read.table("D:/BA/TextMining/CN_StopWords.txt",stringsAsFactors=F))

#移除数字 
removeNumbers = function(x) { return(gsub("[0-9０１２３４５６７８９]","",x)) } 
removeNumbers('00８６４７Hello') #测试函数。
removeNonBreakingSpace = function(x) { return(gsub("&nbsp;","",x)) } #移除文本中的&nbsp;
#中文分词，也可以考虑使用 rmmseg4j、rsmartcn 
wordsegment<- function(x) { segmentCN(x, returnType = "tm") }
wordsegment('人生没有彩排,每一天都是现场直播。') #测试函数。

#移除长度为1的中文字符和中文停止词（即没什么意义的词）。
removeSingleANDStopWords = function(x, stopwords) 
{ return_text = character(0)  #生成一个空字符串。
  `%not_in%` <- Negate(`%in%`) #定义操作符“不在其中”
  Strings <- unlist(strsplit(x,' ')) #将长字符串打散成一个个词。
  index <- 1 
  it_max <- length(Strings) 
  while (index <= it_max) { 
    if ((nchar(Strings[index])>1) && (Strings[index] %not_in% stopwords))
      return_text <- paste(return_text,Strings[index]) 
    #如果第(index)个词长度大于1，并且不在停词表中，则将它留在字符串中。
    index <- index +1 } #继续检查下一个词。
  return_text <- substr(return_text, 2, nchar(return_text)) #移除长字符串前面的第一个字符（即空格）
  return(return_text) }
removeSingleANDStopWords('人生 没有 彩排 每 一天 都 是 现场 直播',mystopwords)

sample.words <- sapply(csv$text, removeNumbers)  #移除数字 
sample.words <- sapply(sample.words, removeNonBreakingSpace) 
sample.words <- sapply(sample.words, wordsegment) #中文分词
names(sample.words) <- (1:length(sample.words))

#先处理中文分词，再处理 stopwords，防止全局替换丢失信息。下面一条语句耗时较长。
sample.words <- sapply(sample.words, removeSingleANDStopWords, mystopwords)
sample.words[1] 

corpus <- Corpus(VectorSource(as.character(sample.words))) #生成语料库。
meta(corpus,"cluster") <- csv$type #给语料库中的文本加标签，标签就是我们已经了解的它们的类型。
unique_type <- unique(csv$type)
unique_type

#建立文档-词条矩阵，词的长度至少为2。
sample.dtm <- DocumentTermMatrix(corpus, control = list(wordLengths = c(2, Inf)))
#建立词条-文档矩阵，词的长度至少为2。
sample.tdm <- TermDocumentMatrix(corpus, control = list(wordLengths = c(2, Inf)))
tdm_matrix <- as.matrix(sample.tdm) #将词条-文档矩阵用矩阵形式表达。
tail(tdm_matrix) #可见该矩阵在尾部的数据：显示几个词条在100个文档中出现的次数。
write.csv(tdm_matrix,file='tdmMatrix.csv')
#打开C:\BA\TextMining\Corpus\CNSample\tdmMatrix.csv文件，
#可以发现R的tm包在识别词组的时候出了一些错误。
#例如第310行的词是“爱好者 不容”，第311行的词是“爱好者 提问”。这是错误的。
#应该把“爱好者”，“不容”和“提问”分别视为1个词。所以tm包在处理中文的时候是有问题的，
#我们恐怕需要重写TermDocumentMatrix函数。目前我没有时间处理这件事情，如果有时间重写该函数再发给你们。

#按分类汇总wordcloud对比图
n <- nrow(csv) 
zz1 = 1:n
cluster_matrix<-sapply(unique_type,function(type){apply(tdm_matrix[,zz1[csv$type==type]],1,sum)})
#上面的语句是把所有的文档按照类别进行词频汇总。文档编号为1到100。
#在TXTCorpus.csv的type列中存放着文档类型。第1到第10篇文档主题是汽车。
#那么针对每个词（如“黑车”），需要把1到10篇文档中出现“黑车”的次数进行汇总。汇总结果存于cluster_matrix
png(paste("Cluster_Comparison",".png", sep = ""), width = 800, height = 800 )
#图画在工作目录下的png格式图片文件中。
comparison.cloud(cluster_matrix,colors=brewer.pal(ncol(cluster_matrix),"Paired"))
#此处我们有10种类别，需要用到10种颜色，调色盘Paired可以调出12种颜色。
#如果使用调色盘Dark2就会出错，因为它只能调出8种颜色。如果有很多类别比如15种，那么任何事先
#定义的调色盘都调不出这么多颜色，我们需要手工调色。相关语句在CHNMap文件夹的文件中可以找到。
#例如调13种颜色，可以使用以下语句：
#myColors <- colorRampPalette(c("lightgoldenrod1", "red3"))(13)
#comparison.cloud(cluster_matrix,colors=myColors)
#也可以用comparison.cloud(cluster_matrix,colors=rainbow(13))
title(main = "sample cluster comparision")  #图表的标题
dev.off() #关闭画图的device（即图片文件）。
#从图上看，能用来识别旅游主题的关键词包括中国、旅游、游客、黄金等。能用来识别招聘主题的
#关键词包括电话、北京、招聘、广东、东莞、骗局等。能用来识别文化主题的词较少，有玫瑰、游戏等。

#分类画词云图
sample.cloud <- function(topic, maxwords = 100) {  
  words <- sample.words[which(csv$type==topic)]  #提取主题等于topic变量的词
  allwords <- unlist(strsplit(words,' ')) #将长字符串打散变成一个个词。
  wordsfreq <- sort(table(allwords), decreasing = T)  #计算词频，存入wordsfreq
  wordsname <- names(wordsfreq) 
  png(paste("Topic_", topic, ".png", sep = ""), width = 800, height = 800 )  
  wordcloud(wordsname, wordsfreq, scale = c(6, 1.5), min.freq = 2, 
            max.words = maxwords, colors = rainbow(100))  
  title(main = paste("Topic:", topic))  
  dev.off()  
}
sapply(unique_type,sample.cloud)# unique(csv$type)
#到工作目录（C:\BA\TextMining\Corpus\CNSample）查看画出来的图。

#主题模型分析
#library(lda)
dim(sample.dtm) #文档-词条矩阵有100个文档，9211条词条。
dtm_matrix <- as.matrix(sample.dtm)
#下面计算每个词条的平均tf-idf值。这个值用来评估一个词在一个语料库的一篇文档当中的重要性。
#词频(term frequency, TF)指的是该文章中某个词出现的次数除以该文章的总词数。
#词频越高说明该词在文档中越重要，例如一篇文档不断提到“翼龙”则“翼龙”应该成为该文档关键词。
#逆向文档频率（inverse document frequency, IDF）是一个词普遍重要性的度量
#计算公式：IDF = log(D/Dt)，D为文章总数，Dt为该词出现的文章数量。
#逆向文档频率越高说明该词用于文档分类越重要，例如语料库是讨论恐龙的文档，其中只有1-2篇是讨论翼龙的，
#则该翼龙用于文档分类就很重要。但如果语料库的文档全部是讨论翼龙的，则“翼龙”就不重要了。
#计算sample.dtm的第一个词条在第一篇文章的tf-idf值应该这样计算：
NDoc <- nrow(dtm_matrix) #语料库中的文档总数，100篇。
DocWords <- sum(dtm_matrix[1,]) #第一篇文档的总词数
tf <- dtm_matrix[1,1]/DocWords #第一个词在第一篇文档的词频
DocTimes <- sum(dtm_matrix[,1]>0) #第一个词在几篇文档中出现过
idf <- log2(NDoc/DocTimes) #idf
tf_idf <- tf*idf #第一个词条在第一篇文章的tf-idf值

#我们想算一下所有词的大于0的tf-idf值的平均值。
NDoc <- nrow(dtm_matrix)
DocTimes <- rep(0,ncol(dtm_matrix)) #DocTimes 用来记录每个词条在几篇文档中出现过。
for (j in (1:ncol(dtm_matrix)) ) DocTimes[j] <- sum(dtm_matrix[,j]>0)
DocWords <- rep(0,nrow(dtm_matrix)) #DocWords 用来记录每个文档有几个词。
for (i in (1:nrow(dtm_matrix)) ) DocWords[i] <- sum(dtm_matrix[i,])

term_tf <- apply(dtm_matrix, 2, function(x) x/DocWords) #计算每个词在每个文档中的tf值
term_tf_idf <- apply(term_tf, 1, function (x) x*log2(NDoc/DocTimes))
#以上计算每个词在每个文档中的tf-idf值。下面计算所有词的大于0的tf-idf值的平均值。
#如果该平均值大，则使用该词进行文档分类是有用的。
avg_term_tf_idf <- apply(term_tf_idf, 1, sum)/DocTimes
summary(avg_term_tf_idf)

#下面的2行语句也可以算出所有词的大于0的tf-idf值的平均值。
avg_term_tf_idf <- tapply(sample.dtm$v/row_sums( sample.dtm)[ sample.dtm$i], sample.dtm$j, mean)* 
  log2(nDocs( sample.dtm)/col_sums( sample.dtm > 0)) 
summary(avg_term_tf_idf)

dtm.Lg.tf.idf <- sample.dtm[, avg_term_tf_idf >= 0.1] #把tf-idf取值较高的词留下来。
#从summary(avg_term_tf_idf)的结果看，取值大于0.1将会排除至少75%的词（注意到75%分位数为0.030620）
#删掉了tf_idf取值较低的词之后，有的文档可能所有的词都被删掉了，这些文档应该从语料库中去掉。
dtm.Lg.tf.idf <- dtm.Lg.tf.idf[row_sums(dtm.Lg.tf.idf) > 0,]
dim(dtm.Lg.tf.idf) #94篇文档，只剩下313个词进行分析。

n_topics <- length(unique(csv$type)) 
#library(topicmodels) 
SEED <- 2012 
sample_TM <- list( VEM = LDA( dtm.Lg.tf.idf, k=n_topics, control = list(seed = SEED)), 
                   VEM_fixed = LDA( dtm.Lg.tf.idf, k = n_topics, control = list(estimate.alpha = FALSE, seed = SEED)), 
                   Gibbs = LDA( dtm.Lg.tf.idf, k = n_topics, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)), 
                   CTM = CTM( dtm.Lg.tf.idf, k = n_topics, control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3)))) 
Topic <- topics(sample_TM[["VEM"]], 1) #最可能的主题文档
Terms <- terms(sample_TM[["VEM"]], 5) #每个主题的前5个关键词
Terms[, 1:10]

#下面使用层次聚类：
sample_matrix = as.matrix(sample.dtm) 
rownames(sample_matrix) <- csv$type 
sample_hclust <- hclust(dist(sample_matrix), method="ward.D") 
plot(sample_hclust)  #效果不是很好，看起来军事、招聘、旅游聚类还可以，其他效果不好。
rect.hclust(sample_hclust,k=length(unique(csv$type)))

#下面使用kMeans：
sample_KMeans <- kmeans(sample_matrix, length(unique(csv$type))) 
library(clue)
cl_agreement(sample_KMeans, as.cl_partition(csv$type), "diag") 
#计算共同分类率，只有24%文档分类与事先已知的分类相同。

#下面使用string kernels：
library(kernlab)
stringkern  <-  stringdot(type  =  "string")
stringC1 <- specc(sample_matrix, 10, kernel=stringkern)
#查看统计效果
table("String  Kernel"=stringC1,  cluster = csv$type )
#效果很不理想。
