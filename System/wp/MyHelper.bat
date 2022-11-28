@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
CLS
REM =====================================================================================
ECHO VERSION 1.0.4 - 28.11.2022
ECHO.
ECHO 0. Get and install Windows Updates
ECHO 1. Disable SMB2 and SMB3 Protocol
ECHO 2. Enable SMB2 and SMB3 Protocol
ECHO 3. Disable SMB1 Protocol
ECHO 4. Enable SMB1 Protocol
ECHO 5. Disable ping to server
ECHO 6. Enable ping to server
ECHO.
ECHO Для подтврждения нажмите ENTER
ECHO.

SET INPUT=
SET /P INPUT=Числа от 0 до 3 для выбора или Q для выхода из программы:

IF /I '%INPUT%'=='0' (
GOTO WindowsUpdates
)
IF /I '%INPUT%'=='1' (
GOTO Disable_SMB2_SMB3
)
IF /I '%INPUT%'=='2' (
GOTO Enable_SMB2_SMB3
)
IF /I '%INPUT%'=='3' (
GOTO Disable_SMB1
)
IF /I '%INPUT%'=='4' (
GOTO Enable_SMB1
)
IF /I '%INPUT%'=='5' (
GOTO Disable_PING
)
IF /I '%INPUT%'=='6' (
GOTO Enable_PING
)
IF /I '%INPUT%'=='Q' GOTO Quit
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выберите параметр из списка
ECHO Меню [0-4] или нажмите 'Q' для выхода из программы.
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE > NUL
GOTO STARTER
PAUSE
REM =====================================================================================


:WindowsUpdates
REM Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

REM Get Windows Updates
cscript /Nologo "C:\Security\WindowsUpdateInstall_Auto.vbs"
ECHO WindowsUpdates END - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Disable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false"
cls
ECHO Disable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $true"
cls
ECHO Enable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Disable_SMB1
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false"
cls
ECHO Disable_SMB1 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_SMB1
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $true"
cls
ECHO Enable_SMB1 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Disable_PING
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv4'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv6'"
cls
ECHO Disable_PING - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_PING
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv4'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv6'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName 'Allow inbound ICMPv4' -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName 'Allow inbound ICMPv6' -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow"
cls
ECHO Enable_PING - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:QUIT
EXIT