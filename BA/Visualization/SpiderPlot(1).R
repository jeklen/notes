library(fmsb)
MyData <- data.frame(Name = c('Alice','Bob','Chris'), 
                     Math=c(80,90,95),
                     Chinese=c(95,85,90),
                     Physics = c(75,80,95),
                     Chemistry= c(75,80,95), stringsAsFactors=FALSE)
MinScore =60; MaxScore=100;
MaxMin <- data.frame(Math=c(MaxScore,MinScore), Chinese=c(MaxScore,MinScore),
                     Physics=c(MaxScore,MinScore),Chemistry=c(MaxScore,MinScore))
#MaxMin <- data.frame(Math=c(100,0), Chinese=c(100,0),Physics=c(100,0),Chemistry=c(100,0))
#define the max and min value for each column.

Alice <- MyData[MyData$Name=='Alice',] #Alice's scores
Scores <- Alice[,2:5] #Prepare to draw a spider plot of Alice's scores
SpiderData <- rbind(MaxMin, Scores)

radarchart(SpiderData, axistype=0, seg=5,centerzero = TRUE)
#Draw a spider plot of Alice's scores

AliceChris <- MyData[MyData$Name %in% c('Alice','Chris'),] #Alice & Chris's scores
#AliceChris <- MyData[c(1,3),]
Scores <- AliceChris[,2:5]
SpiderData <- rbind(MaxMin, Scores)

radarchart(SpiderData, axistype=0, seg=5,centerzero = TRUE)
#Alice & Chris's scores in one spider plot

MyColor <- function (Myclr, ClrTransparency) {
  TT <- col2rgb(Myclr)/255;
  return(rgb(TT[1],TT[2],TT[3],ClrTransparency))
} 
#define a function to caculate RGB Hex constants for a specific color with a specific transparency
MyColor("lightyellow",0.2);

colors_border=c( "blue", "green2")
colors_in=c( MyColor("red",0.3) , MyColor("blue",0.3) )
#colors_in=c( c(col2rgb("lightyellow")/255,0.2) , c(0.1,0.3,0.4,0.6) )
radarchart( SpiderData  , axistype=0 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=3 , plty=1,
            #custom the grid
            cglcol="grey", cglty=3, axislabcol="grey", cglwd=0.9,
            #custom labels
            vlcex=0.9)

rownames(SpiderData) <- c('Max','Min','Alice','Chris')
legend(x=0.8, y=0.8, legend = rownames(SpiderData[-c(1,2),]), 
       bty = "n", pch=16 , col=colors_in , text.col = "black", cex=1, pt.cex=3)
#pch：Alice，Chris旁边的图形是什么形状，取值16为圆圈。
#pt.cex：Alice, Chris旁边的圆圈有多大
#cex：Alice, Chris文字有多大

Scores <- MyData[,2:5]
SpiderData <- rbind(MaxMin, Scores)
rownames(SpiderData) <- c('Max','Min', MyData$Name)

colors_border=c( "blue", "green2", "tan2")
colors_in=c( MyColor("red",0.3) , MyColor("blue",0.3) , MyColor("cyan3",0.3))
radarchart( SpiderData  , axistype=0 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=3 , plty=1,
            #custom the grid
            cglcol="grey", cglty=3, axislabcol="grey", cglwd=0.9,
            #custom labels
            vlcex=0.9)
legend(x=0.8, y=0.8, legend = rownames(SpiderData[-c(1,2),]), 
       bty = "n", pch=16 , col=colors_in , text.col = "black", cex=1, pt.cex=3)