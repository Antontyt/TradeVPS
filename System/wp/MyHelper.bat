@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
REM =====================================================================================
ECHO 0. Get and install Windows Updates
ECHO.
ECHO ��� ����ত���� ������ ENTER
ECHO.

SET INPUT=
SET /P INPUT=��᫠ �� 0 �� 3 ��� �롮� ��� Q ��� ��室� �� �ணࠬ��:

IF /I '%INPUT%'=='0' (
GOTO WindowsUpdates
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
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
ECHO -----------------------------------------------------------------
ECHO �������� �롥�� ��ࠬ��� �� ᯨ᪠
ECHO ���� [0-4] ��� ������ 'Q' ��� ��室� �� �ணࠬ��.
ECHO -----------------------------------------------------------------
ECHO ================ ��������� ��࠭�� ��ࠬ��� =================
PAUSE > NUL
GOTO STARTER
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