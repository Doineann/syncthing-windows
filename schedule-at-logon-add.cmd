@echo off

:: Check for elevated privileges
net.exe session 1>nul 2>nul || (
	echo This script requires elevated rights.
	pause
	exit /b 1
)

:: Parameters
set "BASEDIR=%~dp0"
set "SYNCTHING_TASK_NAME=Syncthing at Logon"
set "SYNCTHING_START_SCRIPT=%BASEDIR%start.cmd"
set "SYNCTHING_TASK_XML=%BASEDIR%syncthing-task-parameters.xml"

:: Sanity check if startup script exists
if not exist "%SYNCTHING_START_SCRIPT%" (
    echo ERROR: %SYNCTHING_START_SCRIPT% not found
    exit /b 1
)

:: Create temporary XML file for creating a task with specific parameters (UTF-16) ---
> "%SYNCTHING_TASK_XML%" (
    echo ^<?xml version="1.0" encoding="UTF-16"?^>
    echo ^<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>
    echo   ^<Triggers^>
    echo     ^<LogonTrigger /^>
    echo   ^</Triggers^>
    echo   ^<Principals^>
    echo     ^<Principal id="Users"^>
    echo       ^<GroupId^>S-1-5-32-545^</GroupId^>
    echo       ^<RunLevel^>HighestAvailable^</RunLevel^>
    echo     ^</Principal^>
    echo   ^</Principals^>
    echo   ^<Settings^>
    echo     ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^>
    echo     ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^>
    echo     ^<StartWhenAvailable^>true^</StartWhenAvailable^>
    echo     ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^>
    echo   ^</Settings^>
    echo   ^<Actions^>
    echo     ^<Exec^>
    echo       ^<Command^>"%SYNCTHING_START_SCRIPT%"^</Command^>
    echo     ^</Exec^>
    echo   ^</Actions^>
    echo ^</Task^>
)

:: Add scheduled task for starting Syncthing at logon
schtasks /create /tn "%SYNCTHING_TASK_NAME%" /xml "%SYNCTHING_TASK_XML%" /f

:: Check if task creation succeeded
if errorlevel 1 (
    echo.
	echo ERROR: Task creation failed!
    exit /b 1
)

:: Remove temporary XML file
del "%SYNCTHING_TASK_XML%"