library(tidyverse)
library(readxl)
library(countrycode)
library(stringi)

# library(googledrive)
# library(googlesheets4)

# eo_id <- '1MND7qbKQZ3Q-pLS2182un7z6ZkUtY3LzvUf626SLuEw'
# sheet_names(ss = eo_id)
# 
# eoData <- read_sheet(ss = eo_id, sheet ='Main')

original_xls <- "data/Country Data.xlsx"

column_names <- read_excel(original_xls, 
                           sheet = "Main", 
                           .name_repair = "minimal") %>% names()

eo_data_import <- read_excel(original_xls, 
                             sheet = "Main", skip = 0)

eo_data_import[ eo_data_import == "No Data" ] <- NA
eo_data_import[ eo_data_import == "#VALUE!" ] <- NA

eoData <- eo_data_import %>% 
  filter(!is.na(Country)) %>% 
  filter(Country != 'World')

# column names make shorter
names(eoData)[grepl('Actual Comment for Web Site', names(eoData))] <- 'Comments'

eoData <- eoData %>% 
  select(iso2c, Country, Comments)

# check country names alphabetical
bakeodata <- eoData
eoData <- eoData %>% 
  arrange(Country)
all.equal(eoData, bakeodata)
# which(eoData[,2] != bakeodata[,2]) # 157 158 159 169 170
identical(eoData, bakeodata)

Encoding(eo_Data$Comments) # reveals some unknown, some UTF-8
eoComment <- eoData
# testing Madagascar, its UTF-8
# comment <- eo_comment %>% 
#   filter(iso2c == 'MG') %>% 
#   select(Comments)
# 
# Encoding(as.character(comment))

eoComment <- stri_encode(eoData$Comments, 'unknown', 'UTF-8')
Encoding(eoComment)

if (grepl("’", caption)) {
  #print(paste(country, caption))
  caption <- gsub("’", "&rsquo;", caption)
}

saveRDS(eo_comment, 'data/eo_comment_Feb2022.rds')
