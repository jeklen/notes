library(stringr)
library(XML)
library(RCurl)

setwd('D:/BA/GetData')
#doc = getURL("https://movie.douban.com/top250") #目前豆瓣已经将网址升级为https而不是http
#使用原来的htmlParse函数已经不能抓取网页，现在使用RCurl包里面的getURL函数。
#writeLines(doc,'Douban_HTML.txt')
#doc <- htmlParse(doc)

doc <- htmlParse('Douban_HTML.txt')

titles <- xpathSApply(doc, "//span[@class='title']",xmlValue) 
titles
length(titles);
title_id = 0; 
MovieTitles <- data.frame(Title = character(0), Title2 = character(0),
                          stringsAsFactors = FALSE) #创建一个空的数据框，有2列分别是Title和Title2
toRemove <- '\\s/\\s' #很明显Title2前面3个字符是无用的，准备移走。
# toRemove <- str_sub(titles[9],1,3)
for (i in (1:length(titles))) { #遍历搜集到的电影名
  if (str_detect(titles[i],toRemove)) {  #如果该电影名含有我们打算移除的3个字符
    MovieTitles[title_id,"Title2"] = gsub(toRemove,'',titles[i])} #移除字符后结果保存在Title2列中。
  else {
    title_id <- title_id+1; 
    MovieTitles[title_id,"Title"] = titles[i]} 
}
fix(MovieTitles)

#ratings <- as.numeric(xpathSApply(doc, "//span[contains(@class, 'rating')]",xmlValue))
ratings <- as.numeric(xpathSApply(doc, "//span[@class='rating_num']",xmlValue))
ratings
length(ratings)
MovieData <- cbind(MovieTitles, data.frame(Rating = ratings))
fix(MovieData)

movieURLs <- xpathSApply(doc, '//a', xmlGetAttr, "href") #提取标签a中的名为href的属性值。
movieURLs
str_detect(movieURLs,'/subject') #只保留URL中包含/subject的URLs。
movieURLs <- movieURLs[str_detect(movieURLs,'/subject')] #只保留URL中包含/subject的URLs。
movieURLs
movieURLs <- unique(movieURLs) #每个电影的URL都出现2次，需要去除重复出现的URL。
movieURLs
length(movieURLs)
#上面的语句只是展示如果取到没用的数据时如何进行数据清理，下面的一条语句就可以直接取出所有URL。
movieURLs <- xpathSApply(doc, "//div[@class='hd']/a", xmlGetAttr, "href")

MovieData <- cbind(MovieData, data.frame(URL = movieURLs))
fix(MovieData)

Comments <- xpathSApply(doc, "//span",xmlValue)
Comments
Comments <- Comments[str_detect(Comments,'人评价')]
Comments
Comments <- as.numeric(gsub('人评价','',Comments))
class(Comments)
MovieData <- cbind(MovieData, data.frame(Comments = Comments))

write.csv(MovieData, file = 'D:/BA/GetData/DouBan1.csv',row.names = FALSE)
