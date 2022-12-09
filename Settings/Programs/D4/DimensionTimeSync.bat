@echo off
chcp 866> nul
REM Dimension4 TimeSync
ECHO Dimension4 TimeSync
IF EXIST "C:\Program Files (x86)\D4\D4.exe" GOTO CONFIG
REM IF NOT EXIST "" (
REM RMDIR /S /Q "C:\Program Files (x86)\D4"
REM )
IF NOT EXIST "C:\Service\TEMP\app\" MD C:\Service\TEMP\app\
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o d4time531.msi "http://www.thinkman.com/dimension4/d4time531.msi"
timeout 5
msiexec /i "C:\Service\TEMP\app\d4time531.msi" /QN /L*V "C:\Service\TEMP\d4time531.log"

:CONFIG
REM Dimension4
w32tm /unregister
net stop w32tm
sc config w32time start= disabled
net stop tzautoupdate
sc config tzautoupdate start= disabled
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /d "NoSync" /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v Start /t REG_DWORD /d 3 /F
net stop Dimension4
XCOPY /I /Z /Y "C:\Windows\Temp\Service\D4\server.dat" "C:\Program Files (x86)\D4\"
net start Dimension4

:END