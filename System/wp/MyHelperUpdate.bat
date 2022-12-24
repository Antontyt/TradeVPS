@ECHO OFF
ECHO Prepare Configuration Tool
IF EXIST "C:\Service\TEMP\" RMDIR C:\Service\TEMP\ /S /Q
IF EXIST "C:\Service\UpdateSecurity.bat" DEL "C:\Service\UpdateSecurity.bat" /Q
IF EXIST "C:\Service\*.vbs" DEL "C:\Service\*.vbs" /Q
IF NOT EXIST "C:\Windows\Temp\Registry\" MD C:\Windows\Temp\Registry\
IF NOT EXIST "C:\Service\Logs\" MD C:\Service\Logs\
IF EXIST "C:\Service\System\curl\curl.exe" (
ECHO CURL OK
) ELSE (
ECHO CRITICAL ERROR: Не найден файл "C:\Service\System\curl\curl.exe"
PAUSE
EXIT
)
REM ===================================================================================================================================================================================
IF NOT EXIST "C:\Service\TEMP\lnk\" MD "C:\Service\TEMP\lnk\"
IF NOT EXIST "C:\Service\Software\PowershellScripts\" MD "C:\Service\Software\PowershellScripts\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Link/CreateHelperLnk.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Manual.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/WindowsUpdateInstall_Auto.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelper.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelperUpdate.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Software\PowershellScripts\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/PowershellScripts/Get-Badname.ps1"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Software\PowershellScripts\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/PowershellScripts/Get-Bruteforce.ps1"
cscript /Nologo "C:\Service\TEMP\lnk\CreateHelperLnk.vbs"
IF NOT EXIST "C:\Service\Test\" MD C:\Service\Test\
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/PowerhsellRDPButforceBlocker.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/RDPDefenderInstall.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/ServiceLogonMultiFactor.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/TSLab22BetaSetup_silentInstall.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/TSLab22Setup_silentInstall.bat"
REM "C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/MiniProgramsAfrerMain/DisableDefender.bat"
REM ===================================================================================================================================================================================
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Windows\Temp\Registry\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Windows/Registry/RussiaLocale_ForNonUnicode.reg"
regedit /s "C:\Windows\Temp\Registry\RussiaLocale_ForNonUnicode.reg"
REM ----------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -OLC --output C:\Service\MyHelper.bat "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/MyHelper.bat"
IF EXIST "C:\Service\MyHelper.bat" (
Start "" C:\Service\MyHelper.bat
) ELSE (
ECHO CRITICAL ERROR: Не найден файл MyHelper.bat
PAUSE
EXIT
)