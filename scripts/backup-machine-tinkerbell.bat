@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=Att22 Daniela Win10 NTFS 1360GB
SET ReflectProfile=D:\Users\Dani\Documents\Reflect\%BackupName%.xml

call %~dp0_backup-machine.bat
