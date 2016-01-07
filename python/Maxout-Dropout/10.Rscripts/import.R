install.packages("caret")
library(caret)

train <- read.csv('data/train.csv')
train_normalized <- read.csv('data/train_normalized.csv')
train_All <- data.frame(Response=train$Response, train_normalized)

str(train)
summary(train)

#===
smp_size <- floor(0.8 * nrow(train_All))
set.seed(123)
train_sample_rows_numbers <- sample(seq_len(nrow(train)), size = smp_size)
#
train_large  <- train_All[train_sample_rows_numbers, ]
train_mini   <- train_All[sample(1:nrow(train_All), 1000), ]
#
valid_large  <- train_All[-train_sample_rows_numbers, ]
valid_mini <- valid_large[sample(1:nrow(valid_large),1000),]

#=== 
write.csv(train_large, "01.pydata/train.csv",row.names=F)
write.csv(train_mini,  "01.pydata/train_mini.csv",row.names=F)
write.csv(valid_large, "01.pydata/valid.csv",row.names=F)
write.csv(valid_mini,  "01.pydata/valid_mini.csv",row.names=F)
