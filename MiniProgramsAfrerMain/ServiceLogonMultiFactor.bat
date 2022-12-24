IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\" MD C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\
IF NOT EXIST "C:\Program Files\Servilon\SLMF\ServiceLogonMultifactor.exe" (
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.msi "https://github.com/Antontyt/ServiceLogonMultifactor/raw/master/downloadAll/ServiceLogonMultiFactor.msi"
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.ini "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/ServiceLogonMultiFactor.ini"
msiexec.exe /i "C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.msi" /qn
netsh advfirewall firewall add rule name="ServiceLogonMultifactor" dir=out action=allow program="C:\Program Files\Servilon\SLMF\ServiceLogonMultifactor.exe" enable=yes
)
FOR /F "tokens=3" %%a IN ('reg query "HKLM\SYSTEM\CONTROLSET001\CONTROL\NLS\language" /v Installlanguage ^| find "Installlanguage"') DO set Installlanguage=%%a
IF EXIST "C:\Program Files\Servilon\SLMF\Service.Config.xml" GOTO AFTERCONFIG
IF "%Installlanguage%"=="0419" (
ECHO Copy Simple Config for SLMF Service
echo User Display Language: %Installlanguage% 
REM 0419 - RURU
"C:\Service\System\curl\curl.exe" -L --output "C:\Program Files\Servilon\SLMF\Service.Config.xml" "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/Service.Config_ru.xml"
"C:\Service\System\curl\curl.exe" -O --output-dir "C:\Program Files\Servilon\SLMF\" "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/ConsoleReadTelegramBot.exe"
) 
IF NOT EXIST "C:\Program Files\Servilon\SLMF\Service.Config.xml" (
ECHO Copy Simple Config for SLMF Service
echo User Display Language: %Installlanguage% 
REM 0419 - RURU
"C:\Service\System\curl\curl.exe" -L --output "C:\Program Files\Servilon\SLMF\Service.Config.xml" "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/Service.Config.xml"
"C:\Service\System\curl\curl.exe" -O --output-dir "C:\Program Files\Servilon\SLMF\" "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/ConsoleReadTelegramBot.exe"
)
:AFTERCONFIG
sc stop "ServiceLogonMultifactor"
sc start "ServiceLogonMultifactor"