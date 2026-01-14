@ECHO OFF
::
:: WinGet 3rd Party Automated Update Batch File
:: By TheRobMozza - https://github.com/TheRobMozza/
::

:: *****************************************************
SET CLEANUP=0
::^^ 0 = Disabled - 1 = Enabled ^^::
SET CLEANUPLOCATION="C:\Users\YOURUSERNAME\Scripts\CleanUp.bat"
::^^ YOUR-CLEANUP-BATCH-FILE-LOCATION-HERE ^^::
:: *****************************************************

:: Sets the ESC character for coloured text 
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
:: Colours available = https://i.sstatic.net/gpDPE.png

echo.
echo Your OS is : %ESC%[91m && ver && echo %ESC%[0m
echo.
echo.
echo                                          ------------------------------------------
echo.
echo                                           Checking for Administrator privileges...
echo.
echo						  TO CANCEL OPERATION JUST HIT "NO"
echo.
echo                                          ------------------------------------------
echo.
TIMEOUT 3
NET SESSION 2>nul
IF %ERRORLEVEL% NEQ 0 GOTO elevate
GOTO adminTasks

:elevate
(
    :: Check Admin rights and create VBS Script to elevate
    >nul fsutil dirty query %SYSTEMDRIVE% 2>&1 || (

        :: Very little red console
        mode con cols=80 lines=3 
        color cf

        :: Message
        title Please wait...
        echo.
        echo                         Requesting elevated shell...

        :: Create VBS script
        echo Set UAC = CreateObject^("Shell.Application"^)>"%TEMP%\elevate.vbs"
        echo UAC.ShellExecute "%~f0", "%TEMP%\elevate.vbs", "", "runas", 1 >>"%TEMP%\elevate.vbs"
        if exist "%TEMP%\elevate.vbs" start /b /wait >nul cscript /nologo "%TEMP%\elevate.vbs" 2>&1

        :: Delete elevation script if exist
        if exist "%TEMP%\elevate.vbs" >nul del /f "%TEMP%\elevate.vbs" 2>&1

        exit /b
    )    
)
pushd "%~dp0"
GOTO exit

:adminTasks
echo.
echo                                          ------------------------------------------
echo.
echo                                           WinGet is now running as %ESC%[1mAdministrator..%ESC%[0m
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
echo                                           - (Y)es or (N)o - %ESC%[43mDefault is YES (5 sec)%ESC%[0m
echo.
echo                                          ------------------------------------------
echo.
:choice1
choice /C yn /N /T 5 /D y /M "> "
IF %ERRORLEVEL% == 1 GOTO choice2
IF %ERRORLEVEL% == 2 GOTO updatesNo
GOTO choice1

:choice2
echo Checking for Discord running in memory, if found stopping Discord as it hinders its own update operation... 
echo.
tasklist | find /i "discord.exe" && taskkill /IM discord.exe /F >nul || echo. && echo Process "discord.exe" was not found running..
echo.
echo.
echo                                          ----------------------------------------------
echo.
echo                                           Would you like to include 'unknown' updates?
echo.
echo                                           - (Y)es or (N)o - %ESC%[43mDefault is NO (5 seconds)%ESC%[0m
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
TIMEOUT 1 >nul
GOTO winGetCheck

:updatesYes
PowerShell.exe -ExecutionPolicy Bypass -Command "winget upgrade --all"
TIMEOUT 1 >nul
GOTO winGetCheck

:winGetCheck
echo.
echo.
echo                                     -----------------------------------------------------
echo.
echo                                      Did you get the following error message?
echo.
echo                                      %ESC%[1m"Failed in attempting to update the source: winget"%ESC%[0m
echo.
echo                                      - (Y)es I did or (N)o I didn't - %ESC%[43mDefault No (5 sec)%ESC%[0m
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
echo                                         Forcing WinGet to reset to %ESC%[1mDEFAULTS%ESC%[0m
echo.
echo                                         You may have to re-run this batch file
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
tasklist | find /i "superantispyware.exe" && taskkill /IM superantispyware.exe /F >nul || echo. && echo Process "superantispyware.exe" was not found running..
set app=superantispyware
winget list %app% | findstr /c:"No installed package found" >nul && (
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
echo                                            %ESC%[93mAll Updates have been COMPLETED!%ESC%[0m
echo.
echo                                                 Quitting in 3 seconds..
echo.
echo                                           ==================================
TIMEOUT 3 >nul
GOTO cleanup

:cleanup 
echo. && echo. && echo *************************************************** && echo. && echo Running Automated Desktop Clean Up if applicable. . && echo. && echo ****************************************************
TIMEOUT 3 >nul
IF %CLEANUP%==1 (echo. && echo Clean UP is ENABLED && TIMEOUT 1 >nul && echo. && call %CLEANUPLOCATION%) ELSE (echo. && echo Clean Up is DISABLED && TIMEOUT 3 >nul)
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
TIMEOUT 3 >nul
GOTO exit

:exit
CLS
IF EXIST "initdebug.nfo" (
	del initdebug.nfo
) ELSE (
exit
)

