REM Reboot a Windows Host using this batch script
REM #############################################
@echo off
REM Get the date for today
set yyyy=%date:~10%
set mm=%date:~4,2%
set dd=%date:~7,2%

echo "START time:" >> "C:\Restart Scripts\ServerReboot.%yyyy%-%mm%-%dd%.txt"
echo %DATE% >> "C:\Restart Scripts\ServerReboot.%yyyy%-%mm%-%dd%.txt"
echo %TIME% >> "C:\Restart Scripts\ServerReboot.%yyyy%-%mm%-%dd%.txt"

c:\windows\system32\shutdown.exe -f -r -t 10 >> "C:\Restart Scripts\ServerReboot.%yyyy%-%mm%-%dd%.txt"
