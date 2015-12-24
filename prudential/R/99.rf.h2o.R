library(h2o)

str(d, list.len=ncol(d))

## Use H2O's random forest
## Start cluster with all available threads
h2o.init(nthreads=-1,max_mem_size='6G')
## Load data into cluster from R
dHex<-as.h2o(d)
## Set up variable to use all features other than those specified here
features<-colnames(d)[!(colnames(d) %in% c("Id"))]
## Train a random forest using all default parameters
rfHex <- h2o.randomForest(x=features,
                          y="Response", 
                          ntrees = 100,
                          max_depth = 30,
                          nbins_cats = 1115, ## allow it to fit store ID
                          training_frame=dHex)


summary(rfHex)
## Load test data into cluster from R
testHex<-as.h2o(test)

## Get predictions out; predicts in H2O, as.data.frame gets them into R
predictions<-as.data.frame(h2o.predict(rfHex,testHex[,-c(1)]))
## Return the predictions to the original scale of the Sales data
summary(predictions)
predictions$round <- round(predictions$predict)

submission <- data.frame(test$Id, predictions$round)
colnames(submission) <- c("Id", "Response")
#saving the submission file
write.csv(submission, "out/out_20151129_1.csv",row.names=F)





