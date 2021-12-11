iso2c = 'BR'
commentPath <- paste0('comment/', iso2c, '.txt')
txtC <- readChar(commentPath, file.info(commentPath)$size)
txtD <- paste0('<p>', gsub("[\r\n]+", "</p><p>", txtC), '</p>')
txtE <- gsub("</p><p></p>", "</p>", txtD)
txtF <- gsub(" </p>", "</p>", txtE)

#load('data/eo.Rda') 
#load('data/imgdata.Rda') 
indicators <- read_csv("data/indicators.csv")
# description <- c(
#   'Population size in 2018, from United Nations DESA World Population Prospects 2019 Revision',
#   'Maximum sustainable population based on the country's 2018 natural resource availability and economic activity',
#   'World Bank 2020. A positive % means population is increasing; negative means population is decreasing',
#   'Estimated contraceptive use among women 15-49 years old from United Nations DESA, World Population Prospects 2019 Revision',
#   'Number of species critically endangered, endangered, and vulnerable, IUCN July 2019',
#   'A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor',
#   'Comments by Earth Overshoot'
# )
# indicators <- cbind(indicators, description)
