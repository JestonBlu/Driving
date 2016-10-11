rm(list = ls())

library(nnet)

load("R-Data/faces_cen.rda")

sub = subset(faces.cen, ID == 'T001-007')
train = sub[1:12000, c(7, 10:18)]
test = sub[nrow(train):nrow(sub), c(7, 10:18)]

sub2 = subset(faces.cen, ID == 'T003-007')
train2 = sub2[1:12000, c(7, 10:18)]
test2 = sub2[nrow(train2):nrow(sub2), c(7, 10:18)]

train3 = rbind(sub[1:12000, c(2, 7, 10:18)], sub2[1:12000, c(2, 7, 10:18)])
test3 = rbind(sub[nrow(train):nrow(sub), c(2, 7, 10:18)], 
              sub2[nrow(train2):nrow(sub2), c(2, 7, 10:18)])

mdl.nn = nnet(Texting ~ . - Time + time(Time), size = 1, maxit = 100, data = train)

mdl.nn2 = nnet(Texting ~ . - Time, size = 2, maxit = 200, data = train3)

results.train = data.frame(actual = train$Texting, pred = predict(mdl.nn, train, type = "raw"))
results.train$pred.class = 0; results.train$pred.class[results.train$pred > .4] = 1

results.test = data.frame(actual = test$Texting, pred = predict(mdl.nn, test, type = "raw"))
results.test$pred.class = 0; results.test$pred.class[results.test$pred > .4] = 1

results.test2 = data.frame(actual = test2$Texting, pred = predict(mdl.nn, test2, type = "raw"))
results.test2$pred.class = 0; results.test2$pred.class[results.test2$pred > .4] = 1

results.train3 = data.frame(actual = train3$Texting, pred = predict(mdl.nn2, train3, type = "raw"))
results.train3$pred.class = 0; results.train3$pred.class[results.train3$pred > .4] = 1

results.test3 = data.frame(actual = test3$Texting, pred = predict(mdl.nn2, test3, type = "raw"))
results.test3$pred.class = 0; results.test3$pred.class[results.test3$pred > .4] = 1



table(results.train$actual, results.train$pred.class)
table(results.test$actual, results.test$pred.class)
table(results.test2$actual, results.test2$pred.class)
table(results.train3$actual, results.train3$pred.class)
table(results.test3$actual, results.test3$pred.class)


