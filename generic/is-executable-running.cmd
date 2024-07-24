@echo off
:: Checks if executable is currently running.
::
:: Sets %errorlevel% to:
::
:: - 0 if the executable is running
:: - 1 if it is not running
:: - 2 on error
::

:: count number of arguments
set argCount=0
for %%x in (%*) do if not "%%~x"=="" set /a argCount+=1
if %argCount%==1 goto check-executable
goto usage

:check-executable
set executable=%~nx1
::echo DEBUG INFO: "%executable%"
tasklist /FI "IMAGENAME eq %executable%" 2>nul | find /I /N "%executable%">nul
if "%errorlevel%" == "0" exit /b 0
exit /b 1

:usage
echo.
echo Checks if executable is currently running.
echo.
echo Usage: 
echo.
echo        %~n0 [filename.exe]
echo.
echo Sets errorlevel to:
echo.
echo  0 if the executable is running
echo  1 if it is not running
echo  2 on error
echo.
exit /b 2