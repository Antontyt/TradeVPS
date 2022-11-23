@ECHO OFF
ECHO Проверка версии операционной системы
for /F "skip=2 tokens=1,2*" %%I in ('%SystemRoot%\System32\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do if /I "%%I" == "ProductName" set "WindowsProduct=%%K"
ECHO WindowsProduct: "%WindowsProduct%"
ECHO Username: "%username%"
PAUSE
IF "%username%"=="Administrator" GOTO RENAME_USERNAME
GOTO USERNAME_OK
REM ====================================================================================
:RENAME_USERNAME
CLS
TITLE Внимание! Данный пакет будет заблокирован через несколько дней!
ECHO Выберите требуемое действие
ECHO ===============================================================================
ECHO.
ECHO 0. Поменять имя пользователя
ECHO 1. Продолжить без изменения имени пользователя
ECHO.
SET choice=
SET /p choice="Для подтверждения после ввода нажмите Enter :"
ECHO.

IF /I '%choice%'=='0' (
GOTO RENAME_USERNAME_RUN
)
IF /I '%choice%'=='1' (
GOTO USERNAME_OK
)
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Доступные варианты 0 или 1
ECHO Нажмите любую кнопку для повторного ввода
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE
GOTO RENAME_USERNAME
:RENAME_USERNAME_RUN
CLS
ECHO Только буквы и цифры
SET /P newusername=Введите имя пользователя:
ECHO RENAME_USERNAME_RUN
PAUSE
REM ====================================================================================
wmic useraccount where fullname='%username%' rename %newusername%
:USERNAME_OK
ECHO USERNAME_OK
PAUSE
REM ================================================================================================================================
REM DISABLE DEFENDER
ECHO DISABLE DEFENDER
REM ================================================================================================================================
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /F
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
IF NOT EXIST "C:\Service\TEMP\lnk\" MD C:\Service\TEMP\lnk\
IF NOT EXIST "C:\Service\TEMP\app\" MD C:\Service\TEMP\app\
"sys\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o FirefoxESR.exe "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/lnk/CreateFirefoxLnk.vbs"
timeout 5
REM "temp\FirefoxESR.exe" -ms -ma
CALL "C:\Service\TEMP\app\FirefoxESR.exe" -ms
cscript /Nologo "C:\Service\TEMP\lnk\CreateFirefoxLnk.vbs"

REM Notepad++
ECHO Notepad++
"sys\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o NotepadPlusPlus.exe "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.7/npp.8.4.7.Installer.exe"
timeout 5
"C:\Service\TEMP\app\NotepadPlusPlus.exe" /S

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
"sys\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o ndp48-x86-x64-allos-enu.exe "https://go.microsoft.com/fwlink/?linkid=2088631"
timeout 5
"C:\Service\TEMP\app\ndp48-x86-x64-allos-enu.exe" /passive /norestart

REM TSLAB 2.2
ECHO TSLAB 2.2
IF NOT EXIST "temp" MD temp
"sys\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22Setup.exe "https://files.tslab.pro/installer/TSLab22Setup.exe"

REM RESENTLY PROGRAMS
ECHO RESENTLY PROGRAMS
ECHO Download Registry Settings
IF NOT EXIST "C:\Service\TEMP\reg\" MD C:\Service\TEMP\reg\
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Disable_DirtyShutdown.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Disable_Recently_added_apps_list_on_Start_Menu.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Disable_Search.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Disable_ShowTaskViewButton.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Disable_Shutdown_Event_Tracker.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/RussiaLocale_ForNonUnicode.reg
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/USALocale_ForNonUnicode.reg
regedit /s "C:\Service\TEMP\reg\Disable_DirtyShutdown.reg"
regedit /s "C:\Service\TEMP\reg\Disable_Recently_added_apps_list_on_Start_Menu.reg"
regedit /s "C:\Service\TEMP\reg\Disable_Search.reg"
regedit /s "C:\Service\TEMP\reg\Disable_ShowTaskViewButton.reg"
regedit /s "C:\Service\TEMP\reg\Disable_Shutdown_Event_Tracker.reg"
CALL "C:\Service\TEMP\Hide_search_on_taskbar.bat"
PAUSE

REM REGIONAL SETTINGS
ECHO REGIONAL SETTINGS
IF NOT EXIST "C:\Service\TEMP\reg\RegionalSettings" MD C:\Service\TEMP\reg\RegionalSettings
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\RegionalSettings\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/RegionalSettings/Settings.xml"
C:\Windows\System32\control.exe intl.cpl,, /f:"C:\Service\TEMP\reg\RegionalSettings\Settings.xml"
regedit /s "C:\Service\TEMP\reg\RussiaLocale_ForNonUnicode.reg"
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
IF NOT EXIST "C:\Service" MD "C:\Service"
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/lnk/CreateSecurityLnk.vbs
"sys\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/WindowsUpdateInstall_Manual.vbs"
"sys\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/WindowsUpdateInstall_Auto.vbs"
"sys\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/sys/wp/UpdateSecurity.bat"
cscript /Nologo "C:\Service\TEMP\lnk\CreateSecurityLnk.vbs"
PAUSE

CLS
ECHO PROGRAM END
ECHO NEEDED REBOOT SERVER - OR PRESS BUTTON FOR REBOOT AUTOMATICALY
EXIT
PAUSE
shutdown /r /t 60 /c "The server will be shutdown in 1 minute"