library(treemap)
setwd("D:/BA/Visualization")

data(GNI2010)
treemap(GNI2010,index=c("continent", "iso3"),vSize="population",vColor="GNI",type="value")

data <- read.csv('AppleFinance.csv',T)
treemap(data, index=c("item", "subitem"), vSize="time1206", vColor="time1106", 
        type="comp", title='苹果公司财务报表可视化', palette='RdBu')
