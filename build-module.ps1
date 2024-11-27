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
Build-Module -SourcePath $PSScriptRoot\Source -VersionedOutputDirectory

# Prevent duplicate module versions breaking PlatyPS
Remove-Module Alt3.Docusaurus.Powershell -Force -ErrorAction SilentlyContinue

# Determine latest module version
$outputFolder = "$PSScriptRoot\Output\Alt3.Docusaurus.Powershell"
$latestModuleVersion = (Get-ChildItem -Path $outputFolder -Directory | Sort-Object CreationTime | Select-Object -Last 1).Name
Write-Output "Importing newly built module $latestModuleVersion"

$latestManifestPath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.Powershell.psd1
$latestModulePath = Join-Path -Path $outputFolder -ChildPath $latestModuleVersion | Join-Path -ChildPath Alt3.Docusaurus.Powershell.psm1

# Import latest module version
Import-Module $latestManifestPath -Force -Global
Get-Module Alt3.Docusaurus.Powershell

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
Write-Output "`nGenerating command reference pages"

$docusaurusOptions = @{
    Module          = "Alt3.Docusaurus.Powershell"
    DocsFolder      = "./website/docs"
    SideBar         = "commands"
    EditUrl         = "https://github.com/alt3/Docusaurus.Powershell/edit/main/Source/Public/"
    Exclude         = @()
    MetaDescription = 'Help page for the Alt3.Docusaurus.Powershell "%1" command'
    MetaKeywords    = @(
        "Alt3"
        "PowerShell"
        "Modules"
        "Documentation"
        "Get-Help"
        "Docusaurus"
        "Website"
    )
    AppendMarkdown  = "## ADDITIONAL INFORMATION`nThis page was auto-generated using the comment based help in Alt3.Docusaurus.Powershell $($latestModuleVersion)."
}

Push-Location $PSScriptRoot
Write-Verbose "[i] Current directory = $(Get-Location)"

$outputFolder = Join-Path -Path $docusaurusOptions.DocsFolder -ChildPath $docusaurusOptions.Sidebar | Join-Path -ChildPath "*.*"
Write-Verbose "[i] Output folder = $outputFolder"

if (Test-Path -Path $outputFolder) {
    Write-Verbose "[+] Removing mdx files from existing output folder"
    Remove-Item -Path $outputFolder
}

Write-Verbose "[+] Generating new MDX files"
New-DocusaurusHelp @docusaurusOptions

Pop-Location
