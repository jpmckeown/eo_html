# Photos: if change update Freq/Photos column in eo... from df9

# Comments: freshen from googlesheet using read_comments.R
#     folder /Comments with text files is not relevant

# Data: refresh from Country_data.xlsx using eo_data/EO_data_2023.R

# HTML country page construction
# menu is made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.

library(tidyverse)
library(stringi)

source("helper.R")
source("extra.R") # for indicators

# eo_2022 <- eo
eo_import <- readRDS('../eo_data/data/eo_2023_oldGrade.rds')
eo_comment <- readRDS('data/eo_comment_Nov2022.rds')
df9 <- readRDS('data/df9.rds')

# rename columns generically, with a year
eo <- eo_import %>% 
  rename("Grade" = "Rank_sustain_2020") %>%
  rename("Pop_Grow_Rate" = "PopGrowRate_UN_2021") %>% 
  rename("Max_Population" = "Sustainable_pop") %>% 
  rename("Population" = "Population_UN_2021") %>% 
  rename("Contraception" = "Contraception") %>% 
  rename("GDP_pp" = "GDP") %>% 
  rename("Species" = "Species_2022_2") %>% 
  select("iso3c", "Country", "Max_Population", "Pop_Grow_Rate", "Population", "Contraception", "Species", "GDP_pp", "iso2c", "Continent")

startCountry <- 1 
endCountry <- nrow(eo)

for (k in startCountry:endCountry) {
  
  country <- eo$Country[k]
  continent <- eo$Continent[k]
  # continent <- as.character(eo %>% filter(iso3c == eo[k,'iso3c']) %>% select(Continent))
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
  print(country)
  cat(paste0('<h1>', country, '</h1></section>\n'), sep='\n', file=out)
  
  # Flag
  cat('<section class="flag">', sep='', file=out)
  cat(paste0('<img src="../flag/', lowiso2c, '.svg" height="120">'), sep='\n', file=out)
  
  rank <- eo[k, "Grade"]
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
      if (f == 'Pop_Grow_Rate') {
        value = format(round(value, 2), nsmall = 2)
        value <- paste(as.character(value), '%')
      } 
      else if (f == 'Contraception') {        
        value = format(round(value, 1), nsmall = 1)
        value <- paste(as.character(value), '%')
      } 
      else if (f == 'GDP_pp') {        
        value = format(round(value, 0), nsmall = 0)
        value <- paste('$', as.character(value))
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      }
      else if (f == 'Population') {        
        value = format(round(value, 0), nsmall = 0)
        value <- prettyNum(value, big.mark = ",", scientific = FALSE)
      } 
      else if (f == 'Max_Population') {        
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
#print(paste(codeLabel, longLabel, popup))

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
    #print(paste(iso3c, numPhotos, country, strIDs))
    
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
      # print(paste(ph, caption))
      
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

#saveRDS(df9, 'data/df9.rds')