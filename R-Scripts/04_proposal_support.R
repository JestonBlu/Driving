library(nnet)

rm(list = ls())
load("R-Data/faces.rda")
load("R-Data/stats.rda")

## Table for checking distirbution of events
x = dcast(ddply(stats, .(Gender, Age, Trial, Event), summarise, count = length(Subject)),
      Gender + Age + Event ~ Trial)
x[is.na(x)] = 0

## Experimental NN on texting trial
x = subset(faces, ID == 'T003-007')
mdl = nnet(factor(Texting) ~ . - ID - Subject - Trial - Age - Gender - Frame -
             Event.Switch - Texting - Event - Time,
           data = x, size = 5)

x$pred = as.numeric(predict(mdl, x, type = "class"))
## Confusion Matrix
table(x$Texting, x$pred)

## Use table model to predict whether someone else is texting
y = subset(faces, ID == 'T004-007')
y$pred = as.numeric(predict(mdl, y, type = "class"))
## Confusion Matrix
table(y$Texting, y$pred)

## Use table model to predict whether someone else is texting
y2 = subset(faces, ID == 'T005-007')
y2$pred = as.numeric(predict(mdl, y2, type = "class"))
table(y2$Texting, y2$pred)
