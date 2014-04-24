REM DOS Script to Delete all files older than 7 days in a Specified directory and directories with in.
REM Below is the script.  Keep it in a .bat script and schedule a task using Windows Scheduled Tasks
REM 
REM Start --> Program --> Accessories --> System Tools --> Scheduled Tasks
REM 
REM And "Add Scheduled Task"
REM 
REM #####

@echo off
REM variables

set CONFIGDIR="C:config"
set OAMDIR="C:oam"
set USERSDIR="C:users"
set USERSDSEDIR="C:usersdse"

REM Delete files which are older than 7 days in the above directories
 
forfiles /p "%CONFIGDIR%" /s /d -7 /c "cmd /c del @path"
forfiles /p "%OAMDIR%" /s /d -7 /c "cmd /c del @path"
forfiles /p "%USERDIR%" /s /d -7 /c "cmd /c del @path"
forfiles /p "%USERSDSEDIR%" /s /d -7 /c "cmd /c del @path"

