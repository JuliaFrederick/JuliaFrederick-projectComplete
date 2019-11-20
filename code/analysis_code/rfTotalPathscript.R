## Random Forest for Total Pathogen

library('forcats')
library('doParallel')
library('rpart')
library('rpart.plot')
library('mda')
library('ranger')
library('e1071')
library('gbm')
library('here')

#Using the whole data file, but removing the exact pathogens because we are just concerned with pathogen prevalence
tickpath <- readRDS(here("././data/processed_data/processeddata_tickpath.rds"))
colnames(tickpath)
tickpath <- tickpath[,c(17,1:16)]
xytickpath <- tickpath[,-c(6,8,11:16)]

#Creating a train data set

set.seed(123)
trainset <- caret::createDataPartition(y = xytickpath$TotalPath, p = 0.7, list = FALSE)
data_train = xytickpath[trainset,] #extract observations/rows for training, assign to new variable
data_test = xytickpath[-trainset,] #do the same for the test set

n_cores <- 4 #number of cores to use
cl <- makePSOCKcluster(n_cores)
registerDoParallel(cl) #comment out this line if you don't want parallel computing

set.seed(1111) #makes each code block reproducible
outcomename = "TotalPath"
Npred <- ncol(data_train)-1 # number of predictors
resultmat <- data.frame(Variable = names(data_train)[-1], Accuracy = rep(0,Npred)) #store performance for each variable

fitControl <- trainControl(method="repeatedcv",number=5,repeats=5) 
fit1 = caret::train(TotalPath  ~ ., data=data_train, method="rpart",  trControl = fitControl, na.action = na.pass, tuneLength = 10) 
print(fit1$results)

prp(fit1$finalModel, extra = 1, type = 1)
ww=17.8/2.54; wh=ww; #for saving plot
dev.print(device=png,width=ww,height=wh,units="in",res=600,file=here("././results/rparttree.png")) #save tree to file


##Full data set
set.seed(1111) #makes each code block reproducible
outcomename = "TotalPath"
Npred <- ncol(xytickpath)-1 # number of predictors
resultmat <- data.frame(Variable = names(xytickpath)[-1], Accuracy = rep(0,Npred)) #store performance for each variable

fitControl <- trainControl(method="repeatedcv",number=5,repeats=5) 
fit2 = caret::train(TotalPath  ~ ., data=xytickpath, method="rpart",  trControl = fitControl, na.action = na.pass, tuneLength = 10) 
print(fit2$results)

prp(fit2$finalModel, extra = 1, type = 1)
ww=17.8/2.54; wh=ww; #for saving plot
dev.print(device=png,width=ww,height=wh,units="in",res=600,file=here("././results/rparttreeFull.png")) #save tree to file