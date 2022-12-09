@echo off
chcp 866> nul
REM NTP
REM https://www.meinbergglobal.com/english/sw/ntp.htm
ECHO NTP
IF EXIST "C:\Program Files (x86)\NTP\ntpd.exe" GOTO END
IF EXIST "C:\Windows\Temp\Service\ntp\" RMDIR /S /Q "C:\Windows\Temp\Service\ntp\"
IF NOT EXIST "C:\Windows\Temp\Service\ntp\" MD C:\Windows\Temp\Service\ntp\
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ECHO Change Windows Settings
w32tm /unregister
net stop w32tm
sc config w32time start= disabled
net stop tzautoupdate
sc config tzautoupdate start= disabled
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /d "NoSync" /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v Start /t REG_DWORD /d 3 /F
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net stop ntp
TASKKILL /IM mmc.exe /F /T
TASKKILL /IM ntpd.exe /F /T
RMDIR /S /Q "C:\Program Files (x86)\NTP"
DEL /Q "C:\Windows\Temp\Service\ntp\ntp.conf"
DEL /Q "C:\Program Files (x86)\NTP\etc\ntp.conf"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\Temp\Service\ntp\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/NTP/ntp.conf"
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\Temp\Service\ntp\ -o NTPinstall.exe "https://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.8p15-v2-win32-setup.exe"
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\Temp\Service\ntp\ -o ntpinstall_settings.ini "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/NTP/ntpinstall_settings.ini"
timeout 5
IF EXIST "C:\Windows\Temp\Service\ntp\NTPinstall.exe" (
CALL "C:\Windows\Temp\Service\ntp\NTPinstall.exe" /USE_FILE=C:\Windows\Temp\Service\ntp\ntpinstall_settings.ini
timeout 5
XCOPY /I /Z /Y "C:\Windows\Temp\Service\ntp\ntp.conf" "C:\Program Files (x86)\NTP\etc\"
)
echo Trying to stop NTP service:
net stop ntp
REM Insert a delay ...
echo Wait 10 seconds before restart ...
ping -n 10 127.0.0.1 > NUL
echo Trying to restart NTP service:
net start ntp
:END