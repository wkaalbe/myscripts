#!/usr/bin/env python
# To Open a set of URLs in a Browser..
# Input being the list of URLs (one per line) in a Text file 'test.txt' 
# EXAMPLE:
# http://www.yahoo.com
# https://www.google.com
######################################################################
import webbrowser
urlsFile = 'test.txt'
for myurl in open(urlsFile):
    url = myurl
    # Open URL in new window, raising the window if possible.
    webbrowser.open_new(url)

######################################################################
