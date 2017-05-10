library(plyr)
library(reshape2)
library(ggplot2)

rm(list = ls())
load("R-Data/faces.rda")

## Check to make sure there are no observations that dont sum to 1
faces = faces[faces$Trial %in% c('004', '007'), ]
faces$Sum = with(faces, Anger + Contempt + Disgust + Fear + Joy + Sad + Surprise + Neutral)
faces$out = 0
faces$out[faces$Sum < .99 | faces$Sum > 1.01] = 1

## Whats is the percentage that are off?
x = ddply(subset(faces, Trial == '004'), .(Subject, Trial, out), summarise, count = length(Subject))
x = dcast(x, Subject + Trial ~ out)
x$`1`[is.na(x$`1`)] = 0
x$pct = with(x, `1` / (`0` + `1`))

y = ddply(subset(faces, Trial == '007'), .(Subject, Trial, out), summarise, count = length(Subject))
y = dcast(y, Subject + Trial ~ out)
y$`1`[is.na(y$`1`)] = 0
y$pct = with(y, `1` / (`0` + `1`))

suspect.x = subset(x, pct < .5, "Subject")
suspect.y = subset(y, pct < .5, c("Subject", "pct"))

colnames(suspect.y)[2] = "Pct.007"

## Full Join with Pct of records NOT suspect
z = join(suspect.x, suspect.y, type = "full")
z = na.omit(z)

#################################################################################
## Explaination
##
## If more than 50% of observations for each Subject do not add up to close to 1 
## then that subject is removed.
##
## Additional all observations that do not add to one are removed as well
##
## Remainder is 57 Subjects (2 removed)

z = as.character(z$Subject)

faces = subset(faces, out != 1 & Subject %in% z)

## Remove Temporary Vars
faces = faces[, 1:18]


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

## Concentrating on simulations 4 and 7
faces.cen = join(faces, baseline, by = "Subject", type = "inner")

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
faces.cen = faces.cen[, -(19:29)]

## Create indicators for Texting
faces.cen$Texting = 0
faces.cen$Texting[faces.cen$Event == "Texting"] = 1
faces.cen$Texting = factor(faces.cen$Texting)

faces$Texting = 0
faces$Texting[faces$Event %in% c("Texting", "Texting and Talking")] = 1
faces$Texting = factor(faces$Texting)

## Save individual datasets
save(list = "faces.cen", file = "R-Data/faces_cen.rda")
save(list = "baseline", file = "R-Data/baseline.rda")
