library(nnet)
library(caret)
library(plyr)
library(doMC)

rm(list = ls())

registerDoMC(cores = 5)


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
search.grid = expand.grid(decay = c(0, .05, .1, .2), 
                          size = c(1, 3, 5, 10, 15))

## Limit the iterations and weights each model can run
maxIt = 500; maxWt = 10000



#############################################################
## Model 1: 
##
## Data Set:   Data scaled between 0-1 after split
## Exclusions: Time
## Specifics:  Train First Half, Test Second Half
## 
load("R-Data/data-mdl-01.rda")

fit = train(Texting ~ . - Time, mdl.01.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)

fit

x = predict(fit, mdl.01.train, type = "raw")
table(Actual = mdl.01.train$Texting, Predicted = x)
metric(table(Actual = mdl.01.train$Texting, Predicted = x))

y = predict(fit, mdl.01.test, type = "raw")
table(Actual = mdl.01.test$Texting, Predicted = y)
metric(table(Actual = mdl.01.test$Texting, Predicted = y))

save("fit", file = "R-Models/mdl_01_nnet.rda")
rm(x, y, fit)



#############################################################
## Model 2: 
##
## Data Set: Sample from total simulation 
## Exclusions: Time
##
load("R-Data/data-mdl-02.rda")

fit = train(Texting ~ . - Time, mdl.02.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)

fit

x = predict(fit, mdl.02.train, type = "raw")
table(Actual = mdl.02.train$Texting, Predicted = x)
metric(table(Actual = mdl.02.train$Texting, Predicted = x))

y = predict(fit, mdl.02.test, type = "raw")
table(Actual = mdl.02.test$Texting, Predicted = y)
metric(table(Actual = mdl.02.test$Texting, Predicted = y))

save("fit", file = "R-Models/mdl_02_nnet.rda")
rm(x, y, fit)



################################################################
## Model 3: Differencing
##
## Calculated differencing
## Need to remove the first observation for each Subject
load("R-Data/data-mdl-03.rda")

fit = train(Texting ~ ., mdl.03.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)

fit

x = predict(fit, mdl.03.train, type = "raw")
table(Actual = mdl.03.train$Texting, Predicted = x)
metric(table(Actual = mdl.03.train$Texting, Predicted = x))

y = predict(fit, mdl.03.test, type = "raw")
table(Actual = mdl.03.test$Texting, Predicted = y)
metric(table(Actual = mdl.03.test$Texting, Predicted = y))

save("fit", file = "R-Models/mdl_03_nnet.rda")
rm(x, y, fit)



################################################################
## Model 4: Differencing with total data set
load("R-Data/data-mdl-04.rda")

fit = train(Texting ~ ., mdl.04.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.04.train, type = "raw")
table(Actual = mdl.04.train$Texting, Predicted = x)
metric(table(Actual = mdl.04.train$Texting, Predicted = x))

y = predict(fit, mdl.04.test, type = "raw")
table(Actual = mdl.04.test$Texting, Predicted = y)
metric(table(Actual = mdl.04.test$Texting, Predicted = y))

save("fit", file = "R-Models/mdl_04_nnet.rda")
rm(x, y, fit)
