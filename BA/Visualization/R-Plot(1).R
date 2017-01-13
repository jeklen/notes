library(ggplot2)
#画线图
plot(pressure$temperature, pressure$pressure, type="l")
#画散点图
plot(pressure$temperature, pressure$pressure)
#散点图
qplot(carat, price, data = diamonds)
#Rescaling to Log Scale
qplot(log(carat), log(price), data = diamonds)
#Sampling 抽样
set.seed(1400)
dsmall <- diamonds[sample(nrow(diamonds), 100), ] #nrow 函数算出数据集中有多少组数据
qplot(carat, price, data = dsmall, colour = color)
qplot(carat, price, data = dsmall, shape = cut)
qplot(carat, price, data = dsmall, colour = cut)
qplot(carat, price, data = dsmall, geom = c("point", "smooth"))  #Geom: geometric object
#盒状图
qplot(color,price/carat, data = dsmall, geom = c("boxplot"))
#直方图
qplot(carat, data = diamonds, geom = "histogram")
qplot(carat, data = diamonds, geom = "histogram", bins=8)
qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.3, xlim = c(0,3))
#密度图
qplot(carat, data = diamonds, geom = "density")
#柱状图
qplot(color, data = diamonds, geom = "bar")
#柱状图，y轴画的不是计数而是克拉重量总和。
qplot(color, data = diamonds, geom = "bar", weight = carat)+scale_y_continuous("carat")
d0 <- which(diamonds[,"color"]=='D')
sum(diamonds[d0,"carat"])
d1 <- which(diamonds[,"color"]=='E')
sum(diamonds[d1,"carat"])
#曲线图
qplot(date, unemploy / pop, data = economics, geom = "line")
#Path Plot 路径图
qplot(unemploy / pop, uempmed, data = economics,geom = c("point", "path"))
#No Jittering
qplot(color, price / carat, data = diamonds)
#Jittering
qplot(color, price / carat, data = diamonds,geom="jitter")
qplot(color, price / carat, data = diamonds, geom = "jitter", alpha = I(1 / 8))
#Heat Maps 热度图
library(corrplot)
mcor <- cor(mtcars) #generate the numerical correlation matrix using cor
round(mcor, digits=2) # Print mcor and round to 2 digits
corrplot(mcor)
corrplot(mcor, method="shade",shade.col=NA,tl.col="black", tl.srt=45)
# shade.col=NA 去掉矩形中的斜线。tl.col="black"标注文字使用黑色。tl.srt=45 文字45倾斜。
# Matrix Plot 矩阵图
pairs(iris[,1:4])
cor(iris[,1:4])
# Parallel Coordinate Plot 平行坐标图
library(lattice)
parallelplot(~iris[1:4] | Species, iris)
#Plotting a Function 函数画图
chippy <- function(x) sin(cos(x)*exp(-x/2))
plot (chippy, -8, 7)
curve(chippy, -8, 7, n = 2000)
#Network Graph 网络图
library(igraph)
gd <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
plot(gd)
relations <- data.frame(from=c("Bob", "Cecil", "Cecil", "David", "David", "Esmeralda"),   
                        to=c("Alice", "Bob", "Alice", "Alice", "Bob", "Alice"),     
                        weight=c(4,5,5,2,1,1))
g <- graph.data.frame(relations, directed=TRUE)
plot(g, edge.width=E(g)$weight)
#Pie Chart 饼图
library(MASS) #for dataset
# Get a table of how many cases are in each level of fold
fold <- table(survey$Fold)
fold
pie(fold)
#绘制地图
library(maps)
east_asia <- map_data("world", region=c("Japan", "China", "North Korea","South Korea")) 
# Map region to fill color
ggplot(east_asia, aes(x=long, y=lat, group=group, fill=region))+geom_polygon(colour="black")+scale_fill_brewer(palette="Set1")
