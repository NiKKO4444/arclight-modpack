@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0generar-manifest.ps1"
echo.
pause
