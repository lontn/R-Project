library(RMySQL)
library(DBI)
library(magrittr)
library(highcharter)

connent <- dbConnect(MySQL(), user="root", password="Gtml@3777", dbname="EdXInfo", host="140.134.51.26", port=3306)

##utf8設定
dbSendQuery(connent, "SET NAMES utf8")

##
sqlString <- "SELECT A.AGE, count(1) AS CN
FROM(
SELECT gender, year_of_birth,
CASE
when year_of_birth <> 0 THEN year(now( )) - year_of_birth
else 0
END AS AGE
FROM edxapp.auth_userprofile where user_id in (SELECT distinct user_id FROM EdXInfo.FCUx2015004201509)
) AS A
Group By A.AGE
order by A.AGE"

age_Raw <- dbSendQuery(connent, sqlString)
ageResult <- dbFetch(age_Raw)

chartReport <- function() {
  highchart() %>%
    hc_title(text = "大學普通物理實驗─手作坊", style = list(color = "#BBB")) %>%
    hc_subtitle(text = "年齡分佈統計") %>%
    hc_yAxis(title = list(text="人數", align="middle")) %>%
    hc_tooltip(split=TRUE, valueSuffix=" 人", sort = TRUE, table = TRUE) %>%
    hc_add_series(ageResult, type = "column",
                  hcaes(x = ageResult$AGE, y = ageResult$CN, size = ageResult$CN, group = c("Age")))
}
chartReport()

# clean result sets
dbClearResult(age_Raw)
# Disconnect from the database
dbDisconnect(connent)
