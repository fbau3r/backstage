@ECHO OFF

SET DeviceName=Igelchen
SET BackupTarget=Y:\Mobile\Dani
SET BackupSource=E:
SET RobocopyBackupExcludeExtra=/XX
SET CECHO=POWERSHELL /noprofile /nologo Write-Host -ForegroundColor

TITLE Backstage - %DeviceName%

:WaitForDevicePath
IF NOT EXIST "%BackupSource%\backstage.inf" (
  %CECHO% Cyan * Plugin %DeviceName%, so %BackupSource%\backstage.inf is available
  PAUSE
  GOTO WaitForDevicePath
)

:WaitForSpecificDevicePath
TYPE "%BackupSource%\backstage.inf" | FIND "%DeviceName%" > nul
IF %ERRORLEVEL% EQU 1 (
  %CECHO% Cyan * Could not verify device %DeviceName%
  PAUSE
  GOTO WaitForSpecificDevicePath
)

IF NOT EXIST "%BackupTarget%" (
  %CECHO% Red ERROR: Backup Target does not exist: %BackupTarget%
  EXIT /B 1
)

%CECHO% DarkGray Now wait for Backup to complete...



call:runRobocopy "DCIM"
call:runRobocopy "Recording"
call:runRobocopy "WhatsApp" ".nomedia"



ECHO.
%CECHO% Green Backup completed successfully!

%CECHO% Green Done, thanks!
PAUSE
goto:eof



:runRobocopy

  ECHO.
  %CECHO% Yellow \"Start Backup of '%~1'...\"

  ROBOCOPY /MIR /B /FFT /R:3 /W:10 /Z /NP /NDL %RobocopyBackupExcludeExtra% ^
    "%BackupSource%\%~1" "%BackupTarget%\%~1" ^
    /XF desktop.ini SyncToy_*.dat Thumbs.db *.tmp *.temp %~2 ^
    /XD .svn _svn .dthumb .thumbnails .Shared .trash .sync %~3

  IF %ERRORLEVEL% LSS 8 (
    %CECHO% Green Done
  ) ELSE (
    %CECHO% Red ERROR: Robocopy returned exit code %~1
    %CECHO% DarkGray For details, see http://ss64.com/nt/robocopy-exit.html
    EXIT /B 1
  )

goto:eof
