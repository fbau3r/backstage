#Requires -Version 3
[CmdletBinding()]
PARAM()

$host.ui.rawui.windowtitle = 'Backstage - Chocolatey Upgrade'
Write-Host -ForegroundColor DarkGray "Checking for upgrades..."

$chocoOutdated = choco outdated -r | select -skip 3 | where { $_ -contains '|' }
$outdatedCount = $chocoOutdated.Count

if($outdatedCount -eq 0 )
{
	Write-Host -ForegroundColor DarkGray "Everything up-to-date"
	EXIT 0
}
else
{
	Write-Host -ForegroundColor Green ("Updates available: {0}" -f $outdatedCount)
	$chocoOutdated | sort-object | %{ Write-Host -ForegroundColor Yellow ("- {0} from {1} to {2}" -f $_.Split('|')[0],  $_.Split('|')[1],  $_.Split('|')[2] ) }
	EXIT $outdatedCount
}