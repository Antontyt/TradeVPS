@ECHO OFF
IF EXIST "%USERPROFILE%\Desktop\PrepareService_1.1\" RMDIR /S /Q "%USERPROFILE%\Desktop\PrepareService_1.1\"
IF EXIST "%USERPROFILE%\Desktop\PrepareService_1.2\" RMDIR /S /Q "%USERPROFILE%\Desktop\PrepareService_1.2\"
IF EXIST "%USERPROFILE%\Desktop\PrepareService_1.1.zip" DEL /Q "%USERPROFILE%\Desktop\PrepareService_1.1.zip"
IF EXIST "%USERPROFILE%\Desktop\PrepareService_1.2.zip" DEL /Q "%USERPROFILE%\Desktop\PrepareService_1.2.zip"
REM Disable WS-Management
ECHO Disable WS-Management (Windows Remote Management)
REM PowerShell -ExecutionPolicy ByPass -NoLogo -Command "Disable-PSRemoting -Force -ErrorAction SilentlyContinue"
net stop WinRM
sc config WinRM start= disabled
REM -----------------------------------------------------------------------------------------
ECHO Change Windows Settings
w32tm /unregister
net stop w32tm
sc config w32time start= disabled
ECHO Hyper-V Time Synchronization Service
sc stop vmictimesync
sc config "vmictimesync" start= disabled
net stop tzautoupdate
sc config tzautoupdate start= disabled
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /d "NoSync" /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v Start /t REG_DWORD /d 3 /F
REM -----------------------------------------------------------------------------------------
for /F "tokens=3 delims=: " %%H in ('sc query "Dimension4" ^| findstr "        STATE"') do (
  if /I "%%H" NEQ "RUNNING" (
   CLS
   COLOR 47
   ECHO Сервис "Dimension4" не запущен. Запускаем!
   TIMEOUT 5
   net start "Dimension4"
   Start "" "C:\Program Files (x86)\D4\D4.exe"
  )
)
REM -----------------------------------------------------------------------------------------
SETLOCAL EnableExtensions
set EXE=RestartOnCrash.exe
FOR /F %%x IN ("%EXE%") do set EXE_=%%x
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF NOT %%x == %EXE_% (
  CLS
  COLOR 47
  echo %EXE% is Not Running
  TIMEOUT 2
)
REM -----------------------------------------------------------------------------------------