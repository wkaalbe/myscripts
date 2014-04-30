#!/usr/bin/python
# AUTHOR: Chandrashekar Munukutla - csmunuku@gmail.com
# Takes input of file containing --> lastname, firstname; lastname, firstname; 
# Provides output of comma separated list of the email addresses - firstname_lastname@MYDOMAIN.com, firstname_lastname@MYDOMAIN.com  etc
#########################################################################################################################################
import sys, os, re
try:
   fh = open(sys.argv[1],'r')
   myList = fh.readlines()
   fh.close()
except IOError,e:
   print "Error:", e

#print myList
entries = re.split(";", myList[0].strip())
#print entries
try:
   fh_a = open('/tmp/test.txt','a')
   for i in entries:
      newlist = re.split(",", i)
      if len(newlist) == 2:
         fh_a.writelines(newlist[1].strip()+ '_' + newlist[0].strip() + '@MYDOMAIN.com,')
      else:
         fh_a.writelines(newlist[0].strip().replace(' ','') + '@MYDOMAIN.com,')
   fh_a.close()
except IOError,e:
   print "Error:", e

try:
   fh_r = open('/tmp/test.txt','r')
   for i in fh_r.readlines():
       print i
   fh_r.close()
except IOError,e:
   print "Error:", e
