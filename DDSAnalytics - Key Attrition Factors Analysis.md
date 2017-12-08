# DDSAnalytics - Key Attrition Factors Analysis
Brychan Manry, Patricia Goresen, and Bradley Robinson  
`r params$run_date`  
[Link to GitHub Repository](https://github.com/bmanry13/case_study_2)


```r
knitr::opts_chunk$set(echo = TRUE, message=FALSE)
```

# Executive Summary

Using a combination of univariate and machine learning techniques to identify variables in the data which are important when predicting employee attrition the team was able to identify five variables which play a key role in employee attrition:

1. Overtime
2. Stock Option Level
3. Job Role
4. Job Level
5. Years with current manager

The results of a model using these five variables suggests that:

* If an employee is required to work overtime they are nearly five times more likely to leave the company
* Once an employee reaches job level 2 they are around four times less likely to leave
* The addition stock options reduces the likelihood of an employee leaving by two to four times compared to employees with no stock option

Some additional findings include:

* Recorded data was useful for determining attrition
* Different methodologies can lead to different conclusions about what variables are most important
* Combining different measures, we determined that the top 5 variables determining attrition are:
* We discovered no statistically significant trends that lead to a higher job satisfaction



# Introduction 
DDSAnalytics, an analytics company that specialized in talent management solutions for Furtune 100 companies, is planning to leverage data science for talent management. Talent management is defined as the iterative process of developing and retaining employees. It may include workforce planning, employee training programs, identifying high-potential employees and reducing/preventing voluntary employee turnover (attrition). Our goal is to maximize talent management. 

# Purpose 
This project uses exploratory data analysis to determine the top three factors that lead to attrition. In addition, we want to discover trends within specific job roles. This will give DDSAnalytics a competitive edge over its competition.

## Goals:
* Determine the top factors that lead to employee attrition
* Identify trends within job roles that might exist in the data
* Discover Employee Demographics

# About the Data:
* There are 35 separate variables, including attrition
* Variables that should be excluded for legal reasons: Age, Gender and Marital Status
* Some Variables have little or no information so are discarded: Employee Number, Over 18, Standard Hours


##Data Processing and Cleaning
1. Unzip and load raw data
2. Process data definitions information for categorical variables
3. Process raw data
4. Apply processed factors
5. Remove uninformative or high-risk variables

For more detailed information on data processing please refer to the  [data_processing.R](https://github.com/bmanry13/case_study_1/blob/master/source/data_processing.R) file located on the GitHub repository.


#Analysis
##Influential Variable Identification
The team used a combination of univariate,  machine learning techniques to identify variables in the data which are important when predicting employee attrition.

*Process Overview:*
1. Collinearity Assessment
2. Univariate modeling
  + a. logit
  + b. chi-square
3. Machine learning
  + a. random forest 
  + b. gradient boosted trees (gbm)
4. Determine Top-Variables Across Methods (stepwise AIC)

### 1) Collinearity Assessment 

```r
#=== CHECK POTENTIAL COLINEARITY ====#
cor_matrix <- cor(analysis_df %>% mutate(Attrition = as.numeric(Attrition == "Yes")) %>% select_if(is.numeric))
max(cor_matrix[cor_matrix < 1 & cor_matrix > -1])
```

```
## [1] 0.7728932
```

```r
corrplot::corrplot(cor_matrix)
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/coLinAssess-1.png)<!-- -->

Some variables show some pairwise correlation, however none of the correlations are high enough to require variable removal since our variable identification methods are robust to collinearity

### 2) Univariate Model Testing
#### 2a) Logit Univariate Top-Variable Assessment

```r
#-- Logit All Variables --
uni_models_list <- lapply(names(analysis_df[, -1]), function(curVar){
  model_df <- data.frame(y = analysis_df$Attrition == "Yes")
  model_df[curVar] <- analysis_df[[curVar]]
  summary(glm(formula(paste("y ~ ", curVar)), model_df, family = binomial(link = "logit")))
})
names(uni_models_list) <- names(analysis_df[, -1])
uni_models_list
```

```
## $BusinessTravel
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7569  -0.5692  -0.5692  -0.4084   2.2475  
## 
## Coefficients:
##                                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                      -2.4423     0.3010  -8.115 4.86e-16 ***
## BusinessTravelTravel_Frequently   1.3389     0.3315   4.039 5.36e-05 ***
## BusinessTravelTravel_Rarely       0.7044     0.3132   2.249   0.0245 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1274.8  on 1467  degrees of freedom
## AIC: 1280.8
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $DailyRate
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6673  -0.6182  -0.5752  -0.5362   2.0296  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.3495400  0.1521092  -8.872   <2e-16 ***
## DailyRate   -0.0003834  0.0001769  -2.168   0.0302 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1293.9  on 1468  degrees of freedom
## AIC: 1297.9
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $Department
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6797  -0.6501  -0.5458  -0.5458   1.9888  
## 
## Coefficients:
##                                  Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                      -1.44692    0.32084  -4.510 6.49e-06 ***
## DepartmentResearch & Development -0.38175    0.33417  -1.142    0.253    
## DepartmentSales                   0.09941    0.34152   0.291    0.771    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1288.1  on 1467  degrees of freedom
## AIC: 1294.1
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $DistanceFromHome
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7341  -0.5947  -0.5618  -0.5366   2.0046  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      -1.890051   0.111382 -16.969  < 2e-16 ***
## DistanceFromHome  0.024710   0.008312   2.973  0.00295 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1290.0  on 1468  degrees of freedom
## AIC: 1294
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $Education
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6345  -0.6165  -0.5825  -0.5613   2.1269  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       -1.50049    0.19863  -7.554 4.21e-14 ***
## EducationCollege  -0.18759    0.25765  -0.728    0.467    
## EducationBachelor -0.06349    0.22730  -0.279    0.780    
## EducationMaster   -0.26802    0.24420  -1.098    0.272    
## EducationDoctor   -0.65128    0.51253  -1.271    0.204    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1295.4  on 1465  degrees of freedom
## AIC: 1305.4
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $EducationField
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7747  -0.5636  -0.5636  -0.5402   2.0044  
## 
## Coefficients:
##                                Estimate Std. Error z value Pr(>|z|)  
## (Intercept)                    -1.04982    0.43915  -2.391   0.0168 *
## EducationFieldLife Sciences    -0.70958    0.45390  -1.563   0.1180  
## EducationFieldMarketing        -0.21511    0.47905  -0.449   0.6534  
## EducationFieldMedical          -0.80100    0.45959  -1.743   0.0814 .
## EducationFieldOther            -0.81496    0.54576  -1.493   0.1354  
## EducationFieldTechnical Degree -0.08961    0.48385  -0.185   0.8531  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1283.7  on 1464  degrees of freedom
## AIC: 1295.7
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $EnvironmentSatisfaction
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7647  -0.5698  -0.5426  -0.5375   2.0030  
## 
## Coefficients:
##                                  Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                       -1.0799     0.1364  -7.917 2.43e-15 ***
## EnvironmentSatisfactionMedium     -0.6560     0.2144  -3.060  0.00221 ** 
## EnvironmentSatisfactionHigh       -0.7617     0.1931  -3.944 8.01e-05 ***
## EnvironmentSatisfactionVery High  -0.7816     0.1946  -4.017 5.90e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1278.0  on 1466  degrees of freedom
## AIC: 1286
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $HourlyRate
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6019  -0.5964  -0.5909  -0.5860   1.9242  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.5889155  0.2397695  -6.627 3.43e-11 ***
## HourlyRate  -0.0009159  0.0034896  -0.262    0.793    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1298.5  on 1468  degrees of freedom
## AIC: 1302.5
## 
## Number of Fisher Scoring iterations: 3
## 
## 
## $JobInvolvement
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.9072  -0.5577  -0.5577  -0.4657   2.1931  
## 
## Coefficients:
##                         Estimate Std. Error z value Pr(>|z|)    
## (Intercept)              -0.6751     0.2322  -2.908  0.00364 ** 
## JobInvolvementMedium     -0.7792     0.2670  -2.919  0.00351 ** 
## JobInvolvementHigh       -1.1073     0.2515  -4.403 1.07e-05 ***
## JobInvolvementVery High  -1.6351     0.3720  -4.395 1.11e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1272.9  on 1466  degrees of freedom
## AIC: 1280.9
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $JobLevel
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7819  -0.7819  -0.4527  -0.3879   2.4714  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.02862    0.09743 -10.557  < 2e-16 ***
## JobLevel2   -1.19808    0.17549  -6.827 8.68e-12 ***
## JobLevel3   -0.73139    0.21475  -3.406  0.00066 ***
## JobLevel4   -1.97706    0.46836  -4.221 2.43e-05 ***
## JobLevel5   -1.52083    0.47447  -3.205  0.00135 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1225.1  on 1465  degrees of freedom
## AIC: 1235.1
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $JobRole
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.0068  -0.6200  -0.5925  -0.3170   2.7162  
## 
## Coefficients:
##                                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                   -2.606796   0.345410  -7.547 4.45e-14 ***
## JobRoleHuman Resources         1.402824   0.477118   2.940 0.003280 ** 
## JobRoleLaboratory Technician   1.450727   0.374851   3.870 0.000109 ***
## JobRoleManager                -0.358477   0.574123  -0.624 0.532371    
## JobRoleManufacturing Director  0.004107   0.476146   0.009 0.993118    
## JobRoleResearch Director      -1.056765   0.795058  -1.329 0.183793    
## JobRoleResearch Scientist      0.955686   0.380350   2.513 0.011983 *  
## JobRoleSales Executive         1.055136   0.374926   2.814 0.004889 ** 
## JobRoleSales Representative    2.191281   0.411838   5.321 1.03e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1209.7  on 1461  degrees of freedom
## AIC: 1227.7
## 
## Number of Fisher Scoring iterations: 6
## 
## 
## $JobSatisfaction
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7201  -0.6008  -0.5991  -0.4904   2.0870  
## 
## Coefficients:
##                          Estimate Std. Error z value Pr(>|z|)    
## (Intercept)               -1.2175     0.1401  -8.689  < 2e-16 ***
## JobSatisfactionMedium     -0.4092     0.2137  -1.915   0.0555 .  
## JobSatisfactionHigh       -0.4028     0.1899  -2.122   0.0339 *  
## JobSatisfactionVery High  -0.8401     0.2033  -4.132 3.59e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1281.2  on 1466  degrees of freedom
## AIC: 1289.2
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $MonthlyIncome
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7704  -0.6646  -0.5811  -0.3430   2.6399  
## 
## Coefficients:
##                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   -9.291e-01  1.292e-01  -7.191 6.43e-13 ***
## MonthlyIncome -1.271e-04  2.162e-05  -5.879 4.12e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1253.1  on 1468  degrees of freedom
## AIC: 1257.1
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $MonthlyRate
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6131  -0.6008  -0.5890  -0.5780   1.9412  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.733e+00  1.611e-01 -10.754   <2e-16 ***
## MonthlyRate  5.798e-06  9.970e-06   0.582    0.561    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1298.2  on 1468  degrees of freedom
## AIC: 1302.2
## 
## Number of Fisher Scoring iterations: 3
## 
## 
## $NumCompaniesWorked
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6742  -0.5956  -0.5711  -0.5592   1.9662  
## 
## Coefficients:
##                    Estimate Std. Error z value Pr(>|z|)    
## (Intercept)        -1.77652    0.10636 -16.703   <2e-16 ***
## NumCompaniesWorked  0.04565    0.02742   1.665    0.096 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1295.9  on 1468  degrees of freedom
## AIC: 1299.9
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $OverTime
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.8535  -0.4695  -0.4695  -0.4695   2.1260  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -2.1496     0.1007 -21.338   <2e-16 ***
## OverTimeYes   1.3274     0.1466   9.056   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1217.2  on 1468  degrees of freedom
## AIC: 1221.2
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $PercentSalaryHike
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6045  -0.5990  -0.5934  -0.5771   1.9540  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       -1.49563    0.30459  -4.910 9.09e-07 ***
## PercentSalaryHike -0.01012    0.01959  -0.517    0.605    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1298.3  on 1468  degrees of freedom
## AIC: 1302.3
## 
## Number of Fisher Scoring iterations: 3
## 
## 
## $PerformanceRating
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.5980  -0.5921  -0.5921  -0.5921   1.9120  
## 
## Coefficients:
##                              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                  -1.65250    0.07719 -21.409   <2e-16 ***
## PerformanceRatingOutstanding  0.02167    0.19564   0.111    0.912    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1298.6  on 1468  degrees of freedom
## AIC: 1302.6
## 
## Number of Fisher Scoring iterations: 3
## 
## 
## $RelationshipSatisfaction
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6802  -0.5797  -0.5671  -0.5663   1.9543  
## 
## Coefficients:
##                                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                        -1.3460     0.1487  -9.052   <2e-16 ***
## RelationshipSatisfactionMedium     -0.4003     0.2196  -1.823   0.0683 .  
## RelationshipSatisfactionHigh       -0.3523     0.1969  -1.789   0.0736 .  
## RelationshipSatisfactionVery High  -0.4032     0.2011  -2.005   0.0450 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1293.6  on 1466  degrees of freedom
## AIC: 1301.6
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $StockOptionLevel
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7480  -0.7480  -0.4442  -0.3975   2.2706  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       -1.13056    0.09268 -12.198  < 2e-16 ***
## StockOptionLevel1 -1.13565    0.16822  -6.751 1.47e-11 ***
## StockOptionLevel2 -1.36814    0.31428  -4.353 1.34e-05 ***
## StockOptionLevel3 -0.40988    0.29924  -1.370    0.171    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1236.9  on 1466  degrees of freedom
## AIC: 1244.9
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $TotalWorkingYears
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.8320  -0.6559  -0.5899  -0.3658   2.8322  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       -0.88306    0.12744  -6.929 4.23e-12 ***
## TotalWorkingYears -0.07773    0.01217  -6.387 1.69e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1248.1  on 1468  degrees of freedom
## AIC: 1252.1
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $TrainingTimesLastYear
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6959  -0.6191  -0.5834  -0.5171   2.0942  
## 
## Coefficients:
##                       Estimate Std. Error z value Pr(>|z|)    
## (Intercept)            -1.2948     0.1675  -7.731 1.07e-14 ***
## TrainingTimesLastYear  -0.1300     0.0571  -2.276   0.0229 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1293.3  on 1468  degrees of freedom
## AIC: 1297.3
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $WorkLifeBalance
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.8657  -0.6077  -0.5539  -0.5539   1.9750  
## 
## Coefficients:
##                       Estimate Std. Error z value Pr(>|z|)    
## (Intercept)            -0.7885     0.2412  -3.269 0.001080 ** 
## WorkLifeBalanceGood    -0.8071     0.2809  -2.873 0.004066 ** 
## WorkLifeBalanceBetter  -1.0085     0.2595  -3.886 0.000102 ***
## WorkLifeBalanceBest    -0.7520     0.3212  -2.341 0.019215 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1284.5  on 1466  degrees of freedom
## AIC: 1292.5
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $YearsAtCompany
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7399  -0.6408  -0.5737  -0.4233   2.9660  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -1.15577    0.11137 -10.378  < 2e-16 ***
## YearsAtCompany -0.08076    0.01594  -5.068 4.03e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1266.5  on 1468  degrees of freedom
## AIC: 1270.5
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $YearsInCurrentRole
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7520  -0.6607  -0.5405  -0.4098   2.5878  
## 
## Coefficients:
##                    Estimate Std. Error z value Pr(>|z|)    
## (Intercept)        -1.11841    0.10380 -10.775  < 2e-16 ***
## YearsInCurrentRole -0.14628    0.02424  -6.033 1.61e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1255.9  on 1468  degrees of freedom
## AIC: 1259.9
## 
## Number of Fisher Scoring iterations: 5
## 
## 
## $YearsSinceLastPromotion
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.6101  -0.6101  -0.6018  -0.5543   2.0769  
## 
## Coefficients:
##                         Estimate Std. Error z value Pr(>|z|)    
## (Intercept)             -1.58703    0.08501 -18.670   <2e-16 ***
## YearsSinceLastPromotion -0.02979    0.02358  -1.263    0.206    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1296.9  on 1468  degrees of freedom
## AIC: 1300.9
## 
## Number of Fisher Scoring iterations: 4
## 
## 
## $YearsWithCurrManager
## 
## Call:
## glm(formula = formula(paste("y ~ ", curVar)), family = binomial(link = "logit"), 
##     data = model_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.7428  -0.6552  -0.5760  -0.4129   2.5175  
## 
## Coefficients:
##                      Estimate Std. Error z value Pr(>|z|)    
## (Intercept)          -1.14677    0.10244 -11.195  < 2e-16 ***
## YearsWithCurrManager -0.14138    0.02407  -5.874 4.26e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.6  on 1469  degrees of freedom
## Residual deviance: 1258.7  on 1468  degrees of freedom
## AIC: 1262.7
## 
## Number of Fisher Scoring iterations: 5
```

```r
top_logit <- sort(sapply(uni_models_list, function(x) x$aic))
top_logit <- names(head(top_logit,5))
top_logit
```

```
## [1] "OverTime"          "JobRole"           "JobLevel"         
## [4] "StockOptionLevel"  "TotalWorkingYears"
```

For each variable in the data a univariate logit model was run to assess how correlated the variable is with employee attrition

The models were ranked based on AIC and top-5 variables were retained for further analysis:

1. OverTime

2. JobRole

3. JobLevel

4. StockOptionLevel

5. TotalWorkingYears

#### 2b) Chi-Square Univariate Top-Variable Assessment

```r
#-- Categorical Chi-Square Testing
chi_sq_list <- lapply(names(analysis_df[, -1] %>% select_if(is.factor)),  function(curVar){
  tbl <- table(analysis_df[[curVar]], analysis_df$Attrition)
  print(curVar)
  print(tbl)
  chisq.test(tbl)
})
```

```
## [1] "BusinessTravel"
##                    
##                      No Yes
##   Non-Travel        138  12
##   Travel_Frequently 208  69
##   Travel_Rarely     887 156
## [1] "Department"
##                         
##                           No Yes
##   Human Resources         51  12
##   Research & Development 828 133
##   Sales                  354  92
## [1] "Education"
##                
##                  No Yes
##   Below College 139  31
##   College       238  44
##   Bachelor      473  99
##   Master        340  58
##   Doctor         43   5
## [1] "EducationField"
##                   
##                     No Yes
##   Human Resources   20   7
##   Life Sciences    517  89
##   Marketing        124  35
##   Medical          401  63
##   Other             71  11
##   Technical Degree 100  32
```

```
## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect
```

```
## [1] "EnvironmentSatisfaction"
##            
##              No Yes
##   Low       212  72
##   Medium    244  43
##   High      391  62
##   Very High 386  60
## [1] "JobInvolvement"
##            
##              No Yes
##   Low        55  28
##   Medium    304  71
##   High      743 125
##   Very High 131  13
## [1] "JobLevel"
##    
##      No Yes
##   1 400 143
##   2 482  52
##   3 186  32
##   4 101   5
##   5  64   5
## [1] "JobRole"
##                            
##                              No Yes
##   Healthcare Representative 122   9
##   Human Resources            40  12
##   Laboratory Technician     197  62
##   Manager                    97   5
##   Manufacturing Director    135  10
##   Research Director          78   2
##   Research Scientist        245  47
##   Sales Executive           269  57
##   Sales Representative       50  33
## [1] "JobSatisfaction"
##            
##              No Yes
##   Low       223  66
##   Medium    234  46
##   High      369  73
##   Very High 407  52
## [1] "OverTime"
##      
##        No Yes
##   No  944 110
##   Yes 289 127
## [1] "PerformanceRating"
##              
##                 No  Yes
##   Excellent   1044  200
##   Outstanding  189   37
## [1] "RelationshipSatisfaction"
##            
##              No Yes
##   Low       219  57
##   Medium    258  45
##   High      388  71
##   Very High 368  64
## [1] "StockOptionLevel"
##    
##      No Yes
##   0 477 154
##   1 540  56
##   2 146  12
##   3  70  15
## [1] "WorkLifeBalance"
##         
##           No Yes
##   Bad     55  25
##   Good   286  58
##   Better 766 127
##   Best   126  27
```

```r
names(chi_sq_list) <- names(analysis_df[, -1] %>% select_if(is.factor))
chi_sq_list
```

```
## $BusinessTravel
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 24.182, df = 2, p-value = 5.609e-06
## 
## 
## $Department
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 10.796, df = 2, p-value = 0.004526
## 
## 
## $Education
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 3.074, df = 4, p-value = 0.5455
## 
## 
## $EducationField
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 16.025, df = 5, p-value = 0.006774
## 
## 
## $EnvironmentSatisfaction
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 22.504, df = 3, p-value = 5.123e-05
## 
## 
## $JobInvolvement
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 28.492, df = 3, p-value = 2.863e-06
## 
## 
## $JobLevel
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 72.529, df = 4, p-value = 6.635e-15
## 
## 
## $JobRole
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 86.19, df = 8, p-value = 2.752e-15
## 
## 
## $JobSatisfaction
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 17.505, df = 3, p-value = 0.0005563
## 
## 
## $OverTime
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  tbl
## X-squared = 87.564, df = 1, p-value < 2.2e-16
## 
## 
## $PerformanceRating
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  tbl
## X-squared = 0.00015475, df = 1, p-value = 0.9901
## 
## 
## $RelationshipSatisfaction
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 5.2411, df = 3, p-value = 0.155
## 
## 
## $StockOptionLevel
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 60.598, df = 3, p-value = 4.379e-13
## 
## 
## $WorkLifeBalance
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 16.325, df = 3, p-value = 0.0009726
```

```r
top_chi <- sort(sapply(chi_sq_list, function(x) x$p.value))
top_chi <- names(head(top_chi,5))
top_chi
```

```
## [1] "OverTime"         "JobRole"          "JobLevel"        
## [4] "StockOptionLevel" "JobInvolvement"
```

For each categorical variable in the data a univariate chi-square model was run to assess how correlated the variable is with employee attrition

The models were ranked based on p-value and top-5 variables were retained for further analysis:

1. OverTime

2. JobRole

3. JobLevel

4. StockOptionLevel

5. JobInvolvement

### 3) Machine Learning 
#### 3a) Random Forest

* Bagging (bootstrap aggregation)
* Fit many different regression trees independently using random sample of the data and random subset of the variables
* Trees run independently in parallel then the results are combined


```r
#=== RANDOM FOREST VARIABLE IDENTIFICATION ====#
rf_model <- randomForest(x = as.data.frame(analysis_df[,-1]), y = analysis_df$Attrition , importance = TRUE)
rf_model
```

```
## 
## Call:
##  randomForest(x = as.data.frame(analysis_df[, -1]), y = analysis_df$Attrition,      importance = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 5
## 
##         OOB estimate of  error rate: 13.88%
## Confusion matrix:
##       No Yes class.error
## No  1225   8  0.00648824
## Yes  196  41  0.82700422
```

```r
varImpPlot(rf_model)
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/rf-1.png)<!-- -->

```r
importance(rf_model)
```

```
##                                   No        Yes MeanDecreaseAccuracy
## BusinessTravel            4.18329753  4.0719576            5.6742194
## DailyRate                -1.15196543  0.7457460           -0.6322164
## Department                3.98404289  2.2180087            4.6620209
## DistanceFromHome          0.49995918  2.5412345            1.6671653
## Education                -0.30051033 -0.3183185           -0.3950351
## EducationField            3.99730726 -0.1068954            3.4209470
## EnvironmentSatisfaction   4.36091723  5.3531295            6.4638943
## HourlyRate                0.09972672 -1.1008680           -0.3464622
## JobInvolvement            2.40153438  5.5931647            4.9140615
## JobLevel                  9.11969346  9.8632686           12.3466018
## JobRole                  11.36471846  7.9925623           14.3169221
## JobSatisfaction           3.62143341  4.0222817            4.9025719
## MonthlyIncome            11.41118813 10.3246045           15.2494834
## MonthlyRate              -1.73094390 -1.4970742           -2.1935744
## NumCompaniesWorked        2.35733543  1.1618965            2.8544181
## OverTime                 17.13951997 22.8669409           25.4216128
## PercentSalaryHike         1.15741689 -1.6685750            0.3491598
## PerformanceRating        -1.14589057  0.3059921           -0.8516006
## RelationshipSatisfaction  3.06486112  0.5156865            2.9171577
## StockOptionLevel          7.59834876 11.7379618           11.9603547
## TotalWorkingYears         8.34196988  6.8909489           11.3261406
## TrainingTimesLastYear     0.46129411  0.9089488            0.7702887
## WorkLifeBalance           5.34839667  4.4702897            6.8490314
## YearsAtCompany            6.66675332  3.4431569            8.0148985
## YearsInCurrentRole        5.28015234  3.5684978            7.2875801
## YearsSinceLastPromotion   6.17179676 -1.6151901            5.0917098
## YearsWithCurrManager      6.26303516  2.6833927            7.7723798
##                          MeanDecreaseGini
## BusinessTravel                   7.183971
## DailyRate                       23.449806
## Department                       4.404459
## DistanceFromHome                20.089302
## Education                       10.547290
## EducationField                  13.855129
## EnvironmentSatisfaction         14.381641
## HourlyRate                      20.366089
## JobInvolvement                  10.359475
## JobLevel                        10.089413
## JobRole                         20.328761
## JobSatisfaction                 13.151676
## MonthlyIncome                   31.918956
## MonthlyRate                     21.449383
## NumCompaniesWorked              14.080540
## OverTime                        21.602544
## PercentSalaryHike               15.137448
## PerformanceRating                1.389901
## RelationshipSatisfaction        10.948351
## StockOptionLevel                14.701447
## TotalWorkingYears               22.895565
## TrainingTimesLastYear           11.307468
## WorkLifeBalance                 12.078722
## YearsAtCompany                  16.816109
## YearsInCurrentRole              10.582267
## YearsSinceLastPromotion         10.926229
## YearsWithCurrManager            13.571852
```

```r
top_rf <- names(tail(sort(importance(rf_model)[,3]),5))
```

The random forest model uses variable inclusion mean-squared error to determine relative variable importance.
The top results of the RF model suggests that OverTime is a clear top variable for attrition.

Top Five Variables from Random Forest:

1. StockOptionLevel

2. JobLevel

3. JobRole

4. MonthlyIncome

5. OverTime

#### 3b) GBM

* Boosting
* Many trees are fit consecutively with additional tree  trying to reduce the net error of the prior tree ensembles
* Trees run consecutively and result is the model for the nth tree


```r
## GRADIENT BOOSTING VARIABLE IDENTIFICATION
gbm_model <- gbm.fit(as.data.frame(analysis_df[,-1]), analysis_df$Attrition == "Yes")
```

```
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        0.8833             nan     0.0010    0.0001
##      2        0.8832             nan     0.0010    0.0000
##      3        0.8831             nan     0.0010    0.0000
##      4        0.8829             nan     0.0010    0.0001
##      5        0.8828             nan     0.0010    0.0001
##      6        0.8827             nan     0.0010    0.0001
##      7        0.8826             nan     0.0010    0.0000
##      8        0.8825             nan     0.0010    0.0000
##      9        0.8824             nan     0.0010    0.0000
##     10        0.8823             nan     0.0010    0.0001
##     20        0.8811             nan     0.0010    0.0001
##     40        0.8787             nan     0.0010    0.0001
##     60        0.8764             nan     0.0010    0.0000
##     80        0.8741             nan     0.0010    0.0000
##    100        0.8719             nan     0.0010    0.0000
```

```r
gbm_model
```

```
## A gradient boosted model with bernoulli loss function.
## 100 iterations were performed.
## There were 27 predictors of which 7 had non-zero influence.
```

```r
summary(gbm_model)
```

```
##                                               var   rel.inf
## OverTime                                 OverTime 45.694313
## TotalWorkingYears               TotalWorkingYears 28.022565
## MonthlyIncome                       MonthlyIncome 10.519428
## YearsAtCompany                     YearsAtCompany  6.836015
## JobLevel                                 JobLevel  4.123704
## JobRole                                   JobRole  2.529893
## StockOptionLevel                 StockOptionLevel  2.274081
## BusinessTravel                     BusinessTravel  0.000000
## DailyRate                               DailyRate  0.000000
## Department                             Department  0.000000
## DistanceFromHome                 DistanceFromHome  0.000000
## Education                               Education  0.000000
## EducationField                     EducationField  0.000000
## EnvironmentSatisfaction   EnvironmentSatisfaction  0.000000
## HourlyRate                             HourlyRate  0.000000
## JobInvolvement                     JobInvolvement  0.000000
## JobSatisfaction                   JobSatisfaction  0.000000
## MonthlyRate                           MonthlyRate  0.000000
## NumCompaniesWorked             NumCompaniesWorked  0.000000
## PercentSalaryHike               PercentSalaryHike  0.000000
## PerformanceRating               PerformanceRating  0.000000
## RelationshipSatisfaction RelationshipSatisfaction  0.000000
## TrainingTimesLastYear       TrainingTimesLastYear  0.000000
## WorkLifeBalance                   WorkLifeBalance  0.000000
## YearsInCurrentRole             YearsInCurrentRole  0.000000
## YearsSinceLastPromotion   YearsSinceLastPromotion  0.000000
## YearsWithCurrManager         YearsWithCurrManager  0.000000
```

```r
top_gbm <- as.character(head(summary(gbm_model)$var,5))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-1-1.png)<!-- -->

The GBM uses an aggregation of the reduction of sum of squared error on each iteration for each variable to create an estimate of relative influence
Only six of the variables result in a non-zero influence on Attrition in the GBM model. 

Top Six Variables from GBM:

1. OverTime

2. TotalWorkingYears

3. MonthlyIncome

4. YearsAtCompany

5. JobLevel

6. OverTime

### 4) Determine Top-Variables Across Methods (stepwise AIC)



```r
#-- Combine Top Variables ---#
all_top <- unique(c(top_logit, top_chi, top_gbm, top_rf))

#- Combined Modle -#
all_model <- glm("Attrition ~ .", data = analysis_df[c("Attrition",all_top)] %>% mutate(Attrition = Attrition == "Yes"), family = binomial(link = "logit"))
summary(all_model)
```

```
## 
## Call:
## glm(formula = "Attrition ~ .", family = binomial(link = "logit"), 
##     data = analysis_df[c("Attrition", all_top)] %>% mutate(Attrition = Attrition == 
##         "Yes"))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.8529  -0.5562  -0.3247  -0.1528   3.0917  
## 
## Coefficients:
##                                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                    0.2271388  0.6855861   0.331 0.740413    
## OverTimeYes                    1.6291270  0.1699058   9.588  < 2e-16 ***
## JobRoleHuman Resources         0.6008037  0.5919739   1.015 0.310146    
## JobRoleLaboratory Technician   0.5442955  0.5365821   1.014 0.310404    
## JobRoleManager                -1.0984430  0.9536902  -1.152 0.249411    
## JobRoleManufacturing Director -0.1179158  0.5019128  -0.235 0.814261    
## JobRoleResearch Director      -1.9560019  1.0574065  -1.850 0.064341 .  
## JobRoleResearch Scientist     -0.2836806  0.5480942  -0.518 0.604754    
## JobRoleSales Executive         1.1546745  0.4003953   2.884 0.003929 ** 
## JobRoleSales Representative    0.9583986  0.5844674   1.640 0.101051    
## JobLevel2                     -1.4068953  0.4131823  -3.405 0.000662 ***
## JobLevel3                     -0.1537371  0.6327790  -0.243 0.808040    
## JobLevel4                     -0.2368853  1.0564406  -0.224 0.822579    
## JobLevel5                      1.8033885  1.4243097   1.266 0.205460    
## StockOptionLevel1             -1.2356914  0.1878724  -6.577 4.79e-11 ***
## StockOptionLevel2             -1.2115891  0.3395329  -3.568 0.000359 ***
## StockOptionLevel3             -0.7712400  0.3414762  -2.259 0.023912 *  
## TotalWorkingYears             -0.0192631  0.0209884  -0.918 0.358727    
## JobInvolvementMedium          -1.0214827  0.3137378  -3.256 0.001131 ** 
## JobInvolvementHigh            -1.3443003  0.2972565  -4.522 6.12e-06 ***
## JobInvolvementVery High       -1.8451535  0.4176881  -4.418 9.98e-06 ***
## MonthlyIncome                 -0.0000621  0.0000825  -0.753 0.451612    
## YearsAtCompany                -0.0213353  0.0206934  -1.031 0.302531    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.58  on 1469  degrees of freedom
## Residual deviance:  994.81  on 1447  degrees of freedom
## AIC: 1040.8
## 
## Number of Fisher Scoring iterations: 6
```


```r
#- Stepwise Backward Variable Reduction -#
step_reduce_model <- stepAIC(all_model, direction = "back")
```

```
## Start:  AIC=1040.81
## Attrition ~ OverTime + JobRole + JobLevel + StockOptionLevel + 
##     TotalWorkingYears + JobInvolvement + MonthlyIncome + YearsAtCompany
## 
##                     Df Deviance    AIC
## - MonthlyIncome      1   995.38 1039.4
## - TotalWorkingYears  1   995.67 1039.7
## - YearsAtCompany     1   995.87 1039.9
## <none>                   994.81 1040.8
## - JobInvolvement     3  1020.12 1060.1
## - JobLevel           4  1031.54 1069.5
## - JobRole            8  1043.90 1073.9
## - StockOptionLevel   3  1048.30 1088.3
## - OverTime           1  1091.16 1135.2
## 
## Step:  AIC=1039.38
## Attrition ~ OverTime + JobRole + JobLevel + StockOptionLevel + 
##     TotalWorkingYears + JobInvolvement + YearsAtCompany
## 
##                     Df Deviance    AIC
## - YearsAtCompany     1   996.44 1038.4
## - TotalWorkingYears  1   996.56 1038.6
## <none>                   995.38 1039.4
## - JobInvolvement     3  1020.27 1058.3
## - JobLevel           4  1032.60 1068.6
## - JobRole            8  1048.50 1076.5
## - StockOptionLevel   3  1049.64 1087.6
## - OverTime           1  1091.41 1133.4
## 
## Step:  AIC=1038.44
## Attrition ~ OverTime + JobRole + JobLevel + StockOptionLevel + 
##     TotalWorkingYears + JobInvolvement
## 
##                     Df Deviance    AIC
## <none>                   996.44 1038.4
## - TotalWorkingYears  1   999.38 1039.4
## - JobInvolvement     3  1021.29 1057.3
## - JobLevel           4  1033.73 1067.7
## - JobRole            8  1049.11 1075.1
## - StockOptionLevel   3  1050.70 1086.7
## - OverTime           1  1093.33 1133.3
```

```r
step_reduce_model$coefficients
```

```
##                   (Intercept)                   OverTimeYes 
##                   -0.01001033                    1.63088085 
##        JobRoleHuman Resources  JobRoleLaboratory Technician 
##                    0.63020534                    0.59083105 
##                JobRoleManager JobRoleManufacturing Director 
##                   -1.31907118                   -0.09064288 
##      JobRoleResearch Director     JobRoleResearch Scientist 
##                   -2.12211946                   -0.24716360 
##        JobRoleSales Executive   JobRoleSales Representative 
##                    1.12588444                    1.02578257 
##                     JobLevel2                     JobLevel3 
##                   -1.53003882                   -0.48493534 
##                     JobLevel4                     JobLevel5 
##                   -0.82899888                    1.04634959 
##             StockOptionLevel1             StockOptionLevel2 
##                   -1.24150720                   -1.22052299 
##             StockOptionLevel3             TotalWorkingYears 
##                   -0.77024150                   -0.03168789 
##          JobInvolvementMedium            JobInvolvementHigh 
##                   -1.01565016                   -1.33030195 
##       JobInvolvementVery High 
##                   -1.82526881
```

```r
summary(step_reduce_model)
```

```
## 
## Call:
## glm(formula = Attrition ~ OverTime + JobRole + JobLevel + StockOptionLevel + 
##     TotalWorkingYears + JobInvolvement, family = binomial(link = "logit"), 
##     data = analysis_df[c("Attrition", all_top)] %>% mutate(Attrition = Attrition == 
##         "Yes"))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.8606  -0.5529  -0.3235  -0.1550   3.0115  
## 
## Coefficients:
##                               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                   -0.01001    0.61376  -0.016  0.98699    
## OverTimeYes                    1.63088    0.16960   9.616  < 2e-16 ***
## JobRoleHuman Resources         0.63021    0.58589   1.076  0.28209    
## JobRoleLaboratory Technician   0.59083    0.52905   1.117  0.26409    
## JobRoleManager                -1.31907    0.91134  -1.447  0.14778    
## JobRoleManufacturing Director -0.09064    0.49945  -0.181  0.85599    
## JobRoleResearch Director      -2.12212    1.01416  -2.092  0.03639 *  
## JobRoleResearch Scientist     -0.24716    0.54025  -0.457  0.64731    
## JobRoleSales Executive         1.12588    0.39880   2.823  0.00476 ** 
## JobRoleSales Representative    1.02578    0.57532   1.783  0.07459 .  
## JobLevel2                     -1.53004    0.38952  -3.928 8.57e-05 ***
## JobLevel3                     -0.48494    0.48686  -0.996  0.31923    
## JobLevel4                     -0.82900    0.78817  -1.052  0.29289    
## JobLevel5                      1.04635    1.10641   0.946  0.34429    
## StockOptionLevel1             -1.24151    0.18746  -6.623 3.52e-11 ***
## StockOptionLevel2             -1.22052    0.33914  -3.599  0.00032 ***
## StockOptionLevel3             -0.77024    0.34138  -2.256  0.02406 *  
## TotalWorkingYears             -0.03169    0.01874  -1.691  0.09085 .  
## JobInvolvementMedium          -1.01565    0.31385  -3.236  0.00121 ** 
## JobInvolvementHigh            -1.33030    0.29669  -4.484 7.33e-06 ***
## JobInvolvementVery High       -1.82527    0.41643  -4.383 1.17e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1298.58  on 1469  degrees of freedom
## Residual deviance:  996.44  on 1449  degrees of freedom
## AIC: 1038.4
## 
## Number of Fisher Scoring iterations: 6
```

```r
# Odds Ratios
or_table <- exp(cbind(OR = coef(step_reduce_model), confint(step_reduce_model)))
or_table %>% kable()
```

                                        OR       2.5 %       97.5 %
------------------------------  ----------  ----------  -----------
(Intercept)                      0.9900396   0.2940132    3.3082017
OverTimeYes                      5.1083725   3.6744911    7.1491186
JobRoleHuman Resources           1.8779962   0.5886427    5.9626837
JobRoleLaboratory Technician     1.8054882   0.6404201    5.1936382
JobRoleManager                   0.2673835   0.0335636    1.3727658
JobRoleManufacturing Director    0.9133438   0.3409519    2.4751752
JobRoleResearch Director         0.1197775   0.0113727    0.6945575
JobRoleResearch Scientist        0.7810129   0.2701161    2.2878190
JobRoleSales Executive           3.0829423   1.4726905    7.1396596
JobRoleSales Representative      2.7892774   0.9022138    8.7422811
JobLevel2                        0.2165273   0.0963559    0.4478513
JobLevel3                        0.6157370   0.2306414    1.5674542
JobLevel4                        0.4364860   0.0878313    1.9679114
JobLevel5                        2.8472385   0.3457003   29.7306438
StockOptionLevel1                0.2889484   0.1986858    0.4147223
StockOptionLevel2                0.2950758   0.1450970    0.5536624
StockOptionLevel3                0.4629013   0.2298614    0.8820003
TotalWorkingYears                0.9688089   0.9331633    1.0044282
JobInvolvementMedium             0.3621669   0.1962381    0.6736517
JobInvolvementHigh               0.2643974   0.1483652    0.4762648
JobInvolvementVery High          0.1611743   0.0695806    0.3587324

```r
#p-value
with(step_reduce_model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
```

```
## [1] 2.946066e-52
```

### Top Variables Identified

When combined across all previous methods the following list of variables were identified as top influencers of employee attrition:

OverTime, JobRole, JobLevel, StockOptionLevel, TotalWorkingYears, JobInvolvement, MonthlyIncome, YearsAtCompany

By creating a model with all variables included and using AIC to stepwise backwards remove variables from the model we can reduce to total number to five:
1. Overtime
2. Stock Option Level
3. Job Role
4. Job Level
5. Years with current manager

By examining the odds ratios of the variable coefficients from the logit model we are able to get a better estimate of how impactful the various variables are for predicting employee attrition

*Some Highlight Insights:*

* If an employee is required to work overtime they are nearly five times more likely to leave the company
* Once an employee reaches job level 2 they are around four times less likely to leave
* The addition stock options reduces the likelihood of an employee leaving by two to four times compared to employees with no stock option


## Exploring the Data Using Visualization


```r
analysis_df2 <- analysis_df
analysis_df2$Attrition <- analysis_df$Attrition == "Yes"
attrition <- length(analysis_df2$Attrition[analysis_df2$Attrition])
non_attrition <- length(analysis_df2$Attrition[!analysis_df2$Attrition])
attrition/(non_attrition+attrition)
```

```
## [1] 0.1612245
```

About 16% of employees leave their company voluntarily. This tells us that if we find any group with rates significantly higher or lower than 16% there might be an interesting trend.

### Looking at Different Columns

Since there are many factors that might lead to attrition, we start with an arbitrary data column. Looking at distance from home we see how that might relate to attrition rates:


```r
analysis_df2 <- analysis_df %>% mutate_if(is.factor, as.character)
analysis_df2$Attrition <- analysis_df2$Attrition == "Yes"

attrition_rate_distance <- analysis_df2 %>%
  group_by(DistanceFromHome) %>%
  count(att_count = Attrition) %>%
  group_by(att_count)
  
attrition_rate_true <- attrition_rate_distance[attrition_rate_distance$att_count,]
attrition_rate_false <- attrition_rate_distance[!attrition_rate_distance$att_count,]
attrition_rate_distance <- merge(attrition_rate_true, attrition_rate_false, by = "DistanceFromHome")
attrition_rate_distance <- attrition_rate_distance %>%
  mutate(AttRate = n.x / (n.x + n.y))
attrition_rate_distance
```

```
##    DistanceFromHome att_count.x n.x att_count.y n.y    AttRate
## 1                 1        TRUE  26       FALSE 182 0.12500000
## 2                 2        TRUE  28       FALSE 183 0.13270142
## 3                 3        TRUE  14       FALSE  70 0.16666667
## 4                 4        TRUE   9       FALSE  55 0.14062500
## 5                 5        TRUE  10       FALSE  55 0.15384615
## 6                 6        TRUE   7       FALSE  52 0.11864407
## 7                 7        TRUE  11       FALSE  73 0.13095238
## 8                 8        TRUE  10       FALSE  70 0.12500000
## 9                 9        TRUE  18       FALSE  67 0.21176471
## 10               10        TRUE  11       FALSE  75 0.12790698
## 11               11        TRUE   4       FALSE  25 0.13793103
## 12               12        TRUE   6       FALSE  14 0.30000000
## 13               13        TRUE   6       FALSE  13 0.31578947
## 14               14        TRUE   4       FALSE  17 0.19047619
## 15               15        TRUE   5       FALSE  21 0.19230769
## 16               16        TRUE   7       FALSE  25 0.21875000
## 17               17        TRUE   5       FALSE  15 0.25000000
## 18               18        TRUE   4       FALSE  22 0.15384615
## 19               19        TRUE   3       FALSE  19 0.13636364
## 20               20        TRUE   4       FALSE  21 0.16000000
## 21               21        TRUE   3       FALSE  15 0.16666667
## 22               22        TRUE   6       FALSE  13 0.31578947
## 23               23        TRUE   5       FALSE  22 0.18518519
## 24               24        TRUE  12       FALSE  16 0.42857143
## 25               25        TRUE   6       FALSE  19 0.24000000
## 26               26        TRUE   3       FALSE  22 0.12000000
## 27               27        TRUE   3       FALSE   9 0.25000000
## 28               28        TRUE   2       FALSE  21 0.08695652
## 29               29        TRUE   5       FALSE  22 0.18518519
```


```r
ggplot(attrition_rate_distance) +
  geom_col(mapping = aes(x = DistanceFromHome, y = AttRate), fill = "blue") + ggtitle("The Closer To Home, The Lower the Attrition Rate")
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-4-1.png)<!-- -->

Looking at that graph, it appears that there are some extremely high attrition rates for some distances, and the general pattern is, that, as the distance increases, so does the attrition rate.


Looking at yet another arbitrary data point, education, we find data that looks different:


```r
attrition_rate_education <- analysis_df2 %>%
  group_by(Education) %>%
  count(att_count = Attrition) %>%
  group_by(att_count)
  
attrition_rate_true <- attrition_rate_education[attrition_rate_education$att_count,]
attrition_rate_false <- attrition_rate_education[!attrition_rate_education$att_count,]
head(attrition_rate_true)
```

```
## # A tibble: 5 x 3
## # Groups:   att_count [1]
##       Education att_count     n
##           <chr>     <lgl> <int>
## 1      Bachelor      TRUE    99
## 2 Below College      TRUE    31
## 3       College      TRUE    44
## 4        Doctor      TRUE     5
## 5        Master      TRUE    58
```

```r
head(attrition_rate_false)
```

```
## # A tibble: 5 x 3
## # Groups:   att_count [1]
##       Education att_count     n
##           <chr>     <lgl> <int>
## 1      Bachelor     FALSE   473
## 2 Below College     FALSE   139
## 3       College     FALSE   238
## 4        Doctor     FALSE    43
## 5        Master     FALSE   340
```

```r
attrition_rate_education <- merge(attrition_rate_true, attrition_rate_false, by = "Education")
attrition_rate_education <- attrition_rate_education %>%
  mutate(AttRate = n.x / (n.x + n.y))
attrition_rate_education
```

```
##       Education att_count.x n.x att_count.y n.y   AttRate
## 1      Bachelor        TRUE  99       FALSE 473 0.1730769
## 2 Below College        TRUE  31       FALSE 139 0.1823529
## 3       College        TRUE  44       FALSE 238 0.1560284
## 4        Doctor        TRUE   5       FALSE  43 0.1041667
## 5        Master        TRUE  58       FALSE 340 0.1457286
```


```r
ggplot(attrition_rate_education) +
  geom_col(mapping = aes(x = Education, y = AttRate), fill = "blue") + ggtitle("Education Level Does Not Affect Attrition")
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-6-1.png)<!-- -->

Education may be related to attrition, since visually it appears an increase in education correlates with lower rate of attrition. However, the differences are so close it may be due to statistical noise.

A small helper function:

```r
att_rate <- function(df, grouper) {
  
  attrition_rate_grouped <- df %>%
    group_by_(grouper) %>%
    count(att_count = Attrition) %>%
    group_by(att_count)
   
  attrition_rate_true <- attrition_rate_grouped[attrition_rate_grouped$att_count,]
  attrition_rate_false <- attrition_rate_grouped[!attrition_rate_grouped$att_count,]
  attrition_rate_grouped <- merge(attrition_rate_true, attrition_rate_false, by = grouper)
  attrition_rate_grouped <- attrition_rate_grouped %>%
     mutate(AttRate = n.x / (n.x + n.y))
  attrition_rate_grouped
}
```

Here are just a few more examples:

```r
hourly_att <- att_rate(analysis_df2, "HourlyRate")
head(hourly_att)
```

```
##   HourlyRate att_count.x n.x att_count.y n.y    AttRate
## 1         31        TRUE   2       FALSE  13 0.13333333
## 2         32        TRUE   4       FALSE  20 0.16666667
## 3         33        TRUE   3       FALSE  16 0.15789474
## 4         34        TRUE   5       FALSE   7 0.41666667
## 5         35        TRUE   1       FALSE  17 0.05555556
## 6         36        TRUE   5       FALSE  13 0.27777778
```

```r
role_att <- att_rate(analysis_df2, "JobRole")
head(role_att)
```

```
##                     JobRole att_count.x n.x att_count.y n.y    AttRate
## 1 Healthcare Representative        TRUE   9       FALSE 122 0.06870229
## 2           Human Resources        TRUE  12       FALSE  40 0.23076923
## 3     Laboratory Technician        TRUE  62       FALSE 197 0.23938224
## 4                   Manager        TRUE   5       FALSE  97 0.04901961
## 5    Manufacturing Director        TRUE  10       FALSE 135 0.06896552
## 6         Research Director        TRUE   2       FALSE  78 0.02500000
```

```r
performance_att <- att_rate(analysis_df2, "PerformanceRating")
performance_att
```

```
##   PerformanceRating att_count.x n.x att_count.y  n.y   AttRate
## 1         Excellent        TRUE 200       FALSE 1044 0.1607717
## 2       Outstanding        TRUE  37       FALSE  189 0.1637168
```

We can rule out performance rating and hourly rate, since they have so few variables they would be impossible to interpret.

### Graphing Each Point
We exclude some data points because in the United States they are protected status, or because they do not have much information. For example, it is illegal to discriminate based on age and gender, so creating a model to predict attrition based on these factors could lead to some unethical waters. We decide to play it safe and stay away from these two data points.


```r
exclude_names <- c("Age", "Gender", "Attrition", "Over18", "EmployeeNumber", "EmployeeCount", "StandardHours")
names_use <- names(analysis_df2)[!names(analysis_df2) %in% exclude_names]

#att_differences <- c("DailyRate", "MonthlyIncome", "MonthlyRate")
att_differences <- c()

for (name in names_use) {
  name_title_split <- regmatches(name, gregexpr("[A-Z]+[a-z]+", name, perl = T))
  name_title <- paste(name_title_split[[1]], collapse = " ")
  name_att <- att_rate(analysis_df2, name)
  max_att <- max(name_att$AttRate)
  min_att <- min(name_att$AttRate)
  att_diff <- max_att - min_att
  att_differences <- c(att_differences, att_diff)
  plot_title <- paste(c("Attrition Rate by ", name_title), collapse = "")
plot <- ggplot(name_att) +
    geom_col(mapping = aes_string(x = name, y = "AttRate"), fill = "blue") +
    labs(x = name_title, y = "Attrition Rate") +
    ggtitle(plot_title) +
    coord_flip()
  print(plot)
  #file_name <- paste(c("../case_study_extra/graphs/", name, ".png"), collapse = "")
  #ggsave(file_name)
}
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-1.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-2.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-3.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-4.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-5.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-6.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-7.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-8.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-9.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-10.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-11.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-12.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-13.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-14.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-15.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-16.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-17.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-18.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-19.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-20.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-21.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-22.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-23.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-24.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-25.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-26.png)<!-- -->![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-9-27.png)<!-- -->

```r
att_differences
```

```
##  [1] 0.16909747 0.46666667 0.06788052 0.34161491 0.07818627 0.12511292
##  [7] 0.11899198 0.37820513 0.24707162 0.21618194 0.37259036 0.11508394
## [13] 0.41666667 0.33333333 0.15333932 0.20092414 0.23015873 0.00294511
## [19] 0.05837359 0.16810769 0.46441540 0.18547009 0.17028275 0.46296296
## [25] 0.27140255 0.19084967 0.35454545
```

Looking at time based data points (such as years in a job, etc. ), there is an interesting pattern that emerges. The number of years someone has been doing something tends to correlate with a decrease in attrition. However, at highest amount of years, there tends to be an increase. 

Other interesting patterns in the visualizations:

### Sales
In the graph of positions, the sales representative postion has a very high attrition rate (near 40%), as well as the sales department having a high attrition rate (21%) compared to other departments.

### Role Involvement
Steps to improve an employees sense of belonging in a particular position tend to decrease attrition. For example, there is a negative correlation between training times in the last year and attrition rate. And job involvement ratings show a dramatic decrease in attrition (1 = 34%, and the max 4 = 9%)

### Money Matters
Stock options tend to decrease attrition, however, the highest sees a spike in attrition again. This might be an indication that those with the best stock options tend to be highly desirable employees and thus are at a greater risk of being offered a higher paying position.

### Misc
Being a manager is appealing: managers have a very low attrition rate (5%), but not quite as appealing as being a research director (2%). Research director positions are so rare, however that it might be more difficult to transfer to another organization with a similar role.

### Chi-Squared Test for Independence
After looking at the graphs, we can start taking a look at what values are related to attrition with a statistical method.


```r
significant_variables <- c()
analysis_df <- data.frame(unclass(analysis_df))
for (name in names_use) {
  tbl <- table(analysis_df[, "Attrition"], analysis_df[, name])
  test_result <- chisq.test(tbl) 
  if (test_result$p.value < .05) {
    significant_variables <- c(significant_variables, name)
  } 
}
```

```
## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect

## Warning in chisq.test(tbl): Chi-squared approximation may be incorrect
```

The variables that pass the p-threshold of 0.05 are:

```r
significant_variables
```

```
##  [1] "BusinessTravel"          "Department"             
##  [3] "EducationField"          "EnvironmentSatisfaction"
##  [5] "JobInvolvement"          "JobLevel"               
##  [7] "JobRole"                 "JobSatisfaction"        
##  [9] "NumCompaniesWorked"      "OverTime"               
## [11] "StockOptionLevel"        "TotalWorkingYears"      
## [13] "TrainingTimesLastYear"   "WorkLifeBalance"        
## [15] "YearsAtCompany"          "YearsInCurrentRole"     
## [17] "YearsWithCurrManager"
```

This means there are ten variables that do not appear to be correlated with attrition rate:

```r
length(names_use) - length(significant_variables)
```

```
## [1] 10
```

### Differences between attrition rates

```r
attrition_diff_df <- data.frame(names_use, att_differences)
attrition_diff_df
```

```
##                   names_use att_differences
## 1            BusinessTravel      0.16909747
## 2                 DailyRate      0.46666667
## 3                Department      0.06788052
## 4          DistanceFromHome      0.34161491
## 5                 Education      0.07818627
## 6            EducationField      0.12511292
## 7   EnvironmentSatisfaction      0.11899198
## 8                HourlyRate      0.37820513
## 9            JobInvolvement      0.24707162
## 10                 JobLevel      0.21618194
## 11                  JobRole      0.37259036
## 12          JobSatisfaction      0.11508394
## 13            MonthlyIncome      0.41666667
## 14              MonthlyRate      0.33333333
## 15       NumCompaniesWorked      0.15333932
## 16                 OverTime      0.20092414
## 17        PercentSalaryHike      0.23015873
## 18        PerformanceRating      0.00294511
## 19 RelationshipSatisfaction      0.05837359
## 20         StockOptionLevel      0.16810769
## 21        TotalWorkingYears      0.46441540
## 22    TrainingTimesLastYear      0.18547009
## 23          WorkLifeBalance      0.17028275
## 24           YearsAtCompany      0.46296296
## 25       YearsInCurrentRole      0.27140255
## 26  YearsSinceLastPromotion      0.19084967
## 27     YearsWithCurrManager      0.35454545
```

```r
attrition_ordered <- attrition_diff_df[order(-attrition_diff_df$att_differences),]
attrition_ordered
```

```
##                   names_use att_differences
## 2                 DailyRate      0.46666667
## 21        TotalWorkingYears      0.46441540
## 24           YearsAtCompany      0.46296296
## 13            MonthlyIncome      0.41666667
## 8                HourlyRate      0.37820513
## 11                  JobRole      0.37259036
## 27     YearsWithCurrManager      0.35454545
## 4          DistanceFromHome      0.34161491
## 14              MonthlyRate      0.33333333
## 25       YearsInCurrentRole      0.27140255
## 9            JobInvolvement      0.24707162
## 17        PercentSalaryHike      0.23015873
## 10                 JobLevel      0.21618194
## 16                 OverTime      0.20092414
## 26  YearsSinceLastPromotion      0.19084967
## 22    TrainingTimesLastYear      0.18547009
## 23          WorkLifeBalance      0.17028275
## 1            BusinessTravel      0.16909747
## 20         StockOptionLevel      0.16810769
## 15       NumCompaniesWorked      0.15333932
## 6            EducationField      0.12511292
## 7   EnvironmentSatisfaction      0.11899198
## 12          JobSatisfaction      0.11508394
## 5                 Education      0.07818627
## 3                Department      0.06788052
## 19 RelationshipSatisfaction      0.05837359
## 18        PerformanceRating      0.00294511
```

Most of the top attrition rate differences are part of the previous list of significant variables. Daily rate, though, is not, perhaps because a chi-squared test is not the most appropriate way to test for significance with that variable. A more appropriate test comes later.

## Explore trends that exist in current employees

```r
#seperate data into only current employees
CurrentEmployees <- analysis_df[analysis_df$Attrition=="No",]
SatisAnalysis <- data.frame('Department' = CurrentEmployees$Department, 'JobRole' = CurrentEmployees$JobRole, 'JobSatisfaction' = CurrentEmployees$JobSatisfaction)
#manager overlaps in department, so add department to distinguish 
SatisAnalysis <- transform(SatisAnalysis, JobRole = ifelse(JobRole == 'Manager' , paste(JobRole, Department, sep = ",") , as.character(JobRole)))
#find count of Job Satisfactions within job role
SatisAnalysis <- data.frame(table(SatisAnalysis$JobRole, SatisAnalysis$JobSatisfaction, SatisAnalysis$Department))
colnames(SatisAnalysis) <- c("Role", "Satisfaction", "Department", "Freq")
#Get rid of observations without recordings
SatisAnalysis <- SatisAnalysis[ ! SatisAnalysis$Freq==0, ] 
#change counts to percentages
SatisAnalysis <- SatisAnalysis %>% 
  group_by(Role) %>% 
  mutate(perc=Freq/sum(Freq))  
SatisAnalysis$perc <- SatisAnalysis$perc*100
#plot percentages and seperate by department
ggplot(SatisAnalysis, aes(x= Role, y=perc)) + 
  coord_flip() + 
  ggtitle("Job Satisfaction by Job Role") +
  facet_grid(Department~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity", position = "dodge", colour = "black") + 
  labs(x= "Job Role", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,45)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4") , labels=c("Low", "Medium", "High", "Very High"))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-15-1.png)<!-- -->

```r
#run to see if differences are statistically significant
chisq.test(table(CurrentEmployees$JobRole, CurrentEmployees$JobSatisfaction))
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(CurrentEmployees$JobRole, CurrentEmployees$JobSatisfaction)
## X-squared = 20.95, df = 24, p-value = 0.6417
```

From this bar graph we can see that Sales Executives are the most satisfied in their jobs. Alternatively, Research and Development Managers are the least satisfied in their jobs. A statistical test was performed to see if these findings were statistically significant, but it was determined job role and job satisfaction are not dependent on each other. The p-value is pretty high, so it may not be looking into further.

### Exploring Environment within Departments

```r
#get counts
EnvironAnalysis <- data.frame(table(CurrentEmployees$Department, CurrentEmployees$EnvironmentSatisfaction))
colnames(EnvironAnalysis) <- c("Department", "Satisfaction","Freq")
#get percentages 
EnvironAnalysis <- EnvironAnalysis %>% 
  group_by(Department) %>% 
  mutate(perc=Freq/sum(Freq))
#plot frequencies
ggplot(EnvironAnalysis, aes(x= Department, y=perc)) + 
  coord_flip() + 
  ggtitle("Environment Satisfaction by Department") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity", position = "dodge") + 
  labs(x= "Department", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,0.50)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4") , labels=c("Low", "Medium", "High", "Very High"))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-16-1.png)<!-- -->

```r
#check if statistically significant
chisq.test(table(CurrentEmployees$Department, CurrentEmployees$EnvironmentSatisfaction))
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(CurrentEmployees$Department, CurrentEmployees$EnvironmentSatisfaction)
## X-squared = 7.7162, df = 6, p-value = 0.2596
```

From this bar graph we can see that Research are the most satisfied in their jobs. However, Human Resources has a very high percentage of employees with high satisfaction. Alternatively, Research and Development has the highest percentage of employees with low satisfaction. A statistical test was performed to see if these findings were statistically significant, but it was determined environment satisfaction and department are not dependent on each other. However, it might be worth looking into further as the p-value isn't extreme.

### Exploring Trends in Job Involvement and Job Role

```r
InvolvAnalysis <- data.frame(table(CurrentEmployees$JobRole, CurrentEmployees$JobInvolvement, CurrentEmployees$Department))
#Seperate Manager into Departments
InvolvAnalysis <- transform(InvolvAnalysis, Var1 = ifelse(Var1 == 'Manager' , paste(Var1, Var3, sep = ",") , as.character(Var1)))
InvolvAnalysis <- InvolvAnalysis[ ! InvolvAnalysis$Freq==0, ]
#plot frequencies
InvolvAnalysis <- InvolvAnalysis %>% 
  group_by(Var1) %>% 
  mutate(perc=Freq/sum(Freq))
InvolvAnalysis$perc <- InvolvAnalysis$perc *100
#plot frequencies
ggplot(InvolvAnalysis, aes(x= Var1, y=perc)) + 
  ggtitle("Job Involvement by Job Role") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Var2), stat="identity", position = "dodge" ,     colour="black") + 
  labs(x= "Job Role", y= "Percentage Involvement")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,75)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"),   labels=c("Low", "Medium", "High", "Very High")) +
  facet_grid(Var3~.) +
  coord_flip() +
  facet_grid(Var3~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) 
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-17-1.png)<!-- -->

```r
#check if statistically significant
chisq.test(table(analysis_df$JobRole, analysis_df$JobInvolvement))
```

```
## Warning in chisq.test(table(analysis_df$JobRole, analysis_df
## $JobInvolvement)): Chi-squared approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(analysis_df$JobRole, analysis_df$JobInvolvement)
## X-squared = 13.357, df = 24, p-value = 0.9599
```

Overall, all jobs have a high job involvement percentage. The least involved job is laboratory technitian at 6.6% employees with low involvement. I would not further look into this as it is not statistically significant.

### Exploring Trends With Job Satisfaction and Education

```r
#get dataframe with counts
EducationSat=as.data.frame(table(CurrentEmployees$Education,CurrentEmployees$JobSatisfaction,dnn=list("Education","Satisfaction")))
#get percentages
EducationSat <- EducationSat %>% 
  group_by(Education) %>% 
  mutate(perc=Freq/sum(Freq))
EducationSat$perc <- EducationSat$perc*100
#plot percentages 
ggplot(EducationSat, aes(x= Education, y=perc)) + 
  ggtitle("Job Satisfaction by Education") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction),stat="identity", position = "dodge",     colour="black") + 
  labs(x= "Education Level", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,75)) +
  coord_flip() +
  theme(strip.text.x = element_text(angle = 0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4") , labels=c("Low", "Medium", "High", "Very High"))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-18-1.png)<!-- -->

```r
#check if statistically significant
chisq.test(table(CurrentEmployees$Education, CurrentEmployees$JobSatisfaction))
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(CurrentEmployees$Education, CurrentEmployees$JobSatisfaction)
## X-squared = 15.663, df = 12, p-value = 0.2072
```

From this barplot we can see that employees with Doctorates are the most unhappy in their job. This is not statistically significant so you cannot conclude having a doctorate degree is why they are unhappy.

### Exploring Trends with Education Level Within Job Roles

```r
EduAnalysis <- data.frame('Department' = CurrentEmployees$Department, 'JobRole' = CurrentEmployees$JobRole, 'Education' = CurrentEmployees$Education)
#manager overlaps in department, so add department to distinguish 
EduAnalysis <- transform(EduAnalysis, JobRole = ifelse(JobRole == 'Manager' , paste(JobRole, Department, sep = ",") , as.character(JobRole)))
#find count of Job Satisfactions within job role
EduAnalysis <- data.frame(table(EduAnalysis$JobRole, EduAnalysis$Education, EduAnalysis$Department))
colnames(EduAnalysis) <- c("Role", "Education", "Department", "Freq")
EduAnalysis <- EduAnalysis[ ! EduAnalysis$Freq==0, ]   
#change counts to percentages
EduAnalysis <- EduAnalysis %>% 
  group_by(Role) %>% 
  mutate(perc=Freq/sum(Freq))  
EduAnalysis$perc <- EduAnalysis$perc*100
#plot counts
ggplot(EduAnalysis, aes(x= Role, y=perc)) + 
  coord_flip() + 
  ggtitle("Education by Job Role") +
  facet_grid(Department~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Education), stat="identity", position = "dodge", colour = "black", width=0.4) + 
  labs(x= "Job Role", y= "Education Percentage")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,50)) +
  scale_fill_manual(values=c("yellow", "limegreen", "deeppink" , "blue", "darkred")) 
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-19-1.png)<!-- -->

```r
chisq.test(table(CurrentEmployees$Education, CurrentEmployees$JobRole))
```

```
## Warning in chisq.test(table(CurrentEmployees$Education, CurrentEmployees
## $JobRole)): Chi-squared approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(CurrentEmployees$Education, CurrentEmployees$JobRole)
## X-squared = 40.782, df = 32, p-value = 0.1373
```

The majority of the employees has a Bachelor's degree. Human Resouce Managers have the highest percentage of employees with Master's degrees. Sales Representatives have the highest percentage with below college educations at 26%.

### Trends with Work Life Balance by Job Role

```r
WorkAnalysis <- data.frame(table(CurrentEmployees$JobRole, CurrentEmployees$WorkLifeBalance, CurrentEmployees$Department))
WorkAnalysis <- transform(WorkAnalysis, Var1 = ifelse(Var1 == 'Manager' , paste(Var1, Var3, sep = ",") , as.character(Var1)))

colnames(WorkAnalysis) <- c("JobRole", "WorkLifeBalance","Department" , "Freq")
WorkAnalysis <- WorkAnalysis[ ! WorkAnalysis$Freq==0, ]   
#change counts to percentages
WorkAnalysis <- WorkAnalysis %>% 
  group_by(JobRole) %>% 
  mutate(perc=Freq/sum(Freq))  
WorkAnalysis$perc <- WorkAnalysis$perc*100

ggplot(WorkAnalysis, aes(x= JobRole, y=perc)) + 
  coord_flip() + 
  ggtitle("Work Life Balance by Job Roles") +
  facet_grid(Department~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=WorkLifeBalance), stat="identity", position = "dodge", colour = "black", width=0.4) + 
  labs(x= "Job Role", y= "Percent in Level")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,100)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-20-1.png)<!-- -->

The majority of employees have a 'better' work life balance.The job nor department seems to make a difference.

### Exploring Trends with Business Travel and Job Satisfaction

```r
TravelAnalysis <- data.frame(table(CurrentEmployees$BusinessTravel, CurrentEmployees$JobSatisfaction))
colnames(TravelAnalysis) <- c("Travel", "Satisfaction" , "Freq")
TravelAnalysis <- TravelAnalysis[ ! TravelAnalysis$Freq==0, ]   
#change counts to percentages
TravelAnalysis <- TravelAnalysis %>% 
  group_by(Travel) %>% 
  mutate(perc=Freq/sum(Freq))  
TravelAnalysis$perc <- TravelAnalysis$perc*100

ggplot(TravelAnalysis, aes(x= Travel, y=perc)) + 
  coord_flip() + 
  ggtitle("Job Satisfaction by Travel Amounts") +
  theme(strip.text.x = element_text(angle = 0)) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity", position = "dodge", colour = "black", width=0.4) + 
  labs(x= "Travel Frequency", y= "Percent Satisfaction")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,100)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-21-1.png)<!-- -->

There does not seem to be much difference in travel frequency and job satisfaction however, employees who travel rarely do have the highest percentage of low satisfaction.

### Exploring Trends with Education Level and Monthly Income

```r
ggplot(data=CurrentEmployees,aes(x= Education,y=MonthlyIncome)) + 
  geom_boxplot(fill = "white", outlier.colour = "red", colour = "blue") +
  coord_flip() + 
  ggtitle("Monthly Income by Education Level")
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-22-1.png)<!-- -->

Employees with Doctorate Degree's have the highest median monthly income, while below college has the lowest median monthly salary. This is consisent with society's expectation of more education, more pay. Note there are outliers in every education level besides doctor, this is most likely due to those employees being at the company longer.

### Trends with Years at Company and Monthly Income

```r
qplot(YearsAtCompany, MonthlyIncome, colour = Education, shape = Department, data = CurrentEmployees)
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-23-1.png)<!-- -->

There is not a strong relationship between years at the company and monthly income-- factoring in income does not seem to explain the huge amount of outliers either.

### Trends with Education Level and Monthly Income

```r
ggplot(data=CurrentEmployees,aes(x= JobSatisfaction,y=MonthlyIncome)) + 
  geom_boxplot(fill = "white", outlier.colour = "red", colour = "blue") +
  coord_flip() + 
  ggtitle("Monthly Income by Education Level")
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-24-1.png)<!-- -->
There is not a noticeable difference between median monthly income and job satisfaction levels. This leads us to conclude the more an employee is paid does not mean they will necessarily have a higher job satisfaction.

### Trends wih Job Role and Years in Current Role

```r
ggplot(data=CurrentEmployees,aes(x= JobRole,y=YearsInCurrentRole)) + 
  geom_boxplot(fill = "white", outlier.colour = "red", colour = "blue") +
  coord_flip() + 
  ggtitle("Job Role and Number of Companies Worked") +
  scale_y_continuous(expand = c(0,0), limits = c(0,20))
```

![](F:\github\CASE_S~1\DDSANA~1/figure-html/unnamed-chunk-25-1.png)<!-- -->

Research Directors and Managers have the highest median years in current role, which means they tend to have worked at the company the longest. Sale Representatives, Library Technicians and Human Resources tend to have worked at the company the shortest amount of time. As we found out by exploring attrition rates, this is because their attrition rate is significantly higher than other roles. 

### Exploring Trends with Attrition

```r
#Salary difference between income by attrition
t.test(MonthlyIncome~Attrition, data=analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  MonthlyIncome by Attrition
## t = 7.4826, df = 412.74, p-value = 4.434e-13
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1508.244 2583.050
## sample estimates:
##  mean in group No mean in group Yes 
##          6832.740          4787.093
```

```r
#Total Working Years and Monthly salary
t.test(MonthlyIncome~PerformanceRating, data=analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  MonthlyIncome by PerformanceRating
## t = 0.66007, df = 313.96, p-value = 0.5097
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -442.4770  889.2376
## sample estimates:
##   mean in group Excellent mean in group Outstanding 
##                  6537.274                  6313.894
```

```r
#Years with Manager and Attrition
t.test(YearsWithCurrManager~Attrition, data = analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  YearsWithCurrManager by Attrition
## t = 6.6334, df = 365.1, p-value = 1.185e-10
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1.065929 1.964223
## sample estimates:
##  mean in group No mean in group Yes 
##          4.367397          2.852321
```

```r
#Years since promotion and attrition
t.test(YearsSinceLastPromotion~Attrition, data = analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  YearsSinceLastPromotion by Attrition
## t = 1.2879, df = 338.49, p-value = 0.1987
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.1525043  0.7309843
## sample estimates:
##  mean in group No mean in group Yes 
##          2.234388          1.945148
```

```r
#Difference in Working Years and Attrition
t.test(TotalWorkingYears~Attrition, data = analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  TotalWorkingYears by Attrition
## t = 7.0192, df = 350.88, p-value = 1.16e-11
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  2.604401 4.632019
## sample estimates:
##  mean in group No mean in group Yes 
##         11.862936          8.244726
```

```r
#Difference in companies worked and attrition
t.test(NumCompaniesWorked~Attrition, data = analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  NumCompaniesWorked by Attrition
## t = -1.5747, df = 317.14, p-value = 0.1163
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.66437603  0.07367926
## sample estimates:
##  mean in group No mean in group Yes 
##          2.645580          2.940928
```

```r
#Difference in years in current role and attrition
t.test(YearsInCurrentRole~Attrition, data = analysis_df)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  YearsInCurrentRole by Attrition
## t = 6.8471, df = 366.57, p-value = 3.187e-11
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1.127107 2.035355
## sample estimates:
##  mean in group No mean in group Yes 
##          4.484185          2.902954
```

There is a statistically significant difference between income levels and their attrition rates. 
There is a statistically significant difference between years with manager and their attrition rates.
There is a statistically significant difference between years working and their attrition rates.
There is a statistically significant difference between years in current role and their attrition rates.


```r
summary(CurrentEmployees)
```

```
##  Attrition            BusinessTravel   DailyRate     
##  No :1233   Non-Travel       :138    Min.   : 102.0  
##  Yes:   0   Travel_Frequently:208    1st Qu.: 477.0  
##             Travel_Rarely    :887    Median : 817.0  
##                                      Mean   : 812.5  
##                                      3rd Qu.:1176.0  
##                                      Max.   :1499.0  
##                                                      
##                   Department  DistanceFromHome         Education  
##  Human Resources       : 51   Min.   : 1.000   Below College:139  
##  Research & Development:828   1st Qu.: 2.000   College      :238  
##  Sales                 :354   Median : 7.000   Bachelor     :473  
##                               Mean   : 8.916   Master       :340  
##                               3rd Qu.:13.000   Doctor       : 43  
##                               Max.   :29.000                      
##                                                                   
##           EducationField EnvironmentSatisfaction   HourlyRate    
##  Human Resources : 20    Low      :212           Min.   : 30.00  
##  Life Sciences   :517    Medium   :244           1st Qu.: 48.00  
##  Marketing       :124    High     :391           Median : 66.00  
##  Medical         :401    Very High:386           Mean   : 65.95  
##  Other           : 71                            3rd Qu.: 83.00  
##  Technical Degree:100                            Max.   :100.00  
##                                                                  
##    JobInvolvement JobLevel                      JobRole   
##  Low      : 55    1:400    Sales Executive          :269  
##  Medium   :304    2:482    Research Scientist       :245  
##  High     :743    3:186    Laboratory Technician    :197  
##  Very High:131    4:101    Manufacturing Director   :135  
##                   5: 64    Healthcare Representative:122  
##                            Manager                  : 97  
##                            (Other)                  :168  
##   JobSatisfaction MonthlyIncome    MonthlyRate    NumCompaniesWorked
##  Low      :223    Min.   : 1051   Min.   : 2094   Min.   :0.000     
##  Medium   :234    1st Qu.: 3211   1st Qu.: 7973   1st Qu.:1.000     
##  High     :369    Median : 5204   Median :14120   Median :2.000     
##  Very High:407    Mean   : 6833   Mean   :14266   Mean   :2.646     
##                   3rd Qu.: 8834   3rd Qu.:20364   3rd Qu.:4.000     
##                   Max.   :19999   Max.   :26997   Max.   :9.000     
##                                                                     
##  OverTime  PercentSalaryHike   PerformanceRating RelationshipSatisfaction
##  No :944   Min.   :11.00     Excellent  :1044    Low      :219           
##  Yes:289   1st Qu.:12.00     Outstanding: 189    Medium   :258           
##            Median :14.00                         High     :388           
##            Mean   :15.23                         Very High:368           
##            3rd Qu.:18.00                                                 
##            Max.   :25.00                                                 
##                                                                          
##  StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance
##  0:477            Min.   : 0.00     Min.   :0.000         Bad   : 55     
##  1:540            1st Qu.: 6.00     1st Qu.:2.000         Good  :286     
##  2:146            Median :10.00     Median :3.000         Better:766     
##  3: 70            Mean   :11.86     Mean   :2.833         Best  :126     
##                   3rd Qu.:16.00     3rd Qu.:3.000                        
##                   Max.   :38.00     Max.   :6.000                        
##                                                                          
##  YearsAtCompany   YearsInCurrentRole YearsSinceLastPromotion
##  Min.   : 0.000   Min.   : 0.000     Min.   : 0.000         
##  1st Qu.: 3.000   1st Qu.: 2.000     1st Qu.: 0.000         
##  Median : 6.000   Median : 3.000     Median : 1.000         
##  Mean   : 7.369   Mean   : 4.484     Mean   : 2.234         
##  3rd Qu.:10.000   3rd Qu.: 7.000     3rd Qu.: 3.000         
##  Max.   :37.000   Max.   :18.000     Max.   :15.000         
##                                                             
##  YearsWithCurrManager
##  Min.   : 0.000      
##  1st Qu.: 2.000      
##  Median : 3.000      
##  Mean   : 4.367      
##  3rd Qu.: 7.000      
##  Max.   :17.000      
## 
```

*Highlights:*
* There are currently 1,233 employees we have data for.
* The Research and Development Department is the largest, comprising of 67.2% of the employees.
* 69.3% of employees have obtained a Bachelor's Degree or higher.
* About 17.2% of employees have a low environment satisfaction.
* The median hourly rate is 65.95-- this seems relatively low since the daily rate is $817.
* Only 4.5% of employees have a low job involvement, while 60.3% of employees have high job involvement.
* 18.1% of employees have low job satisfaction.
* Most employees do not have to work overtime(80.1%).
* The median training times last year was three hours.
* Employees get promoted almost every year-- the median years since last promotion is one.
  
# Conclusion of Analysis
* Recorded data was useful for determining attrition
* Different methodologies can lead to different conclusions about what variables are most important
* Combining different measures, we determined that the top 5 variables determining attrition are:

1. Overtime
2. Stock Option Level
3. Job Role
4. Job Level
5. Years with current manager

* We discovered no statistically significant trends that lead to a higher job satisfaction



  
