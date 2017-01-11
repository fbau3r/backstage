@ECHO OFF

SET TrueCrypt=%ProgramFiles%\TrueCrypt\TrueCrypt.exe
SET TcVolumePath=S:\Att22.tc
SET BackupTargetLetter=T
SET BackupTarget=%BackupTargetLetter%:
SET BackupSource=Y:
SET ColorConsole=%~dp0..\lib\colorconsole.exe

TITLE Backstage - Insanity

:WaitForTcVolumePath
IF NOT EXIST "%TcVolumePath%" (
  %ColorConsole% {{Cyan}}* Plugin Harddisk, so "%TcVolumePath%" is available
  PAUSE
  GOTO WaitForTcVolumePath
)

IF NOT EXIST "%BackupSource%" (
  %ColorConsole% {{Red}}ERROR: Backup Source does not exist
  EXIT /B 1
)

%ColorConsole% {{DarkGray}}Mounting TC volume...
"%TrueCrypt%" /volume "%TcVolumePath%" /letter %BackupTargetLetter% /history n /quit

%ColorConsole% {{DarkGray}}Now wait for Backup to complete...



call:runRobocopy "Shared Data" "" "VirtualBox*"
call:runRobocopy "Software" "*.iso" "Development"
call:runRobocopy "Backup" "*.mrimg *.img *.tc *.backstage"
call:runRobocopy "Mobile"
call:runRobocopy "Shared Music"
call:runRobocopy "Shared Pictures"
call:runRobocopy "Shared Videos"
call:runRobocopy "Videothek\Filme-Kinder"
call:runRobocopy "Videothek\Serien-Kinder"
REM not included intentionally: uTorrent



ECHO.
%ColorConsole% {{Green}}Backup completed successfully!

%ColorConsole% {{DarkGray}}Unmounting TC volume...
"%TrueCrypt%" /dismount %BackupTargetLetter% /quit

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: TrueCrypt returned exit code %ERRORLEVEL%
  EXIT /B 4
)

%ColorConsole% {{Green}}Done, thanks!
goto:eof



:runRobocopy

  ECHO.
  %ColorConsole% {{Yellow}}\"Start Backup of '%~1'...\"

  ROBOCOPY /MIR /B /FFT /R:3 /W:10 /Z /NP /NDL ^
    "%BackupSource%\%~1" "%BackupTarget%\%~1" ^
    /XF desktop.ini SyncToy_*.dat Thumbs.db *.tmp *.temp %~2 ^
    /XD .svn _svn .dthumb .Shared .trash .sync %~3

  IF %ERRORLEVEL% LSS 8 (
    %ColorConsole% {{Green}}Done
  ) ELSE (
    %ColorConsole% {{Red}}ERROR: Robocopy returned exit code %~1
    %ColorConsole% {{DarkGray}}For details, see http://ss64.com/nt/robocopy-exit.html
    EXIT /B 1
  )

goto:eof
