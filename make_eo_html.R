# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
page <- 'country.html'
file.create(page)
file.append(page, 'start.htm')
file.append(page, 'menu.htm')
file.append(page, 'end.htm')
