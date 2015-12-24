#install.packages("caret")
library(caret)

str(d, list.len=ncol(d))

# remove columns almost NA
All_Data <- d[,-c(38, 48, 62, 70)]

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


# convert categorical variables to dummy
All_Data.tmp <- dummyVars(~., data=All_Data)
All_Data.dummy <- as.data.frame(predict(All_Data.tmp, All_Data))

# move "Response" to the top column & d2 is final dataset of conversion process for pylearn2
features<-colnames(All_Data.dummy)[!(colnames(All_Data.dummy) %in% c("Id", "Response"))]
d2 <- data.frame(Response = All_Data.dummy$Response, All_Data.dummy[,features])
str(d2, list.len=ncol(d2))

# target variables must be counted from zero because of pylearn2 requirement
d2$Response <- ifelse(d2$Response==1, 0, d2$Response)
d2$Response <- ifelse(d2$Response==2, 1, d2$Response)
d2$Response <- ifelse(d2$Response==3, 2, d2$Response)
d2$Response <- ifelse(d2$Response==4, 3, d2$Response)
d2$Response <- ifelse(d2$Response==5, 4, d2$Response)
d2$Response <- ifelse(d2$Response==6, 5, d2$Response)
d2$Response <- ifelse(d2$Response==7, 6, d2$Response)
d2$Response <- ifelse(d2$Response==8, 7, d2$Response)
table(d2$Response)

#separate original data to train & valid
nr <- nrow(d2)
train      <- d2[sample(1:nr,3*nr/4),]
valid      <- d2[sample(1:nr,  nr/4),] 
train_mini <- d2[sample(1:nr,nr/50),]
valid_mini <- d2[sample(1:nr,nr/50),]

write.csv(train_mini, "out_for_pylearn2/train_mini.csv",row.names=F)
write.csv(train, "out_for_pylearn2/train.csv",row.names=F)
write.csv(valid_mini, "out_for_pylearn2/valid_mini.csv",row.names=F)
write.csv(valid, "out_for_pylearn2/valid.csv",row.names=F)


#--------------------------------------------------------------------------------------------------
# remove columns almost NA
test1 <- test[,-c(38, 48, 62, 70)]

# Employment_Info_1
summary(test1$Employment_Info_1)
test1$Employment_Info_1_na <- ifelse(is.na(test1$Employment_Info_1), 1, 0 )
test1$Employment_Info_1    <- ifelse(is.na(test1$Employment_Info_1),-1, test1$Employment_Info_1 )

# Employment_Info_4
summary(test1$Employment_Info_4)
test1$Employment_Info_4_na <- ifelse(is.na(test1$Employment_Info_4), 1, 0 )
test1$Employment_Info_4    <- ifelse(is.na(test1$Employment_Info_4),-1, test1$Employment_Info_4 )

# Employment_Info_6
summary(test1$Employment_Info_6)
test1$Employment_Info_6_na <- ifelse(is.na(test1$Employment_Info_6), 1, 0 )
test1$Employment_Info_6    <- ifelse(is.na(test1$Employment_Info_6),-1, test1$Employment_Info_6 )

#Insurance_History_5
summary(test1$Insurance_History_5)
test1$Insurance_History_5_na <- ifelse(is.na(test1$Insurance_History_5), 1, 0 )
test1$Insurance_History_5    <- ifelse(is.na(test1$Insurance_History_5),-1, test1$Insurance_History_5 )

# Family_Hist_2
summary(test1$Family_Hist_2) 
test1$Family_Hist_2_na <- ifelse(is.na(test1$Family_Hist_2), 1, 0 )
test1$Family_Hist_2    <- ifelse(is.na(test1$Family_Hist_2),-1, test1$Family_Hist_2 )

# Family_Hist_3
summary(test1$Family_Hist_3) 
test1$Family_Hist_3_na <- ifelse(is.na(test1$Family_Hist_3), 1, 0 )
test1$Family_Hist_3    <- ifelse(is.na(test1$Family_Hist_3),-1, test1$Family_Hist_3 )

# Family_Hist_4
summary(test1$Family_Hist_4) 
test1$Family_Hist_4_na <- ifelse(is.na(test1$Family_Hist_4), 1, 0 )
test1$Family_Hist_4    <- ifelse(is.na(test1$Family_Hist_4),-1, test1$Family_Hist_4 )

# Medical_History_1
summary(test1$Medical_History_1) 
test1$Medical_History_1_na <- ifelse(is.na(test1$Medical_History_1), 1, 0 )
test1$Medical_History_1    <- ifelse(is.na(test1$Medical_History_1),-1, test1$Medical_History_1 )

# Medical_History_15
summary(test1$Medical_History_15) 
test1$Medical_History_15_na <- ifelse(is.na(test1$Medical_History_15), 1, 0 )
test1$Medical_History_15    <- ifelse(is.na(test1$Medical_History_15),-1, test1$Medical_History_15 )

# Response -> numerical vars.
test1$Response <- as.numeric(test1$Response)

# convert categorical variables to dummy
test1.tmp <- dummyVars(~., data=test1)
test1.dummy <- as.data.frame(predict(test1.tmp, test1))

# move "Response" to the top column & d2 is final dataset of conversion process for pylearn2
#features<-colnames(test1.dummy)[!(colnames(test1.dummy) %in% c("Id", "Response"))]
test2 <- test1.dummy
str(test2, list.len=ncol(d2))

# make small size test data for code development at pylearn2
nr2 <- nrow(test2)
test_mini <- test2[sample(1:nr2,10),]

# make a csv file for pylearn2
write.csv(test2,     "out_for_pylearn2/test.csv",row.names=F)
write.csv(test_mini, "out_for_pylearn2/test_mini.csv",row.names=F)

