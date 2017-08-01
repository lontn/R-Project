library(party)
setwd("D:/ResourceDataTest")
edxData <- read.table("trainData_2017-07-06_23_05_45-2.csv", sep=",", header = TRUE)

ct <- ctree(label ~., data=edxData)
plot(ct, main="條件推論樹")
table.traindata <- table(edxData$label, predict(ct))

#計算預測準確率 = 對角線的數量/總數量
accuracy <- sum(diag(table.traindata)) / sum(table.traindata) * 100