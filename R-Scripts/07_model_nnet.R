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

ml.train = subset(texting.sim, Time <= 365)
ml.test = subset(texting.sim, Time > 365)


mdl = nnet(factor(Texting) ~ ., data = texting.sim, size = 10)

x = predict(mdl, ml.train, type = "class")
table(Actual = ml.train$Texting, Predicted = x)
metric(table(Actual = ml.train$Texting, Predicted = x))

y = predict(mdl, ml.test, type = "class")
table(Actual = ml.test$Texting, Predicted = y)
metric(table(Actual = ml.test$Texting, Predicted = y))
