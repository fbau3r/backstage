@ECHO OFF

SET BackupName=%~n0.ffs_batch
SET BackupPath=%~dpn0.ffs_batch
SET RevisionsDirectory=Y:\Mobile\Dani\_Revisions
SET ColorConsole=%~dp0..\lib\colorconsole.exe
SET FreeFileSync=%ProgramFiles%\FreeFileSync\FreeFileSync.exe

TITLE Backstage - %BackupName%

IF NOT EXIST "%BackupPath%" (
  %ColorConsole% {{Red}}* Cannot find %BackupPath%
  EXIT /B 1
)

TYPE "%BackupPath%" | FIND ">%RevisionsDirectory%</VersioningFolder>" > nul
IF %ERRORLEVEL% EQU 1 (
  %ColorConsole% {{Red}}* Cannot find config for Revisions directory
  EXIT /B 2
)

%ColorConsole% {{DarkGray}}Now wait for Backup to complete...

"%FreeFileSync%" "%BackupPath%"

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: FreeFileSync returned exit code %ERRORLEVEL%
  EXIT /B 3
)

ECHO.
%ColorConsole% {{Green}}Backup completed successfully!

FOR /F %%A IN ('DIR /B /S "%RevisionsDirectory%" ^| FIND /C /V ""') DO SET RevisionsCount=%%A
IF %RevisionsCount% GTR 0 (
  %ColorConsole% {{Cyan}}WARN: There are %RevisionsCount% files to be revised in folder
  %ColorConsole% {{Cyan}}WARN: %RevisionsDirectory%
)

%ColorConsole% {{Green}}Done, thanks!
PAUSE
