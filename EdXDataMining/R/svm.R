library("e1071")
setwd("D:/ResourceDataTest")
edxData <- read.table("trainData_2017-07-06_23_05_45-svm.csv", sep=",", header = TRUE)
# 先把資料區分成 train=0.9, test=0.1
traindata <- ceiling(0.8*nrow(edxData))
svm.index <- sample(1:nrow(edxData), traindata)
#測試資料
svm.test <- edxData[-svm.index,]
#訓練資料
svm.train <- edxData[svm.index,]

#x <- subset(edxData, select = -label)
#y <- edxData$label
#svm.model <- svm(x, y)

# 建立模型
svm.model <- svm(label ~ ., data = svm.train, probability = TRUE)

#svm.pred <- predict(svm.model, svm.test[,-5])

# 預測
results <- predict(svm.model, svm.test, probability = TRUE)

# 評估
cm <- table(x = svm.test$label, y = results)

SVMaccuracy <- sum(diag(cm)) / sum(cm)
