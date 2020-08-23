<#
    .SYNOPSIS
        Use this script to run Pester tests locally.
#>
[cmdletbinding()]
param(
    [switch]$Coverage
)

# build new Alt3 module
Write-Host "Pass the -Coverage switch for coverage report" -ForegroundColor Magenta
Write-Host "Building new module" -ForegroundColor Magenta
Build-Module -SourcePath .\Source -VersionedOutputDirectory

# prevent duplicate module versions breaking PlatyPS
Remove-Module Alt3.Docusaurus.Powershell -Force -ErrorAction SilentlyContinue

# determine latest module version
Write-Host "Importing new module" -ForegroundColor Magenta
$latestModuleVersion = (Get-ChildItem Output -Directory | Sort-Object CreationTime | Select-Object -Last 1).Name
$latestManifestPath = Join-Path -Path .\Output -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.Powershell.psd1
$latestModulePath =Join-Path -Path .\Output -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.Powershell.psm1

# import latest module version
Import-Module $latestManifestPath -Force -Global
Get-Module Alt3.Docusaurus.Powershell

# run pester
if (-Not($Coverage)) {
    Invoke-Pester
} else {
    Invoke-Pester -CodeCoverage $latestModulePath
}

