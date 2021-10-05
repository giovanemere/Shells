: ----------------------------------------------------------------------------------------------------------------------
: File Name         : C:\Users\Administrator\Google Drive\Sterling\BP's\CD\CustomProtocol\SetupCustomProtocol.bat 
: Author            : Edisson Giovanni Zuñiga Lopez 
: Description       : Procedimiento de instalacion STERLING 
:                   : 16\05\2019 
: ----------------------------------------------------------------------------------------------------------------------

@echo off
title:  Modelamiento Sterling: Instalador Principal Ambiente Desarrollo AOS
: Menu Principal
:menu
cls
set "var=%var*=%"
echo   -----------------------------------------------------------------------------
echo   -   Comandos Sterling                                                 -
echo   -----------------------------------------------------------------------------
echo      1 - Crear Grupos
echo      2 - Crear Usuarios FTP sin Cifrado
echo      3 - Crear Usuarios FTP con Cifrado TLS/SSL Explicito
echo      4 - Crear Usuarios FTP con Cifrado TLS/SSL Implicito
echo      5 - Cambiar Password Usuarios
echo   -----------------------------------------------------------------------------
echo   -   Comandos Servidor                                                       -
echo   -----------------------------------------------------------------------------
echo      7 - Apagar Servidor
echo      8 - Configurar Tarjetas de Red
echo      9 - Reiniciar servidor
echo   -----------------------------------------------------------------------------
echo   -   
choice /n /c:123456789 /M "Choose an option (1-9) "
GOTO LABEL-%ERRORLEVEL%

:LABEL-1 GROUPS
echo   -----------------------------------------------------------------------------
echo   Siempre se debe ejecutar como administrador este menu
echo   -----------------------------------------------------------------------------

set /p ftps_usuarios=Digite el grupo a crear: 
net localgroup %ftps_usuarios% /add /COMMENT:"Members of this group can connect through %ftps_usuarios%"
set "var=%var*=%"
PAUSE
goto menu

:LABEL-2 FTP
echo   -----------------------------------------------------------------------------
echo   Siempre se debe ejecutar como administrador este menu
echo   -----------------------------------------------------------------------------
set GrupoFTP=ftps_usuarios
set /p ftpusuarios=Digite el usuario a crear: 
net user %ftpusuarios% /add *
net localgroup %GrupoFTP% %ftpusuarios% /add

:: FTP
::  Crear Directorio 
        mkdir C:\inetpub\ftproot\LocalUser\%ftpusuarios% 
set "var=%var*=%"
PAUSE
goto menu

:LABEL-3 FTPEXPLICIT
echo   -----------------------------------------------------------------------------
echo   Siempre se debe ejecutar como administrador este menu
echo   -----------------------------------------------------------------------------
set GrupoFTP=ftps_usuarios
set /p ftpusuarios=Digite el usuario a crear: 
net user %ftpusuarios% /add *
net localgroup %GrupoFTP% %ftpusuarios% /add

:: FTP
::  Crear Directorio 
set DirFTP=D:\ftps-explicit\LocalUser\
        mkdir %DirFTP%%ftpusuarios%

set "var=%var*=%"
PAUSE
goto menu

:LABEL-4 FTPIMPLICIT
echo   -----------------------------------------------------------------------------
echo   Siempre se debe ejecutar como administrador este menu
echo   -----------------------------------------------------------------------------
set GrupoFTP=ftps_usuarios
set /p ftpusuarios=Digite el usuario a crear: 
net user %ftpusuarios% /add *
net localgroup %GrupoFTP% %ftpusuarios% /add

:: FTP
::  Crear Directorio 
set DirFTP=D:\ftps-implicit\LocalUser\
        mkdir %DirFTP%%ftpusuarios%

set "var=%var*=%"
PAUSE
goto menu

:LABEL-5 PASSWORD
echo   -----------------------------------------------------------------------------
echo   Siempre se debe ejecutar como administrador este menu
echo   -----------------------------------------------------------------------------
set GrupoFTP=ftps_usuarios
set /p ftpusuarios=Digite el usuario a crear: 
net user %ftpusuarios%
PAUSE
goto menu

:LABEL-6 PING0
goto menu

:LABEL-7 shutdown
cls
set "var=%var*=%"
SETLOCAL
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set miip=%%b


shutdown -s -t 00
---------------------------------------------------------------------

echo Enter --: Para Salir
Pause>Nul
goto menu

:LABEL-8 NETWORK
cls
set "var=%var*=%"
REM Habilitar Network Publiuc para compartir carpetas con todos los servidores Windows
set VarPowerShell=%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
%VarPowerShell% Set-NetConnectionProfile -NetworkCategory Public
pause

REM HAbilitar Servicios carpetas compartidas
sc.exe config SSDPSRV start=auto
sc.exe config FDResPub start=auto
sc.exe config upnphost start=auto

REM Subir servicios carpetas compartidas
net start FDResPub
net start SSDPSRV
net start upnphost

REM Enable
set RuleFW=netsh advfirewall firewall set rule name=

%RuleFW%"File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (Echo Request - ICMPv6-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (LLMNR-UDP-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (NB-Datagram-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (NB-Name-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (NB-Session-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (SMB-In)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (Spooler Service - RPC)" new enable=Yes profile=any
%RuleFW%"File and Printer Sharing (Spooler Service - RPC-EPMAP)" new enable=Yes profile=any
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes

REM Disable
REM netsh advfirewall firewall set rule group="Network Discovery" new enable=No
---------------------------------------------------------------------

echo Enter --: Para Salir
Pause>Nul
goto menu

:LABEL-9 RESTART
cls
set "var=%var*=%"
SETLOCAL
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set miip=%%b


shutdown -r -s -t 00
---------------------------------------------------------------------

echo Enter --: Para Salir
Pause>Nul
goto menu
