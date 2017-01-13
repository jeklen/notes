# Define Global LongTxt

CorpusPath <- 'D:/BA/TextMining/Corpus/CNSample' #中文文本路径
setwd(CorpusPath)
FolderList <- read.table('ClassList.txt',header=FALSE, stringsAsFactors = FALSE)
names(FolderList) <- c('folder','type')
fix(FolderList) #我们需要在10个文件夹里面提取文本文件。
#所以生成10个文件夹的目录地址放入数字框FolderList当中。type表示该文件夹的文本文件的主题类型。

#用记事本打开C:\BA\TextMining\Corpus\CNSample目录中的Example1.txt，可看到文字被换行符分隔成多行。
#下面展示如何将一个文本文件当中多个行中的所有文字转化成一长串字符。
Lines <- readLines('Example1.txt',encoding = "UTF-8") #注意：文本文件的编码是UTF-8
#文本文件的默认编码是ANSI，如果不是这个编码，则需要明确告诉readLines函数文本文件的编码是什么。
#使用记事本打开文本文件，选择右上角的文件，再选择另存为，在弹窗下面你会看到文本文件的编码。
Lines
LongTxt <- ''
sapply(Lines, function(line) {LongTxt <<- paste0(LongTxt,line)}) #注意<<-表示Longtxt是全局变量
#函数当中的变量默认是局部变量。把<<-改成<-（此时LongTxt变成局部变量），
#然后再从LongTxt <-''处重新运行，观察结果有何改变。
#全局变量不推荐使用，因为一旦程序需要升级，加入的新变量如果和现有的全局变量发生重名，那么
#整个程序就会出错。这就是为何在这个R Script的第一行声明 LongTxt是一个全局变量，防止将来出错。
LongTxt
#注意：上面处理的是中文文本。如果处理英文文本，那么paste0函数应该改成paste函数。
#这样连接上下2行的时候自动插入一个空格，否则如果第1行最后1个词是tax，第2行第1个词是return。
#合并之后就变成taxreturn，而我们希望得到的结果是tax return。

#将一个文本文件转换成一个长字符串用到多条语句，我们把它写成一个自定义函数：
#为了避免使用全局变量，我们使用了for循环
Txt2String <- function(filepath, encode= "ANSI") { #函数名为Txt2String，文本文件的路径为filepath
  #文本文件默认编码为ANSI。
  Lines <- readLines(filepath,encoding = encode,warn = FALSE)
  #有的文件最后一行不是空行，readLines会产生一个警告信息。将警告信息设置为FALSE则不显示警告信息。
  LongTxt <- ''
  for (i in (1:length(Lines)))   LongTxt <- paste0(LongTxt,Lines[i])
  # for 循环只有一条语句，所以不用在语句两边加大括号。
  # 如果有多条语句则需要用大括号把循环内的语句围起来。
  return(LongTxt)
}
Txt2String('D:/BA/TextMining/Corpus/CNSample/Example1.txt',"UTF-8")
# Example2.txt使用了ANSI编码，和默认值相同，所以不需要告诉我们自定义的函数文本文件是什么编码。
Txt2String('D:/BA/TextMining/Corpus/CNSample/Example2.txt')
#但如果用错了编码就会出现乱码，如以下语句：
Txt2String('D:/BA/TextMining/Corpus/CNSample/Example2.txt',"UTF-8")

# 下面我们将会使用数据框FolderList逐行生成文本文件存放路径
# 要用到apply函数：apply(数据框名，MARGIN =1 代表函数用在行上, 自定义函数)
# 可以在命令行使用?apply语句看apply函数如何使用。
TxtFolders <- apply(FolderList, 1, function(FolderListRow) { 
              #因为margin=1，此处的FolderListRow表示数据框FolderList中的每一行。
              paste0('D:/BA/TextMining/Corpus/CNSample/',FolderListRow[1],'/')     })
#数字1表示每一行的第一个数据，观察数据框TxtFolders的第一列，可见第一列为存放各种主题文本的子目录名。
TxtFolders

#下面展示如何在一个文件夹中操作，将所有文本文件的内容放入一个向量中，
#该向量的每个元素是一篇文本。
TxtFolder01 <- "D:/BA/TextMining/Corpus/CNSample/C000007/"
TextFiles <- dir(TxtFolder01, pattern = '.txt', full.names = TRUE)  #将目录中的所有文件列出。
#full.names = TRUE 确保列出文件的完整路径。
TextFiles
Strings <- sapply(TextFiles, function(filepath) Txt2String(filepath))
#TextFiles是一个列表向量，每个元素是一个文本文件路径。
#针对每个元素，使用自定义的Txt2String函数转换成一个长字符串。
#因为需要对TextFiles每个元素（即每个文本文件路径）进行操作，所以使用了sapply函数。
Strings #结果保留在Strings列表向量中，该列表的每个元素都是文本文件转换之后的长字符串。

#以上的例子展示如何从一个文件夹中提取文本文件的数据。
#下面我们写一个自定义函数，功能是从一个文件夹当中提取所有文本文件的数据放在一个返回的列表向量中。
Folder2String <- function(folderpath, encode= "ANSI") {#函数名为Folder2String，
  #文件夹的路径为filepath, #文本文件默认编码为ANSI。
  TextFiles <- dir(folderpath, pattern = '.txt', full.names = TRUE)  #将目录中的所有文件列出。
  Strings <- sapply(TextFiles, function(filepath) Txt2String(filepath, encode))
  names(Strings) <- NULL #列表向量中每个元素的名称是很长的原文本文件路径，看起来很烦人，去掉！
  return(Strings)
}
Folder2String('D:/BA/TextMining/Corpus/CNSample/C000007/')

#下面我们需要从10个文件夹当中提取文本文件数据并将提出出的文本资料放入一个数据框中（类似于Corpus）
TXT <- data.frame(type = character(), text = character(), stringsAsFactors = FALSE)
#生成一个空的数据框，有2列，一列名为type，一列名为text，并且禁止R自动将文本转换成类别型变量。
for (i in (1:nrow(FolderList)) ){
  folderpath <- paste0('D:/BA/TextMining/Corpus/CNSample/',FolderList[i,"folder"],'/')
  #FolderList中每一行的"folder"变量存储每个存放文本文件的文件夹的名称。上面语句生成该文件夹目录。
  Strings <- Folder2String(folderpath) #从文件夹中提取所有的文本文件资料放入Strings中。
  TXT <- rbind(TXT, data.frame(type = rep(FolderList[i,"type"],length(Strings)), 
                        text = Strings))  #将提取出的文本资料放入TXT数据框中。
}
fix(TXT)

setwd(CorpusPath)
write.csv(TXT, file ="TXTCorpus.csv",row.names = FALSE)
#将得到的结果写入TXTCorpus.csv当中。