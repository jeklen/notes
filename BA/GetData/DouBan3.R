library(stringr)
library(XML)
library(RCurl)

MovieData0 <- data.frame(Title = character(0), Title2 = character(0),
                         Rating = numeric(0), URL = character(0),
                         Comments = numeric(0),  Director = character(0),
                         Cast = character(0), Year=numeric(0), Country = character(0),
                         Classification = character(0), Ranking = numeric(0),
                         stringsAsFactors = FALSE)
for (k in (1:10)) {
  url = paste0('https://movie.douban.com/top250?start=',(k-1)*25,'&filter=&type=')
  doc = getURL(url)
  doc = htmlParse(doc)
  
  titles <- xpathSApply(doc, "//span[@class='title']",xmlValue)
  title_id = 0; 
  MovieTitles <- data.frame(Title = character(0), Title2 = character(0),
                            stringsAsFactors = FALSE)
  toRemove <- '\\s/\\s'
  # toRemove <- str_sub(titles[9],1,3)
  for (i in (1:length(titles))) {
    if (str_detect(titles[i],toRemove)) {
      MovieTitles[title_id,"Title2"] = gsub(toRemove,'',titles[i])}
    else {
      title_id <- title_id+1; 
      MovieTitles[title_id,"Title"] = titles[i]}
  }
  
  #ratings <- as.numeric(xpathSApply(doc, "//span[contains(@class, 'rating')]",xmlValue))
  ratings <- as.numeric(xpathSApply(doc, "//span[@class='rating_num']",xmlValue))
  MovieData <- cbind(MovieTitles, data.frame(Rating = ratings))
  
  movieURLs <- xpathSApply(doc, '//a', xmlGetAttr, "href")
  movieURLs <- movieURLs[str_detect(movieURLs,'/subject')]
  movieURLs <- unique(movieURLs)
  MovieData <- cbind(MovieData, data.frame(URL = movieURLs))
  
  Comments <- xpathSApply(doc, "//span",xmlValue)
  Comments <- Comments[str_detect(Comments,'������')]
  Comments <- as.numeric(gsub('������','',Comments))
  MovieData <- cbind(MovieData, data.frame(Comments = Comments))
  
  Intro <- xpathSApply(doc, "//p[@class='']",xmlValue)
  Intro <- sapply(Intro, function(x) str_sub(x,30,str_length(x))) #ȥ��ǰ��Ŀո�
  
  # Directors <- sapply (Intro, function(x) str_sub(x, 5, str_locate(x,'����')[1]-4))
  # ��ʱ������Ϣռ����һ�У�û��������Ϣ�����Ϻ�����Ҫ��д����Ҫ���ж��Ƿ����������Ϣ��
  Directors <- sapply (Intro, function(x) {
    if (is.na((str_locate(x,'����'))[1])) str_sub(x, 5, str_locate(x,'\n')[1]-1)
    else str_sub(x, 5, str_locate(x,'����')[1]-4)}  )
  
  Casts <- sapply (Intro, function(x) {
    Loc <- (str_locate(x,'����'))[1]
    if (is.na(Loc)) 'NA'
    else str_sub(x, Loc+4, str_locate(x,'\n')[1]-1)}  )
  
#  Year <- as.numeric(str_match(Intro,'\\d{4}'))
#  start_of_Intro2 <- str_sub(x, str_locate(x,'\\d{4}')[2]+4
#  ����81�Ĵ����칬�кܶ����������Intro2����ʼλ��Ӧ�������һ����������ĵ�һ��'/'��
#  �������ǿ���ֱ��ʹ������ļ򵥵Ĵ��롣
#  Intro2��ȥ�����֮ǰ����Ϣ���������ݡ����ݵȣ�ʣ�µ���Ϣ���������ҡ���Ӱ���ͣ�

  Year <- as.numeric(str_match(Intro,'\\d{4}')) #ֻȡ������������Ϣ��
  Intro2 <- sapply(Intro, function(x) {
    YearCount <- str_locate_all(x,'\\d{4}')[[1]]
    if (length(YearCount)==2)   return (str_sub(x, YearCount[2]+4, str_length(x)))
    else {x1 <- str_sub(x,YearCount[length(YearCount)/2,2]+1, str_length(x));
          return (str_sub(x1,str_locate(x1,'/')[2]+2,str_length(x1)))}
    })
# Intro2 <- sapply(Intro, function(x) str_sub(x, start_of_Intro2, str_length(x)) )
  
  Country <- sapply(Intro2, function(x) str_sub(x, 1, str_locate(x,'/')[1]-2) )
  
  Classification <- sapply(Intro2, function(x) str_sub(x, str_locate(x,'/')[1]+2,
                                                       str_locate(x,'\n')[1]-1) )
  
  MovieData <- cbind(MovieData, data.frame(Director = Directors, Cast = Casts, Year = Year,
                     Country = Country, Classification = Classification, Ranking = (k-1)*25+(1:25)) )
  MovieData0 <- rbind(MovieData0, MovieData)  
}

write.csv(MovieData0, file = 'D:/BA/GetData/DouBan3.csv',row.names = FALSE)