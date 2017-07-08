library(rpart)
library(rattle)
setwd("D:/ResourceDataTest")
edxData <- read.table("trainData_2017-07-06_23_05_45.csv", sep=",", header = TRUE)

# 先把資料區分成 train=0.8, test=0.2
traindata <- ceiling(0.8*nrow(edxData))

train.index <- sample(1:nrow(edxData), traindata)
#訓練資料
edx.traindata <- edxData[train.index,]
#測試資料
edx.testdata <- edxData[-train.index,]


edx.tree <- rpart(label ~. , method = "class", data=edx.traindata)

#顯示訓練資料的正確率
species.traindata <- edxData$label[train.index]
result_predict <- predict(edx.tree, edx.traindata, type="class")
train.predict <- factor(result_predict, levels = levels(species.traindata))
#建立混淆矩陣(confusion matrix)觀察模型表現
table.traindata <- table(species.traindata, train.predict)

#整體準確率(取出對角/總數)
#計算預測準確率 = 對角線的數量/總數量
accuracy <- sum(diag(table.traindata)) / sum(table.traindata) * 100