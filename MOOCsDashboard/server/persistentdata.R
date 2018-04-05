
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
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
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


loadEventData <- function(courseId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  query <- sprintf("SELECT EventType, VideoSec, count(1) as Sum FROM EdXInfo.VideoStatistics
                   where CourseId = 'FCUx/2015004/201509' AND VideoCode =  'vN6zidatews' group by EventType, VideoSec order by VideoSec", videoCode)
  
  # Submit the fetch query and disconnect
  data <- dbSendQuery(db, query)
  tableResult <- dbFetch(data)
  
  # clean result sets
  dbClearResult(data)
  
  dbDisconnect(db)
  tableResult
}

loadStudentData <- function() {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  query <- sprintf("SELECT user_id,code,StartTime,EndTime,WatchTime,EventList FROM EdXInfo.FCUx2015004201509VideoPersonal")
  
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}