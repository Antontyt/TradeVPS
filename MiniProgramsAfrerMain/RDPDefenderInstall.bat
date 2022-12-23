IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\" MD C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\
"C:\Service\System\curl\curl.exe" -O --output-dir "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\" "https://github.com/Antontyt/WindowsServerSecurity/raw/main/Settings/Programs/RDPDefender/Setup-RDPDefender.exe"
"C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\Setup-RDPDefender.exe" /VERYSILENT
PAUSE