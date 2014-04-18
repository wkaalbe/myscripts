#!/bin/bash
# Script to check for HTTP Errors and Statuses for specific URLs provided one per line in a text file '/tmp/URLs.txt'
# WS logs are expected to be in the directory '/tmp/wslogs' 
# 500, 501, 503, 504, 505, 5xx, NON 5xx, 200, 301, 404
# 9th field from the log format is the HTTP Status Code.
# HTTP Status codes Reference = http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
# 500 Internal Server Error
# 501 Not Implemented
# 502 Bad Gateway
# 503 Service Unavailable
# 504 Gateway Timeout
# 505 HTTP Version Not Supported
#####################################################################################################################
cd /tmp/wslogs 
for j in $(cat /tmp/URLs.txt)
do
  echo "#######################################################################"
  echo "FOR The URL - ${j}"
  echo
  Count5xx=0; TCount5xx=0; Count500=0; TCount500=0; Count501=0; TCount501=0; Count502=0; TCount502=0; Count503=0; TCount503=0; Count504=0; TCount504=0;
  Count505=0; TCount505=0; Count200=0; TCount200=0; Count301=0; TCount301=0; Count404=0; TCount404=0; NONCount5xx=0; TNONCount5xx=0;
#  for i in "`ls | head -2`"
  for i in $(ls)
  do
    echo "For file ${i}"

    TCount5xx=`cat ${i} | grep "${j}" | awk '$9 ~ /5[0-9][0-9]/ {++a} END {print a}'`
    ((Count5xx=Count5xx+TCount5xx))

    TCount500=`cat ${i} | grep "${j}" | awk '$9 ~ /500/ {++b} END {print b}'`
    ((Count500=Count500+TCount500))

    TCount501=`cat ${i} | grep "${j}" | awk '$9 ~ /501/ {++c} END {print c}'`
    ((Count501=Count501+TCount501))

    TCount502=`cat ${i} | grep "${j}" | awk '$9 ~ /502/ {++d} END {print d}'`
    ((Count502=Count502+TCount502))

    TCount503=`cat ${i} | grep "${j}" | awk '$9 ~ /503/ {++e} END {print e}'`
    ((Count503=Count503+TCount503))

    TCount504=`cat ${i} | grep "${j}" | awk '$9 ~ /504/ {++f} END {print f}'`
    ((Count504=Count504+TCount504))

    TCount505=`cat ${i} | grep "${j}" | awk '$9 ~ /505/ {++g} END {print g}'`
    ((Count505=Count505+TCount505))

    TNONCount5xx=`cat ${i} | grep "${j}" | awk '$9 !~ /5[0-9][0-9]/ {++h} END {print h}'`
    ((NONCount5xx=NONCount5xx+TNONCount5xx))

    TCount200=`cat ${i} | grep "${j}" | awk '$9 ~ /200/ {++k} END {print k}'`
    ((Count200=Count200+TCount200))

    TCount301=`cat ${i} | grep "${j}" | awk '$9 ~ /301/ {++l} END {print l}'`
    ((Count301=Count301+TCount301))

    TCount404=`cat ${i} | grep "${j}" | awk '$9 ~ /404/ {++m} END {print m}'`
    ((Count404=Count404+TCount404))

  done
  echo "Total # of 5xx Errors = ${Count5xx}"
  echo "Total # of 500s = ${Count500}"
  echo "Total # of 501s = ${Count501}"
  echo "Total # of 502s = ${Count502}"
  echo "Total # of 503s = ${Count503}"
  echo "Total # of 504s = ${Count504}"
  echo "Total # of 505s = ${Count505}"
  echo
  echo "Total # of NON 5xx's = ${NONCount5xx}"
  echo "Total # of 200s = ${Count200}"
  echo "Total # of 301s = ${Count301}"
  echo "Total # of 404s = ${Count404}"
  echo "#######################################################################"
done
