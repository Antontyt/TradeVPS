@echo off
REM ======================================================================================================================
REM VERSION 1.0.1 - 21.11.2022
REM ======================================================================================================================
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
powershell -command "Get-AppxPackage -allusers Microsoft.MicrosoftEdge.Stable | Remove-AppxPackage"
REM DISABLE CORTANA
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /F
TASKKILL /IM SearchApp.exe /F
move %windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy %windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.old

REM Search on TaskBar
ECHO Search on TaskBar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 1 /F

REM Shutdown Event Tracker
ECHO Shutdown Event Tracker
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v ShutdownReasonUI /t REG_DWORD /d 0 /F

REM =============================================================================================================
REM Firefox ESR
ECHO Firefox ESR
IF NOT EXIST "C:\Security\TEMP\lnk\" MD C:\Security\TEMP\lnk\
"sys\curl\curl.exe" -L --output-dir C:\Security\TEMP\ -o FirefoxESR.exe "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/lnk/CreateFirefoxLnk.vbs"
timeout 5
REM "temp\FirefoxESR.exe" -ms -ma
CALL "C:\Security\TEMP\FirefoxESR.exe" -ms
cscript /Nologo "C:\Security\TEMP\lnk\CreateFirefoxLnk.vbs"

REM Notepad++
ECHO Notepad++
"sys\curl\curl.exe" -L --output-dir C:\Security\TEMP\ -o NotepadPlusPlus.exe "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.7/npp.8.4.7.Installer.exe"
timeout 5
"C:\Security\TEMP\NotepadPlusPlus.exe" /S

REM TASKKILL PROGRAMS
ECHO TASKKILL PROGRAMS
TASKKILL /IM MicrosoftEdgeUpdate.exe /F
TASKKILL /IM SearchApp.exe /F
TASKKILL /IM msedge.exe /F
TASKKILL /IM firefox.exe /F

REM MS EDGE Remove
ECHO MS EDGE Remove
"C:\Program Files (x86)\Microsoft\Edge\Application\86.0.622.38\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall

REM NET 4.8
ECHO NET 4.8
"sys\curl\curl.exe" -L --output-dir C:\Security\TEMP\ -o ndp48-x86-x64-allos-enu.exe "https://go.microsoft.com/fwlink/?linkid=2088631"
timeout 5
"C:\Security\TEMP\ndp48-x86-x64-allos-enu.exe" /passive /norestart

REM TSLAB 2.2
ECHO TSLAB 2.2
IF NOT EXIST "temp" MD temp
"sys\curl\curl.exe" -L --output-dir C:\Security\TEMP\ -o TSLab22Setup.exe "https://files.tslab.pro/installer/TSLab22Setup.exe"

REM RESENTLY PROGRAMS
ECHO RESENTLY PROGRAMS
ECHO Download Registry Settings
IF NOT EXIST "C:\Security\TEMP\reg\" MD C:\Security\TEMP\reg\
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/Disable_DirtyShutdown.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/Disable_Recently_added_apps_list_on_Start_Menu.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/Disable_Search.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/Disable_ShowTaskViewButton.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/Disable_Shutdown_Event_Tracker.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/RussiaLocale_ForNonUnicode.reg
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/reg/RegionalSettings/USALocale_ForNonUnicode.reg
regedit /s "C:\Security\TEMP\reg\Disable_DirtyShutdown.reg"
regedit /s "C:\Security\TEMP\reg\Disable_Recently_added_apps_list_on_Start_Menu.reg"
regedit /s "C:\Security\TEMP\reg\Disable_Search.reg"
regedit /s "C:\Security\TEMP\reg\Disable_ShowTaskViewButton.reg"
regedit /s "C:\Security\TEMP\reg\Disable_Shutdown_Event_Tracker.reg"
CALL "C:\Security\TEMP\Hide_search_on_taskbar.bat"
PAUSE

REM REGIONAL SETTINGS
ECHO REGIONAL SETTINGS
IF NOT EXIST "C:\Security\TEMP\reg\RegionalSettings" MD C:\Security\TEMP\reg\RegionalSettings
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\reg\RegionalSettings\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/RegionalSettings/Settings.xml"
C:\Windows\System32\control.exe intl.cpl,, /f:"C:\Security\TEMP\reg\RegionalSettings\Settings.xml"
regedit /s "C:\Security\TEMP\reg\RussiaLocale_ForNonUnicode.reg"
PAUSE

REM DISABLE SMB1 Protocol
ECHO DISABLE SMB1 Protocol
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /F
PAUSE

REM Update Windows Defender
ECHO Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
PAUSE

REM Enable Windows Firewall
ECHO Enable Windows Firewall
netsh advfirewall set currentprofile state on
netsh advfirewall set allprofiles state on
netsh advfirewall set domainprofile state on
netsh advfirewall set privateprofile state on
netsh advfirewall set publicprofile state on
PAUSE

REM Get Windows Updates
ECHO Get Windows Updates
REM cscript /Nologo "sys\wp\WindowsUpdateInstall_Auto.vbs"

REM Copy Security Lnk
ECHO Copy Security Lnk
IF NOT EXIST "C:\Security" MD "C:\Security"
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/lnk/CreateSecurityLnk.vbs
"sys\curl\curl.exe" -O --output-dir C:\Security\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/WindowsUpdateInstall_Manual.vbs"
"sys\curl\curl.exe" -O --output-dir C:\Security\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/WindowsUpdateInstall_Manual.vbs"
"sys\curl\curl.exe" -O --output-dir C:\Security\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/UpdateSecurity.bat"
cscript /Nologo "C:\Security\TEMP\lnk\CreateSecurityLnk.vbs"
PAUSE

CLS
ECHO PROGRAM END
ECHO NEEDED REBOOT SERVER - OR PRESS BUTTON FOR REBOOT AUTOMATICALY
EXIT
PAUSE
shutdown /r /t 60 /c "The server will be shutdown in 1 minute"