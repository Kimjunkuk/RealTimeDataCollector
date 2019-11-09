library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)
library(dplyr)
library(RCurl)
library(XML)
library(jsonlite)
library(readxl)

#install.packages("XML")


url1 = "http://openapi.seoul.go.kr:8088/677456646370647232366173524a79/json/bikeList/1/1000"
url2 = "http://openapi.seoul.go.kr:8088/677456646370647232366173524a79/json/bikeList/1001/2000"

setwd(dir = 'D:/bike')
options("encoding" = "UTF-8")

while(TRUE){
  res1 <- getURL(url1, .encoding="UTF-8")
  res2 <- getURL(url = url2, .encoding = "UTF-8")
  res1 %>% fromJSON() -> json1
  res2 %>% fromJSON() -> json2
  df1 <- json1$rentBikeStatus$row
  df2 <- json2$rentBikeStatus$row
  
  result_df <- rbind(df1, df2)
  
  result_df$stationName %>% str_remove(pattern = '(=?\\d+\\. )') -> result_df$stationName
  timestamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
  result_df <- cbind(result_df, timestamp)
  
  result_json <- toJSON(result_df)
  fileName <- paste(timestamp, 'bike.json', sep = '_')
  write(result_json,file=fileName)
  sprintf("create file: %s", fileName)
  Sys.sleep(time = 60)
}
