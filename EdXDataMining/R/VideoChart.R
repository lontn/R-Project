library(RMySQL)
library(DBI)
library(magrittr)
library(highcharter)

conn <- dbConnect(MySQL(), user="root", password="Gtml@3777", dbname="EdXInfo", host="140.134.51.26", port=3306)

##utf8設定
dbSendQuery(conn, "SET NAMES utf8")

##挑選 SubEventType 表所有欄位
  statement <-
    "SELECT EventType, VideoSec, count(1) as Sum FROM EdXInfo.VideoStatistics
  where VideoCode = 'vN6zidatews' group by EventType, VideoSec order by VideoSec"

result_Raw <- dbSendQuery(conn, statement)
tableResult <- dbFetch(result_Raw)

highchart() %>%
  hc_title(text = "大學普通物理實驗─手作坊", style = list(color = "#BBB")) %>%
  hc_subtitle(text = "1-4-b 儀器架設") %>%
  hc_yAxis(title = list(text="次數", align="middle")) %>%
  hc_tooltip(split=TRUE, valueSuffix=" count", sort = TRUE, table = TRUE) %>%
  hc_plotOptions(area = list(stacking = "normal", lineColor = "#ffffff", lineWidth=1, marker = list(lineWidth=1, lineColor ="#ffffff"))) %>%
  hc_add_series(tableResult, type = "areaspline",
                hcaes(x = tableResult$VideoSec, y = tableResult$Sum, size = tableResult$Sum, group = tableResult$EventType))

# clean result sets
dbClearResult(result_Raw)
# Disconnect from the database
dbDisconnect(conn)
