rm(list = ls())

library(nnet)
library(ggplot2)
library(plyr)
library(MASS)
library(devtools)
library(gridExtra)


load("R-Models/mdl_13_nnet.rda")
load("R-Data/data-mdl-12.rda")

dummies = model.matrix(~mdl.12.train$Subject - 1)
colnames(dummies) = sort(as.character(unique(mdl.12.train$Subject)))
mdl.13.train = cbind(dummies, mdl.12.train[, c(2:4, 6:53)])

dummies = model.matrix(~mdl.12.test$Subject - 1)
colnames(dummies) = sort(as.character(unique(mdl.12.test$Subject)))
mdl.13.test = cbind(dummies, mdl.12.test[, c(2:4, 6:53)])


## With all variables fixed, how does changing one
## emotion change the probability of a texting event

## Neutral

x = unique(mdl.12.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, 
                          Anger.mu = 0, Anger.sd = 0, Anger.min = 0, Anger.max = 0, Anger.med = 0, Anger.iqr = 0,
                          Contempt.mu = 0, Contempt.sd = 0, Contempt.min = 0, Contempt.max = 0, Contempt.med = 0, Contempt.iqr = 0,
                          Disgust.mu = 0, Disgust.sd = 0, Disgust.min = 0, Disgust.max = 0, Disgust.med = 0, Disgust.iqr = 0,
                          Fear.mu = 0, Fear.sd = 0, Fear.min = 0, Fear.max = 0, Fear.med = 0, Fear.iqr = 0,
                          Joy.mu = 0, Joy.sd = 0, Joy.min = 0, Joy.max = 0, Joy.med = 0, Joy.iqr = 0,
                          Sad.mu = 0, Sad.sd = 0, Sad.min = 0, Sad.max = 0, Sad.med = 0, Sad.iqr = 0,
                          Surprise.mu = 0, Surprise.sd = 0, Surprise.min = 0, Surprise.max = 0, Surprise.med = 0, Surprise.iqr = 0,
                          Neutral.mu = 0, Neutral.sd = 0, Neutral.min = 0, Neutral.max = 0, Neutral.med = 0, Neutral.iqr = 0))

rm(x)

test.Neutral = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Neutral.mu = i
    test.Neutral = rbind(test.Neutral, x)
}

test.Neutral$predict = predict(mdl.12, test.Neutral, type = "prob")[, 2]

ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral.mu, y = predict, group = Neutral.mu), alpha = 0.7) +
  geom_smooth(aes(x = Neutral.mu, y = predict))


ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral.mu, y = predict, group = Neutral.mu), alpha = 0.7) +
  geom_smooth(aes(x = Neutral.mu, y = predict)) +
  facet_grid(Age_Old ~ Gender_Male)



#############################
## combine all of the tests

test.Sad$Pred = 0
test.Sad$Pred[test.Sad$predict > .5] = 1
test.Surprise$Pred = 0
test.Surprise$Pred[test.Surprise$predict > .5] = 1
test.Joy$Pred = 0
test.Joy$Pred[test.Joy$predict > .5] = 1
test.Fear$Pred = 0
test.Fear$Pred[test.Fear$predict > .5] = 1
test.Disgust$Pred = 0
test.Disgust$Pred[test.Disgust$predict > .5] = 1
test.Contempt$Pred = 0
test.Contempt$Pred[test.Contempt$predict > .5] = 1
test.Anger$Pred = 0
test.Anger$Pred[test.Anger$predict > .5] = 1
test.Neutral$Pred = 0
test.Neutral$Pred[test.Neutral$predict > .5] = 1

mdl.Sad = glm(Pred ~ Age_Old * Gender_Male * Sad, data = test.Sad, family = binomial())
mdl.Surprise = glm(Pred ~ Age_Old * Gender_Male * Surprise, data = test.Surprise, family = binomial())
mdl.Joy = glm(Pred ~ Age_Old * Gender_Male * Joy, data = test.Joy, family = binomial())
mdl.Fear = glm(Pred ~ Age_Old * Gender_Male * Fear, data = test.Fear, family = binomial())
mdl.Disgust = glm(Pred ~ Age_Old * Gender_Male * Disgust, data = test.Disgust, family = binomial())
mdl.Contempt = glm(Pred ~ Age_Old * Gender_Male * Contempt, data = test.Contempt, family = binomial())
mdl.Anger = glm(Pred ~ Age_Old * Gender_Male * Anger, data = test.Anger, family = binomial())
mdl.Neutral = glm(Pred ~ Age_Old * Gender_Male * Neutral, data = test.Neutral, family = binomial())

summary(aov(mdl.Neutral))
summary(aov(mdl.Surprise))
summary(aov(mdl.Anger))
summary(aov(mdl.Disgust))
summary(aov(mdl.Fear))
summary(aov(mdl.Sad))
summary(aov(mdl.Joy))
summary(aov(mdl.Contempt))



  
#############################



## Test distributions
hist(results$OM); summary(results$OM)
hist(abs(results$OM)); summary(results$OM)

x = qunif(p = seq(.01, .99, length.out = 1000), min = -9, max = 9)

plot(x = x, y = sort(results$OM))
lines(x = x, y = x)


hist(results$YM); summary(results$YM)
hist(abs(results$YM)); summary(results$YM)


hist(results$OF); summary(results$OF)
hist(abs(results$OF)); summary(results$OF)

hist(results$YF); summary(results$YF)
hist(abs(results$YF)); summary(results$YF)

## Relationships
hist(results$OM/results$YM, breaks = 50); 
summary(results$OM/results$YM); sd(results$OM/results$YM)/1000

hist(results$OM/results$YF, breaks = 50); 
summary(results$OM/results$YF); sd(results$OM/results$YF)/1000

hist(results$OM/results$OF, breaks = 50); 
summary(results$OM/results$OF); sd(results$OM/results$OF)/1000

hist(results$YM/results$YF, breaks = 50); 
summary(results$YM/results$YF); sd(results$YM/results$YF)/1000

hist(results$YM/results$OF, breaks = 50); 
summary(results$YM/results$OF); sd(results$YM/results$OF)/1000

hist(results$OF/results$YF, breaks = 50); 
summary(results$OF/results$YF); sd(results$OF/results$YF)/1000


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



load("R-Models/Itr_500/mdl_12_nnet.rda")

rel.imp = gar.fun(out.var = "Texting", mod.in = mdl.12$finalModel, bar.plot = FALSE)
rel.imp$Subject = row.names(rel.imp)
rel.imp$Subject = gsub(pattern = "Subject", replacement = "", x = rel.imp$Subject)
rel.imp1 = rel.imp[-(grep("T", rel.imp$Subject)), ]

g1 = ggplot(rel.imp1, aes(x = reorder(Subject, rel.imp), y = rel.imp)) +
  geom_bar(stat = "identity") +
  scale_y_continuous("Relative Importance") +
  scale_x_discrete("") +
  coord_flip() +
  ggtitle("500 Iterations") +
  theme(plot.title = element_text(hjust = .5))

load("R-Models/Itr_250/mdl_12_nnet.rda")

rel.imp = gar.fun(out.var = "Texting", mod.in = mdl.12$finalModel, bar.plot = FALSE)
rel.imp$Subject = row.names(rel.imp)
rel.imp$Subject = gsub(pattern = "Subject", replacement = "", x = rel.imp$Subject)
rel.imp2 = rel.imp[-(grep("T", rel.imp$Subject)), ]

g2 = ggplot(rel.imp2, aes(x = reorder(Subject, rel.imp), y = rel.imp)) +
  geom_bar(stat = "identity") +
  scale_y_continuous("Relative Importance") +
  scale_x_discrete("") +
  coord_flip() +
  ggtitle("250 Iterations") +
  theme(plot.title = element_text(hjust = .5))


load("R-Models/Itr_100/mdl_12_nnet.rda")

rel.imp = gar.fun(out.var = "Texting", mod.in = mdl.12$finalModel, bar.plot = FALSE)
rel.imp$Subject = row.names(rel.imp)
rel.imp$Subject = gsub(pattern = "Subject", replacement = "", x = rel.imp$Subject)
rel.imp3 = rel.imp[-(grep("T", rel.imp$Subject)), ]

g3 = ggplot(rel.imp3, aes(x = reorder(Subject, rel.imp), y = rel.imp)) +
  geom_bar(stat = "identity") +
  scale_y_continuous("Relative Importance") +
  scale_x_discrete("") +
  coord_flip() +
  ggtitle("100 Iterations") +
  theme(plot.title = element_text(hjust = .5))


grid.arrange(g3, g2, g1, ncol = 3)

## Look at relative importance by accuracy



## Presentation Plots
x1 = ggplot(test.Anger) +
  geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.7) +
  geom_smooth(aes(x = Anger, y = predict)) +
  scale_y_continuous("Probability")

x2 = ggplot(test.Contempt) +
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.7) +
  geom_smooth(aes(x = Contempt, y = predict)) +
  scale_y_continuous("Probability")

x3 = ggplot(test.Disgust) +
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.7) +
  geom_smooth(aes(x = Disgust, y = predict)) +
  scale_y_continuous("Probability")

x4 = ggplot(test.Fear) +
  geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.7) +
  geom_smooth(aes(x = Fear, y = predict)) +
  scale_y_continuous("Probability")

x5 = ggplot(test.Joy) +
  geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.7) +
  geom_smooth(aes(x = Joy, y = predict)) +
  scale_y_continuous("Probability")

x6 = ggplot(test.Sad) +
  geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.7) +
  geom_smooth(aes(x = Sad, y = predict)) +
  scale_y_continuous("Probability")

x7 = ggplot(test.Surprise) +
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.7) +
  geom_smooth(aes(x = Surprise, y = predict)) +
  scale_y_continuous("Probability")

x8 = ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral.mu, y = predict, group = Neutral.mu), alpha = 0.7) +
  geom_smooth(aes(x = Neutral.mu, y = predict)) +
  scale_y_continuous("Probability")


grid.arrange(x1, x2, x3, x4, x5, x6, x7, x8, nrow = 4)




######################################################################

metric = function(confusion) {
  sensitivity = confusion[4] / (confusion[2] + confusion[4])
  specificity = confusion[1] / (confusion[1] + confusion[3])
  score = (sensitivity + specificity) / 2
  return(score)
}

mdl.13.train$Predict = predict(mdl.13, mdl.13.train, type = "raw")
mdl.13.test$Predict = predict(mdl.13, mdl.13.test, type = "raw")

subject = subjects$Subject

tab = data.frame()

for (i in 1:59) {
  nm = colnames(mdl.13.train)[i]
  y1 = mdl.13.train[mdl.13.train[i] == 1, ]
  y2 = mdl.13.test[mdl.13.test[i] == 1, ]
  
  x1 = metric(table(Actual = y1$Texting, Predicted = y1$Predict))
  x2 = metric(table(Actual = y2$Texting, Predicted = y2$Predict))
  
  tab = rbind(tab, data.frame(Subject = nm, Train = x1, Test = x2))
  
}

tab = arrange(tab, desc(Test))
tab$Train = round(tab$Train, 3)
tab$Test = round(tab$Test, 3)
subject = as.character(tab$Subject)

sub.imp = join(subjects, tab)

ggplot(sub.imp) +
  geom_point(aes(x = rel.imp, y = Test))


#############################################################################

## Look at the best model
## Treat each node as an individual regresion model
## Look at the distribution of weights for Age and Gender_Male

s1.pos = seq(from = 38, to = 5551, by = 109)
s2.pos = seq(from = 2, to = 5551, by = 109)
s3.pos = seq(from = 3, to = 5551, by = 109)
s4.pos = seq(from = 22, to = 5551, by = 109)

subject1 = mdl.13$finalModel$wts[s1.pos]
subject2 = mdl.13$finalModel$wts[s2.pos]
subject3 = mdl.13$finalModel$wts[s3.pos]
subject4 = mdl.13$finalModel$wts[s4.pos]

subjects = data.frame(subject1, subject2, subject3, subject4)


g1 = ggplot(subjects) + 
  geom_histogram(aes(x = subject1)) + 
  scale_x_continuous("weights") +
  ggtitle("Subject 38 (51% Accuracy)") +
  theme(plot.title = element_text(hjust = 0.5))

g2 = ggplot(subjects) + 
  geom_histogram(aes(x = subject2)) + 
  scale_x_continuous("weights") + 
  ggtitle("Subject 2 (71% Accuracy)") +
  theme(plot.title = element_text(hjust = 0.5))

g3 = ggplot(subjects) + 
  geom_histogram(aes(x = subject3)) + 
  scale_x_continuous("weights") +
  ggtitle("Subject 3 (88% Accuracy)") +
  theme(plot.title = element_text(hjust = 0.5))

g4 = ggplot(subjects) + 
  geom_histogram(aes(x = subject4)) + 
  scale_x_continuous("weights") +
  ggtitle("Subject 22 (97% Accuracy") +
  theme(plot.title = element_text(hjust = 0.5))

grid.arrange(g1, g2, g3, g4, nrow = 2)


ag.pos = seq(from = 60, to = 6900, by = 69)
gn.pos = seq(from = 61, to = 6900, by = 69)

age = mdl.13$finalModel$wts[ag.pos]
gender = mdl.13$finalModel$wts[gn.pos]


hist(age, breaks = 20)
hist(gender, breaks = 20)
hist(age/gender)

hist(subject2, breaks = 15)
hist(subject3, breaks = 15)
hist(subject4, breaks = 15)
hist(subject5, breaks = 15)



##################################################################
## Sum up the weights from the subjects
x = as.character(colnames(mdl.13.train)[1:60])
x = sort(x)

sub.weights = data.frame()

for (i in 2:60) {
  i.pos = seq(from = i, to = 5551, by = 109)
  i.wgt = sum(mdl.13$finalModel$wts[i.pos])
  sub.weights = rbind(sub.weights, data.frame(Subject = x[i], Weight = i.wgt))
}

sub.weights$scaled = with(sub.weights, Weight - min(Weight) / (max(Weight) - min(Weight)))


OldRange = with(sub.weights, max(Weight) - min(Weight))  
sub.weights$scaled = (((sub.weights$Weight - min(sub.weights$Weight)) * 2) / OldRange) - 1

qplot(x = Subject, y = Weight, data = sub.weights) + coord_flip()

final = join(sub.weights, sub.imp)

ggplot(final, aes(x = scaled, y = Test)) + 
  geom_point() +
  geom_smooth(method = "lm")

ggplot(final, aes(x = scaled, y = rel.imp)) + 
  geom_point() +
  geom_smooth(method = "lm")

ggplot(final, aes(x = rel.imp, y = Test)) + 
  geom_point() +
  geom_smooth(method = "lm")



plot(mdl.13)
