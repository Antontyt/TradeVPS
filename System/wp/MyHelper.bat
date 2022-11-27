@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
REM =====================================================================================
ECHO VERSION 1.0.1 - 27.11.2022
ECHO.
ECHO 0. Get and install Windows Updates
ECHO 1. Disable SMB2 and SMB3 Protocol
ECHO 2. Enable SMB2 and SMB3 Protocol
ECHO.
ECHO ��� ����ত���� ������ ENTER
ECHO.

SET INPUT=
SET /P INPUT=��᫠ �� 0 �� 3 ��� �롮� ��� Q ��� ��室� �� �ணࠬ��:

IF /I '%INPUT%'=='0' (
GOTO WindowsUpdates
)
IF /I '%INPUT%'=='1' (
GOTO Disable_SMB2_SMB3
)
IF /I '%INPUT%'=='2' (
GOTO Enable_SMB2_SMB3
)
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

:Disable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false"
cls
ECHO Disable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:Enable_SMB2_SMB3
PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $true"
cls
ECHO Enable_SMB2_SMB3 DONE - PRESS ANY BUTTON FOR NEXT
PAUSE
GOTO STARTER

:QUIT
EXIT