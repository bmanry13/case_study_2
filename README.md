# Case Study 2 README

## Introduction 
DDSAnalytics, an analytics company that specialized in talent management solutions for Furtune 100 companies, is planning to leverage data science for talent management. Talent management is defined as the iterative process of developing and retaining employees. It may include workforce planning, employee training programs, identifying high-potential employees and reducing/preventing voluntary employee turnover (attrition). Our goal is to maximize talent management. 

## Purpose 
This project uses exploratory data analysis to determine the top three factors that lead to attrition. In addition, we want to discover trends within specific job roles. This will give DDSAnalytics a competitive edge over its competition.

## Instructions for reproducing output
 1. Clone this repository
 2. Download and install the libraries
 3. Load the packages


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
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] tidyr_0.7.0  bindrcpp_0.2 readr_1.1.1  dplyr_0.7.2 
## 
## loaded via a namespace (and not attached):
##  [1] zoo_1.8-0          tidyselect_0.1.1   Rook_1.1-1        
##  [4] purrr_0.2.3        lattice_0.20-35    colorspace_1.3-2  
##  [7] htmltools_0.3.6    viridisLite_0.2.0  yaml_2.1.14       
## [10] XML_3.98-1.9       rlang_0.1.2        glue_1.1.1        
## [13] sp_1.2-5           RColorBrewer_1.1-2 readxl_1.0.0      
## [16] bindr_0.1          plyr_1.8.4         stringr_1.2.0     
## [19] munsell_0.4.3      gtable_0.2.0       cellranger_1.1.0  
## [22] data.tree_0.7.3    visNetwork_2.0.1   htmlwidgets_0.9   
## [25] evaluate_0.10.1    knitr_1.17         DiagrammeR_0.9.2  
## [28] Rcpp_0.12.12       scales_0.5.0       backports_1.1.0   
## [31] jsonlite_1.5       rgexf_0.15.3       gridExtra_2.2.1   
## [34] brew_1.0-6         ggplot2_2.2.1      hms_0.3           
## [37] digest_0.6.12      stringi_1.1.5      grid_3.4.1        
## [40] rprojroot_1.2      influenceR_0.1.0   rgdal_1.2-13      
## [43] tools_3.4.1        magrittr_1.5       lazyeval_0.2.0    
## [46] tibble_1.3.4       pkgconfig_2.0.1    downloader_0.4    
## [49] assertthat_0.2.0   rmarkdown_1.6      rstudioapi_0.6    
## [52] viridis_0.4.0      R6_2.2.2           igraph_1.1.2      
## [55] compiler_3.4.1
```

## File Structure

```r
data.tree::as.Node(data.frame(pathString = paste0("Root/",list.files(recursive = TRUE))))
```

```
##                     levelName
## 1  Root                      
## 2   ?--case_study_2.Rproj    
## 3   ?--case_study_extra      
## 4   ?   ?--CaseStudy02.pdf   
## 5   ?--data_processing.R     
## 6   ?--MakeAnalysis.R        
## 7   ?--rawdata               
## 8   ?   ?--CaseStudy2data.zip
## 9   ?--README.md             
## 10  ?--README.Rmd
```

