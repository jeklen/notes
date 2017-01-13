library(tm)
library(stringi)
library(proxy)
library(wordcloud) #required for plotting word cloud

wiki <- "http://en.wikipedia.org/wiki/"
titles <- c("Integral", "Riemann_integral", "Riemann-Stieltjes_integral", "Derivative",
            "Limit_of_a_sequence", "Edvard_Munch", "Vincent_van_Gogh", "Jan_Matejko",
            "Lev_Tolstoj", "Franz_Kafka", "J._R._R._Tolkien")
#There are 5 mathematical terms (3 of them are about integrals), 3 painters and 3 writers.
articles <- character(length(titles))

for (i in 1:length(titles)) {
  articles[i] <- stri_flatten(readLines(stri_paste(wiki, titles[i])), col = " ")
}

docs <- Corpus(VectorSource(articles))
#将文本转成语料库
docs[[1]]
inspect(docs[1])
getTransformations() #The basic transforms are all available within tm.

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs2 <- tm_map(docs, toSpace, "<.+?>")
docs3 <- tm_map(docs2, toSpace, "\t")

docs4 <- tm_map(docs3, PlainTextDocument)
docs5 <- tm_map(docs4, stripWhitespace)
docs6 <- tm_map(docs5, removeWords, stopwords("english"))
docs7 <- tm_map(docs6, removePunctuation)
docs8 <- tm_map(docs7, content_transformer(tolower))
#去掉不想要的字符
docs8[[1]]
dtm <- DocumentTermMatrix(docs8)
#建立文档-词条矩阵
findFreqTerms(dtm,40) #find those terms that occur at least 40 times.
findAssocs(dtm, "painting", 0.9) #find associations (i.e., terms which correlate) 
#with at least 0.9 correlation for the term "painting"

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
head(freq,14)
wordcloud(names(freq), freq, min.freq=30)
#画文本云图

dtm2 <- removeSparseTerms(dtm, sparse=0.50) 
data <- as.data.frame(inspect(dtm2))
dim(data)
rownames(data)<- 1:nrow(data)
data.scale <- scale(data) 
d <- dist(data.scale, method = "euclidean") 
fit <- hclust(d, method="ward.D")
plot(fit) 

#################################
library(tm) 
reut21578 <- system.file("texts", "crude", package = "tm") 
reuters <- Corpus(DirSource(reut21578), readerControl = list(reader = readReut21578XML)) 
reuters <- tm_map(reuters, PlainTextDocument) 
reuters <- tm_map(reuters, stripWhitespace) 
reuters <- tm_map(reuters, content_transformer(tolower)) 
reuters <- tm_map(reuters, removeWords, stopwords("english")) 
reuters <- tm_map(reuters, stemDocument) 
dtm <- DocumentTermMatrix(reuters) 
inspect(dtm)

d=c("prices", "crude", "oil")
inspect(DocumentTermMatrix(reuters, list(dictionary = d)))

dtm2 <- removeSparseTerms(dtm, sparse=0.95) 
data <- as.data.frame(inspect(dtm2)) 
rownames(data)<- 1:nrow(data)
data.scale <- scale(data) 
d <- dist(data.scale, method = "euclidean") 
fit <- hclust(d, method="ward.D")
plot(fit) 
