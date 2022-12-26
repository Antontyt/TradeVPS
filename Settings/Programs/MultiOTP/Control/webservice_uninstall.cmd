@ECHO OFF
REM VERSION 1.0
SET _service_tag=multiOTPservice

IF NOT "%1"=="" SET _service_tag=%1

REM Define the current folder
SET _folder=C:\ProgramData\MultiOTP\
SET _web_folder=C:\ProgramData\MultiOTP\
REM IF NOT EXIST %_web_folder%webservice SET _web_folder=%~d0%~p0..\

netsh firewall delete allowedprogram "%_folder%webservice\nginx.exe" >NUL
netsh advfirewall firewall delete rule name="%_service_tag%" >NUL

SC queryex type= service state= all | FIND "%_service_tag%" >NUL
IF ERRORLEVEL 1 GOTO NoService
ECHO Stop and remove the service %_service_tag%
"%_web_folder%webservice\nssm" stop "%_service_tag%" >NUL
"%_web_folder%webservice\nssm" remove "%_service_tag%" confirm >NUL
:NoService

TASKLIST | FIND "php-cgi.exe" >NUL
IF NOT ERRORLEVEL 1 TASKKILL /F /IM php-cgi.exe >NUL

SET _folder=
SET _web_folder=
