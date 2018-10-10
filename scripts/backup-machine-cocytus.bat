@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Florian Win10
SET VcVolumeLetter=S:
SET VcVolumePath=%VcVolumeLetter%\Att22.vc

call %~dp0_backup-machine.bat
