A <- data.frame ()   #建立空数据框A
B <- data.frame(Name=character(0), Grade = numeric(0))  
#建立数据框B， 有2列其中一列名称是Name，另外一列的名称是Grade。
B <- rbind(B, data.frame(Name='Zach Zhou', Grade=90, stringsAsFactors=FALSE))
#在B中加入1行数据，使用到rbind函数（row bind）。
B
B <- cbind(B, data.frame(Sex='M', City='Shanghai'))
#在B中增加2列数据，使用到cbind函数（column bind)。
B
B <- rbind (B, data.frame(Name ='Eric Liu', Grade = 95, Sex = 'M', City='Beijing'))
B
class(B$Sex) 
class(B$Name)
class(B$City) #City列的数据类型为类别型数据（factor型数据），我们打算转换成字符型数据。
C <- cbind(B[,1:3],data.frame( City=as.character(B$City), stringsAsFactors=FALSE))
C
class(C$Sex)
class(C$Name)
class(C$City)
C[1,] #提取第一行数据
C[,1] #提取第一列数据
C[2,2] #提取第二行第二列数据

A1 <- c(1:3)
for (i in (1:length(A1))) { print(A1[i]+1)}