<#
    .SYNOPSIS
    Build the module, then import it
#>
param (
  [switch] $GenerateMDX
)
Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop"

# -----------------------------------------------------------------------------
# Build Alt3 module, then import it using the latest version in .\Output
# -----------------------------------------------------------------------------
Build-Module -SourcePath ".\Source" -VersionedOutputDirectory

Write-Host "Removing loaded modules"
Remove-Module Alt3.Docusaurus.Powershell -Force -ErrorAction SilentlyContinue

$outputFolder = Join-Path -Path ".\Output" -ChildPath "Alt3.Docusaurus.Powershell"

$latestModuleVersion = (Get-ChildItem $outputFolder -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Host "Newly built module version = $latestModuleVersion"

$latestManifestPath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.Powershell.psd1
Write-Host "Newly built manifest path  = $latestManifestPath"

Import-Module $latestManifestPath -RequiredVersion $latestModuleVersion -Force -Verbose
