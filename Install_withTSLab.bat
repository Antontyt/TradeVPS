@echo off
chcp 866> nul
TASKKILL /IM ServerManager.exe /F
REM ======================================================================================================================
REM VERSION 1.3.0 - 28.03.2022
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
ECHO VERSION 1.3.0 - 28.03.2022
ECHO =====================================
ECHO Проверка версии операционной системы
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
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\Install_withTSLab.bat /f
shutdown /r /t 5 /c "The server will be shutdown in 5 seconds"
EXIT
)
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM ====================================================================================================================
SET userp=%username%
IF "%userp%"=="Administrator" GOTO RENAME_USERNAME
IF "%userp%"=="Администратор" GOTO RENAME_USERNAME
GOTO USERNAME_OK
REM ====================================================================================
:RENAME_USERNAME
CLS
ECHO =====================================
ECHO VERSION 1.3.0 - 28.03.2022
ECHO =====================================
ECHO.
TITLE Переименование имени пользователя Administrator
ECHO.
ECHO Для безопасности советую переименовать стандартное имя пользователя Administrator
ECHO Используйте буквы и цифры без спецсимволов
ECHO.
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
REM ====================================================================================
ECHO Для переименования пользователя "%newusername%"
ECHO Нажмите любую кнопку для подтверждения
PAUSE
wmic useraccount where name='%userp%' rename %newusername%
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\Install_withTSLab.bat /f
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
 echo Целое число. "%RDPPortNumber%"
) else (
 echo Что-то другое. "%RDPPortNumber%"
 PAUSE
)
REM ====================================================================================
IF "%RDPPortNumber%"=="3389" GOTO CHANGE_RDPPORT
IF "%RDPPortNumber%"=="0" GOTO CHANGE_RDPPORT
GOTO RDPPORT_OK
REM ====================================================================================
:CHANGE_RDPPORT
CLS
TITLE Смена порта RDP
ECHO.
ECHO Для безопасности советую изменить номер порта RDP
ECHO Стандартный порт:3389
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
SET choice=
SET /p choice="Для подтверждения после ввода нажмите Enter :"
ECHO.

IF /I '%choice%'=='0' (
GOTO CHANGE_RDPPORT_RUN
)
IF /I '%choice%'=='1' (
GOTO RDPPORT_OK
)
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Доступные варианты 0 или 1
ECHO Нажмите любую кнопку для повторного ввода
ECHO -----------------------------------------------------------------
ECHO ================ Отсутствует выбранный параметр =================
PAUSE
GOTO CHANGE_RDPPORT
:CHANGE_RDPPORT_RUN
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
:RDPPORT_OK
ECHO RDPPORT_OK
REM ================================================================================================================================
REM ================================================================================================================================
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM DISABLE DEFENDER
REM CLS
REM ECHO DISABLE DEFENDER
REM ECHO Пожалуйста подождите...
REM REM ================================================================================================================================
REM REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /F
REM REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SubmitSamplesConsent NeverSend"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -MAPSReporting Disable"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableArchiveScanning $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableAutoExclusions $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScanningNetworkFiles $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScriptScanning $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableIOAVProtection $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisablePrivacyMode $true"
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-Item 'C:\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db'"
REM REM ================================================================================================================================
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
powershell -command "Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage" -ErrorAction SilentlyContinue
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Search | Remove-AppxPackage" -ErrorAction SilentlyContinue
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Cortana_cw5n1h2txyewy | Remove-AppxPackage" -ErrorAction SilentlyContinue
powershell -command "Get-AppxPackage -allusers Microsoft.MicrosoftEdge.Stable | Remove-AppxPackage" -ErrorAction SilentlyContinue
REM DISABLE CORTANA
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /F
TASKKILL /IM SearchApp.exe /F
TASKKILL /IM SearchUI.exe /F
move "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy.bak"
move "%windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.bak"

REM Search on TaskBar
ECHO Search on TaskBar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 1 /F

REM Setup Parameters for Network Adapters
ECHO Setup Parameters for Network Adapters
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetAdapterBinding -Name * -DisplayName 'File and Printer Sharing for Microsoft Networks'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetAdapterBinding -Name * -ComponentID 'ms_tcpip6'"

REM LocalPolicy
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\LocalPolicy\" MD "C:\Windows\TEMP\WindowsServerSecurity\LocalPolicy\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\LocalPolicy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/LocalPolicy/LocalPolicy.inf"
secedit /configure /db %temp%\temp.sdb /cfg "C:\Windows\TEMP\WindowsServerSecurity\LocalPolicy\LocalPolicy.inf"

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
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\lnk\" MD "C:\Windows\TEMP\WindowsServerSecurity\lnk\"
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\app\" MD "C:\Windows\TEMP\WindowsServerSecurity\app\"
IF EXIST "C:\Program Files\Mozilla Firefox\firefox.exe" GOTO FFLNK
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o FirefoxESR.exe "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
timeout 5
REM "temp\FirefoxESR.exe" -ms -ma
CALL "C:\Windows\TEMP\WindowsServerSecurity\app\FirefoxESR.exe" -ms

:FFLNK
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateFirefoxLnk.vbs"
cscript /Nologo "C:\Windows\TEMP\WindowsServerSecurity\lnk\CreateFirefoxLnk.vbs"

IF EXIST "C:\Program Files (x86)\Notepad++\notepad++.exe" GOTO TASKKILL
REM Notepad++
ECHO Notepad++
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\app\ -o NotepadPlusPlus.exe "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5/npp.8.5.Installer.exe"
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
for /f "usebackq tokens=2* delims=	 " %%i in (
	`reg.exe query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v "DisplayVersion"`
) do set DisplayVersion=%%j
ECHO DisplayVersion: "%DisplayVersion%"
"C:\Program Files (x86)\Microsoft\Edge\Application\%DisplayVersion%\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall
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
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RunScript /d C:\Service\temp\Install_withTSLab.bat /f
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

REM Windows Privacy Settings
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\" MD "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Clear_location_last_accessed_history_for_current_user.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Activity_history.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_app_launch_tracking.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Background_Apps.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Background_Apps_for_all_users.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Cloud_content_search_for_Microsoft_account.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Cloud_Search_for_all_users.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Getting_to_know_you_for_inking_and_typing_personalization.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_account_info.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_calendar.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_call_history.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_contacts.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_email.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_messaging.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_microphone.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_access_my_camera.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Let_apps_communicate_with_unpaired_devices_for_all_users.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Location_services.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Location_services_2.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Phone-PC_linking_with_Your_Phone_app_for_all_users.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Phone_calls.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Radios_calls.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_website_access_of_language_list.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_access_to_call_history_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_access_to_messaging_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_access_to_microphone_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_account_info_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_camera_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_Documents_library_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_email_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_Pictures_library_for_device.reg"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/WindowsPrivacy/Turn_OFF_Windows_and_apps_acecss_to_Videos_library_for_device.reg"
CALL "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Clear_location_last_accessed_history_for_current_user.bat"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Activity_history.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_app_launch_tracking.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Background_Apps.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Background_Apps_for_all_users.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Cloud_content_search_for_Microsoft_account.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Cloud_Search_for_all_users.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Getting_to_know_you_for_inking_and_typing_personalization.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_account_info.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_calendar.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_call_history.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_contacts.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_email.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_messaging.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_microphone.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_access_my_camera.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Let_apps_communicate_with_unpaired_devices_for_all_users.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Location_services.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Location_services_2.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Phone-PC_linking_with_Your_Phone_app_for_all_users.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Phone_calls.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Radios_calls.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_website_access_of_language_list.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_access_to_call_history_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_access_to_messaging_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_access_to_microphone_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_account_info_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_camera_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_Documents_library_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_email_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_Pictures_library_for_device.reg"
regedit /s "C:\Windows\TEMP\WindowsServerSecurity\Registry\WindowsPrivacy\Turn_OFF_Windows_and_apps_acecss_to_Videos_library_for_device.reg"

REM Disable NETBIOS for All NetworkAdapters
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\Windows "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Settings/NetBiosDisable.ps1"
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Windows\TEMP\WindowsServerSecurity\Windows\NetBiosDisable.ps1"

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
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsFeature WoW64-Support, FS-SMB1"

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
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO RDPPortNumber: "%RDPPortNumber%"
REM RDP SSL Settings
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEncryptRPCTraffic /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v SecurityLayer /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v UserAuthentication /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MinEncryptionLevel /t REG_DWORD /d 5 /f
REM -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"
net stop termservice /y
net start termservice /y
REM "C:\Service\System\curl\curl.exe" -O --output-dir C:\Users\Public\Desktop\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/WindowsFirewall_Enable.bat"

REM Copy Security Lnk
ECHO Copy Security Lnk
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\lnk\" MD "C:\Windows\TEMP\WindowsServerSecurity\lnk\"
IF NOT EXIST "C:\Service\Software\PowershellScripts\" MD "C:\Service\Software\PowershellScripts\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateHelperLnk.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateCmdLnk.vbs"
REM "C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Software\PowershellScripts\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/CreateBlock_RDP_Attack_Task.ps1"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Manual.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Auto.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelper.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelperUpdate.bat"
cscript /Nologo "C:\Windows\TEMP\WindowsServerSecurity\lnk\CreateHelperLnk.vbs"
cscript /Nologo "C:\Windows\TEMP\WindowsServerSecurity\lnk\CreateCmdLnk.vbs"

REM Get Windows Updates
ECHO Get Windows Updates
REM cscript /Nologo "C:\Service\WindowsUpdateInstall_Auto.vbs"

REM Global Windows Settings
ECHO Включение возможности RDP подключений
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
REM "C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\TEMP\WindowsServerSecurity\D4\ -o d4time531.msi "http://www.thinkman.com/dimension4/d4time531.msi"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\D4\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Soft/d4time531.msi"
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
timeout 5
tasklist /fi "ImageName eq Dimension4.exe" /fo csv 2>NUL | find /I "Dimension4.exe">NUL
if "%ERRORLEVEL%"=="0" (
echo Program is running
) else (
Start "" "C:\Program Files (x86)\D4\D4.exe"
)
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
)
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM Starter Windows
IF NOT EXIST "C:\Service\Software\StartWindows\" MD "C:\Service\Software\StartWindows\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Software\StartWindows\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/Starter.bat"
timeout 5
IF EXIST "C:\Service\Software\StartWindows\Starter.bat" (
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Starter" /t REG_SZ /d "C:\Service\Software\StartWindows\Starter.bat" /F
)

IF EXIST "C:\Program Files\simplewall\" GOTO PROGRAM_END
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM Simplewall
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\simplewall\" MD C:\Windows\TEMP\WindowsServerSecurity\simplewall\
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\simplewall\simplewall-setup.exe "https://github.com/henrypp/simplewall/releases/download/v.3.6.7/simplewall-3.6.7-setup.exe"
CALL C:\Windows\TEMP\WindowsServerSecurity\simplewall\simplewall-setup.exe /S /D=C:\Program Files\simplewall

IF EXIST "C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" GOTO PROGRAM_END
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM TSLab
IF NOT EXIST "C:\Service\TEMP\app\" MD "C:\Service\TEMP\app\"
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22Setup.exe "https://files.tslab.pro/installer/TSLab22Setup.exe"
timeout 5
ECHO Install TSLab22Setup
CALL C:\Service\TEMP\app\TSLab22Setup.exe /exenoui /quiet /qn
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\" MD "C:\Windows\TEMP\WindowsServerSecurity\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\TEMP\WindowsServerSecurity\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/TSLabAutoRun.bat"
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "RUNTSLAB" /t REG_SZ /d "C:\Windows\TEMP\WindowsServerSecurity\TSLabAutoRun.bat" /F

REM TaskSheduled History Enable
wevtutil set-log Microsoft-Windows-TaskScheduler/Operational /enabled:true

:PROGRAM_END
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
ECHO PROGRAM END
REM ==================================================================================================================================
RMDIR /S /Q "%USERPROFILE%\Desktop\PrepareService_1.1\"
RMDIR /S /Q "%USERPROFILE%\Desktop\PrepareService_1.2\"
RMDIR /S /Q "%USERPROFILE%\Desktop\PrepareService_1.3\"
RMDIR /S /Q "C:\Windows\TEMP\WindowsServerSecurity\"
DEL /Q "%USERPROFILE%\Desktop\PrepareService_1.1.zip"
DEL /Q "%USERPROFILE%\Desktop\PrepareService_1.2.zip"
DEL /Q "%USERPROFILE%\Desktop\PrepareService_1.3.zip"
ECHO NEEDED REBOOT SERVER - PRESS BUTTON FOR REBOOT AUTOMATICALY
PAUSE
shutdown /r /t 10 /c "The server will be shutdown in 10 seconds"
EXIT


REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
:NOTSUPPORTOS
CLS
TITLE NOT SUPPORT OPERATION SYSTEM
ECHO Данная Windows не поддерживается данная операционная система
ECHO.
ECHO WindowsProduct: "%WindowsProduct%"
PAUSE
EXIT