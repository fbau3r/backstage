@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Daniela Win10
SET TcVolumeLetter=S:
SET TcVolumePath=%TcVolumeLetter%\Att22.tc
SET ReflectProfile=D:\Users\Dani\Documents\Reflect\%BackupName%.xml

call %~dp0_backup-machine.bat
