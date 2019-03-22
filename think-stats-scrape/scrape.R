# Grab all the pages (specifically the second tr tag since that's where the content is) 
# from the thinkstats url
library(rvest)
library(stringr)

# The url is thankfully simple, so we'll take the base url and
# create a list of 16 chapters and then recreate the urls.
base_url <- "http://greenteapress.com/thinkstats2/html/thinkstats20"
chapters <- paste(formatC(seq(1, 16, 1), width=2, flag="0"))
urls <- str_c(base_url, chapters, ".html")

# Simple function to go to the given url, extract the 2nd td, and write out
extract_chapter <- function(url) {
  read_html(url) %>%
    html_node("td:nth-child(2)") %>%
    write_html(paste("think-stats-scrape/", tail(strsplit(url,split="/")[[1]],1), sep = ""))
}

# Go through each url in urls and apply our function to get the html
lapply(urls, extract_chapter)
