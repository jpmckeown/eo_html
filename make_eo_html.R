# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
library(tidyverse)
#load('data/eo.Rda') 
#load('data/imgdata.Rda') 
indicators <- read_csv("data/indicators.csv")

startCountry <- 1 
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
  for (i in 1:6) {
    value <- eo[k, i+2]
    value <- prettyNum(value, big.mark = ",", scientific = FALSE)
    if (i == 3 || i == 4) {
      value <- paste(value, '%')
    }
    label <- as.character(indicators[i, 1])
    longLabel <- as.character(indicators[i, 2])
    cat(paste0('    <div class="cell ', label, '"><h3>', value, '</h3>\n<h2>', longLabel, '</h2></div>'), sep='\n', file=out)
  }
  cat('  </section>', sep='\n', file=out)

  # Comment
  commentPath <- paste0('comment/', iso2c, '.txt')
  txtC <- readChar(commentPath, file.info(commentPath)$size)
  cat('  <section class="comment">', sep='', file=out)
  cat('<h4>Comment</h4>', sep='/n', file=out)
  cat(paste0('   <p>', txtC, '</p></section>'), sep='\n', file=out)
  
  # Photo carousel
  cat('  <section class="slideshow-container fade">', sep='/n', file=out)
    
  # identify number of images for each country
  numPhotos <- eo$Freq[k]
  #print(paste(k, iso2c, numPhotos, country))
  
  captions <- imgdata[imgdata$iso2c == iso2c,]$Caption
  attributions <- imgdata[imgdata$iso2c == iso2c,]$Attribution
  
  if (numPhotos>0) {
    IDs <- imgdata[imgdata$iso2c == eo$iso2c[k],]$ID
    strIDs <- toString(IDs)
    #print(paste(iso2c, numPhotos, country, strIDs))
    
    for (ph in seq_along(IDs)) {
      # filename
      img <- paste0('../photo/', eo[k,1], '_', IDs[ph], '.jpg')
      imgpath <- paste0('photo/', eo[k,1], '_', IDs[ph], '.jpg')
      #print(imgpath)
      if (!file.exists(imgpath)) {
        img <- paste0('../photo/', eo[k,1], '_', IDs[ph], '.png')
        imgpath <- paste0('photo/', eo[k,1], '_', IDs[ph], '.png')
      }

      #p <- image_read(imgpath)
      #height <- image_info(p)$height
      
      cat('<div class="Containers">', sep='/n', file=out)
      cat(paste0('<div class="caption">', captions[ph], '</div>'), sep='/n', file=out)
      cat(paste0('<img src="', img, '" style="width:100%">'), sep='/n', file=out)
      cat(paste0('<div class="attribution">', attributions[ph], '</div>'), sep='/n', file=out)
      cat('</div>', sep='/n', file=out)
      numPhotos <- 0
    } 
  } else { # if no photos available
    print(paste(iso2c, numPhotos, country))
  }

  close(out)
  file.append(page, 'fragment/end.htm')
}
