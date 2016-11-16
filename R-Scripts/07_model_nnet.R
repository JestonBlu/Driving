library(nnet)
library(caret)
library(plyr)
library(doMC)

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
                          size = c(1, 5, 15, 30, 50, 75, 100))

## Limit the iterations and weights each model can run
maxIt = 100; maxWt = 15000



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

mdl.01 = fit

save("mdl.01", file = "R-Models/mdl_01_nnet.rda")
rm(x, y, fit, mdl.01, mdl.01.train, mdl.01.test)


#############################################################
## Model 2: 
##
## Data Set:       Sample from total simulation 
## Exclusions:     Time
## Execution Time: Smaller: 12 hours, Expanded: 60 hours
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


mdl.02 = fit

save("mdl.02", file = "R-Models/mdl_02_nnet.rda")
rm(x, y, fit, mdl.02, mdl.02.train, mdl.02.test)



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


mdl.03 = fit

save("mdl.03", file = "R-Models/mdl_03_nnet.rda")
rm(x, y, fit, mdl.03, mdl.03.train, mdl.03.test)


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


mdl.04 = fit

save("mdl.04", file = "R-Models/mdl_04_nnet.rda")
rm(x, y, fit, mdl.04, mdl.04.train, mdl.04.test)


################################################################
## Model 5: Differencing with Moving Average 365 Split
load("R-Data/data-mdl-05.rda")

fit = train(Texting ~ ., mdl.05.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.05.train, type = "raw")
table(Actual = mdl.05.train$Texting, Predicted = x)
metric(table(Actual = mdl.05.train$Texting, Predicted = x))

y = predict(fit, mdl.05.test, type = "raw")
table(Actual = mdl.05.test$Texting, Predicted = y)
metric(table(Actual = mdl.05.test$Texting, Predicted = y))


mdl.05 = fit

save("mdl.05", file = "R-Models/mdl_05_nnet.rda")
rm(x, y, fit, mdl.05, mdl.05.train, mdl.05.test)


################################################################
## Model 6: Differencing with Moving Average, entire sim
load("R-Data/data-mdl-06.rda")

fit = train(Texting ~ ., mdl.06.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.06.train, type = "raw")
table(Actual = mdl.06.train$Texting, Predicted = x)
metric(table(Actual = mdl.06.train$Texting, Predicted = x))

y = predict(fit, mdl.06.test, type = "raw")
table(Actual = mdl.06.test$Texting, Predicted = y)
metric(table(Actual = mdl.06.test$Texting, Predicted = y))


mdl.06 = fit

save("mdl.06", file = "R-Models/mdl_06_nnet.rda")
rm(x, y, fit, mdl.06, mdl.06.train, mdl.06.test)



################################################################
## Model 7: Averaging values over fixed .5 seconds
load("R-Data/data-mdl-07.rda")

fit = train(Texting ~ . - Time, mdl.07.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.07.train, type = "raw")
table(Actual = mdl.07.train$Texting, Predicted = x)
metric(table(Actual = mdl.07.train$Texting, Predicted = x))

y = predict(fit, mdl.07.test, type = "raw")
table(Actual = mdl.07.test$Texting, Predicted = y)
metric(table(Actual = mdl.07.test$Texting, Predicted = y))


mdl.07 = fit

save("mdl.07", file = "R-Models/mdl_07_nnet.rda")
rm(x, y, fit, mdl.07, mdl.07.train, mdl.07.test)



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
## Model 9: Averaging values over fixed .5 seconds, differenced
load("R-Data/data-mdl-09.rda")

fit = train(Texting ~ ., mdl.09.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.09.train, type = "raw")
table(Actual = mdl.09.train$Texting, Predicted = x)
metric(table(Actual = mdl.09.train$Texting, Predicted = x))

y = predict(fit, mdl.09.test, type = "raw")
table(Actual = mdl.09.test$Texting, Predicted = y)
metric(table(Actual = mdl.09.test$Texting, Predicted = y))


mdl.09 = fit

save("mdl.09", file = "R-Models/mdl_09_nnet.rda")
rm(x, y, fit, mdl.09, mdl.09.train, mdl.09.test)



################################################################
## Model 10: Averaging values over fixed .5 seconds, differenced
load("R-Data/data-mdl-10.rda")

fit = train(Texting ~ ., mdl.10.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)
fit

x = predict(fit, mdl.10.train, type = "raw")
table(Actual = mdl.10.train$Texting, Predicted = x)
metric(table(Actual = mdl.10.train$Texting, Predicted = x))

y = predict(fit, mdl.10.test, type = "raw")
table(Actual = mdl.10.test$Texting, Predicted = y)
metric(table(Actual = mdl.10.test$Texting, Predicted = y))


mdl.10 = fit

save("mdl.10", file = "R-Models/mdl_09_nnet.rda")
rm(x, y, fit, mdl.10, mdl.10.train, mdl.10.test) 



#############################################################
## Model 11: 
##
## Data Set:   
## Specifics:  Train First Half, Test Second Half
## 
load("R-Data/data-mdl-11.rda")

fit = train(Texting ~ . - Time, mdl.11.train, method = "nnet", 
            trControl = fit.control, 
            tuneGrid = search.grid,
            MaxNWts = maxWt,
            maxit = maxIt)

fit

x = predict(fit, mdl.11.train, type = "raw")
table(Actual = mdl.11.train$Texting, Predicted = x)
metric(table(Actual = mdl.11.train$Texting, Predicted = x))

y = predict(fit, mdl.11.test, type = "raw")
table(Actual = mdl.11.test$Texting, Predicted = y)
metric(table(Actual = mdl.11.test$Texting, Predicted = y))

mdl.11 = fit

save("mdl.11", file = "R-Models/mdl_11_nnet.rda")
rm(x, y, fit, mdl.11, mdl.11.train, mdl.11.test)


#############################################################
## Model 12: 
##
## Data Set:   
## Specifics:  Train First Half, Test Second Half
## 
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




#############################################################
## Model 13: 
##
## Simplified Model for Relationship Diagnostics
## 
load("R-Data/data-mdl-08.rda")

# ## Create combination of model parameters to train on
# search.grid = expand.grid(decay = c(0, .1, .2), size = 1)
# 
# ## Limit the iterations and weights each model can run
# maxIt = 1000; maxWt = 15000
# 
# 
# fit = train(Texting ~ . - Time, mdl.08.train, method = "nnet", 
#             trControl = fit.control, 
#             tuneGrid = search.grid,
#             MaxNWts = maxWt,
#             maxit = maxIt)
# 
# fit

fit = nnet(Texting ~ Subject + Age_Old * Gender_Male + Anger + Contempt + Disgust + 
             Fear + Joy + Sad + Surprise + Neutral, 
           mdl.08.train, size = 1, maxit = 1000)

x = predict(fit, mdl.08.train, type = "class")
table(Actual = mdl.08.train$Texting, Predicted = x)
metric(table(Actual = mdl.08.train$Texting, Predicted = x))

y = predict(fit, mdl.08.test, type = "class")
table(Actual = mdl.08.test$Texting, Predicted = y)
metric(table(Actual = mdl.08.test$Texting, Predicted = y))

mdl.13 = fit

save("mdl.13", file = "R-Models/mdl_13_nnet.rda")
rm(x, y, fit, mdl.13, mdl.08.train, mdl.08.test)
