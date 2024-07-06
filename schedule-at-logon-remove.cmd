@echo off

:: Check for elevated privileges
net.exe session 1>nul 2>nul || (echo This script requires elevated rights. & pause & exit /b 1)

:: Remove scheduled task for starting Syncthing at logon
schtasks /delete /tn "Syncthing at Logon"