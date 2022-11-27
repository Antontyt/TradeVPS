@echo off
chcp 866> nul
:STARTER
REM =====================================================================================
ECHO 0. Get and install Windows Updates
ECHO.
ECHO Для подтверждения после ввода нажмите Enter
ECHO.

SET INPUT=
SET /P INPUT=Числа от 1 до 3 для выбора или Q для выхода из программы:

IF /I '%INPUT%'=='0' (
ECHO 0. Get and install Windows Updates
GOTO CONF04_Level1
)
REM IF /I '%INPUT%'=='2' (
REM ECHO Обслуживание действующего ресторана
REM GOTO CONF04_Level2
REM )
REM IF /I '%INPUT%'=='3' (
REM ECHO Обновления действующего ресторана Deployment \ Upgrades
REM GOTO CONF04_Level3
REM )
REM IF /I '%INPUT%'=='4' (
REM ECHO Действия со временем в ресторане
REM GOTO CONF04_Level4
REM )
IF /I '%INPUT%'=='Q' GOTO Quit
CLS
ECHO ================ Отсутствует выбранный параметр =================
ECHO -----------------------------------------------------------------
ECHO Пожалуйста выбрерите параметр из списка
ECHO Меню [0-4] или нажиме 'Q' для выхода из программы.
ECHO -----------------------------------------------------------------
ECHO ====== Нажимте любую кнопку для возврата в предыдущее меню ======
PAUSE > NUL
GOTO CONF04
PAUSE
REM =====================================================================================


:WindowsUpdates
REM Update Windows Defender
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -removedefinitions -dynamicsignatures
CALL "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

REM Get Windows Updates
cscript /Nologo "C:\Security\WindowsUpdateInstall_Auto.vbs"
ECHO WindowsUpdates END - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:QUIT
EXIT