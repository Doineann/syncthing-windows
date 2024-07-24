@echo off
cd %~dp0

:: Stop Syncthing
echo Stopping syncthing...
.\syncthing\syncthing.exe cli operations shutdown