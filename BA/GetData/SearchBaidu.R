#Scrapping data from Baidu.com after searching SJTU and navigating
#Author: Zach Zhizhong ZHOU, zhouzhzh@sjtu.edu.cn
#Date: Oct/27/2016

library(RSelenium)
library(stringr)
setwd("D:/BA/GetData")

RSelenium::checkForServer()
RSelenium::startServer()
remDr <- remoteDriver$new()
#remDr <- remoteDriver(browserName = "chrome")
#也可以使用Chrome浏览器，但是需要Chrome Webdriver的支持。
#先下载并安装Chrome。
#将课程文件夹/Software/Selenium WebDrivers中的所有文件拷贝到本地硬盘
#（我拷贝到C:\Applications\Analytics\Selenium WebDrivers），
#将上面的目录加入Path环境变量中。
#如果做了上面的事情还出错，那么应该关掉并重启R Studio。
remDr$open()

MyURL <- "https://www.baidu.com/"
remDr$navigate(MyURL)
#remDr$maxWindowSize()
#我们打算做的事情是打开百度，搜索SJTU，获取第一个搜索页面的所有链接和链接描述。
#然后点击第二个搜索页面，获得第二个搜索页面的所有链接和链接描述。
#下面是使用Firefox+Selenium IDE录制下来的输入动作和鼠标操作。
#driver.find_element_by_id("kw").click()
#driver.find_element_by_id("kw").send_keys("SJTU")
#driver.find_element_by_id("su").click()
#把这些代码转成R语言代码即可。你也可以通过分析网页元素来找到需要进行点击和填表的元素地址。

webElem <- remDr$findElement(using = 'id', "kw")
webElem$clickElement()
webElem$sendKeysToElement(list("SJTU")) #搜索框中输入SJTU
webElem <- remDr$findElement(using = 'id', "su")
webElem$clickElement()

PageSource <- remDr$getPageSource()
length(PageSource) #提取出的是一个网页的源代码，list长度为1。
doc <- htmlParse(PageSource[[1]]) 

FirstURL <- xpathSApply(doc, "//a[@class='favurl']", xmlGetAttr, "href")
#使用360浏览器分析页面元素，可以发现第一个搜索结果链接地址
#放在<a class='favurl',href='  '>...</a>中的herf。
remDr$navigate(FirstURL) #打开第一个搜索结果的链接。连到上海交通大学主页。

remDr$goBack() #回到上个页面，也就是百度搜索结果页面。
remDr$goForward() #向前
remDr$goBack() #向后 回到百度搜索结果页面。

#分析百度搜索结果的链接，发现搜索结果链接放在<a href='  '>...</a>中的href中。
#而且<a>...</a>这边标签上一层是<h3 class='t'>...</h3>，
#或者是<h3 class='t c-gap-bottom-small'>...</h3>
A1 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlGetAttr, "href")
A1 #得到百度搜索SJTU第一个页面的所有搜索结果的链接地址。
A2 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlValue)
A2 #得到百度搜索SJTU第一个页面的所有搜索结果的网页描述。

#分析网页元素，发现搜索结果第n页的链接地址放在<a href=' '>...</a>中的href，
#而且上一层是<div id='page'>...</div>
L1 <- xpathSApply(doc, "//div[@id='page']/a", xmlGetAttr, "href")
Search02 <- paste0('https://www.baidu.com',L1[1]) 
Search02 #这是搜索结果的第2页的链接地址。

remDr$navigate(Search02)
PageSource <- remDr$getPageSource()
doc <- htmlParse(PageSource[[1]]) 

B1 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlGetAttr, "href")
B1 #得到百度搜索SJTU第二个页面的所有搜索结果的链接地址。
B2 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlValue)
B2 #得到百度搜索SJTU第二个页面的所有搜索结果的网页描述。

remDr$close()
