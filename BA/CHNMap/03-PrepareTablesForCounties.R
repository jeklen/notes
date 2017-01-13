library(maptools)
library(ggplot2)
setwd("D:/BA/CHNMap")
CHNmap <-readShapePoly("./maps/bou4/BOUNT_poly.shp") #读取shapefile文件
names(CHNmap)
CHNmapdata<-fortify(CHNmap)
write.table(CHNmapdata,file="CountyMapData.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names=TRUE) #县市地图数据写入CountyMapData中以便将来使用。

CHNmap@data$NAME
countynames <- as.character(unique(CHNmap@data$NAME))
write.table(countynames,file="CountyNames.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names = "CountyNames") #写入CountyNames文件中以便将来使用。

countylist <- as.character(CHNmap@data$NAME)
countyid <- c(0:(length(countylist)-1))
countyCode <- CHNmap$ADCODE99
countyindex <- data.frame(countyid,countyCode,countylist)
colnames(countyindex) <- c("CountyID","ADCODE99","CountyNames")
write.table(countyindex,file="CountyIndex.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names=TRUE) #这张表是将CountyNames中的数据与地图数据连接起来的。
#这张表显示了CountyData中的县市名称对应CountyMapData地图数据中的id的取值，以及县市对应的ADCODE99。