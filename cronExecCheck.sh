#!/bin/bash
# AUTHOR: csmunuku@gmail.com
for i in `crontab -l | grep -v "^#" | grep -v '^$' | egrep -v "bash|perl|ruby|sh|python|java" | cut -d' ' -f6 | sort -u`
do
  my_script=`eval "echo $i"`
  if [ -f ${my_script} ]; then
      dirname_val=`dirname ${my_script}`
      basename_val=`basename ${my_script}`
      abs_path="${dirname_val}/${basename_val}"
      if [ ! -x "${abs_path}" ]; then
          echo "script is - ${abs_path} - is NOT Executable.. Please Check!!"
      else
          which ${abs_path} > /dev/null
          if [ $? -eq 0 ]; then
             script_type=`head -1 ${abs_path}`
             echo "${abs_path} - is a ${script_type} and is Executable.. "
          else
             echo "ERROR: script - ${abs_path} - DOESN'T EXIST"
          fi
      fi
  fi
done
