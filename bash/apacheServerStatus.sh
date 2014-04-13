#!/bin/bash
# AUTHOR: csmunuku@gmail.com
# Desgined to be run from a Bastion Host which has access (password less) to bunch of Web Servers.
# Apache Status module needs to be enabled for this script to work.
# Gets the server-status for each of the Prod Web Servers,
# parses the output and sends email based on the thresholds set.
# Runs every 10 min via Crontab
# 00,10,20,30,40,50 * * * * /tmp/apache-server-status.sh
###################################################################################################
ToAddress="csmunuku@gmail.com"
CCAddresses="vchitupl@gmail.com"

# Web Server list in a text file with one hostname on each line.
WEBSERVERS="/tmp/prod_webservers.txt"
TempFile="/tmp/websrvstat.txt"

# Mail entries
SubjectMsg=""
WarningMsg=""
RedAlertMsg=""

# Thresholds
WARNING_Threshold=450
REDALERT_Threshold=800

tempVarReqPerSec=0
totalReqPerSec=0
averageReqPerSec=0

# Requests Processed
tempVarReqCurrProcessed=0
totalReqCurrProcessed=0
averageReqCurrProcessed=0

# Idle Worker Variables
tempVarIdleWorkers=0
totalIdleWorkers=0
averageIdleWorkers=0

SCRIPTSIGNATURE="Script Signature: `uname -n`:${0}"


if [ ! -f "${WEBSERVERS}" ]; then
   echo "Please make sure this file ${WEBSERVERS} exists and then re-run the script."
   echo "Now exiting..."
   exit 1
fi
> ${TempFile}
echo -e "-----------------------------------------------------------------------------------------" >> ${TempFile}
echo -e "|     Web Server Name     | No of procs | Reqs / Sec  | Reqs processed  | Idle Workers  |" >> ${TempFile}
echo -e "|-------------------------|-------------|-------------|-----------------|---------------|" >> ${TempFile}
for i in `cat ${WEBSERVERS}`
do
   # Running a ps for httpd
#   noOfApacheProcesses=`ssh -xq ${i} "ps -ef | grep httpd | grep latest_code | wc -l"`
   noOfApacheProcesses=`ssh -xq ${i} "ps -ef | grep httpd | wc -l"`
   wget http://${i}/server-status?auto -O ${i}-server-status
   printf  "| %s |%13s" ${i} ${noOfApacheProcesses} >> ${TempFile}

   # Requests Per Second
   head -9 ${i}-server-status | grep "ReqPerSec:" | awk -F": " '{ printf("|%13s|",$2) }' >> ${TempFile}
   tempVarReqPerSec=`head -9 ${i}-server-status | grep "ReqPerSec:" | awk -F": " '{ printf($2) }'`
   totalReqPerSec=`echo "$totalReqPerSec + $tempVarReqPerSec" | bc`

   # Busy Workers (Requests Processed)
   head -9 ${i}-server-status | grep "BusyWorkers:" | awk -F": " '{ printf("%17s|",$2) }' >> ${TempFile}
   tempVarReqCurrProcessed=`head -9 ${i}-server-status | grep "BusyWorkers:" | awk -F": " '{ printf($2) }'`

   # Checking for Thresholds
   if [ -z "${RedAlertMsg}" -a "$tempVarReqCurrProcessed" -ge "${REDALERT_Threshold}" ]; then
        SubjectMsg="RED ALERT: eStore Production Web Servers - High Req Processing at ${REDALERT_Threshold}"
        RedAlertMsg="${SubjectMsg}"
   elif [ -z "${RedAlertMsg}" -a -z "${WarningMsg}" -a "$tempVarReqCurrProcessed" -ge "${WARNING_Threshold}" ]; then
        SubjectMsg="WARNING: eStore Production Web Servers - Req processing at ${WARNING_Threshold}"
        WarningMsg="${SubjectMsg}"
   fi
   totalReqCurrProcessed=`echo "$totalReqCurrProcessed + $tempVarReqCurrProcessed" | bc`

   # Idle Workers
   head -9 ${i}-server-status | grep "IdleWorkers:" | awk -F": " '{ printf("%15s|\n",$2) }' >> ${TempFile}
   tempVarIdleWorkers=`head -9 ${i}-server-status | grep "IdleWorkers:" | awk -F": " '{ printf($2) }'`
   totalIdleWorkers=`echo "$totalIdleWorkers + $tempVarIdleWorkers" | bc`

   rm ${i}-server-status
done
echo -e "-----------------------------------------------------------------------------------------" >> ${TempFile}

# Calculating the Averages
averageReqPerSec=`echo "$totalReqPerSec / 22" | bc`
averageReqCurrProcessed=`echo "$totalReqCurrProcessed / 22" | bc`
averageIdleWorkers=`echo "$totalIdleWorkers / 22" | bc`

# Printing the Averages and Signature
echo -e "Average Requests per second = $averageReqPerSec \n"  >> ${TempFile}
echo -e "Total Requests Currently Processed = $totalReqCurrProcessed \n"  >> ${TempFile}
echo -e "Average Requests Currently Processed = $averageReqCurrProcessed \n"  >> ${TempFile}
echo -e "Average Idle Workers = $averageIdleWorkers \n"  >> ${TempFile}
echo -e "-----------------------------------------------------------------------------------------------" >> ${TempFile}
echo -e "`date`" >> ${TempFile}
echo -e "${SCRIPTSIGNATURE} " >> ${TempFile}
echo -e "-----------------------------------------------------------------------------------------------" >> ${TempFile}

# Sending email if SubjectMsg is Not Empty.
if [ -n "${SubjectMsg}" ]; then
    cat ${TempFile} | mutt -s "${SubjectMsg}" "${ToAddress}" -c "${CCAddresses}"
else
    SubjectMsg="Production Web Servers - Status"
    cat ${TempFile} | mutt -s "${SubjectMsg}" "${ToAddress}"
fi
