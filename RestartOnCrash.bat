@echo off
chcp 866> nul
REM RestartOnCrash-v1.6.4
ECHO RestartOnCrash-v1.6.4
IF EXIST "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe" GOTO END
IF NOT EXIST "C:\Windows\Temp\Service\RestartOnCrash\" MD C:\Windows\Temp\Service\RestartOnCrash\
TASKKILL /IM RestartOnCrash.exe /F /T
RMDIR /S /Q "C:\Service\Software\RestartOnCrash\"
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Windows\Temp\Service\RestartOnCrash\ -o RestartOnCrash.zip "https://w-shadow.com/files/RestartOnCrash-v1.6.4.zip"
timeout 5
"C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\Service\RestartOnCrash\RestartOnCrash.zip -oC:\Service\Software\RestartOnCrash\
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\Software\RestartOnCrash\ -o settings.ini "https://raw.githubusercontent.com/Antontyt/WindowsServerSecurity/main/Settings/Programs/RestartOnCrash/settings.ini"
START "" "C:\Service\Software\RestartOnCrash\RestartOnCrash.exe"
:END