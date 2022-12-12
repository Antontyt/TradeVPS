$StartLayoutPath = "C:\Windows\TEMP\WindowsServerSecurity\Windows\StartLayout.xml"

Import-StartLayout -LayoutPath $StartLayoutPath -MountPath 'C:\'
New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows -Name Explorer -ErrorAction SilentlyContinue
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V LockedStartLayout /T REG_DWORD /D 1 /F
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V StartLayoutFile /T REG_EXPAND_SZ /D $StartLayoutPath /F
Stop-Process -ProcessName explorer
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer
