Set objShell = WScript.CreateObject("WScript.Shell")
Dim strUserProfile
strUserProfile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")

Set lnk = objShell.CreateShortcut("C:\Users\Public\Desktop\OTPUsers.url")


lnk.TargetPath = "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
lnk.Arguments = "http://127.0.0.1:8112"
lnk.Description = "Firefox"
'lnk.HotKey = "ALT+CTRL+F"
lnk.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 244"
lnk.WindowStyle = "1"
lnk.WorkingDirectory = ""
lnk.Save
Set lnk = Nothing