@echo off
cd %~dp0

:: Find latest version of syncthing
echo Finding latest version...
call github-find-latest-artifact.cmd syncthing syncthing "syncthing-windows-amd64"
if %errorlevel% NEQ 0 call :fail-with-errormessage "Unable to find latest version of Syncthing!"
goto found

:found
echo - found: %ARTIFACT_TAGNAME%
set /p current-version=<syncthing\version.txt
call :trim current-version %current-version%
if "%current-version%" NEQ "%ARTIFACT_TAGNAME%" goto update
echo.
echo Latest version already installed !
echo.
exit /b 0

:update
echo Removing old version...
if exist syncthing rmdir /s /q syncthing
echo Downloading %ARTIFACT_URL%...
curl -kOL %ARTIFACT_URL%
echo Extracting...
mkdir syncthing
tar -xf %ARTIFACT_FILENAME% -C syncthing --strip-components=1
echo %ARTIFACT_TAGNAME% >syncthing\version.txt
if exist %ARTIFACT_FILENAME% del /f /q %ARTIFACT_FILENAME%
echo.
echo Updated to %ARTIFACT_TAGNAME% ! 
echo.
exit /b 0

:fail-with-errormessage
echo.
echo ERROR: %~1
echo.
exit /b 1

:trim
setlocal enabledelayedexpansion
for /f "tokens=1*" %%a in ("%*") do endlocal & set %1=%%b
goto :eof