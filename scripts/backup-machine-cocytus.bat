@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Florian Win10
SET VcVolumeLetter=S:
SET VcVolumePath=%VcVolumeLetter%\Att22.vc
SET VcKeyPath=%USERPROFILE%\.vc\22tta.key

call %~dp0_backup-machine.bat
