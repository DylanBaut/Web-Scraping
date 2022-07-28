library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
library(dtplyr)


fighter_page <- read_html("https://www.https://www.sherdog.com/fighter/Khabib-Nurmagomedov-56035")

fighter_page %>%
  # use CSS selector to extract relevant entries from html
  html_nodes(".nickname em , .fn") %>%
  # turn the html output into simple text fields
  html_text
  
# Using our same fight page from before
fighter_table <- fighter_page %>%
  # extract fight history
  html_nodes("section:nth-child(4) td") %>%
  # not a well-behaved table so it is extracted as strings
  html_text() %>%
  # wrap text to reform table
  matrix(ncol = 6, byrow = T)

# Add column names from first entries of table
colnames(fighter_table) <- fighter_table[1,]
fighter_table <- fighter_table[-1,, drop = F]

fighter_table <- fighter_table %>%
  as.data.frame(stringsAsFactors = F) %>% tbl_df() %>%
  # reorder
  select(Result, Fighter, `Method/Referee`, R, Time, Event)

kable(head(fighter_table, 10), row.names = F)

fighter_links <- fighter_page %>%
  html_nodes("td:nth-child(2) a") %>%
  html_attr("href")

fighter_links[1:5]

library(ggplot2)

# bouts is a cleaned-up summary of this dataset (I will discuss its generation later on)
fight_counts <- bouts %>%
  # count the number of each fighter's bouts
  count(Fighter_link) %>%
  rename(nfights = n) %>%
  count(nfights)
  
# ggplot2 plotting theme
hist_theme <- theme(axis.title = element_text(color = "black", size = 25),
                    panel.background = element_rect(fill = "gray93"),
                    panel.border = element_rect(fill = NA, color = "black"),
                    panel.grid.minor = element_blank(),
                    panel.grid.major.x = element_blank(),
                    panel.grid.major.y = element_line(color = "gray70", size = 1),
                    axis.text = element_text(size = 18, hjust = 0.5, vjust = 0.5),
                    axis.ticks = element_line(size = 1),
                    axis.ticks.length = unit(0.15, "cm"))

no_sci_conv <- function(x){format(x, scientific=FALSE)}

ggplot(fight_counts, aes(x = nfights, y = n)) +
  geom_point(color = "firebrick", size = 2) +
  scale_y_continuous("Number of fighters", trans = "log10", breaks = 10^c(0:5), labels = no_sci_conv) +
  scale_x_continuous("Number of fights", trans = "log10", breaks = c(1, 3, 10, 30, 100)) +
  hist_theme