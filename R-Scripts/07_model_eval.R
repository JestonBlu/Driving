library(ggplot2)
library(plyr)
library(reshape2)
library(nnet)
library(caret)

rm(list = ls())


## Load Models
load("R-Models/mdl_01_nnet.rda")
load("R-Models/mdl_02_nnet.rda")
load("R-Models/mdl_02_nnet_expanded.rda")
load("R-Models/mdl_03_nnet.rda")
load("R-Models/mdl_04_nnet.rda")
load("R-Models/mdl_05_nnet.rda")
load("R-Models/mdl_06_nnet.rda")
load("R-Models/mdl_07_nnet.rda")
load("R-Models/mdl_08_nnet.rda")
load("R-Models/mdl_09_nnet.rda")
load("R-Models/mdl_10_nnet.rda")
load("R-Models/mdl_11_nnet.rda")
load("R-Models/mdl_12_nnet.rda")


## Load Data
load("R-Data/data-mdl-01.rda")
load("R-Data/data-mdl-02.rda")
load("R-Data/data-mdl-03.rda")
load("R-Data/data-mdl-04.rda")
load("R-Data/data-mdl-05.rda")
load("R-Data/data-mdl-06.rda")
load("R-Data/data-mdl-07.rda")
load("R-Data/data-mdl-08.rda")
load("R-Data/data-mdl-09.rda")
load("R-Data/data-mdl-10.rda")
load("R-Data/data-mdl-11.rda")
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


perform(fit = mdl.01, train = mdl.01.train, mdl.01.test)
perform(fit = mdl.02, train = mdl.02.train, mdl.02.test)
perform(fit = fit, train = mdl.02.train, mdl.02.test)
perform(fit = mdl.03, train = mdl.03.train, mdl.03.test)
perform(fit = mdl.04, train = mdl.04.train, mdl.04.test)
perform(fit = mdl.05, train = mdl.05.train, mdl.05.test)
perform(fit = mdl.06, train = mdl.06.train, mdl.06.test)
perform(fit = mdl.07, train = mdl.07.train, mdl.07.test)
perform(fit = mdl.08, train = mdl.08.train, mdl.08.test)
perform(fit = mdl.09, train = mdl.09.train, mdl.09.test)
perform(fit = mdl.10, train = mdl.10.train, mdl.10.test)
perform(fit = mdl.11, train = mdl.11.train, mdl.11.test)
perform(fit = mdl.12, train = mdl.12.train, mdl.12.test)
