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
  page <- paste0('country/', iso3c, '.html')
  file.create(page)
  file.append(page, 'fragment/start.htm')
  file.append(page, 'fragment/select_by_continent.htm')
  
  out <- file(page, open='a')
  
  # Country name
  cat('  <section class="country">', sep='', file=out)
  cat(paste0('<h1>', country, '</h1></section>'), sep='\n', file=out)
  
  # Flag
  cat('  <section class="flag">', sep='', file=out)
  cat(paste0('<img src="../flag/', iso2c, '.svg" height="120"></section>'), sep='\n', file=out)
  
  # Data grid
  cat('  <section class="grid">', sep='\n', file=out)
  cat('    <div class="cell a">Cell A</div>', sep='\n', file=out)
  cat('    <div class="cell a">Cell A</div>', sep='\n', file=out)
  cat('    <div class="cell a">Cell A</div>', sep='\n', file=out)
  cat('    <div class="cell a">Cell A</div>', sep='\n', file=out)
  cat('    <div class="cell a">Cell A</div>', sep='\n', file=out)
  cat('    <div class="cell a">Cell F</div>', sep='\n', file=out)
  cat('  </section>', sep='\n', file=out)

  # Comment
  commentPath <- paste0('comment/', iso2c, '.txt')
  txtC <- readChar(commentPath, file.info(commentPath)$size)
  cat('  <section class="comment">', sep='', file=out)
  cat('<h4>Comment</h4>', sep='/n', file=out)
  cat(paste0('   <p>', txtC, '</p></section>'), sep='\n', file=out)
  
  # Photo carousel
  
  
  close(out)
  file.append(page, 'fragment/end.htm')
}
