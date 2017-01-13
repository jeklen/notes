library(MASS)
library(ggplot2)

#Combine training dataset and testing dataset
data(Pima.tr)
data(Pima.te)
Pima <- rbind (Pima.tr, Pima.te)
#"glu" (plasma glucose concentration)
#"type"='Yes': presence of diabetes
#"type"='No': absence of diabetes
glu  <- Pima[, 'glu']
qplot(glu, geom = "density")
#Density plot of glu for all data
d0 <- which(Pima[, 'type'] == 'No')
qplot(glu[d0], geom = "density")
#Density plot of glu for those who are not suffered from diabetes.
d1 <- which(Pima[, 'type'] == 'Yes')
qplot(glu[d1], geom = "density")
#Density plot of glu for those who are suffered from diabetes.

ggplot(Pima, aes(x=glu,colour=type)) +  geom_density() +  ggtitle("Density Plot")

G1 <- Pima[,c("glu","type")]
G2 <- data.frame(glu=Pima[,"glu"],type="All")
GAll <- rbind(G1,G2)
ggplot(GAll, aes(x=glu,colour=type)) +  geom_density() +  ggtitle("Density Plot")
