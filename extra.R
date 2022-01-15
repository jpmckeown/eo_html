# iso2c = 'BR'
# commentPath <- paste0('comment/', iso2c, '.txt')
# txtC <- readChar(commentPath, file.info(commentPath)$size)
# txtD <- paste0('<p>', gsub("[\r\n]+", "</p><p>", txtC), '</p>')
# txtE <- gsub("</p><p></p>", "</p>", txtD)
# txtF <- gsub(" </p>", "</p>", txtE)

#load('data/eo.Rda') 
#load('data/imgdata.Rda') 
indicators <- read_csv("data/indicators.csv")
description <- c(
  "Population in 2017, Global Footprint Network.", 
  "Estimated modern contraceptive use among women 15-49 years old.\nPoor 0-20%\nBelow Average 20-40%\nAverage 40-60%\nAbove Average 60-80%\nExcellent 80-100%", 
  "Number of species critically endangered, endangered, or vulnerable. IUCN Red List of Threatened Species.", 
  "Maximum sustainable population based on the country's 2017 natural resource availability and economic activity.", 
  "A positive % means population is increasing; negative means population is decreasing.", 
  "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", 
  "Comments by Earth Overshoot"
)
# indicators <- cbind(indicators, description)
indicators$description <- description

setwd('w640/')
ff <- list.files(pattern='*.jpeg')
# ff <- list.files(path='w640/', pattern='*.jpeg')
nf <- gsub('.jpeg$', '.jpg', ff)
file.rename(ff, nf)

ff <- list.files(pattern='*.JPG')
nf <- gsub('.JPG$', '.jpg', ff)
file.rename(ff, nf)

ff <- list.files(pattern='*.JPEG')
nf <- gsub('.JPEG$', '.jpg', ff)
file.rename(ff, nf)

ff <- list.files(pattern='*.PNG')

ff <- list.files(pattern='*.SVG')

extraphotos <-  slice(df9, n=3)
extraphotos[2, 'ID'] <- 3
extraphotos[2, 'Caption'] <- 'While the Nigerian Government provides contraceptives and other family planning commodities at no cost, state governments are responsible for getting the products to the clinics, pharmacies and other health facilities where women can access them.'
extraphotos[2, 'folder'] <- 'b/bb/'
extraphotos[2, 'FileURL'] <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Family_Planning_Talk_at_Umunogodo_Community.jpg/640px-Family_Planning_Talk_at_Umunogodo_Community.jpg'
extraphotos[2, 'InfoURL'] <- 'https://commons.wikimedia.org/wiki/File:Family_Planning_Talk_at_Umunogodo_Community.jpg'
extraphotos[2, 'Artist'] <- 'Lovecharles2004'
extraphotos[2, 'ArtistHTML'] <- NA
