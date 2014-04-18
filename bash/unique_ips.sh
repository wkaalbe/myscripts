#!/bin/bash
# csmunuku@gmail.com
# gets all the unique IPs from all the Web Farm.
# Script assumes that you have password less ssh access to the WS nodes from bastion host (Mgmt node)
# by the virtue of deploying the ssh keys for the Application user.
#######################################################################################################

if [ $# -ne 1 ]; then
   echo "Please provide WS Log file name as argument to this script"
   echo "Example: $0 access.log.140418"
   exit 1
else
   fileName="${1}"
fi

stime=`date`
ts="`date '+%Y%m%d_%H%M%S'`"
mkdir -p /tmp/unique_ips
cd /tmp/unique_ips
rm -f /tmp/unique_ips/*
touch /tmp/TEMP_IPS_${ts}.txt
touch /tmp/all_unique_ips_${ts}.txt
wsNodeList="/tmp/ws.txt"
for i in $(cat $wsNodeList)
do
  ssh -q $i "cd /app/apache/\`hostname -s\`/logs; awk '{ print \$1}' $fileName | sort -u > /tmp/\`hostname -s\`_Unique_IPs.txt"
done
for i in $(cat $wsNodeList)
do
  scp $i:/tmp/${i}_Unique_IPs.txt .
  ssh -q $i "rm /tmp/${i}_Unique_IPs.txt"
done
for i in `ls /tmp/unique_ips`
do
  cat $i >> /tmp/TEMP_IPS_${ts}.txt
done
sort -u /tmp/TEMP_IPS_${ts}.txt > /tmp/all_unique_ips_${ts}.txt
echo "Here is your file with Unique IPs --> /tmp/all_unique_ips_${ts}.txt"
etime=`date`
echo "Start time - $stime"
echo "End time - $etime"
