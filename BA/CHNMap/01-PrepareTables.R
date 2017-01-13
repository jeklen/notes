library(rgeos)
library(sp)
library(maptools)
library(ggplot2)
library(rgdal)
setwd("D:/BA/CHNMap")
CHNmap <-readShapePoly("./maps/bou2/bou2_4p.shp") #读取shapefile文件
names(CHNmap)
summary(CHNmap)
plot(CHNmap, axes=TRUE) #画中国地图，不过地图投影不太理想
#下面的代码首先进行mercator投影然后绘图。
# 首先，我们需要指定x本身的投影信息，下面一行代码指定x对应的投影为原始的地理坐标（经纬度）：  
proj4string(CHNmap) <- CRS("+proj=longlat +ellps=WGS84")  
# 然后我们指定新的投影方式，并将x投影到其上：  
projNew <- CRS("+proj=merc +lat_0=45n +lon_0=100e") 
CHNProj <- spTransform(CHNmap, projNew)  
# 现在我们可以画出它了
plot(CHNProj)  

#下面展示另外一种方法画中国地图
CHNmapdata<-fortify(CHNmap)
head(CHNmapdata)

mymap = ggplot(data = CHNmapdata) + geom_polygon(aes(x = long, y = lat, group = id), 
colour = "black", fill = NA) +  theme_grey()
mymap + coord_map() #画中国地图，地图投影也是我们所需要的。coord_map函数参数默认值为"mercator"
#但是画出来的湖南省多了一条线，我们打算把这条多余的线去掉。
#经过分析，发现湖南省对应的id是277，而多出来的线是piece等于2的数据造成。
#所以我们应该把CHNmapdata中的id=277且piece=2的数据去掉。

idx <- which((CHNmapdata[,'piece']==2) & (CHNmapdata[,'id']==277))
CHNmapdata <- CHNmapdata[-idx,]
#删掉多余数据之后把CHNmapdata写入ProvMapData.csv
write.table(CHNmapdata,file="ProvMapData.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names=TRUE) #省级地图数据写入ProvMapData中以便将来使用。
mymap = ggplot(data = CHNmapdata) + geom_polygon(aes(x = long, y = lat, group = id), 
                                                 colour = "black", fill = NA) +  theme_grey()
mymap + coord_map() #湖南省多出来的线消失了。

mymap + coord_map("azequalarea")
#coord_map 其他参数参见http://docs.ggplot2.org/current/coord_map.html

plot(CHNmap, axes = TRUE)
#给不同省标上不同颜色
province <- sort(unique(CHNmap@data$NAME))
n <- length(province)
color <- rainbow(n)
for(i in 1:n){
  plot(subset(CHNmap, CHNmap@data$NAME==province[i]),
       add = TRUE, col=color[i], border="gray")}

CHNmap@data$NAME
provincenames <- as.character(unique(CHNmap@data$NAME)) #数据集中有NA，应该是澳门特别行政区。
provincenames[34]="澳门特别行政区" #将NA改成澳门特别行政区。
write.table(provincenames,file="ProvNames.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names = "ProvNames") #写入ProvNames文件中以便将来使用。

provincelist <- as.character(CHNmap@data$NAME)
print(provincelist)
provincelist[899]="澳门特别行政区"
provid <- c(0:(length(provincelist)-1))
provCode <- CHNmap$ADCODE99
provinceindex <- data.frame(provid,provCode,provincelist)
colnames(provinceindex) <- c("ProvID","ADCODE99","ProvNames")
write.table(provinceindex,file="ProvIndex.csv",sep = ",",eol = "\n",
            row.names = FALSE, col.names=TRUE) #这张表是将ProvNames中的数据与地图数据连接起来的。
#这张表显示了ProvData中的省份名称对应ProvMapData地图数据中的id的取值，以及省份名对应的ADCODE99。

