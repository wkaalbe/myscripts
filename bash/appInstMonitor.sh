#!/bin/bash
# Author: csmunuku@gmail.com
#############################################
emailDistList="csmunuku@gmail.com"
ts="`date '+%Y%m%d_%H%M%S'`"
MyLogFile="/tmp/temp_${ts}"
touch ${MyLogFile}
instDownList=
count=0
##########################################################################
# Define what apps would be running on this node!
case `hostname` in
#   abc.xyz.com) apps="abc1 abc2 abc3" ;;
    localhost) apps="app1 app2" ;;
    *) apps="app1";;
esac
##########################################################################
## Script Signature
##scriptSign=$(readlink -f $0)
scriptDir=`dirname ${0}`
scriptName=`basename ${0}`
if [ ${scriptDir} = "." ]; then
    scriptDir=`pwd`
fi
scriptSignature(){
      scriptSign="${scriptDir}/${scriptName}"
      echo "##################################################################################################"
      echo "Script Signature: `uname -n`: ${scriptSign}"
      echo "##################################################################################################"
}
###################
emailNotification()
{
  ToAddress="${1}"
  echo "`date`" >> ${MyLogFile}
  echo >> ${MyLogFile}
  scriptSignature >> ${MyLogFile}
  echo emailing now
  /bin/mail "${ToAddress}" -s "${MailSubject}" < ${MyLogFile}
}
##########################################################################
checkAppStatus()
{
  for i in $*
  do
    pCount="`ps -ef | grep java | grep -v grep | grep -w ${i} | wc -l`"
    if [ $pCount -eq 0 ]; then
       ((count=count+1))
       echo count is $count
       instDownList="$instDownList $i"
    fi
  done
}
#######################################
###  Actual Execution - main() ;) !!

checkAppStatus $apps
if [ $count -eq 1 ]; then
    echo "The following instance is not running!" >> ${MyLogFile}
    echo "$instDownList" >> ${MyLogFile}
    MailSubject="ALERT:`hostname` - $instDownList - instance is Down!!"
    emailNotification "${emailDistList}"
elif [ $count -gt 1 ]; then
    echo "The following instances are not running!" >> ${MyLogFile}
    echo "$instDownList" >> ${MyLogFile}
    MailSubject="ALERT:`hostname` - multiple java instances are Down!!"
    emailNotification "${emailDistList}"
fi
#######################################
