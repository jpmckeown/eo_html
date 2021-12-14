iso2c = 'BR'
commentPath <- paste0('comment/', iso2c, '.txt')
txtC <- readChar(commentPath, file.info(commentPath)$size)
txtD <- paste0('<p>', gsub("[\r\n]+", "</p><p>", txtC), '</p>')
txtE <- gsub("</p><p></p>", "</p>", txtD)
txtF <- gsub(" </p>", "</p>", txtE)

#load('data/eo.Rda') 
#load('data/imgdata.Rda') 
indicators <- read_csv("data/indicators.csv")
description <- c("Population size in 2018, from United Nations DESA World Population Prospects 2019 Revision.", "Maximum sustainable population based on the country's 2018 natural resource availability and economic activity.", "A positive % means population is increasing; negative means population is decreasing. World Bank Development Indicators SP.POP.GROW. Accessed 7 Sept 2021", "Estimated contraceptive use (Modern methods) among women 15-49 years old. World Bank Development Indicators SP.DYN.CONM.ZS Accessed 7 Sept 2021", "Number of species critically endangered, endangered, or vulnerable. IUCN (2021). The IUCN Red List of Threatened Species. Version 2021-2. https://www.iucnredlist.org. Accessed on 5 Sept 2021.", "A = Excellent\nB = Above Average\nC = Average\nD = Below Average\nF = Poor", "Comments by Earth Overshoot")
# indicators <- cbind(indicators, description)
indicators$description <- description
