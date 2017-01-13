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
#Ҳ����ʹ��Chrome�������������ҪChrome Webdriver��֧�֡�
#�����ز���װChrome��
#���γ��ļ���/Software/Selenium WebDrivers�е������ļ�����������Ӳ��
#���ҿ�����C:\Applications\Analytics\Selenium WebDrivers����
#�������Ŀ¼����Path���������С�
#���������������黹��������ôӦ�ùص�������R Studio��
remDr$open()

MyURL <- "https://www.baidu.com/"
remDr$navigate(MyURL)
#remDr$maxWindowSize()
#���Ǵ������������Ǵ򿪰ٶȣ�����SJTU����ȡ��һ������ҳ����������Ӻ�����������
#Ȼ�����ڶ�������ҳ�棬��õڶ�������ҳ����������Ӻ�����������
#������ʹ��Firefox+Selenium IDE¼�����������붯������������
#driver.find_element_by_id("kw").click()
#driver.find_element_by_id("kw").send_keys("SJTU")
#driver.find_element_by_id("su").click()
#����Щ����ת��R���Դ��뼴�ɡ���Ҳ����ͨ��������ҳԪ�����ҵ���Ҫ���е���������Ԫ�ص�ַ��

webElem <- remDr$findElement(using = 'id', "kw")
webElem$clickElement()
webElem$sendKeysToElement(list("SJTU")) #������������SJTU
webElem <- remDr$findElement(using = 'id', "su")
webElem$clickElement()

PageSource <- remDr$getPageSource()
length(PageSource) #��ȡ������һ����ҳ��Դ���룬list����Ϊ1��
doc <- htmlParse(PageSource[[1]]) 

FirstURL <- xpathSApply(doc, "//a[@class='favurl']", xmlGetAttr, "href")
#ʹ��360���������ҳ��Ԫ�أ����Է��ֵ�һ������������ӵ�ַ
#����<a class='favurl',href='  '>...</a>�е�herf��
remDr$navigate(FirstURL) #�򿪵�һ��������������ӡ������Ϻ���ͨ��ѧ��ҳ��

remDr$goBack() #�ص��ϸ�ҳ�棬Ҳ���ǰٶ��������ҳ�档
remDr$goForward() #��ǰ
remDr$goBack() #��� �ص��ٶ��������ҳ�档

#�����ٶ�������������ӣ���������������ӷ���<a href='  '>...</a>�е�href�С�
#����<a>...</a>��߱�ǩ��һ����<h3 class='t'>...</h3>��
#������<h3 class='t c-gap-bottom-small'>...</h3>
A1 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlGetAttr, "href")
A1 #�õ��ٶ�����SJTU��һ��ҳ�������������������ӵ�ַ��
A2 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlValue)
A2 #�õ��ٶ�����SJTU��һ��ҳ������������������ҳ������

#������ҳԪ�أ��������������nҳ�����ӵ�ַ����<a href=' '>...</a>�е�href��
#������һ����<div id='page'>...</div>
L1 <- xpathSApply(doc, "//div[@id='page']/a", xmlGetAttr, "href")
Search02 <- paste0('https://www.baidu.com',L1[1]) 
Search02 #������������ĵ�2ҳ�����ӵ�ַ��

remDr$navigate(Search02)
PageSource <- remDr$getPageSource()
doc <- htmlParse(PageSource[[1]]) 

B1 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlGetAttr, "href")
B1 #�õ��ٶ�����SJTU�ڶ���ҳ�������������������ӵ�ַ��
B2 <- xpathSApply(doc, "//h3[@class='t' or @class='t c-gap-bottom-small']/a", xmlValue)
B2 #�õ��ٶ�����SJTU�ڶ���ҳ������������������ҳ������

remDr$close()