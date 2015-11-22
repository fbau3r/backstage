@ECHO OFF

SET BackupName=%~n0.ffs_batch
SET BackupPath=%~dpn0.ffs_batch
SET RevisionsDirectory=Y:\Mobile\Flo\_Revisions
SET CECHO=POWERSHELL /noprofile /nologo Write-Host -ForegroundColor
SET FreeFileSync=%ProgramFiles%\FreeFileSync\FreeFileSync.exe

TITLE Backstage - %BackupName%

IF NOT EXIST "%BackupPath%" (
  %CECHO% Red * Cannot find %BackupPath%
  EXIT /B 1
)

TYPE "%BackupPath%" | FIND ">%RevisionsDirectory%</VersioningFolder>" > nul
IF %ERRORLEVEL% EQU 1 (
  %CECHO% Red * Cannot find config for Revisions directory
  EXIT /B 2
)

%CECHO% DarkGray Now wait for Backup to complete...

"%FreeFileSync%" "%BackupPath%"

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: FreeFileSync returned exit code %ERRORLEVEL%
  EXIT /B 3
)

ECHO.
%CECHO% Green Backup completed successfully!

FOR /F %%A IN ('DIR /B /S "%RevisionsDirectory%" ^| FIND /C /V ""') DO SET RevisionsCount=%%A
IF %RevisionsCount% GTR 0 (
  %CECHO% Cyan WARN: There are %RevisionsCount% files to be revised in folder
  %CECHO% Cyan WARN: %RevisionsDirectory%
)

%CECHO% Green Done, thanks!
PAUSE
