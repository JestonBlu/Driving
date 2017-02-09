library(plyr)
library(reshape2)
library(ggplot2)
library(gridExtra)

rm(list = ls())
load("R-Data/faces.rda")
load("R-Data/faces_cen.rda")


##
## SUBJECT 001: Control vs Texting Events... intended to show differences between the trials
## particularly during the texting even window
##

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


## Example Old Male -- Original (worst subject accuracy)
g5 = ggplot(subset(x, Subject == 'T038'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Baseline and Texting Trials", subtitle = "Subject 38") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_38_worst.png", plot = g5, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_38_worst.png", plot = g5, width = 11, height = 6)

## Example Old Male -- Original (worst subject accuracy)
g6 = ggplot(subset(x, Subject == 'T022'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
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
  ggtitle("Boxplots of Variance by Subject") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_by_Trial.png", plot = g9, width = 7, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_by_Trial.png", plot = g9, width = 7, height = 7)

g10 = ggplot(a, aes(x = AG, y = var)) +
  geom_boxplot(aes(color = Trial), size = .3, outlier.size = .5) +
  scale_y_continuous("Variance") +
  scale_x_discrete("Age/Gender") +
  scale_color_discrete("") +
  ggtitle("Boxplots of Variance by Subject") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_by_Trial_AgeGender.png", plot = g10, width = 13, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_by_Trial_AgeGender.png", plot = g10, width = 13, height = 7)

b = ddply(subset(y, Trial == 'LOESS Texting Trial'), .(Subject, Age, Gender, Event, variable), summarise, var = var(value))

b$AG = paste(b$Age, b$Gender, sep = "")

g11 = ggplot(b, aes(x = Event, y = var)) +
  geom_boxplot(size = .3, outlier.size = .5) +
  scale_y_continuous("Variance") +
  ggtitle("Boxplots of Variance by Subject", subtitle = "Texting Trial") +
  facet_wrap(~variable, scale = "free") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Boxplots_Variance_Texting_Trial.png", plot = g11, width = 7, height = 7)
ggsave(filename = "docs/Plots/Boxplots_Variance_Texting_Trial.png", plot = g11, width = 7, height = 7)

















