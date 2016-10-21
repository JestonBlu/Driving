library(neuralnet)

rm(list = ls())

load("R-Data/stats.rda")

stats = subset(stats, Trial == '007')

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}


##
x = sample(x = nrow(stats), size = round(nrow(stats) * .6), replace = FALSE)


stats$Age_Old = ifelse(stats$Age == 'O', 1, 0)
stats$Gender_Male = ifelse(stats$Gender == 'M', 1, 0)

texting = as.numeric(stats$texting)-1

stats = stats[, c(7:46, 48:49)]

stats.max = apply(stats, 2, max)
stats.min = apply(stats, 2, min)

stats = data.frame(scale(stats, scale = stats.max - stats.min))

stats$texting = texting

n = names(stats)
f = as.formula(paste("texting ~", paste(n[!n %in% "texting"], collapse = " + ")))

train = stats[x, ]
test = stats[-x, ]

mdl.nn = neuralnet(f, train, hidden = c(20, 10), err.fct = "sse", likelihood = TRUE, act.fct = 'logistic')


results = round(compute(mdl.nn, test[, 1:42])$net.result, 3)
results[results < 0] = 0
results[results > 1] = 1
results = data.frame(
  pred = results
)

results$pred.class = ifelse(results$pred > .5, 1, 0)
results$Actual = test$texting
metric(table(Actual = results$Actual, Prediction = results$pred.class))
