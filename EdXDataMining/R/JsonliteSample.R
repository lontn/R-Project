library(jsonlite)
apiUrl <- "http://ip.360.cn/IPQuery/ipquery?ip=140.134.220.144"
data <- fromJSON(apiUrl)


apiUrl <- paste("http://ip-api.com/json/", "140.134.220.144", sep="")
city <- fromJSON(apiUrl)
