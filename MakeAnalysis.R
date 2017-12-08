#################################################################################'
# File name: MakeAnalysis.R
# Author: Brychan Manry
# Creation Date: 11/26/2017
# Last Edited: 12/7/2017
# Description: This file runs the source files, creates the analysis html document,
#               and then creates GitHub readme file
#################################################################################'

##### LOAD ALL LIBRARIES REQUIRED FOR ANALYSIS #####
library(MASS)
library(dplyr)
library(tidyr)
library(readxl)
library(knitr)
library(ggplot2)
library(randomForest)
library(gbm)
library(kableExtra)

##### INGEST DATA #####
source("./source/data_processing.R")

##### Knit html and Markdown File ####
rmarkdown::render(input = "./analysis/analysis_main.Rmd", 
                  output_file = "DDSAnalytics - Key Attrition Factors Analysis.html",
                  output_dir = ".",
                  output_options =  list(keep_md = TRUE, self_contained=TRUE,
                                         theme = "journal", toc = TRUE, toc_float = TRUE))

##### Knit README file for GitHub #####
knitr::knit(input = "README.Rmd", output = "README.md")
