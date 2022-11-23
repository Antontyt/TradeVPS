@ECHO OFF
ECHO Download DisableDefender
IF NOT EXIST "C:\Security\TEMP\" MD C:\Security\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/DisableDefender.bat
CALL C:\Security\TEMP\DisableDefender.bat
PAUSE
ECHO Download DisableSmartScreen
IF NOT EXIST "C:\Security\TEMP\" MD C:\Security\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/DisableSmartScreen.bat
CALL C:\Security\TEMP\DisableSmartScreen.bat
PAUSE
ECHO Download SearchDisable
IF NOT EXIST "C:\Security\TEMP\" MD C:\Security\TEMP\
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/reg/Hide_search_on_taskbar.bat
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/SearchDisable.bat
CALL C:\Security\TEMP\SearchDisable.bat
PAUSE
CALL C:\Security\TEMP\Hide_search_on_taskbar.bat
PAUSE
ECHO Download Prepare2022Server
"sys\curl\curl.exe" -O --output-dir C:\Security\TEMP\ https://raw.githubusercontent.com/Antontyt/TradeVPS/main/Prepare2022Server.bat
CALL C:\Security\TEMP\Prepare2022Server.bat
PAUSE