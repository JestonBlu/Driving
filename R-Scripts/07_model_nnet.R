library(nnet)
library(caret)

rm(list = ls())

load("R-Data/data-ml.rda")

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}


#############################################################
## Model No time
mdl = nnet(factor(Texting) ~ . - Time, data = ml.train, size = 13)

x = predict(mdl, ml.train, type = "class")
table(Actual = ml.train$Texting, Predicted = x)
metric(table(Actual = ml.train$Texting, Predicted = x))

y = predict(mdl, ml.test, type = "class")
table(Actual = ml.test$Texting, Predicted = y)
metric(table(Actual = ml.test$Texting, Predicted = y))


# fitControl <- trainControl(method = "repeatedcv", number = 1, repeats = 1)
#
# search.grid = expand.grid(.decay = c(.1), .size = c(5))
# fit = train(Texting ~ . - Time, data = ml.train, method = "nnet",
#             maxit = 100, tuneGrid = search.grid)


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
x

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


mdl = nnet(Texting ~ ., data = ml.train, size = 30, maxit = 1000, decay = .1, MaxNWts = 10000)

x = predict(mdl, ml.train, type = "class")
table(Actual = ml.train$Texting, Predicted = x)
metric(table(Actual = ml.train$Texting, Predicted = x))

y = predict(mdl, ml.test, type = "class")
table(Actual = ml.test$Texting, Predicted = y)
metric(table(Actual = ml.test$Texting, Predicted = y))


#####################################################################
## All obs

x = texting.sim[texting.sim$Time != 0, "Texting"]

texting.sim = ddply(texting.sim, .(Subject, Age_Old, Gender_Male), summarise,
                 Anger = diff(Anger),
                 Contempt = diff(Contempt),
                 Disgust = diff(Disgust),
                 Fear = diff(Fear),
                 Joy = diff(Joy),
                 Sad = diff(Sad),
                 Surprise = diff(Surprise),
                 Neutral = diff(Neutral))
texting.sim = cbind(texting.sim, Texting = x)

mdl = nnet(Texting ~ ., data = ml.train, size = 10, maxit = 100, MaxNWts = 10000)

x = predict(mdl, ml.train, type = "class")
table(Actual = ml.train$Texting, Predicted = x)
metric(table(Actual = ml.train$Texting, Predicted = x))

x = predict(mdl, ml.test, type = "class")
table(Actual = ml.test$Texting, Predicted = x)
metric(table(Actual = ml.test$Texting, Predicted = x))

x = predict(mdl, texting.sim, type = "class")
table(Actual = texting.sim$Texting, Predicted = x)
metric(table(Actual = texting.sim$Texting, Predicted = x))
