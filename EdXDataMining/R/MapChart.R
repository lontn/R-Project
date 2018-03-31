library(DBI)
library(RMySQL)
library(magrittr)
library(highcharter)

#mapTWdata <- get_data_from_map(download_map_data("countries/tw/tw-all"))
#glimpse(mapTWdata)

#data_fakeTW <- mapTWdata %>% 
#select(code = `hc-a2`) %>% 
#mutate(value = 1e5 * abs(rt(nrow(.), df = 10)))

#glimpse(data_fakeTW)


CityName <- c("TW", "TH", "TN", "CG")
Num <- c(20, 205, 35, 10)
citySum <- data.frame(CityName, Num)
#glimpse(citySum)

hcmap("countries/tw/tw-all", data = citySum, value = "Num",
      joinBy = c("hc-a2", "CityName"), name = "人數",
      dataLabels = list(enabled = TRUE, format = '{point.name}')) %>%
  hc_title(text = "台灣")
