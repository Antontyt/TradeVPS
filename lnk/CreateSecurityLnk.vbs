Set objShell = WScript.CreateObject("WScript.Shell")
Dim strUserProfile
strUserProfile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")

Set lnk = objShell.CreateShortcut("C:\Users\Public\Desktop\UpdateSecurity.LNK")


lnk.TargetPath = "C:\Service\UpdateSecurity.bat"
lnk.Arguments = ""
lnk.Description = "Firefox"
'lnk.HotKey = "ALT+CTRL+F"
lnk.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 6"
lnk.WindowStyle = "1"
lnk.WorkingDirectory = "C:\Service"
lnk.Save
Set lnk = Nothing