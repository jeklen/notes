library(ggplot2)
A <-data.frame( x= c(0,1,0,2,1,2),y=c(0,1,0,1,1,1),grp = c(1,1,2,2,3,3))
A
ggplot(A)+geom_line(aes(x,y,group=grp))

A <-data.frame( x= c(0,1,2),y=c(0,1,1))
ggplot(A)+geom_polygon(aes(x,y))
ggplot(A)+geom_polygon(aes(x,y),fill="green")  

p <- ggplot(A)+geom_polygon(aes(x,y),fill="green")
B <-data.frame( x= c(0,1,0),y=c(0,1,1))
ggplot(B)+geom_polygon(aes(x,y),fill="red")
p+geom_polygon(aes(B$x,B$y),fill="red")  #图形可以叠加

A <-data.frame( x= c(0,1,2,0,1,0),y=c(0,1,1,0,1,1),grp=c(1,1,1,2,2,2))
ggplot(A)+geom_polygon(aes(x,y,group=grp))
ggplot(A)+geom_polygon(aes(x,y,group=grp,fill=grp))
A$grp <- as.factor(A$grp)
ggplot(A)+geom_polygon(aes(x,y,group=grp,fill=grp))
