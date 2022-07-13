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
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = "TestResults.xml"
$configuration.TestResult.OutputFormat = "NUnitXml"

$configuration.Output.Verbosity = 'Detailed'

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

return

#Invoke-Pester -Configuration $configuration | Export-CliXMl -Path "pester-object.xml"

#Invoke-Pester -Configuration $configuration | Export-CliXml "pester-object.xml"

#Invoke-Pester -Configuration $configuration | Set-Content -Path "missed.txt"
#Invoke-Pester -Configuration $configuration # | Convert-CodeCoverage -SourceRoot .\Source

# $res.CodeCoverage

# Write-Host "Next" -BackgroundColor Magenta
# $res.CodeCoverage.CommandsMissed



# Convert-LineNumber -SourceFile D:\vscodeprojects\Powershell\Alt3.Docusaurus.PowerShell\Output\Alt3.Docusaurus.PowerShell\1.0.30\Alt3.Docusaurus.PowerShell.psm1 -SourceLineNumber 1189

$res = Invoke-Pester -Configuration $configuration
$res.CodeCoverage.CommandsMissed #.FilesAnalyzed
#$res.CodeCoverage.CommandsMissed | Convert-LineNumber -ErrorAction 'Stop' -PassThru #| Out-Null

