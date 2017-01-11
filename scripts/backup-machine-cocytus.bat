@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Florian Win10
SET TcVolumeLetter=S:
SET TcVolumePath=%TcVolumeLetter%\Att22.tc

call %~dp0_backup-machine.bat
