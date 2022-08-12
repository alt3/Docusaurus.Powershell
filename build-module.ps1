<#
    .SYNOPSIS
    Use this script to rebuild and test the Alt3 module after making code changes.

    .NOTES
    Newly compiled module and Pester results will be created in the `Output` folder.

    .PARAMETER Test
    Runs Pester tests against a freshly built Alt3-module.

    .PARAMETER Path
    Limit Pester tests by specifiying path to specific test(s).

    .PARAMETER Coverage
    Runs Pester code coverage.

    .PARAMETER GenerateDocs
    Generates the Docusaurus files used by the Alt3 command reference website pages.
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
    $Coverage,

    [Parameter()]
    [switch]
    $GenerateDocs,

    [Parameter()]
    [switch]
    $PassThru
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

# Pester tests and code coverage
if ($Test) {
    if (-not(Get-Module Pester)) {
        throw "Required module 'Pester' is not loaded. Run 'Import-Module -Name Pester' first."
    }

    $configuration = [PesterConfiguration]::Default

    $configuration.Run.Path = $Path
    $configuration.Output.Verbosity = $Output
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputPath = Join-Path -Path "Output" -ChildPath "Pester" | Join-Path -ChildPath "TestResults.xml"
    $configuration.TestResult.OutputFormat = "NUnitXml"

    if ($Coverage) {
        $configuration.CodeCoverage.Enabled = $true
        $configuration.CodeCoverage.Path = $latestModulePath
        $configuration.CodeCoverage.UseBreakpoints = $false # use new and faster profiler-based coverage
        $configuration.CodeCoverage.OutputPath = Join-Path -Path "Output" -ChildPath "Pester" | Join-Path -ChildPath "CodeCoverageResults.xml"
        $configuration.CodeCoverage.OutputFormat = 'JaCoCo'

        $configuration.CodeCoverage.CoveragePercentTarget = 80 # minimum threshold needed to pass
    }

    if ($PassThru) {
        $configuration.Run.PassThru = $true
    }

    Invoke-Pester -Configuration $configuration

    Write-Output "Test files created in $(Join-Path -Path "Output" -ChildPath "Pester")"
}

if (-not $GenerateDocs) {
    return
}

# Generate mdx files used for the Alt3 website
Write-Output "Generating command reference pages" -ForegroundColor Magenta

$docusaurusOptions = @{
    Module          = "Alt3.Docusaurus.Powershell"
    DocsFolder      = "./website/docs"
    SideBar         = "commands"
    EditUrl         = "https://github.com/alt3/Docusaurus.PowerShell/edit/main/Source/Public/"
    Exclude         = @()
    MetaDescription = 'Help page for the Alt3.Docusaurus.PowerShell "%1" command'
    MetaKeywords    = @(
        "Alt3"
        "PowerShell"
        "Modules"
        "Documentation"
        "Get-Help"
        "Docusaurus"
        "Website"
    )
    AppendMarkdown  = "## ADDITIONAL INFORMATION`nThis page was auto-generated using the comment based help in Alt3.Docusaurus.PowerShell $($latestModuleVersion)."
}

Push-Location $PSScriptRoot
Write-Output "[i] Current directory = $(Get-Location)" -ForegroundColor DarkGreen

$outputFolder = Join-Path -Path $docusaurusOptions.DocsFolder -ChildPath $docusaurusOptions.Sidebar | Join-Path -ChildPath "*.*"
Write-Output "[i] Output folder = $outputFolder" -ForegroundColor DarkGreen

if (Test-Path -Path $outputFolder) {
    Write-Output "[+] Removing mdx files from existing output folder" -ForegroundColor DarkGreen
    Remove-Item -Path $outputFolder
}

Write-Output "[+] Generating new MDX files" -ForegroundColor DarkGreen
New-DocusaurusHelp @docusaurusOptions

Pop-Location
