@ECHO OFF

IF "%BackupName%"=="" (
    ECHO Error: Variable "BackupName" missing. Setup variable before calling %~nx0
    EXIT /B 101
)

REM SET Default values if not overridden
IF "%ReflectProfile%"==""     (SET ReflectProfile=%USERPROFILE%\Documents\Reflect\%BackupName%.xml)
IF "%TcVolumeLetter%"==""     (SET TcVolumeLetter=S:)
IF "%TcVolumePath%"==""       (SET TcVolumePath=%TcVolumeLetter%\%BackupName%.tc)
IF "%BackupTargetLetter%"=="" (SET BackupTargetLetter=T)
IF "%BackupTarget%"==""       (SET BackupTarget=%BackupTargetLetter%:)
IF "%TrueCrypt%"==""          (SET TrueCrypt=%ProgramFiles%\TrueCrypt\TrueCrypt.exe)
IF "%Reflect%"==""            (SET Reflect=%ProgramFiles%\Macrium\Reflect\Reflect.exe)
IF "%RemoveDrive%"==""        (SET RemoveDrive=%~dp0..\lib\removedrive.exe)
IF "%ColorConsole%"==""       (SET ColorConsole=%~dp0..\lib\colorconsole.exe)

IF NOT EXIST %ColorConsole% (
    ECHO Error: Cannot find ColorConsole at "%ColorConsole%"
    EXIT /B 201
)

TITLE Backstage - %BackupName%
%ColorConsole% {{Magenta}}Backstage - %BackupName%

:WaitForTcVolumePath
IF NOT EXIST "%TcVolumePath%" (
  %ColorConsole% {{Cyan}}* Plugin Harddisk, so "%TcVolumePath%" is available
  timeout /t 5 /nobreak > NUL
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
