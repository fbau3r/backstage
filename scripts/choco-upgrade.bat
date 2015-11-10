@ECHO OFF

SET ChocoUpgradeCheck=POWERSHELL -noprofile -nologo -file %~dp0choco-upgrade-check.ps1
SET ChocoUpgrade=POWERSHELL -noprofile -nologo -command Start-Process choco 'upgrade all' -Verb RunAs -Wait
SET CECHO=POWERSHELL /noprofile /nologo Write-Host -ForegroundColor

TITLE Backstage - Chocolatey Upgrade

%ChocoUpgradeCheck%

IF %ERRORLEVEL% EQU 0 (
  EXIT /B 0
)

%CECHO% Cyan Press ENTER to install Upgrades, or CTRL+C to abort
PAUSE

%ChocoUpgrade%

IF %ERRORLEVEL% GTR 0 (
  %CECHO% Red ERROR: Upgrade returned exit code %ERRORLEVEL%
  EXIT /B 1
)

%CECHO% Green Done, thanks!
PAUSE
