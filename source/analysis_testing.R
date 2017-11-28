library(dplyr)
library(tibble)

#### ANALYSIS TESTING ####'
source("./source/data_processing.R")



#=== CHECK POTENTIAL COLINEARITY ===
cor_matrix <- cor(analysis_df %>% select_if(is.numeric))
max(cor_matrix[cor_matrix < 1 & cor_matrix > -1])

corrplot::corrplot(cor_matrix)


#==== ARE SOME FACTOR LEVELS TOO SMALL? SHOULD WE GROUP TO OTHER? ====#

x <- lapply(analysis_df %>% select_if(is.factor), function(x) min(prop.table(table(x))))
x[x<.05]


#==== UNIVATIATE MODEL TESTING ====#
uni_models_list <- lapply(names(analysis_df[, -1]), function(curVar){
  model_df <- data.frame(y = analysis_df$Attrition == "Yes")
  model_df[curVar] <- analysis_df[[curVar]]
  summary(glm(formula(paste("y ~ ", curVar)), model_df, family = binomial(link = "logit")))
})
names(uni_models_list) <- names(analysis_df[, -1])
uni_models_list
sort(sapply(uni_models_list, function(x) x$aic))


#=== GRADIENT BOOSTING VARIABLE IDENTIFICATION ====#
library(gbm)

gbm_model <- gbm.fit(as.data.frame(analysis_df[,-1]), analysis_df$Attrition == "Yes")
summary(gbm_model)

#=== RANDOM FOREST VARIABLE IDENTIFICATION ====#
library(randomForest)

rf_model <- randomForest(x = as.data.frame(analysis_df[,-1]), y = analysis_df$Attrition , importance = TRUE)
varImpPlot(rf_model)




