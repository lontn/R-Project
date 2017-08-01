#FCUx/2015002/201510
library(rpart)
library(rattle)
setwd("D:/ResourceDataTest")
edxData <- read.table("trainData_2017-07-06_23_05_45-2.csv", sep=",", header = TRUE)

otherEdxData <- read.table("trainData_2017-08-07_23_14_55.csv", sep=",", header = TRUE)

# 先把資料區分成 train=0.8, test=0.2
traindata <- ceiling(0.8*nrow(edxData))

otherTraindata <- ceiling(1.0*nrow(otherEdxData))

# 80%訓練資料
train.index <- sample(1:nrow(edxData), traindata)
#訓練資料
edx.traindata <- edxData[train.index,]

#測試資料
edx.testdata <- edxData[-train.index,]

other.index <- sample(1:nrow(otherEdxData), otherTraindata)
#全部測試資料
edx.othertestdata <- otherEdxData[other.index,]


#建立決策樹模型
edx.tree <- rpart(label ~. , method = "class", data=edx.traindata)

#顯示訓練資料的正確率
species.traindata <- otherEdxData$label[other.index]
#species.traindata <- edxData$label[-train.index]
#預測
result_predict <- predict(edx.tree, edx.othertestdata, type="class")
train.predict <- factor(result_predict, levels = levels(species.traindata))
#建立混淆矩陣(confusion matrix)觀察模型表現
matrix.traindata <- table(species.traindata, train.predict)
matrix.traindata

#整體準確率(取出對角/總數)
#計算預測準確率 = 對角線的數量/總數量
accuracy <- sum(diag(matrix.traindata)) / sum(matrix.traindata) * 100
accuracy
