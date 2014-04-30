#!/usr/bin/python
# Author: Chandrashekar Munukutla - csmunuku@gmail.com
# provide urls in a text file (one per line) to test out the availability and the response time
######################################################################################################
import sys
import socket
import time
import urllib2
from urllib2 import Request, urlopen, URLError

socket.setdefaulttimeout(10)

for URL in open(sys.argv[1]):         # Use file iterators
    myURL = URL.rstrip()
    req = urllib2.Request(myURL)
    try:
        startTime = time.time()
        urllib2.urlopen(req)
        endTime = time.time()
        print "%s - Took %0.2f seconds" % ( myURL, endTime - startTime )
#        print "######################################################################################"
    except URLError, e:
        if hasattr(e, 'reason'):
           print 'We failed to reach ' + myURL
           print 'Reason: ', e.reason
#          print "######################################################################################"
