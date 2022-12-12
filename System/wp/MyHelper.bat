@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
CLS
REM =====================================================================================
ECHO VERSION 1.0.6 - 12.12.2022
ECHO.
ECHO 0. Get and install Windows Updates
ECHO 1. Control SMB2 and SMB3 Protocol
ECHO 2. Control SMB1 Protocol
ECHO 3. Control ping to server
ECHO 4. Security Checks
ECHO.
ECHO =================================================================
ECHO Для подтверждения нажмите ENTER
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 4 для выбора или Q для выхода из программы:

IF /I '%INPUT%'=='0' (
GOTO WindowsUpdates
)

IF /I '%INPUT%'=='1' (
GOTO ControlSMB2SMB3
)

IF /I '%INPUT%'=='2' (
GOTO ControlSMB1
)

IF /I '%INPUT%'=='3' (
GOTO ControlPING
)

IF /I '%INPUT%'=='4' (
GOTO SecurityChecks
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

REM =====================================================================================
REM /////////////////////////////////////////////////////////////////////////////////////
REM =====================================================================================
:ControlSMB2SMB3
CLS
ECHO VERSION 1.0.6 - 12.12.2022
ECHO.
ECHO Control SMB2 and SMB3
ECHO.
ECHO 0. Disable SMB2 and SMB3
ECHO 1. Enable SMB2 and SMB3
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO Disable_SMB2_SMB3
IF /I '%INPUT%'=='1' GOTO Enable_SMB2_SMB3
IF /I '%INPUT%'=='B' GOTO STARTER
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выберите параметр из списка
ECHO Меню [0-1] или нажмите 'B' для возврата назад.
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE > NUL
GOTO ControlSMB2SMB3

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:ControlSMB1
CLS
ECHO VERSION 1.0.6 - 12.12.2022
ECHO.
ECHO Control SMB1
ECHO.
ECHO 0. Disable SMB1
ECHO 1. Enable SMB1
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO Disable_SMB1
IF /I '%INPUT%'=='1' GOTO Enable_SMB1
IF /I '%INPUT%'=='B' GOTO STARTER
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выберите параметр из списка
ECHO Меню [0-1] или нажмите 'B' для возврата назад.
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE > NUL
GOTO ControlSMB1

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:ControlPING
CLS
ECHO VERSION 1.0.6 - 12.12.2022
ECHO.
ECHO Control PING - Recomened Disable PING
ECHO.
ECHO 0. Disable ICMP PING
ECHO 1. Enable ICMP PING
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO Disable_PING
IF /I '%INPUT%'=='1' GOTO Enable_PING
IF /I '%INPUT%'=='B' GOTO STARTER
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выберите параметр из списка
ECHO Меню [0-1] или нажмите 'B' для возврата назад.
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE > NUL
GOTO ControlPING

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:SecurityChecks
CLS
ECHO VERSION 1.0.6 - 12.12.2022
ECHO.
ECHO SecurityChecks
ECHO.
ECHO 0. Script Get-Badname
ECHO 1. Script Get-Bruteforce
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO SecurityChecks_Badname
IF /I '%INPUT%'=='1' GOTO SecurityChecks_Bruteforce
IF /I '%INPUT%'=='B' GOTO STARTER
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выберите параметр из списка
ECHO Меню [0-1] или нажмите 'B' для возврата назад.
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE > NUL
GOTO SecurityChecks

REM =====================================================================================
REM /////////////////////////////////////////////////////////////////////////////////////
REM =====================================================================================
:WindowsUpdates
REM Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

REM Get Windows Updates
cscript /Nologo "C:\Service\WindowsUpdateInstall_Auto.vbs"
ECHO WindowsUpdates END - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Disable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 0 -Force"
sc.exe config mrxsmb20 start= disabled
net stop mrxsmb20
cls
ECHO Disable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 1 -Force"
sc.exe config mrxsmb20 start= auto
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
net start mrxsmb20
cls
ECHO Enable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Disable_SMB1
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
cls
ECHO Disable_SMB1 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_SMB1
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $true -Force"
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

:SecurityChecks_Badname
CLS
ECHO SecurityChecks_Badname
ECHO.
powershell.exe -File "C:\Service\Software\PowershellScripts\Get-Badname.ps1"
PAUSE
GOTO STARTER

:SecurityChecks_Bruteforce
CLS
ECHO SecurityChecks_Bruteforce
ECHO.
powershell.exe -File "C:\Service\Software\PowershellScripts\Get-Bruteforce.ps1"
PAUSE
GOTO STARTER

:QUIT
EXIT