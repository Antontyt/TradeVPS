@ECHO OFF
ECHO Download DisableDefender
IF NOT EXIST "C:\Service\TEMP\" MD C:\Service\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/DisableDefender.bat
CALL C:\Service\TEMP\DisableDefender.bat
PAUSE
ECHO Download DisableSmartScreen
IF NOT EXIST "C:\Service\TEMP\" MD C:\Service\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/DisableSmartScreen.bat
CALL C:\Service\TEMP\DisableSmartScreen.bat
PAUSE
ECHO Download SearchDisable
IF NOT EXIST "C:\Service\TEMP\" MD C:\Service\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Hide_search_on_taskbar.bat
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/SearchDisable.bat
CALL C:\Service\TEMP\SearchDisable.bat
PAUSE
CALL C:\Service\TEMP\Hide_search_on_taskbar.bat
PAUSE
ECHO Download Prepare2022Server
"sys\curl\curl.exe" -O --output-dir C:\Service\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/Prepare2022Server.bat
CALL C:\Service\TEMP\Prepare2022Server.bat
PAUSE