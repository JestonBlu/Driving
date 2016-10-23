## Data Prep for Neural Net Learning

rm(list = ls())

library(plyr)
library(ggplot2)

load("R-Data/faces_cen.rda")
stimuli = read.csv("Files/data-stimuli.csv")


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

## Some subjects have event files, but done have sim data
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

## The last first event occurs at 262 seconds
## The first last event occurs at 331 seconds
## The training set and testing set will be split on
## (331-262) / 2 + 331 = 365
texting.sim$Subject = as.character(texting.sim$Subject)
texting.sim = texting.sim[texting.sim$Subject %in% keep, ]
texting.sim$Age_Old = ifelse(texting.sim$Age == 'O', 1, 0)
texting.sim$Gender_Male = ifelse(texting.sim$Gender == 'M', 1, 0)
texting.sim = texting.sim[, c(1, 15:16, 4, 6:14)]
texting.sim$Subject = factor(texting.sim$Subject)

## Center the data
#texting.sim[, 5:12] = apply(texting.sim[, 5:12], 2, scale)
ml.train = subset(texting.sim, Time <= 365)
y.max = apply(ml.train[, 5:12], 2, max)
y.min = apply(ml.train[, 5:12], 2, min)
ml.train[, 5:12] = scale(ml.train[, 5:12], scale = y.max - y.min)

ml.test = subset(texting.sim, Time > 365)
y.max = apply(ml.test[, 5:12], 2, max)
y.min = apply(ml.test[, 5:12], 2, min)
ml.test[, 5:12] = scale(ml.test[, 5:12], scale = y.max - y.min)

save(list = c("ml.train", "ml.test", "texting.sim"), file = "R-Data/data-ml.rda")

