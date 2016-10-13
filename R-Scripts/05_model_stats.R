rm(list = ls())

library(nnet)
library(randomForest)

load("R-Data/stats.rda")

x = sample(x = nrow(stats), size = round(nrow(stats) * .60), replace = FALSE)


train = stats[x, c(4:5, 7:39)]
test = stats[-x, c(4:5, 7:39)]

mdl.nnet = nnet(formula = texting ~ ., size = 10, data = train)
mdl.rf = randomForest(formula = texting ~ ., ntree = 300, data = train)


results = data.frame(actual = train$texting, nn.pred = predict(mdl.nnet, train, type = "raw"))
results$nn.pred.class = 0; results$nn.pred.class[results$nn.pred > .25] = 1


results$rf.pred = predict(mdl.rf, train, type = "prob")[, 2]
results$rf.pred.class = 0; results$rf.pred.class[results$rf.pred > .2] = 1


table(results$actual, results$nn.pred.class)
table(results$actual, results$rf.pred.class)


results = data.frame(actual = test$texting, nn.pred = predict(mdl.nnet, test, type = "raw"))
results$nn.pred.class = 0; results$nn.pred.class[results$nn.pred > .4] = 1

results$rf.pred = predict(mdl.rf, test, type = "prob")[, 2]
results$rf.pred.class = 0; results$rf.pred.class[results$rf.pred > .15] = 1

table(results$actual, results$nn.pred.class)
table(results$actual, results$rf.pred.class)





