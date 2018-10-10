@ECHO OFF

SET VeraCrypt=%ProgramFiles%\VeraCrypt\VeraCrypt.exe
SET VcVolumePath=S:\Att22.vc
SET VcKeyPath=%USERPROFILE%\.vc\22tta.key
SET BackupTargetLetter=T
SET BackupTarget=%BackupTargetLetter%:
SET BackupSource=Y:
SET ColorConsole=%~dp0..\lib\colorconsole.exe

TITLE Backstage - Insanity

:WaitForVcVolumePath
IF NOT EXIST "%VcVolumePath%" (
  %ColorConsole% {{Cyan}}* Plugin Harddisk, so "%VcVolumePath%" is available
  timeout /t 5 /nobreak > NUL
  GOTO WaitForVcVolumePath
)

IF NOT EXIST "%BackupSource%" (
  %ColorConsole% {{Red}}ERROR: Backup Source not found: '%BackupSource%'
  EXIT /B 1
)

%ColorConsole% {{DarkGray}}Mounting VC volume...
"%VeraCrypt%" /volume "%VcVolumePath%" /letter %BackupTargetLetter% /tryemptypass /history n /quit /keyfile %VcKeyPath% ^
	|| ( %ColorConsole% "{{Red}}ERROR: VeraCrypt returned exit code %ERRORLEVEL%" & EXIT /B 4 )

%ColorConsole% {{DarkGray}}Now wait for Backup to complete...



call:runRobocopy "Shared Data" "" "VirtualBox*" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Software" "*.iso" "Development" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Backup" "*.mrimg *.img *.tc *.vc *.backstage" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Mobile" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Shared Music" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Shared Pictures" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Shared Videos" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Videothek\Filme-Kinder" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
call:runRobocopy "Videothek\Serien-Kinder" ^
	|| ( call:unmountVolume "{{Red}}Backup failed!" & EXIT /B 5 )
REM not included intentionally: uTorrent



call:unmountVolume "{{Green}}Backup completed successfully!"

goto:eof



:unmountVolume

  %ColorConsole% {{DarkGray}}Unmounting VC volume...
  "%VeraCrypt%" /dismount %BackupTargetLetter% /quit ^
  	|| ( %ColorConsole% "{{Red}}ERROR: VeraCrypt returned exit code %ERRORLEVEL%" & EXIT /B 4 )

  %ColorConsole% {{DarkGray}}Unmount done

  ECHO.
  %ColorConsole% %~1

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
    %ColorConsole% {{Red}}ERROR: Robocopy for %~1 returned exit code %ERRORLEVEL%
    %ColorConsole% {{DarkGray}}For details, see http://ss64.com/nt/robocopy-exit.html
    EXIT /B 1
  )

goto:eof
