library(neuralnet)
library(nnet)
library(caret)

rm(list = ls())

load("R-Data/stats.rda")

stats = subset(stats, Trial == '007')

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}

stats = stats[, c(4,5,7:47)]

trainIndex = createDataPartition(stats$texting, p = .6, list = FALSE)

train = stats[trainIndex, ]
test = stats[-trainIndex, ]

my.grid = expand.grid(.decay = c(.01, .5, .1), .size = c(3, 5, 7, 10, 20))
fit = train(texting ~ ., data = train, method = "nnet", maxit = 1000, tuneGrid = my.grid)    

results = predict(fit, newdata = test)
table(Actual = test$texting, Prediction = results)
metric(table(Actual = test$texting, Prediction = results))
