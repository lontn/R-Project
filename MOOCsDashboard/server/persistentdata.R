library(DBI)
library(RMySQL)

options(mysql = list(
  "host" = "140.134.51.26",
  "port" = 3306,
  "user" = "root",
  "password" = "Gtml@3777"
))

databaseName <- "EdXInfo"

loadCourseData <- function() {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  
  # Construct the fetching query
  query <- "SELECT CourseId, 
       concat(Org, '-', DisplayNumber, '-', Date, '-',DisplayName) AS DisplayName 
  FROM EdXInfo.TrackingCourse
  Order by DisplayName"
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  #tableResult <- dbFetch(data)
  dbDisconnect(db)
  data
}


loadEventData <- function(videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
        port = options()$mysql$port, user = options()$mysql$user, 
        password = options()$mysql$password)
  
  # Construct the fetching query
  query <- sprintf("SELECT EventType, VideoSec, count(1) as Sum FROM EdXInfo.VideoStatistics
  where VideoCode =  %s group by EventType, VideoSec order by VideoSec", videoCode)

  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}