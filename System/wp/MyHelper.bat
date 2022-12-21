@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
CLS
REM =====================================================================================
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO Current RDP Port: "%RDPPortNumber%"
ECHO =================================================================
ECHO VERSION 1.1.8 - 22.12.2022
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
ECHO VERSION 1.1.8 - 22.12.2022
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
IF /I '%INPUT%'=='0' (
GOTO SMB_Disable
)
IF /I '%INPUT%'=='1' (
GOTO SMB_Enable
)
IF /I '%INPUT%'=='B' (
GOTO STARTER
)
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
ECHO VERSION 1.1.8 - 22.12.2022
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
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
net stop termservice /y
net start termservice /y
:ControlRDPPort_OK
GOTO STARTER

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:ControlPING
CLS
ECHO VERSION 1.1.8 - 22.12.2022
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
ECHO VERSION 1.1.8 - 22.12.2022
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
ECHO VERSION 1.1.8 - 22.12.2022
ECHO.
ECHO SecurityChecks
ECHO.
ECHO 0. Block In and Out Only
ECHO 1. Block In Only
ECHO.
ECHO =================================================================
ECHO B. Для возврата назад
ECHO.
 
SET INPUT=
SET /P INPUT=Числа от 0 до 1 для выбора или B для возврата обратно:
IF /I '%INPUT%'=='0' GOTO WindowsFirewallControl_BlockOut
IF /I '%INPUT%'=='1' GOTO WindowsFirewallControl_BlockInOnly
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
CLS
ECHO WindowsUpdates
REM Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

REM Get Windows Updates
cscript /Nologo "C:\Service\WindowsUpdateInstall_Auto.vbs"
ECHO WindowsUpdates END - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:SMB_Disable
CLS
ECHO SMB_Disable
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 0 -Force"
sc.exe config mrxsmb20 start= disabled
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=yes
net stop mrxsmb20 /y
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
TIMEOUT 5
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT

:SMB_Enable
CLS
ECHO SMB_Enable
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 1 -Force"
sc.exe config mrxsmb20 start= auto
net start mrxsmb20 /y
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=no
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
TIMEOUT 5
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT

:Disable_PING
CLS
ECHO Disable_PING
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv4'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'Allow inbound ICMPv6'"
cls
ECHO Disable_PING - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_PING
CLS
ECHO Enable_PING
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
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Service\Software\PowershellScripts\Get-Badname.ps1"
PAUSE
GOTO STARTER

:SecurityChecks_Bruteforce
CLS
ECHO SecurityChecks_Bruteforce
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Service\Software\PowershellScripts\Get-Bruteforce.ps1"
PAUSE
GOTO STARTER

:WindowsFirewallControl_BlockInOnly
cls
ECHO WindowsFirewallControl_BlockInOnly
REM Reset rules for default settings
netsh advfirewall reset
TIMEOUT 2
netsh advfirewall set Domainprofile state on
netsh advfirewall set Privateprofile state on
netsh advfirewall set Publicprofile state on
REM Configure Windows Firewall
netsh advfirewall set Domainprofile firewallpolicy blockinbound,allowoutbound
netsh advfirewall set Privateprofile firewallpolicy blockinbound,allowoutbound
netsh advfirewall set Publicprofile firewallpolicy blockinbound,allowoutbound
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
netsh advfirewall firewall add rule name="MozillaFirefox" dir=out action=allow program="C:\Program Files\Mozilla Firefox\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLab.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLabApp.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLabApp.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLabAppW.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLabAppW.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - createdump.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\createdump.exe" enable=yes
netsh advfirewall firewall add rule name="Curl" dir=out action=allow program="C:\Service\System\curl\curl.exe" enable=yes
netsh advfirewall firewall add rule name="D4Time" dir=out action=allow program="C:\Program Files (x86)\D4\D4.exe" enable=yes
netsh advfirewall firewall add rule name="NotepadPlus" dir=out action=allow program="C:\Program Files (x86)\Notepad++\notepad++.exe" enable=yes
netsh advfirewall firewall add rule name="NotepadPlusUpdater" dir=out action=allow program="C:\Program Files (x86)\Notepad++\updater\updater.exe" enable=yes
netsh advfirewall firewall add rule name="WindowsDefender" dir=out action=allow program="C:\Program Files (x86)\Windows Defender\MpCmdRun.exe" enable=yes
netsh advfirewall firewall add rule name="Simplewall" dir=out action=allow program="C:\Program Files\simplewall\simplewall.exe" enable=yes
netsh advfirewall set currentprofile logging filename %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall set currentprofile logging maxfilesize 4096
netsh advfirewall set currentprofile logging droppedconnections enable
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=No
netsh advfirewall firewall set rule group="Work or school account" new enable=No
netsh advfirewall firewall set rule group="Start" new enable=No
netsh advfirewall firewall set rule group="Your account" new enable=No
netsh advfirewall firewall set rule group="Cast to Device functionality" new enable=No
netsh advfirewall firewall set rule group="@{Microsoft.Windows.Search_1.15.0.20348_neutral_neutral_cw5n1h2txyewy?ms-resource://Microsoft.Windows.Search/resources/PackageDisplayName}" new enable=No
netsh advfirewall firewall set rule group="Desktop App Web Viewer" new enable=No
netsh advfirewall firewall set rule group="DIAL protocol server" new enable=No
netsh advfirewall firewall set rule group="Microsoft Media Foundation Network Source" new enable=No
netsh advfirewall firewall set rule group="DiagTrack" new enable=No
netsh advfirewall firewall set rule group="Windows Device Management" new enable=No
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO Current RDP Port: "%RDPPortNumber%"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
REM TCP порт 135 - предназначенный для выполнения команд;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=135 name="Block1_TCP-135"
REM UDP порт 137 - с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=137 name="Block1_TCP-137"
REM TCP порт 138
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=138 name="Block1_TCP-138"
REM TCP порт 139 - необходимый для удаленного подключения и управления ПК;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=139 name="Block_TCP-139"
REM TCP порт 445 - Позволяющий быстро передавать файлы;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=445 name="Block_TCP-445"
sc stop lanmanserver
sc config lanmanserver start=disabled
REM TCP порт 5000
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=5000 name="Block_TCP-5000"
REM =========================================================================
netsh advfirewall firewall set rule name="Core Networking - Destination Unreachable (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Done (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Query (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report v2 (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Packet Too Big (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Parameter Problem (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Time Exceeded (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - IPv6 (IPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Dynamic Host Configuration Protocol for IPv6(DHCPV6-In)" new enable=no
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=yes
REM =========================================================================
TIMEOUT 5
ECHO WindowsFirewallControl Restore Default Done - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:WindowsFirewallControl_BlockOut
cls
ECHO WindowsFirewallControl_BlockOut
REM Reset rules for default settings
netsh advfirewall reset
TIMEOUT 2
netsh advfirewall set Domainprofile state on
netsh advfirewall set Privateprofile state on
netsh advfirewall set Publicprofile state on
REM Configure Windows Firewall
netsh advfirewall set Domainprofile firewallpolicy blockinbound,blockoutbound
netsh advfirewall set Privateprofile firewallpolicy blockinbound,blockoutbound
netsh advfirewall set Publicprofile firewallpolicy blockinbound,blockoutbound
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
netsh advfirewall firewall add rule name="MozillaFirefox" dir=out action=allow program="C:\Program Files\Mozilla Firefox\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLab.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLabApp.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLabApp.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - TSLabAppW.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\TSLabAppW.exe" enable=yes
netsh advfirewall firewall add rule name="TSLab version2.2 - createdump.exe" dir=out action=allow program="C:\Program Files\TSLab\TSLab 2.2\createdump.exe" enable=yes
netsh advfirewall firewall add rule name="Curl" dir=out action=allow program="C:\Service\System\curl\curl.exe" enable=yes
netsh advfirewall firewall add rule name="D4Time" dir=out action=allow program="C:\Program Files (x86)\D4\D4.exe" enable=yes
netsh advfirewall firewall add rule name="NotepadPlus" dir=out action=allow program="C:\Program Files (x86)\Notepad++\notepad++.exe" enable=yes
netsh advfirewall firewall add rule name="NotepadPlusUpdater" dir=out action=allow program="C:\Program Files (x86)\Notepad++\updater\updater.exe" enable=yes
netsh advfirewall firewall add rule name="WindowsDefender" dir=out action=allow program="C:\Program Files (x86)\Windows Defender\MpCmdRun.exe" enable=yes
netsh advfirewall firewall add rule name="Simplewall" dir=out action=allow program="C:\Program Files\simplewall\simplewall.exe" enable=yes
netsh advfirewall set currentprofile logging filename %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall set currentprofile logging maxfilesize 4096
netsh advfirewall set currentprofile logging droppedconnections enable
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=No
netsh advfirewall firewall set rule group="Work or school account" new enable=No
netsh advfirewall firewall set rule group="Start" new enable=No
netsh advfirewall firewall set rule group="Your account" new enable=No
netsh advfirewall firewall set rule group="Cast to Device functionality" new enable=No
netsh advfirewall firewall set rule group="@{Microsoft.Windows.Search_1.15.0.20348_neutral_neutral_cw5n1h2txyewy?ms-resource://Microsoft.Windows.Search/resources/PackageDisplayName}" new enable=No
netsh advfirewall firewall set rule group="Desktop App Web Viewer" new enable=No
netsh advfirewall firewall set rule group="DIAL protocol server" new enable=No
netsh advfirewall firewall set rule group="Microsoft Media Foundation Network Source" new enable=No
netsh advfirewall firewall set rule group="DiagTrack" new enable=No
netsh advfirewall firewall set rule group="Windows Device Management" new enable=No
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO Current RDP Port: "%RDPPortNumber%"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
REM TCP порт 135 - предназначенный для выполнения команд;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=135 name="Block1_TCP-135"
REM UDP порт 137 - с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=137 name="Block1_TCP-137"
REM TCP порт 138
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=138 name="Block1_TCP-138"
REM TCP порт 139 - необходимый для удаленного подключения и управления ПК;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=139 name="Block_TCP-139"
REM TCP порт 445 - Позволяющий быстро передавать файлы;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=445 name="Block_TCP-445"
sc stop lanmanserver
sc config lanmanserver start=disabled
REM TCP порт 5000
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=5000 name="Block_TCP-5000"
REM =========================================================================
netsh advfirewall firewall set rule name="Core Networking - Destination Unreachable (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Done (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Query (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report v2 (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Packet Too Big (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Parameter Problem (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Time Exceeded (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - IPv6 (IPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Dynamic Host Configuration Protocol for IPv6(DHCPV6-In)" new enable=no
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=yes
REM =========================================================================
ECHO WindowsFirewallControl Restore MiniSetup Done - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:QUIT
EXIT