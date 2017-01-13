library(ggplot2)
library(mapproj)
library(plyr)
library(RColorBrewer)

setwd("D:/BA/CHNMap")
CHNPop <-read.csv("ProvData.csv") #��ProvNames���������������֣�����Ϊ�˿��ܶȣ�Ȼ������ΪProvData.csv
CHNmapdata<-read.csv("ProvMapData.csv")
ProvIndex<-read.csv("ProvIndex.csv")

Pop_Index <-merge(CHNPop,ProvIndex,by="ProvNames")
Pop_Index <-arrange(Pop_Index,ProvID)
Pop_Index <-transform(Pop_Index, ProvNames=NULL) #Pop_Index�е�ProvNames������û���ˣ����԰�����ɾ����
#ɾ��ProvNames��һ��Ҳ����ʹ����䣺Pop_Index <- Pop_Index[,-1] 
#����������䲻ֱ̫����ֻ֪��ɾ���˵�1�ж���֪��������

Pop_Map <- merge(CHNmapdata,Pop_Index,by.x="id",by.y="ProvID")
#�ϲ�Pop_Index��CHNmapdata������Mapdata��ÿ��id����Data���е��˿����ݶ�Ӧ
Pop_Map <- arrange(Pop_Map,id,order) #�����ϲ�����֮�����ݱ����ң���Ҫ��������
#�ȶ�id��������Ȼ���order��������

ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=PopData))+geom_polygon(colour="black")+coord_map()
#�˿����̫���Զ���ɫ��������Ρ���Ҫ�ֶ����е�ɫ��

Pop_Map$Pop_Scale <- cut(Pop_Map$PopData,breaks=c(0,50,150,250,300,400,600,1000,20000))
#��http://blog.revolutionanalytics.com/2009/11/choropleth-challenge-result.html
mymap <- ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=Pop_Scale))+geom_polygon(colour="black")+coord_map()
mymap
mymap+scale_fill_brewer(palette="Reds")
mymap+scale_fill_brewer(palette="Greens")

Pop_Map$Pop_Scale <- cut(Pop_Map$PopData,breaks=c(0,50,100,150,250,300,400,500,600,700,800,1000,20000))
#����ķָ��ֻ���8�࣬ʹ�ø�ϸ�µķָ�����Ը��10�ࡣ
#���Ǳ�׼�ĵ�ɫ��ֻ�ܵ���8-9����ɫ��������Ҫ�ֶ����õ�ɫ�̡�
mymap <- ggplot(Pop_Map, aes(x=long, y=lat, group=id, fill=Pop_Scale))+geom_polygon(colour="black")+coord_map()
ColorNum=length(unique(Pop_Map$Pop_Scale)) #���㿴��Ҫ��������ɫ
mymap+scale_fill_manual(values=colorRampPalette(c("blue","green", "red"))(ColorNum))
mymap+scale_fill_manual(values=colorRampPalette(c("lightgoldenrod1", "red3"))(ColorNum))
#R �е���ɫ��http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
mymap+scale_fill_manual(values=colorRampPalette(brewer.pal(9, "Greens"))(ColorNum))
#����ϸ���ϼ�http://novyden.blogspot.jp/2013/09/how-to-expand-color-palette-with-ggplot.html
#����ϸ���ϼ�http://www.inside-r.org/r-doc/grDevices/colorRampPalette
