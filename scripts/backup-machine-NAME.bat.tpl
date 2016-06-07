@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=

call %~dp0_backup-machine.bat
