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
