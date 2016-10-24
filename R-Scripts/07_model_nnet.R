library(nnet)
library(caret)
library(plyr)
library(doMC)

rm(list = ls())

load("R-Data/data-ml.rda")

registerDoMC(cores = 4)

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}


#############################################################
## Model No time
# mdl = nnet(factor(Texting) ~ . - Time, data = ml.train, size = 10)
# 
# x = predict(mdl, ml.train, type = "class")
# table(Actual = ml.train$Texting, Predicted = x)
# metric(table(Actual = ml.train$Texting, Predicted = x))
# 
# y = predict(mdl, ml.test, type = "class")
# table(Actual = ml.test$Texting, Predicted = y)
# metric(table(Actual = ml.test$Texting, Predicted = y))


#############################################################
## Model No time: Tuning
fit.control = trainControl(method = "cv", number = 2)
search.grid = expand.grid(decay = c(0, .1, .5), size = c(5, 10, 15))
fit = train(Texting ~ . - Time, ml.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = 10000,
            maxit = 2)



################################################################3
## Model: Differencing

## Calculated differencing
## Need to remove the first observation for each Subject
x = ml.train[ml.train$Time != 0, "Texting"]

ml.train = ddply(ml.train, .(Subject, Age_Old, Gender_Male), summarise,
                 Anger = diff(Anger),
                 Contempt = diff(Contempt),
                 Disgust = diff(Disgust),
                 Fear = diff(Fear),
                 Joy = diff(Joy),
                 Sad = diff(Sad),
                 Surprise = diff(Surprise),
                 Neutral = diff(Neutral))
ml.train = cbind(ml.train, Texting = x)

## Calculated the first row for each Subject to remove
ml.test$row = 1:nrow(ml.test)
y = ddply(ml.test, .(Subject), summarise, minRow = min(row))

x2 = ml.test$Texting
x2 = x2[-(y$minRow)]

## Calculated differencing for the test set
ml.test = ddply(ml.test, .(Subject, Age_Old, Gender_Male), summarise,
                 Anger = diff(Anger),
                 Contempt = diff(Contempt),
                 Disgust = diff(Disgust),
                 Fear = diff(Fear),
                 Joy = diff(Joy),
                 Sad = diff(Sad),
                 Surprise = diff(Surprise),
                 Neutral = diff(Neutral))
ml.test = cbind(ml.test, Texting = x2)

## Clean up workspace
rm(x, x2, y)


# mdl = nnet(Texting ~ ., data = ml.train, size = 50, maxit = 100, decay = .1, MaxNWts = 10000)
# 
# x = predict(mdl, ml.train, type = "class")
# table(Actual = ml.train$Texting, Predicted = x)
# metric(table(Actual = ml.train$Texting, Predicted = x))
# 
# y = predict(mdl, ml.test, type = "class")
# table(Actual = ml.test$Texting, Predicted = y)
# metric(table(Actual = ml.test$Texting, Predicted = y))


## Model No time: Tuning
fit.control = trainControl(method = "cv", number = 4)
search.grid = expand.grid(decay = c(0, .1, .5), size = c(5, 10, 25, 50))
fit = train(Texting ~ ., ml.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = 10000,
            maxit = 1000)

save("fit", file = "R-Models/nnet_differenced.rda")
