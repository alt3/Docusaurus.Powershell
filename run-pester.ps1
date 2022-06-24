<#
    .SYNOPSIS
        Use this script to run Pester tests locally.
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory = $False)][ValidateSet("Diagnostic","Detailed","Normal","Minimal","None")][string]$Output = "Normal",
    [switch]$Coverage
)

# build new Alt3 module
Write-Output "Building new module"
Build-Module -SourcePath .\Source -VersionedOutputDirectory

# prevent duplicate module versions breaking PlatyPS
Remove-Module Alt3.Docusaurus.PowerShell -Force -ErrorAction SilentlyContinue

# determine latest module version
$outputFolder = ".\Output\Alt3.Docusaurus.PowerShell"
$latestModuleVersion = (Get-ChildItem -Path $outputFolder -Directory | Sort-Object CreationTime | Select-Object -Last 1).Name
Write-Output "Importing new module $latestModuleVersion"

$latestManifestPath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.PowerShell.psd1
$latestModulePath =Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.PowerShell.psm1

# import latest module version
Import-Module $latestManifestPath -Force -Global
Get-Module Alt3.Docusaurus.PowerShell

# run pester
if (-Not($Coverage)) {
    Invoke-Pester .\Tests\Unit\Private\GetCustomEditUrl.Tests.ps1 -Output $Output
} else {
    Invoke-Pester -CodeCoverage $latestModulePath
}

