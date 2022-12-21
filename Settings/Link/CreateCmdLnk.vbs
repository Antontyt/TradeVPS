Set objShell = WScript.CreateObject("WScript.Shell")
Dim strUserProfile
strUserProfile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")

Set lnk = objShell.CreateShortcut("C:\Users\Public\Desktop\CMD.LNK")


lnk.TargetPath = "C:\Windows\System32\cmd.exe"
lnk.Arguments = ""
lnk.Description = "cmd"
'lnk.HotKey = "ALT+CTRL+F"
lnk.IconLocation = "C:\Windows\System32\cmd.exe"
lnk.WindowStyle = "1"
lnk.WorkingDirectory = "C:\Windows\system32"
lnk.Save
Set lnk = Nothing