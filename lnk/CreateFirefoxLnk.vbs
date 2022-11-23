Set objShell = WScript.CreateObject("WScript.Shell")
Dim strUserProfile
strUserProfile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")

Set lnk = objShell.CreateShortcut(strUserProfile & "\Desktop\Firefox.LNK")

lnk.TargetPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
lnk.Arguments = "-private-window"
lnk.Description = "Firefox"
'lnk.HotKey = "ALT+CTRL+F"
lnk.IconLocation = "C:\Program Files\Mozilla Firefox\firefox.exe, 6"
lnk.WindowStyle = "1"
lnk.WorkingDirectory = "C:\Program Files\Mozilla Firefox"
lnk.Save
Set lnk = Nothing