
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
winning_fighter<-c()

fighter_page <- read_html("https://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1")
#add html for link for each of the events on page
completedLinks <- url %>% html_nodes("td td td td a") %>% html_attr("href")
#concatonate beginning url with rest of link
completedLinks <- paste0("https://www.betmma.tips/", completedLink)
#for each completed link to alternative page
for (i in 1:length(completedLinks)){
    alternativeLink <- read_html(completedLinks[i])
    
   
    fighterA_0 <- alternativeLink %>% html_nodes("a+ a:nth-child(4)") %>% html_text()
    #removes from fighterA_0 any instances of MMA
    fighterA_0 <- fighterA_0[-grep("MMA", fighterA_0)]
    fighterA_0 <- fighterA_0[-grep("Betting", fighterA_0)]
    fighterA_0 <- fighterA_0[-grep("Past", fighterA_0)]
    fighterA <- c(fighterA, fighterA_0)



    fighterB_0 <- alternativeLink %>% html_nodes("a+ a:nth-child(6)") %>% html_text()
    fighterB_0 <- fighterB_0[-grep("MMA", fighterB_0)]
    fighterB_0 <- fighterB_0[-grep("Betting", fighterB_0)]
    fighterB_0 <- fighterB_0[-grep("Past", fighterB_0)]
    fighterB <- c(fighterB, fighterB_0)

    odds_0 <- alternativeLink %>% html_nodes("td td td td tr~ tr+ tr td") %>% html_text()
    odds_1 <- gsub("@", "", trimws(odds_0))
    #create filter to only allow odd values in
    a_odds_0 <- odds_1[c(TRUE, FALSE)]
    a_odds <- c(a_odds, a_odds_0)

    #create filter to only allow even values in
    b_odds_0 <- odds_1[c(FALSE, TRUE)]
    b_odds <- c(b_odds, b_odds_0)

    event_0 <- alternativeLink %>% html_nodes("td h1") %>% html_text()
    #extend the event column to match the entirety of the roster for this event
    event <- c(event, replicate(length(fighterA),event))

    winning_fighter_0<-alternativeLink %>% html_nodes("td td td td br+ a") %>% html_text()
    winning_fighter<-c(winning_fighter, winning_fighter_0)
    
    if(winning_fighter_0==fighterA_0){
        fighterA_win <- c(fighterA_win, TRUE)
    }else{
        fighterB_win <- c(fighterB_win, TRUE)
    }
}
a<-data.frame(Events=event, FighterA= fighterA)
write.csv(a, "MMAscrape1.csv", row.names=FALSE)
write.csv(fighterB, "MMAscrape2.csv", row.names=FALSE)
write.csv(winning_fighter, "MMAscrape3.csv", row.names=FALSE)
write.csv(data.frame(fighterA_win, fighterB_win), "MMAscrape4.csv", row.names=FALSE)
write.csv(data.frame(a_odds, b_odds), "MMAscrape5.csv", row.names=FALSE)


