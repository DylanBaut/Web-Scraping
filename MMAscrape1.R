
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
library(dtplyr)

#variables
event <- c()
fighterA <- c()
fighterB <- c()
a_odds <- c()
b_odds <- c()
fighterA_win <- c()
fighterB_win <- c()

fighter_page <- read_html("https://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1")
#add html for link for each of the events on page
completedLinks <- url %>% html_nodes("td td td td a") %>% html_attr("href")
#concatonate beginning url with rest of link
completedLinks <- paste0("https://www.betmma.tips/", completedLink)
#for each completed link to alternative page
for (i in 1:length(completedLinks)){
    alternativeLink <- read_html(completedLinks[i])
    
    event <- alternativeLink %>% html_nodes("td h1") %>% html_text()
    fighterA <- alternativeLink %>% html_nodes("a+ a:nth-child(4)") %>% html_text()
    fighterB <- alternativeLink %>% html_nodes("a+ a:nth-child(6)") %>% html_text()
    a_odds <- alternativeLink %>% html_nodes("td td td td tr~ tr+ tr td") %>% html_text()
    b_odds <- alternativeLink %>% html_nodes("td td td td tr~ tr+ tr td") %>% html_text()
    
    fighterA_win <- alternativeLink %>% html_nodes("") %>% html_text()
    fighterB_win <- alternativeLink %>% html_nodes("") %>% html_text()
}



