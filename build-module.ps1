<#
    .SYNOPSIS
    Use this script to rebuild and test the Alt3 module after making code changes.

    .NOTES
    Newly compiled module will be created in the `Output` folder.
#>
[cmdletbinding()]
param(
    [Parameter()]
    [switch]
    $Test,

    [Parameter(Mandatory = $False)]
    [string]
    $Path = ".",

    [Parameter(Mandatory = $False)]
    [ValidateSet("Diagnostic", "Detailed", "Normal", "Minimal", "None")]
    [string]
    $Output = "Normal",

    [Parameter()]
    [switch]
    $Coverage
)

# Build new Alt3 module
Write-Output "Building new module"
Build-Module -SourcePath .\Source -VersionedOutputDirectory

# Prevent duplicate module versions breaking PlatyPS
Remove-Module Alt3.Docusaurus.PowerShell -Force -ErrorAction SilentlyContinue

# Determine latest module version
$outputFolder = ".\Output\Alt3.Docusaurus.PowerShell"
$latestModuleVersion = (Get-ChildItem -Path $outputFolder -Directory | Sort-Object CreationTime | Select-Object -Last 1).Name
Write-Output "Importing new module $latestModuleVersion"

$latestManifestPath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.PowerShell.psd1
$latestModulePath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.PowerShell.psm1

# Import latest module version
Import-Module $latestManifestPath -Force -Global
Get-Module Alt3.Docusaurus.PowerShell

if (-not $Test) {
    return
}

# Still here, run pester
$configuration = [PesterConfiguration]::Default

$configuration.Run.Path = $Path
$configuration.Output.Verbosity = $Output
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = "TestResults.xml"
$configuration.TestResult.OutputFormat = "NUnitXml"

if ($Coverage) {
    $configuration.CodeCoverage.Enabled = $true
    $configuration.CodeCoverage.UseBreakpoints = $false # use new and faster profiler-based coverage
    $configuration.CodeCoverage.OutputFormat = 'JaCoCo'
    $configuration.CodeCoverage.Path = $latestModulePath
    $configuration.CodeCoverage.OutputPath = "CodeCoverageResults.xml"
    $configuration.CodeCoverage.CoveragePercentTarget = 80 # minimum threshold needed to pass

    $configuration.Run.PassThru = $true
}


Invoke-Pester -Configuration $configuration
