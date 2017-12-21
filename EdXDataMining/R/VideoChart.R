library(RMySQL)
library(DBI)
library(magrittr)
library(highcharter)

conn <- dbConnect(MySQL(), user="root", password="Gtml@3777", dbname="EdXInfo", host="140.134.51.26", port=3306)

##utf8設定
dbGetQuery(conn, "SET NAMES utf8")

##挑選 SubEventType 表所有欄位
statement <- 
"SELECT EventType, VideoSec, count(1) as Sum FROM EdXInfo.VideoStatistics where VideoCode = '9H2KWHmbGA0'
group by EventType, VideoSec
order by VideoSec"
result_Raw <- dbGetQuery(conn, statement)

highchart() %>%
  hc_add_series(result_Raw, type = "scatter",
                hcaes(x = result_Raw$VideoSec, y = result_Raw$Sum, size = result_Raw$Sum, group = result_Raw$EventType))


# Disconnect from the database
dbDisconnect(conn)
