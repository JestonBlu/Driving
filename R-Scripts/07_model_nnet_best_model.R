library(nnet)
library(caret)
library(plyr)
library(doMC)
library(e1071)

rm(list = ls())

registerDoMC(cores = 6)


## Model Performance Metric
metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}

############################################################
## Set parameters for all models

## Set Cross Validation
fit.control = trainControl(method = "cv", number = 10)

## Create combination of model parameters to train on
search.grid = expand.grid(decay = c(0, .1, .2),
                          size = c(1, 10, 25, 50))

## Limit the iterations and weights each model can run
maxIt = 250; maxWt = 150000


################################################################
## Model 8: Averaging values over fixed .5 seconds
load("R-Data/data-mdl-08.rda")

fit = train(Texting ~ . - Time, mdl.08.train, method = "nnet",
            trControl = fit.control,
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.08.train, type = "raw")
table(Actual = mdl.08.train$Texting, Predicted = x)
metric(table(Actual = mdl.08.train$Texting, Predicted = x))

y = predict(fit, mdl.08.test, type = "raw")
table(Actual = mdl.08.test$Texting, Predicted = y)
metric(table(Actual = mdl.08.test$Texting, Predicted = y))


mdl.08 = fit

save("mdl.08", file = "R-Models/mdl_08_nnet.rda")
rm(x, y, fit, mdl.08, mdl.08.train, mdl.08.test)



################################################################
## Model 12: 
load("R-Data/data-mdl-12.rda")

fit = train(Texting ~ . - Time, mdl.12.train, method = "nnet",
            trControl = fit.control,
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.12.train, type = "raw")
table(Actual = mdl.12.train$Texting, Predicted = x)
metric(table(Actual = mdl.12.train$Texting, Predicted = x))

y = predict(fit, mdl.12.test, type = "raw")
table(Actual = mdl.12.test$Texting, Predicted = y)
metric(table(Actual = mdl.12.test$Texting, Predicted = y))


mdl.12 = fit

save("mdl.12", file = "R-Models/mdl_12_nnet.rda")
rm(x, y, fit, mdl.12, mdl.12.train, mdl.12.test)
