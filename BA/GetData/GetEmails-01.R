library(stringr) # for the function str_match 调入stringr package
setwd("d:/BA/GetData") #设置工作目录
con <- file("Email.txt", "r") #读文本文件Email.txt
email_list <- NULL  #email_list用来保存提取出来的Email，初始化为空。
pattern <- '[[:alnum:]_.-]+@[[:alnum:]_.-]+\\.[A-Za-z]+'  #Email的正则表达式。
# a simplier RE: pattern <- '[[:alnum:].-_]+@[[:alnum:].-_]+'
# However, the above simplier RE may match "ABC@AAA.Com._"
line=readLines(con,n=1) #读一行文字。
while( length(line) != 0 ) { #如果还没到文件尾部
  match_emails <- unlist(str_match_all(line, pattern)) 
  #看这一行里面有没有Email，如果有有则将结果存入match_emails这个变量中。
  #str_match_all returns all matched emails.
  # unlist a list to a vector variable.
  if (length(match_emails)!=0)
     {  email_list <- append(email_list, match_emails)
        print(match_emails) }
  line=readLines(con,n=1)
}
close(con) #关闭打开的Email.txt文件
paste(email_list,collapse=";") #合并email_list当中保存的emails，用分号作为分隔符。
length(email_list) #看一下提取出多少个email。
