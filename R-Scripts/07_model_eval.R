library(ggplot2)
library(plyr)
library(reshape2)
library(nnet)
library(caret)

rm(list = ls())


## Load Models
load("R-Models/Itr_500/mdl_02_nnet.rda")
load("R-Models/Itr_500/mdl_08_nnet.rda")
load("R-Models/Itr_500/mdl_12_nnet.rda")


## Load Data
load("R-Data/data-mdl-02.rda")
load("R-Data/data-mdl-08.rda")
load("R-Data/data-mdl-12.rda")


## Model Performance Metrics
metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}

perform = function(fit, train, test) {
  
  x = predict(fit, train, type = "raw")
  y = predict(fit, test, type = "raw")

  results = list (
    "Max Iterations:" = fit$dots$maxit,
    "Algorithm Converged" = fit$finalModel$convergence,
    "Confusion Matrix Training Set: " = table(Actual = train$Texting, Predicted = x),
    "Training Set Performance: " = metric(table(Actual = train$Texting, Predicted = x)),
    "Confusion Matrix: Testing Set: " = table(Actual = test$Texting, Predicted = y),
    "Testing Set Performance: " = metric(table(Actual = test$Texting, Predicted = y))
  )
  return(results)
}


perform(fit = mdl.02, train = mdl.02.train, mdl.02.test)
perform(fit = mdl.08, train = mdl.08.train, mdl.08.test)
perform(fit = mdl.12, train = mdl.12.train, mdl.12.test)
