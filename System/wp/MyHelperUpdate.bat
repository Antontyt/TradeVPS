@ECHO OFF
ECHO Prepare Configuration Tool
IF EXIST "C:\Service\TEMP\" RMDIR C:\Service\TEMP\ /S /Q
IF EXIST "C:\Service\UpdateSecurity.bat" DEL "C:\Service\UpdateSecurity.bat" /Q
IF EXIST "C:\Service\*.vbs" DEL "C:\Service\*.vbs" /Q
IF NOT EXIST "C:\Service\TEMP\reg\" MD C:\Service\TEMP\reg\
IF EXIST "C:\Service\System\curl\curl.exe" (
ECHO CURL OK
) ELSE (
ECHO CRITICAL ERROR: Не найден файл "C:\Service\System\curl\curl.exe"
PAUSE
EXIT
)
REM ===================================================================================================================================================================================
IF NOT EXIST "C:\Service\TEMP\lnk\" MD "C:\Service\TEMP\lnk\"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\lnk\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/lnk/CreateHelperLnk.vbs
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/System/wp/WindowsUpdateInstall_Manual.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/System/wp/WindowsUpdateInstall_Auto.vbs"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/System/wp/MyHelper.bat"
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/System/wp/MyHelperUpdate.bat"
cscript /Nologo "C:\Service\TEMP\lnk\CreateHelperLnk.vbs"
IF NOT EXIST "C:\Service\Test\" MD C:\Service\Test\
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\Test\ "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/TSLab22BetaSetup_silentInstall.bat"
REM ===================================================================================================================================================================================
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\TEMP\reg\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/RussiaLocale_ForNonUnicode.reg"
regedit /s "C:\Service\TEMP\reg\RussiaLocale_ForNonUnicode.reg"
REM ----------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -O --output-dir C:\Service\ "https://raw.githubusercontent.com/Antontyt/TradeVPS/main/System/wp/MyHelper.bat"
IF EXIST "C:\Service\MyHelper.bat" (
Start "" C:\Service\MyHelper.bat
) ELSE (
ECHO CRITICAL ERROR: Не найден файл MyHelper.bat
PAUSE
EXIT
)