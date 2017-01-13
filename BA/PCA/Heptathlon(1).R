require("HSAUR")
data("heptathlon", package = "HSAUR")
summary(heptathlon)
heptathlon$hurdles <- max(heptathlon$hurdles) - heptathlon$hurdles
heptathlon$run200m <- max(heptathlon$run200m) - heptathlon$run200m
heptathlon$run800m <- max(heptathlon$run800m) - heptathlon$run800m
score <- which(colnames(heptathlon) == "score")
round(cor(heptathlon[, -score]), 2)
plot(heptathlon[, -score])
heptathlon_pca <- prcomp(heptathlon[, -score], scale = TRUE)
print(heptathlon_pca)
summary(heptathlon_pca)
a1 <- heptathlon_pca$rotation[, 1] #The linear combination for the first principal component
print(a1)