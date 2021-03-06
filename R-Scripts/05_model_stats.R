rm(list = ls())

library(knitr)
library(ggplot2)
library(plyr)
library(reshape2)
library(pander)
library(nnet)
library(randomForest)
library(devtools)

load("R-Data/stats.rda")
load("R-Data/faces.rda")
load("R-Data/faces_cen.rda")

## Look at only Trial 007
stats = subset(stats, Trial %in% c('007'))

## Split data into training and testing sets
x = sample(x = nrow(stats), size = round(nrow(stats) * .60), replace = FALSE)

train = stats[x, c(4:5, 7:47)]
test = stats[-x, c(4:5, 7:47)]

## Neural Net
mdl.nnet = nnet(formula = texting ~ ., size = 15, data = train)

## Random Forest
mdl.rf = randomForest(formula = texting ~ ., ntree = 1000, data = train)

## NN prediction
results = data.frame(actual = train$texting, nn.pred = predict(mdl.nnet, train, type = "raw"))
results$nn.pred.class = 0; results$nn.pred.class[results$nn.pred > .5] = 1

## RF prediction
results$rf.pred = predict(mdl.rf, train, type = "prob")[, 2]
results$rf.pred.class = 0; results$rf.pred.class[results$rf.pred > .5] = 1

## Performance Metric
metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + (3 * specificity)) / 4
  return(score)
}

## Training set performance
table(results$actual, results$nn.pred.class)
metric(table(results$actual, results$nn.pred.class))
table(results$actual, results$rf.pred.class)
metric(table(results$actual, results$rf.pred.class))

## Testing set: NN Prediction
results = data.frame(actual = test$texting, nn.pred = predict(mdl.nnet, test, type = "raw"))
results$nn.pred.class = 0; results$nn.pred.class[results$nn.pred > .5] = 1

## Testing set: RF Prediction
results$rf.pred = predict(mdl.rf, test, type = "prob")[, 2]
results$rf.pred.class = 0; results$rf.pred.class[results$rf.pred > .5] = 1

## Testing set performance
table(actual = results$actual, predicted = results$nn.pred.class)
metric(table(actual = results$actual, predicted = results$nn.pred.class))
table(actual = results$actual, predicted = results$rf.pred.class)
metric(table(actual = results$actual, predicted = results$rf.pred.class))


#####################################################################################
## Plots of differences in demographics summary statistics

ggplot(train, aes(x = Gender, color = texting, y = mu_Neutral)) +
  geom_boxplot() +
  facet_wrap(~Age)

ggplot(train, aes(x = Gender, color = texting, y = var_Neutral)) +
  geom_boxplot() +
  facet_wrap(~Age)

ggplot(train, aes(x = Gender, color = texting, y = mu_Disgust)) +
  geom_boxplot() +
  facet_wrap(~Age)

ggplot(train, aes(x = Gender, color = texting, y = mu_Fear)) +
  geom_boxplot() +
  facet_wrap(~Age)

ggplot(train, aes(x = Gender, color = texting, y = iqr_Neutral)) +
  geom_boxplot() +
  facet_wrap(~Age)


## Plot of neural net
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')

#plot each model
plot.nnet(mdl.nnet)

#####################################################################################
## Presentation plots

## Original Data
x = subset(faces, Trial == '007' | Trial == '004')
x = melt(x, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy",
                          "Sad", "Surprise", "Neutral"))

## Young Male
ggplot(subset(x, Subject == 'T002'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()

## Centered Data
x2 = subset(faces.cen, Trial == '007' | Trial == '004')
x2 = melt(x2, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
          measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy",
                           "Sad", "Surprise", "Neutral"))

## Young Male
ggplot(subset(x2, Subject == 'T002'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()

## Summary table of stats by gender, age
stats = subset(stats, Trial %in% '007')
x3 = stats[, c(1:6, 42, 44, 47)]
x3[, 7:8] = round(x3[, 7:8], 3)
x3

## Distribution of IQR by event
ggplot(x3, aes(x = iqr_Neutral, color = Event)) +
  geom_density()

## Distribution of MU by event
ggplot(x3, aes(x = mu_Neutral, color = Event)) +
  geom_density()


############################################################################
## Suspected crash list

## crash?
x = dcast(ddply(subset(faces, Trial %in% c('004', '007')), .(Subject, Trial, Gender, Age), summarise, 
                count = max(Time) / 60), Age + Gender + Subject ~ Trial)
x = na.omit(x)
x = arrange(x, Subject)

x$est_kph_004 = with(x, 10.9 / `004` * 60)
x$est_kph_007 = with(x, 10.9 / `007` * 60)
x


crash.list = c("T060", "T061", "T064", "T066", "T073", "T074", "T076", "T077", "T079", "T080",
               "T081", "T082", "T083", "T084", "T086", "T088")

y1 = x$est_kph_004[x$Subject %in% crash.list]
y2 = x$est_kph_004[!(x$Subject %in% crash.list)]

## How different are the two distributions?
plot(density(y1), col = "blue", xlim = c(40, 75), ylim = c(0, .25)) ## Suspected Crash
lines(density(y2), col = "red") ## Everyone Else

y1 = x$est_kph_004[x$Subject %in% crash.list]
y2 = x$est_kph_007[x$Subject %in% crash.list]

## How different are the speed differences between trials?
plot(density(y1), col = "blue", xlim = c(40, 75), ylim = c(0, .25)) ## Suspected Crash
lines(density(y2), col = "red") ## Everyone Else

## Statistically Different?
ks.test(y1, y2)
