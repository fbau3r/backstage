@ECHO OFF

IF "%BackupName%"=="" (
    ECHO Error: Variable "BackupName" missing. Setup variable before calling %~nx0
    EXIT /B 101
)

IF "%BackupPath%"=="" (
    ECHO Error: Variable "BackupPath" missing. Setup variable before calling %~nx0
    EXIT /B 102
)

IF "%RevisionsDirectory%"=="" (
    ECHO Error: Variable "RevisionsDirectory" missing. Setup variable before calling %~nx0
    EXIT /B 103
)

REM SET Default values if not overridden
IF "%FreeFileSync%"==""       (SET FreeFileSync=%ProgramFiles%\FreeFileSync\FreeFileSync.exe)
IF "%ColorConsole%"==""       (SET ColorConsole=%~dp0..\lib\colorconsole.exe)

IF NOT EXIST %ColorConsole% (
    ECHO Error: Cannot find ColorConsole at "%ColorConsole%"
    EXIT /B 201
)

TITLE Backstage - %BackupName%
%ColorConsole% {{Magenta}}Backstage - %BackupName%

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
