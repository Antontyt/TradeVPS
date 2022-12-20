@ECHO OFF
REM Reset rules for default settings
netsh advfirewall reset
TIMEOUT 2
netsh advfirewall set Domainprofile state on
netsh advfirewall set Privateprofile state on
netsh advfirewall set Publicprofile state on
REM Configure Windows Firewall
netsh advfirewall set Domainprofile firewallpolicy blockinbound,allowoutbound
netsh advfirewall set Privateprofile firewallpolicy blockinbound,allowoutbound
netsh advfirewall set Publicprofile firewallpolicy blockinbound,allowoutbound
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=No
netsh advfirewall firewall set rule group="Work or school account" new enable=No
netsh advfirewall firewall set rule group="Start" new enable=No
netsh advfirewall firewall set rule group="Your account" new enable=No
netsh advfirewall firewall set rule group="Cast to Device functionality" new enable=No
netsh advfirewall firewall set rule group="@{Microsoft.Windows.Search_1.15.0.20348_neutral_neutral_cw5n1h2txyewy?ms-resource://Microsoft.Windows.Search/resources/PackageDisplayName}" new enable=No
netsh advfirewall firewall set rule group="Desktop App Web Viewer" new enable=No
netsh advfirewall firewall set rule group="DIAL protocol server" new enable=No
netsh advfirewall firewall set rule group="Microsoft Media Foundation Network Source" new enable=No
netsh advfirewall firewall set rule group="DiagTrack" new enable=No
netsh advfirewall firewall set rule group="Windows Device Management" new enable=No
For /F tokens^=^3 %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber')DO SET "RDPPortNumber=%%i"
set /a RDPPortNumber=%RDPPortNumber%
ECHO Current RDP Port: "%RDPPortNumber%"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-TCP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol TCP -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "NewRDPPort-UDP-In" -Direction Inbound -LocalPort %RDPPortNumber% -Protocol UDP -Action Allow"