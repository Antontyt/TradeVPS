@ECHO OFF
REM TCP порт 135, предназначенный для выполнения команд;
netsh advfirewall firewall set rule name="Block1_TCP-135" new action=block
REM UDP порт 137, с помощью которого проводится быстрый поиск на ПК.
netsh advfirewall firewall set rule name="Block1_TCP-137" new action=block
netsh advfirewall firewall set rule name="Block1_TCP-138" new action=block
REM TCP порт 139, необходимый для удаленного подключения и управления ПК;
netsh advfirewall firewall set rule name="Block_TCP-139" new action=block
REM TCP порт 445, позволяющий быстро передавать файлы;
netsh advfirewall firewall set rule name="Block_TCP-445" new action=block
netsh advfirewall firewall set rule name="Block_TCP-5000" new action=block
sc stop lanmanserver
sc config lanmanserver start=disabled
REM =========================================================================
netsh advfirewall firewall set rule name="Core Networking - Destination Unreachable (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Done (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Query (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Multicast Listener Report v2 (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Neighbor Discovery Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Packet Too Big (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Parameter Problem (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Advertisement (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Router Solicitation (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Time Exceeded (ICMPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - IPv6 (IPv6-In)" new enable=no
netsh advfirewall firewall set rule name="Core Networking - Dynamic Host Configuration Protocol for IPv6(DHCPV6-In)" new enable=no
netsh advfirewall firewall set rule name="File and Printer Sharing (SMB-Out)" new action=block enable=yes