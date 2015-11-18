@ECHO OFF

SET BackupName=Att22 Daniela Win10 NTFS 1360GB
SET ReflectProfile=D:\Users\Dani\Documents\Reflect\%BackupName%.xml
SET TcVolumeLetter=S:
SET TcVolumePath=%TcVolumeLetter%\%BackupName%.tc
SET BackupTargetLetter=T
SET BackupTarget=%BackupTargetLetter%:
SET CECHO=POWERSHELL /noprofile /nologo Write-Host -ForegroundColor
SET TrueCrypt=%ProgramFiles%\TrueCrypt\TrueCrypt.exe
SET Reflect=%ProgramFiles%\Macrium\Reflect\Reflect.exe
SET RemoveDrive=%~dp0..\lib\removedrive.exe

TITLE Backstage - %BackupName%

:WaitForTcVolumePath
IF NOT EXIST "%TcVolumePath%" (
  %CECHO% Cyan * Plugin Harddisk, so "%TcVolumePath%" is available
  PAUSE
  GOTO WaitForTcVolumePath
)

IF NOT EXIST "%ReflectProfile%" (
  %CECHO% Red ERROR: Reflect profile does not exist
  EXIT /B 1
)

%CECHO% DarkGray Mounting TC volume...
"%TrueCrypt%" /volume "%TcVolumePath%" /letter %BackupTargetLetter% /history n /quit

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: TrueCrypt returned exit code %ERRORLEVEL%
  EXIT /B 2
)

%CECHO% DarkGray Cleaning up old backup...
IF EXIST "%BackupTarget%%BackupName%*.mrimg" ( DEL /F /Q "%BackupTarget%%BackupName%*.mrimg")

%CECHO% DarkGray Now wait for Backup to complete...
"%Reflect%" -e -w -full "%ReflectProfile%"

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: Reflect returned exit code %ERRORLEVEL%
  EXIT /B 3
)

ECHO.
%CECHO% Green Backup completed successfully!

%CECHO% DarkGray Unmounting TC volume...
"%TrueCrypt%" /dismount %BackupTargetLetter% /quit

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: TrueCrypt returned exit code %ERRORLEVEL%
  EXIT /B 4
)

%CECHO% DarkGray Unmounting drive %TcVolumeLetter%...
%RemoveDrive% %TcVolumeLetter% -l -b

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: RemoveDrive returned exit code %ERRORLEVEL%
  EXIT /B 5
)

%CECHO% Green Done, thanks!
PAUSE
