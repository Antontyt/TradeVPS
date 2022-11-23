@ECHO OFF
Set-NetFirewallProfile -All -Enabled True
Set-NetFirewallProfile –Name Public –DefaultInboundAction Block
Set-NetFirewallProfile –Name Public –DefaultInboundAction Block
Set-NetFirewallProfile –Name Public –DefaultInboundAction Block
Disable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
Disable-NetFirewallRule -Name FPS-ICMP6-ERQ-In
New-NetFirewallRule -DisplayName "AllowRDP" -Direction Inbound -Protocol TCP –LocalPort 3389 -Action Allow
New-NetFirewallRule -DisplayName "AllowRDP" -Direction Inbound -Protocol UDP –LocalPort 3389 -Action Allow