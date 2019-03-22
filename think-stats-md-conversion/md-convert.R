library(here)
library(glue)
library(rmarkdown)

# Get list of files but remove scrape.R
files <- list.files(here("think-stats-scrape/"))[-1]

# Use pandoc convert to generate md file
convert_html <- function(filename) {
  pandoc_convert(glue(here("think-stats-scrape/{filename}")), 
                 to = "markdown_strict", 
                 output = glue(here("think-stats-md-conversion/{filename}.md")))
}

# Pass vector of files to convert_html
lapply(files, convert_html)
