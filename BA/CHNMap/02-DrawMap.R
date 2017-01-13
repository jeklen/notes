library(ggplot2)
library(mapproj)
library(plyr)
library(RColorBrewer)

setwd("D:/BA/CHNMap")
CHNPop <-read.csv("ProvData.csv") #在ProvNames工作表中填入数字（本例为人口密度）然后另存为ProvData.csv
CHNmapdata<-read.csv("ProvMapData.csv")
ProvIndex<-read.csv("ProvIndex.csv")

Pop_Index <-merge(CHNPop,ProvIndex,by="ProvNames")
Pop_Index <-arrange(Pop_Index,ProvID)
Pop_Index <-transform(Pop_Index, ProvNames=NULL) #Pop_Index中的ProvNames对我们没用了，可以把这列删掉。
#删掉ProvNames这一列也可以使用语句：Pop_Index <- Pop_Index[,-1] 
#不过这条语句不太直观你只知道删掉了第1列而不知道列名。

Pop_Map <- merge(CHNmapdata,Pop_Index,by.x="id",by.y="ProvID")
#合并Pop_Index和CHNmapdata，这样Mapdata中每个id就有Data列中的人口数据对应
Pop_Map <- arrange(Pop_Map,id,order) #经过合并操作之后数据被打乱，需要重新排序。
#先对id进行排序，然后对order进行排序

ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=PopData))+geom_polygon(colour="black")+coord_map()
#人口相差太大，自动上色看不出层次。需要手动进行调色。

Pop_Map$Pop_Scale <- cut(Pop_Map$PopData,breaks=c(0,50,150,250,300,400,600,1000,20000))
#见http://blog.revolutionanalytics.com/2009/11/choropleth-challenge-result.html
mymap <- ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=Pop_Scale))+geom_polygon(colour="black")+coord_map()
mymap
mymap+scale_fill_brewer(palette="Reds")
mymap+scale_fill_brewer(palette="Greens")

Pop_Map$Pop_Scale <- cut(Pop_Map$PopData,breaks=c(0,50,100,150,250,300,400,500,600,700,800,1000,20000))
#上面的分割方法只割出8类，使用更细致的分割方法可以割出10类。
#但是标准的调色盘只能调出8-9种颜色，所以需要手动设置调色盘。
mymap <- ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=Pop_Scale))+geom_polygon(colour="black")+coord_map()
ColorNum=length(unique(Pop_Map$Pop_Scale)) #计算看需要多少种颜色
mymap+scale_fill_manual(values=colorRampPalette(c("blue","green", "red"))(ColorNum))
mymap+scale_fill_manual(values=colorRampPalette(c("lightgoldenrod1", "red3"))(ColorNum))
#R 中的颜色见http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
mymap+scale_fill_manual(values=colorRampPalette(brewer.pal(9, "Greens"))(ColorNum))
#更详细资料见http://novyden.blogspot.jp/2013/09/how-to-expand-color-palette-with-ggplot.html
#更详细资料见http://www.inside-r.org/r-doc/grDevices/colorRampPalette

