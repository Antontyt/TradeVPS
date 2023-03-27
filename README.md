# WindowsServerSecurity
Скрипт настройки Windows Server по безопасности \ Script for setup first security on Windows Server

Выполняемые действия:
> 1. Переименование учётной записи адмнистратора
> 2. Смена RDP порта вместо стандартного на ваш. Для подключения после нужно указывать IP_вашего_сервера:Ваш_порт
> 3. Отключается родной Windows Defender
> 4. Отключается сервис поиска по системе (для минимизации расхода ресурсов)
> 5. Отключается телеметрия Windows
> 6. Отключаются адмнские расшаренные ресурсы
> 7. Удаляется MS EDGE
> 8. Отключается удалённый реестр
> 9. Отключается Cortana
> 10. Отключается серис дефрагементации дисков
> 11. Отключается автозапуск любых носителей
> 12. По умолчанию отключены SMB1,2,3 протоколы. Можно включить через ярлык MyHelper
> 13. Отключен сервис Windows Remote Management
> 14. Отключены автоматические обновления Windows и автоматические перезагрузки (Используйте ярлык MyHelper)
> 15. Удалены компоненты WoW64-Support, FS-SMB1 Protocols
> 16. Отключен ICMP Ping
> 17. Устанавливается Mozilla ESR
> 18. Устанавливается Notepad++
> 19. Устанавливается обновления NET Framework 4.8
> 20. Устанавливается русская локализация (Согласно требованиям для TSLab)
> 21. Производится настройка Windows Firewall (Отключается ответ на PING\Разрешаются RDP порты)
> 22. Устанавливается NTP Service (Для синхронизации времени\Поумолчанию регион настроек Россия)
> 23. Устанавливается программа RestartOnCrash для перезапуска программ после критического сбоя. (Программы нужно добавлять отдельно)
> 24. Добавляется иконка на рабочий стол для установки обновлений и работы с небольшими настройками системы
> 25. Добавлены скрипты проверки Get-Badname и Get-Bruteforce (Доступны через ярлык MyHelper)
> 26. Настройка Windows Defender Firewall на OutBlock и InBlock (Возможность отключить OutBlock)
> 27. Блокировка подбора паролей при подключении по RDP (Powershell + Задание в планировщике)
> 28. Настройка параметров безопасности GPO: Computer Configuration\Policies\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Security:
    + Require secure RPC communication = Enabled
    + Require use of specific security layer for remote (RDP) connections = SSL
    + Require user authentication for remote connections by using Network Level Authentication = Enabled
    + Set client connection encryption level = High
> 29. Добавлена возможность автоматической настройки OTP Login (Только для удалённых подключений RDP).

Для запуска сервиса настройки:
> Cкопируйте пакет PrepareService_1.3.zip на рабочий стол. 
> Распакуйте файлы в любую папку и запустите файл Prepare.bat
> Следуйте указанием программы
> Также в Wiki есть инструкция с картинками.

Тестирование произоводилось на операционных системах:
> Windows 2022 Server
> Windows 2019 Server

Используются оригинальные программы с официальных сайтов

==========================================================

Бат файлы по установке из папки MiniProgramsAfrerMain можно запускать после установки основного пакета
