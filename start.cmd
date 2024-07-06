@echo off

:: Start Syncthing
cd %~dp0
echo Starting syncthing...
cmd /c start /min "Running syncthing..." .\syncthing\syncthing.exe serve --no-console --no-browser --no-upgrade --no-default-folder --logfile=-