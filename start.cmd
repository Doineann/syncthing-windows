@echo off
cd %~dp0

:: Start Syncthing
echo Starting syncthing...
cmd /c start /min "Running syncthing..." .\syncthing\syncthing.exe serve --no-console --no-browser --no-upgrade --no-default-folder --logfile=-