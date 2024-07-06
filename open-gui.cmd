@echo off

:: Open Syncthing GUI
cd %~dp0
.\syncthing\syncthing.exe serve --browser-only