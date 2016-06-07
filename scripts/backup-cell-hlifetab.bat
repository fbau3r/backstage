@ECHO OFF
SETLOCAL

REM Override variable values here
SET BackupName=%~n0.ffs_batch
SET BackupPath=%~dpn0.ffs_batch
SET RevisionsDirectory=%USERPROFILE%\Pictures\_Mobil\Lifetab\_Revisions

call %~dp0_backup-cell.bat
