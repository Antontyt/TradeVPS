@ECHO OFF
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallProfile -All -Enabled True"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-NetFirewallProfile -All -DefaultInboundAction Block"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetFirewallRule -Name FPS-ICMP4-ERQ-In"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-NetFirewallRule -Name FPS-ICMP6-ERQ-In"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "AllowRDP TCP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -DisplayName "AllowRDP UDP" -Direction Inbound -Protocol UDP -LocalPort 3389 -Action Allow"
PAUSE