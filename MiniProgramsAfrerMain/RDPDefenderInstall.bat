IF EXIST "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\" RMDIR /S /Q "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\"
IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\" MD "C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\"
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\Setup-RDPDefender.exe "https://github.com/Antontyt/WindowsServerSecurity/raw/main/Settings/Programs/RDPDefender/Setup-RDPDefender.exe"
"C:\Windows\TEMP\WindowsServerSecurity\RDPDefender\Setup-RDPDefender.exe" /VERYSILENT