library(XML)
library(stringr)
library(RCurl)

setwd('D:/BA/GetData')
doc <- htmlParse('ITOrange_HTML.txt')

xpathSApply(doc, "//span",xmlValue)

getNodeSet(doc, "//table")
TableRows  <- getNodeSet(doc, "/html/body/div[2]/div[2]/div[2]/div[3]/div/div[1]/ul[2]/li")
TableRows

xpathSApply(TableRows[[1]], './/span', xmlValue)
xpathSApply(TableRows[[1]], ".//span[@class='c-gray']", xmlValue)
xpathSApply(TableRows[[1]], './/a', xmlValue)
xpathSApply(TableRows[[1]], ".//i[@class='cell fina']", xmlValue)

xpathSApply(TableRows[[2]], './/span', xmlValue)
xpathSApply(TableRows[[2]], ".//span[@class='c-gray']", xmlValue)
xpathSApply(TableRows[[2]], './/a', xmlValue)

xpathSApply(TableRows[[7]], './/span', xmlValue)
xpathSApply(TableRows[[7]], ".//span[@class='c-gray']", xmlValue)
xpathSApply(TableRows[[7]], './/a', xmlValue)

xpathSApply(TableRows[[10]], './/span', xmlValue)
xpathSApply(TableRows[[10]], ".//span[@class='c-gray']", xmlValue)
xpathSApply(TableRows[[10]], './/a', xmlValue)

Investments = data.frame(Date=character(0),  FirmName=character(0),
                        Industry=character(0), Location=character(0),
                        Round=character(0), Amount=character(0),
                        InvestorswithURL=character(0), InvestorsNoURL=character(0))

for ( i in (1:length(TableRows))) {
  RowItems1 <- xpathSApply(TableRows[[i]], './/span', xmlValue)
  RowItems2 <- xpathSApply(TableRows[[i]], ".//span[@class='c-gray']", xmlValue)
  RowItems3 <- xpathSApply(TableRows[[i]], './/a', xmlValue)
  RowItems4 <- xpathSApply(TableRows[[i]], ".//i[@class='cell fina']", xmlValue)
  
  Investors1 <- '';
  if (length(RowItems3)>5) Investors1 <- RowItems3[6:(length(RowItems3))]
  Investors1 <- paste0 (Investors1,collapse=',')
  #上面的这些投资者都是有URL链接的。
  Investors2 <- RowItems2;
  #上面的这些投资者都是没有URL链接的。
  Investors2 <- paste0 (Investors2,collapse=',')
  
  Investment=data.frame(Date=RowItems1[1],FirmName=RowItems1[3],
                        Industry=RowItems3[3], Location=RowItems3[4],
                        Round=RowItems1[6],Amount=str_trim(RowItems4[1]),
                        InvestorswithURL = Investors1, InvestorsNoURL = Investors2  )
  Investments <- rbind(Investments, Investment)
  }
fix(Investments)
