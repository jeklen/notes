library(tm)
#tm包支持从多个来源读取文本：
getSources()
#也支持多个阅读器：
getReaders()

sourcedir <- 'D:/BA/TextMining/Corpus/pdf' #将要用来生成语料库的pdf文件所在的目录
dir(sourcedir) #运行dir语句，看目录里面有哪些pdf文件
pdffiles <- list.files(path = sourcedir, pattern = ".pdf",  full.names = TRUE) 
#将pdf文件的路径放入pdffiles变量中。

sapply(pdffiles, function(filepath) system(paste
     ('D:/BA/TextMining/pdf2txt/bin64/pdftotext.exe', paste0('"', filepath, '"')), wait = FALSE) )
#上面的sapply语句是对pdffiles当中所有元素应用一个函数。
#该函数的作用是使用pdftotext.exe程序将目标目录中所有pdf文件转换成txt文件。
#注意：我用的是64位操作系统，如果你用的是Windows 32位操作系统，应该把bin64改成bin32。
#可以试着运行以下语句看有什么效果：
# sapply(1:5, function(i) i^2)
# filepathlength <- sapply(pdffiles, function(f) nchar(f)); names(filepathlength) <-NULL; filepathlength
#paste0('"', filepath, '"') 生成双引号引起来的pdf文件路径。
#paste0('1','2','3') 结果和paste('1','2','3',sep='')相同，但paste('1','2','3')得到的结果是分隔符为空格。
#system()函数执行一个命令语句，此处为对pdf文件执行pdftotext.exe程序。
#paste('D:/BA/TextMining/pdf2txt/bin64/pdftotext.exe', paste0('"', filepath, '"')
#则生成了执行命令的语句。
#试着运行一下 paste('D:/BA/TextMining/pdf2txt/bin64/pdftotext.exe', paste0('"', pdffiles[1], '"'))
#运行完之后，目标目录中所有pdf转换成txt文件，放在原目录中。

dir.create('D:/BA/TextMining/Corpus/txt') #创建新目录用来存放txt文件。
txtfiles <- list.files(path = sourcedir, pattern = ".txt",  full.names = TRUE)
#这是所有文本文件的路径名
sapply(txtfiles, function(origintxtfile) { #origintxtfile 表示txtfiles中的每个元素
  destfile <- sub('/Corpus/pdf','/Corpus/txt',origintxtfile)
  # 目标文件路径是原文件路径中的/Corpus/pdf替换成/Corpus/txt，其他不变。
  file.copy(from = origintxtfile, to = destfile, overwrite=TRUE)
  # 将原文件拷贝到目标文件夹。
  file.remove(origintxtfile)  #移除原文件。  
  })
