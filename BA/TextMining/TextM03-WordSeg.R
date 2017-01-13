library(Rwordseg)

segmentCN("爱是恒久忍耐，又有恩慈；爱是不嫉妒，爱是不自夸，不张狂，不做害羞的事，")
#分词的结果显示：“害羞”一词被割成2个字符。“恩慈”也被割成2个字符。
segmentCN("不求自己的益处，不轻易发怒，不计算人的恶，不喜欢不义，只喜欢真理；")
#分词的结果显示：“不义”一词被割成2个字符。
segmentCN("凡事包容，凡事相信，凡事盼望，凡事忍耐。", returnType = "tm")
#如果使用returntype="tm"参数，则分词结果以空格分隔，没有双引号。

# RWordSeg词典的存放目录：
getOption("dic.dir")
# 也可以用以下语句生成词典的存放目录：
# RWordSegDictPath <- paste(R.home(),'/library/Rwordseg/dict', sep='')
# 目前在词典目录当中有2个自定义词典，分别是tw.dic和example.dic
list.files(getOption("dic.dir"))
#下面在词典目录中生成一个名为“Bible.dic”的自定义字典，然后把自定义词写进去。
#你也可以自己使用文本编辑器编辑好之后存为dic文件，然后放入RWordSeg的自定义词典目录中。
dictpath <- paste(getOption("dic.dir"),'/Bible.dic',sep='')
fileConn <- file(dictpath, encoding = 'UTF-8', "w") #应该使用UTF-8编码，否则不能识别中文。
writeLines(c('害羞','恩慈','不义'), fileConn)
close(fileConn)
loadDict() #将词典调入内存
#默认词典的安装目录是%R_HOME%\library\Rwordseg\dict，只需将自己的词典放到这里即可，后缀为.dic
#修改之后每次重启都会导入dict目录下的词典，若想立即就生效可使用 loadDict()

segmentCN("爱是恒久忍耐，又有恩慈；爱是不嫉妒，爱是不自夸，不张狂，不做害羞的事，", returnType = "tm")
segmentCN("不求自己的益处，不轻易发怒，不计算人的恶，不喜欢不义，只喜欢真理；", returnType = "tm")
segmentCN("凡事包容，凡事相信，凡事盼望，凡事忍耐。", returnType = "tm")

segmentCN("降龙十八掌、黯然销魂掌和玄冥神掌哪个强？")
#以上的分词结果没有把金庸小说中的招式正确识别出来。
#我们到http://pinyin.sogou.com/dict/下载金庸武功招式词库。
#搜索“金庸”之后到以下链接下载：http://pinyin.sogou.com/dict/detail/index/8552
installDict("d:/BA/TextMining/金庸武功招式.scel","JinYongKungFuStyle")
segmentCN("降龙十八掌、黯然销魂掌和玄冥神掌哪个强？",returnType = "tm")

listDict() #显示安装的词典
uninstallDict() #删除安装的词典
#如果只是在内存中临时添加或删除词汇，可以使用insertWords()和deleteWords()函数
segmentCN("降龙十八掌、黯然销魂掌和玄冥神掌哪个强？",returnType = "tm")
insertWords(c("降龙十八掌","黯然销魂掌","玄冥神掌")) #临时添加词汇
segmentCN("降龙十八掌、黯然销魂掌和玄冥神掌哪个强？",returnType = "tm")
deleteWords(c("降龙十八掌","黯然销魂掌","玄冥神掌")) #临时删除词汇
segmentCN("降龙十八掌、黯然销魂掌和玄冥神掌哪个强？",returnType = "tm")

