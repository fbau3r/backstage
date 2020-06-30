@ECHO OFF

REM Change working directory to script's directory
CD  "%~dp0"

"%PROGRAMFILES%\Git\bin\bash.exe" -c "./backup-storage.sh"

PAUSE
