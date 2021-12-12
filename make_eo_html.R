# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
library(tidyverse)
library(stringi)

startCountry <- 1 
endCountry <- nrow(eo)

for (k in startCountry:endCountry) {
  
  country <- eo$Country[k]
  continent <- as.character(eo %>% filter(iso3c == eo[k,'iso3c']) %>% select(Continent))
  iso2c <- eo$iso2c[k]
  iso3c <- eo$iso3c[k]
  lowiso2c <- tolower(iso2c)
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
  cat(paste0('<img src="../flag/', lowiso2c, '.svg" height="120"></section>'), sep='\n', file=out)
  
  # Data grid
  cat('  <section class="grid">', sep='\n', file=out)
  for (i in 1:6) {
    if (i == 6 && is.na(eo[k, i+2])) {
      value <- 'N/A'
    } else {
      value <- eo[k, i+2]
      value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      if (i == 3 || i == 4) {
        value <- paste(value, '%')
      }      
    }

    codeLabel <- as.character(indicators[i, 1])
    longLabel <- as.character(indicators[i, 2])
    popup <-  as.character(indicators[i, 3])

    cat(paste0('    <div class="cell ', codeLabel, '"><h3>', value, '</h3>'), sep='\n', file=out)
    cat(paste0('<h2><a id="', codeLabel, '_" href="#" data-tooltip data-tooltip-label="', popup, '">', longLabel, '</a></h2>'), sep='\n', file=out)
    cat(paste0('<div class="icon" id="', codeLabel, '"><i class="fas fa-plus-circle"></i></div></div>'), sep='\n', file=out)
  }
  cat('  </section>', sep='\n', file=out)

  # Comment
  commentPath <- paste0('comment/', iso2c, '.txt')
  txtC <- readChar(commentPath, file.info(commentPath)$size)
  txtC <- stri_encode(txtC, '', 'UTF-8')
  txtD <- paste0('<p>', gsub("[\r\n]+", "</p><p>", txtC), '</p>')
  txtE <- gsub("</p><p></p>", "</p>", txtD)
  txtF <- gsub(" </p>", "</p>", txtE)

  cat('  <section class="comment">', sep='', file=out)
  cat('<h4>Comments on country</h4>', sep='\n', file=out)
  cat(paste0('   <p>', txtF, '</p></section>'), sep='\n', file=out)
  
  # Photo gallery: title, caption, and carousel
  # identify number of images for each country
  numPhotos <- eo$Freq[k]

  if (numPhotos>0) {
    captions <- imgdata[imgdata$iso2c == iso2c,]$Caption
    attributions <- imgdata[imgdata$iso2c == iso2c,]$Attribution
    
    IDs <- imgdata[imgdata$iso2c == eo$iso2c[k],]$ID
    strIDs <- toString(IDs)
    print(paste(iso2c, numPhotos, country, strIDs))
    
    cat('<section class="gallery">', sep='\n', file=out)
    cat(paste0('  <h4>Photo gallery for ', country, '</h4>'), sep='\n', file=out)
    
    cat('  <div class="slideshow-container fade">', sep='\n', file=out)
  
    for (ph in seq_along(IDs)) {
      # filename
      img <- paste0('../photo/', eo[k,1], '_', IDs[ph], '.jpg')
      imgpath <- paste0('photo/', eo[k,1], '_', IDs[ph], '.jpg')
      #print(imgpath)
      if (!file.exists(imgpath)) {
        img <- paste0('../photo/', eo[k,1], '_', IDs[ph], '.png')
        imgpath <- paste0('photo/', eo[k,1], '_', IDs[ph], '.png')
      }
      if (!file.exists(imgpath)) {
        img <- paste0('../photo/', eo[k,1], '_', IDs[ph], '.svg')
      }

      # fix caption encoding
      caption <- stri_encode(captions[ph], '', 'UTF-8')
      
      cat('<div class="Containers">', sep='\n', file=out)
      cat(paste0('<div class="caption">', caption, '</div>'), sep='\n', file=out)
      cat(paste0('<img src="', img, '" style="width:100%">'), sep='\n', file=out)
      cat(paste0('<div class="attribution">', attributions[ph], '</div>'), sep='\n', file=out)
      cat('</div>', sep='\n', file=out)
    }
    
    if(numPhotos > 1) {
      cat('<a class="Back" onclick="plusSlides(-1)">&#10094;</a>', sep='\n', file=out)
      cat('<a class="forward" onclick="plusSlides(1)">&#10095;</a>', sep='\n', file=out)
    }
    cat('<div style="text-align:center">', sep='\n', file=out)
    for (ph in seq_along(IDs)) {
      cat(paste0('<span class="dots" onclick="currentSlide(', ph, ')"></span>'), sep='\n', file=out)
    }
    cat('</div></div>', sep='\n', file=out)
    cat('</section>', sep='\n', file=out)
    numPhotos <- 0
    
  } else { # if no photos available
    print(paste('ZERO', iso2c, numPhotos, country))
  }

  close(out)
  file.append(page, 'fragment/end.htm')
}
