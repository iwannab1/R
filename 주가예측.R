library(caret)
library(dplyr)

df=read.csv("sk.csv",fileEncoding = "UTF-8",header=T,fill=T)

df = df %>% select(날짜시간, 종가.차.등락.,종가,거래량, X5일..평균.등락율, X20일.평균.등락,POSC,TRIX)
df$종가등락여부 = sign(df$종가.차.등락.)
df$종가등락여부 = as.factor(df$종가등락여부)
df=df[order(df$날짜시간),]
colnames(df) = c("date","x","close","amount","five","twenty","posc","trix","Y")


train_df=df[21:289,]
test_df=df[290:412,]


trCtrl = trainControl(method = "timeslice",
                      initialWindow = 50,
                      horizon = 20,
                      fixedWindow = TRUE,
                      allowParallel = TRUE,
                      verboseIter=TRUE)


model = train(Y ~ .-date-x, df, method="rf", maximize=TRUE, trControl=trCtrl)
pred = predict(model, test_df)
(table = table(pred, test_df$Y)) 
confusionMatrix(table)


