REM # Uninstall the OpenSSH Client
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0"
REM # Uninstall the OpenSSH Server
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"

REM Install OpenSSH
IF EXIST "C:\Program Files\OpenSSH" GOTO AFTEROpenSSHInstall
IF NOT EXIST "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\" MD "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\"
"C:\Service\System\curl\curl.exe" -L --output C:\Windows\Temp\WindowsServerSecurity\OpenSSH\OpenSSH-Win64-v9.1.0.0.msi "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.1.0.0p1-Beta/OpenSSH-Win64-v9.1.0.0.msi"
msiexec /i "C:\Windows\Temp\WindowsServerSecurity\OpenSSH\OpenSSH-Win64-v9.1.0.0.msi" /qn
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-Item -Type File -Path C:\ProgramData\ssh\administrators_authorized_keys"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH SSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Program 'C:\Windows\System32\OpenSSH\sshd.exe'"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String –Force"
"C:\Service\System\curl\curl.exe" -L --output C:\ProgramData\ssh\sshd_config "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/OpenSSH/sshd_config"
:AFTEROpenSSHInstall
ECHO AFTEROpenSSHInstall
IF NOT EXIST "C:\ProgramData\ssh\ssh_host_secret_ed25519_key" (
ECHO SSH KEY GENERATOR
ssh-keygen -t ed25519 -f C:\ProgramData\ssh\ssh_host_secret_ed25519_key
ssh-add "C:\ProgramData\ssh\ssh_host_secret_ed25519_key"
)
PAUSE