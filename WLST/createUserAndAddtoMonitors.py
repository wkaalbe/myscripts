##############################################################################################################
# AUTHOR: csmunuku@gmail.com
#USAGE: java weblogic.WLST createUserAndAddtoMonitors.py ofmsmsupport "OFM Support - RO Account"
#Where ofmsmsupport is the user account we are creating and adding it to monitors group.
##########################################################################################
##########################################################################################
userName = sys.argv[1]
userDescription = sys.argv[2]
#userGroup = sys.argv[3]
userGroup = 'Monitors'
userPassword = 'mydefaultPassword'

if len(userName) == 0:
   print "ERROR:" + userName + "is Empty, EXITING!"
   exit()
if len(userDescription) == 0:
   print "ERROR:" + userDescription + "is Empty, EXITING!"
   exit()
if len(userGroup) == 0:
   print "ERROR:" + userGroup + "is Empty, EXITING!"
   exit()

adm_Username = raw_input('Please provide your username to connect to WLS: ')
adm_Password = raw_input('Password: ')
adm_URL = 't3://localhost:7001'
#adm_URL = 't3://<MY_WEBLOGIC_SERVER_FQDN>:7001'

if len(adm_Username) == 0:
   print "ERROR:" + adm_Username + "is Empty, EXITING!"
   exit()
if len(adm_Password) == 0:
   print "ERROR:" + adm_Username + "is Empty, EXITING!"
   exit()

try:
   connect(adm_Username,adm_Password,adm_URL)
except:
   print "ERROR: Unable to connect to weblogic server"
   print(dumpStack())

print "Looking up DefaultAuthenticator ..."
atnr=cmo.getSecurityConfiguration().getDefaultRealm().lookupAuthenticationProvider('DefaultAuthenticator')

try:
   if atnr.userExists(userName) == 1:
      print "User " + userName + " already exists"
   else:
      print "Creating user ..." + userName
      atnr.createUser(userName,userPassword,userDescription)
      print "Created user successfully"
except:
   print(dumpStack())
   print "ERROR: - Error creating user.."

from weblogic.management.security.authentication import GroupEditorMBean
print "Adding user " + userName + " to the group " + userGroup
atnr.addMemberToGroup(userGroup,userName)
print "Done adding user " + userName + " to the group " + userGroup
