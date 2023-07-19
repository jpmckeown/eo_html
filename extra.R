# iso2c = 'BR'
# commentPath <- paste0('comment/', iso2c, '.txt')
# txtC <- readChar(commentPath, file.info(commentPath)$size)
# txtD <- paste0('<p>', gsub("[\r\n]+", "</p><p>", txtC), '</p>')
# txtE <- gsub("</p><p></p>", "</p>", txtD)
# txtF <- gsub(" </p>", "</p>", txtE)

#load('data/imgdata.Rda') 

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

xtra=c(144,396,448)
xph <-  slice(df9, xtra)

# xph[1, 'ID'] <- 3
# xph[1, 'Caption'] <- 'Adolescent fertility in Curacao continues to decrease and life expectancy continues to rise.'
# xph[1, 'folder'] <- '3/3d/'
# xph[1, 'FileURL'] <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Curacao_02_110_%2814180520624%29.jpg/640pxxph_110_%2814180520624%29.jpg'
# xph[1, 'InfoURL'] <- 'https://commons.wikimedia.org/wiki/File:Curacao_02_110_(14180520624).jpg'
# xph[1, 'Artist'] <- 'Roel van Deursen - Spijkenisse / Nissewaard - Nederland'
# xph[1, 'ArtistExtra'] <- 'from Spijkenisse - Nissewaard, Holland'
# xph[1, 'ArtistHTML'] <- NA
# xph[1, 'License'] <- 'CC BY 2.0'
# xph[1, 'LicenseURL'] <- 'https://creativecommons.org/licenses/by/2.0'
  
# xph[2, 'ID'] <- 3
# xph[2, 'Caption'] <- 'While the Nigerian Government provides contraceptives and other family planning commodities at no cost, xphnments are responsible for getting the products to the clinics, pharmacies and other health facilities where women can xph.'
# xph[2, 'folder'] <- 'b/bb/'
# xph[2, 'FileURL'] <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Family_Planning_Talk_at_Umunogodo_Community.jpgxphly_Planning_Talk_at_Umunogodo_Community.jpg'
# xph[2, 'InfoURL'] <- 'https://commons.wikimedia.org/wiki/File:Family_Planning_Talk_at_Umunogodo_Community.jpg'
# xph[2, 'Artist'] <- 'Lovecharles2004'
# xph[2, 'ArtistExtra'] <- NA

# xph[3, 'ID'] <- 3
# xph[3, 'Caption'] <- 'Rwanda is 50% Catholic and their health centers are many citizens only health care option.'
# xph[3, 'folder'] <- '5/5e/'
# xph[3, 'FileURL'] <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Catholic_Cathedral_of_Butare.jpg/640pxxpha3hedral_of_Butare.jpg'
# xph[3, 'InfoURL'] <- 'https://commons.wikimedia.org/wiki/File:Catholic_Cathedral_of_Butare.jpg'
# xph[3, 'Artist'] <- 'Claude Nizeyimana'
# xph[3, 'ArtistExtra'] <- NA
# xph[3, 'ArtistHTML'] <- NA
# xph[3, 'License'] <- 'CC BY-SA 4.0'
# xph[3, 'LicenseURL'] <- 'https://creativecommons.org/licenses/by-sa/4.0'

df9backup <- df9
df9 <- rbind(df9, xph)
df9 <- df9 %>% 
  arrange(Country, ID)

# Curacao 3rd photo
df9$CreditHTML[145] <- "<a href=\"https://www.flickr.com/people/24352666@N05\">Roel van Deursen - Spijkenisse / Nissewaard - Nederland</a>; License <a href=\"https://creativecommons.org/licenses/by/2.0\">CC BY 2.0</a>; Image <a href=\"https://commons.wikimedia.org/wiki/File:Curacao_02_110_(14180520624).jpg\">https://commons.wikimedia.org/wiki/File:Curacao_02_110_(14180520624).jpg</a> via Wikimedia Commons."

# Nigeria 3rd photo
df9$CreditHTML[398] <- "Lovecharles2004; License <a href=\"https://creativecommons.org/licenses/by-sa/4.0\">CC BY-SA 4.0</a>; Image <a href=\"https://commons.wikimedia.org/wiki/File:Family_Planning_Talk_at_Umunogodo_Community.jpg\">https://commons.wikimedia.org/wiki/File:Family_Planning_Talk_at_Umunogodo_Community.jpg</a> via Wikimedia Commons."

df9$CreditHTML[451] <- "<a href=\"https://commons.wikimedia.org/wiki/User:Claude_Nizeyimana\">Claude Nizeyimana</a>; License <a href=\"https://creativecommons.org/licenses/by-sa/4.0\">CC BY-SA 4.0</a>; Image <a href=\"https://commons.wikimedia.org/wiki/File:Catholic_Cathedral_of_Butare.jpg\">https://commons.wikimedia.org/wiki/File:Catholic_Cathedral_of_Butare.jpg</a> via Wikimedia Commons."

saveRDS(df9, "data/df9_July2023.rds")

pixbay <- readRDS('../eo_photo/data/df8_PixabayFixed.rds')
pix=which(pixbay$Provider=='Pixabay')
