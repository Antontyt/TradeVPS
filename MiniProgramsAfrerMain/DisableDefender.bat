CLS
ECHO DISABLE DEFENDER
ECHO Пожалуйста подождите...
REM ================================================================================================================================
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SubmitSamplesConsent NeverSend"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -MAPSReporting Disable"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableArchiveScanning $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableAutoExclusions $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScanningNetworkFiles $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableScriptScanning $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisableIOAVProtection $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-MpPreference -DisablePrivacyMode $true"
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Remove-Item 'C:\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db'"