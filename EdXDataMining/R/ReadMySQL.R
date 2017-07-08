library(RMySQL)
library(DBI)
con <- dbConnect(MySQL(), user="root", password="root123!", dbname="EdXInfo", host="localhost")
dbListTables(con)
dbListFields(con, "TrackingLog")
#dbReadTable(con, "TrackingLog")
result <- dbGetQuery(con, "SELECT * FROM TrackingLog limit 5")
tableX <- data.frame(result)

#data.frame
class(result)

mode(tableX)

# Clear the result
#dbClearResult(result)


# Disconnect from the database
dbDisconnect(con)

