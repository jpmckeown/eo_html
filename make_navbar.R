# make nav Continents dropdown as fragment htm
# library(tidyverse)

# temporary, get EO data from previously assembled dataframe
# load(file='data/eo.Rda')

frag <- 'select_by_continent.htm'
file.create(frag)
out <- file(frag, open='a')

cat('<nav class="continent">', sep='\n', file=out)

continents <- c('Africa', 'Americas', 'Asia', 'Europe', 'Oceania') 

for (c in seq_along(continents)) {
  #print(continents[c])
  # begin dropdown for a Continent
  cat('  <div class="dropdown">', sep='\n', file=out)
  cat(paste0('  <button class="dropbtn">', continents[c]), sep='\n', file=out)
  cat('  </button>', sep='\n', file=out)
  cat('    <div class="dropdown-content">', sep='\n', file=out)
  
  # loop Countries in that continent
  thisContinent <- eo %>% 
    filter(Continent == continents[c]) %>% 
    select(iso3c, Country) %>% 
    arrange(Country)  # just in case not already ordered by Country name
  
  for (k in 1:nrow(thisContinent)) {
    iso3c <- thisContinent$iso3c[k]
    Country <- thisContinent$Country[k] 
    # print(paste0("<a href='", iso3c, ".html'>", Country, "</a>"))
    cat(paste0("      <a href='", iso3c, ".html'>", Country, "</a>"), sep='\n', file=out)
  }
  
  cat('    </div>', sep='\n', file=out)    
  cat('  </div>', sep='\n', file=out)    
}
cat('</nav>', sep='\n', file=out)    
close(out)