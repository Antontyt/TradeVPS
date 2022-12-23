IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\" MD C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\
IF NOT EXIST "C:\Program Files\Servilon\SLMF\ServiceLogonMultifactor.exe" (
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.msi "https://github.com/Antontyt/ServiceLogonMultifactor/raw/master/downloadAll/ServiceLogonMultiFactor.msi"
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.ini "https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/ServiceLogonMultiFactor.ini"
msiexec.exe /i "C:\Windows\TEMP\WindowsServerSecurity\ServiceLogonMultiFactor\ServiceLogonMultiFactor.msi" /qn
)
FOR /F "tokens=3" %%a IN ('reg query "HKLM\SYSTEM\CONTROLSET001\CONTROL\NLS\language" /v Installlanguage ^| find "Installlanguage"') DO set Installlanguage=%%a
IF NOT EXIST "C:\Program Files\Servilon\SLMF\Service.Config.xml" (
ECHO Copy Simple Config for SLMF Service
echo User Display Language: %Installlanguage% 
REM 0419 - RURU
REM https://raw.githubusercontent.com/Antontyt/ServiceLogonMultifactor/master/downloadAll/ConsoleReadTelegramBot.exe
)
PAUSE