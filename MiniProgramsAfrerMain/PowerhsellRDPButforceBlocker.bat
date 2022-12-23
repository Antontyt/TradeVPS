IF NOT EXIST "C:\Windows\TEMP\WindowsServerSecurity\RDPButforceBlocker\" MD C:\Windows\TEMP\WindowsServerSecurity\RDPButforceBlocker\
IF NOT EXIST "C:\Service\Logs\" MD "C:\Service\Logs\"
"C:\Service\System\curl\curl.exe" -O --output-dir "C:\Service\Software\PowershellScripts\" "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/PowershellScripts/Block_RDP_Attack.ps1"
"C:\Service\System\curl\curl.exe" -O --output-dir "C:\Windows\TEMP\WindowsServerSecurity\RDPButforceBlocker\" "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/System/wp/CreateBlock_RDP_Attack_Task.ps1"
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Windows\TEMP\WindowsServerSecurity\RDPButforceBlocker\CreateBlock_RDP_Attack_Task.ps1"