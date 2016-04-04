@ECHO OFF

SET ChocoUpgradeCheck=POWERSHELL -noprofile -nologo -file %~dp0choco-upgrade-check.ps1
SET ChocoUpgrade=POWERSHELL -noprofile -nologo -command Start-Process choco 'upgrade all -y' -Verb RunAs -Wait
SET ColorConsole=%~dp0..\lib\colorconsole.exe

TITLE Backstage - Chocolatey Upgrade

set delay=10
ECHO Waiting %delay%s to check for upgrades...
ping localhost -n %delay%  >nul 2>&1

%ChocoUpgradeCheck%

IF %ERRORLEVEL% EQU 0 (
  EXIT /B 0
)

%ColorConsole% {{Cyan}}Press ENTER to install Upgrades, or CTRL+C to abort
PAUSE

%ChocoUpgrade%

IF %ERRORLEVEL% GTR 0 (
  %ColorConsole% {{Red}}ERROR: Upgrade returned exit code %ERRORLEVEL%
  EXIT /B 1
)

%ColorConsole% {{Green}}Done, thanks!
PAUSE
