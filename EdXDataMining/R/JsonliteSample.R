library(jsonlite)
apiUrl <- "https://www.googleapis.com/youtube/v3/videos?id=9H2KWHmbGA0&key=AIzaSyBybIZ1TwOkZFF9T3guYjjdS72pUsHwMeE&part=contentDetails"
data <- fromJSON(apiUrl)
