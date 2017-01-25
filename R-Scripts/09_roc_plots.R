library(ROCR)
library(ggplot2)

roc.curves = data.frame()
auc.scores = data.frame()




##########################################################################
## MODEL 12
load("R-Models/Itr_100/mdl_12_nnet.rda")
load("R-Data/data-mdl-12.rda")

pred = as.numeric(predict(mdl.12, mdl.12.test, type = "prob")[,2])
clss = as.numeric(mdl.12.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 12", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 12", auc = x3)

### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


ggplot(roc.curves) +
  geom_line(aes(x = x, y = y, color = Model))


###########################################################################
## MODEL 08
load("R-Models/Itr_100/mdl_08_nnet.rda")
load("R-Data/data-mdl-08.rda")

pred = as.numeric(predict(mdl.08, mdl.08.test, type = "prob")[,2])
clss = as.numeric(mdl.08.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 08", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 08", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)

###########################################################################
## MODEL 02
load("R-Models/Itr_100/mdl_02_nnet.rda")
load("R-Data/data-mdl-02.rda")

pred = as.numeric(predict(mdl.02, mdl.02.test, type = "prob")[,2])
clss = as.numeric(mdl.02.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 02", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 02", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)

###########################################################################
## MODEL 11
load("R-Models/Itr_100/mdl_11_nnet.rda")
load("R-Data/data-mdl-11.rda")

pred = as.numeric(predict(mdl.11, mdl.11.test, type = "prob")[,2])
clss = as.numeric(mdl.11.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 11", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 11", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)

###########################################################################
## MODEL 07
load("R-Models/Itr_100/mdl_07_nnet.rda")
load("R-Data/data-mdl-07.rda")

pred = as.numeric(predict(mdl.07, mdl.07.test, type = "prob")[,2])
clss = as.numeric(mdl.07.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 07", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 07", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 01
load("R-Models/Itr_100/mdl_01_nnet.rda")
load("R-Data/data-mdl-01.rda")

pred = as.numeric(predict(mdl.01, mdl.01.test, type = "prob")[,2])
clss = as.numeric(mdl.01.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 01", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 01", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 10
load("R-Models/Itr_100/mdl_10_nnet.rda")
load("R-Data/data-mdl-10.rda")

pred = as.numeric(predict(mdl.10, mdl.10.test, type = "prob")[,2])
clss = as.numeric(mdl.10.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 10", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 10", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 09
load("R-Models/Itr_100/mdl_09_nnet.rda")
load("R-Data/data-mdl-09.rda")

pred = as.numeric(predict(mdl.09, mdl.09.test, type = "prob")[,2])
clss = as.numeric(mdl.09.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 09", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 09", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 04
load("R-Models/Itr_100/mdl_04_nnet.rda")
load("R-Data/data-mdl-04.rda")

pred = as.numeric(predict(mdl.04, mdl.04.test, type = "prob")[,2])
clss = as.numeric(mdl.04.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 04", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 04", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)

###########################################################################
## MODEL 06
load("R-Models/Itr_100/mdl_06_nnet.rda")
load("R-Data/data-mdl-06.rda")

pred = as.numeric(predict(mdl.06, mdl.06.test, type = "prob")[,2])
clss = as.numeric(mdl.06.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 06", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 06", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 03
load("R-Models/Itr_100/mdl_03_nnet.rda")
load("R-Data/data-mdl-03.rda")

pred = as.numeric(predict(mdl.03, mdl.03.test, type = "prob")[,2])
clss = as.numeric(mdl.03.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 03", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 03", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


###########################################################################
## MODEL 05
load("R-Models/Itr_100/mdl_05_nnet.rda")
load("R-Data/data-mdl-05.rda")

pred = as.numeric(predict(mdl.05, mdl.05.test, type = "prob")[,2])
clss = as.numeric(mdl.05.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 05", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 05", auc = x3)


### COMBINE
roc.curves = rbind(roc.curves, y1)
auc.scores = rbind(auc.scores, y2)


##########################################################################
## LONGER TRAINED MODELS

roc.curves.long = data.frame()
auc.scores.long = data.frame()

###########################################################################
## MODEL 08 -- 250
load("R-Models/Itr_250/mdl_08_nnet.rda")
load("R-Data/data-mdl-08.rda")

pred = as.numeric(predict(mdl.08, mdl.08.test, type = "prob")[,2])
clss = as.numeric(mdl.08.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 08 250 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 08 250 Itr", auc = x3)


### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)



##########################################################################
## MODEL 12 -- 500
load("R-Models/Itr_250/mdl_12_nnet.rda")
load("R-Data/data-mdl-12.rda")

pred = as.numeric(predict(mdl.12, mdl.12.test, type = "prob")[,2])
clss = as.numeric(mdl.12.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 12 250 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 12 250 Itr", auc = x3)

### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)


###########################################################################
## MODEL 08 -- 500
load("R-Models/Itr_500/mdl_08_nnet.rda")
load("R-Data/data-mdl-08.rda")

pred = as.numeric(predict(mdl.08, mdl.08.test, type = "prob")[,2])
clss = as.numeric(mdl.08.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 08 500 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 08 500 Itr", auc = x3)


### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)



##########################################################################
## MODEL 12 -- 500
load("R-Models/Itr_500/mdl_12_nnet.rda")
load("R-Data/data-mdl-12.rda")

pred = as.numeric(predict(mdl.12, mdl.12.test, type = "prob")[,2])
clss = as.numeric(mdl.12.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 12 500 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 12 500 Itr", auc = x3)

### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)



###########################################################################
## MODEL 08 -- 1000
load("R-Models/Itr_1000/mdl_08_nnet.rda")
load("R-Data/data-mdl-08.rda")

pred = as.numeric(predict(mdl.08, mdl.08.test, type = "prob")[,2])
clss = as.numeric(mdl.08.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 08 1000 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 08 1000 Itr", auc = x3)


### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)



##########################################################################
## MODEL 12 -- 1000
load("R-Models/Itr_1000/mdl_12_nnet.rda")
load("R-Data/data-mdl-12.rda")

pred = as.numeric(predict(mdl.12, mdl.12.test, type = "prob")[,2])
clss = as.numeric(mdl.12.test$Texting)

x1 = prediction(pred, clss)
x2 = performance(x1, "tpr", "fpr")
x2a = x2@x.values[[1]]
x2b = x2@y.values[[1]]
x3 = performance(x1, "auc")
(x3 = x3@y.values[[1]])

y1 = data.frame(Model = "Model 12 1000 Itr", x = x2a, y = x2b)
y2 = data.frame(Model = "Model 12 1000 Itr", auc = x3)

### COMBINE
roc.curves.long = rbind(roc.curves.long, y1)
auc.scores.long = rbind(auc.scores.long, y2)

save(list = c("auc.scores", "auc.scores.long", "roc.curves", "roc.curves.long"), 
     file = "R-Data/roc.rda")

rm(list = ls())


#########################################################################
## ROC Plots
library(ggplot2)
library(scales)
library(gridExtra)

load("R-Data/roc.rda")

g1 = ggplot(roc.curves, aes(x = x, y = y, color = Model)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, lty = 2, size = .5) +
  scale_x_continuous("False Positive Rate", labels = percent) +
  scale_y_continuous("True Positive Rate", labels = percent) +
  ggtitle("Area Under Curve\n100 Iteration Models") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Presentation/Plots/ROC1.png", plot = g1, width = 7, height = 5)

roc.curves.best = rbind(subset(roc.curves, Model %in% c("Model 08", "Model 12")), roc.curves.long)

g2 = ggplot(roc.curves.best, aes(x = x, y = y, color = Model)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, lty = 2, size = .5) +
  scale_x_continuous("False Positive Rate", labels = percent) +
  scale_y_continuous("True Positive Rate", labels = percent) +
  ggtitle("Area Under Curve\nBest Models") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Presentation/Plots/ROC2.png", plot = g2, width = 7, height = 5)
