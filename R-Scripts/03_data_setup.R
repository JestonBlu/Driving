library(plyr)
library(reshape2)
library(ggplot2)

rm(list = ls())
load("R-Data/faces.rda")

## Calculate the baseline
baseline = ddply(subset(faces, Trial == '004'),
                 .(Subject, Age, Gender), summarise,
                 mu_Anger = mean(Anger),
                 mu_Contempt = mean(Contempt),
                 mu_Disgust = mean(Disgust),
                 mu_Fear = mean(Fear),
                 mu_Joy = mean(Joy),
                 mu_Sad = mean(Sad),
                 mu_Surprise = mean(Surprise),
                 mu_Neutral = mean(Neutral))

## Concentrating on simulations 4-7
faces.cen = faces[faces$Trial %in% c('004', '005', '006', '007'), ]
faces.cen = join(faces.cen, baseline, by = "Subject", type = "inner")

## Center all emotions
faces.cen$Anger = with(faces.cen, Anger - mu_Anger)
faces.cen$Contempt = with(faces.cen, Contempt - mu_Contempt)
faces.cen$Disgust = with(faces.cen, Disgust - mu_Disgust)
faces.cen$Fear = with(faces.cen, Fear - mu_Fear)
faces.cen$Joy = with(faces.cen, Joy - mu_Joy)
faces.cen$Sad = with(faces.cen, Sad - mu_Sad)
faces.cen$Surprise = with(faces.cen, Surprise - mu_Surprise)
faces.cen$Neutral = with(faces.cen, Neutral - mu_Neutral)

## Remove unneeded columsn
faces.cen = faces.cen[, -(19:28)]

## Calculate the average value and variance for each trial, event, expression
stats = ddply(faces.cen, .(Subject, Trial, Event, Age, Gender, Event.Switch), summarise,
              mu_Anger = mean(Anger),
              var_Anger = var(Anger),
              iqr_Anger = IQR(Anger),
              min_Anger = min(Anger),
              max_Anger = max(Anger),
              mu_Contempt = mean(Contempt),
              var_Contempt = var(Contempt),
              iqr_Contempt = IQR(Contempt),
              min_Contempt = min(Contempt),
              max_Contempt = max(Contempt),
              mu_Disgust = mean(Disgust),
              var_Disgust = var(Disgust),
              iqr_Disgust = IQR(Disgust),
              min_Disgust = min(Disgust),
              max_Disgust = max(Disgust),
              mu_Fear = mean(Fear),
              var_Fear = var(Fear),
              iqr_Fear = IQR(Fear),
              min_Fear = min(Fear),
              max_Fear = max(Fear),
              mu_Joy = mean(Joy),
              var_Joy = var(Joy),
              iqr_Joy = IQR(Joy),
              min_Joy = min(Joy),
              max_Joy = max(Joy),
              mu_Sad = mean(Sad),
              var_Sad = var(Sad),
              iqr_Sad = IQR(Sad),
              min_Sad = min(Sad),
              max_Sad = max(Sad),
              mu_Surprise = mean(Surprise),
              var_Surprise = var(Surprise),
              iqr_Surprise = IQR(Surprise),
              min_Surprise = min(Surprise),
              max_Surprise = max(Surprise),
              mu_Neutral = mean(Neutral),
              var_Neutral = var(Neutral),
              iqr_Neutral = IQR(Neutral),
              min_Neutral = min(Neutral),
              max_Neutral = max(Neutral)
              )

## Create indicators for Texting
faces.cen$Texting = 0
faces.cen$Texting[faces.cen$Event %in% c("Texting", "Texting and Talking")] = 1
faces.cen$Texting = factor(faces.cen$Texting)

faces$Texting = 0
faces$Texting[faces$Event %in% c("Texting", "Texting and Talking")] = 1
faces$Texting = factor(faces$Texting)

stats$texting = 0
stats$texting[stats$Event %in% c("Texting", "Texting and Talking")] = 1
stats$texting = factor(stats$texting)

## Save individual datasets
save(list = "faces", file = "R-Data/faces.rda")
save(list = "stats", file = "R-Data/stats.rda")
save(list = "baseline", file = "R-Data/baseline.rda")
save(list = "faces.cen", file = "R-Data/faces_cen.rda")
