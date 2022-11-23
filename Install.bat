@ECHO OFF
ECHO Проверка версии операционной системы
For /F "Tokens=1,3* Delims=,:" %%A In ('WMIC OS GET Caption^,CSDVersion /FORMAT:CSV^|FindStr .^|More +1^|FindStr /n .') DO SET OS=%%B & SET SP=%%C
SET OS=%OS: =%
ECHO OS: "%OS%"
ECHO Username: "%username%"
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
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/Prepare2022Server.bat
CALL C:\Service\TEMP\Prepare2022Server.bat
PAUSE