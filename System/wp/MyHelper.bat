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
ECHO VERSION 1.2.5 - 08.01.2023
ECHO.
ECHO 0. Get and install Windows Updates
ECHO 1. Control SMB2 and SMB3 Protocol
ECHO 2. Check and change RDP Port
ECHO 3. Control ping to server
ECHO 4. Security Checks
ECHO 5. Windows Firewall Control
IF NOT EXIST "C:\Program Files (x86)\multiOTP\multiotp.exe" (
ECHO 6. Install MFA OTP Login
) ELSE (
ECHO 7. Remove MFA OTP Login
ECHO 8. Open OTP Login Web Page
)
IF NOT EXIST "C:\Program Files\OpenSSH" (
ECHO 9. Install OpenSSH Server
)
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
IF NOT EXIST "C:\Program Files (x86)\multiOTP\multiotp.exe" (
IF /I '%INPUT%'=='6' (
GOTO InstallMFAOTPLogin
)
) ELSE (
IF /I '%INPUT%'=='7' (
GOTO RemoveMFAOTPLogin
)
IF /I '%INPUT%'=='8' (
GOTO MFAOTPLoginWeb
)
)
IF NOT EXIST "C:\Program Files\OpenSSH" (
IF /I '%INPUT%'=='9' (
GOTO OpenSSHServerInstall
)
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
ECHO VERSION 1.2.5 - 08.01.2023
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
ECHO VERSION 1.2.5 - 08.01.2023
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
REM #Check "Remote Desktop - User Mode (TCP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-TCP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-TCP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=tcp
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
    ) ELSE (
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
        ECHO Rule already exists
)
REM #Check "Remote Desktop - User Mode (UDP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-UDP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-UDP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=udp
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
    ) ELSE (
        ECHO Rule already exists
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
)
net stop termservice /y
net start termservice /y
:ControlRDPPort_OK
GOTO STARTER

REM ============================================================================
REM ////////////////////////////////////////////////////////////////////////////
:ControlPING
CLS
ECHO VERSION 1.2.5 - 08.01.2023
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
ECHO VERSION 1.2.5 - 08.01.2023
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
ECHO VERSION 1.2.5 - 08.01.2023
ECHO.
ECHO SecurityChecks
ECHO.
ECHO 0. Only Allowed programs In and Out
ECHO 1. Only Allowed programs In and Allow All Out
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
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetAdapterBinding -Name * -DisplayName 'File and Printer Sharing for Microsoft Networks'"
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
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Enable-NetAdapterBinding -Name * -DisplayName 'File and Printer Sharing for Microsoft Networks'"
sc.exe config mrxsmb20 start= auto
net start mrxsmb20 /y
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=allow enable=yes
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

:InstallMFAOTPLogin
CLS
ECHO InstallMFAOTPLogin
CALL "C:\Service\Test\MultiOTP.bat"
ECHO Настройте учётные записи пользователей для MFA OTP - http://127.0.0.1:8112
PAUSE
GOTO STARTER

:RemoveMFAOTPLogin
CLS
ECHO RemoveMFAOTPLogin
ECHO Нажмите любую кнопку для подтверждения удаления MultiOTP
PAUSE
IF EXIST "C:\ProgramData\MultiOTP" (
"C:\Service\System\curl\curl.exe" -O --output-dir C:\ProgramData\MultiOTP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/MultiOTP/Control/webservice_uninstall.cmd"
ECHO INSTALL WEB SERVER MULTIOTP
CALL "C:\ProgramData\MultiOTP\webservice_uninstall.cmd"
timeout 5
NET STOP "MultiOTPService"
NET STOP "MultiOTPradius"
RMDIR /S /Q "C:\ProgramData\MultiOTP"
)
ECHO Remove MultiOTP Provider
MsiExec.exe /x {2868DCFB-1A39-47FA-9B74-398B43C56875} /qn
timeout 5
IF EXIST "C:\Program Files (x86)\multiOTP" (
RMDIR /S /Q "C:\Program Files (x86)\multiOTP"
)
REG DELETE "HKEY_CLASSES_ROOT\CLSID\{FCEFDFAB-B0A1-4C4D-8B2B-4FF4E0A3D978}" /F
GOTO STARTER

:MFAOTPLoginWeb
start "C:\Program Files\Mozilla Firefox\firefox.exe" "http://127.0.0.1:8112"
GOTO STARTER

:OpenSSHServerInstall
cls
ECHO OpenSSHServerInstall
REM # Uninstall the OpenSSH Client
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0"
REM # Uninstall the OpenSSH Server
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"

REM Install OpenSSH
IF NOT EXIST "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\" MD "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\"
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\Temp\WindowsServerSecurity\OpenSSH\OpenSSH-Win64-v9.1.0.0.msi "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.1.0.0p1-Beta/OpenSSH-Win64-v9.1.0.0.msi"
msiexec /i "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\OpenSSH-Win64-v9.1.0.0.msi" /qn
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-Item -Type File -Path C:\ProgramData\ssh\administrators_authorized_keys"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force"
"C:\Service\System\curl\curl.exe" -L --output C:\ProgramData\ssh\sshd_config "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/OpenSSH/sshd_config"
netsh advfirewall firewall add rule name="OpenSSH SSH Server (sshd)" dir=in action=allow program="C:\Windows\System32\OpenSSH\sshd.exe" protocol=TCP localport=23 enable=yes
ECHO AFTEROpenSSHInstall
ECHO SSH KEY GENERATOR
"C:\Program Files\OpenSSH\ssh-keygen.exe" -t ed25519 -f C:\ProgramData\ssh\ssh_host_secret_ed25519_key
"C:\Program Files\OpenSSH\ssh-add.exe" -k "C:\ProgramData\ssh\ssh_host_secret_ed25519_key"
ECHO OpenSSHServerInstall Done - PRESS ANY BUTTON FOR NEXT
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
netsh advfirewall firewall add rule name="WinGup for Notepad++ (gup.exe)" dir=out action=allow program="C:\program files (x86)\notepad++\updater\gup.exe" protocol=TCP enable=yes
netsh advfirewall firewall add rule name="Windows Update" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=TCP remoteport=80,443 enable=yes
netsh advfirewall firewall add rule name="Windows Time Service" dir=out action=block program="C:\Windows\system32\svchost.exe" protocol=UDP remoteport=123 enable=yes
netsh advfirewall firewall add rule name="Core Networking - DNS (UDP-Out)" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=UDP remoteport=53 enable=yes
netsh advfirewall firewall add rule name="Core Networking - Dynamic Host Configuration Protocol (DHCP-Out)" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=UDP localport=68 remoteport=67 enable=yes
netsh advfirewall firewall add rule name="Simplewall" dir=out action=allow program="C:\Program Files\simplewall\simplewall.exe" enable=yes
netsh advfirewall firewall add rule name="OpenSSH SSH Server (sshd)" dir=in action=allow program="C:\Windows\System32\OpenSSH\sshd.exe" protocol=TCP localport=23 enable=yes
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
REM RDP SSL Settings
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEncryptRPCTraffic /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v SecurityLayer /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v UserAuthentication /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MinEncryptionLevel /t REG_DWORD /d 5 /f
REM #Check "Remote Desktop - User Mode (TCP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-TCP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-TCP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=tcp
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
    ) ELSE (
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
        ECHO Rule already exists
)
REM #Check "Remote Desktop - User Mode (UDP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-UDP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-UDP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=udp
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
    ) ELSE (
        ECHO Rule already exists
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
)
REM TCP порт 135 - предназначенный для выполнения команд;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=135 name="Block_TCP-135"
REM UDP порт 137 - с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=137 name="Block_TCP-137"
REM TCP порт 138
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=138 name="Block_TCP-138"
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
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=no
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
netsh advfirewall firewall add rule name="WinGup for Notepad++ (gup.exe)" dir=out action=allow program="C:\program files (x86)\notepad++\updater\gup.exe" protocol=TCP enable=yes
netsh advfirewall firewall add rule name="Windows Update" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=TCP remoteport=80,443 enable=yes
netsh advfirewall firewall add rule name="Windows Time Service" dir=out action=block program="C:\Windows\system32\svchost.exe" protocol=UDP remoteport=123 enable=yes
netsh advfirewall firewall add rule name="Core Networking - DNS (UDP-Out)" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=UDP remoteport=53 enable=yes
netsh advfirewall firewall add rule name="Core Networking - Dynamic Host Configuration Protocol (DHCP-Out)" dir=out action=allow program="C:\Windows\system32\svchost.exe" protocol=UDP localport=68 remoteport=67 enable=yes
netsh advfirewall firewall add rule name="Simplewall" dir=out action=allow program="C:\Program Files\simplewall\simplewall.exe" enable=yes
netsh advfirewall firewall add rule name="OpenSSH SSH Server (sshd)" dir=in action=allow program="C:\Windows\System32\OpenSSH\sshd.exe" protocol=TCP localport=23 enable=yes
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
REM #Check "Remote Desktop - User Mode (TCP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-TCP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-TCP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=tcp
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
    ) ELSE (
		PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
        ECHO Rule already exists
)
REM #Check "Remote Desktop - User Mode (UDP-In)"
netsh advfirewall firewall show rule name="NewRDPPort-UDP-In" > NUL 2>&1
IF ERRORLEVEL 1 (
        REM netsh.exe advfirewall firewall add rule name="NewRDPPort-UDP-In" dir=in action=allow program="%%SystemRoot%%\system32\svchost.exe" service="TermService" enable=yes profile=ALL localport=%RDPPortNumber% protocol=udp
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
    ) ELSE (
        ECHO Rule already exists
        PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
)
REM TCP порт 135 - предназначенный для выполнения команд;
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=135 name="Block_TCP-135"
REM UDP порт 137 - с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=137 name="Block_TCP-137"
REM TCP порт 138
netsh advfirewall firewall add rule dir=in action=block protocol=tcp localport=138 name="Block_TCP-138"
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