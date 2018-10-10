@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Daniela Win10
SET VcVolumeLetter=S:
SET VcVolumePath=%VcVolumeLetter%\Att22.vc
SET ReflectProfile=D:\Users\Dani\Documents\Reflect\%BackupName%.xml

call %~dp0_backup-machine.bat
