@echo off
chcp 866> nul
REM ======================================================================================================================
REM VERSION 1.2.1 - 11.12.2022
REM ======================================================================================================================
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /f
reg add "HKCU\Console" /v "QuickEdit" /t REG_DWORD /d 0 /f
reg add "HKCU\Console" /v "InsertMode" /t REG_DWORD /d 0 /f
REM -----------------------------------------------------------------------------------------------------
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "QuickEdit" /t REG_DWORD /d 0 /f
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "InsertMode" /t REG_DWORD /d 0 /f
REM -----------------------------------------------------------------------------------------------------
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "QuickEdit" /t REG_DWORD /d 0 /f
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "InsertMode" /t REG_DWORD /d 0 /f
REM -----------------------------------------------------------------------------------------------------
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "QuickEdit" /t REG_DWORD /d 0 /f
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "InsertMode" /t REG_DWORD /d 0 /f
REM ======================================================================================================================
ECHO =====================================
ECHO VERSION 1.2.1 - 11.12.2022
ECHO =====================================
ECHO �஢�ઠ ���ᨨ ����樮���� ��⥬�
for /F "skip=2 tokens=1,2*" %%I in ('%SystemRoot%\System32\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do if /I "%%I" == "ProductName" set "WindowsProduct=%%K"
ECHO WindowsProduct: "%WindowsProduct%"
ECHO Username: "%username%"
IF "%WindowsProduct%"=="Windows Server 2019 Standard" (
SET WindowsProduct=WindowsServer2019Standard
GOTO OPERATIONOS_OK
)
IF "%WindowsProduct%"=="Windows Server 2022 Standard" (
SET WindowsProduct=WindowsServer2022Standard
GOTO OPERATIONOS_OK
)
GOTO NOTSUPPORTOS
:OPERATIONOS_OK
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
IF "%WindowsProduct%"=="WindowsServer2019Standard" IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\FLG\WindowsServer2019Standard_ID1.FLG" (
ECHO PLEASE REBOOT PC AND RESTART
ECHO.
ECHO PRESS BUTTON FOR REBOOT
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\FLG\" MD "C:\Windows\TEMP\WindowsServerSecurity\FLG\"
ECHO 1 > "C:\Windows\TEMP\WindowsServerSecurity\FLG\WindowsServer2019Standard_ID1.FLG"
PAUSE
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\install.bat /f
shutdown /r /t 5 /c "The server will be shutdown in 5 seconds"
EXIT
)
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM ====================================================================================================================
SET userp=%username%
IF "%userp%"=="Administrator" GOTO RENAME_USERNAME
IF "%userp%"=="�����������" GOTO RENAME_USERNAME
GOTO USERNAME_OK
REM ====================================================================================
:RENAME_USERNAME
CLS
ECHO =====================================
ECHO VERSION 1.2.1 - 11.12.2022
ECHO =====================================
ECHO.
TITLE ��२��������� ����� ���짮��⥫� Administrator
ECHO.
ECHO ��� ������᭮�� ᮢ���� ��२�������� �⠭���⭮� ��� ���짮��⥫� Administrator
ECHO �ᯮ���� �㪢� � ���� ��� ᯥ�ᨬ�����
ECHO.
ECHO �롥�� �ॡ㥬�� ����⢨�
ECHO ===============================================================================
ECHO.
ECHO 0. �������� ��� ���짮��⥫�
ECHO 1. �த������ ��� ��������� ����� ���짮��⥫�
ECHO.
SET choice=
SET /p choice="��� ���⢥ত���� ��᫥ ����� ������ Enter :"
ECHO.

IF /I '%choice%'=='0' (
GOTO RENAME_USERNAME_RUN
)
IF /I '%choice%'=='1' (
GOTO USERNAME_OK
)
CLS
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
ECHO -----------------------------------------------------------------
ECHO ����㯭� ��ਠ��� 0 ��� 1
ECHO ������ ���� ������ ��� ����୮�� �����
ECHO -----------------------------------------------------------------
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
PAUSE
GOTO RENAME_USERNAME
:RENAME_USERNAME_RUN
CLS
ECHO ���쪮 �㪢� � ����
SET /P newusername=������ ��� ���짮��⥫�:
ECHO RENAME_USERNAME_RUN
REM ====================================================================================
ECHO ��� ��२��������� ���짮��⥫� "%newusername%"
ECHO ������ ���� ������ ��� ���⢥ত����
PAUSE
wmic useraccount where name='%userp%' rename %newusername%
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\install.bat /f
shutdown /r /t 5 /c "The server will be shutdown in 5 seconds"
EXIT
:USERNAME_OK
ECHO USERNAME_OK
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM ================================================================================================================================
REM ECHO RDP Port
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO RDPPortNumber: "%RDPPortNumber%"
REM ====================================================================================
set/a lTime=%RDPPortNumber%*1
if "%lTime%"=="%RDPPortNumber%" (
�echo ����� �᫮. "%RDPPortNumber%"
) else (
�echo ��-� ��㣮�. "%RDPPortNumber%"
 PAUSE
)
REM ====================================================================================
IF "%RDPPortNumber%"=="3389" GOTO CHANGE_RDPPORT
IF "%RDPPortNumber%"=="0" GOTO CHANGE_RDPPORT
GOTO RDPPORT_OK
REM ====================================================================================
:CHANGE_RDPPORT
CLS
TITLE ����� ���� RDP
ECHO.
ECHO ��� ������᭮�� ᮢ���� �������� ����� ���� RDP
ECHO �⠭����� ����:3389
ECHO.
ECHO ����������� �㦭� IP_ADDRESS:PORT
ECHO �ᯮ���� ⮫쪮 ����
ECHO.
ECHO �롥�� �ॡ㥬�� ����⢨�
ECHO ===============================================================================
ECHO.
ECHO 0. �������� RDP Port
ECHO 1. �த������ ��� ���������
ECHO.
SET choice=
SET /p choice="��� ���⢥ত���� ��᫥ ����� ������ Enter :"
ECHO.

IF /I '%choice%'=='0' (
GOTO CHANGE_RDPPORT_RUN
)
IF /I '%choice%'=='1' (
GOTO RDPPORT_OK
)
CLS
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
ECHO -----------------------------------------------------------------
ECHO ����㯭� ��ਠ��� 0 ��� 1
ECHO ������ ���� ������ ��� ����୮�� �����
ECHO -----------------------------------------------------------------
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
PAUSE
GOTO CHANGE_RDPPORT
:CHANGE_RDPPORT_RUN
CLS
ECHO ���쪮 ����
SET /P newrdpport=������ ����� ���� - �� ����姭��� ����:
ECHO ����騩 ����:"%RDPPortNumber%" \ �롥�� �� �� 3000 �� 3999
ECHO.
REM ====================================================================================
ECHO ������ ���� ����: "%newrdpport%"
ECHO ������ ���� ������ ��� ���⢥ত����
PAUSE
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d %newrdpport% /F
:RDPPORT_OK
ECHO RDPPORT_OK
REM ================================================================================================================================
REM ================================================================================================================================
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM DISABLE DEFENDER
CLS
ECHO DISABLE DEFENDER
ECHO �������� ��������...
REM ================================================================================================================================
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SubmitSamplesConsent NeverSend"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -MAPSReporting Disable"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableArchiveScanning $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableAutoExclusions $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScanningNetworkFiles $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScriptScanning $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableIOAVProtection $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisablePrivacyMode $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-Item 'C:\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db'"
REM ================================================================================================================================
REM DISABLE SMARTSCREEN
ECHO DISABLE SMARTSCREEN
REM ================================================================================================================================
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "Off" /F
REM ================================================================================================================================
REM DISABLE SEARCHDISABLE
ECHO DISABLE SEARCHDISABLE
REM ================================================================================================================================
REM https://serverfault.com/questions/749921/remove-reboot-request-for-dism
dism /online /disable-feature /featurename:SearchEngine-Client-Package /NoRestart
REM Disable Search on Taskbar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 0 /F
REM To kill and restart explorer
taskkill /f /im explorer.exe
start explorer.exe
REM ================================================================================================================================
REM DISABLE PREPARE2022 SERVER
ECHO DISABLE PREPARE2022 SERVER
REM ================================================================================================================================
REM Change Windows Settings
REM Setup Belarus Standard Time
ECHO Setup Belarus Standard Time 
tzutil /s "Belarus Standard Time"
REM Sync time
ECHO Sync time
w32tm /resync
REM Disable Telemetry in Windows
ECHO Disable Telemetry in Windows
sc stop DiagTrack
sc delete DiagTrack
sc stop dmwappushservice
sc delete dmwappushservice
echo "" > C:\\ProgramData\\Microsoft\\Diagnosis\\ETLLogs\\AutoLogger\\AutoLogger-Diagtrack-Listener.etl
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "Allow Telemetry" /t REG_DWORD /d 0 /F

REM Disable Telemetry Tasks
ECHO Disable Telemetry Tasks
schtasks /Delete /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /F
schtasks /Delete /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /F

REM Disable Defrag Task
ECHO Disable Defrag Task
schtasks /Delete /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /F

REM Disable Admins share
ECHO Disable Admins share
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 0 /F

REM Disable Windows Update Task
ECHO Disable Windows Update Task
schtasks /Delete /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /F

REM Turn off server manager on login
ECHO Turn off server manager on login
REG ADD "HKCU\Software\Microsoft\ServerManager" /v CheckedUnattendLaunchSetting /t REG_DWORD /d 0 /F
REG ADD "HKLM\SOFTWARE\Microsoft\ServerManager" /v "DoNotPopWACConsoleAtSMLaunch" /t REG_DWORD /d 1 /F
schtasks /Delete /TN "\Microsoft\Windows\Server Manager\ServerManager" /F

REM MS EDGE
ECHO MS EDGE
sc stop MicrosoftEdgeElevationService
sc delete MicrosoftEdgeElevationService
sc delete MicrosoftEdgeElevationService
sc stop edgeupdate
sc delete edgeupdate
sc delete edgeupdate
sc stop edgeupdatem
sc delete edgeupdatem
sc delete edgeupdatem

REM Windows Report Service
ECHO Windows Report Service
sc stop WerSvc
sc config "WerSvc" start= disabled

REM Windows Secondary Logon
ECHO Windows Secondary Logon
sc stop seclogon
sc config "seclogon" start= disabled

REM RemoteRegistry Disable
ECHO RemoteRegistry Disable
sc stop RemoteRegistry
sc config "RemoteRegistry" start= disabled

REM WindowsSearch Disable
ECHO WindowsSearch Disable
sc stop WSearch
sc config "WSearch" start= disabled
powershell -command "Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage"
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Search | Remove-AppxPackage"
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Cortana_cw5n1h2txyewy | Remove-AppxPackage"
powershell -command "Get-AppxPackage -allusers Microsoft.MicrosoftEdge.Stable | Remove-AppxPackage"
REM DISABLE CORTANA
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /F
TASKKILL /IM SearchApp.exe /F
TASKKILL /IM SearchUI.exe /F
move "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy.bak"
move "%windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.bak"

REM Search on TaskBar
ECHO Search on TaskBar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 1 /F

REM Shutdown Event Tracker
ECHO Shutdown Event Tracker
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v ShutdownReasonUI /t REG_DWORD /d 0 /F

REM WindowsMenuLayout
ECHO WindowsMenuLayout
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\Windows\" MD "C:\Windows\TEMP\WindowsServerSecurity\Windows\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Windows "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/WindowsLayouts/ImportLayout.ps1"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Windows "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/WindowsLayouts/StartLayout.xml"
powershell.exe -file "C:\Windows\TEMP\WindowsServerSecurity\Windows\ImportLayout.ps1"

REM =============================================================================================================
REM Firefox ESR
ECHO Firefox ESR
IF NOT EXIST "C:\Service\TEMP\lnk\" MD C:\Service\TEMP\lnk\
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\app\" MD "C:\Windows\TEMP\WindowsServerSecurity\app\"
IF EXIST "C:\Program Files\Mozilla Firefox\firefox.exe" GOTO FFLNK
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o FirefoxESR.exe "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
timeout 5
REM "temp\FirefoxESR.exe" -ms -ma
CALL "C:\Windows\TEMP\WindowsServerSecurity\app\FirefoxESR.exe" -ms

:FFLNK
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateFirefoxLnk.vbs"
cscript /Nologo "C:\Service\TEMP\lnk\CreateFirefoxLnk.vbs"

IF EXIST "C:\Program Files (x86)\Notepad++\notepad++.exe" GOTO TASKKILL
REM Notepad++
ECHO Notepad++
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o NotepadPlusPlus.exe "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.7/npp.8.4.7.Installer.exe"
timeout 5
"C:\Windows\TEMP\WindowsServerSecurity\app\NotepadPlusPlus.exe" /S

:TASKKILL
REM TASKKILL PROGRAMS
ECHO TASKKILL PROGRAMS
TASKKILL /IM MicrosoftEdgeUpdate.exe /F /T
TASKKILL /IM SearchApp.exe /F /T
TASKKILL /IM msedge.exe /F /T
TASKKILL /IM firefox.exe /F /T

REM MS EDGE Remove
ECHO MS EDGE Remove
"C:\Program Files (x86)\Microsoft\Edge\Application\107.0.1418.56\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall
"C:\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall
schtasks /Delete /TN "MicrosoftEdgeUpdateTaskMachineCore{B95B19F5-FCC1-4E69-93F1-4E645586C4DC}" /F
schtasks /Delete /TN "MicrosoftEdgeUpdateTaskMachineUA{46DB8337-FB73-4FC6-864D-7462C85416B9}" /F																					

REM NET 4.8
ECHO NET 4.8
REM ECHO NETVersion
For /F tokens^=^3 %%i in ('reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full" /v version')DO SET "NETVersion=%%i"
ECHO NETVersion: "%NETVersion%"
REM 2019 Server NET Version
IF "%NETVersion%"=="4.8.03761" GOTO NET48_OK
REM 2020 Server NET Version
IF "%NETVersion%"=="4.8.04161" GOTO NET48_OK
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o ndp48-x86-x64-allos-enu.exe "https://go.microsoft.com/fwlink/?linkid=2088631"
timeout 5
"C:\Windows\TEMP\WindowsServerSecurity\app\ndp48-x86-x64-allos-enu.exe" /passive /norestart
REM ------------------------------------------------------------------------------------------------
ECHO PLEASE REBOOT PC AND RESTART
ECHO.
ECHO PRESS BUTTON FOR REBOOT
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\FLG\" MD "C:\Windows\TEMP\WindowsServerSecurity\FLG\"
ECHO 1 > "C:\Windows\TEMP\WindowsServerSecurity\FLG\WindowsServer2019Standard_ID2.FLG"
PAUSE
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\install.bat /f
shutdown /r /t 5 /c "The server will be shutdown in 5 seconds"
EXIT
REM ------------------------------------------------------------------------------------------------

:NET48_OK
REM RESENTLY PROGRAMS
ECHO RESENTLY PROGRAMS
ECHO Download Registry Settings
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\Registry\" MD "C:\Windows\TEMP\WindowsServerSecurity\Registry\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsUpdates/WindowsUpdate.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Disable_DirtyShutdown.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Disable_Recently_added_apps_list_on_Start_Menu.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Disable_Search.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Disable_ShowTaskViewButton.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Disable_Shutdown_Event_Tracker.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/RussiaLocale_ForNonUnicode.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/USALocale_ForNonUnicode.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/DisableAutoRun.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/Hide_search_on_taskbar.bat"																										 
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\Disable_DirtyShutdown.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\Disable_Recently_added_apps_list_on_Start_Menu.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\Disable_Search.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\Disable_ShowTaskViewButton.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\Disable_Shutdown_Event_Tracker.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\DisableAutoRun.reg"
REM Windows Update Settings
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsUpdate.reg"
CALL "C:\Service\TEMP\Hide_search_on_taskbar.bat"

REM REGIONAL SETTINGS
ECHO REGIONAL SETTINGS
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\Registry\RegionalSettings" MD C:\Windows\TEMP\WindowsServerSecurity\Registry\RegionalSettings
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\RegionalSettings\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/RegionalSettings/Settings.xml"
C:\Windows\System32\control.exe intl.cpl,, /f:"C:\Windows\TEMP\WindowsServerSecurity\Registry\RegionalSettings\Settings.xml"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\RussiaLocale_ForNonUnicode.reg"

REM DISABLE SMB1 Protocol
ECHO DISABLE SMB1 Protocol
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /F
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB2 -Type DWORD -Value 0 -Force"
sc.exe config mrxsmb20 start= disabled

REM Remove WoW64-Support, FS-SMB1 Protocols
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsFeature WoW64-Support, FS-SMB1 -Force"

REM Update Windows Defender
ECHO Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

REM Enable Windows Firewall
ECHO Enable Windows Firewall
netsh advfirewall set currentprofile state on
netsh advfirewall set allprofiles state on
netsh advfirewall set domainprofile state on
netsh advfirewall set privateprofile state on
netsh advfirewall set publicprofile state on
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallProfile -All -Enabled True"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallProfile -All -DefaultInboundAction Block"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetFirewallRule -Name FPS-ICMP4-ERQ-In"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetFirewallRule -Name FPS-ICMP6-ERQ-In"
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO RDPPortNumber: "%RDPPortNumber%"
REM -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-NetFirewallRule -DisplayName 'AllowRDP'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName 'AllowRDP' -Direction Inbound -Protocol TCP -LocalPort %RDPPortNumber% -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName 'AllowRDP' -Direction Inbound -Protocol UDP -LocalPort %RDPPortNumber% -Action Allow"
REM "C:\Service\System\curl\curl.exe" -O --output-dir C:\Users\Public\Desktop\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/WindowsFirewall_Enable.bat"

REM Copy Security Lnk
ECHO Copy Security Lnk
IF NOT EXIST "C:\Service\TEMP\lnk\" MD "C:\Service\TEMP\lnk\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateHelperLnk.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Manual.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Auto.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelper.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelperUpdate.bat"
cscript /Nologo "C:\Service\TEMP\lnk\CreateHelperLnk.vbs"

REM Get Windows Updates
ECHO Get Windows Updates
REM cscript /Nologo "C:\Service\WindowsUpdateInstall_Auto.vbs"

REM Global Windows Settings
ECHO ����祭�� ���������� RDP ������祭��
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

REM Remove Programs from Startup
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SecurityHealth /F

REM Service defragsvc 
ECHO Service defragsvc
sc.exe stop defragsvc
sc.exe config defragsvc start= disabled

REM Interactive Services
ECHO Interactive Services
reg.exe ADD "HKLM\SYSTEM\CurrentControlSet\Control\Windows" /v NoInteractiveServices /t REG_DWORD /d 0 /f
sc.exe stop ui0detect
sc.exe config ui0detect start= disabled

REM Change System Resolution
IF NOT EXIST "C:\Service\Software\ChangeRes\" MD "C:\Service\Software\ChangeRes\"
"C:\Service\System\curl\curl.exe" -L --output C:\Service\Software\ChangeRes\ChangeRes.exe "https://github.com/Antontyt/WindowsServerSecurity/blob/main/Settings/Programs/ChangeRes/ChangeRes.exe?raw=true"
CALL "C:\Service\Software\ChangeRes\ChangeRes.exe" 1600 900

REM Install Aditional Programs
IF EXIST "C:\Program Files\7-Zip" GOTO AFTER_INSTALL7z
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o 7z2201-x64.msi "https://www.7-zip.org/a/7z2201-x64.msi"
timeout 5
MsiExec.exe /i "C:\Windows\TEMP\WindowsServerSecurity\app\7z2201-x64.msi" /qn
:AFTER_INSTALL7z

REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM Disable WS-Management
ECHO Disable WS-Management (Windows Remote Management)
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-PSRemoting -Force"
net stop WinRM
sc config WinRM start= disabled
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ECHO Change Windows Settings
w32tm /unregister
net stop w32tm
sc config w32time start= disabled
ECHO Hyper-V Time Synchronization Service
sc stop vmictimesync
sc config "vmictimesync" start= disabled
net stop tzautoupdate
sc config tzautoupdate start= disabled
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /d "NoSync" /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v Start /t REG_DWORD /d 3 /F
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Dimension4 TimeSync
ECHO Dimension4 TimeSync
IF EXIST "C:\Program Files (x86)\D4\D4.exe" GOTO D4CONFIG
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\D4\" MD "C:\Windows\TEMP\WindowsServerSecurity\D4\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\D4\ -o d4time531.msi "http://www.thinkman.com/dimension4/d4time531.msi"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\D4\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/D4/defaults.ini"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\D4\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/D4/server.dat"
timeout 5
msiexec /i "C:\Windows\TEMP\WindowsServerSecurity\D4\d4time531.msi" /QN /L*V "C:\Windows\TEMP\WindowsServerSecurity\D4\d4time531.log"

:D4CONFIG
REM Dimension4
net stop Dimension4
REM Insert a delay ...
echo Wait 10 seconds before restart ...
ping -n 10 127.0.0.1 > NUL
XCOPY /I /Z /Y "C:\Windows\TEMP\WindowsServerSecurity\D4\defaults.ini" "C:\Program Files (x86)\D4\"
XCOPY /I /Z /Y "C:\Windows\TEMP\WindowsServerSecurity\D4\server.dat" "C:\Program Files (x86)\D4\"
net start Dimension4
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
:RestartOnCrash
REM RestartOnCrash
IF EXIST "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe" GOTO PROGRAM_END
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\RestartOnCrash\" MD "C:\Windows\TEMP\WindowsServerSecurity\RestartOnCrash\"
TASKKILL /IM RestartOnCrash.exe /F /T
RMDIR /S /Q "C:\Service\Software\RestartOnCrash\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\RestartOnCrash\ -o RestartOnCrash.zip "https://w-shadow.com/files/RestartOnCrash-v1.6.4.zip"
timeout 5
"C:\Program Files\7-Zip\7z.exe" x C:\Windows\TEMP\WindowsServerSecurity\RestartOnCrash\RestartOnCrash.zip -oC:\Service\Software\RestartOnCrash\
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\Software\RestartOnCrash\ -o settings.ini "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/RestartOnCrash/settings.ini"
IF EXIST "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe" (
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "wsRestartOnCrash" /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "wsRestartOnCrash" /t REG_SZ /d "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe" /F
START "" "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe"
)
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM Starter Windows
IF NOT EXIST "C:\Service\Software\StartWindows\" MD "C:\Service\Software\StartWindows\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Software\StartWindows\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/Starter.bat"
timeout 5
IF EXIST "C:\Service\Software\StartWindows\Starter.bat" (
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Starter" /t REG_SZ /d "C:\Service\Software\StartWindows\Starter.bat" /F
"C:\Service\Software\StartWindows\Starter.bat"
)

CLS
:PROGRAM_END
ECHO PROGRAM END
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
PAUSE
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT


REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
:NOTSUPPORTOS
CLS
TITLE NOT SUPPORT OPERATION SYSTEM
ECHO ������ Windows �� �����ন������ ������ ����樮���� ��⥬�
ECHO.
ECHO WindowsProduct: "%WindowsProduct%"
PAUSE
EXIT