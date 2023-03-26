@echo off
chcp 866> nul
REM TSLAB 2.2
ECHO TSLAB 2.2
IF EXIST "C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" GOTO END
IF EXIST "C:\Program Files\TSLab\TSLab 2.2 Beta\TSLab.exe" GOTO END
IF NOT EXIST "C:\Service\TEMP\app\" MD C:\Service\TEMP\app\
TASKKILL /IM TSLab22Setup.exe /F /T
TASKKILL /IM TSLab22BetaSetup.exe /F /T
TASKKILL /IM msiexec.exe /F /T
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22Setup.exe "https://files.tslab.pro/installer/TSLab22Setup.exe"
timeout 5
ECHO Install TSLab22Setup
CALL C:\Service\TEMP\app\TSLab22Setup.exe /exenoui /quiet /qn
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM "C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22BetaSetup.exe "https://files.tslab.pro/beta/TSLab22BetaSetup.exe"
REM timeout 5
REM ECHO Install TSLab22BetaSetup
REM CALL C:\Service\TEMP\app\TSLab22BetaSetup.exe /exenoui /quiet /qn
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM ADD RUN TSLAB
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /t REG_SZ /v "C:\Program Files\TSLab\TSLab 2.2 Beta\TSLab.exe" /d "RUNTSLAB"
:END