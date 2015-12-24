

res <- read.csv("from_pylearn2/test.csv", header = F)

names(res) <- c("Response")

res$Response <- ifelse(res$Response==7, 8, res$Response)
res$Response <- ifelse(res$Response==6, 7, res$Response)
res$Response <- ifelse(res$Response==5, 6, res$Response)
res$Response <- ifelse(res$Response==4, 5, res$Response)
res$Response <- ifelse(res$Response==3, 4, res$Response)
res$Response <- ifelse(res$Response==2, 3, res$Response)
res$Response <- ifelse(res$Response==1, 2, res$Response)
res$Response <- ifelse(res$Response==0, 1, res$Response)

submission <- data.frame(Id = test$Id, Response = res$Response)

write.csv(submission, "submit/20151217_1.csv",row.names=F)




