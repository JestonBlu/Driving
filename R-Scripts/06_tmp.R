library(neuralnet)

rm(list = ls())

load("R-Data/stats.rda")

stats = subset(stats, Trial == '007')

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}


##
x = sample(x = nrow(stats), size = round(nrow(stats) * .6), replace = FALSE)


stats$Age_Old = ifelse(stats$Age == 'O', 1, 0)
stats$Gender_Male = ifelse(stats$Gender == 'M', 1, 0)

texting = as.numeric(stats$texting)-1

stats = stats[, c(7:46, 48:49)]

stats.max = apply(stats, 2, max)
stats.min = apply(stats, 2, min)

stats = data.frame(scale(stats, scale = stats.max - stats.min))

stats$texting = texting

n = names(stats)
f = as.formula(paste("texting ~", paste(n[!n %in% "texting"], collapse = " + ")))

train = stats[x, ]
test = stats[-x, ]

mdl.nn = neuralnet(f, train, hidden = c(20, 10), err.fct = "sse", likelihood = TRUE, act.fct = 'logistic')


results = round(compute(mdl.nn, test[, 1:42])$net.result, 3)
results[results < 0] = 0
results[results > 1] = 1
results = data.frame(
  pred = results
)

results$pred.class = ifelse(results$pred > .5, 1, 0)
results$Actual = test$texting
metric(table(Actual = results$Actual, Prediction = results$pred.class))


#######################################################################

library(ggplot2)
library(plyr)
library(reshape2)

rm(list = ls())

## Model Performance Metric
metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}


load("R-Data/data-ml.rda")
load("R-Models/nnet_total.rda")
stimuli = read.csv("Files/data-stimuli.csv")

ml.test$Prediction = predict(fit, ml.test, type = "raw")
y = predict(fit, ml.test, type = "prob")[2]
ml.test$Prob = y = as.numeric(y$`1`)




sub = 'T001'
x = subset(ml.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Prediction", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]

ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) + 
  geom_smooth(aes(y = Prob), se = FALSE, span = .1) +
  geom_point(alpha = .02, aes(color = Prediction)) +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))




sub = 'T002'
x = subset(ml.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Prediction", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]

ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) + 
  geom_smooth(aes(y = Prob), se = FALSE, span = .1) +
  geom_point(alpha = .02, aes(color = Prediction)) +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))




sub = 'T003'
x = subset(ml.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Prediction", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]

ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) + 
  geom_smooth(aes(y = Prob), se = FALSE, span = .1) +
  geom_point(alpha = .02, aes(color = Prediction)) +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))



sub = 'T004'
x = subset(ml.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Prediction", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]

ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) + 
  geom_smooth(aes(y = Prob), se = FALSE, span = .1) +
  geom_point(alpha = .02, aes(color = Prediction)) +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))



subject = as.character(unique(ml.test$Subject))

metric(table(ml.test$Texting, ml.test$Prediction))


