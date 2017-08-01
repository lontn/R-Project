library(randomForest)
setwd("D:/ResourceDataTest")
edxData <- read.table("trainData_2017-07-06_23_05_45-2.csv", sep=",", header = TRUE)

# 先把資料區分成 train=0.8, test=0.2
traindata <- ceiling(0.8*nrow(edxData))

train.index <- sample(1:nrow(edxData), traindata)
#訓練資料
edx.traindata <- edxData[train.index,]
#測試資料
edx.testdata <- edxData[-train.index,]

#(2)跑隨機樹森林模型
randomforestM <- randomForest(label ~ ., data = edx.traindata, importane = T, proximity = T, do.trace = 100)

#錯誤率: 利用OOB(Out Of Bag)運算出來的
plot(randomforestM)

#衡量每一個變數對Y值的重要性，取到小數點第二位
round(importance(randomforestM), 2)

#(3)預測
result <- predict(randomforestM, newdata = edx.testdata)
#result_Approved <- ifelse(result > 0.6, 1, 0)


#顯示訓練資料的正確率
species.traindata <- edxData$label[-train.index]
train.predict <- factor(result, levels = levels(species.traindata))
#建立混淆矩陣(confusion matrix)觀察模型表現
matrix.traindata <- table(species.traindata, train.predict)
matrix.traindata

#(5)正確率
#計算核準卡正確率
matrix.traindata[4] / sum(matrix.traindata[, 2])

#計算拒補件正確率
matrix.traindata[1] / sum(matrix.traindata[, 1])

#整體準確率(取出對角/總數)
accuracy <- sum(diag(matrix.traindata)) / sum(matrix.traindata)
accuracy
