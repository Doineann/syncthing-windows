@echo off
:: Downloads the latest version of a specific repository's artifact on Github.
::
:: It will set the following variables as return values:
::
:: - ARTIFACT_TAGNAME   (version/tag name of the artifact)
:: - ARTIFACT_FILENAME  (filename of the artifact)
:: - ARTIFACT_URL       (full URL of the artifact)
::
:: Limitations:
::
:: - only downloads the latest version, not possible to specifiy a specific version (yet)
::

:: count number of arguments
set argCount=0
for %%x in (%*) do if not "%%~x"=="" set /a argCount+=1
if %argCount%==3 goto download-latest
goto usage

:download-latest
setlocal enabledelayedexpansion

set github_user=%~1
set github_repo=%~2
set target_name_search=%3

set github-latest-api-url=https://api.github.com/repos/%github_user%/%github_repo%/releases/latest

for /f "tokens=1,* delims=,: " %%A in ('curl -ks %github-latest-api-url% ^| findstr "tag_name"' ) do (
    for %%F in (%%B) do (
        set artifact-tagname=%%~nxF
    )
)

for /f "tokens=1,* delims=: " %%A in ('curl -ks %github-latest-api-url% ^| findstr "browser_download_url" ^| findstr "%target_name_search%"') do (
    set artifact-url=%%~B
    for %%F in (!artifact-url!) do (
        set artifact-filename=%%~nxF
    )
)

:: DEBUG (comment the above for-loops and uncomment the 3 lines below to simulate API calls instead of hitting rate limits on github's api servers)
::set artifact-tagname=v1.27.9 
::set artifact-filename=syncthing-windows-arm64-v1.27.9.zip
::set artifact-url=https://github.com/syncthing/syncthing/releases/download/v1.27.9/syncthing-windows-arm64-v1.27.9.zip 

endlocal & set ARTIFACT_TAGNAME=%artifact-tagname% & set ARTIFACT_FILENAME=%artifact-filename% & set ARTIFACT_URL=%artifact-url%
call :trim ARTIFACT_TAGNAME %ARTIFACT_TAGNAME%
call :trim ARTIFACT_FILENAME %ARTIFACT_FILENAME%
call :trim ARTIFACT_URL %ARTIFACT_URL%
::echo DEBUG INFO: "%ARTIFACT_TAGNAME%"
::echo DEBUG INFO: "%ARTIFACT_FILENAME%"
::echo DEBUG INFO: "%ARTIFACT_URL%"
if "%ARTIFACT_FILENAME%"=="" exit /b 2
exit /b 0

:trim
setlocal enabledelayedexpansion
for /f "tokens=1*" %%a in ("%*") do endlocal & set %1=%%b
goto :eof

:usage
echo.
echo Downloads the latest version of a specific repository's artifact on Github.
echo.
echo Usage: 
echo.
echo        %~n0 [github user] [github repo] [part of filename]
echo.
echo It will set the following variables as return values:
echo. 
echo - ARTIFACT_TAGNAME   (version/tag name of the artifact)
echo - ARTIFACT_FILENAME  (filename of the artifact)
echo - ARTIFACT_URL       (full URL of the artifact)
echo.
exit /b 1