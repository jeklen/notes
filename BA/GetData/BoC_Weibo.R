library(XML)
library(selectr)
setwd("d:/BA/GetData")
url = 'http://www.boc.cn/sourcedb/whpj/'
Rates = readHTMLTable(url, header=TRUE, which=2,stringsAsFactors=F)
fix(Rates) #表格头是乱码，下面需要重新定义表格头，消除乱码。
names(Rates) <- c('货币名称','现汇买入价','现钞买入价','现汇卖出价','现钞卖出价',
                  '中行折算价','发布日期','发布时间')
fix(Rates)
#R语言处理中文有时候会出现乱码，上面的语句是手工输入正确的表格头。下面的语句是自动输入。
#效果和上面的语句是一样的。
doc = htmlParse(url)  #提取网页源代码
t_heads <- xpathSApply(doc, "//th", xmlValue)  #提取表格头信息。

#xpathSApply(doc, "/html/body/div/div[5]/div[1]/div[2]/table/tbody/tr[1]/th[1]", xmlValue)
#从谷歌浏览器或者360浏览器里导出的xPath有误，多了一个/tbody，而且div[5]应该是div[3]。
#可能是使用htmlParse函数下载网页源码的时候产生了变动。
#xpathSApply(doc, "/html/body/div/div[3]/div[1]/div[2]/table/tr[1]/th", xmlValue)
#因此使用xPath时候一切以下载的源码为准。
querySelectorAll(doc, "body > div > div.BOC_main > div.publish > div:nth-child(3) > 
                 table  > tr:nth-child(1) > th")

t_heads #检查表格头是不是我们想要的结果。
names(Rates) <- t_heads #将表格头信息赋值给数据框Rates的表格头。
write.csv(Rates, file = 'ExRates.csv', row.names = FALSE) #将数据框Rates的内容写入ExRates.csv

fileName <- 'd:/BA/GetData/Weibo_HTML.txt'
doc <- htmlParse(fileName)
#url = 'http://bang.weibo.com/renwu'
#doc = htmlParse(url)  #提取网页源代码
names <- xpathSApply(doc, "//dd[@class='name']",xmlValue) #提取人名
names

influence <- xpathSApply(doc, "//dd[@class='influence']",xmlValue) 
influence
influence <- gsub('影响力：','',influence) #去掉‘影响’两个字
influence <- gsub('分','',influence) #去掉'分'一个字
influence <- as.numeric(influence) #将字符串格式转换成数字格式
influence

WeiboURLs <- xpathSApply(doc, "//section", xmlGetAttr, "data-url") #提取微博链接地址。
WeiboURLs <- unlist(WeiboURLs)
WeiboURLs
#上面展示了如何使用unlist函数。下面只需要用一条语句即可提取所有的微博链接地址。
xpathSApply(doc, "//section[@class='list_info']", xmlGetAttr, "data-url") #提取微博链接地址。

shortbio <- xpathSApply(doc, "//dd[@class='bio']",xmlValue)  #提取微博简介。
shortbio

imgs <- xpathSApply(doc, '//img', xmlGetAttr, "src") #提取微博排行榜上各个微博的图片链接
imgs

WeiboData <- data.frame(Ranking = c(1:20), Names = names, Influence = influence, 
                        WeiboURLs = WeiboURLs, Icons = imgs, Shortbio = shortbio, 
                        stringsAsFactors=FALSE)
write.csv(WeiboData, file = 'Weibo.csv', row.names = FALSE)
