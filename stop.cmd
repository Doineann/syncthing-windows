@echo off

:: Stop Syncthing
cd %~dp0
echo Stopping syncthing...
.\syncthing\syncthing.exe cli operations shutdown