library(rpart)
library(rattle)
data("iris")

#nrow(iris)傳回iris資料筆數
np <- ceiling(0.1*nrow(iris))

#10% test data
test.index <- sample(1:nrow(iris), np)
#訓練資料
iris.traindata <- iris[-test.index,]
#測試資料
iris.testdata <- iris[test.index,]


#使用rpart()函數建立訓練資料的決策樹iris.tree
#method參數可以選擇分類樹class或迴歸樹anova兩種方式。
iris.tree <- rpart(Species ~ Sepal.Length + Sepal.Width + Petal.Length +
                     Petal.Width, method = "class", data=iris.traindata)
plot(iris.tree)
text(iris.tree)

#顯示訓練資料的正確率
species.traindata <- iris$Species[-test.index]
result_predict <- predict(iris.tree, iris.traindata, type="class")
train.predict <- factor(result_predict, levels = levels(species.traindata))
#建立混淆矩陣(confusion matrix)觀察模型表現
table.traindata <- table(species.traindata, train.predict)

#整體準確率(取出對角/總數)
#計算預測準確率 = 對角線的數量/總數量
accuracy <- sum(diag(table.traindata)) / sum(table.traindata) * 100

#測試資料的正確率
species.testdata <- iris$Species[test.index]
test_predict <- predict(iris.tree, iris.testdata, type="class")
test.predict <- factor(test_predict, levels = levels(species.testdata))
table.testdata <- table(species.testdata, test.predict)

#整體準確率(取出對角/總數)
#計算測試準確率 = 對角線的數量/總數量
accuracy.test <- sum(diag(table.testdata)) / sum(table.testdata) * 100

