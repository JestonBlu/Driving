## Data Prep for Neural Net Learning

rm(list = ls())

library(plyr)
library(ggplot2)
library(TTR)

load("R-Data/faces_cen.rda")
stimuli = read.csv("Files/data-stimuli.csv")



## Only look at Texting simulations
texting.sim = subset(faces.cen, Trial == '007', c(2, 4:5, 7, 10:19))
stimuli = subset(stimuli, substr(stimuli$ID, 6, 8) == '007' & Action.Type == 4)


## Where do the second texting events occur for each subject?
text1 = stimuli[seq(1, 129, 2), c("ID", "StartTime", "EndTime")]
colnames(text1) = c("ID", "FirstEventStart", "FirstEventEnd")
  
text2 = stimuli[seq(2, 130, 2), c("ID", "StartTime", "EndTime")]
colnames(text2) = c("ID", "SecondEventStart", "SecondEventEnd")

text = join(text1, text2)
text$ID = substr(text$ID, 1, 4)
rm(text1, text2)

# plot(density(text$FirstEventEnd), col = "blue", xlim = c(150, 620))
# lines(density(text$SecondEventStart), col = "red")

## When did the sim end?
sim.max = ddply(texting.sim, .(ID = Subject), summarise, TrialEnd = max(Time))
text = join(text, sim.max, type = "left")
text = na.omit(text)
rm(sim.max)

## Some subjects have event files, but dont have sim data
keep = as.character(text$ID)

## Did a crash occur during a texting event?
text$Diff = with(text, TrialEnd - SecondEventEnd)

crash.list = c("T060", "T061", "T064", "T066", "T073", "T074", "T076", "T077", "T079", "T080",
               "T081", "T082", "T083", "T084", "T086", "T088")

text$SuspectedCrash = "N"
text$SuspectedCrash[text$ID %in% crash.list] = "Y"
rm(crash.list)

# qplot(x = text$TrialEnd, y = text$Diff, col = text$SuspectedCrash)
# summary(text)



########################################################################################
## Prepare the Training and Testing Sets for the various models
##
## All data starts with by using the faces_cen data set which is the 007 Sim centered
## on the 004 baseline sim
##
texting.sim$Subject = as.character(texting.sim$Subject)
texting.sim = texting.sim[texting.sim$Subject %in% keep, ]
texting.sim$Age_Old = ifelse(texting.sim$Age == 'O', 1, 0)
texting.sim$Gender_Male = ifelse(texting.sim$Gender == 'M', 1, 0)
texting.sim = texting.sim[, c(1, 15:16, 4, 6:14)]
texting.sim$Subject = factor(texting.sim$Subject)

## The data set on which all models data sets are based
save(list = "texting.sim", file = 'R-Data/data-mdl-00.rda')

rm(keep, text, stimuli, faces.cen)

#########################################################################################
## Model 01: Scale the data after splitting the simulation in half
##
## The last first event occurs at 262 seconds
## The first last event occurs at 331 seconds
## The training set and testing set will be split on
## (331-262) / 2 + 331 = 365
##
## All variables scaled between 0 and 1
mdl.01.train = subset(texting.sim, Time <= 365)
y.max = apply(mdl.01.train[, 5:12], 2, max)
y.min = apply(mdl.01.train[, 5:12], 2, min)
mdl.01.train[, 5:12] = scale(mdl.01.train[, 5:12], scale = y.max - y.min)

mdl.01.test = subset(texting.sim, Time > 365)
y.max = apply(mdl.01.test[, 5:12], 2, max)
y.min = apply(mdl.01.test[, 5:12], 2, min)
mdl.01.test[, 5:12] = scale(mdl.01.test[, 5:12], scale = y.max - y.min)

save(list = c("mdl.01.train", "mdl.01.test"), file = "R-Data/data-mdl-01.rda")
rm(y.max, y.min)



########################################################################################
## Model 02: Sample from total simulation
set.seed(1123)
x = sample(nrow(texting.sim), nrow(texting.sim)/2)

mdl.02.train = texting.sim[x, ]
mdl.02.test = texting.sim[-x, ]

save(list = c("mdl.02.train", "mdl.02.test"), file = "R-Data/data-mdl-02.rda")
rm(x, mdl.02.test, mdl.02.train)



########################################################################################
## Model 03: Differencing on the split sim
##
## Need to remove the first observation for each Subject
## Uses the mdl.01.train/test data sets as a starting point
mdl.03.train = ddply(mdl.01.train, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                 Anger = diff(Anger),
                 Contempt = diff(Contempt),
                 Disgust = diff(Disgust),
                 Fear = diff(Fear),
                 Joy = diff(Joy),
                 Sad = diff(Sad),
                 Surprise = diff(Surprise),
                 Neutral = diff(Neutral))

## Calculated the first row for each Subject to remove
mdl.01.test$row = 1:nrow(mdl.01.test)

## Calculated differencing for the test set
mdl.03.test = ddply(mdl.01.test, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                Anger = diff(Anger),
                Contempt = diff(Contempt),
                Disgust = diff(Disgust),
                Fear = diff(Fear),
                Joy = diff(Joy),
                Sad = diff(Sad),
                Surprise = diff(Surprise),
                Neutral = diff(Neutral))

save(list = c("mdl.03.train", "mdl.03.test"), file = 'R-Data/data-mdl-03.rda')
rm(mdl.01.train, mdl.01.test, mdl.03.train, mdl.03.test)



##################################################################################
## Model 04: Differencing with total data set
##
## Need to remove the first observation for each Subject
mdl.04.train = ddply(texting.sim, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger = diff(Anger),
                     Contempt = diff(Contempt),
                     Disgust = diff(Disgust),
                     Fear = diff(Fear),
                     Joy = diff(Joy),
                     Sad = diff(Sad),
                     Surprise = diff(Surprise),
                     Neutral = diff(Neutral))

set.seed(1123)
x = sample(nrow(mdl.04.train), nrow(mdl.04.train) / 2)

mdl.04.test = mdl.04.train[-x, ]
mdl.04.train = mdl.04.train[x, ]

save(list = c("mdl.04.train", "mdl.04.test"), file = 'R-Data/data-mdl-04.rda')
rm(mdl.04.train, mdl.04.test, x)


##################################################################################
## Model 05: Simple Running Averages for each emotion
##
## Training and Testing split at the 365 second
mdl.05.train = subset(texting.sim, Time <= 365)
mdl.05.test = subset(texting.sim, Time > 365)

mdl.05.train = ddply(mdl.05.train, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger    = diff(runMean(Anger,    n = 30)),
                     Contempt = diff(runMean(Contempt, n = 30)),
                     Disgust  = diff(runMean(Disgust,  n = 30)),
                     Fear     = diff(runMean(Fear,     n = 30)),
                     Joy      = diff(runMean(Joy,      n = 30)),
                     Sad      = diff(runMean(Sad,      n = 30)),
                     Surprise = diff(runMean(Surprise, n = 30)),
                     Neutral  = diff(runMean(Neutral,  n = 30)))

mdl.05.test = ddply(mdl.05.test, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger    = diff(runMean(Anger,    n = 30)),
                     Contempt = diff(runMean(Contempt, n = 30)),
                     Disgust  = diff(runMean(Disgust,  n = 30)),
                     Fear     = diff(runMean(Fear,     n = 30)),
                     Joy      = diff(runMean(Joy,      n = 30)),
                     Sad      = diff(runMean(Sad,      n = 30)),
                     Surprise = diff(runMean(Surprise, n = 30)),
                     Neutral  = diff(runMean(Neutral,  n = 30)))

mdl.05.train = na.omit(mdl.05.train)
mdl.05.test = na.omit(mdl.05.test)

save(list = c("mdl.05.train", "mdl.05.test"), file = 'R-Data/data-mdl-05.rda')
rm(mdl.05.train, mdl.05.test)


##################################################################################
## Model 06: Simple Running Averages for each emotion
##
## Samples taken over the entire simulation
mdl.06.train = ddply(texting.sim, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger    = diff(runMean(Anger,    n = 30)),
                     Contempt = diff(runMean(Contempt, n = 30)),
                     Disgust  = diff(runMean(Disgust,  n = 30)),
                     Fear     = diff(runMean(Fear,     n = 30)),
                     Joy      = diff(runMean(Joy,      n = 30)),
                     Sad      = diff(runMean(Sad,      n = 30)),
                     Surprise = diff(runMean(Surprise, n = 30)),
                     Neutral  = diff(runMean(Neutral,  n = 30)))

mdl.06.train = na.omit(mdl.06.train)

set.seed(1123)
x = sample(nrow(mdl.06.train), nrow(mdl.06.train) / 2)

mdl.06.test = mdl.06.train[-x, ]
mdl.06.train = mdl.06.train[x, ]

save(list = c("mdl.06.train", "mdl.06.test"), file = 'R-Data/data-mdl-06.rda')
rm(mdl.06.train, mdl.06.test, x)



##################################################################################
## Model 07: Average values for each .5 secods
##
## Training and Testing split at the 365 second
mdl.07.train = subset(texting.sim, Time <= 365)
mdl.07.test = subset(texting.sim, Time > 365)

mdl.07.train = ddply(mdl.07.train, .(Subject, Age_Old, Gender_Male, Texting, 
                                     Time = round_any(Time, .5, f = floor)), summarise,
                     Anger    = mean(Anger),
                     Contempt = mean(Contempt),
                     Disgust  = mean(Disgust),
                     Fear     = mean(Fear),
                     Joy      = mean(Joy),
                     Sad      = mean(Sad),
                     Surprise = mean(Surprise),
                     Neutral  = mean(Neutral))

mdl.07.test = ddply(mdl.07.test, .(Subject, Age_Old, Gender_Male, Texting, 
                                   Time = round_any(Time, .5, f = floor)), summarise,
                    Anger    = mean(Anger),
                    Contempt = mean(Contempt),
                    Disgust  = mean(Disgust),
                    Fear     = mean(Fear),
                    Joy      = mean(Joy),
                    Sad      = mean(Sad),
                    Surprise = mean(Surprise),
                    Neutral  = mean(Neutral))

mdl.07.train = na.omit(mdl.07.train)
mdl.07.test = na.omit(mdl.07.test)

save(list = c("mdl.07.train", "mdl.07.test"), file = 'R-Data/data-mdl-07.rda')
rm(mdl.07.train, mdl.07.test)



##################################################################################
## Model 08: Average values for each .5 secods
##
## Training sampled from the entire sim
mdl.08.train = ddply(texting.sim, .(Subject, Age_Old, Gender_Male, Texting, 
                                     Time = round_any(Time, .5, f = floor)), summarise,
                     Anger    = mean(Anger),
                     Contempt = mean(Contempt),
                     Disgust  = mean(Disgust),
                     Fear     = mean(Fear),
                     Joy      = mean(Joy),
                     Sad      = mean(Sad),
                     Surprise = mean(Surprise),
                     Neutral  = mean(Neutral))

set.seed(1123)
x = sample(nrow(mdl.08.train), nrow(mdl.08.train) / 2)

mdl.08.test = mdl.08.train[-x, ]
mdl.08.train = mdl.08.train[x, ]

save(list = c("mdl.08.train", "mdl.08.test"), file = 'R-Data/data-mdl-08.rda')
rm(mdl.08.train, mdl.08.test, x)



##################################################################################
## Model 09: Averaged Values differencing based on mdl.07 data
##
## Training and Testing split at the 365 second
load("R-Data/data-mdl-07.rda")

mdl.09.train = ddply(mdl.07.train, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger = diff(Anger),
                     Contempt = diff(Contempt),
                     Disgust = diff(Disgust),
                     Fear = diff(Fear),
                     Joy = diff(Joy),
                     Sad = diff(Sad),
                     Suprise = diff(Surprise),
                     Neutral = diff(Neutral))

mdl.09.test = ddply(mdl.07.test, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                    Anger = diff(Anger),
                    Contempt = diff(Contempt),
                    Disgust = diff(Disgust),
                    Fear = diff(Fear),
                    Joy = diff(Joy),
                    Sad = diff(Sad),
                    Suprise = diff(Surprise),
                    Neutral = diff(Neutral))

save(list = c("mdl.09.train", "mdl.09.test"), file = 'R-Data/data-mdl-09.rda')
rm(mdl.09.train, mdl.09.test, mdl.07.train, mdl.07.test)



##################################################################################
## Model 10: Averaged Values differencing based on mdl.08 data
##
## Training and Testing split at the 365 second
load("R-Data/data-mdl-08.rda")

mdl.10.train = ddply(mdl.08.train, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                     Anger = diff(Anger),
                     Contempt = diff(Contempt),
                     Disgust = diff(Disgust),
                     Fear = diff(Fear),
                     Joy = diff(Joy),
                     Sad = diff(Sad),
                     Suprise = diff(Surprise),
                     Neutral = diff(Neutral))

mdl.10.test = ddply(mdl.08.test, .(Subject, Age_Old, Gender_Male, Texting), summarise,
                    Anger = diff(Anger),
                    Contempt = diff(Contempt),
                    Disgust = diff(Disgust),
                    Fear = diff(Fear),
                    Joy = diff(Joy),
                    Sad = diff(Sad),
                    Suprise = diff(Surprise),
                    Neutral = diff(Neutral))

save(list = c("mdl.10.train", "mdl.10.test"), file = 'R-Data/data-mdl-10.rda')
rm(mdl.10.train, mdl.10.test, mdl.08.train, mdl.08.test)

