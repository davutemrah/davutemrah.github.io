---
title: "Web Scraping using rvest package"
author: "Davut Ayan"
date: '2021-08-21'
slug: first post
categories: ["R"]
tags: ["R", "Web Scraping", "rvest"]
subtitle: ''
summary: 'This project showcases how `rvest` package in `R` can be utilized to scrape data from a website.'
lastmod: "2023-11-29"
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---





**Loading required packages**
    

```r
library(rvest)  ## web scraping
```

Here I read data from AEA website urls using *read_html()* function.


```r
url1 <- "https://www.aeaweb.org/about-aea/committees/csmgep/neacode-a-l"
url2 <- "https://www.aeaweb.org/about-aea/committees/csmgep/neacode-m-z"
simple <- read_html(url1)
simple2 <- read_html(url2)
simple
## {html_document}
## <html class="no-js" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="internal generic-detail">\n    <div class="cookie-legal-bann ...
```

As seen above, downloaded data is list of *head* and *body*. Understanding the nature of this data requires at least basic literacy of html documents. Data is structured like a tree and branches. Each point in data, denoted node, has different category of information.

Before we delve into downloaded data, it is wise to see the website we want to scrape in developer mode (inspect element) so that we can understand how the website is structured and what type of information exists.

Below you can see what values are contained in node "p", also check the website and see what the tag \<p> contains.


```r
simple %>%
    html_nodes("p") %>%
    html_text()
## [1] "By clicking the \"Accept\" button or continuing to browse our site, you agree to first-party and session-only cookies being stored on your device to enhance site navigation and analyze site performance and traffic. For more information on our use of cookies, please see our Privacy Policy."
## [2] "The NEACODE is a historical listing of Black economists. Please contact Professor Gregory Price at gprice@morehouse.edu for questions and suggestions."                                                                                                                                           
## [3] " "                                                                                                                                                                                                                                                                                                
## [4] "Get instructions on submitting your work for publication."                                                                                                                                                                                                                                        
## [5] "Join the AEA."                                                                                                                                                                                                                                                                                    
## [6] "Explore the AEA's prestigious journals."                                                                                                                                                                                                                                                          
## [7] "Copyright 2023 American Economic Association. All\n    rights reserved."                                                                                                                                                                                                                          
## [8] "Terms of Use & Privacy Policy"
```

I can extract column names (variable names) from the node "th". There are five columns and I can extract 5 column names. 


```r
names <- 
simple %>%
    html_nodes("th") %>%
    html_text()

names <- make.names(names)  # quickly convert column names
names
## [1] "Last.Name"           "Full.Name"           "Year.Hired"         
## [4] "College.Institution" "Alma.Mater"
```

And below I extract the main data from the node "td". Data is extracted into a vector named "vec".


```r
vec <-
simple %>%
    html_nodes("td") %>%
    html_text()

head(vec)
## [1] "Abegaz"           "Berhanu Abegaz"   "1982"             "William and Mary"
## [5] "Pennsylvania"     "Adams"
```

Then I can convert the vector in a matrix format. There are five columns and number of rows are computed automatically.


```r
mat <- 
    matrix(vec, nrow = round(length(vec)/5), ncol = 5, byrow = T)
mat[1:5, 1:4]
##      [,1]        [,2]                 [,3]   [,4]                         
## [1,] "Abegaz"    "Berhanu Abegaz"     "1982" "William and Mary"           
## [2,] "Adams"     "Laurel A. Adams"    "1993" "Rollings College"           
## [3,] "Adedeji"   "Adebayo M. Adejeji" "1990" "Congressional Budget Office"
## [4,] "Agbeyegbe" "Terence Agbeyegbe"  "1983" "CUNY-Hunter"                
## [5,] "Agesa"     "Jacqueline Agesa"   "1996" "Marshall University"
```

And finally, I can convert the matrix to a data frame attaching variable names.


```r
df1 <- as.data.frame(mat)
names(df1) <- names

head(df1, n=5)
##   Last.Name          Full.Name Year.Hired         College.Institution
## 1    Abegaz     Berhanu Abegaz       1982            William and Mary
## 2     Adams    Laurel A. Adams       1993            Rollings College
## 3   Adedeji Adebayo M. Adejeji       1990 Congressional Budget Office
## 4 Agbeyegbe  Terence Agbeyegbe       1983                 CUNY-Hunter
## 5     Agesa   Jacqueline Agesa       1996         Marshall University
##                      Alma.Mater
## 1                  Pennsylvania
## 2                  Pennsylvania
## 3                         Miami
## 4 University of Essex (Foreign)
## 5                  UW Milwaukee
```

Same procedure is followed for the second url which contains the rest of the data.


```r
names2 <-
simple2 %>%
    html_nodes("th") %>%
    html_text()
names2 <- make.names(names2)  # quickly convert column names
names2
## [1] "Last.Name"           "Full.Name"           "Year.Hired"         
## [4] "College.Institution" "Alma.Mater"
```


```r
vec2 <-
simple2 %>%
    html_nodes("td") %>%
    html_text()
head(vec2)
## [1] "Mason"                 "Patrick L. Mason"      "1991"                 
## [4] "Florida State"         "New School University" "Mbaku"
```


```r
mat2 <- 
    matrix(vec2, nrow = round(length(vec2)/5), ncol = 5, byrow = T)
mat2[1:5, 1:4]
##      [,1]       [,2]                  [,3]   [,4]                        
## [1,] "Mason"    "Patrick L. Mason"    "1991" "Florida State"             
## [2,] "Mbaku"    "John M. Mbaku"       "1985" "Weber State"               
## [3,] "McDonald" "Vincent R. McDonald" "1968" "Howard University"         
## [4,] "McDowell" "Donald R. McDowell"  "1985" "North Carolina A&T"        
## [5,] "McElroy"  "Susan W. McElroy"    "1996" "University of Texas-Dallas"
```



```r
df2 <- as.data.frame(mat)
names(df2) <- names

head(df2, n=5)
##   Last.Name          Full.Name Year.Hired         College.Institution
## 1    Abegaz     Berhanu Abegaz       1982            William and Mary
## 2     Adams    Laurel A. Adams       1993            Rollings College
## 3   Adedeji Adebayo M. Adejeji       1990 Congressional Budget Office
## 4 Agbeyegbe  Terence Agbeyegbe       1983                 CUNY-Hunter
## 5     Agesa   Jacqueline Agesa       1996         Marshall University
##                      Alma.Mater
## 1                  Pennsylvania
## 2                  Pennsylvania
## 3                         Miami
## 4 University of Essex (Foreign)
## 5                  UW Milwaukee
```
And we can append (merge) those files and make one complete data frame with all African American economists in the US.

Among many ways to append data frames sharing the same column names, I show below merging (appending in STATA) using dplyr package, particularly calling bind_rows() function because of its advantages over other methods.

[rbind.data.frame(), do.call(rbind, ) ... ]


```r
df <- bind_rows(df1, df2)

head(df, n=5)
##   Last.Name          Full.Name Year.Hired         College.Institution
## 1    Abegaz     Berhanu Abegaz       1982            William and Mary
## 2     Adams    Laurel A. Adams       1993            Rollings College
## 3   Adedeji Adebayo M. Adejeji       1990 Congressional Budget Office
## 4 Agbeyegbe  Terence Agbeyegbe       1983                 CUNY-Hunter
## 5     Agesa   Jacqueline Agesa       1996         Marshall University
##                      Alma.Mater
## 1                  Pennsylvania
## 2                  Pennsylvania
## 3                         Miami
## 4 University of Essex (Foreign)
## 5                  UW Milwaukee
```




