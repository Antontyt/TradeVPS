@ECHO OFF
TASKKILL /IM Firefox.exe /F
TASKKILL /IM notepad++.exe /F
IF EXIST "C:\Program Files\TSLab\TSLab 2.2\TSLab.exe" (
"C:\Program Files\TSLab\TSLab 2.2\TSLab.exe"
)
IF EXIST "C:\Program Files\TSLab\TSLab 2.2 Beta\TSLab.exe" (
"C:\Program Files\TSLab\TSLab 2.2 Beta\TSLab.exe"
)