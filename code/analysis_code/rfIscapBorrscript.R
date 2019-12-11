##Random Forest for I scapularis and Borrelia.spp

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
iscapbor<-readRDS(here("././data/processed_data/processeddata_iscapbor.rds"))

#Creating a train data set

set.seed(123)
trainset <- caret::createDataPartition(y = iscapbor$Borrelia.spp, p = 0.7, list = FALSE)
data_train = iscapbor[trainset,] #extract observations/rows for training, assign to new variable
data_test = iscapbor[-trainset,] #do the same for the test set

n_cores <- 4 #number of cores to use
cl <- makePSOCKcluster(n_cores)
registerDoParallel(cl) #comment out this line if you don't want parallel computing

set.seed(1111) #makes each code block reproducible
outcomename = "Borrelia.spp"
Npred <- ncol(data_train)-1 # number of predictors
resultmat <- data.frame(Variable = names(data_train)[-1], Accuracy = rep(0,Npred)) #store performance for each variable

fitControl <- caret::trainControl(method="repeatedcv",number=5,repeats=5) 
fit1 = caret::train(Borrelia.spp  ~ ., data=data_train, method="rpart",  trControl = fitControl, na.action = na.pass, tuneLength = 10) 
print(fit1$results)

prp(fit1$finalModel, extra = 100, under=TRUE, type = 0, yesno=1, fallen.leaves = TRUE, varlen = 20,under.cex = 1.5,round=0)
ww=17.8/2.54; wh=ww; #for saving plot
dev.print(device=png,width=ww,height=wh,units="in",res=600,file=here("././results/rparttreeBorrelia.png")) #save tree to file
