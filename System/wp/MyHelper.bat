@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
CLS
REM =====================================================================================
ECHO VERSION 1.1.0 - 14.12.2022
ECHO.
ECHO 0. Get and install Windows Updates
ECHO 1. Control SMB2 and SMB3 Protocol
ECHO 2. Check and change RDP Port
ECHO 3. Control ping to server
ECHO 4. Security Checks
ECHO 5. Windows Firewall Control
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
GOTO ControlRDPPort
)

IF /I '%INPUT%'=='3' (
GOTO ControlPING
)

IF /I '%INPUT%'=='4' (
GOTO SecurityChecks
)
IF /I '%INPUT%'=='5' (
GOTO WindowsFirewallControl
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
ECHO VERSION 1.1.0 - 14.12.2022
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
IF /I '%INPUT%'=='0' GOTO ControlSMB2SMB3_Disable
IF /I '%INPUT%'=='1' GOTO ControlSMB2SMB3_Enable
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
:ControlRDPPort
REM ECHO RDP Port
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO RDPPortNumber: "%RDPPortNumber%"
REM ====================================================================================
:ControlRDPPort_Change
CLS
TITLE Смена порта RDP
CLS
ECHO VERSION 1.1.0 - 14.12.2022
ECHO.
ECHO Для безопасности советую изменить номер порта RDP
ECHO Стандартный порт:3389
ECHO Текущий порт:"%RDPPortNumber%"
ECHO.
ECHO Подключаться нужно IP_ADDRESS:PORT
ECHO Используйте только цифры
ECHO.
ECHO Выберите требуемое действие
ECHO ===============================================================================
ECHO.
ECHO 0. Поменять RDP Port
ECHO 1. Продолжить без изменения
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
SET INPUT=
SET /p INPUT="Для подтверждения после ввода нажмите Enter :"
IF /I '%INPUT%'=='0' (
GOTO ControlRDPPort_RUN
)
IF /I '%INPUT%'=='1' (
GOTO ControlRDPPort_OK
)
IF /I '%INPUT%'=='B' GOTO STARTER
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Доступные варианты 0 или 1
ECHO Нажмите любую кнопку для повторного ввода
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE
GOTO ControlRDPPort_Change
:ControlRDPPort_RUN
CLS
ECHO Только цифры
SET /P newrdpport=Введите номер порта - любой четырехзначный порт:
ECHO Текущий порт:"%RDPPortNumber%" \ Выберите любой от 3000
ECHO.
REM ====================================================================================
ECHO Введённый новый порт: "%newrdpport%"
ECHO Нажмите любую кнопку для подтверждения
PAUSE
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d %newrdpport% /F
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO RDPPortNumber: "%RDPPortNumber%"
REM -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net stop termservice /y
net start termservice /y
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
:ControlRDPPort_OK
GOTO STARTER

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:ControlPING
CLS
ECHO VERSION 1.1.0 - 14.12.2022
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
ECHO VERSION 1.1.0 - 14.12.2022
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

:WindowsFirewallControl
CLS
ECHO VERSION 1.1.0 - 14.12.2022
ECHO.
ECHO SecurityChecks
ECHO.
ECHO 0. Restore Default Windows Firewall Setting
ECHO 1. Windows Firewall Mini Setup
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO WindowsFirewallControl_Default
IF /I '%INPUT%'=='1' GOTO WindowsFirewallControl_MiniSetup
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

:ControlSMB2SMB3_Disable
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 0 -Force"
sc.exe config mrxsmb20 start= disabled
net stop mrxsmb20
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
TIMEOUT 5
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT

:ControlSMB2SMB3_Enable
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 1 -Force"
sc.exe config mrxsmb20 start= auto
net start mrxsmb20
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
TIMEOUT 5
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT

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

:WindowsFirewallControl_Default
cls
IF NOT EXIST "C:\Service\TEMP\Firewall\" MD "C:\Service\TEMP\Firewall\"
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\Firewall\ -o firewall-rules-default.wfw "https://github.com/Antontyt/WindowsServerSecurity/blob/main/Settings/Windows/Firewall/firewall-rules-default.wfw"
TIMEOUT 5
netsh advfirewall import "C:\Service\TEMP\Firewall\firewall-rules-default.wfw"
ECHO WindowsFirewallControl Restore Default Done - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:WindowsFirewallControl_MiniSetup
cls
ECHO WindowsFirewallControl Restore MiniSetup Done - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:QUIT
EXIT