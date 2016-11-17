load("R-Models/mdl_13_nnet.rda")
load("R-Data/data-mdl-13.rda")


#import the function from Github
library(devtools)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')

#plot each model
plot.nnet(mdl.13, wts.only = TRUE)


## Old Male
-.98+2.25-1.57; 1 / (1 + exp(.3))

## Young Male
-.98-1.57; 1 / (1 + exp(2.55))

.425*## Old Female 
-.98+2.25; 1 / (1 + exp(-1.27))

## Young Female
-.98; 1/(1 + exp(.98))


1/(1 + exp(-.834))


source_url('https://gist.githubusercontent.com/fawda123/6206737/raw/d6f365c283a8cae23fb20892dc223bc5764d50c7/gar_fun.r')

#create a pretty color vector for the bar plot
cols<-colorRampPalette(c('lightgreen','lightblue'))(8)

#use the function on the model created above
par(mar=c(3,4,1,1),family='serif')

gar.fun('Texting', mdl.13) + coord_flip()



#import the function from Github
source_url('https://gist.githubusercontent.com/Peque/41a9e20d6687f2f3108d/raw/85e14f3a292e126f1454864427e3a189c2fe33f3/nnet_plot_update.r')

#plot each model
plot.nnet(mdl.13)

