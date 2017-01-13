#Scrapping data from Jenner.com after clicking search options
#Author: Zach Zhizhong ZHOU, zhouzhzh@sjtu.edu.cn
#Date: Oct/27/2016

library(RSelenium)
library(stringr)
setwd("D:/BA/GetData")

RSelenium::checkForServer()
RSelenium::startServer()
remDr <- remoteDriver$new()
#remDr <- remoteDriver(browserName = "phantomjs")
#通常我喜欢使用PhantomJS（你要确保phantomjs.exe在Path目录中）
#这是因为在PhantomJS当中你不需要上下卷屏幕确保要点击的对象在屏幕中。
#而使用Firefox、Chrome等浏览器则需要。不过mouseMoveToLocation函数经常不管用。
#为了便于展示，使用Firefox。
remDr$open()
#到这一步如果发生错误，请检查以下内容：Java是否已经安装？
#Java的位数是否和操作系统位数相同（比如都是64位）？
#下载Java https://www.java.com/zh_CN/download/manual.jsp
#Firefox低版本（我用的是Firefox 47）是否安装？是否装在默认路径？
#Windows的Path环境变量是否包括可以找到firefox.exe的路径？
#做完这些事情还出错的话，关掉R Studio重新启动。

MyURL <- "https://jenner.com/people"
remDr$navigate(MyURL)
remDr$maxWindowSize()

#remDr$getCurrentUrl() #Get Current URL

#下面的寻找网页element的地址是从Selenium IDE录制的地址找到的。
#网页的element的地址也可以通过自行分析得到。
webElem <- remDr$findElement(using = 'xpath', "//form[@id='new_search']/div[4]/div/h1")
#remDr$mouseMoveToLocation(webElement = webElem)
webElem$clickElement() #点击搜索Locations旁边的圆点。切换到Selenium自动打开的Firefox，
#可以看到Location旁边的下拉式菜单已经打开了。
webElem <- remDr$findElement(using = 'id', "search_offices_new_york")
webElem$clickElement() #选择New York。切换到Selenium自动打开的Firefox，
#可以看到New York已经被选择。
webElem <- remDr$findElement(using = 'xpath', "//form[@id='new_search']/div[4]/div/h1")
webElem$clickElement() #再次点击搜索Locations旁边的圆点收起下拉式菜单。

webElem <- remDr$findElement(using = 'xpath', "//form[@id='new_search']/div[6]/div/h1")
webElem$clickElement() #点击搜索ROLE旁边的圆点。切换到Selenium自动打开的Firefox，可以
      　　　　　　　　#看到ROLE旁边的下拉式菜单已经打开了。
webElem <- remDr$findElement(using = 'id', "search_roles_partner")
webElem$clickElement() #选择Partner。切换到Selenium自动打开的Firefox，可以
#看到Partner旁边已经打了勾。
webElem <- remDr$findElement(using = 'xpath', "//form[@id='new_search']/div[6]/div/h1")
webElem$clickElement() #再次点击搜索Role旁边的圆点收起下拉式菜单。

remDr$findElement(using = 'css selector', "input.button:nth-child(2)")
webElem$clickElement() #点击搜索键。

PageSource <- remDr$getPageSource() #提取出来的网页代码是一个list列表
length(PageSource) #提取出的是一个网页的源代码，list长度为1。
doc <- htmlParse(PageSource[[1]]) 

A1 <- str_trim(xpathSApply(doc, "//div[@class='overlay']", xmlValue)) 
A1 #提取人名，不过发现人名在\n之前。
str_locate(A1[1],'\n') #定位看\n在哪里。
str_sub(A1[1],1,15) #提取\n之前的名字。
str_locate(A1[1],'\n')[1,1]-1
str_sub(A1[1],1,str_locate(A1[1],'\n')[1,1]-1)

#下面写一个函数提取名字
GetName <- function (x) {
  return(str_sub(x,1,str_locate(x,'\n')[1,1]-1))
}

A2 <- sapply(A1,GetName)
names(A2) <- NULL
A2

remDr$close()
