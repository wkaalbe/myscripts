##############################################################################################################
# AUTHOR: csmunuku@gmail.com
# <domain> --> Configuration --> Logging    you have many options to choose from to Rotate Log files.
# Using WLST - you can force Log Rotation OnDemand - at any specific given time using this script below ===  
# Info from Site --> http://docs.oracle.com/cd/E11035_01/wls100/logging/config_logs.html#wp1001654
##############################################################################################################

import os
import sys

adminUsername = 'weblogic'
adminPassword = 'weblogic1'
connectString = 't3://HOSTNAME:7001'

try:
   connect(adminUsername, adminPassword, connectString)
   serverRuntime()
   wlsAdminServerName = cmo.getName()
   cd('LogRuntime/' + wlsAdminServerName)
   cmo.forceLogRotation()
   disconnect()
except:
   print(dumpStack())
