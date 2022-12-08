@echo off
chcp 866> nul
REM RestartOnCrash-v1.6.4
ECHO RestartOnCrash-v1.6.4
IF NOT EXIST "C:\Windows\Temp\Service\windows\" MD "C:\Windows\Temp\Service\windows\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o RestartOnCrash.zip "https://w-shadow.com/files/RestartOnCrash-v1.6.4.zip"
timeout 5
PAUSE
:END