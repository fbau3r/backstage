@ECHO OFF

SET BackupName=Att22 Daniela Win10 NTFS 1360GB
SET ReflectProfile=D:\Users\Dani\Documents\Reflect\%BackupName%.xml
SET TcVolumeLetter=S:
SET TcVolumePath=%TcVolumeLetter%\%BackupName%.tc
SET BackupTargetLetter=T
SET BackupTarget=%BackupTargetLetter%:
SET ColorConsole=%~dp0..\lib\colorconsole.exe
SET TrueCrypt=%ProgramFiles%\TrueCrypt\TrueCrypt.exe
SET Reflect=%ProgramFiles%\Macrium\Reflect\Reflect.exe
SET RemoveDrive=%~dp0..\lib\removedrive.exe

TITLE Backstage - %BackupName%

:WaitForTcVolumePath
IF NOT EXIST "%TcVolumePath%" (
  %ColorConsole% {{Cyan}}* Plugin Harddisk, so "%TcVolumePath%" is available
  PAUSE
  GOTO WaitForTcVolumePath
)

IF NOT EXIST "%ReflectProfile%" (
  %ColorConsole% {{Red}}ERROR: Reflect profile does not exist
  EXIT /B 1
)

%ColorConsole% {{DarkGray}}Mounting TC volume...
"%TrueCrypt%" /volume "%TcVolumePath%" /letter %BackupTargetLetter% /history n /quit

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: TrueCrypt returned exit code %ERRORLEVEL%
  EXIT /B 2
)

%ColorConsole% {{DarkGray}}Cleaning up old backup...
IF EXIST "%BackupTarget%%BackupName%*.mrimg" ( DEL /F /Q "%BackupTarget%%BackupName%*.mrimg")

%ColorConsole% {{DarkGray}}Now wait for Backup to complete...
"%Reflect%" -e -w -full "%ReflectProfile%"

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: Reflect returned exit code %ERRORLEVEL%
  EXIT /B 3
)

ECHO.
%ColorConsole% {{Green}}Backup completed successfully!

%ColorConsole% {{DarkGray}}Unmounting TC volume...
"%TrueCrypt%" /dismount %BackupTargetLetter% /quit

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: TrueCrypt returned exit code %ERRORLEVEL%
  EXIT /B 4
)

%ColorConsole% {{DarkGray}}Unmounting drive %TcVolumeLetter%...
%RemoveDrive% %TcVolumeLetter% -l -b

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: RemoveDrive returned exit code %ERRORLEVEL%
  EXIT /B 5
)

%ColorConsole% {{Green}}Done, thanks!
PAUSE
