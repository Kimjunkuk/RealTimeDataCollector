library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)
library(dplyr)

url1 = "http://openapi.seoul.go.kr:8088/677456646370647232366173524a79/json/bikeList/1/1000"
url2 = "http://openapi.seoul.go.kr:8088/677456646370647232366173524a79/json/bikeList/1001/2000"

while(TRUE){
  GET(url = url1) -> res1
  res1 %>% content(as = 'text', encoding = 'UTF-8') %>% fromJSON() -> json1
  
  GET(url = url2) -> res2
  res2 %>% content(as = 'text', encoding = 'UTF-8') %>% fromJSON() -> json2
  
  df1 <- json1$rentBikeStatus$row
  df2 <- json2$rentBikeStatus$row
  
  result_df <- rbind(df1, df2)
  
  result_df$stationName %>% str_remove(pattern = '(=?\\d+\\.)') -> result_df$stationName
  timestamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
  result_df <- cbind(result_df, timestamp)
  
  result_json <- toJSON(result_df)
  fileName <- paste(timestamp, 'bike.json', sep = '_')
  write(result_json,file=fileName)
  
  Sys.sleep(time = 1)
}

install.packages("readxl")
library(readxl)

setwd("C:\Users\Elite\Desktop\서울시 공공자전거 고장신고 내역")

df_exam <- read_excel("excel_exam.xlsx")


library(jsonlite)
setwd('./bike')

json1 <- fromJSON("2019-10-14_15-47_bike.json")