rm(list = ls())

library(nnet)
library(ggplot2)
library(plyr)
library(MASS)
library(devtools)
library(gridExtra)


load("R-Models/Itr_1000/mdl_08_nnet.rda")
load("R-Data/data-mdl-08.rda")


####################################################################################
## With all variables fixed, how does changing one
## emotion change the probability of a texting event

## Neutral

x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Contempt = 0, Disgust = 0, Fear = 0,
    Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Neutral = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Neutral = i
    test.Neutral = rbind(test.Neutral, x)
}

test.Neutral$predict = predict(mdl.08, test.Neutral, type = "prob")[, 2]

ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.7) +
  geom_smooth(aes(x = Neutral, y = predict))


ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.7) +
  geom_smooth(aes(x = Neutral, y = predict)) +
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))


## Change Anger, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Neutral = 0, Contempt = 0, Disgust = 0, Fear = 0,
    Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Anger = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Anger = i
    test.Anger = rbind(test.Anger, x)
}

test.Anger$predict = predict(mdl.08, test.Anger, type = "prob")[, 2]

ggplot(test.Anger) + geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.3) +
  geom_smooth(aes(x = Anger, y = predict))

ggplot(test.Anger) + geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.3) +
  geom_smooth(aes(x = Anger, y = predict)) +
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))



## Change Contempt, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Contempt = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Contempt = i
    test.Contempt = rbind(test.Contempt, x)
}

test.Contempt$predict = predict(mdl.08, test.Contempt, type = "prob")[, 2]


ggplot(test.Contempt) +
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.3) +
  geom_smooth(aes(x = Contempt, y = predict))


ggplot(test.Contempt) + 
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.3) + 
  geom_smooth(aes(x = Contempt, y = predict)) + 
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))



## Change Disgust, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Disgust = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Disgust = i
    test.Disgust = rbind(test.Disgust, x)
}

test.Disgust$predict = predict(mdl.08, test.Disgust, type = "prob")[, 2]

ggplot(test.Disgust) +
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.3) +
  geom_smooth(aes(x = Disgust, y = predict))


ggplot(test.Disgust) + 
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.3) + 
  geom_smooth(aes(x = Disgust, y = predict)) + 
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))




## Change Fear, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Fear = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Fear = i
    test.Fear = rbind(test.Fear, x)
}

test.Fear$predict = predict(mdl.08, test.Fear, type = "prob")[, 2]


ggplot(test.Fear) + geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.3) +
  geom_smooth(aes(x = Fear, y = predict))

ggplot(test.Fear) + geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.3) +
    geom_smooth(aes(x = Fear, y = predict)) + facet_grid(Age_Old ~ Gender_Male)



## Change Joy, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Joy = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Joy = i
    test.Joy = rbind(test.Joy, x)
}

test.Joy$predict = predict(mdl.08, test.Joy, type = "prob")[, 2]

ggplot(test.Joy) + geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
  geom_smooth(aes(x = Joy, y = predict))

ggplot(test.Joy) + 
  geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
  geom_smooth(aes(x = Joy, y = predict)) + 
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))




## Change Sad, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Sad = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Sad = i
    test.Sad = rbind(test.Sad, x)
}

test.Sad$predict = predict(mdl.08, test.Sad, type = "prob")[, 2]

ggplot(test.Sad) + geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
    geom_smooth(aes(x = Sad, y = predict))

ggplot(test.Sad) + 
  geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
  geom_smooth(aes(x = Sad, y = predict)) + 
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))






## Change Surprise, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Surprise = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Surprise = i
    test.Surprise = rbind(test.Surprise, x)
}

test.Surprise$predict = predict(mdl.08, test.Surprise, type = "prob")[, 2]

ggplot(test.Surprise) +
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.3) +
  geom_smooth(aes(x = Surprise, y = predict))


ggplot(test.Surprise) + 
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.3) +
  geom_smooth(aes(x = Surprise, y = predict)) + 
  facet_grid(Age_Old ~ Gender_Male, labeller = labeller(.rows = label_both, .cols = label_both))


#############################
## combine all of the tests

test.Sad$Pred = 0
test.Sad$Pred[test.Sad$predict > .5] = 1
test.Surprise$Pred = 0
test.Surprise$Pred[test.Surprise$predict > .5] = 1
test.Joy$Pred = 0
test.Joy$Pred[test.Joy$predict > .5] = 1
test.Fear$Pred = 0
test.Fear$Pred[test.Fear$predict > .5] = 1
test.Disgust$Pred = 0
test.Disgust$Pred[test.Disgust$predict > .5] = 1
test.Contempt$Pred = 0
test.Contempt$Pred[test.Contempt$predict > .5] = 1
test.Anger$Pred = 0
test.Anger$Pred[test.Anger$predict > .5] = 1
test.Neutral$Pred = 0
test.Neutral$Pred[test.Neutral$predict > .5] = 1

mdl.Sad = glm(Pred ~ Age_Old * Gender_Male * Sad, data = test.Sad, family = binomial())
mdl.Surprise = glm(Pred ~ Age_Old * Gender_Male * Surprise, data = test.Surprise, family = binomial())
mdl.Joy = glm(Pred ~ Age_Old * Gender_Male * Joy, data = test.Joy, family = binomial())
mdl.Fear = glm(Pred ~ Age_Old * Gender_Male * Fear, data = test.Fear, family = binomial())
mdl.Disgust = glm(Pred ~ Age_Old * Gender_Male * Disgust, data = test.Disgust, family = binomial())
mdl.Contempt = glm(Pred ~ Age_Old * Gender_Male * Contempt, data = test.Contempt, family = binomial())
mdl.Anger = glm(Pred ~ Age_Old * Gender_Male * Anger, data = test.Anger, family = binomial())
mdl.Neutral = glm(Pred ~ Age_Old * Gender_Male * Neutral, data = test.Neutral, family = binomial())

summary(aov(mdl.Neutral))
summary(aov(mdl.Surprise))
summary(aov(mdl.Anger))
summary(aov(mdl.Disgust))
summary(aov(mdl.Fear))
summary(aov(mdl.Sad))
summary(aov(mdl.Joy))
summary(aov(mdl.Contempt))



  
#############################



## Test distributions
hist(results$OM); summary(results$OM)
hist(abs(results$OM)); summary(results$OM)

x = qunif(p = seq(.01, .99, length.out = 1000), min = -9, max = 9)

plot(x = x, y = sort(results$OM))
lines(x = x, y = x)


hist(results$YM); summary(results$YM)
hist(abs(results$YM)); summary(results$YM)


hist(results$OF); summary(results$OF)
hist(abs(results$OF)); summary(results$OF)

hist(results$YF); summary(results$YF)
hist(abs(results$YF)); summary(results$YF)

## Relationships
hist(results$OM/results$YM, breaks = 50); 
summary(results$OM/results$YM); sd(results$OM/results$YM)/1000

hist(results$OM/results$YF, breaks = 50); 
summary(results$OM/results$YF); sd(results$OM/results$YF)/1000

hist(results$OM/results$OF, breaks = 50); 
summary(results$OM/results$OF); sd(results$OM/results$OF)/1000

hist(results$YM/results$YF, breaks = 50); 
summary(results$YM/results$YF); sd(results$YM/results$YF)/1000

hist(results$YM/results$OF, breaks = 50); 
summary(results$YM/results$OF); sd(results$YM/results$OF)/1000

hist(results$OF/results$YF, breaks = 50); 
summary(results$OF/results$YF); sd(results$OF/results$YF)/1000


## Look at relative importance by accuracy



## Presentation Plots
x1 = ggplot(test.Anger) +
  geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.7) +
  geom_smooth(aes(x = Anger, y = predict)) +
  scale_y_continuous("Probability")

x2 = ggplot(test.Contempt) +
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.7) +
  geom_smooth(aes(x = Contempt, y = predict)) +
  scale_y_continuous("Probability")

x3 = ggplot(test.Disgust) +
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.7) +
  geom_smooth(aes(x = Disgust, y = predict)) +
  scale_y_continuous("Probability")

x4 = ggplot(test.Fear) +
  geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.7) +
  geom_smooth(aes(x = Fear, y = predict)) +
  scale_y_continuous("Probability")

x5 = ggplot(test.Joy) +
  geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.7) +
  geom_smooth(aes(x = Joy, y = predict)) +
  scale_y_continuous("Probability")

x6 = ggplot(test.Sad) +
  geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.7) +
  geom_smooth(aes(x = Sad, y = predict)) +
  scale_y_continuous("Probability")

x7 = ggplot(test.Surprise) +
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.7) +
  geom_smooth(aes(x = Surprise, y = predict)) +
  scale_y_continuous("Probability")

x8 = ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.7) +
  geom_smooth(aes(x = Neutral, y = predict)) +
  scale_y_continuous("Probability")


grid.arrange(x1, x2, x3, x4, x5, x6, x7, x8, nrow = 4)




######################################################################

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}

mdl.08.train$Predict = predict(mdl.08, mdl.08.train, type = "raw")
mdl.08.test$Predict = predict(mdl.08, mdl.08.test, type = "raw")

subject = as.character(unique(mdl.08.train$Subject))

tab = data.frame()

for (i in 1:59) {
  y1 = subset(mdl.08.train, Subject == subject[i])
  y2 = subset(mdl.08.test, Subject == subject[i])
  
  x1 = metric(table(Actual = y1$Texting, Predicted = y1$Predict))
  x2 = metric(table(Actual = y2$Texting, Predicted = y2$Predict))
  
  tab = rbind(tab, data.frame(Subject = subject[i], Train = x1, Test = x2))
  
}

tab = arrange(tab, desc(Test))
tab$Train = round(tab$Train, 3)
tab$Test = round(tab$Test, 3)
subject = as.character(tab$Subject)

rel.imp2 = na.omit(join(rel.imp, tab))
qplot(x = rel.imp, y = Train, data = rel.imp2) + geom_smooth(method = "lm", se = FALSE)
cor(rel.imp2$Train, rel.imp2$rel.imp)
