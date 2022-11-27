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
REM "C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22Setup.exe "https://files.tslab.pro/installer/TSLab22Setup.exe"
REM timeout 5
REM ECHO Install TSLab22Setup
REM CALL C:\Service\TEMP\app\TSLab22Setup.exe /exenoui /quiet /qn
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Service\System\curl\curl.exe" -L --output-dir C:\Service\TEMP\app\ -o TSLab22BetaSetup.exe "https://files.tslab.pro/beta/TSLab22BetaSetup.exe"
timeout 5
ECHO Install TSLab22BetaSetup
CALL C:\Service\TEMP\app\TSLab22BetaSetup.exe /exenoui /quiet /qn
:END