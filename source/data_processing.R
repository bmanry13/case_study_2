#################################################################################'
# File name: data_processing.R
# Author: Brychan Manry
# Creation Date: 11/26/2017
# Last Edited: 11/26/2017
# Description: This source file reads in raw xlsx file provided for analysis and 
#               processes the data by: creating factors and adding factor definition
#               provided; removing unnecessary columns.
#
# R libraries: dplyr, tidyr, readxl
# input files: ./rawdata/CaseStudy2data.zip
#
# Output:
#   1) analysis_df -> data.frame, each row is individual employee
#
#################################################################################'
##### Load Libraries #####
library(dplyr)

##### 1) LOAD RAW DATA #####
unzip(zipfile = "./rawdata/CaseStudy2data.zip", files = "CaseStudy2-data.xlsx", exdir = "tempextract") # unzip to temp directory
rawdata_df <- readxl::read_xlsx("./tempextract/CaseStudy2-data.xlsx", sheet = "HR-employee-attrition Data")
data_def_df <- readxl::read_xlsx("./tempextract/CaseStudy2-data.xlsx", sheet = "Data Definitions", col_names = c("variable", "rawcode"))
unlink("./tempextract", recursive = TRUE) # delete temp dir

##### 2) PROCESS DATA DEFINITIONS DF #####
data_def_df <- data_def_df %>% 
  filter(!(is.na(variable) & is.na(rawcode))) %>% # remove empty rows
  tidyr::fill(variable) # forward fill missing

#== CREATE LIST FOR EACH FACTOR VARIABLE DEFINITION IN data_def_df
data_def_list <- lapply(split(data_def_df, data_def_df$variable), function(df){
  lvl <- sapply(strsplit(df$rawcode, " '"), function(x) x[1],simplify = "vector")
  code <- gsub("'","",sapply(strsplit(df$rawcode, " '"), function(x) x[2],simplify = "vector"))
  return(list(lvl = lvl, code = code))
})

#== FOR EACH VARIABLE WITH DEFINITION APPLY FACOTOR DEFINITION
rawdata_df[names(data_def_list)] <- lapply(names(data_def_list), function(x){
  vals <- as.data.frame(rawdata_df)[,x]
  tmp_lvl <- data_def_list[[x]]$lvl
  tmp_lab <- data_def_list[[x]]$code
  tmp_lvl_exist <- tmp_lvl%in%vals
    return(factor(vals, levels = tmp_lvl[tmp_lvl_exist], labels = tmp_lab[tmp_lvl_exist]))
})

##### 3) PROCESS RAW DATA #####
#== CONVERT CHARACTER TO FACTOR
rawdata_df <- rawdata_df %>% mutate_if(is.character, as.factor)

#== Additional Numeric based Factors
rawdata_df$JobLevel <- factor(rawdata_df$JobLevel)
rawdata_df$StockOptionLevel <- factor(rawdata_df$StockOptionLevel)

#== ADDITIONAL FACTOR VARIABLES
numeric_to_factor_vars <- c("JobLevel","StockOptionLevel")
rawdata_df[numeric_to_factor_vars] <- lapply(rawdata_df[numeric_to_factor_vars], factor)

#== IDENTIFY VARIABLES TO REMOVE FROM ANALYSIS
#-- FACTORS MUST HAVE MORE THAN ONE LEVEL
single_value_vars <- names(rawdata_df)[!sapply(rawdata_df, function(x) length(unique(x)) > 1)]
#-- PROTECTED CLASS VARIABLES
protect_class_vars <- c("Age", "Gender", "MaritalStatus")
#-- Non-Informative Variables
non_inforative_vars <- c("EmployeeNumber", "StandardHours", "EmployeeCount")

#-- REMOVE UNNECESSARY VARIABLES ----
all_removed_vars <- c(single_value_vars, protect_class_vars, non_inforative_vars)
rawdata_df <- rawdata_df[names(rawdata_df)[!names(rawdata_df)%in%all_removed_vars]]

#### 4) FINAL ANALYSIS DF ####
analysis_df <- rawdata_df

#== CLEANUP
rm(list = ls()[ls()!="analysis_df"])