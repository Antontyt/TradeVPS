@echo off
chcp 866> nul
:STARTER
TITLE MyHelper Service
REM =====================================================================================
ECHO 0. Get and install Windows Updates
ECHO.
ECHO „«ï ¯®¤â¢à¦¤¥­¨ï ­ ¦¬¨â¥ ENTER
ECHO.

SET INPUT=
SET /P INPUT=—¨á«  ®â 0 ¤® 3 ¤«ï ¢ë¡®à  ¨«¨ Q ¤«ï ¢ëå®¤  ¨§ ¯à®£à ¬¬ë:

IF /I '%INPUT%'=='0' (
GOTO WindowsUpdates
)
REM IF /I '%INPUT%'=='2' (
REM ECHO ÐžÐ±ÑÐ»ÑƒÐ¶Ð¸Ð²Ð°Ð½Ð¸Ðµ Ð´ÐµÐ¹ÑÑ‚Ð²ÑƒÑŽÑ‰ÐµÐ³Ð¾ Ñ€ÐµÑÑ‚Ð¾Ñ€Ð°Ð½Ð°
REM GOTO CONF04_Level2
REM )
REM IF /I '%INPUT%'=='3' (
REM ECHO ÐžÐ±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ Ð´ÐµÐ¹ÑÑ‚Ð²ÑƒÑŽÑ‰ÐµÐ³Ð¾ Ñ€ÐµÑÑ‚Ð¾Ñ€Ð°Ð½Ð° Deployment \ Upgrades
REM GOTO CONF04_Level3
REM )
REM IF /I '%INPUT%'=='4' (
REM ECHO Ð”ÐµÐ¹ÑÑ‚Ð²Ð¸Ñ ÑÐ¾ Ð²Ñ€ÐµÐ¼ÐµÐ½ÐµÐ¼ Ð² Ñ€ÐµÑÑ‚Ð¾Ñ€Ð°Ð½Ðµ
REM GOTO CONF04_Level4
REM )
IF /I '%INPUT%'=='Q' GOTO Quit
CLS
ECHO ================ Žâáãâáâ¢ã¥â ¢ë¡à ­­ë© ¯ à ¬¥âà =================
ECHO -----------------------------------------------------------------
ECHO ®¦ «ã©áâ  ¢ë¡¥à¨â¥ ¯ à ¬¥âà ¨§ á¯¨áª 
ECHO Œ¥­î [0-4] ¨«¨ ­ ¦¬¨â¥ 'Q' ¤«ï ¢ëå®¤  ¨§ ¯à®£à ¬¬ë.
ECHO -----------------------------------------------------------------
ECHO ================ Žâáãâáâ¢ã¥â ¢ë¡à ­­ë© ¯ à ¬¥âà =================
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