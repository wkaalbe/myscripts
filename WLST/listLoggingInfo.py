#!/bin/python
import os
import sys

adminUsername = 'myadminuser'
adminPassword = 'mysecretpassword'
# connectString = 't3://myhost.mydomain.com:7001'
connectString = 't3://localhost:7001'

def connect_to_admin():
    try:
       connect(adminUsername, adminPassword, connectString)
    except:
       print(dumpStack())
       print
       print "##############################################################"
       print "Not able to connect to the Admin Server - Please Check!"
       print "##############################################################"
       print

def disconnect_from_admin():
    try:
       disconnect()
    except:
       print(dumpStack())

def getLoggingInfo():
    domainConfig()
    servers = cmo.getServers()
    for server in servers:
      name = server.getName()
      cd('/Servers/' + name + '/Log/' + name)
      print "For Server - " + name
      print "Log file location/name: " + cmo.getFileName()
      print "Rotation type: " + cmo.getRotationType()
      print "Rotation file size: " + str(cmo.getFileMinSize())
      print "Number of Files retained: " + str(cmo.getFileCount())
      print "########################################################"

connect_to_admin()
getLoggingInfo()
disconnect_from_admin()
