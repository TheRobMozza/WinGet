@ECHO OFF
::
:: WinGet 3rd Party Update Automated Batch File
:: By TheRobMozza - https://github.com/TheRobMozza/
::
echo.
echo Your OS is : && ver
echo.
echo.
echo                                          ------------------------------------------
echo.
echo                                           Checking for Administrator privileges...
echo.
echo                                          ------------------------------------------
echo.
TIMEOUT 5
NET SESSION 2>nul
IF %ERRORLEVEL% NEQ 0 GOTO elevate
GOTO adminTasks

:elevate
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" 
GOTO exit

:adminTasks
echo.
echo                                          ------------------------------------------
echo.
echo                                           WinGet is now running as Administrator..
echo.
echo                                          ------------------------------------------
echo.
echo.
echo ** This 3rd party update script will begin in 3 seconds **
echo.
TIMEOUT 3
echo.
echo.
echo                                          ------------------------------------------
echo.
echo                                           Check for 3rd party program updates now?
echo.
echo                                           - (Y)es or (N)o - Default is YES (5 sec)
echo.
echo                                          ------------------------------------------
echo.
:choice1
choice /C yn /N /T 5 /D y /M "> "
IF %ERRORLEVEL% == 1 GOTO choice2
IF %ERRORLEVEL% == 2 GOTO updatesNo
GOTO choice1

:choice2
echo Checking for Discord running in memory, if found stopping Discord... 
echo.
tasklist | find /i "discord.exe" && taskkill /IM discord.exe /F > NUL || echo. && echo Process "discord.exe" was not found running..
echo.
echo.
echo                                          ----------------------------------------------
echo.
echo                                           Would you like to include 'unknown' updates?
echo.
echo                                           - (Y)es or (N)o - Default is NO (5 seconds)
echo.
echo                                          ----------------------------------------------
echo.
echo.
:choice2
choice /C yn /N /T 5 /D n /M "> "
IF %ERRORLEVEL% == 1 GOTO updatesAllYes
IF %ERRORLEVEL% == 2 GOTO updatesYes
GOTO choice2

:updatesAllYes
PowerShell.exe -ExecutionPolicy Bypass -Command "winget upgrade --all --include-unknown"
TIMEOUT 1 > NUL
GOTO winGetCheck

:updatesYes
PowerShell.exe -ExecutionPolicy Bypass -Command "winget upgrade --all"
TIMEOUT 1 > NUL
GOTO winGetCheck

:winGetCheck
echo.
echo.
echo                                     -----------------------------------------------------
echo.
echo                                      Did you get the following error message?
echo.
echo                                      "Failed in attempting to update the source: winget"
echo.
echo                                      - (Y)es I did or (N)o I didn't - Default No (5 sec)
echo.
echo                                     -----------------------------------------------------
echo.
:choice3
choice /C yn /N /T 5 /D n /M "> "
IF %ERRORLEVEL% == 1 GOTO resetWinGet
IF %ERRORLEVEL% == 2 GOTO sas
GOTO choice3

:resetWinGet
echo.
echo                                        -----------------------------------------
echo.
echo                                         Forcing WinGet to reset to default
echo.
echo                                         You will have to re-run this batch file
echo.
echo                                        -----------------------------------------
echo.
winget source reset --force
GOTO exit

:sas
tasklist | find /i "superantispyware.exe"
IF %ERRORLEVEL% == 0 GOTO sasInMem
IF %ERRORLEVEL% == 1 GOTO sasNo
GOTO sas

:sasInMem
echo.
echo                                        ------------------------------------------
echo.
echo                                         Quickly double checking SuperAntiSpyware
echo.
echo                                             (Known problems in the past...)
echo.
echo                                        ------------------------------------------
echo.
tasklist | find /i "superantispyware.exe" && taskkill /IM superantispyware.exe /F > NUL || echo. && echo Process "superantispyware.exe" was not found running..
set app=superantispyware
winget list %app% | findstr /c:"No installed package found" > nul && (
    winget install %app% --force --silent
) || (
    winget upgrade %app% --force --silent
)
start C:\"Program Files"\SUPERAntiSpyware\SUPERAntiSpyware.exe
GOTO exit

:sasNo
echo.
echo                                           ==================================
echo.
echo                                            All Updates have been COMPLETED!
echo.
echo                                                 Quitting in 3 seconds..
echo.
echo                                           ==================================
TIMEOUT 3
GOTO exit

:updatesNo
echo.
echo                                              -------------------------
echo.
echo                                                Skipping update check
echo.
echo                                               Quitting in 3 seconds..
echo.
echo                                              -------------------------
TIMEOUT 3
GOTO exit

:exit
CLS
IF EXIST "initdebug.nfo" (
	del initdebug.nfo
) ELSE (
exit
)
