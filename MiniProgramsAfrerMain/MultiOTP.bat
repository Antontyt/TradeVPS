@ECHO OFF
REM 1.0 - Create
REM 1.1 - Change multiOTP Credential Provider
REM 1.2 - Silent Setup
REM 1.3 - Check Visual++ Library
REM ==================================================================================================
REM Сервис http://www.multiotp.net
REM Модуль OTP для Windows - https://github.com/multiOTP/multiOTPCredentialProvider

IF EXIST "C:\Windows\Temp\WindowsServerSecurity\MultiOTP" RMDIR /S /Q "C:\Windows\Temp\WindowsServerSecurity\MultiOTP"
IF NOT EXIST "C:\Windows\Temp\WindowsServerSecurity\MultiOTP" MD "C:\Windows\Temp\WindowsServerSecurity\MultiOTP"
:DOWNLOADAGAIN1
"C:\Service\System\curl\curl.exe" -C - --output-dir C:\Windows\Temp\WindowsServerSecurity\MultiOTP\ -o multiotp.zip "https://download.multiotp.net/multiotp.zip"
set "var=%errorlevel%"
ECHO ERRORLVEL:"%var%"
IF "%var%" NEQ "0" (
GOTO DOWNLOADAGAIN1
)
timeout 2
:DOWNLOADAGAIN2
"C:\Service\System\curl\curl.exe" -C - -L --output-dir C:\Windows\Temp\WindowsServerSecurity\MultiOTP\ -o MultiOneTimePasswordCredentialProvider.zip "https://github.com/multiOTP/multiOTPCredentialProvider/releases/download/5.9.4.0/multiOTPCredentialProvider-5.9.4.0.zip"
set "var=%errorlevel%"
ECHO ERRORLVEL:"%var%"
IF "%var%" NEQ "0" (
GOTO DOWNLOADAGAIN2
)
timeout 2
:DOWNLOADAGAIN3
"C:\Service\System\curl\curl.exe" -C - -L --output "C:\Windows\Temp\WindowsServerSecurity\MultiOTP\vc_redist.x86.exe" "https://aka.ms/vs/16/release/vc_redist.x86.exe"
set "var=%errorlevel%"
ECHO ERRORLVEL:"%var%"
IF "%var%" NEQ "0" (
GOTO DOWNLOADAGAIN3
)
:DOWNLOADAGAIN4
"C:\Service\System\curl\curl.exe" -C - -L --output "C:\Windows\Temp\WindowsServerSecurity\MultiOTP\vc_redist.x64.exe" "https://aka.ms/vs/16/release/vc_redist.x64.exe"
set "var=%errorlevel%"
ECHO ERRORLVEL:"%var%"
IF "%var%" NEQ "0" (
GOTO DOWNLOADAGAIN4
)
REM ==========================================================================================================================================================================================
:MicrosoftVisualX64
REM Check Microsoft Visual C++ 2019 X64
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7F4A9F52-173F-4B0D-B1EA-269C32EDA827}">NULL
if "%ERRORLEVEL%" NEQ "0" (
"C:\Windows\Temp\WindowsServerSecurity\MultiOTP\vc_redist.x64.exe" /Q
)
:MicrosoftVisualX86
REM Check Microsoft Visual C++ 2019 X86
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{1679EF65-55F3-4248-B91E-6B3BE1A69CDF}">NULL
if "%ERRORLEVEL%" NEQ "0" (
"C:\Windows\Temp\WindowsServerSecurity\MultiOTP\vc_redist.x86.exe" /Q
)
"C:\Program Files\7-Zip\7z.exe" t C:\Windows\Temp\WindowsServerSecurity\MultiOTP\multiotp.zip
ECHO multiotp.zip - ERRORLEVEL: "%ERRORLEVEL%"
"C:\Program Files\7-Zip\7z.exe" t C:\Windows\Temp\WindowsServerSecurity\MultiOTP\MultiOneTimePasswordCredentialProvider.zip
ECHO MultiOneTimePasswordCredentialProvider.zip - ERRORLEVEL: "%ERRORLEVEL%"
"C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\WindowsServerSecurity\MultiOTP\multiotp.zip -oC:\Windows\Temp\WindowsServerSecurity\MultiOTP\Unzip\MultiOTP\
"C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\WindowsServerSecurity\MultiOTP\MultiOneTimePasswordCredentialProvider.zip -oC:\Windows\Temp\WindowsServerSecurity\MultiOTP\Unzip\MultiOneTimePasswordCredentialProvider\
timeout 5
IF NOT EXIST "C:\ProgramData\MultiOTP\users\*.db" (
NET STOP "MultiOTPService"
NET STOP "MultiOTPradius"
RMDIR /S /Q "C:\ProgramData\MultiOTP"
)
IF NOT EXIST "C:\ProgramData\MultiOTP\users\*.db" (
ROBOCOPY "C:\Windows\Temp\WindowsServerSecurity\MultiOTP\Unzip\MultiOTP\windows" "C:\ProgramData\MultiOTP" /MIR /Z /R:5 /W:15
del /q "C:\ProgramData\MultiOTP\checkmultiotp.cmd"
del /q "C:\ProgramData\MultiOTP\radius_install.cmd"
del /q "C:\ProgramData\MultiOTP\radius_uninstall.cmd"
del /q "C:\ProgramData\MultiOTP\webservice_install.cmd"
del /q "C:\ProgramData\MultiOTP\webservice_uninstall.cmd"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/radius_install.cmd"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/radius_uninstall.cmd"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/webservice_install.cmd"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/webservice_uninstall.cmd"
)
IF NOT EXIST "C:\ProgramData\MultiOTP\multiotp.exe" (
ECHO FILE NOT EXIST "C:\ProgramData\MultiOTP\multiotp.exe"
PAUSE
EXIT
)
ECHO INSTALL WEB SERVER MULTIOTP
CALL "C:\ProgramData\MultiOTP\webservice_install.cmd"
timeout 15
"C:\ProgramData\MultiOTP\multiotp.exe" -config server-secret=secretOTP
"C:\ProgramData\MultiOTP\multiotp.exe" -config server-cache-level=1
"C:\ProgramData\MultiOTP\multiotp.exe" -config server-timeout=5
"C:\ProgramData\MultiOTP\multiotp.exe" -config ntp_server=time.google.com
"C:\ProgramData\MultiOTP\multiotp.exe" -config timezone=Europe/Minsk
NET STOP "MultiOTPService"
NET STOP "MultiOTPradius"
NET START "MultiOTPService"
NET START "MultiOTPradius"
timeout 5
msiexec /i "C:\Windows\Temp\WindowsServerSecurity\MultiOTP\Unzip\MultiOneTimePasswordCredentialProvider\multiOTPCredentialProviderInstaller.msi" /qn
timeout 15
IF NOT EXIST "C:\Program Files (x86)\multiOTP" (
ECHO CRITICAL ERROR - NOT EXIST multiOTPCredentialProviderInstaller
PAUSE
)
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config server-secret=secretOTP
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config server-cache-level=1
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config server-timeout=5
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config server-url=http://127.0.0.1:8112
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config ntp_server=time.google.com
"C:\Program Files (x86)\multiOTP\multiotp.exe" -config timezone=Europe/Minsk
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/MultiOTPLocalSettings.reg"
regedit /s "C:\ProgramData\MultiOTP\MultiOTPLocalSettings.reg"
PAUSE