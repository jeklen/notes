library(stringr)
library(XML)
library(RCurl)

MovieData0 <- data.frame(Title = character(0), Title2 = character(0),
                         Rating = numeric(0), URL = character(0),
                         Comments = numeric(0),  stringsAsFactors = FALSE)

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
  Comments <- Comments[str_detect(Comments,'人评价')]
  Comments <- as.numeric(gsub('人评价','',Comments))
  MovieData <- cbind(MovieData, data.frame(Comments = Comments))
  
  MovieData0 <- rbind(MovieData0, MovieData)
}

write.csv(MovieData0, file = 'D:/BA/GetData/DouBan2.csv',row.names = FALSE)
