library(fmsb)
MyData <- data.frame(Name = c('ZhugeLiang','ZhangFei','ZhaoYun'), 
                     Attack=c(5,100,90),
                     Defense=c(5,80,95),
                     Witchcraft = c(100,0,60),
                     Healing= c(100,0,80), 
                     Strategy=c(100,30,80),stringsAsFactors=FALSE)
MinScore =0; MaxScore=100;





MyColor <- function (Myclr, ClrTransparency) {
  TT <- col2rgb(Myclr)/255;
  return(rgb(TT[1],TT[2],TT[3],ClrTransparency))
} 
#define a function to caculate RGB Hex constants for a specific color with a specific transparency
MyColor("lightyellow",0.2);

colors_border=c( "blue", "green3", "red3")
colors_in=c( MyColor("green2",0.3) , MyColor("red4",0.3) , MyColor("orange3",0.3))