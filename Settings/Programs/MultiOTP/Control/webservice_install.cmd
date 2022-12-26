@ECHO OFF
REM VERSION 1.0
@setlocal enableextensions enabledelayedexpansion

REM Ports variables are not overwritten if already defined
IF "%_web_port%"=="" SET _web_port=8112
IF "%_web_ssl_port%"=="" SET _web_ssl_port=8113

REM Define the service tag and the service name
SET _service_tag=multiOTPservice
SET _service_name=multiOTP Web Service

REM Define the main file
SET _web_multiotp=multiotp.server.php
IF NOT "%_web_multiotp_alternate%"=="" SET _web_multiotp=%_web_multiotp_alternate%

REM Define the check file
SET _web_multiotp_class_check=check.multiotp.class.php
IF NOT "%_web_multiotp_class_check_alternate%"=="" SET _web_multiotp_class_check=%_web_multiotp_class_check_alternate%


REM Ports and service information can be overwritten if passing parameters
IF NOT "%1"=="" SET _web_port=%1
IF NOT "%2"=="" SET _web_ssl_port=%2
IF NOT "%3"=="" SET _service_tag=%3
IF NOT "%4"=="" SET _service_name=%4
IF NOT "%5"=="" SET _service_name=%_service_name% %5
IF NOT "%6"=="" SET _service_name=%_service_name% %6
IF NOT "%7"=="" SET _service_name=%_service_name% %7
IF NOT "%8"=="" SET _service_name=%_service_name% %8
IF NOT "%9"=="" SET _service_name=%_service_name% %9

IF "%_service_tag%"=="multiOTPserverTest" SET _no_web_display=1

REM Define the current folder
SET _folder=C:\ProgramData\MultiOTP\
SET _web_folder=C:\ProgramData\MultiOTP\

IF NOT EXIST %_web_folder%webservice SET _web_folder=%~d0%~p0..\

SET _root_folder=%_folder%
if "!_root_folder:~-1!"=="\" (
    set _root_folder=!_root_folder:~0,-1!
)

REM Stop and delete the service (if already existing)
SC stop %_service_tag% >NUL
SC delete %_service_tag% >NUL

SET _check_pattern=
IF "multiOTPserverTest"=="%_service_tag%" SET _check_pattern=location /check { root %_root_folder%; try_files $uri $uri/ /%_web_multiotp_class_check%$is_args$args; }
SET _check_pattern=location /check { root %_root_folder%; try_files $uri $uri/ /%_web_multiotp_class_check%$is_args$args; }

SET _config_file="%_web_folder%webservice\conf\sites-enabled\multiotp.conf"
IF NOT EXIST %_web_folder%webservice\conf MD %_web_folder%webservice\conf
IF NOT EXIST %_web_folder%webservice\conf\sites-enabled MD %_web_folder%webservice\conf\sites-enabled

ECHO server {> %_config_file%
ECHO     listen       %_web_port%;>> %_config_file%
ECHO     listen       %_web_ssl_port% ssl;>> %_config_file%
ECHO     server_name  localhost;>> %_config_file%
ECHO     ssl_certificate     ../certificates/certificate.crt;>> %_config_file%
ECHO     ssl_certificate_key ../certificates/certificate.key;>> %_config_file%
ECHO     # SSL v3 protocol removed due to the POODLE attack (CVE-2014-3566)>> %_config_file%
ECHO     ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;>> %_config_file%
ECHO     ssl_ciphers         TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA:TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA:TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDH-RSA-AES256-SHA384:ECDH-ECDSA-AES256-SHA384:ALL:!RC4:HIGH:!IDEA:!MD5:!aNULL:!eNULL:!EDH:!SSLv2:!ADH:!EXPORT40:!EXP:!LOW:!ADH:!AECDH:!DSS:@STRENGTH;>> %_config_file%
ECHO     ssl_prefer_server_ciphers on;>> %_config_file%
ECHO.>> %_config_file%
ECHO     root %_root_folder%;>> %_config_file%
ECHO     index %_web_multiotp%;>> %_config_file%
ECHO.>> %_config_file%
ECHO     gzip            on;>> %_config_file%
ECHO     gzip_comp_level 4;>> %_config_file%
ECHO     gzip_disable    msie6;>> %_config_file%
ECHO     gzip_min_length 1000;>> %_config_file%
ECHO     gzip_proxied    any;>> %_config_file%
ECHO     gzip_static     on;>> %_config_file%
ECHO     gzip_types      application/xml application/x-javascript text/css text/plain;>> %_config_file%
ECHO     gzip_vary       on;>> %_config_file%
ECHO.>> %_config_file%
ECHO     sendfile on;>> %_config_file%
ECHO     tcp_nopush on;>> %_config_file%
ECHO     tcp_nodelay on;>> %_config_file%
ECHO     keepalive_timeout 65;>> %_config_file%
ECHO     types_hash_max_size 2048;>> %_config_file%
ECHO.>> %_config_file%
ECHO     try_files $uri $uri/ /%_web_multiotp%;>> %_config_file%
ECHO.>> %_config_file%

IF NOT "%_check_pattern%"=="" ECHO %_check_pattern%>> %_config_file%
IF NOT "%_check_pattern%"=="" ECHO.>> %_config_file%

ECHO     location ~ /(config^|log^|users^|tokens^|devices^|groups^|radius^|webservice) {>> %_config_file%
ECHO         deny all;>> %_config_file%
ECHO         return 404;>> %_config_file%
ECHO     }>> %_config_file%
ECHO.>> %_config_file%
ECHO     location ~* \.(appcache^|manifest)$ {>> %_config_file%
ECHO         expires -1;>> %_config_file%
ECHO     }>> %_config_file%
ECHO.>> %_config_file%
ECHO     location ~ \.php$ {>> %_config_file%
ECHO         include fastcgi_params;>> %_config_file%
ECHO         try_files $uri /%_web_multiotp%;>> %_config_file%
ECHO         fastcgi_param HTTPS on;>> %_config_file%
ECHO         fastcgi_index %_web_multiotp%;>> %_config_file%
ECHO         fastcgi_split_path_info ^(.+\.php)(/.+)$;>> %_config_file%
ECHO         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;>> %_config_file%
ECHO         fastcgi_pass 127.0.0.1:9000;>> %_config_file%
ECHO         fastcgi_read_timeout 86400;>> %_config_file%
ECHO     }>> %_config_file%
ECHO.>> %_config_file%
ECHO     location / {>> %_config_file%
ECHO         try_files $uri $uri/ /%_web_multiotp%;>> %_config_file%
ECHO     }>> %_config_file%
ECHO }>> %_config_file%


REM Create the service
"%_web_folder%webservice\nssm" install "%_service_tag%" "%_web_folder%webservice\start-nginx-php.cmd" >NUL
"%_web_folder%webservice\nssm" set "%_service_tag%" Description "Runs the %_service_name% on ports %_web_port%/%_web_ssl_port%." >NUL
"%_web_folder%webservice\nssm" set "%_service_tag%" DisplayName "%_service_name%" >NUL

REM Basic firewall rules for the service
netsh firewall delete allowedprogram "%_web_folder%webservice\nginx.exe" >NUL
netsh firewall add allowedprogram "%_web_folder%webservice\nginx.exe" "%_service_tag%" ENABLE >NUL

REM Enhanced firewall rules for the service
netsh advfirewall firewall delete rule name="%_service_tag%" >NUL
netsh advfirewall firewall add rule name="%_service_tag%" dir=in action=allow program="%_web_folder%webservice\nginx.exe" enable=yes >NUL

REM Start the service
SC start %_service_tag% >NUL

REM Call the URL of the multiOTP web service
IF NOT "%_no_web_display%"=="1" START http://127.0.0.1:%_web_port%

REM Clean the environment variables
SET _check_pattern=
SET _config_file=
SET _folder=
SET _root_folder=
SET _service_tag=
SET _url_rewrite_patterns=
SET _web_folder=
SET _web_multiotp=
SET _web_multiotp_alternate=
SET _web_multiotp_class_check=
SET _web_multiotp_class_check_alternate=
SET _web_port=
SET _web_ssl_port=
