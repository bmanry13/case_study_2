# Case Study 2 README

## Introduction 
DDSAnalytics, an analytics company that specialized in talent management solutions for Furtune 100 companies, is planning to leverage data science for talent management. Talent management is defined as the iterative process of developing and retaining employees. It may include workforce planning, employee training programs, identifying high-potential employees and reducing/preventing voluntary employee turnover (attrition). Our goal is to maximize talent management. 

## Purpose 
This project uses exploratory data analysis to determine the top three factors that lead to attrition. In addition, we want to discover trends within specific job roles. This will give DDSAnalytics a competitive edge over its competition.

## Instructions for reproducing output
 1. Clone this repository
 2. Download and install the libraries
 3. Run MakeAnalysis.R

## Summary of Findings:
1. The top five variables for determining attrition are: overtime, stock option level, job role, job level and years with current manager
2. Sales Representatives have the highest rate of attrition (the most likely to leave the Company)
3. Research and Development employees are the most satisfied in their jobs.

## Contributors: 
Brychan Manry,Patricia Goresen, and Bradley Robinson

## Session Info

```
## R version 3.4.1 (2017-06-30)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] parallel  splines   stats     graphics  grDevices utils     datasets 
## [8] methods   base     
## 
## other attached packages:
##  [1] kableExtra_0.5.2    bindrcpp_0.2        gbm_2.1.3          
##  [4] lattice_0.20-35     survival_2.41-3     randomForest_4.6-12
##  [7] ggplot2_2.2.1       knitr_1.17          readxl_1.0.0       
## [10] tidyr_0.7.0         dplyr_0.7.2         MASS_7.3-47        
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.1.1   Rook_1.1-1         purrr_0.2.3       
##  [4] reshape2_1.4.2     corrplot_0.84      colorspace_1.3-2  
##  [7] viridisLite_0.2.0  htmltools_0.3.6    yaml_2.1.14       
## [10] base64enc_0.1-3    XML_3.98-1.9       rlang_0.1.2       
## [13] glue_1.1.1         RColorBrewer_1.1-2 bindr_0.1         
## [16] plyr_1.8.4         stringr_1.2.0      munsell_0.4.3     
## [19] gtable_0.2.0       cellranger_1.1.0   rvest_0.3.2       
## [22] data.tree_0.7.3    visNetwork_2.0.1   htmlwidgets_0.9   
## [25] evaluate_0.10.1    labeling_0.3       DiagrammeR_0.9.2  
## [28] highr_0.6.1        Rcpp_0.12.12       readr_1.1.1       
## [31] scales_0.5.0       backports_1.1.0    jsonlite_1.5      
## [34] rgexf_0.15.3       gridExtra_2.2.1    brew_1.0-6        
## [37] hms_0.3            digest_0.6.12      stringi_1.1.5     
## [40] influenceR_0.1.0   grid_3.4.1         rprojroot_1.2     
## [43] tools_3.4.1        magrittr_1.5       lazyeval_0.2.0    
## [46] tibble_1.3.4       pkgconfig_2.0.1    Matrix_1.2-10     
## [49] xml2_1.1.1         downloader_0.4     viridis_0.4.0     
## [52] rstudioapi_0.6     assertthat_0.2.0   rmarkdown_1.6     
## [55] httr_1.3.1         R6_2.2.2           igraph_1.1.2      
## [58] compiler_3.4.1
```

## File Structure

```r
data.tree::as.Node(data.frame(pathString = paste0("Root/",list.files(recursive = TRUE))))
```

```
##                                                   levelName
## 1   Root                                                   
## 2    ¦--analysis                                           
## 3    ¦   ¦--analysis_main.Rmd                              
## 4    ¦   °--analysis_testing_sandbox                       
## 5    ¦       ¦--analysis_testing.R                         
## 6    ¦       ¦--eda.nb.html                                
## 7    ¦       ¦--eda.Rmd                                    
## 8    ¦       °--TrendAnalysis.Rmd                          
## 9    ¦--case_study_2.Rproj                                 
## 10   ¦--case_study_extra                                   
## 11   ¦   °--CaseStudy02.pdf                                
## 12   ¦--DDSAnalytics - Key Attrition Factors Analysis.html 
## 13   ¦--DDSAnalytics - Key Attrition Factors Analysis.md   
## 14   ¦--DDSAnalytics - Key Attrition Factors Analysis_files
## 15   ¦   °--figure-html                                    
## 16   ¦       ¦--coLinAssess-1.png                          
## 17   ¦       ¦--rf-1.png                                   
## 18   ¦       ¦--unnamed-chunk-1-1.png                      
## 19   ¦       ¦--unnamed-chunk-15-1.png                     
## 20   ¦       ¦--unnamed-chunk-16-1.png                     
## 21   ¦       ¦--unnamed-chunk-17-1.png                     
## 22   ¦       ¦--unnamed-chunk-18-1.png                     
## 23   ¦       ¦--unnamed-chunk-19-1.png                     
## 24   ¦       ¦--unnamed-chunk-2-1.png                      
## 25   ¦       ¦--unnamed-chunk-20-1.png                     
## 26   ¦       ¦--unnamed-chunk-21-1.png                     
## 27   ¦       ¦--unnamed-chunk-22-1.png                     
## 28   ¦       ¦--unnamed-chunk-23-1.png                     
## 29   ¦       ¦--unnamed-chunk-24-1.png                     
## 30   ¦       ¦--unnamed-chunk-25-1.png                     
## 31   ¦       ¦--unnamed-chunk-25-10.png                    
## 32   ¦       ¦--unnamed-chunk-25-11.png                    
## 33   ¦       ¦--unnamed-chunk-25-12.png                    
## 34   ¦       ¦--unnamed-chunk-25-13.png                    
## 35   ¦       ¦--unnamed-chunk-25-14.png                    
## 36   ¦       ¦--unnamed-chunk-25-15.png                    
## 37   ¦       ¦--unnamed-chunk-25-16.png                    
## 38   ¦       ¦--unnamed-chunk-25-17.png                    
## 39   ¦       ¦--unnamed-chunk-25-18.png                    
## 40   ¦       ¦--unnamed-chunk-25-19.png                    
## 41   ¦       ¦--unnamed-chunk-25-2.png                     
## 42   ¦       ¦--unnamed-chunk-25-20.png                    
## 43   ¦       ¦--unnamed-chunk-25-21.png                    
## 44   ¦       ¦--unnamed-chunk-25-22.png                    
## 45   ¦       ¦--unnamed-chunk-25-23.png                    
## 46   ¦       ¦--unnamed-chunk-25-24.png                    
## 47   ¦       ¦--unnamed-chunk-25-25.png                    
## 48   ¦       ¦--unnamed-chunk-25-26.png                    
## 49   ¦       ¦--unnamed-chunk-25-27.png                    
## 50   ¦       ¦--unnamed-chunk-25-3.png                     
## 51   ¦       ¦--unnamed-chunk-25-4.png                     
## 52   ¦       ¦--unnamed-chunk-25-5.png                     
## 53   ¦       ¦--unnamed-chunk-25-6.png                     
## 54   ¦       ¦--unnamed-chunk-25-7.png                     
## 55   ¦       ¦--unnamed-chunk-25-8.png                     
## 56   ¦       ¦--unnamed-chunk-25-9.png                     
## 57   ¦       ¦--unnamed-chunk-31-1.png                     
## 58   ¦       ¦--unnamed-chunk-32-1.png                     
## 59   ¦       ¦--unnamed-chunk-33-1.png                     
## 60   ¦       ¦--unnamed-chunk-34-1.png                     
## 61   ¦       ¦--unnamed-chunk-35-1.png                     
## 62   ¦       ¦--unnamed-chunk-36-1.png                     
## 63   ¦       ¦--unnamed-chunk-37-1.png                     
## 64   ¦       ¦--unnamed-chunk-38-1.png                     
## 65   ¦       ¦--unnamed-chunk-39-1.png                     
## 66   ¦       ¦--unnamed-chunk-4-1.png                      
## 67   ¦       ¦--unnamed-chunk-40-1.png                     
## 68   ¦       ¦--unnamed-chunk-41-1.png                     
## 69   ¦       ¦--unnamed-chunk-6-1.png                      
## 70   ¦       ¦--unnamed-chunk-9-1.png                      
## 71   ¦       ¦--unnamed-chunk-9-10.png                     
## 72   ¦       ¦--unnamed-chunk-9-11.png                     
## 73   ¦       ¦--unnamed-chunk-9-12.png                     
## 74   ¦       ¦--unnamed-chunk-9-13.png                     
## 75   ¦       ¦--unnamed-chunk-9-14.png                     
## 76   ¦       ¦--unnamed-chunk-9-15.png                     
## 77   ¦       ¦--unnamed-chunk-9-16.png                     
## 78   ¦       ¦--unnamed-chunk-9-17.png                     
## 79   ¦       ¦--unnamed-chunk-9-18.png                     
## 80   ¦       ¦--unnamed-chunk-9-19.png                     
## 81   ¦       ¦--unnamed-chunk-9-2.png                      
## 82   ¦       ¦--unnamed-chunk-9-20.png                     
## 83   ¦       ¦--unnamed-chunk-9-21.png                     
## 84   ¦       ¦--unnamed-chunk-9-22.png                     
## 85   ¦       ¦--unnamed-chunk-9-23.png                     
## 86   ¦       ¦--unnamed-chunk-9-24.png                     
## 87   ¦       ¦--unnamed-chunk-9-25.png                     
## 88   ¦       ¦--unnamed-chunk-9-26.png                     
## 89   ¦       ¦--unnamed-chunk-9-27.png                     
## 90   ¦       ¦--unnamed-chunk-9-3.png                      
## 91   ¦       ¦--unnamed-chunk-9-4.png                      
## 92   ¦       ¦--unnamed-chunk-9-5.png                      
## 93   ¦       ¦--unnamed-chunk-9-6.png                      
## 94   ¦       ¦--unnamed-chunk-9-7.png                      
## 95   ¦       ¦--unnamed-chunk-9-8.png                      
## 96   ¦       °--unnamed-chunk-9-9.png                      
## 97   ¦--MakeAnalysis.R                                     
## 98   ¦--rawdata                                            
## 99   ¦   °--CaseStudy2data.zip                             
## 100  °--... 3 nodes w/ 1 sub
```

