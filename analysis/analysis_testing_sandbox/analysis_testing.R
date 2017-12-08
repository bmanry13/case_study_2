library(dplyr)
library(MASS)
library(ggplot2)

#### ANALYSIS TESTING ####'
source("./source/data_processing.R")

#=== CHECK POTENTIAL COLINEARITY ====#
cor_matrix <- cor(analysis_df %>% mutate(Attrition = as.numeric(Attrition == "Yes")) %>% select_if(is.numeric))
max(cor_matrix[cor_matrix < 1 & cor_matrix > -1])
corrplot::corrplot(cor_matrix)


#==== ARE SOME FACTOR LEVELS TOO SMALL? SHOULD WE GROUP TO OTHER? ====#

x <- lapply(analysis_df %>% select_if(is.factor), function(x) min(prop.table(table(x))))
x[x<.05]


#==== UNIVATIATE MODEL TESTING ====#
#-- Logit All Variables --
uni_models_list <- lapply(names(analysis_df[, -1]), function(curVar){
  model_df <- data.frame(y = analysis_df$Attrition == "Yes")
  model_df[curVar] <- analysis_df[[curVar]]
  summary(glm(formula(paste("y ~ ", curVar)), model_df, family = binomial(link = "logit")))
})
names(uni_models_list) <- names(analysis_df[, -1])
uni_models_list
top_logit <- sort(sapply(uni_models_list, function(x) x$aic))
top_logit <- names(head(top_logit,5))

#-- Categorical Chi-Square Testing
chi_sq_list <- lapply(names(analysis_df[, -1] %>% select_if(is.factor)),  function(curVar){
  tbl <- table(analysis_df[[curVar]], analysis_df$Attrition)
  print(curVar)
  print(tbl)
  chisq.test(tbl)
})
names(chi_sq_list) <- names(analysis_df[, -1] %>% select_if(is.factor))
chi_sq_list
top_chi <- sort(sapply(chi_sq_list, function(x) x$p.value))
top_chi <- names(head(top_chi,5))

#=== STEPWISE AIC ====#

multi_logit <- glm(paste("Attrition ~", paste(unique(top_chi, top_logit), collapse = " + ")), data = analysis_df %>% mutate(Attrition = Attrition == "Yes")  ,family = binomial(link = "logit"))
summary(multi_logit)
stepAIC(multi_logit,direction = "both")

#=== GRADIENT BOOSTING VARIABLE IDENTIFICATION ====#
library(gbm)

gbm_model <- gbm.fit(as.data.frame(analysis_df[,-1]), analysis_df$Attrition == "Yes")
gbm_plot_data <- data.frame(Var = summary(gbm_model)$var, Influence = summary(gbm_model)$rel.inf)
gbm_plot_data$Var <- factor(gbm_plot_data$Var, gbm_plot_data$Var[order(gbm_plot_data$Influence)])

ggplot(gbm_plot_data) +
  geom_bar(aes(Var, Influence), stat = "identity") +
  xlab("") +
  ylab("Rel Influence") +
  coord_flip()

top_gbm <- as.character(head(summary(gbm_model)$var,6))

#=== RANDOM FOREST VARIABLE IDENTIFICATION ====#
library(randomForest)

rf_model <- randomForest(x = as.data.frame(analysis_df[,-1]), y = analysis_df$Attrition == "Yes" , importance = TRUE)
rf_model
varImpPlot(rf_model)
importance(rf_model)
top_rf <- tail(rownames(importance(rf_model, type=1))[order(importance(rf_model, type=1))],5)

#-- Combine Top Variables ---#
all_top <- unique(c(top_logit, top_chi, top_gbm, top_rf))

#- Combined Modle -#
all_model <- glm("Attrition ~ .", data = analysis_df[c("Attrition",all_top)] %>% mutate(Attrition = Attrition == "Yes"), family = binomial(link = "logit"))
summary(all_model)
#- Stepwise Backward Variable Reduction -#
step_reduce_model <- stepAIC(all_model, direction = "back")
step_reduce_model$coefficients
summary(step_reduce_model)

# Odds Ratios
or_table <- exp(cbind(OR = coef(step_reduce_model), confint(step_reduce_model)))
or_table

#p-value
with(step_reduce_model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))







