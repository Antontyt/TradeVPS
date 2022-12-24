    $taskname="Block RDP Attack"
	$PSScriptFolder="C:\Service\Software\PowershellScripts"
    $taskname="Block RDP Attack"
    # delete existing task if it exists
    Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue |  Unregister-ScheduledTask -Confirm:$false
    # get target script based on current script root
    $scriptPath=[System.IO.Path]::Combine($PSScriptFolder, "Block_RDP_Attack.ps1")
    # create list of triggers, and add logon trigger
    $triggers = @()
    #$triggers += New-ScheduledTaskTrigger -AtLogOn

    # create TaskEventTrigger, use your own value in Subscription
    $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
    $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
    $trigger.Subscription = 
@"
<QueryList><Query Id="0" Path="Security"><Select Path="Security">*[System[(EventID=4625)]]</Select></Query></QueryList>
"@
    $trigger.Enabled = $True 
    $triggers += $trigger

    # create task
    $User='Nt Authority\System'
    $Action=New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-ExecutionPolicy bypass -File $scriptPath"
    Register-ScheduledTask -TaskName $taskname -Trigger $triggers -User $User -Action $Action -RunLevel Highest -Force