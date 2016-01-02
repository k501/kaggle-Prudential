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


smp_size2 <- floor(0.1 * nrow(d))
set.seed(123)
train_rows2 <- sample(seq_len(nrow(d)), size = smp_size2)
train_mini_keras  <- d[train_rows2, ]          # 10% of train data

smp_size3 <- floor(0.1 * nrow(test))
set.seed(123)
test_rows2 <- sample(seq_len(nrow(test)), size = smp_size3)
test_mini_keras  <- test[test_rows2, ]          # 10% of train data


# Make csv files
write.csv(train_mini_keras,       "data/train_mini.csv",       row.names=F)
write.csv(test_mini_keras,        "data/test_mini.csv",  row.names=F)
