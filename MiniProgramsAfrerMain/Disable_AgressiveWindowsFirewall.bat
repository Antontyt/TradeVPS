@ECHO OFF
REM TCP порт 135, предназначенный для выполнения команд;
netsh advfirewall firewall set rule name="Block1_TCP-135" new action=allow
REM UDP порт 137, с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall set rule name="Block1_TCP-137" new action=allow
netsh advfirewall firewall set rule name="Block1_TCP-138" new action=allow
REM TCP порт 139, необходимый для удаленного подключения и управления ПК;
netsh advfirewall firewall set rule name="Block_TCP-139" new action=allow
REM TCP порт 445, позволяющий быстро передавать файлы;
netsh advfirewall firewall set rule name="Block_TCP-445" new action=allow
netsh advfirewall firewall set rule name="Block_TCP-5000" new action=allow
sc stop lanmanserver
sc config lanmanserver start=disabled
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=no