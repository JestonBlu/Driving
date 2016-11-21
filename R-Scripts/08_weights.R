rm(list = ls())

library(nnet)

load("R-Data/data-mdl-08.rda")

dummies = model.matrix(~ mdl.08.train$Subject - 1)
colnames(dummies) = sort(as.character(unique(mdl.08.train$Subject)))
mdl.13.train = cbind(dummies, mdl.08.train[, c(2:4,6:13)])

fun = function(x) 1 / (1 + exp(-x))

results = data.frame()

for (i in 1:100) {
  
  fit = nnet(Texting ~  Age_Old * Gender_Male + .,
             data = mdl.13.train,
             range = .1,
             size = 1, 
             maxit = 100, 
             decay = .1)
  
  OM = fit$wts[1] + fit$wts[2] + fit$wts[3] + fit$wts[71]
  YM = fit$wts[1] + fit$wts[3]
  OF = fit$wts[1] + fit$wts[2]
  YF = fit$wts[1]
  B1 = fit$wts[1]
  B2 = fit$wts[72]
  O1 = fit$wts[73]
  
  results = rbind(results, data.frame(Trial = i, OM, YM, OF, YF, B1, B2, O1))
  
}



########################################################
########################################################











