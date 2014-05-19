#!/bin/bash
# Author: csmunuku@gmail.com
##########################################################################
ToAddress="csmunuku@gmail.com"
CCAddresses="vchitupl@gmail.com"

check_tomcat()
{
   if  [ `ps -ef | grep java | grep -i "org.apache.catalina.startup.Bootstrap" | grep -cv grep` -ne 1 ]; then
          echo "Tomcat on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: Tomcat Down on - `hostname`" -c "${CCAddresses}"
   else
       echo "Tomcat - Running"
   fi
}
#######################################

check_jetty()
{
   if  [ `ps -ef | grep java | grep -i "jetty-6.1.14/start.jar" | grep -cv grep` -ne 1 ]; then
          echo "Jetty on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: `hostname` - Jetty Process is DOWN!!" -c "${CCAddresses}"
   else
       echo "Jetty - Running"
   fi
}
#######################################

check_apache()
{
   if [ `ps -ef | grep httpd | grep root | grep -cv grep` -ne 1 ]; then
       echo "Apache on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: `hostname` - Apache on host is DOWN!!" -c "${CCAddresses}"
   else
       echo "Apache - Running"
   fi
}
#######################################

check_mysql()
{
   if [[ `ps -ef | grep mysqld | grep -v mysqld_safe | grep -cv grep` -ne 1 ]] && [[ `ps -ef | grep mysqld_safe | grep -cv grep` -ne 1 ]]; then
       echo "MySQL on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: `hostname` - MySQL on host is DOWN!!" -c "${CCAddresses}"
   else
       echo "MySQL - Running"
   fi
}
#######################################

check_weblogic()
{
 if [ `ps -ef | grep java | grep weblogic.Server | grep -cv grep` -gt 0 ]; then
    echo -e "PID \t WebLogic ServerName"
    echo -e "#######\t ########################"
    for i in `ps -ef | grep java | grep weblogic.Server | grep -v grep | awk '{print $2}'`
    do
      serverName=`ps -ef | grep ${i} | grep weblogic.Server | grep Dweblogic.Name= | grep -v grep | awk 'BEGIN { FS = "weblogic.Name="} { print $2 }' | awk '{print $1}'`
      echo -e "${i} \t ${serverName}"
    done
    echo "######################################"
 else
    echo "WebLogic Server Instance(s) on Host - `hostname` is/are DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: `hostname` - WebLogic is DOWN!!" -c "${CCAddresses}"
    echo "NO WebLogic Server instances running on this Host - `hostname`"
 fi
}

#######################################

check_nodemanager()
{
 nm_process_count="`ps -ef | grep weblogic.NodeManager | grep -cv grep`"
 if [ "$nm_process_count" -eq 1 ]; then
    echo
    echo "`ps -ef | grep weblogic.NodeManager | grep -v grep | awk '{print $2}'` - is PID for NodeManager Process"
    echo
 elif [ "$nm_process_count" -eq 0 ]; then
    echo "WebLogic NodeManager isn't running on this host - `hostname`"
    echo "WebLogic NodeManager on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: `hostname` - WebLogic NodeManager is DOWN!!" -c "${CCAddresses}" 
 elif [ "$nm_process_count" -gt 1 ]; then
    echo "Hmm.. NOT Good.. - There are multiple instances of NodeManager running on this host"
    echo "Which is unnecessary"
    echo "Here are the processes"
    ps -ef | grep weblogic.NodeManager | grep -v grep
 fi
}

#######################################
check_jboss()
{
   if  [ `ps -ef | grep java | grep -i "org.jboss.Main" | grep -cv grep` -ne 1 ]; then
          echo "JBoss on Host - `hostname` is DOWN!! - `date`" | /bin/mail "${ToAddress}" -s "ERROR: JBoss Down on - `hostname`" -c "${CCAddresses}"
   else
       echo "JBoss - Running"
   fi
}

#######################################
#######################################
## Calling the functions
#######################################
#######################################

check_tomcat
check_jetty
check_apache
check_mysql
check_weblogic
check_nodemanager
check_jboss
