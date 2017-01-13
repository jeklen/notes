library(XML)

setwd('D:/BA/GetData')
#MyPath <- Sys.getenv("PATH")
#MyPath
#检查看path里面有没有phantomjs.exe所在的目录：D:\BA\GetData
#如果没有则需要在系统path当中加入该目录
#if (is.na(str_match(MyPath,'D:\\\\BA\\\\GetData'))) 
#{ Sys.setenv(PATH=paste0(MyPath,'D:\\BA\\GetData;')) } else {};
#Sys.getenv("PATH")

MyScrapeJS <- function(MyURL){
  ## change Phantom.js scrape file
  lines <- readLines("ScrapePage.js")
  lines[1] <- paste0("var url ='", MyURL,"';")
  writeLines(lines, "ScrapePage.js") }

MyScrapeJS('http://hefei.lashou.com/')
system("phantomjs ScrapePage.js")
doc <- htmlParse('MyPage.html')
xpathSApply(doc, "//a[@class='index-goods-name']", xmlValue)

MyScrapeJS('http://shanghai.lashou.com/')
system("phantomjs ScrapePage.js")
doc <- htmlParse('MyPage.html')
xpathSApply(doc, "//a[@class='index-goods-name']", xmlValue)

MyScrapeJS('http://www.oddsportal.com/hockey/usa/nhl-2013-2014/carolina-hurricanes-ottawa-senators-80YZhBGC/')
system("phantomjs ScrapePage.js")
doc <- htmlParse('MyPage.html')
readHTMLTable(doc, header=TRUE, which=1,stringsAsFactors=F)

MyScrapeJS('http://v6.bang.weibo.com/czv/caijing?period=month')
system("phantomjs ScrapePage.js")
doc <- htmlParse('MyPage.html')
xpathSApply(doc, "//dd[@class='name']", xmlValue)
xpathSApply(doc, "//dd[@class='intro_ve']", xmlValue)
xpathSApply(doc, "//span[contains(@data-reactid,'.0.3.1.0')]", xmlValue)
