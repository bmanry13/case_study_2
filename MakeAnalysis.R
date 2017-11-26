#################################################################################'
# File name: MakeAnalysis.R
# Author: Brychan Manry
# Creation Date: 11/26/2017
# Last Edited: 11/26/2017
# Description: This file runs the source files, creates the analysis html document,
#               and then creates GitHub readme file
#################################################################################'

##### LOAD ALL LIBRARIES REQUIRED FOR ANALYSIS #####
library(dplyr)
library(readr)


##### INGEST DATA #####
# TODO
#source("./source/data_processing.R")

##### Knit html and Markdown File ####
# TODO

##### Knit README file for GitHub #####
knitr::knit(input = "README.Rmd", output = "README.md")
