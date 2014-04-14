#!/bin/bash
###################################################################################################
# SCRIPT NAME: commandOnRemBoxes.sh
# DESCRIPTION: Used to execute command(s) on remote boxes
# AUTHOR: csmunuku@gmail.com
###################################################################################################
USER_NAME="myusername"

START_TIME="`date`"
if [ $# -eq 0 ]; then
   echo "Please provide FQDN of boxes as arguments to this script "
   exit 1
fi
echo "Please specify the Command you would like to run:"
read commandToRun

if [ -z "$commandToRun" ]; then
   echo "Command String that you entered currently is \"$commandToRun\" - Empty.."
   echo "Exiting now.."
   exit 1
fi

if [ $# -eq 1 -a -f ${1} ]; then
   for i in `cat ${1} |grep -v "^#"`
   do
     echo -n "$i - "
     ssh -xtq $i "sHost=\`hostname -s\`; if [ -f ~${USER_NAME}/.bash_profile ]; then . ~${USER_NAME}/.bash_profile; ${commandToRun}; else ${commandToRun}; fi"
#     echo "#######################################################################"
   done
else
   for i in $*
   do
     echo "On $i ..."
     ssh -xtq $i "sHost=\`hostname -s\`; if [ -f ~${USER_NAME}/.bash_profile ]; then . ~${USER_NAME}/.bash_profile; ${commandToRun}; else ${commandToRun}; fi"
     echo "#######################################################################"
   done
fi
END_TIME="`date`"
echo "#################"
echo "#################"
echo "Start Time is - $START_TIME"
echo "End Time is - $END_TIME"
