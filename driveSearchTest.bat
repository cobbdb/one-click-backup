@echo off

set driveLabel=DUPLICATE
set driveLetter=NULL

call:getDriveLetter %driveLabel%

echo Label:%driveLabel% is letter %driveLetter%
echo.
pause


:getDriveLetter
for /f %%D in ('wmic volume get DriveLetter^, Label ^| find "%~1"') do set driveLetter=%%D
goto:eof
