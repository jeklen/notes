library(ggplot2)
library(mapproj)
library(plyr)
library(RColorBrewer)

setwd("D:/BA/CHNMap")
CHNmapdata<-read.csv("CountyMapData.csv")
CountyIndex<-read.csv("CountyIndex.csv")

#�������Ǵ��㻭�Ϻ�������ͼ��
#����CountyIndex.csv��ProvIndex.csv���ű������Է��֣��Ϻ���ADCODE99��310000��
#���Ϻ��������е�ADCODE99������310��ͷ�ġ�
#����Ϻ�����������CountyMapData.csv�еĵ�ͼ����Ӧ����310��ͷ��ADCODE99��Ӧ��id�����������ݡ�
#�������ǰ��Ϻ����ص�ͼ���ݴ�CountyMapData.csv���ڳ�����

CountyCode <- CountyIndex$ADCODE99
class(CountyCode) #CountyCode��һ�������ͱ��������Ǵ�����ȡ����ǰ��λ��
CountyCodeHead <- substr(as.character(CountyCode),1,3) #�Ȱ�CountyCodeת�����ַ���Ȼ��ȡǰ3λ��
SH_idx <- which(CountyCodeHead=='310') #�ҵ�CountyCodeǰ3λ��310��CountyCode�е�λ�ã���CountyIndex�����е�λ��)��
SH_id <- CountyIndex[SH_idx,'CountyID']   #��ȡ����Щλ�ã��У�����Ӧ��id��ȡֵ��

#����Ҫ��CountyMapData.csv��idȡֵ��SH_id�е�������Ӧ�ĵ�ͼ���ݡ�
SH_Map_idx <- which(CHNmapdata$id %in% SH_id)
SH_Map_Data <- CHNmapdata[SH_Map_idx,]

mymap <- ggplot(SH_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")

#������ƺ���ʡ������ͼ��
#����CountyIndex.csv��ProvIndex.csv���ű������Է��֣����ϵ�ADCODE99��460000��
#�����ϸ������е�ADCODE99������460��ͷ�ġ�
HN_idx <- which(CountyCodeHead=='460') #�ҵ�CountyCodeǰ3λ��460��CountyCode�е�λ�ã���CountyIndex�����е�λ��)��
HN_id <- CountyIndex[HN_idx,'CountyID']   #��ȡ����Щλ�ã��У�����Ӧ��id��ȡֵ��
HN_Map_idx <- which(CHNmapdata$id %in% HN_id)
HN_Map_Data <- CHNmapdata[HN_Map_idx,]

mymap <- ggplot(HN_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")
#�����ͼ�Ѻ���ʡ����̫С�ˣ��������Ǵ���ɾ����ɳ����ɳ����ɳ����ɳ��ͼ����һ����������ɳȺ���ĺ���ʡ��
HN_idx <- which(CountyCodeHead=='460' & CountyCode!='460037' & CountyCode!='460038' & CountyCode!='460039')
HN_id <- CountyIndex[HN_idx,'CountyID'] 
HN_Map_idx <- which(CHNmapdata$id %in% HN_id)
HN_Map_Data <- CHNmapdata[HN_Map_idx,]

mymap <- ggplot(HN_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")
#write.csv(data.frame(HainanCounties = unique(CountyIndex[HN_idx, 'CountyNames'])),
#          'HaiNan.csv',row.names = FALSE)

#��������½�������ͼ���½��������ж�Ӧ��ADCODE99ǰ3λ������650, 652, 653��654��
XJ_idx <- which(CountyCodeHead=='650' | CountyCodeHead=='653' | CountyCodeHead=='652' | CountyCodeHead=='654') 
#�ҵ�CountyCodeǰ3λ��650����652����653����654��CountyCode�е�λ�ã���CountyIndex�����е�λ��)��
XJ_id <- CountyIndex[XJ_idx,'CountyID']   #��ȡ����Щλ�ã��У�����Ӧ��id��ȡֵ��
XJ_Map_idx <- which(CHNmapdata$id %in% XJ_id)
XJ_Map_Data <- CHNmapdata[XJ_Map_idx,]

mymap <- ggplot(XJ_Map_Data, aes(x=long, y=lat, group=id,fill=1))+geom_polygon(colour="black")+coord_map()
mymap + theme(legend.position="none")