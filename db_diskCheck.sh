#!/bin/bash
# Author: csmunuku@gmail.com
##########################################################################
ts="`date '+%Y%m%d_%H%M%S'`"
ToAddress="csmunuku@gmail.com"
CCAddresses="csmunuku@gmail.com"
TEMP_FILE=/tmp/DB_Disk_Issues_${ts}.txt
STDERROR_FILE=/tmp/stderror_${ts}.txt
EmailERROR_FILE=/tmp/email_error_${ts}.txt
touch $TEMP_FILE
touch $STDERROR_FILE
touch ${EmailERROR_FILE}

# Example of DB Windows Hosts with FQDNs.
# HOST_LIST="<my_host_FQDN1> <my_host_FQDN2> <my_host_FQDN3>"
# HOST_LIST="abc.good.com bcd.good.com cde.good.com"
HOST_LIST=

for i in $HOST_LIST
do
  myHost="$i"
###  diskSpace=`ssh -o ConnectTimeout=20 $myHost "fsutil volume diskfree D: | grep avail" 2> /dev/null`
  diskSpace=`ssh -o ConnectTimeout=20 -o LogLevel=ERROR $myHost "fsutil volume diskfree D: | findstr avail" 2> $STDERROR_FILE`
  if [ ! -s $STDERROR_FILE ]; then
     echo "diskSpace = $diskSpace"
     availDiskSpaceInMB=`echo $diskSpace | awk '{print $NF/1048576}'`
     echo "availDiskSpaceInMB = ${availDiskSpaceInMB} MB"
     availDiskSpaceInGB=`echo $diskSpace | awk '{print $NF/1073741824}'`
     echo "availDiskSpaceInGB = ${availDiskSpaceInGB} GB"
     AvailableDiskSpaceInMB=${availDiskSpaceInMB/.*}
     echo "AvailableDiskSpaceInMB = ${AvailableDiskSpaceInMB}"
     if [[ ${AvailableDiskSpaceInMB} -gt 2048 ]]; then
        echo "$myHost ==> OK on disk space - ${availDiskSpaceInMB} MB ==> ${availDiskSpaceInGB} GB"
     else
        echo "Host - ${myHost} - D: drive Disk space LOW - ${availDiskSpaceInMB} MB ==> ${availDiskSpaceInGB} GB" >> $TEMP_FILE
     fi
  else
    echo "Host with Errors - ${i}"
    echo "Host with Errors - ${i}" >> ${EmailERROR_FILE}
    cat $STDERROR_FILE >> ${EmailERROR_FILE}
    echo "#####################################################" ${EmailERROR_FILE}
  fi
done
if [ -s ${TEMP_FILE} ]; then
   echo "" >> $TEMP_FILE
   echo "DB Team - Please clear the disk space on the above node(s)" >> $TEMP_FILE
   /bin/mail "${ToAddress}" -s "DB - Disk Space issue(s)" -c "${CCAddresses}" < /tmp/DB_Disk_Issues_${ts}.txt
fi
if [ -s ${EmailERROR_FILE} ]; then
   /bin/mail "${ToAddress}" -s "ERROR running DB Disk Space Check script" < ${EmailERROR_FILE}
fi
rm ${TEMP_FILE}
rm $STDERROR_FILE
rm ${EmailERROR_FILE}
