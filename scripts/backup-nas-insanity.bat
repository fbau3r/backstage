@ECHO OFF

SET TrueCrypt=%ProgramFiles%\TrueCrypt\TrueCrypt.exe
SET TcVolumePath=S:\Att22 Insanity 3000GB.tc
SET BackupTargetLetter=T
SET BackupTarget=%BackupTargetLetter%:
SET BackupSource=Y:
SET CECHO=POWERSHELL /noprofile /nologo Write-Host -ForegroundColor

TITLE Backstage - Insanity

:WaitForTcVolumePath
IF NOT EXIST "%TcVolumePath%" (
	%CECHO% Cyan * Plugin Harddisk, so "%TcVolumePath%" is available
	PAUSE
	GOTO WaitForTcVolumePath
)

IF NOT EXIST "%BackupSource%" (
	%CECHO% Red ERROR: Backup Source does not exist
	EXIT /B 1
)

%CECHO% DarkGray Mounting TC volume...
"%TrueCrypt%" /volume "%TcVolumePath%" /letter %BackupTargetLetter% /history n /quit

%CECHO% DarkGray Now wait for Backup to complete...



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
%CECHO% Green Backup completed successfully!

%CECHO% DarkGray Unmounting TC volume...
"%TrueCrypt%" /dismount %BackupTargetLetter% /quit

IF %ERRORLEVEL% GTR 0 (
	%CECHO% Red ERROR: TrueCrypt returned exit code %ERRORLEVEL%
	EXIT /B 4
)

%CECHO% Green Done, thanks!
PAUSE
goto:eof



:runRobocopy

	ECHO.
	%CECHO% Yellow \"Start Backup of '%~1'...\"

	ROBOCOPY /MIR /B /FFT /R:3 /W:10 /Z /NP /NDL ^
		"%BackupSource%\%~1" "%BackupTarget%\%~1" ^
		/XF desktop.ini SyncToy_*.dat Thumbs.db *.tmp *.temp %~2 ^
		/XD .svn _svn .dthumb .Shared .trash .sync %~3

	IF %ERRORLEVEL% LSS 8 (
		%CECHO% Green Done
	) ELSE (
		%CECHO% Red ERROR: Robocopy returned exit code %~1
		%CECHO% DarkGray For details, see http://ss64.com/nt/robocopy-exit.html
		EXIT /B 1
	)

goto:eof
