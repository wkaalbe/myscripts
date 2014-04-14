#!/bin/bash
# Runs without providing any arguments to the script - if provided, it assumes you provide two arguments.
# First argument if provided, needs to be the absolute path for the directory we need to check disk space on (default /)
# Second argument - a number - anything less than 100
# Author - Chandrashekar Munukutla - csmunuku@gmail.com
#########################################################################################################################

# This script checks if a particular directory ${locationToCheck} is x% full and emails easm team the results.
if [ $# -eq 2 ]; then
   locationToCheck="${1}"
   percentCheck="${2}"
else
   locationToCheck="/"
   percentCheck="90"
fi

##### Script Signature #####
scriptDir=`dirname ${0}`
scriptName=`basename ${0}`
#echo script directory ${scriptDir}
#echo script name ${scriptName}

if [ ${scriptDir} = "." ]; then
    scriptDir=`pwd`
fi

scriptSignature(){
      scriptSign="${scriptDir}/${scriptName}"
      echo "####################################################################################################"
      echo "Script Signature: `uname -n`: ${scriptSign}"
      echo "####################################################################################################"
}
#####

ts="`date '+%Y%m%d_%H%M%S'`"
tmpFileName="/tmp/${USER}_${ts}_$$.txt"
touch ${tmpFileName}

MailSubject=""
ToAddress="csmunuku@gmail.com"

email_msg(){
   MailSubject="ALERT: ${locationToCheck} on `uname -n` is ${currDiskSpacePercent}% full."
   echo -e "\n=========================================================================================================" >> ${tmpFileName}
   scriptSignature >> ${tmpFileName}
#   echo "Script Signature: `uname -n`:${ScriptSignature}" >> ${tmpFileName}
   /bin/mail "${ToAddress}" -s "${MailSubject}" < ${tmpFileName}
}

currDiskSpacePercent=`df -h ${locationToCheck} | grep -v Filesystem | awk '{ print $5 }' | cut -d'%' -f1`
if [ ${currDiskSpacePercent} -gt ${percentCheck} ]; then
      cd ${locationToCheck}
      echo "In the Directory - `pwd`" >> ${tmpFileName}
      df -H . >> ${tmpFileName}
      echo -e "\n=========================================================================================================" >> ${tmpFileName}
      echo "ls -alrt output" >> ${tmpFileName}
      ls -alrt >> ${tmpFileName}
      email_msg
fi

rm ${tmpFileName}
