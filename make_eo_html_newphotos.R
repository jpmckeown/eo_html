# need make new eo with updated Freq column, from df9
# freshen Comments from googlesheet works with read_comments.R
# must run extra.R (for indicators)

# folder Comments with text files exists, but not relevant

# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
library(tidyverse)
library(stringi)

df9 <- readRDS('../eo_photo/data/df8.rds')
eo <- readRDS('../eo_data/data/eo_new.rds')
eo_comment <- readRDS('data/eo_comment.rds')

indicators <- read_csv("data/indicators.csv")
description <- c(
  "Population in 2017, Global Footprint Network.", 
  "Maximum sustainable population based on the country's 2017 natural resource availability and economic activity.", 
  "A positive % means population is increasing; negative means population is decreasing.", 
  "Estimated modern contraceptive use among women 15-49 years old.\nPoor 0-20%\nBelow Average 20-40%\nAverage 40-60%\nAbove Average 60-80%\nExcellent 80-100%", 
  "Number of species critically endangered, endangered, or vulnerable. IUCN Red List of Threatened Species.", 
  "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", 
  "Comments by Earth Overshoot"
)
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
  cat('<section class="country">', sep='', file=out)
  country <- symbol_to_HTML(country)
  cat(paste0('<h1>', country, '</h1></section>\n'), sep='\n', file=out)
  
  # Flag
  cat('<section class="flag">', sep='', file=out)
  cat(paste0('<img src="../flag/', lowiso2c, '.svg" height="120"></section>\n'), sep='\n', file=out)
  
  # Data grid
  cat('<section class="grid">  <!-- data items are 1 row of FlexBox -->\n', sep='\n', file=out)
  
  fields <- indicators$name[1:6]
  for (i in fields) { 
    if (i == 6 && is.na(eo[k, i+3])) {
      value <- 'N/A'
    } else {
      value <- eo[k, i+3]
      if(is.na(value)) {
        value <- 'N/A'
      } else {

        if (i == 3 || i == 4) {
          if (i==3) {
            value = format(round(value, 3), nsmall = 2)
          }
          if (i==4) {
            value = format(round(value, 1), nsmall = 1)
          }
          value <- paste(as.character(value), '%')
        } else {
          value <- prettyNum(value, big.mark = ",", scientific = FALSE)
        }           
      }
    }

    codeLabel <- as.character(indicators[i, 1])
    longLabel <- as.character(indicators[i, 2])
    popup <-  as.character(indicators[i, 3])

    cat(paste0('<div class="cell ', codeLabel, '">'), sep='\n', file=out)
    cat(paste0('  <h3>', value, '</h3>'), sep='\n', file=out)
 
    cat(paste0('<div data-tooltip data-tooltip-label="', popup, '"><h2<a id="', codeLabel, '_" href="#">', longLabel, '</a></h2><span class="icon" id="', codeLabel, '"><i class="fas fa-plus-circle"></i></h2></div>'), sep='\n', file=out)

    cat('</div>  <!-- cell ends -->\n', sep='\n', file=out)
    
  } # end of 6 data items 
  
  cat('</section> <!-- grid for data ends -->\n', sep='\n', file=out)

  # Comment
 
  # not using stored Comment, now fresh via readcomment.r
  # commentPath <- paste0('comment/', iso2c, '.txt')
  # txtC <- readChar(commentPath, file.info(commentPath)$size)
  txtC <- as.character(eo_comment[eo_comment$iso2c == iso2c, "Comments"])
  txtC <- stri_encode(txtC, '', 'UTF-8')
  txtC <- symbol_to_HTML(txtC)

  # blank lines turn into paragraphs
  txtD <- gsub("[\r\n]+", "</p><p>", txtC)
  
  # first paragraph
  txtD <- gsub("^</p><p>", "", txtD)
  txtD <- paste0('<p>', txtD)
  
  # remove <p> after final </p>
  txtD <- gsub("<p>$", "", txtD)
  
  # stray space at end of paragraph, delete
  txtD <- gsub(" </p>", "</p>", txtD)
  
  # newline between paragraph tags
  txtD <- gsub("</p><p>", "</p>\n<p>", txtD)
  
  # txtD <- gsub("[<p>]{2,}", "<p>", txtD) # likely redundant

  cat('<section class="comment">', sep='\n', file=out)
  cat('<h4>Comments on country</h4>', sep='\n', file=out)
  cat(paste0(txtD, '\n</section> <!-- Comment ends -->\n'), sep='\n', file=out)
  
  # Photo gallery: title, caption, and carousel
  # identify number of images for each country
  numPhotos <- eo$Freq[k]
 
  if (numPhotos>0) {
    captions <- df9[df9$iso3c == iso3c,]$Caption
    attributions <- df9[df9$iso3c == iso3c,]$CreditHTML
    
    IDs <- df9[df9$iso3c == eo$iso3c[k],]$ID
    strIDs <- toString(IDs)
    print(paste(iso3c, numPhotos, country, strIDs))
    
    cat('<section class="gallery">', sep='\n', file=out)
    cat(paste0('<h4>Photo gallery for ', country, '</h4>'), sep='\n', file=out)
    
    cat('<div class="slideshow-container fade">\n', sep='\n', file=out)
  
    for (ph in seq_along(IDs)) {

      # when format unknown, get extension experimentally
      # harmonised now, lowercase
      # scropt runs in cwd above country/ folder
      
      imgFromScript <- paste0('w640/', eo[k, 'iso3c'], '_', IDs[ph], '.jpg')
      imgFromHTML <- paste0('../w640/', eo[k, 'iso3c'], '_', IDs[ph], '.jpg')

      if (!file.exists(imgFromScript)) {
        imgFromScript <- paste0('w640/', eo[k, 'iso3c'], '_', IDs[ph], '.png')
        imgFromHTML <- paste0('../w640/', eo[k, 'iso3c'], '_', IDs[ph], '.png')
      }
      if (!file.exists(imgFromScript)) {
        imgFromHTML <- paste0('../w640/', eo[k, 'iso3c'], '_', IDs[ph], '.svg')
      }

      # fix caption encoding
      caption <- stri_encode(captions[ph], '', 'UTF-8')
      caption <- symbol_to_HTML(caption)
      print(paste(ph, caption))
      
      # cat('<div class="photo-container">', sep='\n', file=out)
      cat('<div class="Containers">', sep='\n', file=out)
      cat(paste0('<div class="caption">', caption, '</div>'), sep='\n', file=out)
      cat(paste0('<img src="', imgFromHTML, '">'), sep='\n', file=out)
      attribution <- symbol_to_HTML(attributions[ph])
      cat(paste0('<div class="attribution">', attribution, '</div>'), sep='\n', file=out)
      cat('</div> <!-- photo -->\n', sep='\n', file=out)
    }
    
    if(numPhotos > 1) {
      cat('<a class="Back" onclick="plusSlides(-1)">&#10094;</a>', sep='\n', file=out)
      cat('<a class="forward" onclick="plusSlides(1)">&#10095;</a>', sep='\n', file=out)
    }
    cat('<div style="text-align:center">', sep='\n', file=out)
    for (ph in seq_along(IDs)) {
      cat(paste0('  <span class="dots" onclick="currentSlide(', ph, ')"></span>'), sep='\n', file=out)
    }
    cat('</div> <!-- dots -->\n', sep='\n', file=out)
    cat('</div> <!-- slide-show -->', sep='\n', file=out)
    cat('</section>', sep='\n', file=out)
    numPhotos <- 0
    
  } else { # if no photos available
    #print(paste('ZERO', iso2c, numPhotos, country))
  }

  close(out)
  file.append(page, 'fragment/end.htm')
}

saveRDS(df9, 'data/df9.rds')
