
options(mysql = list(
  "host" = "140.134.51.26",
  "port" = 3306,
  "user" = "root",
  "password" = "Gtml@3777"
))

databaseName <- "EdXInfo"

# killDbConnections <- function () {
#   
#   all_cons <- dbListConnections(MySQL())
#   
#   print(all_cons)
#   
#   for(con in all_cons)
#     +  dbDisconnect(con)
#   
#   print(paste(length(all_cons), " connections killed."))
#   
# }
# 
# killDbConnections()


loadCourseData <- function() {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  
  # Construct the fetching query
  query <- "SELECT concat(Org, '-', DisplayNumber, '-', Date, '-',DisplayName) AS DisplayName, CourseId AS id
  FROM EdXInfo.TrackingCourse
  WHERE CourseId in('FCUx/2015004/201509','FCUx/mooc0005/201412')
  Order by DisplayName"
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
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
  where CourseId = '%s' AND VideoCode =  '%s' group by EventType, VideoSec order by VideoSec", courseId, videoCode)
  
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

loadVideoData <- function(CourseId) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  query <- sprintf("SELECT DisplayName,CourseId, IFNULL(VideoTitle, '無設定標題') AS VideoTitle, VideoCode FROM EdXInfo.CourseMaterialInfo where CourseId = '%s'", CourseId)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

loadSampleData <- function(courseId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT user_id,code,StartTime,EndTime,WatchTime,EventList FROM EdXInfo.FCUx2015004201509VideoPersonal where code = '%s'", videoCode)
  } else {
    query <- sprintf("SELECT user_id,code,StartTime,EndTime,WatchTime,EventList FROM EdXInfo.FCUxmooc0005201504VideoPersonal where code = '%s'", videoCode)
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

countCourseData <- function(courseId) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT count(distinct user_id) as QTY FROM EdXInfo.FCUx2015004201509VideoPersonal")
  } else {
    query <- sprintf("SELECT count(distinct user_id) as QTY FROM EdXInfo.FCUxmooc0005201504VideoPersonal")
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

countVideoData <- function(courseId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT count(distinct user_id) as QTY FROM EdXInfo.FCUx2015004201509VideoPersonal where code = '%s'", videoCode)
  } else {
    query <- sprintf("SELECT count(distinct user_id) as QTY FROM EdXInfo.FCUxmooc0005201504VideoPersonal where code = '%s'", videoCode)
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

# 取得認證人數
certData <- function(courseId) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  query <- sprintf("SELECT count(1) as QTY FROM edxapp.certificates_generatedcertificate where course_id = '%s' and status = 'downloadable'", courseId)
  
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

listUserId <- function(courseId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT distinct user_id as QTY FROM EdXInfo.FCUx2015004201509VideoPersonal where code = '%s' order by row_names", videoCode)
  } else {
    query <- sprintf("SELECT distinct user_id as QTY FROM EdXInfo.FCUxmooc0005201504VideoPersonal where code = '%s' order by row_names", videoCode)
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

wordCloudSum <- function(courseId, userId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT sum(hide_transcript_num) as hide_transcript, 
sum(show_transcript_num) as show_transcript, 
sum(load_num) as load_video, 
sum(play_num) as play_video, 
sum(pause_num) as pause_video, 
sum(stop_num) as stop_video, 
sum(seek_num) as seek_video, 
sum(speed_change_num) as speed_change
FROM EdXInfo.FCUx2015004201509VideoPersonal
where  user_id = %i and code = '%s'
order by row_names ", as.integer(userId), videoCode)
  } else {
    query <- sprintf("SELECT sum(hide_transcript_num) as hide_transcript, 
sum(show_transcript_num) as show_transcript, 
sum(load_num) as load_video, 
sum(play_num) as play_video, 
sum(pause_num) as pause_video, 
sum(stop_num) as stop_video, 
sum(seek_num) as seek_video, 
sum(speed_change_num) as speed_change
FROM EdXInfo.FCUxmooc0005201504VideoPersonal
where  user_id = %i and code = '%s'
order by row_names ", as.integer(userId), videoCode)
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

videoEventType <- function(courseId, userId, videoCode) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host,
                  port = options()$mysql$port, user = options()$mysql$user,
                  password = options()$mysql$password)
  ##utf8設定
  dbSendQuery(db, "SET NAMES utf8")
  # Construct the fetching query
  if (courseId == "FCUx/2015004/201509") {
    query <- sprintf("SELECT user_id, WatchTime, EventList FROM EdXInfo.FCUx2015004201509VideoPersonal where user_id = %i and code = '%s' order by row_names", as.integer(userId), videoCode)
  } else {
    query <- sprintf("SELECT user_id, WatchTime, EventList FROM EdXInfo.FCUxmooc0005201504VideoPersonal where user_id = %i and code = '%s' order by row_names", as.integer(userId), videoCode)
  }
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}