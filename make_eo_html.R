# HTML country page construction
# menu will be made from country list
# file.append doesnt add newline between files 
# so fragments after last line need extra newline.
page <- 'AFG.html'
file.create(page)
file.append(page, 'fragment/start.htm')
file.append(page, 'fragment/select_by_continent.htm')

out <- file(page, open='a')
cat('<h1>Afghanistan</h1>', sep='\n', file=out)

close(out)

file.append(page, 'fragment/end.htm')
