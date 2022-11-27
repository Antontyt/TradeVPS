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