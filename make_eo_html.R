# HTML country page construction
# menu will be made from country list
page <- 'country.html'
if (file.exists(page)) {
  file.remove(page)
}
file.copy('start.htm', page)
file.append(page, 'menu.htm')
file.append(page, 'end.htm')
