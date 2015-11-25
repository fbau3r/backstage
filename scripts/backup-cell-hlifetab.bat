@ECHO OFF

SET DeviceName=hlifetab
SET BackupTarget=%USERPROFILE%\Pictures\_Mobil\Lifetab
SET BackupSource=E:
SET RobocopyBackupExcludeExtra=/XX
SET ColorConsole=%~dp0..\lib\colorconsole.exe

TITLE Backstage - %DeviceName%

:WaitForDevicePath
IF NOT EXIST "%BackupSource%\backstage.inf" (
  %ColorConsole% {{Cyan}}* Plugin %DeviceName%, so %BackupSource%\backstage.inf is available
  PAUSE
  GOTO WaitForDevicePath
)

:WaitForSpecificDevicePath
TYPE "%BackupSource%\backstage.inf" | FIND "%DeviceName%" > nul
IF %ERRORLEVEL% EQU 1 (
  %ColorConsole% {{Cyan}}* Could not verify device %DeviceName%
  PAUSE
  GOTO WaitForSpecificDevicePath
)

IF NOT EXIST "%BackupTarget%" (
  %ColorConsole% {{Red}}ERROR: Backup Target does not exist: %BackupTarget%
  EXIT /B 1
)

%ColorConsole% {{DarkGray}}Now wait for Backup to complete...



call:runRobocopy "DCIM"



ECHO.
%ColorConsole% {{Green}}Backup completed successfully!

%ColorConsole% {{Green}}Done, thanks!
PAUSE
goto:eof



:runRobocopy

  call:runRobocopyMirror %~1 %~2 %~3 %RobocopyBackupExcludeExtra%

goto:eof



:runRobocopyMirror

  ECHO.
  %ColorConsole% {{Yellow}}\"Start Backup of '%~1'...\"

  ROBOCOPY /MIR /B /FFT /R:3 /W:10 /Z /NP /NDL %~4 ^
    "%BackupSource%\%~1" "%BackupTarget%\%~1" ^
    /XF desktop.ini SyncToy_*.dat Thumbs.db *.tmp *.temp %~2 ^
    /XD .svn _svn .dthumb .thumbnails .Shared .trash .sync %~3

  IF %ERRORLEVEL% LSS 8 (
    %ColorConsole% {{Green}}Done
  ) ELSE (
    %ColorConsole% {{Red}}ERROR: Robocopy returned exit code %~1
    %ColorConsole% {{DarkGray}}For details, see http://ss64.com/nt/robocopy-exit.html
    EXIT /B 1
  )

goto:eof
