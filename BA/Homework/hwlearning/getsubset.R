# 声明了一个vector（向量）
x <- c(2.1, 4.2, 3.3, 5.4)

#正整数索引
x[c(3,1)]
x[order(x)]
x[c(1,1)]

#负整数索引
x[-c(3,1)]
#正负索引不能混合使用
x[c(-1,2)]

#逻辑向量索引
x[c(TRUE, TRUE, FALSE, FALSE)]
x[x>3]
x[c(TRUE, TRUE, NA, FALSE)]

#空索引返回原向量
x[]
