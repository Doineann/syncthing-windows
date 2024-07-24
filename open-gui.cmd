@echo off
cd %~dp0

:: Open Syncthing GUI
echo Opening syncthing GUI...
.\syncthing\syncthing.exe serve --browser-only