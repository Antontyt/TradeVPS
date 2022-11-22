@ECHO OFF
REM ====================================================================================================================
REM DISABLE SMARTSCREEN 1.0 21.11.2022
REM ====================================================================================================================
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "Off" /F
PAUSE