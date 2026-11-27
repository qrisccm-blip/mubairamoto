@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "build-cars.ps1"
echo.
echo Done. Open index.html, or press Ctrl+F5 if it is already open.
pause
