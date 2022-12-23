#Antontyt 2020.23.12
#RDPBruteForce Powershell Script
$RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
$RDPPort=$RegBase.OpenSubKey('SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').GetValue('PortNumber')
write-host "$RDPPort"
# Сначала создадим на компьютере правило брандмауэра, которое блокирует входящее RDP подключение с определённых IP адресов:
# В дальнейшем в это правило мы будем добавлять IP адреса, с которых фиксируется попытки подбора паролей по RDP.
$RDPRule = Get-NetFirewallRule -DisplayName "Block RDP Attack" -erroraction 'silentlycontinue'
if ($RDPRule -eq $null) { New-NetFirewallRule -DisplayName "Block RDP Attack" -RemoteAddress 1.1.1.1 -Direction Inbound -Protocol TCP -LocalPort $RDPPort -Action Block }
$Last_n_Hours = [DateTime]::Now.AddHours(-2)
$log = "C:\Service\Logs\blocked_ip.txt"
$OSLang = (Get-WmiObject Win32_OperatingSystem).OSLanguage
switch ($OSLang) {
1049 { $badRDPlogons = Get-EventLog -LogName 'Security' -after $Last_n_Hours -InstanceId 4625 | ? { $_.Message -match 'Тип входа:\s+(3)\s' } | Select-Object @{n = 'IpAddress'; e = { $_.ReplacementStrings[-2] } } }
1033 { $badRDPlogons = Get-EventLog -LogName 'Security' -after $Last_n_Hours -InstanceId 4625 | ? { $_.Message -match 'logon type:\s+(3)\s' } | Select-Object @{n = 'IpAddress'; e = { $_.ReplacementStrings[-2] } } }
}
$getip = $badRDPlogons | group-object -property IpAddress | where { $_.Count -gt 10 } | Select -property Name
$current_ips = (Get-NetFirewallRule -DisplayName "Block RDP Attack" | Get-NetFirewallAddressFilter ).RemoteAddress -split (',')
#Проверка блокировался ли IP ранее
$ip = $getip | where {$getip.Name.Length -gt 1 -and !($current_ips -contains $getip.Name) }
$ip|%{
$current_ips += $ip.name
(Get-Date).ToString() + ' ' + $ip.name + ' IP заблокирован за  ' + ($badRDPlogons | where {$_.IpAddress -eq $ip.name}).count + ' попыток за 2 часа '>> $log # запись события блокировки IP адреса в лог файл
}
Set-NetFirewallRule -DisplayName "Block RDP Attack" -RemoteAddress $current_ips
(Get-Date).ToString() | Out-File -FilePath "C:\Service\Logs\blocked_ip_test.txt"