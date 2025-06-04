library(caret)
library(rpart)
library(rpart.plot)


#Discard useless variables
ds[["division"]] <- NULL
ds[["work_accident"]] <- NULL

#Generate training and test set (70%-30%) by random sampling
set.seed(1977)
trainIndex <- createDataPartition(ds$left, p = 0.7,list = FALSE,times = 1) 
train <- ds[ trainIndex,]
test <- ds[-trainIndex,]

#Set the evaluation mode (10-fold CV, repeated 3 times)
eval.mode <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE, summaryFunction = twoClassSummary)


---CART------------------------------------------------
#Investigate the default parameter values
CART.model <- train(left~., data = train, method="rpart", trControl = eval.mode, metric="ROC")

#Set the parameter grid and find the best model
CART.grid <- expand.grid(cp = (1:20)*0.01)
CART.model <- train(left~., data = train, method="rpart", trControl = eval.mode, tuneGrid = CART.grid, metric="ROC")
#otherwise...metric="Sens", metric="Sens"
plot(CART.model)

#Read and visualize the best model
CART.model$finalModel
rpart.plot(CART.model$finalModel,tweak=1.1,extra=1)

#Generate predictions for the examples in the test set (hold-out examples)
CART.preds.class <- predict(CART.model,test)
confusionMatrix(CART.preds.class, test$left, positive = "yes")
CART.preds.prob <- predict(CART.model,test,type = "prob")

#Build the cumulative gain chart on the test set
gain_chart <- data.frame(class = test$left)
gain_chart$CART <- CART.preds.prob$yes
cum.gain <- lift(class ~ CART, class = "yes", data = gain_chart)
plot(cum.gain, lwd = 3, col = "black", xlab="% Of population reached", ylab = "% Of true positive responses", cex =1.3)

