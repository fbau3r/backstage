@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Florian Win10 NTFS 250GB

call %~dp0_backup-machine.bat
