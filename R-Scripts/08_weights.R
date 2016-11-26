rm(list = ls())

library(nnet)
library(ggplot2)
library(plyr)
library(MASS)
library(devtools)
library(gridExtra)

f## Train single layer single node model repeatedly and Measure the relationship
## betwen Gender and Age

load("R-Data/data-mdl-08.rda")

dummies = model.matrix(~mdl.08.train$Subject - 1)
colnames(dummies) = sort(as.character(unique(mdl.08.train$Subject)))
mdl.13.train = cbind(dummies, mdl.08.train[, c(2:4, 6:13)])

fun = function(x) 1/(1 + exp(-x))

results = data.frame()

for (i in 1:1000) {

    fit = nnet(Texting ~ Age_Old * Gender_Male + ., data = mdl.13.train, range = 0.0,
        size = 1, maxit = 100, decay = 0.1, trace = FALSE)

    OM = fit$wts[1] + fit$wts[2] + fit$wts[3] + fit$wts[71]
    YM = fit$wts[1] + fit$wts[3]
    OF = fit$wts[1] + fit$wts[2]
    YF = fit$wts[1]
    OM.S = fun(OM)
    YM.S = fun(YM)
    OF.S = fun(OF)
    YF.S = fun(YF)
    OM.O = fun(OM.S * fit$wt[73] + fit$wt[72])
    YM.O = fun(YM.S * fit$wt[73] + fit$wt[72])
    OF.O = fun(OF.S * fit$wt[73] + fit$wt[72])
    YF.O = fun(YF.S * fit$wt[73] + fit$wt[72])

    results = rbind(results, data.frame(Trial = i, OM, YM, OF, YF,
                                        OM.S, YM.S, OF.S, YF.S,
                                        OM.O, YM.O, OF.O, YF.O))
    print(i)

}

hist(results$OM, breaks = 20)
hist(results$YM, breaks = 20)
hist(results$OF, breaks = 20)
hist(results$YF, breaks = 20)

hist(abs(results$OM), breaks = 20)
hist(abs(results$YM), breaks = 20)
hist(abs(results$OF), breaks = 20)
hist(abs(results$YF), breaks = 20)

hist(results$OM / results$YM, breaks = 50, xlim = c(-5, 5))
hist(results$OM / results$YF, breaks = 40, xlim = c(-5, 5))
hist(results$OM / results$OF, breaks = 20)
hist(results$YM / results$YF, breaks = 20)
hist(results$YM / results$OF, breaks = 20)
hist(results$OF / results$YF, breaks = 20)


## Look at the best model
## Treat each node as an individual regresion model
## Look at the distribution of weights for Age and Gender_Male

load("R-Models/mdl_08_nnet.rda")

s2.pos = seq(from = 2, to = 6900, by = 69)
ag.pos = seq(from = 60, to = 6900, by = 69)
gn.pos = seq(from = 61, to = 6900, by = 69)

subject2 = mdl.08$finalModel$wts[s2.pos]
age = mdl.08$finalModel$wts[ag.pos]
gender = mdl.08$finalModel$wts[gn.pos]


hist(age, breaks = 20)
hist(gender, breaks = 20)
summary(subject2)
sqrt(var(subject2))/sqrt(100)
hist(age/gender)

## Sum up the weights from the subjects
x = as.character(unique(mdl.08.train$Subject))
x = sort(x)

sub.weights = data.frame()

for (i in 2:60) {
  i.pos = seq(from = i, to = 6900, by = 69)
  i.wgt = sum(mdl.08$finalModel$wts[i.pos])
  sub.weights = rbind(sub.weights, data.frame(Subject = x[i], Weight = i.wgt))
}

sub.weights$scaled = with(sub.weights, Weight - min(Weight) / (max(Weight) - min(Weight)))


OldRange = with(sub.weights, max(Weight) - min(Weight))  
sub.weights$scaled = (((sub.weights$Weight - min(sub.weights$Weight)) * 2) / OldRange) - 1

qplot(x = Subject, y = Weight, data = sub.weights) + coord_flip()


## With all variables fixed, how does changing one
## emotion change the probability of a texting event

load("R-Data/data-mdl-08.rda")

## Neutral

x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Contempt = 0, Disgust = 0, Fear = 0,
    Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Neutral = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Neutral = i
    test.Neutral = rbind(test.Neutral, x)
}

test.Neutral$predict = predict(mdl.08, test.Neutral, type = "prob")[, 2]

ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.3) +
  geom_smooth(aes(x = Neutral, y = predict))


ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.3) +
  geom_smooth(aes(x = Neutral, y = predict)) +
  facet_grid(Age_Old ~ Gender_Male)


## Change Anger, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Neutral = 0, Contempt = 0, Disgust = 0, Fear = 0,
    Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Anger = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Anger = i
    test.Anger = rbind(test.Anger, x)
}

test.Anger$predict = predict(mdl.08, test.Anger, type = "prob")[, 2]

ggplot(test.Anger) + geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.3) +
  geom_smooth(aes(x = Anger, y = predict))

ggplot(test.Anger) + geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.3) +
    geom_smooth(aes(x = Anger, y = predict)) +
  facet_grid(Age_Old ~ Gender_Male)



## Change Contempt, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Contempt = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Contempt = i
    test.Contempt = rbind(test.Contempt, x)
}

test.Contempt$predict = predict(mdl.08, test.Contempt, type = "prob")[, 2]


ggplot(test.Contempt) +
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.3) +
  geom_smooth(aes(x = Contempt, y = predict))


ggplot(test.Contempt) + geom_boxplot(aes(x = Contempt, y = predict, group = Contempt),
    alpha = 0.3) + geom_smooth(aes(x = Contempt, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)



## Change Disgust, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Disgust = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Disgust = i
    test.Disgust = rbind(test.Disgust, x)
}

test.Disgust$predict = predict(mdl.08, test.Disgust, type = "prob")[, 2]

ggplot(test.Disgust) +
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.3) +
  geom_smooth(aes(x = Disgust, y = predict))


ggplot(test.Disgust) + geom_boxplot(aes(x = Disgust, y = predict, group = Disgust),
    alpha = 0.3) + geom_smooth(aes(x = Disgust, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)




## Change Fear, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Fear = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Fear = i
    test.Fear = rbind(test.Fear, x)
}

test.Fear$predict = predict(mdl.08, test.Fear, type = "prob")[, 2]


ggplot(test.Fear) + geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.3) +
  geom_smooth(aes(x = Fear, y = predict))

ggplot(test.Fear) + geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.3) +
    geom_smooth(aes(x = Fear, y = predict)) + facet_grid(Age_Old ~ Gender_Male)



## Change Joy, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Joy = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Joy = i
    test.Joy = rbind(test.Joy, x)
}

test.Joy$predict = predict(mdl.08, test.Joy, type = "prob")[, 2]

ggplot(test.Joy) + geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
  geom_smooth(aes(x = Joy, y = predict))

ggplot(test.Joy) + geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
    geom_smooth(aes(x = Joy, y = predict)) + facet_grid(Age_Old ~ Gender_Male)




## Change Sad, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Sad = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Sad = i
    test.Sad = rbind(test.Sad, x)
}

test.Sad$predict = predict(mdl.08, test.Sad, type = "prob")[, 2]

ggplot(test.Sad) + geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
    geom_smooth(aes(x = Sad, y = predict))

ggplot(test.Sad) + geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
  geom_smooth(aes(x = Sad, y = predict)) + facet_grid(Age_Old ~ Gender_Male)






## Change Surprise, all others constant
x = unique(mdl.08.train[, c("Subject", "Age_Old", "Gender_Male")])
dta = cbind(x, data.frame(Time = 0, Anger = 0, Neutral = 0, Contempt = 0, Disgust = 0,
    Fear = 0, Joy = 0, Sad = 0, Surprise = 0))

rm(x)

test.Surprise = data.frame()

for (i in seq(-1, 1, 0.1)) {
    x = dta
    x$Surprise = i
    test.Surprise = rbind(test.Surprise, x)
}

test.Surprise$predict = predict(mdl.08, test.Surprise, type = "prob")[, 2]

ggplot(test.Surprise) +
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.3) +
  geom_smooth(aes(x = Surprise, y = predict))


ggplot(test.Surprise) + geom_boxplot(aes(x = Surprise, y = predict, group = Surprise),
    alpha = 0.3) + geom_smooth(aes(x = Surprise, y = predict)) + facet_grid(Age_Old ~
    Gender_Male)



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
source_gist('6206737')

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


rel.imp = gar.fun(out.var = "Texting", mod.in = mdl.08, bar.plot = FALSE)

## Look at relative importance by accuracy



## Presentation Plots
x1 = ggplot(test.Anger) +
  geom_boxplot(aes(x = Anger, y = predict, group = Anger), alpha = 0.3) +
  geom_smooth(aes(x = Anger, y = predict))

x2 = ggplot(test.Contempt) +
  geom_boxplot(aes(x = Contempt, y = predict, group = Contempt), alpha = 0.3) +
  geom_smooth(aes(x = Contempt, y = predict))

x3 = ggplot(test.Disgust) +
  geom_boxplot(aes(x = Disgust, y = predict, group = Disgust), alpha = 0.3) +
  geom_smooth(aes(x = Disgust, y = predict))

x4 = ggplot(test.Fear) +
  geom_boxplot(aes(x = Fear, y = predict, group = Fear), alpha = 0.3) +
  geom_smooth(aes(x = Fear, y = predict))

x5 = ggplot(test.Joy) +
  geom_boxplot(aes(x = Joy, y = predict, group = Joy), alpha = 0.3) +
  geom_smooth(aes(x = Joy, y = predict))

x6 = ggplot(test.Sad) +
  geom_boxplot(aes(x = Sad, y = predict, group = Sad), alpha = 0.3) +
  geom_smooth(aes(x = Sad, y = predict))

x7 = ggplot(test.Surprise) +
  geom_boxplot(aes(x = Surprise, y = predict, group = Surprise), alpha = 0.3) +
  geom_smooth(aes(x = Surprise, y = predict))

x8 = ggplot(test.Neutral) +
  geom_boxplot(aes(x = Neutral, y = predict, group = Neutral), alpha = 0.3) +
  geom_smooth(aes(x = Neutral, y = predict))


grid.arrange(x1, x2, x3, x4, x5, x6, x7, x8, nrow = 4)
