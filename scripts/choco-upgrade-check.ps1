#Requires -Version 3
[CmdletBinding()]
PARAM()

$chocoOutdated = choco outdated -r | select -skip 3
$outdatedCount = $chocoOutdated.Count

if($outdatedCount -eq 0 )
{
	Write-Host -ForegroundColor DarkGray "Everything up-to-date"
	EXIT 0
}
else
{
	Write-Host -ForegroundColor Green ("Updates available: {0}" -f $outdatedCount)
	if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
	{
		$chocoOutdated | %{ Write-Host -ForegroundColor Yellow ("- {0} v{1}" -f $_.Split('|')[0],  $_.Split('|')[2] ) }
	}
	EXIT $outdatedCount
}
