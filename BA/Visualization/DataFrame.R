#Data Frame的基本操作

Celebrities <- data.frame(Name = c('葛优','范冰冰','王宝强','郭敬明'), 
                          Sex = c('M','F','M','M'), Height = c(175,163 , 165, 147))

#在数据框最后一行之下继续增加一行数据
ZHAO_LY <- data.frame(Name='赵丽颖',Sex='F',Height=165)
Celebrities <- rbind(Celebrities,ZHAO_LY)
Celebrities

#在数据框插入新的一列Birthday
Birth <- as.Date(c('1957/04/19','1981/09/16','1984/05/29','1983/06/06','1987/10/16'))
Celebrities <- cbind(Celebrities,Birthday = Birth)
Celebrities

#访问第3行数据
Celebrities[3,]

#访问第3和第5行数据
Celebrities[c(3,5),]

#访问第1行到第4行的数据
Celebrities[1:4,]

#访问除了第1行的数据
Celebrities[-1,]

#访问除了第1，3行的数据
Celebrities[-c(1,3),]

#访问某一列数据（例如列出所有明星的名字和身高）
Celebrities[,c('Name','Height')]
Celebrities[,c(1,3)] #如果知道名字是第1列，身高是第3列

#查找明星为葛优的资料
Celebrities[Celebrities$Name=='葛优',]

#查找明星为葛优以及范冰冰的资料
Celebrities[Celebrities$Name %in% c('葛优','范冰冰'),]

#查找郭敬明的身高
Celebrities[Celebrities$Name=='郭敬明', 'Height']

#上面的查找，列名前面都要跟着数据框名字，如果不想这么麻烦，可以使用attach函数。
attach(Celebrities)
Celebrities[Name=='郭敬明', 'Height']
#取消attach
detach(Celebrities)

class(Celebrities) #Celebrities是一个data.frame
sapply(Celebrities,class) #看Celebrities里面每一列是什么数据类型。
#发现名字是类别型变量（factor型变量）。这不是我们所期望的。
#我们希望名字应该是字符型变量。
Celebrities$Name <- as.character(Celebrities$Name)
#将Name字段的内容转换成字符型变量。
sapply(Celebrities,class)

nrow(Celebrities) #看数据框有多少行。
ncol(Celebrities) #看数据框有多少列。
dim(Celebrities) #看数据框行列。
colnames(Celebrities) #看数据框列名。

#把列名Birthday改成Birthdate
colnames(Celebrities) <- c('Name','Sex','Height','Birthdate')
colnames(Celebrities)
Celebrities

#我们打算把列名Birthdate改回Birthday，如果数据框的列非常多，
#那么查找Birthdate这列在第几列就非常不方便。还要输入无需改名的其他列的信息。
CelColNames <- colnames(Celebrities)
ColN_to_change <- which(CelColNames=='Birthdate') #在第4列
ColN_to_change
CelColNames[ColN_to_change]='Birthday' #CelColNames[4]='Birthday'
colnames(Celebrities) <- CelColNames
colnames(Celebrities)

#行名
row.names(Celebrities)
row.names(Celebrities) <- c('笑星','女星','笑星','作家','女星') #不允许有重复的行名
row.names(Celebrities) <- c('笑星1','女星1','笑星2','作家1','女星2')
Celebrities
#修改行名
attach(Celebrities)
RowN_to_change <- which(Name=='范冰冰')
CelRowNames <- row.names(Celebrities)
CelRowNames[RowN_to_change] = '美女1'
row.names(Celebrities) <- CelRowNames

CelAge <- as.integer(format(Sys.Date(),"%Y"))-as.integer(format.Date(Birthday,"%Y"))
Celebrities <- data.frame(Celebrities,Age=CelAge)
Celebrities
detach(Celebrities)

#找到身高大于160，年龄大于30的明星
Celebrities[(Celebrities$Height>160 & Celebrities$Age>30),]

#找到身高大于160，年龄大于30的女明星
Celebrities[(Celebrities$Height>160 & Celebrities$Age>30 & Celebrities$Sex=='F'),]

attach(Celebrities)
Celebrities[(Height>160 & Age>30 ),]
Celebrities[(Height>160 & Age>30 & Sex=='F'),]

Celebrities[order(Age),] #根据年龄从小到大排序
Celebrities[order(-Age),] #根据年龄从大到小排序

detach(Celebrities)

#合并两个data.frame。
Cel_Prov = data.frame(Cel=c('葛优','范冰冰','王宝强','郭敬明','赵丽颖'),
                      Prov = c('北京','山东','河北','上海','河北'),stringsAsFactors=FALSE)
merge(Celebrities, Cel_Prov, by.x="Name", by.y="Cel")
