indicators <- read_csv("data/indicators.csv")
description <- c(
  "Population total.", 
  "Estimated prevalence of contraception (modern methods) among women 15-49 years old.\nPoor 0-20%\nBelow Average 20-40%\nAverage 40-60%\nAbove Average 60-80%\nExcellent 80-100%", 
  "Number of species critically endangered, endangered, or vulnerable (IUCN Red List of Threatened Species).", 
  "Maximum sustainable population based on the country's natural resource availability, economic activity, and population in 2019.", 
  "Annual rate: a positive % means population is increasing; negative means population is decreasing.", 
  "Annual Per Capita GDP in U.S. Dollars. A high figure indicates high consumption of resources per person. A low figure indicates low consumption of resources per person.", 
  "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", 
  "Comments by Earth Overshoot"
)
# , UN World Population Prospects 2022

# description <- c(
#   "Population total in 2018, Global Footprint Network.", 
#   "Estimated prevalence of contraception (modern methods) among women 15-49 years old.\nPoor 0-20%\nBelow Average 20-40%\nAverage 40-60%\nAbove Average 60-80%\nExcellent 80-100%", 
#   "Number of species critically endangered, endangered, or vulnerable. IUCN Red List of Threatened Species.", 
#   "Maximum sustainable population based on the country's 2018 natural resource availability and economic activity.", 
#   "Annual rate: a positive % means population is increasing; negative means population is decreasing.", 
#   "Annual Per Capita GDP in U.S. Dollars. A high figure indicates high consumption of resources per person. A low figure indicates low consumption of resources per person.", 
#   "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", 
#   "Comments by Earth Overshoot"
# )
indicators$description <- description


symbol_to_HTML <- function(txt) {
  if (grepl("’", txt)) {
    txt <- gsub("’", "&rsquo;", txt)
  }
  if (grepl('“', txt)) {
    txt <- gsub("“", "&ldquo;", txt)
  }
  if (grepl('”', txt)) {
    txt <- gsub("”", "&rdquo;", txt)
  }
  if (grepl('½', txt)) {
    txt <- gsub("½", "&frac12;", txt)
  }
  if (grepl('–', txt)) {
    txt <- gsub("–", "&ndash;", txt)
  }
  if (grepl('—', txt)) {
    txt <- gsub("—", "&mdash;", txt)        
  }
  if (grepl('‘', txt)) {
    txt <- gsub("‘", "&lsquo;", txt)        
  }
  if (grepl('ô', txt)) {
    txt <- gsub("ô", "&ocirc;", txt)        
  }
  if (grepl('ê', txt)) {
    txt <- gsub("ê", "&ecirc;", txt)        
  }
  if (grepl('é', txt)) {
    txt <- gsub("é", "&eacute;", txt)        
  }
  if (grepl('è', txt)) {
    txt <- gsub("è", "&egrave;", txt)        
  }
  if (grepl('í', txt)) {
    txt <- gsub("í", "&iacute;", txt)        
  }
  if (grepl('ã', txt)) {
    txt <- gsub("ã", "&atilde;", txt)        
  }
  if (grepl('ç', txt)) {
    txt <- gsub("ç", "&ccedil;", txt)      
  }
  if (grepl('á', txt)) {
    txt <- gsub("á", "&aacute;", txt)        
  }
  if (grepl('à', txt)) {
    txt <- gsub("à", "&agrave;", txt)        
  }
  if (grepl('©', txt)) {
    txt <- gsub("©", "&copy;", txt)        
  }
  return(txt)
}

# not here, was cleaned earlier when making imgdata
# cleanCaption <- function(line) {
#   caption <- sub('#', '', line)
#   caption <- capitalize(caption)
#   # remove trailing spaces
#   caption <- trimws(caption, which = "right", whitespace = "[ \t\r\n]")
#   # add final period if missing
#   if (!str_sub(caption, -1) == '.') {
#     caption <- paste0(caption, '.')
#   }
#   return(caption)
# }
