library(XML)

setwd("d:/BA/Homework/HW01")
url = 'PengPai_HTML.txt'
doc <- htmlParse(url)

Hot00 <- xpathSApply(doc, ,xmlValue) #提取每日热门新闻
Hot00

Hot01 <- xpathSApply(doc, ,xmlValue) #提取三天内热门新闻
Hot01

Hot02 <- xpathSApply(doc, ,xmlValue) #提取一周内热门新闻
Hot02