# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
library(dplyr)
#load('data/eo.Rda') 
startCountry <- 1 #nrow(eo) -10
endCountry <- 10 #nrow(eo)

for (k in startCountry:endCountry) {
  
  country <- eo$Country[k]
  continent <- as.character(eo %>% filter(iso3c == eo[k,'iso3c']) %>% select(Continent))
  iso2c <- eo$iso2c[k]
  iso3c <- eo$iso3c[k]
  page <- paste0('result/', iso3c, '.html')
  file.create(page)
  file.append(page, 'fragment/start.htm')
  file.append(page, 'fragment/select_by_continent.htm')
  
  out <- file(page, open='a')
  cat('<h1>Afghanistan</h1>', sep='\n', file=out)
  
  close(out)
  
  file.append(page, 'fragment/end.htm')
}
