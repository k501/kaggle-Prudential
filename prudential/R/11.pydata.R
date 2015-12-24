install.packages("caret")
library(caret)

str(d, list.len=ncol(d))
str(test, list.len=ncol(test))

d$Train_Flag    <- 1  #Add in a flag to identify if observations fall in train data, 1 train, 0 test
test$Response   <- NA #Add in a column for Response in the test data and initialize to NA
test$Train_Flag <- 0  #Add in a flag to identify if observations fall in train data, 1 train, 0 test

#concatenate train and test together, any features we create will be on both data sets with the same code. This will make scoring easy
All_Data <- rbind(d,test) #79,146 observations, 129 variables 
All_Data_bk <- All_Data

str(All_Data, list.len=ncol(All_Data))

# Employment_Info_1
summary(All_Data$Employment_Info_1)
All_Data$Employment_Info_1_na <- ifelse(is.na(All_Data$Employment_Info_1), 1, 0 )
All_Data$Employment_Info_1    <- ifelse(is.na(All_Data$Employment_Info_1),-1, All_Data$Employment_Info_1 )

# Employment_Info_4 
summary(All_Data$Employment_Info_4)
All_Data$Employment_Info_4_na <- ifelse(is.na(All_Data$Employment_Info_4), 1, 0 )
All_Data$Employment_Info_4    <- ifelse(is.na(All_Data$Employment_Info_4),-1, All_Data$Employment_Info_4 )

# Employment_Info_6
summary(All_Data$Employment_Info_6)
All_Data$Employment_Info_6_na <- ifelse(is.na(All_Data$Employment_Info_6), 1, 0 )
All_Data$Employment_Info_6    <- ifelse(is.na(All_Data$Employment_Info_6),-1, All_Data$Employment_Info_6 )

#Insurance_History_5
summary(All_Data$Insurance_History_5)
All_Data$Insurance_History_5_na <- ifelse(is.na(All_Data$Insurance_History_5), 1, 0 )
All_Data$Insurance_History_5    <- ifelse(is.na(All_Data$Insurance_History_5),-1, All_Data$Insurance_History_5 )

# Family_Hist_2
summary(All_Data$Family_Hist_2) 
All_Data$Family_Hist_2_na <- ifelse(is.na(All_Data$Family_Hist_2), 1, 0 )
All_Data$Family_Hist_2    <- ifelse(is.na(All_Data$Family_Hist_2),-1, All_Data$Family_Hist_2 )

# Family_Hist_3
summary(All_Data$Family_Hist_3) 
All_Data$Family_Hist_3_na <- ifelse(is.na(All_Data$Family_Hist_3), 1, 0 )
All_Data$Family_Hist_3    <- ifelse(is.na(All_Data$Family_Hist_3),-1, All_Data$Family_Hist_3 )

# Family_Hist_4
summary(All_Data$Family_Hist_4) 
All_Data$Family_Hist_4_na <- ifelse(is.na(All_Data$Family_Hist_4), 1, 0 )
All_Data$Family_Hist_4    <- ifelse(is.na(All_Data$Family_Hist_4),-1, All_Data$Family_Hist_4 )

# Medical_History_1
summary(All_Data$Medical_History_1) 
All_Data$Medical_History_1_na <- ifelse(is.na(All_Data$Medical_History_1), 1, 0 )
All_Data$Medical_History_1    <- ifelse(is.na(All_Data$Medical_History_1),-1, All_Data$Medical_History_1 )

# Medical_History_15
summary(All_Data$Medical_History_15) 
All_Data$Medical_History_15_na <- ifelse(is.na(All_Data$Medical_History_15), 1, 0 )
All_Data$Medical_History_15    <- ifelse(is.na(All_Data$Medical_History_15),-1, All_Data$Medical_History_15 )

# Family_Hist_5
summary(All_Data$Family_Hist_5)
All_Data$Family_Hist_5_na <- ifelse(is.na(All_Data$Family_Hist_5), 1, 0 )
All_Data$Family_Hist_5    <- ifelse(is.na(All_Data$Family_Hist_5),-1, All_Data$Family_Hist_5 )

# Medical_History_10
summary(All_Data$Medical_History_10)
All_Data$Medical_History_10_na <- ifelse(is.na(All_Data$Medical_History_10), 1, 0 )
All_Data$Medical_History_10    <- ifelse(is.na(All_Data$Medical_History_10),-1, All_Data$Medical_History_10 )

# Medical_History_24
summary(All_Data$Medical_History_24)
All_Data$Medical_History_24_na <- ifelse(is.na(All_Data$Medical_History_24), 1, 0 )
All_Data$Medical_History_24    <- ifelse(is.na(All_Data$Medical_History_24),-1, All_Data$Medical_History_24 )

# Medical_History_32
summary(All_Data$Medical_History_32)
All_Data$Medical_History_32_na <- ifelse(is.na(All_Data$Medical_History_32), 1, 0 )
All_Data$Medical_History_32    <- ifelse(is.na(All_Data$Medical_History_32),-1, All_Data$Medical_History_32 )

str(All_Data, list.len=ncol(All_Data))

# Convert categorical variables to dummy
All_Data.tmp <- dummyVars(~., data=All_Data)
All_Data.dummy <- as.data.frame(predict(All_Data.tmp, All_Data))

# Move "Id" & "Response" to the first & second column
features<-colnames(All_Data.dummy)[!(colnames(All_Data.dummy) %in% c("Id","Response"))]
All_Data.for.pylearn2 <- data.frame(Id=All_Data.dummy$Id,Response = All_Data.dummy$Response, All_Data.dummy[,features])
str(All_Data.for.pylearn2, list.len=ncol(All_Data.for.pylearn2))

# Target variable must be counted from zero because of pylearn2 requirement
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==1, 0, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==2, 1, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==3, 2, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==4, 3, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==5, 4, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==6, 5, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==7, 6, All_Data.for.pylearn2$Response)
All_Data.for.pylearn2$Response <- ifelse(All_Data.for.pylearn2$Response==8, 7, All_Data.for.pylearn2$Response)

# Separate "All_Data" to "train" $ "test"
train.for.pylearn2 <- All_Data.for.pylearn2[All_Data.for.pylearn2$Train_Flag==1, -c(1)]  # Remove Id
test.for.pylearn2  <- All_Data.for.pylearn2[All_Data.for.pylearn2$Train_Flag==0, -c(1)]  # Remove Id 
test.for.pylearn2$Response <- 0

# Separate "train.for.pylearn2" to large, mini & valid
smp_size <- floor(0.8 * nrow(train.for.pylearn2))
set.seed(123)
train_rows <- sample(seq_len(nrow(train.for.pylearn2)), size = smp_size)
train_large  <- train.for.pylearn2[train_rows, ]          # 80% of train data
train_mini   <- train.for.pylearn2[sample(1:nrow(train.for.pylearn2), 1000), ]
valid_large  <- train.for.pylearn2[-train_rows, ]         # rest data (20%)
valid <- valid_large[sample(1:nrow(valid_large),1000),]  # make valid data have 1,000 rows for simplicity of valid process
# Sampling test data having only 10 rows to make coding be easy
test_mini    <- test.for.pylearn2[c(1:10),]

# Make csv files
write.csv(train_large,       "out_for_pylearn2/train.csv",       row.names=F)
write.csv(train_mini,        "out_for_pylearn2/train_mini.csv",  row.names=F)
write.csv(valid,             "out_for_pylearn2/valid.csv",       row.names=F)
write.csv(test.for.pylearn2, "out_for_pylearn2/test.csv",        row.names=F)
write.csv(test_mini,         "out_for_pylearn2/test_mini.csv",   row.names=F)


