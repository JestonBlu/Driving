rm(list = ls())

library(nnet)
library(ggplot2)
library(plyr)
library(MASS)

f## Train single layer single node model repeatedly and Measure the relationship
## betwen Gender and Age

load("R-Data/data-mdl-08.rda")

dummies = model.matrix(~mdl.08.train$Subject - 1)
colnames(dummies) = sort(as.character(unique(mdl.08.train$Subject)))
mdl.13.train = cbind(dummies, mdl.08.train[, c(2:4, 6:13)])

fun = function(x) 1/(1 + exp(-x))

results = data.frame()

for (i in 1:1000) {

    fit = nnet(Texting ~ Age_Old * Gender_Male + ., data = mdl.13.train, range = 0.0,
        size = 1, maxit = 100, decay = 0.1, trace = FALSE)

    OM = fit$wts[1] + fit$wts[2] + fit$wts[3] + fit$wts[71]
    YM = fit$wts[1] + fit$wts[3]
    OF = fit$wts[1] + fit$wts[2]
    YF = fit$wts[1]
    OM.S = fun(OM)
    YM.S = fun(YM)
    OF.S = fun(OF)
    YF.S = fun(YF)
    OM.O = fun(OM.S * fit$wt[73] + fit$wt[72])
    YM.O = fun(YM.S * fit$wt[73] + fit$wt[72])
    OF.O = fun(OF.S * fit$wt[73] + fit$wt[72])
    YF.O = fun(YF.S * fit$wt[73] + fit$wt[72])

    results = rbind(results, data.frame(Trial = i, OM, YM, OF, YF,
                                        OM.S, YM.S, OF.S, YF.S,
                                        OM.O, YM.O, OF.O, YF.O))
    print(i)

}

hist(results$OM, breaks = 20)
hist(results$YM, breaks = 20)
hist(results$OF, breaks = 20)
hist(results$YF, breaks = 20)

hist(abs(results$OM), breaks = 20)
hist(abs(results$YM), breaks = 20)
hist(abs(results$OF), breaks = 20)
hist(abs(results$YF), breaks = 20)

hist(results$OM / results$YM, breaks = 50, xlim = c(-5, 5))
hist(results$OM / results$YF, breaks = 40, xlim = c(-5, 5))
hist(results$OM / results$OF, breaks = 20)
hist(results$YM / results$YF, breaks = 20)
hist(results$YM / results$OF, breaks = 20)
hist(results$OF / results$YF, breaks = 20)


## Look at the best model
## Treat each node as an individual regresion model
## Look at the distribution of weights for Age and Gender_Male

load("R-Models/mdl_08_nnet.rda")

s2.pos = seq(from = 2, to = 6900, by = 69)
ag.pos = seq(from = 60, to = 6900, by = 69)
gn.pos = seq(from = 61, to = 6900, by = 69)

subject2 = mdl.08$finalModel$wts[s2.pos]
age = mdl.08$finalModel$wts[ag.pos]
gender = mdl.08$finalModel$wts[gn.pos]


hist(age, breaks = 20)
hist(gender, breaks = 20)
summary(subject2)
sqrt(var(subject2))/sqrt(100)
hist(age/gender)

## Sum up the weights from the subjects
x = as.character(unique(mdl.08.train$Subject))
x = sort(x)

sub.weights = data.frame()

for (i in 2:60) {
  i.pos = seq(from = i, to = 6900, by = 69)
  i.wgt = sum(mdl.08$finalModel$wts[i.pos])
  sub.weights = rbind(sub.weights, data.frame(Subject = x[i], Weight = i.wgt))
}

qplot(x = Subject, y = Weight, data = sub.weights) + coord_flip()


## With all variables fixed, how does changing one
## emotion change the probability of a texting event

load("R-Data/data-mdl-08.rda")

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
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral),
               alpha = 0.3) +
  geom_smooth(aes(x = Neutral, y = predict))


ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral),
    alpha = 0.3) +
  geom_smooth(aes(x = Neutral, y = predict)) +
  facet_grid(Age_Old ~
    Gender_Male)


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
  facet_grid(Age_Old ~ Gender_Male)



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


ggplot(test.Contempt) + geom_boxplot(aes(x = Contempt, y = predict, group = Contempt),
    alpha = 0.3) + geom_smooth(aes(x = Contempt, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)



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


ggplot(test.Disgust) + geom_boxplot(aes(x = Disgust, y = predict, group = Disgust),
    alpha = 0.3) + geom_smooth(aes(x = Disgust, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)




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

ggplot(test.Joy) + geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
    geom_smooth(aes(x = Joy, y = predict)) + facet_grid(Age_Old ~ Gender_Male)




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

ggplot(test.Sad) + geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
  geom_smooth(aes(x = Sad, y = predict)) + facet_grid(Age_Old ~ Gender_Male)






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


ggplot(test.Surprise) + geom_boxplot(aes(x = Surprise, y = predict, group = Surprise),
    alpha = 0.3) + geom_smooth(aes(x = Surprise, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)



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




















