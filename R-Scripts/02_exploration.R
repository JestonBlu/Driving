library(plyr)
library(reshape2)
library(ggplot2)

rm(list = ls())
load("R-Data/faces.rda")

## 8 Total Simulations, not all of the Subjects have data for every simulation

## What are the total frames by Sim per Subject?
summary(dcast(ddply(faces, .(Subject, Trial), summarise, count = length(ID)), Subject ~ Trial))

summary(subset(dcast(ddply(faces, .(Subject, Trial), summarise, count = length(ID)), Subject ~ Trial),
       is.na(`006`) == FALSE & is.na(`007`) == FALSE))

## What are the crash events
ddply(faces, .(Event), summarise, count = length(ID))



x = subset(faces, Trial == '007' | Trial == '004')
x = melt(x, id.vars = c("Subject", "Age", "Gender", "Time", "Event", "Event.Switch", "Trial"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy", 
                          "Sad", "Surprise", "Neutral"))

## Young Male
ggplot(subset(x, Subject == 'T001'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()

## Young Female
ggplot(subset(x, Subject == 'T002'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()


## Old Female
ggplot(subset(x, Subject == 'T027'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()

## Old Male
ggplot(subset(x, Subject == 'T045'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("Event", values = c("blue" , "red", "gray50", "#f0b823")) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("") +
  theme()


## Old Female
ggplot(subset(x, Subject == 'T086'), aes(x = Time, y = value, group = Trial, color = Event)) +
  geom_point(alpha = .03) +
  geom_smooth(size = .2, aes(color = Trial))+
  scale_color_manual("", labels = c("Sim 004 (No Events)", 
                                    "Sim 007 (Texting Events)", 
                                    "No Event", "Texting Event"), 
                     values = c("blue" , "red", "gray50", "#f0b823")) +
  scale_x_continuous("Seconds") +
  scale_y_continuous("Emotional Likelihood", breaks = c(0, .5, 1)) +
  facet_wrap(~variable) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1))) +
  ggtitle("Subject T086 (Old Female)\nSim 004 (No Events) and Sim 007 (Texting Events)") +
  theme()







x = subset(faces, Subject == 'T001')
x = melt(x, id.vars = c("Subject", "Trial", "Age", "Gender", "Time", "Event"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy", 
                          "Sad", "Surprise", "Neutral"))

ggplot(x, aes(x = Time, y = value, color = Event)) +
  geom_point(alpha = .05, size = .25) +
  facet_grid(Trial~variable) +
  scale_color_brewer(type = "qual", palette = 2) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))




x = subset(faces.cen, Trial %in% c('004', '005', '006', '007') & Subject == 'T001')
x = melt(x, id.vars = c("Subject", "Trial", "Age", "Gender", "Time", "Event"),
         measure.vars = c("Anger", "Contempt", "Disgust", "Fear", "Joy", 
                          "Sad", "Surprise", "Neutral"))

ggplot(x, aes(x = Time, y = value, color = Event)) +
  geom_point(alpha = .05, size = .25) +
  facet_grid(Trial~variable) +
  scale_color_brewer(type = "qual", palette = 2) +
  guides(colour = guide_legend(override.aes = list(alpha = 1, size = 1)))
