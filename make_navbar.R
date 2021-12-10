# make nav Continents dropdown as fragment htm
library(tidyverse)
library(textutils)

# temporary, get EO data from previously assembled dataframe
# load(file='data/eo.Rda')

frag <- 'select_by_continent.htm'
file.create(frag)
out <- file(frag, open='a')

cat('<nav class="continent">', sep='\n', file=out)

continents <- c('Africa', 'Americas', 'Asia', 'Europe', 'Oceania') 

for (c in seq_along(continents)) {
  # begin dropdown for a Continent
  cat(paste0(spaces(2), '<div class="dropdown">'), sep='\n', file=out)
  cat(paste0(spaces(4), '<button class="dropbtn">', continents[c], '</button>'), sep='\n', file=out)
  # cat(paste0(spaces(4), '</button>'), sep='\n', file=out)
  cat(paste0(spaces(4), '<div class="dropdown-content">'), sep='\n', file=out)
  
  # loop Countries in that continent
  thisContinent <- eo %>% 
    filter(Continent == continents[c]) %>% 
    select(iso3c, Country) %>% 
    arrange(Country)  # just in case not already ordered by Country name
  
  for (k in 1:nrow(thisContinent)) {
    iso3c <- thisContinent$iso3c[k]
    Country <- thisContinent$Country[k] 
    cat(paste0(spaces(6), "<a href='", iso3c, ".html'>", Country, "</a>"), sep='\n', file=out)
  }
  
  cat(paste0(spaces(4), '</div>'), sep='\n', file=out)  # dropdown-content
  cat(paste0(spaces(2), '</div>'), sep='\n', file=out)  # dropdown
}
cat('</nav>', sep='\n', file=out)  
close(out)