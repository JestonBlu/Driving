 rm(list = ls())

library(plyr)

## Import Data
faces = read.csv("Files/data-faces.csv")
stimuli = read.csv("Files/data-stimuli.csv")
demograph = read.csv("Files/Other/Subject Biographic Info.csv")

faces$Event.Switch = 0
faces$Event = ""
faces$Action = 0

## Join the datasets
for (i in 1:nrow(stimuli)) {

  x = stimuli[i, ]
  x.id = as.character(x$ID)
  x.str = as.numeric(x$StartTime)
  x.end = as.numeric(x$EndTime)

  x.event.switch = as.numeric(x$Event.Switch)
  x.event = as.character(x$Question.Number)
  x.action = as.numeric(x$Action.Type)

  faces$Event.Switch[which(faces$ID %in% x.id & faces$Time >= x.str & faces$Time <= x.end)] = x.event.switch
  faces$Event[which(faces$ID %in% x.id & faces$Time >= x.str & faces$Time <= x.end)] = x.event
  faces$Action[which(faces$ID %in% x.id & faces$Time >= x.str & faces$Time <= x.end)] = x.action
}

rm(x, x.id, x.str, x.end, x.event.switch, x.event, i)

## Splits Subjects from Trials
faces$Subject = substr(faces$ID, 1, 4)
faces$Trial = substr(faces$ID, 6, 8)

## Join demographics with faces and stimuli data
faces = join(faces, demograph)

## Factor the strings
faces$Subject = factor(faces$Subject)
faces$Trial = factor(faces$Trial)
faces$Age = factor(faces$Age)
faces$Gender = factor(faces$Gender)

## A few rows have no data in the faces, setting those to 0
faces[is.na(faces)] = 0

## Adjust Column position and names
colnames(faces)[1] = "Frame"
faces = faces[, c(11, 15:18, 1:2, 12:14, 3:10)]

## Fix Spelling issues in the data
faces$Event = as.character(faces$Event)
faces$Event[faces$Action == 0] = 'No Event'
faces$Event[faces$Action == 1] = 'Analytical Questions'
faces$Event[faces$Action == 2] = 'Mathematical Questions'
faces$Event[faces$Action == 3] = 'Emotional Questions'
faces$Event[faces$Action == 4] = 'Texting'
faces$Event[faces$Action == 5] = 'Texting and Talking'
faces$Event[faces$Action == 6] = 'Failure Event'
faces$Event = factor(faces$Event)


## Saves Data Frame
save("faces", file = "R-Data/faces.rda")
