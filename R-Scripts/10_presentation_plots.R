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
x$Trial[x$Trial == '004'] = 'Trial 4 (Baseline)'
x$Trial[x$Trial == '007'] = 'Trial 7 (Texting)'
x$Trial = factor(x$Trial)

## Example Young Male -- Original
g1 = ggplot(subset(x, Subject == 'T001'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 01", subtitle = "Baseline and Texting Trials") +
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
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 02", subtitle = "Baseline and Texting Trials") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_02.png", plot = g2, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_02.png", plot = g2, width = 13, height = 5)

## Example Young Male -- Original
g3 = ggplot(subset(x, Subject == 'T003'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 03", subtitle = "Baseline and Texting Trials") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_03.png", plot = g3, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_03.png", plot = g3, width = 13, height = 5)

## Example Young Female -- Original
g4 = ggplot(subset(x, Subject == 'T004'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 04", subtitle = "Baseline and Texting Trials") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_04.png", plot = g4, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_04.png", plot = g4, width = 13, height = 5)


## Example Old Male -- Original (worst subject accuracy)
g5 = ggplot(subset(x, Subject == 'T038'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 38", subtitle = "Baseline and Texting Trials") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_38_worst.png", plot = g5, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_38_worst.png", plot = g5, width = 13, height = 5)

## Example Old Male -- Original (worst subject accuracy)
g6 = ggplot(subset(x, Subject == 'T022'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03, size = .5) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_x_continuous("Time") +
  scale_y_continuous("Emotional Likelihood") +
  scale_color_manual("", values = c("gray50", "#f0b823", "blue" , "red")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject 22", subtitle = "Baseline and Texting Trials") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))

ggsave(filename = "Plots/Texting_vs_Baseline_22_best.png", plot = g6, width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_22_best.png", plot = g6, width = 13, height = 5)


##
## ALL SUBJECTS: Sim 0 vs Sim 7... intended to show increased variability between trials
##

y = subset(faces.cen, Trial == '007' | Trial == '004')
y = melt(y, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy",
                          "Sad", "Surprise", "Neutral"))

y$Trial = as.character(y$Trial)
y$Trial[y$Trial == '004'] = 'Trial 4 (Baseline)'
y$Trial[y$Trial == '007'] = 'Trial 7 (Texting)'
y$Trial = factor(y$Trial)


g7 = ggplot(subset(y, Trial == 'Trial 4 (Baseline)'), aes(x = Time, y = value, group = Subject)) +
  geom_smooth(se = FALSE, size = .1) +
  facet_wrap(~variable)

g8 = ggplot(subset(y, Trial == 'Trial 7 (Texting)'), aes(x = Time, y = value, group = Subject)) +
  geom_smooth(se = FALSE, size = .1) +
  facet_wrap(~variable)

ggsave(filename = "Plots/Texting_vs_Baseline_all.png", 
       plot = grid.arrange(g7, g8, nrow = 1), 
       width = 13, height = 5)
ggsave(filename = "docs/Plots/Texting_vs_Baseline_all.png", 
       plot = grid.arrange(g7, g8, nrow = 1), 
       width = 13, height = 5)

