# Case Study 2 README

## Introduction 
TODO

## Purpose 
TODO

## Instructions for reproducing output
 1. Clone this repository
 2. Download and install the libraries
 3. Load the packages


## Contributors: 
Brychan Manry and Patricia Goresen

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
## [1] readr_1.1.1 dplyr_0.7.2
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.12       compiler_3.4.1     RColorBrewer_1.1-2
##  [4] influenceR_0.1.0   plyr_1.8.4         bindr_0.1         
##  [7] viridis_0.4.0      tools_3.4.1        digest_0.6.12     
## [10] evaluate_0.10.1    jsonlite_1.5       viridisLite_0.2.0 
## [13] tibble_1.3.4       gtable_0.2.0       rgexf_0.15.3      
## [16] pkgconfig_2.0.1    rlang_0.1.2        igraph_1.1.2      
## [19] rstudioapi_0.6     yaml_2.1.14        bindrcpp_0.2      
## [22] gridExtra_2.2.1    knitr_1.17         downloader_0.4    
## [25] DiagrammeR_0.9.2   stringr_1.2.0      htmlwidgets_0.9   
## [28] hms_0.3            rprojroot_1.2      grid_3.4.1        
## [31] data.tree_0.7.3    glue_1.1.1         R6_2.2.2          
## [34] Rook_1.1-1         XML_3.98-1.9       rmarkdown_1.6     
## [37] purrr_0.2.3        tidyr_0.7.0        ggplot2_2.2.1     
## [40] magrittr_1.5       backports_1.1.0    scales_0.5.0      
## [43] htmltools_0.3.6    assertthat_0.2.0   colorspace_1.3-2  
## [46] brew_1.0-6         stringi_1.1.5      visNetwork_2.0.1  
## [49] lazyeval_0.2.0     munsell_0.4.3
```

## File Structure

```r
data.tree::as.Node(data.frame(pathString = paste0("Root/",list.files(recursive = TRUE))))
```

```
##                levelName
## 1 Root                  
## 2  ¦--case_study_2.Rproj
## 3  ¦--MakeAnalysis.R    
## 4  ¦--README.md         
## 5  °--README.Rmd
```

