library(ggplot2)
library(dplyr) #for function "arrange"

circleFun <- function(center = c(0,0),radius = 1, npoints = 100){ #这是画圆圈的函数。
#各参数默认值：center = (0,0),原点为(0,0) 半径=1，需画的点数：100个点。
  tt <- seq(0,2*pi,length.out = npoints)   #从0到2*pi画npoints个点。
  xx <- center[1] + radius * cos(tt)  
  yy <- center[2] + radius * sin(tt)  #算npoints个点的横坐标和纵坐标。
  return(data.frame(x = xx, y = yy))  #返回一个数据框，名为x的列放横坐标，名为y的列放纵坐标。
}

#OrbitPoints <- function(c1= c(0,0), c2= c(0,0),r1=1, r2=rV/rE, Obt1=ObtE, Obt2=ObtV, npoints=80) {
#  t1 <- seq(from = 0, by = 2*pi/Obt1, length.out = npoints)
#  t2 <- seq(from = 0, by = 2*pi/Obt2, length.out = npoints)
#  ObtPts <- data.frame(x=numeric(0),y=numeric(0),grp = numeric(0))
#  for (i in (1:npoints)) {
#    pt1 = data.frame( x= c1[1] + r1 * cos(t1[i]), y = c1[2] + r1 * sin(t1[i]), grp = i)
#    pt2 = data.frame( x= c2[1] + r2 * cos(t2[i]), y = c2[2] + r2 * sin(t2[i]), grp = i)
#    ObtPts <- rbind(ObtPts,pt1,pt2)
#  }
#  return(ObtPts)
#}

#OrbitPoints函数用来计算两个天体在不同时间所在位置。
OrbitPoints <- function(c1= c(0,0), c2= c(0,0),r1=rE, r2=rV, Obt1=ObtE, Obt2=ObtV, npoints=80) {
  #ObtE：公转周期（天数），ObtV：公转周期（天数）
  t1 <- seq(from = 0, by = 2*pi/Obt1, length.out = npoints)
  #一个公转周期转2pi，那么每天转的角度是2*pi/Obt1。t1是Obt1各个日子在圆圈上的角度位置。
  t2 <- seq(from = 0, by = 2*pi/Obt2, length.out = npoints)
  #一个公转周期转2pi，那么每天转的角度是2*pi/Obt1。t2是Obt2各个日子在圆圈上的角度位置。
  x1 <- c1[1] + 1 * cos(t1) #计算Obt1每天在圆圈上的坐标位置，其中1是半径。
  y1 <- c1[2] + 1 * sin(t1)
  x2 <- c2[1] + r2/r1 * cos(t2) #计算Obt2每天在圆圈上的坐标位置，其中r2/r1是半径。
  y2 <- c2[2] + r2/r1 * sin(t2)
  ObtPts <- data.frame(x=x1,y=y1,grp =rep(1:npoints))
  #把Obt1每天在圆圈上的位置放入数据框ObtPts当中。grp代表group，代表第几天的位置。
  ObtPts <- rbind(ObtPts,data.frame(x=x2,y=y2,grp =rep(1:npoints)))
  #把Obt2每天在圆圈上的位置加入数据框ObtPts当中。
  ObtPts <- arrange(ObtPts, grp) #重新进行排序。确保同一天的2个点放在一起，以便后面画图。
  return(ObtPts)
}

rE = 92.96 #million miles. 地球距离太阳9296万英里。
ObtE = 365 #days - orbital period  地球绕太阳公转周期是365天。
rV = 67.24 #million miles. 金星距离太阳6724万英里。
ObtV = 225 #days - orbital period  金星绕太阳公转周期是225天。

Edat <- circleFun(c(0,0),1,npoints = 100) 
#地球公转半径设为1。先把公转圆画出来。
Vdat <- circleFun(c(0,0),rV/rE,npoints = 100) 
#另外一个星球公转半径设为rV/rE。先把公转圆画出来。
p <- ggplot(Edat) + geom_path(aes(x,y)) + coord_fixed(ratio = 1)
p + geom_path(aes(Vdat$x, Vdat$y))

#下面我们画地球和金星绕太阳转的图。金星英文名是Venus。
LinePoints <- OrbitPoints(npoints=1200)
ggplot(LinePoints)+geom_line(aes(x,y,group=grp))+ coord_fixed(ratio=1)

#下面我们画地球和水星绕太阳转的图。水星英文名是Mercury，我们把rV、ObtV换成水星的信息。
rV = 35.98 #million miles. 水星距离太阳3598万英里。
ObtV = 88 #days - orbital period 水星绕太阳公转周期是88天。
LinePoints <- OrbitPoints(r2 = 35.98, Obt2=88, npoints=365)
ggplot(LinePoints)+geom_line(aes(x,y,group=grp))+ coord_fixed(ratio=1)

#下面我们画地球和火星绕太阳转的图。火星英文名是Mars，我们把rV、ObtV换成火星的信息。
rV = 141.6 #million miles. 
ObtV = 687 #days - orbital period
LinePoints <- OrbitPoints(r2 = 141.6, Obt2=687, npoints=800)
ggplot(LinePoints)+geom_line(aes(x,y,group=grp))+ coord_fixed(ratio=1)

LinePoints <- OrbitPoints(c2=c(0.5,0.5),r2 = 141.6, Obt2=687, npoints=800)
ggplot(LinePoints)+geom_line(aes(x,y,group=grp))+ coord_fixed(ratio=1)
