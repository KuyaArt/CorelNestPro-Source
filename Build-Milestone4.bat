@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Build-Milestone4.ps1"
if errorlevel 1 (
  echo.
  echo BUILD GAGAL. Salin seluruh pesan error untuk diperiksa.
  pause
  exit /b 1
)
echo.
echo BUILD SELESAI. Periksa folder artifacts.
pause
