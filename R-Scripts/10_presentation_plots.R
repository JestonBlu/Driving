library(plyr)
library(reshape2)
library(ggplot2)
library(gridExtra)

rm(list = ls())
load("R-Data/faces.rda")
load("R-Data/faces_cen.rda")


## SUBJECT 001: Control vs Texting Events... intended to show differences between the trials
## particularly during the texting even window

## Compare regular drive to the texting drive
x = subset(faces, Trial == '007' | Trial == '004')
x = melt(x, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy",
                          "Sad", "Surprise", "Neutral"))

x$Trial = as.character(x$Trial)
x$Trial[x$Trial == '004'] = 'LOESS Baseline Trial'
x$Trial[x$Trial == '007'] = 'LOESS Texting Trial'
x$Trial = factor(x$Trial)

## Example Young Male -- Original
g1 = ggplot(subset(x, Subject == 'T001'), aes(x = Time, y = value, group = Trial)) +
  geom_point(alpha = .03, size = .5, aes(color = Event)) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle(label = "Baseline Trial vs Texting Trial", subtitle = "Subject 01") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_01.png", plot = g1, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_01.png", plot = g1, width = 13, height = 5)

## Example Young Female -- Original
g2 = ggplot(subset(x, Subject == 'T002'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 02") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_02.png", plot = g2, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_02.png", plot = g2, width = 11, height = 6)

## Example Young Male -- Original
g3 = ggplot(subset(x, Subject == 'T003'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 03") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_03.png", plot = g3, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_03.png", plot = g3, width = 11, height = 6)

## Example Young Female -- Original
g4 = ggplot(subset(x, Subject == 'T004'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 04") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_04.png", plot = g4, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_04.png", plot = g4, width = 13, height = 6)


## Example Old Female -- Original (worst subject accuracy)
g5 = ggplot(subset(x, Subject == 'T034'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 34") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_25_worst.png", plot = g5, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_25_worst.png", plot = g5, width = 11, height = 6)

## Example Young Female -- Best overall accuracy
g6 = ggplot(subset(x, Subject == 'T022'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 22") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_22_best.png", plot = g6, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_22_best.png", plot = g6, width = 11, height = 6)


##
## ALL SUBJECTS: Sim 0 vs Sim 7... intended to show increased variability between trials
##

y = subset(faces.cen, Trial == '007' | Trial == '004')
y = melt(y, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy",
                          "Sad", "Surprise", "Neutral"))

y$Trial = as.character(y$Trial)
y$Trial[y$Trial == '004'] = 'LOESS Baseline Trial'
y$Trial[y$Trial == '007'] = 'LOESS Texting Trial'
y$Trial = factor(y$Trial)


g7 = ggplot(subset(y, Trial == 'LOESS Baseline Trial'), aes(x = Time, y = value, group = Subject)) +
  geom_smooth(se = FALSE, size = .1) +
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood Centered", limits = c(-1, 1)) +
  ggtitle("Baseline Trial", subtitle = "All Subjects") +
  theme(plot.title = element_text(hjust = .5), plot.subtitle = element_text(hjust = .5)) +
  facet_wrap(~variable)

g8 = ggplot(subset(y, Trial == 'LOESS Texting Trial'), aes(x = Time, y = value, group = Subject)) +
  geom_smooth(se = FALSE, size = .1) +
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood Centered on Baseline", limits = c(-1, 1)) +
  ggtitle("Texting Trial", subtitle = "All Subjects") +
  theme(plot.title = element_text(hjust = .5), plot.subtitle = element_text(hjust = .5)) +
  facet_wrap(~variable)

ggsave(filename = "Plots/Texting_vs_Baseline_all.png", 
       plot = grid.arrange(g7, g8, nrow = 1), 
       width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_all.png", 
       plot = grid.arrange(g7, g8, nrow = 1), 
       width = 13, height = 5)


##
## Total Variation comparison
##

a = ddply(y, .(Subject, Age, Gender,  Trial, variable), summarise, var = var(value))

a$AG = paste(a$Age, a$Gender, sep = "")

a$Trial = as.character(a$Trial)
a$Trial[a$Trial == 'LOESS Baseline Trial'] = 'Baseline Trial'
a$Trial[a$Trial == 'LOESS Texting Trial'] = 'Texting Trial'
a$Trial = factor(a$Trial, levels = c("Baseline Trial", "Texting Trial"))

g9 = ggplot(a, aes(x = Trial, y = var)) +
  geom_boxplot(size = .3, outlier.size = .5) +
  scale_y_continuous("Variance") +
  ggtitle("Box Plots of Variance by Subject") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_by_Trial.png", plot = g9, width = 7, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_by_Trial.png", plot = g9, width = 7, height = 7)

g10 = ggplot(a, aes(x = AG, y = var)) +
  geom_boxplot(aes(color = Trial), size = .3, outlier.size = .5) +
  scale_y_continuous("Variance") +
  scale_x_discrete("Age/Gender") +
  scale_color_discrete("") +
  ggtitle("Box Plots of Variance by Subject") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_by_Trial_AgeGender.png", plot = g10, width = 13, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_by_Trial_AgeGender.png", plot = g10, width = 13, height = 7)

b = ddply(subset(y, Trial == 'LOESS Texting Trial'), .(Subject, Age, Gender, Event, variable), summarise, var = var(value))

b$AG = paste(b$Age, b$Gender, sep = "")

g11 = ggplot(b, aes(x = Event, y = var)) +
  geom_boxplot(size = .3, outlier.size = .5) +
  scale_y_continuous("Variance") +
  ggtitle("Box Plots of Variance by Subject", subtitle = "Texting Trial") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_Texting_Trial.png", plot = g11, width = 7, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_Texting_Trial.png", plot = g11, width = 7, height = 7)






##
## Model Accuracy
##

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


load("R-Data/data-mdl-08.rda")
load("R-Models/Itr_1000/mdl_08_nnet.rda")
stimuli = read.csv("Files/data-stimuli.csv")


mdl.08.test$Predict = predict(mdl.08, mdl.08.test, type = "raw")
y = predict(mdl.08, mdl.08.test, type = "prob")[2]
mdl.08.test$Prob = y = as.numeric(y$`1`)

mdl.08.test$Predict = revalue(x = mdl.08.test$Predict, replace = c('0' = 'Not Texting', '1' = 'Texting'))

sub = 'T001'
x = subset(mdl.08.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Predict", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]
y3 = y[1,1]; y4 = y[1, 2]

g1 = ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  annotate(geom = "rect", xmin = y3, xmax = y4, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  geom_smooth(aes(y = Prob), se = FALSE, size = .5, span = .2) +
  geom_point(alpha = .25, aes(color = Predict)) +
  scale_x_continuous("") +
  scale_y_continuous("Likelihood Centered on Baseline") +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 01: Accuracy 80%") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Prediction_Subject001.png", plot = g1, width = 13, height = 5)
ggsave(filename = "docs/Plots/Prediction_Subject001.png", plot = g1, width = 13, height = 5)


sub = 'T002'
x = subset(mdl.08.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Predict", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]
y3 = y[1,1]; y4 = y[1, 2]

g2 = ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  annotate(geom = "rect", xmin = y3, xmax = y4, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  geom_smooth(aes(y = Prob), se = FALSE, size = .5, span = .2) +
  geom_point(alpha = .25, aes(color = Predict)) +
  scale_x_continuous("") +
  scale_y_continuous("Likelihood Centered on Baseline") +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 02: Accuracy 69%") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Prediction_Subject002.png", plot = g2, width = 13, height = 5)
ggsave(filename = "docs/Plots/Prediction_Subject002.png", plot = g2, width = 11, height = 6)

sub = 'T003'
x = subset(mdl.08.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Predict", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]
y3 = y[1,1]; y4 = y[1, 2]

g3 = ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  annotate(geom = "rect", xmin = y3, xmax = y4, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  geom_smooth(aes(y = Prob), se = FALSE, size = .5, span = .2) +
  geom_point(alpha = .25, aes(color = Predict)) +
  scale_x_continuous("") +
  scale_y_continuous("Likelihood Centered on Baseline") +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 03: Accuracy 88%") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Prediction_Subject003.png", plot = g3, width = 13, height = 5)
ggsave(filename = "docs/Plots/Prediction_Subject003.png", plot = g3, width = 11, height = 6)


sub = 'T022'
x = subset(mdl.08.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Predict", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]
y3 = y[1,1]; y4 = y[1, 2]

g4 = ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  annotate(geom = "rect", xmin = y3, xmax = y4, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  geom_smooth(aes(y = Prob), se = FALSE, size = .5, span = .2) +
  geom_point(alpha = .25, aes(color = Predict)) +
  scale_x_continuous("") +
  scale_y_continuous("Likelihood Centered on Baseline") +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 22: Accuracy 96%") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Prediction_Subject022.png", plot = g4, width = 13, height = 5)
ggsave(filename = "docs/Plots/Prediction_Subject022.png", plot = g4, width = 11, height = 6)


sub = 'T034' 
x = subset(mdl.08.test, Subject == sub)
x = melt(x, id.vars = c("Subject", "Age_Old", "Gender_Male", "Texting", "Predict", "Prob", "Time"))
y = subset(stimuli, ID == paste(sub,'-007', sep = ''))
y1 = y[2,1]; y2 = y[2, 2]
y3 = y[1,1]; y4 = y[1, 2]

g5 = ggplot(x, aes(x = Time, y = value)) +
  annotate(geom = "rect", xmin = y1, xmax = y2, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  annotate(geom = "rect", xmin = y3, xmax = y4, ymin = -Inf, ymax = Inf, fill = "gray50", alpha = .4) +
  geom_smooth(aes(y = Prob), se = FALSE, size = .5, span = .2) +
  geom_point(alpha = .25, aes(color = Predict)) +
  scale_x_continuous("") +
  scale_y_continuous("Likelihood Centered on Baseline") +
  scale_color_manual("Prediction", values = c("black", "#f0b923")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 34: Accuracy 64%") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Prediction_Subject034.png", plot = g5, width = 13, height = 5)
ggsave(filename = "docs/Plots/Prediction_Subject034.png", plot = g5, width = 11, height = 6)



load("R-Data/data-mdl-08.rda")
load("R-Models/Itr_1000/mdl_08_nnet.rda")
stimuli = read.csv("Files/data-stimuli.csv")

library(plyr)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(pander)
library(caret)


mdl.08.train$Predict = predict(mdl.08, mdl.08.train, type = "raw")
mdl.08.test$Predict = predict(mdl.08, mdl.08.test, type = "raw")

subject = as.character(unique(mdl.08.train$Subject))

tab = data.frame()

for (i in 1:56) {
  y1 = subset(mdl.08.train, Subject == subject[i])
  y2 = subset(mdl.08.test, Subject == subject[i])

  x1 = confusionMatrix(reference = y1$Texting, data = y1$Predict, positive = "1")$byClass[11]
  x2 = confusionMatrix(reference = y2$Texting, data = y2$Predict, positive = "1")$byClass[11]

  tab = rbind(tab, data.frame(Subject = subject[i], 
                              Train = x1, 
                              Test = x2,
                              GenderMale = y2$Gender_Male[1],
                              AgeOld = y2$Age_Old[1]))

}

tab = arrange(tab, desc(Test))
tab$GenderAge = "Old Female"
tab$GenderAge[tab$GenderMale == 1 & tab$AgeOld == 0] = 'Young Male'
tab$GenderAge[tab$GenderMale == 0 & tab$AgeOld == 0] = 'Young Female'
tab$GenderAge[tab$GenderMale == 1 & tab$AgeOld == 1] = 'Old Male'

g9 = ggplot(tab, aes(x = GenderAge, y = Test)) +
  geom_boxplot() +
  geom_point() +
  scale_y_continuous("Testing Accuracy") +
  scale_x_discrete("Age and Gender") +
  ggtitle("Boxplots of Testing Accuracy by Subject") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "docs/Plots/Boxplots_Testing_Accuracy_By_Age_Gender.png", 
       plot = g9, height = 9, width = 6)
ggsave(filename = "Plots/Boxplots_Testing_Accuracy_By_Age_Gender.png", 
       plot = g9, height = 9, width = 6)

library(car)

head(tab)

mdl = glm(Test ~ factor(GenderMale)*factor(AgeOld), data = tab)
mdl2 = glm(Test ~ factor(GenderMale) + factor(AgeOld), data = tab)
mdl3 = glm(Test ~ factor(GenderAge), data = tab)

anova(mdl, mdl2,mdl3)
AIC(mdl, mdl2, mdl3)

x = data.frame(GenderAge = tab$GenderAge, Residuals = mdl2$residuals)

leveneTest(Test ~ factor(GenderMale), data = tab, center = "median")
leveneTest(Residuals ~ GenderAge, data = x)

tab = tab[, -6]

tab$Train = round(tab$Train, 3)
tab$Test = round(tab$Test, 3)
subject = as.character(tab$Subject)

tab2 = t(tab)
tab2 = data.frame(tab2)
colnames(tab2) = subject
tab2 = tab2[-1, ]

pander(tab2, split.table = 150)





## Relative Importance
gar.fun<-function(out.var,mod.in,bar.plot=T,struct=NULL,x.lab=NULL,
                  y.lab=NULL, wts.only = F){
  
  require(ggplot2)
  require(plyr)
  
  # function works with neural networks from neuralnet, nnet, and RSNNS package
  # manual input vector of weights also okay
  
  #sanity checks
  if('numeric' %in% class(mod.in)){
    if(is.null(struct)) stop('Three-element vector required for struct')
    if(length(mod.in) != ((struct[1]*struct[2]+struct[2]*struct[3])+(struct[3]+struct[2])))
      stop('Incorrect length of weight matrix for given network structure')
    if(substr(out.var,1,1) != 'Y' | 
       class(as.numeric(gsub('^[A-Z]','', out.var))) != 'numeric')
      stop('out.var must be of form "Y1", "Y2", etc.')
  }
  if('train' %in% class(mod.in)){
    if('nnet' %in% class(mod.in$finalModel)){
      mod.in<-mod.in$finalModel
      warning('Using best nnet model from train output')
    }
    else stop('Only nnet method can be used with train object')
  }
  
  #gets weights for neural network, output is list
  #if rescaled argument is true, weights are returned but rescaled based on abs value
  nnet.vals<-function(mod.in,nid,rel.rsc,struct.out=struct){
    
    require(scales)
    require(reshape)
    
    if('numeric' %in% class(mod.in)){
      struct.out<-struct
      wts<-mod.in
    }
    
    #neuralnet package
    if('nn' %in% class(mod.in)){
      struct.out<-unlist(lapply(mod.in$weights[[1]],ncol))
      struct.out<-struct.out[-length(struct.out)]
      struct.out<-c(
        length(mod.in$model.list$variables),
        struct.out,
        length(mod.in$model.list$response)
      )      	
      wts<-unlist(mod.in$weights[[1]])   
    }
    
    #nnet package
    if('nnet' %in% class(mod.in)){
      struct.out<-mod.in$n
      wts<-mod.in$wts
    }
    
    #RSNNS package
    if('mlp' %in% class(mod.in)){
      struct.out<-c(mod.in$nInputs,mod.in$archParams$size,mod.in$nOutputs)
      hid.num<-length(struct.out)-2
      wts<-mod.in$snnsObject$getCompleteWeightMatrix()
      
      #get all input-hidden and hidden-hidden wts
      inps<-wts[grep('Input',row.names(wts)),grep('Hidden_2',colnames(wts)),drop=F]
      inps<-melt(rbind(rep(NA,ncol(inps)),inps))$value
      uni.hids<-paste0('Hidden_',1+seq(1,hid.num))
      for(i in 1:length(uni.hids)){
        if(is.na(uni.hids[i+1])) break
        tmp<-wts[grep(uni.hids[i],rownames(wts)),grep(uni.hids[i+1],colnames(wts)),drop=F]
        inps<-c(inps,melt(rbind(rep(NA,ncol(tmp)),tmp))$value)
      }
      
      #get connections from last hidden to output layers
      outs<-wts[grep(paste0('Hidden_',hid.num+1),row.names(wts)),grep('Output',colnames(wts)),drop=F]
      outs<-rbind(rep(NA,ncol(outs)),outs)
      
      #weight vector for all
      wts<-c(inps,melt(outs)$value)
      assign('bias',F,envir=environment(nnet.vals))
    }
    
    if(nid) wts<-rescale(abs(wts),c(1,rel.rsc))
    
    #convert wts to list with appropriate names 
    hid.struct<-struct.out[-c(length(struct.out))]
    row.nms<-NULL
    for(i in 1:length(hid.struct)){
      if(is.na(hid.struct[i+1])) break
      row.nms<-c(row.nms,rep(paste('hidden',i,seq(1:hid.struct[i+1])),each=1+hid.struct[i]))
    }
    row.nms<-c(
      row.nms,
      rep(paste('out',seq(1:struct.out[length(struct.out)])),each=1+struct.out[length(struct.out)-1])
    )
    out.ls<-data.frame(wts,row.nms)
    out.ls$row.nms<-factor(row.nms,levels=unique(row.nms),labels=unique(row.nms))
    out.ls<-split(out.ls$wts,f=out.ls$row.nms)
    
    assign('struct',struct.out,envir=environment(nnet.vals))
    
    out.ls
    
  }
  
  # get model weights
  best.wts<-nnet.vals(mod.in,nid=F,rel.rsc=5,struct.out=NULL)
  
  # weights only if T
  if(wts.only) return(best.wts)
  
  #get variable names from mod.in object
  #change to user input if supplied
  if('numeric' %in% class(mod.in)){
    x.names<-paste0(rep('X',struct[1]),seq(1:struct[1]))
    y.names<-paste0(rep('Y',struct[3]),seq(1:struct[3]))
  }
  if('mlp' %in% class(mod.in)){
    all.names<-mod.in$snnsObject$getUnitDefinitions()
    x.names<-all.names[grep('Input',all.names$unitName),'unitName']
    y.names<-all.names[grep('Output',all.names$unitName),'unitName']
  }
  if('nn' %in% class(mod.in)){
    x.names<-mod.in$model.list$variables
    y.names<-mod.in$model.list$response
  }
  if('xNames' %in% names(mod.in)){
    x.names<-mod.in$xNames
    y.names<-attr(terms(mod.in),'factor')
    y.names<-row.names(y.names)[!row.names(y.names) %in% x.names]
  }
  if(!'xNames' %in% names(mod.in) & 'nnet' %in% class(mod.in)){
    if(is.null(mod.in$call$formula)){
      x.names<-colnames(eval(mod.in$call$x))
      y.names<-colnames(eval(mod.in$call$y))
    }
    else{
      forms<-eval(mod.in$call$formula)
      x.names<-mod.in$coefnames
      facts<-attr(terms(mod.in),'factors')
      y.check<-mod.in$fitted
      if(ncol(y.check)>1) y.names<-colnames(y.check)
      else y.names<-as.character(forms)[2]
    } 
  }
  
  # get index value for response variable to measure
  if('numeric' %in% class(mod.in)){
    out.ind <-  as.numeric(gsub('^[A-Z]','',out.var))
  } else {
    out.ind<- grep(out.var, y.names)
  }
  
  #change variables names to user sub 
  if(!is.null(x.lab)){
    if(length(x.names) != length(x.lab)) stop('x.lab length not equal to number of input variables')
    else x.names<-x.lab
  }
  if(!is.null(y.lab)){
    y.names<-y.lab
  } else {
    y.names <- y.names[grep(out.var, y.names)]
  }
  
  # organize hidden layer weights for matrix mult
  inp.hid <- best.wts[grep('hidden', names(best.wts))]
  split_vals <- substr(names(inp.hid), 1, 8)
  inp.hid <- split(inp.hid, split_vals)
  inp.hid <- lapply(inp.hid, function(x) t(do.call('rbind', x))[-1, ])
  
  # final layer weights for output
  hid.out<-best.wts[[grep(paste('out',out.ind),names(best.wts))]][-1]
  
  # matrix multiplication of output layer with connecting hidden layer
  max_i <- length(inp.hid)
  sum_in <- as.matrix(inp.hid[[max_i]]) %*% matrix(hid.out)
  
  # recursive matrix multiplication for all remaining hidden layers
  # only for multiple hidden layers
  if(max_i != 1){ 
    
    for(i in (max_i - 1):1) sum_in <- as.matrix(inp.hid[[i]]) %*% sum_in
    
    # final contribution vector for all inputs
    inp.cont <- sum_in    
    
  } else {
    
    inp.cont <- sum_in
    
  }
  
  #get relative contribution
  #inp.cont/sum(inp.cont)
  rel.imp<-{
    signs<-sign(inp.cont)
    signs*rescale(abs(inp.cont),c(0,1))
  }
  
  if(!bar.plot){
    out <- data.frame(rel.imp)
    row.names(out) <- x.names
    return(out)
  }
  
  to_plo <- data.frame(rel.imp,x.names)[order(rel.imp),,drop = F]
  to_plo$x.names <- factor(x.names[order(rel.imp)], levels = x.names[order(rel.imp)])
  out_plo <- ggplot(to_plo, aes(x = x.names, y = rel.imp, fill = rel.imp,
                                colour = rel.imp)) + 
    geom_bar(stat = 'identity') + 
    scale_x_discrete(element_blank()) +
    scale_y_continuous(y.names)
  
  return(out_plo)
  
}

# rel.imp = gar.fun(out.var = "Texting", mod.in = mdl.08$finalModel, bar.plot = FALSE)
# rel.imp$Subject = row.names(rel.imp)
# rel.imp$Subject = gsub(pattern = "Subject", replacement = "", x = rel.imp$Subject)
# rel.imp2 = rel.imp
# 
# rel.imp = rel.imp[-(grep("T", rel.imp$Subject)), ]
# 
# g1 = ggplot(rel.imp, aes(x = reorder(Subject, rel.imp), y = rel.imp)) +
#   geom_bar(stat = "identity") +
#   scale_y_continuous("Relative Importance") +
#   scale_x_discrete("") +
#   coord_flip() +
#   ggtitle("Relative Importance") +
#   theme(plot.title = element_text(hjust = .5))
# 
# ggsave(filename = "Plots/Relative_Importance.png", plot = g1, width = 7, height = 5)
# ggsave(filename = "docs/Plots/Relative_Importance.png", plot = g1, width = 7, height = 5)
# 







