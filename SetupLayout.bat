@echo off
chcp 866> nul
REM WindowsMenuLayout
ECHO WindowsMenuLayout
IF NOT EXIST "C:\Windows\Temp\Service\windows\" MD "C:\Windows\Temp\Service\windows\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\Temp\Service\windows\ -o StartLayout.xml "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/WindowsLayouts/ImportLayout.ps1"
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\Temp\Service\windows\ -o StartLayout.xml "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/WindowsLayouts/StartLayout.xml"
powershell.exe -noexit -file "C:\Windows\Temp\Service\windows\ImportLayout.ps1"
timeout 5
PAUSE
:END