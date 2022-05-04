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

# saveRDS(eo, 'data/eo_before25April2022.rds')
eo <- readRDS('../eo_data/data/eop_26April2022.rds')
eo_comment <- readRDS('data/eo_comment_Feb2022.rds')

indicators <- read_csv("data/indicators.csv")
description <- c(
  "Population total in 2018, Global Footprint Network.", 
  "Estimated prevalence of contraception (modern methods) among women 15-49 years old.\nPoor 0-20%\nBelow Average 20-40%\nAverage 40-60%\nAbove Average 60-80%\nExcellent 80-100%", 
  "Number of species critically endangered, endangered, or vulnerable. IUCN Red List of Threatened Species.", 
  "Maximum sustainable population based on the country's 2018 natural resource availability and economic activity.", 
  "Annual rate: a positive % means population is increasing; negative means population is decreasing.", 
  "Annual Per Capita GDP in U.S. Dollars. A high figure indicates high consumption of resources per person. A low figure indicates low consumption of resources per person.", 
  "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", 
  "Comments by Earth Overshoot"
)
indicators$description <- description

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
  cat(paste0('<img src="../flag/', lowiso2c, '.svg" height="120">'), sep='\n', file=out)
  
  rank <- eo[k, 'Rank_sustain_2020']
  cat(paste0('<div class="rating-', rank, '">'), sep='\n', file=out)
  cat(paste0('<h3>', rank, '</h3>'), sep='\n', file=out)
  cat('<div data-tooltip data-tooltip-label="A = Excellent', sep='\n', file=out)
  cat('B = Above Average', sep='\n', file=out)
  cat('C = Average', sep='\n', file=out)
  cat('D = Below Average', sep='\n', file=out)
  cat('F = Poor">', sep='\n', file=out)
  cat('<h2>Sustainability Grade</h2>', sep='\n', file=out)
  cat('<i class="fas fa-plus-circle"></i></div> <!-- end hover div -->', sep='\n', file=out)
  cat('</div></section>\n', sep='\n', file=out)
  
  # Data grid
  cat('<!-- data items are 1 row of FlexBox -->\n', sep='\n', file=out)
  cat('<section class="grid">', sep='\n', file=out)
  
  #fields <- indicators$name[1:6]
  #seq_data <- c(1,5,3,4,2,6)
  seq_data <- c(1,4,2,3,5,6)
  for (i in seq_data) {
    #print(eo[k, f])
    f <- indicators$name[i]
    
    value <- eo[k, f]
    if (is.na(value)) {
      value <- 'N/A'
    } else {
      if (f == 'Growth_rate_pop_2020') {
        value = format(round(value, 2), nsmall = 2)
        value <- paste(as.character(value), '%')
      } 
      else if (f == 'Modern_contraception_2020') {        
        value = format(round(value, 1), nsmall = 1)
        value <- paste(as.character(value), '%')
      } 
      else if (f == 'GDP_pp_2020') {        
        value = format(round(value, 0), nsmall = 0)
        value <- paste('$', as.character(value))
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      }
      else if (f == 'Population_2018') {        
        value = format(round(value, 0), nsmall = 0)
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      } 
      else if (f == 'SustainPop_2018') {        
        value = format(round(value, 0), nsmall = 0)
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      } 
      else {
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      }
    }

    codeLabel <- f #as.character(indicators[f, 1])
    longLabel <- as.character(indicators[i, 2])
    popup <-  as.character(indicators[i, 3])
print(paste(codeLabel, longLabel, popup))

    cat(paste0('<div class="cell ', codeLabel, '">'), sep='\n', file=out)
    cat(paste0('  <h3>', value, '</h3>'), sep='\n', file=out)
 
    cat(paste0('<div data-tooltip data-tooltip-label="', popup, '">'),  sep='\n', file=out)
    cat(paste0('<h2>', longLabel, '</h2><i class="fas fa-plus-circle"></i></div>'), sep='\n', file=out)

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
  cat('<h4>Country Comments</h4>', sep='\n', file=out)
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
    cat('<h4>Photo Gallery</h4>', sep='\n', file=out)
    
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

#saveRDS(df9, 'data/df9.rds')

#saveRDS(df9, 'data/df9.rds')
#saveRDS(eo, '../eo_data/data/eo_Jan2022.rds')
#saveRDS(eo_comment, 'data/eoComment.rds')
#df9 <- readRDS('../eo_photo/data/df8.rds')