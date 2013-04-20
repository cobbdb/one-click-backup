@echo off
set version=1.2.2

:: Setup drive path variables.
set backupLabel=Backup
set duplicateLabel=Duplicate
call:setupDrives
::set backupPath=F:\Documents\Programming\BatchScript\backup_%version%\dest
::set duplicatePath=F:\Documents\Programming\BatchScript\backup_%version%\duplicate

:: Greet the user and offer last chance.
call:greet
pause
call:newLine 2

if exist %backupPath% (
    :: Try to backup the laptop.
    call:backup
    :: Try to duplicate the backup drive.
    call:duplicate

    call:farewell
) else (
    call:log "Backup drive not found!"
)

pause
goto:eof



::-------------------------------------------
::-- Functions
::-------------------------------------------

:: @returns backupPath and duplicatePath into global scope.
:setupDrives
:: Fetch repo information.
set backupLetter=NULL
set duplicateLetter=NULL
call:getDriveInfo

:: Set repo paths.
set backupPath=%backupLetter%\laptop_backup-test
set duplicatePath=%duplicateLetter%\
goto:eof


:getDriveInfo
:: Fetch backup drive info.
set driveLetter=NULL
call:getDriveLetter %backupLabel%
set backupLetter=%driveLetter%

:: Fetch duplicate drive info.
set driveLetter=NULL
call:getDriveLetter %duplicateLabel%
set duplicateLetter=%driveLetter%
goto:eof


:backup
call:log "Backing up your laptop."
cd F:\Documents\Programming\BatchScript\backup_%version%\
:: @see http://ss64.com/nt/for2.html
for %%G in (
    source1
    source2
    source3\targetSubDir
) do (
    echo  --- From %%G
    :: @see http://ss64.com/nt/xcopy.html
    xcopy %%G %backupPath%\%%G /d /i /s /e /r /y
    echo.
)
goto:eof


:duplicate
if exist %duplicatePath% (
    call:log "Duplicating Backup Drive."
    xcopy %backupPath% %duplicatePath% /d /i /s /e /r /y
    echo.
) else (
    call:log "Duplicate drive not found!"
)
goto:eof


:: @see http://stackoverflow.com/questions/47849/refer-to-select-a-drive-based-only-on-its-label-i-e-not-the-drive-letter
:getDriveLetter
for /f %%D in ('wmic volume get DriveLetter^, Label ^| find "%~1"') do set driveLetter=%%D
goto:eof


:: @see http://ss64.com/nt/for_l.html
:newLine
for /L %%i in (0, 1, %~1) do (
    echo.
)
goto:eof


:log
echo.
echo  * %~1 *
echo.
goto:eof


:farewell
call:log "Goodbye."
goto:eof


:greet
cls
call:newLine 2
echo     Welcome to
echo    ______        __     __       ______ __ _        __  
echo   / ____/____   / /_   / /_     / ____// /(_)_____ / /__
echo  / /    / __ \ / __ \ / __ \   / /    / // // ___// //_/
echo / /___ / /_/ // /_/ // /_/ /  / /___ / // // /__ / ,^<   
echo \____/ \____//_.___//_.___/   \____//_//_/ \___//_/^|_^|  
echo         ____                __                              
echo        / __ ) ____ _ _____ / /__ __  __ ____                
echo       / __  ^|/ __ `// ___// //_// / / // __ \               
echo      / /_/ // /_/ // /__ / ,^<  / /_/ // /_/ /               
echo     /_____/ \__,_/ \___//_/^|_^| \__,_// .___/                
echo                                     /_/     v%version%
echo.
call:log "Close this window to quit without changing your files."
goto:eof
