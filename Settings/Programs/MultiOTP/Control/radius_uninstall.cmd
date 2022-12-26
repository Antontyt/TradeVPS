@ECHO OFF
REM VERSION 1.0
SET _service_tag=multiOTPradius

IF NOT "%1"=="" SET _service_tag=%1

SET _folder=C:\ProgramData\MultiOTP\
SET _radius_folder=C:\ProgramData\MultiOTP\
IF NOT EXIST %_radius_folder%radius SET _radius_folder=%~d0%~p0.			.\

netsh firewall delete allowedprogram "%_radius_folder%radius\sbin\radiusd.exe" >NUL
netsh advfirewall firewall delete rule name="multiOTP Radius server" >NUL

SC queryex type= service state= all | FIND "%_service_tag%" >NUL
IF ERRORLEVEL 1 GOTO NoService
ECHO Stop and remove the service %_service_tag%
SC stop %_service_tag% >NUL
SC delete %_service_tag% >NUL
:NoService

SET _folder=
SET _radius_folder=
