@echo off
chcp 866> nul
REM RestartOnCrash-v1.6.4
ECHO RestartOnCrash-v1.6.4
REM IF EXIST "C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" GOTO END
REM IF EXIST "C:\Program Files\TSLab\TSLab 2.2 Beta\TSLab.exe" GOTO END
IF NOT EXIST "C:\Service\TEMP\app\" MD C:\Service\TEMP\app\
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o RestartOnCrash.zip "https://w-shadow.com/files/RestartOnCrash-v1.6.4.zip"
timeout 5
PAUSE
:END