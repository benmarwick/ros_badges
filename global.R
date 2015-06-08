

library(googlesheets)
library(dplyr)
my_gsheet_key <-  "1CrXOj26zohHvQ7RGzco4boqrXT7oNUeBZDPtFAyZdFQ"
my_gsheet <- gs_key(my_gsheet_key, visibility = "public") 
# my_gsheet <- read.csv(my_gsheet$ws$exportcsv[1], stringsAsFactors = FALSE)

library(RCurl)
x <- getURL(my_gsheet$ws$exportcsv[1], .opts = list(ssl.verifypeer = FALSE))
my_gsheet <- read.csv(text = x, stringsAsFactors = FALSE)

# split all the reponses by line breaks
make_tmp <- function(x){
  tmp <- list()
  for(i in seq_len(ncol(x))){
    tmp[[i]] <- strsplit(as.character(x[,i]), "\n")
  }
  return(tmp)
}

tmp <- make_tmp(my_gsheet)

# get criteria and scores 
library("rvest")
url <- "https://github.com/uwescience/reproducible/wiki/%5BDRAFT%5D-Open-Science-and-Reproducible-Badges"

scores <- url %>%
  html() %>%
  html_nodes(xpath = '//*[@id="wiki-body"]/div/table[1]') %>%
  html_table() %>% 
  data.frame()

# get digits from the text
scores_digits <- as.numeric(gsub("[^0-9]", "", scores[,2]))
scores_each   <- grepl("each", scores[,2])
scores$scores_digits <- scores_digits
scores$scores_each <- scores_each 
scores <- scores[!is.na(scores$scores_digits), ]

# clean up
scores <- scores[-22,]


scr_c_f <- function(person_, n){
scr_c <- 0
for(i in seq_along(person_)){
  n <- length(unlist(person_[i]))
  scr_c[i] <- unlist(ifelse(scores$scores_each[i], (n * scores[i, 3]), 
                            ifelse(n == 0, 0, scores[i, 3])))
}
return(scr_c)
}


# 
# library(shinyapps)
# deployApp()
