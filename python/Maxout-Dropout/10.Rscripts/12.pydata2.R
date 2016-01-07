install.packages("caret")
library(caret)

str(d, list.len=ncol(d))
str(test, list.len=ncol(test))

d$Train_Flag    <- 1  #Add in a flag to identify if observations fall in train data, 1 train, 0 test
test$Response   <- NA #Add in a column for Response in the test data and initialize to NA
test$Train_Flag <- 0  #Add in a flag to identify if observations fall in train data, 1 train, 0 test

All_Data <- rbind(d,test) #79,146 observations, 129 variables 
All_Data_bk <- All_Data

str(All_Data, list.len=ncol(All_Data))

# NAN Strategy : mean -------------------------------------------------------------
# Employment_Info_1
summary(All_Data$Employment_Info_1)
#All_Data$Employment_Info_1_na <- ifelse(is.na(All_Data$Employment_Info_1), 1, 0 )
All_Data$Employment_Info_1    <- ifelse(is.na(All_Data$Employment_Info_1),
                                        mean(na.omit(All_Data$Employment_Info_1)), 
                                        All_Data$Employment_Info_1 )
# Employment_Info_4 
summary(All_Data$Employment_Info_4)
All_Data$Employment_Info_4    <- ifelse(is.na(All_Data$Employment_Info_4),
                                        mean(na.omit(All_Data$Employment_Info_4)),
                                        All_Data$Employment_Info_4 )
# Employment_Info_6
summary(All_Data$Employment_Info_6)
All_Data$Employment_Info_6    <- ifelse(is.na(All_Data$Employment_Info_6),
                                        mean(na.omit(All_Data$Employment_Info_6)), 
                                        All_Data$Employment_Info_6 )
#Insurance_History_5
summary(All_Data$Insurance_History_5)
All_Data$Insurance_History_5    <- ifelse(is.na(All_Data$Insurance_History_5),
                                          mean(na.omit(All_Data$Insurance_History_5)), 
                                          All_Data$Insurance_History_5 )
# Family_Hist_2
summary(All_Data$Family_Hist_2) 
All_Data$Family_Hist_2    <- ifelse(is.na(All_Data$Family_Hist_2),
                                    mean(na.omit(All_Data$Family_Hist_2)),  
                                    All_Data$Family_Hist_2 )
# Family_Hist_3
summary(All_Data$Family_Hist_3) 
All_Data$Family_Hist_3    <- ifelse(is.na(All_Data$Family_Hist_3),
                                    mean(na.omit(All_Data$Family_Hist_3)),   
                                    All_Data$Family_Hist_3 )
# Family_Hist_4
summary(All_Data$Family_Hist_4) 
All_Data$Family_Hist_4    <- ifelse(is.na(All_Data$Family_Hist_4),
                                    mean(na.omit(All_Data$Family_Hist_4)),   
                                    All_Data$Family_Hist_4 )
# Medical_History_1
summary(All_Data$Medical_History_1) 
All_Data$Medical_History_1    <- ifelse(is.na(All_Data$Medical_History_1),
                                        mean(na.omit(All_Data$Medical_History_1)),  
                                        All_Data$Medical_History_1 )
# Medical_History_15
summary(All_Data$Medical_History_15) 
All_Data$Medical_History_15    <- ifelse(is.na(All_Data$Medical_History_15),
                                         mean(na.omit(All_Data$Medical_History_15)), 
                                         All_Data$Medical_History_15 )
# Family_Hist_5
summary(All_Data$Family_Hist_5)
All_Data$Family_Hist_5    <- ifelse(is.na(All_Data$Family_Hist_5),
                                    mean(na.omit(All_Data$Family_Hist_5)),  
                                    All_Data$Family_Hist_5 )
# Medical_History_24
summary(All_Data$Medical_History_24)
All_Data$Medical_History_24    <- ifelse(is.na(All_Data$Medical_History_24),
                                         mean(na.omit(All_Data$Medical_History_24)), 
                                         All_Data$Medical_History_24 )
# Medical_History_32
summary(All_Data$Medical_History_32)
All_Data$Medical_History_32    <- ifelse(is.na(All_Data$Medical_History_32),
                                         mean(na.omit(All_Data$Medical_History_32)),  
                                         All_Data$Medical_History_32 )
# Medical_History_10
summary(All_Data$Medical_History_10)
All_Data$Medical_History_10    <- ifelse(is.na(All_Data$Medical_History_10),
                                         mean(na.omit(All_Data$Medical_History_10)), 
                                         All_Data$Medical_History_10 )
# backup
All_Data_fulfill_bk <- All_Data

#=== [0, 1] Normalization ( Numerical var. ONLY) ===================================
features<-colnames(All_Data)[!(colnames(All_Data) %in% c("Id","Response","Train_Flag"))]

All_Data.scl <- data.frame(Id=All_Data$Id, Response=All_Data$Response, Train_Flag=All_Data$Train_Flag) 
for (f in features) {
  if (class(All_Data[[f]])!="factor") {
    cat(f,  class(All_Data[[f]]),":normalizing process wil be done. \n")
    All_Data.scl[[f]] <- as.numeric(scale(All_Data[[f]], 
                               center = min(All_Data[[f]]),
                               scale = max(All_Data[[f]]) - min(All_Data[[f]])) )
  }else {
    cat(f, class(All_Data[[f]]),":nothing to do \n")
    All_Data.scl[[f]] <- All_Data[[f]]
  }
}

str(All_Data.scl)
summary(All_Data.scl)


#=== Convert categorical variables to dummy ===================================
All_Data.tmp <- dummyVars(~., data=All_Data.scl)
All_Data.for.pylearn2 <- as.data.frame(predict(All_Data.tmp, All_Data.scl))

summary(All_Data.for.pylearn2)
str(All_Data.for.pylearn2)


#=== Target variable must be counted from zero because of pylearn2 requirement
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==1, 0, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==2, 1, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==3, 2, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==4, 3, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==5, 4, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==6, 5, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==7, 6, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==8, 7, All_Data.for.pylearn2$Response)

# Separate "All_Data" to "train" $ "test"
train.for.pylearn2 <- All_Data.for.pylearn2[All_Data.for.pylearn2$Train_Flag==1, -c(1,3)]
test.for.pylearn2  <- All_Data.for.pylearn2[All_Data.for.pylearn2$Train_Flag==0, -c(1,3)]
test.for.pylearn2$Response <- 0

#=== Separate "train.for.pylearn2" to large, mini & valid ===============
smp_size <- floor(0.8 * nrow(train.for.pylearn2))
set.seed(123)
train_rows <- sample(seq_len(nrow(train.for.pylearn2)), size = smp_size)
train_large  <- train.for.pylearn2[train_rows, ]          # 80% of train data
train_mini   <- train.for.pylearn2[sample(1:nrow(train.for.pylearn2), 1000), ]
valid_large  <- train.for.pylearn2[-train_rows, ]         # rest data (20%)
valid <- valid_large[sample(1:nrow(valid_large),1000),]
# Sampling test data having only 10 rows to make coding be easy
test_mini    <- test.for.pylearn2[c(1:10),]


# Make csv files
write.csv(train_large,       "out_for_pylearn2/train.csv",       row.names=F)
write.csv(train_mini,        "out_for_pylearn2/train_mini.csv",  row.names=F)
write.csv(valid_large,       "out_for_pylearn2/valid.csv",       row.names=F)
write.csv(valid,             "out_for_pylearn2/valid_mini.csv",  row.names=F)
write.csv(test.for.pylearn2, "out_for_pylearn2/test.csv",        row.names=F)
write.csv(test_mini,         "out_for_pylearn2/test_mini.csv",   row.names=F)


