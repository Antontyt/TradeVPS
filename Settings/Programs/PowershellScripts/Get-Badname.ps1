function Get-Badname {
 
    $Last = 24
    $Attempts = 40
 
   
    $DateTime = [DateTime]::Now.AddHours(-$Last)
 
    $BruteEvents = Get-EventLog -LogName 'Security' -InstanceId 4625 -After $DateTime -ErrorAction SilentlyContinue | Select-Object @{n='IpAddress';e={$_.ReplacementStrings[5]} }
    $TopPunks = $BruteEvents | Group-Object -property IpAddress | Sort-Object Count
 
   
    $GetPunks = $TopPunks | where {$_.Count -ge $attempts} | Select -property Name
 
    Write-host Unique attackers IP: $GetPunks.Length -ForegroundColor Green
    Write-Host Total bruteforce attempts: $BruteEvents.Length -ForegroundColor Green
 
    #Output
    foreach ($i in $TopPunks | where {$_.Count -ge $attempts}) {
 
        Write-Host "Attempts": $i.count Username: $i.name
 
    }
   
}
Get-Badname