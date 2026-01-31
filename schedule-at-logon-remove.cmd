@echo off

:: Check for elevated privileges
net.exe session 1>nul 2>nul || (
	echo This script requires elevated rights.
	pause
	exit /b 1
)

:: Parameters
set "SYNCTHING_TASK_NAME=Syncthing at Logon"

:: Check if task exists
schtasks /query /tn "%SYNCTHING_TASK_NAME%" >nul 2>&1
if errorlevel 1 (
    echo Task "%SYNCTHING_TASK_NAME%" not found. Nothing to uninstall.
    exit /b 0
)

:: Remove scheduled task for starting Syncthing at logon
schtasks /delete /tn "%SYNCTHING_TASK_NAME%" /f
if errorlevel 1 (
    echo ERROR: failed to delete task "%SYNCTHING_TASK_NAME%"
    exit /b 1
)
