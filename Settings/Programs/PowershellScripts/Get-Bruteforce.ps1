function Get-Bruteforce {
 
    $Last = 4
    $Attempts = 10
 
    #Getting date -one hour (default)
    $DateTime = [DateTime]::Now.AddHours(-$Last)
 
    $BruteEvents = Get-EventLog -LogName 'Security' -InstanceId 4625 -After $DateTime -ErrorAction SilentlyContinue | Select-Object @{n='IpAddress';e={$_.ReplacementStrings[-2]} }
    $TopPunks = $BruteEvents | Group-Object -property IpAddress | Sort-Object Count
 
    #Get bruteforsers that tried to login greated or equal than 4 times (default)
    $GetPunks = $TopPunks | where {$_.Count -ge $attempts} | Select -property Name
 
    Write-host Unique attackers IP: $GetPunks.Length -ForegroundColor Green
    Write-Host Total bruteforce attempts: $BruteEvents.Length -ForegroundColor Green
 
    #Output-punks
    foreach ($i in $TopPunks | where {$_.Count -ge $attempts}) {
 
    $PunkRdns = (Resolve-DnsName $i.Name -ErrorVariable ProcessError -ErrorAction SilentlyContinue).NameHost 
 
    if ($ShowRDNS) {
        if ($PunkRdns) {
            Write-Host "attempts": $i.count IP: $PunkRdns
        }
        else {
            Write-Host "attempts": $i.count IP: $i.name
        }
    }
    else {
 
        Write-Host "attempts": $i.count IP: $i.name
 
    }
 
    }
   
}
Get-Bruteforce