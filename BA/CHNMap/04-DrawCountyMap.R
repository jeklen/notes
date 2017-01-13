library(ggplot2)
library(mapproj)
library(plyr)
library(RColorBrewer)

setwd("D:/BA/CHNMap")
CHNmapdata<-read.csv("CountyMapData.csv")
CountyIndex<-read.csv("CountyIndex.csv")

#下面我们打算画上海的县市图。
#分析CountyIndex.csv和ProvIndex.csv两张表，可以发现，上海的ADCODE99是310000，
#而上海各个县市的ADCODE99都是以310开头的。
#因此上海各个县市在CountyMapData.csv中的地图数据应该是310开头的ADCODE99对应的id所包含的数据。
#下面我们把上海市县地图数据从CountyMapData.csv中挖出来。

CountyCode <- CountyIndex$ADCODE99
class(CountyCode) #CountyCode是一个整数型变量，我们打算提取它的前三位。
CountyCodeHead <- substr(as.character(CountyCode),1,3) #先把CountyCode转换成字符串然后取前3位。
SH_idx <- which(CountyCodeHead=='310') #找到CountyCode前3位是310在CountyCode中的位置（即CountyIndex表中行的位置)。
SH_id <- CountyIndex[SH_idx,'CountyID']   #提取出这些位置（行）所对应的id的取值。

#下面要找CountyMapData.csv的id取值在SH_id中的行所对应的地图数据。
SH_Map_idx <- which(CHNmapdata$id %in% SH_id)
SH_Map_Data <- CHNmapdata[SH_Map_idx,]

mymap <- ggplot(SH_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")

#下面绘制海南省各县市图。
#分析CountyIndex.csv和ProvIndex.csv两张表，可以发现，海南的ADCODE99是460000，
#而海南各个县市的ADCODE99都是以460开头的。
HN_idx <- which(CountyCodeHead=='460') #找到CountyCode前3位是460在CountyCode中的位置（即CountyIndex表中行的位置)。
HN_id <- CountyIndex[HN_idx,'CountyID']   #提取出这些位置（行）所对应的id的取值。
HN_Map_idx <- which(CHNmapdata$id %in% HN_id)
HN_Map_Data <- CHNmapdata[HN_Map_idx,]

mymap <- ggplot(HN_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")
#上面的图把海南省画得太小了，下面我们打算删掉西沙、东沙、中沙和南沙的图，画一个不包括南沙群岛的海南省。
HN_idx <- which(CountyCodeHead=='460' & CountyCode!='460037' & CountyCode!='460038' & CountyCode!='460039')
HN_id <- CountyIndex[HN_idx,'CountyID'] 
HN_Map_idx <- which(CHNmapdata$id %in% HN_id)
HN_Map_Data <- CHNmapdata[HN_Map_idx,]

mymap <- ggplot(HN_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")
#write.csv(data.frame(HainanCounties = unique(CountyIndex[HN_idx, 'CountyNames'])),
#          'HaiNan.csv',row.names = FALSE)

#下面绘制新疆各县市图。新疆各个县市对应的ADCODE99前3位可能是650, 652, 653，654。
XJ_idx <- which(CountyCodeHead=='650' | CountyCodeHead=='653' | CountyCodeHead=='652' | CountyCodeHead=='654') 
#找到CountyCode前3位是650或者652或者653或者654在CountyCode中的位置（即CountyIndex表中行的位置)。
XJ_id <- CountyIndex[XJ_idx,'CountyID']   #提取出这些位置（行）所对应的id的取值。
XJ_Map_idx <- which(CHNmapdata$id %in% XJ_id)
XJ_Map_Data <- CHNmapdata[XJ_Map_idx,]

mymap <- ggplot(XJ_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")
